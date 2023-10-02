import 'package:cookie_app/view/components/loading.dart';
import 'package:cookie_app/view/components/snackbar.dart';
import 'package:cookie_app/view/pages/friends/friendsSheet.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:cookie_app/viewmodel/friendlist.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:cookie_app/view/components/account/FriendProfileWidget.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

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

  Future<void> handleUpdateFriends() async {
    try {
      await context.read<FriendsListViewModel>().updateFriends();
      if (context.mounted) {
        showSnackBar(context: context, message: '친구 목록을 업데이트했습니다.');
      }
    } catch (e) {
      showErrorSnackBar(context, e.toString());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    handleUpdateFriends();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('친구'),
        actions: const [FriendsAction()],
      ),
      body: Consumer<FriendsListViewModel>(
        builder: (context, value, child) => RefreshIndicator(
          onRefresh: () => handleUpdateFriends(),
          child: value.busy
              ? const LoadingScreen()
              : value.loaded
                  ? FriendsGrid(
                      friendsListViewModel: value,
                      handleRefresh: handleUpdateFriends,
                    )
                  : Message(
                      msg: '친구 목록을 불러오는 중 오류가 발생했습니다.',
                      handleRefresh: handleUpdateFriends,
                    ),
        ),
      ),
    );
  }
}

class FriendsGrid extends StatelessWidget {
  final FriendsListViewModel friendsListViewModel;
  final void Function() handleRefresh;
  const FriendsGrid({
    super.key,
    required this.friendsListViewModel,
    required this.handleRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return friendsListViewModel.friends.isNotEmpty
        ? GridView.builder(
            cacheExtent: 300,
            itemCount: friendsListViewModel.friends.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (BuildContext context, int index) {
              final PublicAccountViewModel friend =
                  friendsListViewModel.friends[index];

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
    return Stack(
      children: [
        ListView(),
        Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Center(
                child: Text(
                  msg,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FloatingActionButton(
                onPressed: handleRefresh,
                child: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/*
Reference:
 https://eunoia3jy.tistory.com/106
 https://memostack.tistory.com/329
*/
