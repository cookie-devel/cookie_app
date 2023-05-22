import 'package:cookie_app/cookie.appbar.dart';
import 'package:cookie_app/handler/friends_refresh.handler.dart';
import 'package:cookie_app/utils/myinfo.dart';
import 'package:cookie_app/pages/friends/friendsSheet.dart';
import 'package:flutter/material.dart';
import 'package:cookie_app/components/friends/FriendProfileWidget.dart';
import 'package:cookie_app/schema/User.dart';
import 'package:vibration/vibration.dart';

class FriendsGrid extends StatefulWidget {
  const FriendsGrid({Key? key}) : super(key: key);

  @override
  State<FriendsGrid> createState() => _FriendsGridState();
}

class _FriendsGridState extends State<FriendsGrid>
    with AutomaticKeepAliveClientMixin<FriendsGrid> {
  @override
  bool get wantKeepAlive => true;

  List<dynamic> profiles = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    var friendList = my.friendList;
    if (friendList != null) {
      setState(() {
        profiles = sortList(friendList, 'username');
      });
    }
  }

  Future<void> updateData() async {
    var data = await apiGetFriends();
    setState(() {
      profiles = sortList(data['result'], 'username');
    });
    my.friendList = data['result'];
  }

  List sortList(List<dynamic> list, String key, {bool reverse = false}) {
    list.sort((a, b) {
      if (a[key] == null) {
        return 1;
      } else if (b[key] == null) {
        return -1;
      } else {
        return a[key].compareTo(b[key]);
      }
    });
    if (reverse) {
      list = list.reversed.toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: CookieAppBar(
        title: '친구',
        actions: const [
          FriendsAction(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: updateData,
        child: profiles.isNotEmpty
            ? GridView.builder(
                cacheExtent: 300,
                itemCount: profiles.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final Map<String, dynamic> profile = profiles[index];

                  return Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: InkWell(
                      onLongPress: () {
                        Vibration.vibrate(duration: 40);
                        setState(() {
                          _showDeleteConfirmationSnackBar(index);
                        });
                      },
                      child: FriendProfileWidget(
                        user: User.fromMap(profile),
                      ),
                    ),
                  );
                },
              )
            : Stack(
                children: [
                  ListView(),
                  const Center(
                    child: Text(
                      '친구를 추가해보세요!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _showDeleteConfirmationSnackBar(int index) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('정말로 삭제하겠습니까?'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: '삭제',
          onPressed: () {
            setState(() {
              profiles.removeAt(index);
            });
            scaffold.hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}

/*
Reference:
 https://eunoia3jy.tistory.com/106
 https://memostack.tistory.com/329
*/
