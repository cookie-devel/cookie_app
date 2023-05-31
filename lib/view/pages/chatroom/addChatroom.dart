import 'package:cookie_app/schema/Room.dart';
import 'package:cookie_app/view/components/cookie.appbar.dart';
import 'package:flutter/material.dart';
import 'package:cookie_app/view/pages/chatroom/chatroom.dart';
import 'package:cookie_app/repository/myinfo.dart';
import 'package:cookie_app/schema/User.dart';
import 'package:cookie_app/schema/Message.dart';

class FriendSelectionScreen extends StatefulWidget {
  const FriendSelectionScreen({Key? key}) : super(key: key);

  @override
  State<FriendSelectionScreen> createState() => _FriendSelectionScreenState();
}

class _FriendSelectionScreenState extends State<FriendSelectionScreen> {
  List<dynamic>? friendsList = my.friendList;
  Set<int> selectedIndexes = {};
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CookieAppBar(
        title: '채팅방 추가',
        actions: [
          AddChatroomAction(
            roomTitle: textEditingController.text,
            selectedFriendsList: _selectedFriendsList(),
            onRoomTitleChanged: (newTitle) {
              setState(() {
                textEditingController.text = newTitle;
              });
            },
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
                      title: Text('친구 (${friendsList!.length})'),
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: friendsList!.length,
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, dynamic> friend = friendsList![index];
                            return FriendTile(
                              friend: friend,
                              isSelected: selectedIndexes.contains(index),
                              onCheckboxChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    selectedIndexes.add(index);
                                  } else {
                                    selectedIndexes.remove(index);
                                  }
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

  List _selectedFriendsList() {
    List selectedList = [];
    for (int index in selectedIndexes) {
      if (index >= 0 && index < friendsList!.length) {
        selectedList.add(friendsList![index]);
      }
    }
    return selectedList;
  }

  @override
  void dispose() {
    textEditingController.dispose();
    selectedIndexes.clear();
    super.dispose();
  }
}

class FriendTile extends StatelessWidget {
  final Map<String, dynamic> friend;
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
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Image(
          image: my.profileImage,
          fit: BoxFit.cover,
          errorBuilder: (
            BuildContext context,
            Object error,
            StackTrace? stackTrace,
          ) {
            return Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 24,
              ),
            );
          },
        ),
      ),
      title: Text(friend["username"]),
      subtitle: Text(
        friend["profile"]["message"] ?? "",
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      trailing: Checkbox(
        value: isSelected,
        onChanged: onCheckboxChanged,
      ),
    );
  }
}

class AddChatroomAction extends StatefulWidget {
  final String roomTitle;
  final List selectedFriendsList;
  final Function(String) onRoomTitleChanged;

  const AddChatroomAction({
    Key? key,
    this.roomTitle = "",
    required this.selectedFriendsList,
    required this.onRoomTitleChanged,
  }) : super(key: key);

  @override
  State<AddChatroomAction> createState() => _AddChatroomActionState();
}

class _AddChatroomActionState extends State<AddChatroomAction> {
  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return IconButton(
      icon: const Icon(Icons.check_box_outlined),
      onPressed: () {
        widget.selectedFriendsList.isEmpty // 친구가 없을 때
            ? scaffold.showSnackBar(
                _snackBar(scaffold, '친구를 한 명 이상 추가해주세요.', '확인'),
              )
            : widget.roomTitle.isEmpty // 제목이 없을 때
                ? scaffold.showSnackBar(
                    _snackBar(scaffold, '채팅방 이름을 입력해주세요.', '확인'),
                  )
                : showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      title: Text(
                        '${widget.roomTitle} (${widget.selectedFriendsList.length + 1}명)',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: const Text(
                        '채팅방을 개설하겠습니까?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            '취소',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            List<User> userList =
                                widget.selectedFriendsList.map<User>((map) {
                              return User.fromMap(map);
                            }).toList();

                            Message temp = Message(
                              sender: userList[0],
                              content: '안녕?',
                              time: DateTime.now(),
                            );

                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.push(
                              // TODO: chatrooms tab에도 추가
                              // TODO: 채팅방 목록 데이터에도 추가
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatRoom(
                                  room: Room(
                                    id: '',
                                    name: widget.roomTitle,
                                    users: userList,
                                    messages: [temp],
                                  ),
                                ),
                              ),
                            );
                          },
                          child: const Text('확인'),
                        ),
                      ],
                    ),
                  );
      },
    );
  }

  SnackBar _snackBar(
    ScaffoldMessengerState scaffold,
    String title,
    String label,
  ) =>
      SnackBar(
        content: Text(title),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: label,
          onPressed: () {
            scaffold.hideCurrentSnackBar();
          },
        ),
      );
}
