import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MethodChannelExample extends StatefulWidget {
  const MethodChannelExample({Key? key}) : super(key: key);

  @override
  _MethodChannelExampleState createState() => _MethodChannelExampleState();
}

class _MethodChannelExampleState extends State<MethodChannelExample> {
  late String username = "No username found";

  static const platform = MethodChannel("username");

  Future<void> getUsername() async {
    try {
      String res = await platform.invokeMethod("getUsername");
      setState(() {
        username = res;
      });
    } on PlatformException catch (e) {
      setState(() {
        username = "Failed to get username : ${e.toString()}";
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(username,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 34)),
              ElevatedButton(
                child: const Text('Get Username'),
                onPressed: getUsername,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
