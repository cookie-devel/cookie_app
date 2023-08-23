import 'package:cookie_app/view/pages/friends/friendsSheet.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:cookie_app/viewmodel/friendlist.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:cookie_app/view/components/account/FriendProfileWidget.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class FriendsGrid extends StatelessWidget {
  const FriendsGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<FriendsListViewModel>(context, listen: false).updateFriends();
    return Scaffold(
      appBar: AppBar(
        title: const Text('친구'),
        actions: const [
          FriendsAction(),
        ],
      ),
      body: Consumer<FriendsListViewModel>(
        builder: (context, value, child) => RefreshIndicator(
          onRefresh: value.updateFriends,
          child: !value.busy
              ? value.friends.isNotEmpty
                  ? GridView.builder(
                      cacheExtent: 300,
                      itemCount: value.friends.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final PublicAccountViewModel friend =
                            value.friends[index];

                        return Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: InkWell(
                            onLongPress: () {
                              Vibration.vibrate(duration: 40);
                              _showDeleteConfirmationSnackBar(context, index);
                            },
                            child: FriendProfileWidget(
                              account: friend,
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
                    )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  void _showDeleteConfirmationSnackBar(BuildContext context, int index) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('정말로 삭제하겠습니까?'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: '삭제',
          onPressed: () {
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
