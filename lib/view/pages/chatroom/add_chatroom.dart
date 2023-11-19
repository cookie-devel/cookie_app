import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:cookie_app/service/account.service.dart';
import 'package:cookie_app/service/chat.service.dart';
import 'package:cookie_app/view/components/dialog.dart';
import 'package:cookie_app/view/components/rounded_image.dart';
import 'package:cookie_app/view/components/snackbar.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';

class FriendSelectionScreen extends StatefulWidget {
  const FriendSelectionScreen({super.key});

  @override
  State<FriendSelectionScreen> createState() => _FriendSelectionScreenState();
}

class _FriendSelectionScreenState extends State<FriendSelectionScreen> {
  Set<AccountViewModel> selectedFriends = {};
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<AccountViewModel> friendList =
        context.watch<AccountService>().users.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅방 추가'),
        actions: [
          SizedBox(
            width: 56.0,
            child: CreateChatroomButton(
              roomTitle: textEditingController.text,
              selectedFriendsList: selectedFriends,
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: TextFormField(
              controller: textEditingController,
              onChanged: (newTitle) {
                final cursorPosition = textEditingController.selection;
                setState(() {
                  textEditingController.value =
                      textEditingController.value.copyWith(
                    text: newTitle,
                    selection: cursorPosition,
                  );
                });
              },
              decoration: const InputDecoration(
                labelText: '채팅방 이름',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              children: [
                const Text('친구'),
                const SizedBox(width: 10),
                Text(
                  '${selectedFriends.length}명',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    const Divider(color: Colors.grey),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: friendList.length,
                itemBuilder: (BuildContext context, int index) {
                  AccountViewModel friend = friendList[index];
                  return FriendTile(
                    friend: friend,
                    isSelected: selectedFriends.contains(friend),
                    onCheckboxChanged: (value) {
                      setState(() {
                        value == true
                            ? selectedFriends.add(friend)
                            : selectedFriends.remove(friend);
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}

class FriendTile extends StatelessWidget {
  final AccountViewModel friend;
  final bool isSelected;
  final ValueChanged<bool?>? onCheckboxChanged;

  const FriendTile({
    super.key,
    required this.friend,
    required this.isSelected,
    required this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // dense: true,
      leading: RoundedImage(
        image: friend.profile.image,
        imageSize: 50.0,
      ),
      title: Text(friend.name),
      subtitle: friend.profile.message != null
          ? Text(
              friend.profile.message!,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            )
          : null,
      trailing: Checkbox(
        value: isSelected,
        onChanged: onCheckboxChanged,
      ),
    );
  }
}

class CreateChatroomButton extends StatelessWidget {
  final String roomTitle;
  final Set<AccountViewModel> selectedFriendsList;

  const CreateChatroomButton({
    super.key,
    this.roomTitle = "",
    required this.selectedFriendsList,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.check),
      onPressed: () {
        // TODO: Handle Error cases
        try {
          if (selectedFriendsList.isEmpty) {
            throw Exception('친구를 한 명 이상 추가해주세요.');
          } else if (roomTitle.isEmpty) {
            throw Exception('채팅방 이름을 입력해주세요.');
          }
        } catch (e) {
          showErrorSnackBar(context, e.toString());
          rethrow;
        }

        // TODO: Implement code to create & navigate to chatroom. Business Logics MUST be done from ViewModel.
        showDialog(
          context: context,
          builder: (BuildContext context) => Alert(
            title: '$roomTitle (${selectedFriendsList.length + 1}명)',
            content: '채팅방을 개설하겠습니까?',
            onConfirm: () {
              Navigator.pop(context); // Pop Alert Dialog
              Navigator.pop(context); // Pop FriendSelectionScreen
              context.read<ChatService>().createRoom(
                    roomTitle,
                    selectedFriendsList.map((e) => e.id).toList(),
                  );
            },
          ),
        );
      },
    );
  }
}
