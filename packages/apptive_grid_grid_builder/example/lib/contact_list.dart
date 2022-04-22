import 'package:apptive_grid_grid_builder/apptive_grid_grid_builder.dart';
import 'package:flutter/material.dart';

/// Shows a contact List
///
/// Set Up your Grid in ApptiveGrid using Text Columns
/// | First Name | Last Name | imgUrl
void main() async {
  await enableWebAuth(ApptiveGridOptions());
  runApp(
    ApptiveGrid(
      options: ApptiveGridOptions(
        environment: ApptiveGridEnvironment.alpha,
        authenticationOptions: ApptiveGridAuthenticationOptions(
          autoAuthenticate: true,
          apiKey: ApptiveGridApiKey(
            authKey: 'YOUR_AUTH_KEY',
            password: 'YOUR_AUTH_KEY_PASSWORD',
          ),
        ),
      ),
      child: MyApp(),
    ),
  );
}

///
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ApptiveGrid',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  _MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  final GlobalKey<ApptiveGridGridBuilderState> _builderKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grid Builder'),
      ),
      // Add the ApptiveGridGridBuilder to your Widget Tree
      body: ApptiveGridGridBuilder(
        key: _builderKey,
        gridUri: GridUri(
          user: 'USER_ID',
          space: 'SPACE_ID',
          grid: 'GRID_ID',
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () {
                return _builderKey.currentState?.reload() ?? Future.value();
              },
              child: ListView.separated(
                itemCount: snapshot.data!.rows?.length ?? 0,
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemBuilder: (context, index) {
                  final row = snapshot.data!.rows![index];
                  return ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10000),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(
                            row.entries
                                    .firstWhere(
                                      (element) =>
                                          element.field.name == 'imgUrl',
                                    )
                                    .data
                                    .value ??
                                '',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(
                          row.entries
                              .firstWhere(
                                (element) => element.field.name == 'First Name',
                              )
                              .data
                              .value,
                        ),
                        Text(' '),
                        Text(
                          row.entries
                              .firstWhere(
                                (element) => element.field.name == 'Last Name',
                              )
                              .data
                              .value,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
