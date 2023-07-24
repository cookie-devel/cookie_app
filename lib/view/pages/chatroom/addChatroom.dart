import 'package:cookie_app/view/components/RoundedImage.dart';
import 'package:cookie_app/view/components/dialog.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendSelectionScreen extends StatefulWidget {
  // final List<PublicAccountViewModel> friendsList;
  const FriendSelectionScreen({Key? key}) : super(key: key);

  @override
  State<FriendSelectionScreen> createState() => _FriendSelectionScreenState();
}

class _FriendSelectionScreenState extends State<FriendSelectionScreen> {
  // late List<PublicAccountViewModel> friendsList = [];
  Set<int> selectedIndexes = {};
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<PublicAccountViewModel> friendsList =
        Provider.of<PrivateAccountViewModel>(context).friends;
    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅방 추가'),
        actions: [
          CreateChatroomButton(
            roomTitle: textEditingController.text,
            selectedFriendsList: const [],
            // selectedFriendsList: _selectedFriendsList(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 28, 12, 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
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
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ExpansionTile(
                      title: Text('친구 (${friendsList.length})'),
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: friendsList.length - 1,
                          itemBuilder: (BuildContext context, int index) {
                            PublicAccountViewModel friend = friendsList[index];
                            return FriendTile(
                              friend: friend,
                              isSelected: selectedIndexes.contains(index),
                              onCheckboxChanged: (value) {
                                setState(() {
                                  value == true
                                      ? selectedIndexes.add(index)
                                      : selectedIndexes.remove(index);
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // List _selectedFriendsList() {
  //   List selectedList = [];
  //   for (int index in selectedIndexes) {
  //     if (index >= 0 && index < friendsList.length) {
  //       selectedList.add(friendsList[index]);
  //     }
  //   }
  //   return selectedList;
  // }

  @override
  void dispose() {
    textEditingController.dispose();
    selectedIndexes.clear();
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
      leading: Container(
        // width: 40,
        // height: 40,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: RoundedImage(image: friend.profileImage),
      ),
      title: const Text("username"),
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

class FriendEntry extends StatelessWidget {
  const FriendEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class CreateChatroomButton extends StatelessWidget {
  final String roomTitle;
  final List<PublicAccountViewModel> selectedFriendsList;

  const CreateChatroomButton({
    Key? key,
    this.roomTitle = "",
    required this.selectedFriendsList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.check_box_outlined),
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
            onConfirm: () {},
            onCancel: () {},
          ),
        );
      },
    );
  }
}
