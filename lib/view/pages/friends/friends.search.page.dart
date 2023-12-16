import 'package:cookie_app/view/components/map/friend_invite_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cookie_app/utils/logger.dart';
import 'package:cookie_app/model/account/account.dart';
import 'package:cookie_app/types/account/profile.dart';
import 'package:cookie_app/service/account.service.dart';
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
              FriendInviteListTile(user: _userProfile),
            ],
          )
        : const Text('검색 결과가 없습니다.');
  }
}
