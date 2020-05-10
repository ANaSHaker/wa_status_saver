import 'package:flutter/material.dart';
import 'package:wa_status_saver/ui/dashboard.dart';
import 'package:wa_status_saver/ui/mydrawer.dart';
import 'package:share/share.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_html/flutter_html.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  int _storagePermissionCheck;
  Future<int> _storagePermissionChecker;

  Future<int> checkStoragePermission() async {
    // bool result = await SimplePermissions.checkPermission(Permission.ReadExternalStorage);
    PermissionStatus result = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    print("Checking Storage Permission " + result.toString());
    setState(() {
      _storagePermissionCheck = 1;
    });
    if (result.toString() == 'PermissionStatus.denied') {
      return 0;
    } else if (result.toString() == 'PermissionStatus.granted') {
      return 1;
    } else {
      return 0;
    }
  }

  Future<int> requestStoragePermission() async {
    // PermissionStatus result = await SimplePermissions.requestPermission(Permission.ReadExternalStorage);
    Map<PermissionGroup, PermissionStatus> result =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    if (result.toString() == 'PermissionStatus.denied') {
      return 1;
    } else if (result.toString() == 'PermissionStatus.granted') {
      return 2;
    } else {
      return 1;
    }
  }

  @override
  void initState() {
    super.initState();
    _storagePermissionChecker = (() async {
      int storagePermissionCheckInt;
      int finalPermission;

      print("Initial Values of $_storagePermissionCheck");
      if (_storagePermissionCheck == null || _storagePermissionCheck == 0) {
        _storagePermissionCheck = await checkStoragePermission();
      } else {
        _storagePermissionCheck = 1;
      }
      if (_storagePermissionCheck == 1) {
        storagePermissionCheckInt = 1;
      } else {
        storagePermissionCheckInt = 0;
      }

      if (storagePermissionCheckInt == 1) {
        finalPermission = 1;
      } else {
        finalPermission = 0;
      }

      return finalPermission;
    })();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'حفظ حالات الواتساب',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.teal,
      ),
      home: DefaultTabController(
        length: 2,
        child: FutureBuilder(
          future: _storagePermissionChecker,
          builder: (context, status) {
            if (status.connectionState == ConnectionState.done) {
              if (status.hasData) {
                if (status.data == 1) {
                  return MyHome();
                } else {
                  return Scaffold(
                    body: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          Colors.lightBlue[100],
                          Colors.lightBlue[200],
                          Colors.lightBlue[300],
                          Colors.lightBlue[200],
                          Colors.lightBlue[100],
                        ],
                      )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "Storage Permission Required",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                          FlatButton(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              "Allow Storage Permission",
                              style: TextStyle(fontSize: 20.0),
                            ),
                            color: Colors.indigo,
                            textColor: Colors.white,
                            onPressed: () {
                              setState(() {
                                _storagePermissionChecker =
                                    requestStoragePermission();
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  );
                }
              } else {
                return Scaffold(
                  body: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Colors.lightBlue[100],
                        Colors.lightBlue[200],
                        Colors.lightBlue[300],
                        Colors.lightBlue[200],
                        Colors.lightBlue[100],
                      ],
                    )),
                    child: Center(
                      child: Text(
                        "Something went wrong.. Please uninstall and Install Again.",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                );
              }
            } else {
              return Scaffold(
                body: Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class MyHome extends StatelessWidget {
  var html =
      "<h3><b>How To Use?</b></h3><p>- Check the Desired Status/Story...</p><p>- Come Back to App, Click on any Image or Video to View...</p><p>- Click the Save Button...<br />The Image/Video is Instantly saved to your Galery :)</p><p>- You can also Use Multiple Saving. [to do]</p>";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState.openDrawer()),
        title: Text('Status Saver'),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                Share.share(
                    'شارك التطبيق الان',
                    subject: 'Look what I made!');
              }),
         
        ],
        bottom: TabBar(tabs: [
          Container(
            height: 30.0,
            child: Text(
              'صور',
            ),
          ),
          Container(
            height: 30.0,
            child: Text(
              'فيديوهات',
            ),
          ),
        ]),
      ),
      body: Dashboard(),
      backgroundColor: Colors.white,
     
    );
  }
}
