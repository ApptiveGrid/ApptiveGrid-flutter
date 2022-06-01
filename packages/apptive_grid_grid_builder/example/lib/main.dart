// ignore_for_file: public_member_api_docs

import 'package:apptive_grid_grid_builder/apptive_grid_grid_builder.dart';
import 'package:flutter/material.dart';

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
  State<_MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  final GlobalKey<ApptiveGridGridBuilderState> _builderKey = GlobalKey();

  List<ApptiveGridSorting>? _sorting;

  SortOrder _order = SortOrder.asc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grid Builder'),
        actions: [
          IconButton(
            onPressed: () {
              late final SortOrder newOrder;
              if (_order == SortOrder.asc) {
                newOrder = SortOrder.desc;
              } else {
                newOrder = SortOrder.asc;
              }
              setState(() {
                if (_sorting != null) {
                  _sorting = [_sorting!.first.copyWith(order: newOrder)];
                  _order = newOrder;
                }
              });
            },
            icon: Icon(
              _order == SortOrder.asc
                  ? Icons.arrow_drop_up
                  : Icons.arrow_drop_down,
            ),
          )
        ],
      ),
      // Add the ApptiveGridGridBuilder to your Widget Tree
      body: ApptiveGridGridBuilder(
        key: _builderKey,
        uri: Uri.parse('/api/a/users/USER_ID/spaces/SPACE_ID/grids/GRID_ID'),
        sorting: _sorting,
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
            if (_sorting == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                late final ApptiveGridSorting newSorting;
                if (snapshot.data!.fields?.first.type == DataType.geolocation) {
                  newSorting = DistanceApptiveGridSorting(
                    fieldId: snapshot.data!.fields!.first.id,
                    order: _order,
                    location:
                        Geolocation(latitude: 50.938757, longitude: 6.954399),
                  );
                } else {
                  newSorting = ApptiveGridSorting(
                    fieldId: snapshot.data!.fields!.first.id,
                    order: _order,
                  );
                }
                setState(() {
                  _sorting = [newSorting];
                });
              });
            }
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
                    title: Text(row.entries[1].data.schemaValue),
                    subtitle: Text(row.entries[0].data.value.toString()),
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
