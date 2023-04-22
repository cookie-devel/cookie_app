import 'package:flutter/material.dart';
import '../../../../cookie.appbar.dart';
import 'package:cookie_app/components/ImageSelection.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:io';


class MyProfileWidget extends StatefulWidget {
  const MyProfileWidget({Key? key}) : super(key: key);

  @override
  State<MyProfileWidget> createState() => _MyProfileWidgetState();
}

class _MyProfileWidgetState extends State<MyProfileWidget> {

  Map<String,dynamic> profiles = {};
  // File _image = File('assets/images/user.jpg');

  @override
  void initState() {
    super.initState();
    // _image = File('assets/images/user.jpg');
    getSampleData();
  }

  void getSampleData() async {
    final String res = await rootBundle.loadString('assets/data/user.json');
    final data = await json.decode(res);

    setState(() {
      profiles = data;
    });


    // // 이미지 파일 초기값 설정
    // final imagePath = profiles['image'];
    // if (imagePath != null) {
    //   _image = File(imagePath);
    // }
  }

  
  @override
  Widget build(BuildContext context) {
    

    return Scaffold(

      appBar: cookieAppbar2(context,'프로필 관리'),
      
      body: Column(
        children: [

          const SizedBox(height: 24),
          
          // GestureDetector(
          //   onTap: () async {
          //     final imageSelectionDialog = ImageSelectionDialog();
          //     final imageFile = await imageSelectionDialog.show(context);
          //     setState(() {
          //       if (imageFile != null) {
          //         _image = File(imageFile.path);
          //       }
          //     });
          //   },
          //   child: CircleAvatar(
          //     radius: 80,
          //     backgroundImage: Image.file(_image).image,
          //   ),
          // ),

          CircleAvatar(
              radius: 80,
              backgroundImage: Image.asset(profiles['image']).image,
          ),

          const SizedBox(height: 16),

          ListTile(
            leading: Icon(Icons.person),
            title: Text('이름'),
            subtitle: Text(profiles['name']),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _showEditNameDialog();
              },
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('상태메시지'),
            subtitle: Text(profiles['message']),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _showEditStatusDialog();
              },
            ),
          ),
        ],
      ),
    );  
  }

  void _showEditNameDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('이름을 입력하세요.'),
          content: TextField(
            decoration: InputDecoration(hintText: 'Enter your name'),
            onChanged: (value) {
              setState(() {
                profiles['name'] = value;
              });
            },
          ),
          actions: [
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('저장'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditStatusDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('상태메시지를 입력하세요.'),
          content: TextField(
            decoration: InputDecoration(hintText: 'Enter your status message'),
            onChanged: (value) {
              setState(() {
                profiles['message'] = value;
              });
            },
          ),
          actions: [
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('저장'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

