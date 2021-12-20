import 'package:flutter/material.dart';
import 'package:flutter_arduino/pages/chat_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Arduino + Flutter"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            height: 200,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 120,
                    child: Image.asset("arduino.png"),
                  ),
                  Container(
                    height: 120,
                    child: Image.asset(
                      "flutter.jpg",
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 40, 20, 20),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: 'Name'),
            ),
          ),
          Container(
            child: ElevatedButton(
              child: Text('Submit'),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('name', controller.text.trim());
                if (controller.text.isNotEmpty) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ChatPage(name: controller.text.trim())));
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
