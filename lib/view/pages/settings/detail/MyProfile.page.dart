import 'package:cookie_app/view/components/cookie.appbar.dart';
import 'package:cookie_app/viewmodel/account.viewmodel.dart';
import 'package:flutter/material.dart';

class MyProfileWidget extends StatefulWidget {
  final PrivateAccountViewModel my;
  const MyProfileWidget({
    Key? key,
    required this.my,
  }) : super(key: key);

  @override
  State<MyProfileWidget> createState() => _MyProfileWidgetState();
}

class _MyProfileWidgetState extends State<MyProfileWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CookieAppBar(title: '프로필 관리'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(5, 25, 5, 10),
        children: [
          Container(
            height: 160,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image(
              image: widget.my.profileImage,
              fit: BoxFit.cover,
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                return const Icon(Icons.error, size: 36);
              },
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(
              Icons.person,
              size: 36,
            ),
            title: const Text('이름'),
            subtitle: Text(widget.my.name),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // _showEditNameDialog();
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.message,
              size: 36,
            ),
            title: const Text('상태메시지'),
            subtitle: Text(widget.my.profileMessage!),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // _showEditStatusDialog();
              },
            ),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(
              Icons.phone_android_outlined,
              size: 36,
            ),
            title: Text('전화번호'),
            subtitle: Text('profiles[\'phonenumber\']'),
          ),
          const Divider(),
        ],
      ),
    );
  }

  // void _showEditNameDialog() {
  //   // String newName = profiles['name'];
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16.0),
  //         ),
  //         title: const Text(
  //           '이름을 입력하세요',
  //           style: TextStyle(
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         content: TextField(
  //           decoration: InputDecoration(
  //             hintText: 'Enter your name',
  //             border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(10.0),
  //             ),
  //           ),
  //           onChanged: (value) {
  //             newName = value;
  //           },
  //         ),
  //         actions: [
  //           TextButton(
  //             child: const Text(
  //               '취소',
  //               style: TextStyle(
  //                 color: Colors.grey,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               setState(() {
  //                 profiles['name'] = newName;
  //               });
  //               Navigator.of(context).pop();
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.blue,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10.0),
  //               ),
  //             ),
  //             child: const Text(
  //               '저장',
  //               style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void _showEditStatusDialog() {
  //   // String newMessage = profiles['message'];
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16.0),
  //         ),
  //         title: const Text(
  //           '상태메시지를 입력하세요',
  //           style: TextStyle(
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         content: TextField(
  //           decoration: InputDecoration(
  //             hintText: 'Enter your status message',
  //             border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(10.0),
  //             ),
  //           ),
  //           onChanged: (value) {
  //             newMessage = value;
  //           },
  //         ),
  //         actions: [
  //           TextButton(
  //             child: const Text(
  //               '취소',
  //               style: TextStyle(
  //                 color: Colors.grey,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               setState(() {
  //                 profiles['message'] = newMessage;
  //               });
  //               Navigator.of(context).pop();
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.blue,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10.0),
  //               ),
  //             ),
  //             child: const Text(
  //               '저장',
  //               style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
