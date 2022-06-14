part of apptive_grid_form_widgets;

/// FormWidget for a DataUser
class UserFormWidget extends StatefulWidget {
  /// Creates the FormWidget
  const UserFormWidget({
    super.key,
    required this.component,
  });

  /// Component this Widget should reflect
  final FormComponent<UserDataEntity> component;

  @override
  State<UserFormWidget> createState() => _UserFormWidgetState();
}

class _UserFormWidgetState extends State<UserFormWidget> {
  @override
  Widget build(BuildContext context) {
    return _UserDropdownButtonFormField(
      component: widget.component,
      onSelected: (user) {
        setState(() {
          widget.component.data.value = user;
        });
      },
    );
  }
}

class DataUserWidget extends StatelessWidget {
  const DataUserWidget({super.key, required this.user});

  final DataUser user;

  @override
  Widget build(BuildContext context) {
    late final String initials;
    if (user.displayValue.isEmpty) {
      initials = '';
    } else {
      final names = user.displayValue.split(' ');
      if (names.length > 1) {
        initials = names[0][0] + names.last[0];
      } else {
        initials = names[0][0];
      }
    }
    final theme = Theme.of(context);
    final initialsWidget = FittedBox(
      fit: BoxFit.cover,
      child: ColoredBox(
        color: theme.colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            initials,
            style: TextStyle(color: theme.colorScheme.onPrimary),
          ),
        ),
      ),
    );
    return Row(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            child: Image.network(
              'https://apptiveavatarupload-apptiveavataruploadbucket-17hw58ak4gvs6.s3.eu-central-1.amazonaws.com/${user.uri.pathSegments.last}.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => initialsWidget,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(user.displayValue),
      ],
    );
  }
}
