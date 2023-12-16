import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cookie_app/utils/logger.dart';
import 'package:cookie_app/model/account/account.dart';
import 'package:cookie_app/types/account/profile.dart';
import 'package:cookie_app/view/components/dialog.dart';
import 'package:cookie_app/service/account.service.dart';
import 'package:cookie_app/view/components/snackbar.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';

class FriendSearchScreen extends StatefulWidget {
  const FriendSearchScreen({super.key});

  @override
  State<FriendSearchScreen> createState() => _FriendSearchScreenState();
}

class _FriendSearchScreenState extends State<FriendSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchedId = '';
  AccountViewModel _userProfile = AccountViewModel(
    model: AccountModel(id: '', name: '', profile: Profile()),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('친구 추가'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildSearchBar(),
            const SizedBox(height: 20),
            buildSearchResult(),
          ],
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: '친구의 ID를 입력하세요',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchedId = value;
              });
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            _search();
          },
        ),
      ],
    );
  }

  void _search() async {
    AccountViewModel userProfile = AccountViewModel(
      model: AccountModel(id: '', name: '', profile: Profile()),
    );

    if (_searchedId.isNotEmpty) {
      logger.t('_searchedId: $_searchedId');
      try {
        userProfile =
            await context.read<AccountService>().getUserProfile(_searchedId);
      } catch (e) {
        logger.t(e);
      }
      setState(() {
        _userProfile = userProfile;
      });
    }
  }

  Widget buildSearchResult() {
    if (_searchedId.isEmpty && _userProfile.name == '') {
      return const SizedBox();
    }
    return _userProfile.name != ''
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                '검색 결과',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              FriendSearchListTile(user: _userProfile),
            ],
          )
        : const Text('검색 결과가 없습니다.');
  }
}

class FriendSearchListTile extends StatelessWidget {
  final AccountViewModel user;

  const FriendSearchListTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    bool userHasFriend =
        context.watch<AccountService>().users.containsKey(user.id);
    bool me = context.watch<AccountService>().my.id == user.id;
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.orangeAccent,
            width: 1.3,
          ),
        ),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: user.profile.image,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            user.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      trailing: userHasFriend || me
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.orangeAccent,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              child: Text(
                userHasFriend ? '친구' : '본인',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : IconButton(
              icon: const Icon(
                Icons.person_add_alt_1_outlined,
                color: Colors.orangeAccent,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Alert(
                    title: "친구 추가",
                    content: "${user.name}님을 친구 목록에 추가할래요?",
                    onCancel: () {
                      Navigator.of(context).pop();
                    },
                    onConfirm: () {
                      context.read<AccountService>().updateUserFriends(user.id);
                      showSnackBar(
                        context,
                        "${user.name}님을 친구 목록에 추가했습니다.",
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                );
              },
            ),
    );
  }
}
