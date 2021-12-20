import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_arduino/api.dart';
import 'package:flutter_arduino/bloc/api_bloc.dart';

import 'package:flutter_arduino/pages/pins_status_page.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  final String name;
  ChatPage({Key? key, required this.name}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ApiBloc bloc = ApiBloc();
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Timer.periodic(
        Duration(seconds: 5), (Timer t) => bloc..add(GetMessagesEvent()));
    return BlocProvider(
      create: (context) => bloc..add(GetMessagesEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Messages'),
          actions: [
            BlocBuilder<ApiBloc, ApiState>(
              builder: (context, state) {
                return IconButton(
                    onPressed: () async {
                      await API.deleteHisory();
                    },
                    icon: Icon(Icons.delete_forever));
              },
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PinStatusPage()));
                },
                icon: Icon(Icons.architecture)),
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              BlocBuilder<ApiBloc, ApiState>(
                builder: (context, state) {
                  if (state is MessagesLoaded) {
                    return ListView.builder(
                      itemCount: state.messages.length,
                      // shrinkWrap: true,
                      padding: EdgeInsets.only(top: 10, bottom: 60),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(
                              left: 14, right: 14, top: 10, bottom: 10),
                          child: Align(
                            alignment: (!isMessageMine(state.messages[index])
                                ? Alignment.topLeft
                                : Alignment.topRight),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: (!isMessageMine(state.messages[index])
                                    ? Colors.grey.shade200
                                    : Colors.cyan),
                              ),
                              padding: EdgeInsets.all(16),
                              child: Text(
                                state.messages[index],
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  height: 60,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                              hintText: "Write message...",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      BlocBuilder<ApiBloc, ApiState>(
                        builder: (context, state) {
                          if (state is MessagesLoaded) {
                            return FloatingActionButton(
                              onPressed: () {
                                if (controller.text.isNotEmpty) {
                                  bloc..add(SendMessageEvent(controller.text));
                                }
                                controller.text = '';
                              },
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 18,
                              ),
                              elevation: 0,
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isMessageMine(String message) {
    print(message);

    int endIndex = message.indexOf(':');
    String sender = message.substring(0, endIndex);
    print(this.widget.name);
    return sender.contains(this.widget.name);
  }
}
