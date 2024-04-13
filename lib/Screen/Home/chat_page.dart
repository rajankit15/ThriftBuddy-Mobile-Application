import 'package:at_project/Screen/Home/bottom_bar.dart';
import 'package:at_project/Screen/Home/message_page.dart';
import 'package:at_project/chat%20functions/chat_firebase_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String userId = '';

  @override
  void initState() {
    super.initState();
    var user = FirebaseAuth.instance.currentUser;
    userId = user!.uid;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        foregroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              setState(() {
                currentNavIndex = 0;
              });
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
                (route) => false,
              );
            },
            icon: const Icon(Icons.home)),
        title: const Text(
          'Chats',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FutureBuilder(
          future: fetchChats(userId: userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error'));
            }
            List<DocumentSnapshot> chatList =
                snapshot.data as List<DocumentSnapshot>;

            return SingleChildScrollView(
              child: Column(
                children: List.generate(
                  chatList.length,
                  (index) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessagePage(
                            senderId: userId,
                            senderName:
                                snapshot.data![index]['user1Id'] == userId
                                    ? snapshot.data![index]['user1Name']
                                    : snapshot.data![index]['user2Name'],
                            receiverId:
                                snapshot.data![index]['user1Id'] == userId
                                    ? snapshot.data![index]['user2Id']
                                    : snapshot.data![index]['user1Id'],
                            receiverName:
                                snapshot.data![index]['user1Id'] == userId
                                    ? snapshot.data![index]['user2Name']
                                    : snapshot.data![index]['user1Name'],
                            receiverImgUrl:
                                snapshot.data![index]['user1Id'] == userId
                                    ? snapshot.data![index]['user2ImgUrl']
                                    : snapshot.data![index]['user1ImgUrl'],
                            senderImgUrl:
                                snapshot.data![index]['user1Id'] == userId
                                    ? snapshot.data![index]['user1ImgUrl']
                                    : snapshot.data![index]['user2ImgUrl'],
                          ),
                        ),
                      );
                    },
                    child: chatIcon(
                      imgUrl: snapshot.data![index]['user1Id'] == userId
                          ? snapshot.data![index]['user2ImgUrl']
                          : snapshot.data![index]['user1ImgUrl'],
                      name: snapshot.data![index]['user1Id'] == userId
                          ? snapshot.data![index]['user2Name']
                          : snapshot.data![index]['user1Name'],
                      lastMessage:
                          snapshot.data![index]['message'].last['text'],
                      time: snapshot.data![index]['message'].last['time']
                          .toDate(),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget chatIcon(
      {required String imgUrl,
      required String name,
      required String lastMessage,
      required DateTime time}) {
    return Container(
      margin: const EdgeInsets.only(top: 7.5, bottom: 7.5),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundImage: NetworkImage(
              imgUrl,
            ),
            backgroundColor: Colors.grey[100],
          ),
          const SizedBox(width: 15),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(fontSize: 20),
              ),
              SizedBox(
                width: 180,
                child: Text(
                  lastMessage,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(formatTime(time)),
          const SizedBox(width: 10)
        ],
      ),
    );
  }

  String formatTime(DateTime time) {
    String hour = (time.hour % 12).toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    String period = time.hour < 12 ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }
}
