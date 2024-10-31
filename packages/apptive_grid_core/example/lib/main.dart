import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter/material.dart';

/// Add A ApptiveGrid Widget to your Widget Tree to enable ApptiveGrid Functionality
void main() async {
  const options = ApptiveGridOptions(
    environment: ApptiveGridEnvironment.alpha,
    authenticationOptions: ApptiveGridAuthenticationOptions(
      autoAuthenticate: true,
      authGroup: 'apptivegrid',
      redirectScheme: 'apptivegrid',
      persistCredentials: false,
    ),
  );
  await enableWebAuth(options);
  runApp(const ApptiveGrid(options: options, child: MyApp()));
}

/// You can access the ApptiveGridClient via ApptiveGrid.getClient()
class MyApp extends StatefulWidget {
  /// A widget that demonstrates ApptiveGrid functionality
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? _user;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: ListView(
              children: [
                Text(
                  'User',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                _UserSection(
                  onUserLoaded: (user) => setState(() => _user = user),
                ),
                if (_user != null)
                  Text(
                    'Spaces',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ...(_user?.embeddedSpaces ?? []).map(
                  (e) => _SpaceSection(
                    uri: Uri.parse(
                      e.links[ApptiveLinkType.self]!.uri.toString(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _UserSection extends StatefulWidget {
  const _UserSection({
    required this.onUserLoaded,
  });

  final Function(User) onUserLoaded;

  @override
  State<_UserSection> createState() => _UserSectionState();
}

class _UserSectionState extends State<_UserSection> {
  Future<User>? _userFuture;
  late ApptiveGridClient _client;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _client = ApptiveGrid.getClient(context);
    _reload();
  }

  Future<void> _reload() async {
    _userFuture = _client.getMe().then((value) {
      widget.onUserLoaded(value);
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _userFuture != null
        ? FutureBuilder<User>(
            future: _userFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final user = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          child: const Text('Logout'),
                          onPressed: () {
                            ApptiveGrid.getClient(context, listen: false)
                                .logout();
                          },
                        ),
                        IconButton(
                          onPressed: _reload,
                          icon: const Icon(Icons.refresh),
                        ),
                      ],
                    ),
                    Text('${user.firstName} ${user.lastName}'),
                    Text(user.email),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}

class _SpaceSection extends StatefulWidget {
  const _SpaceSection({
    required this.uri,
  });

  final Uri uri;

  @override
  State<_SpaceSection> createState() => _SpaceSectionState();
}

class _SpaceSectionState extends State<_SpaceSection> {
  Future<Space>? _spaceFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _spaceFuture = ApptiveGrid.getClient(context).getSpace(
      uri: widget.uri,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _spaceFuture != null
        ? FutureBuilder<Space>(
            future: _spaceFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final space = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(space.name),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: space.embeddedGrids
                              ?.map(
                                (e) => _GridSection(
                                  uri: Uri.parse(
                                    e.links[ApptiveLinkType.self]!.uri
                                        .toString(),
                                  ),
                                ),
                              )
                              .toList() ??
                          [const SizedBox()],
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}

class _GridSection extends StatefulWidget {
  const _GridSection({
    required this.uri,
  });

  final Uri uri;

  @override
  State<_GridSection> createState() => _GridSectionState();
}

class _GridSectionState extends State<_GridSection> {
  Future<Grid>? _gridFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _gridFuture = ApptiveGrid.getClient(context).loadGrid(
      uri: widget.uri,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _gridFuture != null
        ? FutureBuilder<Grid>(
            future: _gridFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final grid = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(grid.name),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: grid.rows
                              ?.map(
                                (e) =>
                                    Text(e.entries.first.data.value.toString()),
                              )
                              .toList() ??
                          [const SizedBox()],
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
