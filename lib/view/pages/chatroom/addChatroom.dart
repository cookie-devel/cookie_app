import 'package:cookie_app/view/components/RoundedImage.dart';
import 'package:cookie_app/view/components/dialog.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:cookie_app/viewmodel/chat.viewmodel.dart';
import 'package:cookie_app/viewmodel/friendlist.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendSelectionScreen extends StatefulWidget {
  const FriendSelectionScreen({Key? key}) : super(key: key);

  @override
  State<FriendSelectionScreen> createState() => _FriendSelectionScreenState();
}

class _FriendSelectionScreenState extends State<FriendSelectionScreen> {
  Set<PublicAccountViewModel> selectedFriends = {};
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<PublicAccountViewModel> friendsList =
        Provider.of<FriendsListViewModel>(context).friends;
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
                itemCount: friendsList.length,
                itemBuilder: (BuildContext context, int index) {
                  PublicAccountViewModel friend = friendsList[index];
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
  final PublicAccountViewModel friend;
  final bool isSelected;
  final ValueChanged<bool?>? onCheckboxChanged;

  const FriendTile({
    Key? key,
    required this.friend,
    required this.isSelected,
    required this.onCheckboxChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // dense: true,
      leading: RoundedImage(
        image: friend.profileImage,
        imageSize: 50.0,
      ),
      title: Text(friend.name),
      subtitle: friend.profileMessage != null
          ? Text(
              friend.profileMessage!,
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
  final Set<PublicAccountViewModel> selectedFriendsList;

  const CreateChatroomButton({
    Key? key,
    this.roomTitle = "",
    required this.selectedFriendsList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.check),
      onPressed: () {
        // TODO: Handle Error cases
        if (selectedFriendsList.isEmpty) throw Exception('친구를 한 명 이상 추가해주세요.');
        if (roomTitle.isEmpty) throw Exception('채팅방 이름을 입력해주세요.');

        // TODO: Implement code to create & navigate to chatroom. Business Logics MUST be done from ViewModel.
        showDialog(
          context: context,
          builder: (context) => Alert(
            title: '$roomTitle (${selectedFriendsList.length + 1}명)',
            content: '채팅방을 개설하겠습니까?',
            onConfirm: () {
              Provider.of<ChatViewModel>(context, listen: false)
                  .socket
                  .emit("create_room", {
                'title': roomTitle,
                'members': selectedFriendsList.map((e) => e.id).toList(),
              });
              Navigator.pop(context);
            },
            onCancel: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
