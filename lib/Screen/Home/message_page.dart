import 'dart:async';

import 'package:at_project/chat%20functions/chat_firebase_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({
    super.key,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.receiverName,
    required this.receiverImgUrl,
    required this.senderImgUrl,
  });

  final String senderId;
  final String senderName;
  final String receiverId;
  final String receiverName;
  final String receiverImgUrl;
  final String senderImgUrl;

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final _messagecontroller = TextEditingController();

  String formatTime(DateTime time) {
    String hour = (time.hour % 12).toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    String period = time.hour < 12 ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  String formatDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  Stream<List<Map<String, dynamic>>> fetchChatsStream() async* {
    try {
      while (true) {
        List<Map<String, dynamic>> fetchedMessages = await fetchMessages(
          senderId: widget.senderId,
          receiverId: widget.receiverId,
        );
        yield fetchedMessages;

        await Future.delayed(Duration(seconds: 1));
      }
    } catch (error) {
      print("Error fetching chat messages: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        foregroundColor: Colors.white,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(widget.receiverImgUrl),
            ),
            const SizedBox(width: 15),
            Text(
              widget.receiverName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    StreamBuilder(
                      stream: fetchChatsStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          print('${snapshot.error}');
                          return Center(
                            child: Text('An error occurred ${snapshot.error}'),
                          );
                        }

                        final List<Map<String, dynamic>>? messages =
                            snapshot.data;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: messages?.map((message) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: messagebox(
                                    message: message['text'],
                                    isSender:
                                        message['senderId'] == widget.senderId,
                                    time:
                                        (message['time'] as Timestamp).toDate(),
                                  ),
                                );
                              }).toList() ??
                              [],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            reusemessageField(
              hintText: 'Type a message',
              controller: _messagecontroller,
              onsend: () {
                if (_messagecontroller.text.isNotEmpty) {
                  addmessagetoFirebase(
                    user1Id: widget.receiverId,
                    user1Name: widget.receiverName,
                    user1ImgUrl: widget.receiverImgUrl,
                    user2ImgUrl: widget.senderImgUrl,
                    user2Id: widget.senderId,
                    user2Name: widget.senderName,
                    message: _messagecontroller.text,
                  );
                  setState(() {
                    _messagecontroller.clear();
                  });
                  FocusScope.of(context).unfocus();
                }
              },
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  Widget reusemessageField({
    required String hintText,
    required TextEditingController controller,
    required Function() onsend,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        hintText: hintText,
        suffixIcon: IconButton(onPressed: onsend, icon: const Icon(Icons.send)),
      ),
      style: const TextStyle(fontSize: 18),
    );
  }

  Widget messagebox(
      {required String message,
      required bool isSender,
      required DateTime time}) {
    if (isSender == true) {
      return Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                widget.senderName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7),
                padding: const EdgeInsets.only(
                    top: 8, bottom: 8, left: 14, right: 14),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(0),
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  color: Color.fromRGBO(66, 165, 245, 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      message,
                      style: const TextStyle(fontSize: 17, color: Colors.white),
                      softWrap: true,
                    ),
                    Text(
                      formatTime(time),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Text(formatDate(time))
            ],
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.receiverName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7),
                padding: const EdgeInsets.only(
                    top: 8, bottom: 8, left: 14, right: 14),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  color: Color.fromRGBO(66, 165, 245, 1),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message,
                        style:
                            const TextStyle(fontSize: 17, color: Colors.white),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                      Text(
                        formatTime(time),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              Text(formatDate(time))
            ],
          ),
        ],
      );
    }
  }
}
