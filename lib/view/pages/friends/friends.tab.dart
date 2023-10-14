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

class _FriendsTabState extends State<FriendsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  late Future<void> _initFriendsData;

  @override
  void initState() {
    super.initState();
    _initFriendsData = context.read<FriendsViewModel>().updateFriends();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    FriendsViewModel friendsViewModel = context.read<FriendsViewModel>();
    return FutureBuilder(
      future: friendsViewModel.friendList,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return RefreshIndicator(
              key: _refreshKey,
              onRefresh: friendsViewModel.updateFriends,
              child: Message(
                msg: '친구 목록을 불러오세요.',
                handleRefresh: friendsViewModel.updateFriends,
              ),
            );
          case ConnectionState.active:
          case ConnectionState.waiting:
            return const LoadingScreen();
          case ConnectionState.done:
            if (snapshot.hasError) {
              return RefreshIndicator(
                key: _refreshKey,
                onRefresh: () => Future(() {
                  setState(() {});
                }),
                child: Message(
                  msg: '친구 목록을 불러오는 중 오류가 발생했습니다.',
                  handleRefresh: friendsViewModel.updateFriends,
                ),
              );
            }
            if (snapshot.data!.isEmpty) {
              return RefreshIndicator(
                key: _refreshKey,
                onRefresh: friendsViewModel.updateFriends,
                child: Message(
                  msg: '친구를 추가해보세요!',
                  handleRefresh: friendsViewModel.updateFriends,
                ),
              );
            } else {
              return RefreshIndicator(
                key: _refreshKey,
                onRefresh: friendsViewModel.updateFriends,
                child: FriendsGrid(
                  friendList: snapshot.data!,
                ),
              );
            }
        }
      },
    );
  }
}

class FriendsGrid extends StatelessWidget {
  final List<PublicAccountViewModel> friendList;
  const FriendsGrid({
    super.key,
    required this.friendList,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      cacheExtent: 300,
      itemCount: friendList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (BuildContext context, int index) {
        final PublicAccountViewModel friend = friendList[index];
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
