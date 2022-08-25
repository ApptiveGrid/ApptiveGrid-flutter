part of 'package:apptive_grid_form/src/widgets/form_widget/user_form_widget.dart';

class _UserDropdownButtonFormField extends StatefulWidget {
  const _UserDropdownButtonFormField({
    required this.component,
    required this.onSelected,
  });

  final FormComponent<UserDataEntity> component;

  final void Function(DataUser? user) onSelected;

  @override
  _UserDropdownButtonFormFieldState createState() =>
      _UserDropdownButtonFormFieldState();
}

class _UserDropdownButtonFormFieldState
    extends State<_UserDropdownButtonFormField>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _filterController = TextEditingController();

  final _overlayKey = GlobalKey();

  void closeOverlay() {
    if (_overlayKey.currentContext != null) {
      Navigator.pop(_overlayKey.currentContext!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DropdownButtonFormField<DataUser>(
      key: _overlayKey,
      isExpanded: true,
      items: _items(),
      menuMaxHeight: MediaQuery.of(context).size.height * 0.95,
      onChanged: (_) {}, // coverage:ignore-line
      onTap: () {
        _filterController.text = '';
      },
      validator: (user) {
        if (widget.component.required && (user == null)) {
          return ApptiveGridLocalization.of(context)!
              .fieldIsRequired(widget.component.property);
        } else {
          return null;
        }
      },
      selectedItemBuilder: _selectedItems,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      value: widget.component.data.value,
      decoration: widget.component.baseDecoration,
    );
  }

  List<DropdownMenuItem<DataUser>>? _items() {
    final localization = ApptiveGridLocalization.of(context)!;
    final searchBox = DropdownMenuItem<DataUser>(
      enabled: false,
      value: null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: _filterController,
          decoration: InputDecoration(
            icon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _filterController.clear();
              },
            ),
            hintText: localization.crossRefSearch,
          ),
        ),
      ),
    );

    final list = DropdownMenuItem<DataUser>(
      value: widget.component.data.value ??
          DataUser(displayValue: 'displayValue', uri: Uri()),
      enabled: false,
      child: _UserMenuSelectionList(
        controller: _filterController,
        link: widget.component.field.links[ApptiveLinkType.collaborators],
        selectedUser: widget.component.data.value,
        onSelected: (user) {
          closeOverlay();
          widget.onSelected(user);
        },
        translation: ApptiveGridLocalization.of(context),
      ),
    );
    return [searchBox, list];
  }

  List<Widget> _selectedItems(BuildContext context) {
    final localization = ApptiveGridLocalization.of(context)!;

    final pleaseSelect = Text(localization.selectEntry);
    return [
      ...[pleaseSelect],
      if (widget.component.data.value != null)
        DataUserWidget(user: widget.component.data.value!)
    ];
  }
}

class _UserMenuSelectionList extends StatefulWidget {
  const _UserMenuSelectionList({
    required this.controller,
    required this.link,
    required this.onSelected,
    required this.selectedUser,
    required this.translation,
  });

  final TextEditingController controller;
  final ApptiveLink? link;
  final Function(DataUser? user) onSelected;
  final DataUser? selectedUser;
  final ApptiveGridTranslation? translation;

  @override
  State<_UserMenuSelectionList> createState() => _UserMenuSelectionListState();
}

class _UserMenuSelectionListState extends State<_UserMenuSelectionList> {
  late ApptiveGridClient _client;
  List<DataUser>? _users;
  dynamic _error;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_searchUsers);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _client = ApptiveGrid.getClient(context);
    if (_users == null) {
      _searchUsers();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_searchUsers);
    super.dispose();
  }

  Future<void> _searchUsers() async {
    setState(() {
      _error = null;
    });
    if (widget.link != null) {
      final query = widget.controller.text;
      final users = await _client
          .performApptiveLink<List<DataUser>>(
        link: widget.link!,
        queryParameters: {
          if (query.isNotEmpty) 'matching': query,
        },
        parseResponse: (response) async {
          final jsonList = jsonDecode(response.body) as List<dynamic>;
          return jsonList.map((json) => DataUser.fromJson(json)).toList();
        },
      )
          .catchError((error) {
        setState(() {
          _error = error;
          _users = null;
        });
      });
      setState(() {
        _users = users;
      });
    } else {
      setState(() {
        _users = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_error != null) {
      return Text(
        _error!.toString(),
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.error,
        ),
      );
    }
    if (_users == null) {
      return const LinearProgressIndicator();
    }
    if (_users!.isEmpty) {
      return Text(
        widget.translation?.searchUserNoResult(widget.controller.text) ??
            'No User that matches "${widget.controller.text}"', // coverage:ignore-line
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: _users?.length ?? 0,
      itemBuilder: (context, index) {
        final user = _users![index];
        return _UserMenuItem(
          key: ValueKey(user.uri.toString()),
          user: user,
          selected: widget.selectedUser == user,
          onTap: () => widget.onSelected(user),
        );
      },
    );
  }
}

class _UserMenuItem extends StatelessWidget {
  const _UserMenuItem({
    super.key,
    required this.user,
    this.selected = false,
    this.onTap,
  });

  final DataUser user;

  final bool selected;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 32),
        child: DataUserWidget(user: user),
      ),
      selected: selected,
      onTap: onTap,
    );
  }
}
