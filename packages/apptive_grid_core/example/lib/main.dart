import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter/material.dart';

/// Add A ApptiveGrid Widget to your Widget Tree to enable ApptiveGrid Functionality
void main() async {
  const options = ApptiveGridOptions(
    environment: ApptiveGridEnvironment.alpha,
    authenticationOptions: ApptiveGridAuthenticationOptions(
      autoAuthenticate: true,
      redirectScheme: 'apptivegrid',
    ),
  );
  await enableWebAuth(options);
  runApp(ApptiveGrid(options: options, child: MyApp()));
}

/// You can access the ApptiveGridClient via ApptiveGrid.getClient()
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
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
                  style: Theme.of(context).textTheme.headline4,
                ),
                _UserSection(
                  onUserLoaded: (user) => setState(() => _user = user),
                ),
                if (_user != null)
                  Text(
                    'Spaces',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ...((_user?.spaces) ?? [])
                    .map((e) => _SpaceSection(spaceUri: e)),
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
    Key? key,
    required this.onUserLoaded,
  }) : super(key: key);

  final Function(User) onUserLoaded;

  @override
  _UserSectionState createState() => _UserSectionState();
}

class _UserSectionState extends State<_UserSection> {
  Future<User>? _userFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userFuture = ApptiveGrid.getClient(context).getMe().then((value) {
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
                    Text('${user.firstName} ${user.lastName}'),
                    Text(user.email),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}

class _SpaceSection extends StatefulWidget {
  const _SpaceSection({
    Key? key,
    required this.spaceUri,
  }) : super(key: key);

  final SpaceUri spaceUri;

  @override
  _SpaceSectionState createState() => _SpaceSectionState();
}

class _SpaceSectionState extends State<_SpaceSection> {
  Future<Space>? _spaceFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _spaceFuture = ApptiveGrid.getClient(context).getSpace(
      spaceUri:
          SpaceUri(user: widget.spaceUri.user, space: widget.spaceUri.space),
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
                      children: space.grids.map((e) => _GridSection(gridUri: e)).toList(),
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}

class _GridSection extends StatefulWidget {
  const _GridSection({
    Key? key,
    required this.gridUri,
  }) : super(key: key);

  final GridUri gridUri;

  @override
  _GridSectionState createState() => _GridSectionState();
}

class _GridSectionState extends State<_GridSection> {
  Future<Grid>? _gridFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _gridFuture = ApptiveGrid.getClient(context).loadGrid(
      gridUri: widget.gridUri,
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
                children: grid.rows.map((e) => Text(e.entries.first.data.value.toString())).toList(),
              )
            ],
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    )
        : Center(
      child: CircularProgressIndicator(),
    );
  }
}
