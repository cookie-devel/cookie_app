import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

import 'package:cookie_app/view/components/dialog.dart';
import 'package:cookie_app/service/account.service.dart';
import 'package:cookie_app/view/components/loading.dart';
import 'package:cookie_app/view/components/snackbar.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:cookie_app/view/components/account/friend_profile.dart';

class FriendsTab extends StatefulWidget {
  const FriendsTab({
    super.key,
  });

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  Future<void> updateFriends() =>
      context.read<AccountService>().update().catchError((error) {
        showErrorSnackBar(context, error.message);
      });

  @override
  Widget build(BuildContext context) {
    ConnectionState connectionState =
        context.watch<AccountService>().connectionState;

    if (connectionState == ConnectionState.waiting)
      return const LoadingScreen();
    else if (connectionState == ConnectionState.done)
      return RefreshIndicator(
        onRefresh: updateFriends,
        child: FriendsGrid(
          friendsListViewModel: context.watch<AccountService>(),
          handleRefresh: updateFriends,
        ),
      );
    return Message(
      msg: '친구 목록을 불러오세요',
      handleRefresh: updateFriends,
    );
  }
}

class FriendsGrid extends StatelessWidget {
  final AccountService friendsListViewModel;
  final void Function() handleRefresh;
  const FriendsGrid({
    super.key,
    required this.friendsListViewModel,
    required this.handleRefresh,
  });

  @override
  Widget build(BuildContext context) {
    List<AccountViewModel> friends = friendsListViewModel.users.values.toList();

    return friends.isNotEmpty
        ? GridView.builder(
            cacheExtent: 300,
            itemCount: friends.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (BuildContext context, int index) {
              final AccountViewModel friend = friends[index];

              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: InkWell(
                  onLongPress: () {
                    Vibration.vibrate(duration: 40);
                    showDialog(
                      context: context,
                      builder: (context) => Alert(
                        title: "친구 삭제",
                        content: "${friend.name}님을 목록에서 삭제할래요?",
                        onCancel: () {
                          Navigator.of(context).pop();
                        },
                        onConfirm: () {
                          context
                              .read<AccountService>()
                              .deleteUserFriends(friend.id)
                              .then((_) {
                            showSnackBar(
                              context,
                              "${friend.name}님을 목록에서 삭제했어요!",
                            );
                            Navigator.of(context).pop();
                          }).then((_) {
                            context
                                .read<AccountService>()
                                .update()
                                .catchError((error) {
                              showErrorSnackBar(context, error.message);
                            });
                          }).catchError((error) {
                            showErrorSnackBar(context, error.message);
                          });
                        },
                      ),
                    );
                  },
                  child: FriendProfileWidget(account: friend),
                ),
              );
            },
          )
        : Message(
            msg: '친구를 추가해보세요!',
            handleRefresh: handleRefresh,
          );
  }
}

class Message extends StatelessWidget {
  const Message({super.key, required this.msg, required this.handleRefresh});
  final String msg;
  final void Function() handleRefresh;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  msg,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                IconButton(
                  onPressed: handleRefresh,
                  tooltip: 'Refresh',
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),
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
