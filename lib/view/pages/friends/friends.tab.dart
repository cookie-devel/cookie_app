import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

import 'package:cookie_app/view/components/account/friend_profile.dart';
import 'package:cookie_app/view/components/loading.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:cookie_app/viewmodel/friends.viewmodel.dart';

class FriendsTab extends StatefulWidget {
  const FriendsTab({
    Key? key,
  }) : super(key: key);

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  @override
  Widget build(BuildContext context) {
    FriendsViewModel fvmr = context.read<FriendsViewModel>();
    FriendsViewModel fvmw = context.read<FriendsViewModel>();

    return RefreshIndicator(
      onRefresh: context.read<FriendsViewModel>().updateFriends,
      child: context.watch<FriendsViewModel>().connectionState ==
              ConnectionState.waiting
          ? const LoadingScreen()
          : FriendsGrid(
              friendsListViewModel: context.watch<FriendsViewModel>(),
              handleRefresh: context.read<FriendsViewModel>().updateFriends,
            ),
      // child: value.busy
      //     ? const LoadingScreen()
      //     : value.loaded
      //         ?
      //         : Message(
      //             msg: '친구 목록을 불러오는 중 오류가 발생했습니다.',
      //             handleRefresh: handleUpdateFriends,
      //           ),
    );
  }
}

class FriendsGrid extends StatelessWidget {
  final FriendsViewModel friendsListViewModel;
  final void Function() handleRefresh;
  const FriendsGrid({
    super.key,
    required this.friendsListViewModel,
    required this.handleRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return friendsListViewModel.friendList.isNotEmpty
        ? GridView.builder(
            cacheExtent: 300,
            itemCount: friendsListViewModel.friendList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (BuildContext context, int index) {
              final PublicAccountViewModel friend =
                  friendsListViewModel.friendList[index];

              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: InkWell(
                  onLongPress: () {
                    Vibration.vibrate(duration: 40);
                    _showDeleteConfirmationSnackBar(context, index);
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
