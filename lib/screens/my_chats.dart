// @dart=2.9

import 'package:alsouqf/widgets/bottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/chats_provider.dart';

import 'chatScreen.dart';

class MyChats extends StatefulWidget {
  static const routeName = "/my_chats";

  @override
  _MyChatsState createState() => _MyChatsState();
}

class _MyChatsState extends State<MyChats> {
  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Auth>(context, listen: false).userId;
    final chats = Provider.of<ChatsProvider>(context, listen: false)
        .fetchMyChats('', userId);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('دردشاتي'),
      ),
      body: FutureBuilder(
          future: Provider.of<ChatsProvider>(context, listen: false)
              .fetchMyChats(userId, userId),
          builder: (context, data) {
            if (data.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.separated(
                  itemCount: Provider.of<ChatsProvider>(context, listen: false)
                      .listChats
                      .length,
                  separatorBuilder: (context, index) => Divider(
                        thickness: 2,
                        color: Colors.deepOrange,
                      ),
                  itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                        data.data[index]['adId'],
                                        true,
                                        userId,
                                        data.data[index]['creatorAdId'],
                                        data.data[index]['adName'],
                                        data.data[index]['chatId'],
                                      )));
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(data.data[index]['chatDate']),
                            leading: Text(data.data[index]['creatorChatName']),
                            trailing: Text(
                              data.data[index]['adName'],
                              overflow: TextOverflow.clip,
                              softWrap: true,
                            ),
                          ),
                        ),
                      ));
            }
          }),
      bottomNavigationBar: BottomNavB(),
    );
  }
}
