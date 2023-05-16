import 'package:flutter/material.dart';
import 'package:flutter_application_hw1/components/friends_list.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FriendListPage(),
    );
  }
}

class FriendListPage extends StatefulWidget {
  FriendListPage({super.key});

  @override
  State<FriendListPage> createState() => _FriendListPage();
}

class _FriendListPage extends State<FriendListPage> {
  List<FriendItem> _friends = [];
  var url = 'https://randomuser.me/api/?results=30';

  @override
  void initState() {
    super.initState();
    _loadFriendsData();
  }

  _loadFriendsData() async {
    HttpClient client = HttpClient();
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();
    var jsonString = response.transform(utf8.decoder).join();

    setState(() {
      _friends = FriendItem.resolveDataFromResponse(jsonString as String);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Friend list"),
        ),
        body: ListView.builder(
          itemCount: _friends.length,
          itemBuilder: (BuildContext context, int index) {
            var item = _friends[index];
            return ListTile(
              leading: Image.network(item.avatar),
              title: Text(item.name),
              subtitle: Text(item.email),
            );
          },
        ));
  }
}

class FriendItem {
  final String avatar;

  final String name;

  final String email;

  FriendItem({required this.avatar, required this.name, required this.email});

  // transform json strings into List<Friend>
  static List<FriendItem> resolveDataFromResponse(String responseData) {
    var json = jsonDecode(responseData);
    var results = json['results'];
    var res = results
        .map((obj) => FriendItem.fromMap(obj))
        .toList()
        .cast<FriendItem>();
    return res;
  }

  static FriendItem fromMap(Map map) {
    var name = map['name'];

    return FriendItem(
      avatar: map['picture']['large'],
      name: '${name['first']} ${name['last']}',
      email: map['email'],
    );
  }
}
