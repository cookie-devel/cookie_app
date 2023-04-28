import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../cookie.appbar.dart';

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
      
      body: ListView(
        padding: const EdgeInsets.fromLTRB(5, 25, 5, 10),
        children: [
          
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
          Container(
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage(profiles['image']),
              ),
            ),
          ),

          const SizedBox(height: 16),
          
          ListTile(
            leading: Icon(Icons.person,size: 36,),
            title: Text('이름'),
            subtitle: Text(profiles['name']),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _showEditNameDialog();
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.message,size: 36,),
            title: Text('상태메시지'),
            subtitle: Text(profiles['message']),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _showEditStatusDialog();
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.phone_android_outlined,size: 36,),
            title: Text('전화번호'),
            subtitle: Text('profiles[\'phonenumber\']'),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.person,size: 36,),
            title: Text('이름'),
            subtitle: Text(profiles['name']),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.heart_broken,size: 36,),
            title: Text('이름'),
            subtitle: Text(profiles['name']),
          ),
          const Divider(),
          ListTile(
          leading: Icon(Icons.heart_broken,size: 36,),
          title: Text('이름'),
          subtitle: Text(profiles['name']),
          ),
        ],
      ),
    );  
  }

  void _showEditNameDialog() {
    String newName = profiles['name'];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(
            '이름을 입력하세요',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            decoration: InputDecoration(
              hintText: 'Enter your name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onChanged: (value) {
              newName = value;
            },
          ),
          actions: [
            TextButton(
              child: Text(
                '취소',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text(
                '저장',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                setState(() {
                  profiles['name'] = newName;
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditStatusDialog() {
    String newMessage = profiles['message'];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(
            '상태메시지를 입력하세요',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            decoration: InputDecoration(
              hintText: 'Enter your status message',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onChanged: (value) {
              newMessage = value;
            },
          ),
          actions: [
            TextButton(
              child: Text(
                '취소',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text(
                '저장',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                setState(() {
                  profiles['message'] = newMessage;
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

