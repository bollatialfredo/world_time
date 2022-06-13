import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';
import 'package:ndialog/ndialog.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Map<dynamic, dynamic> data = {};
  String imageName = '';

  Future<PermissionStatus> cameraAllowed() async {
    PermissionStatus status = await Permission.camera.status;
    return status;
  }

  Future<bool> requestCameraPermission() async {
    PermissionStatus resp = await Permission.camera.request();
    return resp.isGranted;
  }

  @override
  void initState() {
    super.initState();
    requestCameraPermission();
  }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context)?.settings.arguments as Map;
    data['isDayTime'] ? imageName = 'sun.jpg' : imageName = 'moon.jpg';
    return Scaffold(
      body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/$imageName'),
                fit: BoxFit.cover,
              )
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 120.0, 0, 0),
              child: Column(
                children: <Widget>[
                  TextButton.icon(
                      onPressed: () async {
                        dynamic res = await Navigator.pushNamed(context, '/location');
                        setState(() {
                          if(res != null){
                            data = res;
                          }
                        });
                      },
                      icon: const Icon(Icons.edit_location),
                      label: const Text('Edit Locatidons'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data['location'],
                        style: const TextStyle(
                          letterSpacing: 3,
                          fontSize: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    data['time'],
                    style: const TextStyle(
                      fontSize: 64,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          PermissionStatus perm = await cameraAllowed();
          if (!mounted) return;
          if (perm.isDenied) {
            if(Platform.isIOS) {
              CupertinoAlertDialog(
                title: const Text("Camera Permission not granted"),
                content: const Text("Open settings to grant access to the camera?"),
                actions: [
                  TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: const Text("Yes"),
                  onPressed: () {
                    AppSettings.openAppSettings();
                  },
                ),
                ],
              ).show(context);
            } else {
              AlertDialog(
                title: const Text('Camera Permission not granted'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: const <Widget>[
                      Text('Open settings to grant access to the camera?'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                   TextButton(
                    child: const Text("Yes"),
                    onPressed: () {
                      AppSettings.openAppSettings();
                    },
                  ),
                ],
              ).show(context);
            }
          }
          if (!perm.isGranted) return;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const Scanner(),
            ),
          );
         },
        child: const Icon(Icons.camera),
      ),
    );
  }
}
