import 'dart:convert';

class friendItem {
  final String avatar;

  final String name;

  final String email;

  friendItem({required this.avatar, required this.name, required this.email});

  // transform json strings into List<Friend>
  static List<friendItem> resolveDataFromResponse(String responseData) {
    var json = jsonDecode(responseData);
    var results = json['results'];
    var res = results.map((obj) => Friend.fromMap(obj)).toList().cast<Friend>();
    return res;
  }

  static friendItem fromMap(Map map) {
    var name = map['name'];

    return friendItem(
      avatar: map['picture']['large'],
      name: '${name['first']} ${name['last']}',
      email: map['email'],
    );
  }
}
