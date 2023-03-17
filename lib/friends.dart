import 'package:flutter/material.dart';

class FriendsScreen extends StatelessWidget{
  const FriendsScreen({Key? key}) : super(key:key);
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          returnProfile(color: Colors.red, width: 100, height: 100),
          returnProfile(color: Colors.red, width: 100, height: 100),
          returnProfile(color: Colors.red, width: 100, height: 100),
        ],
        )
      );
  }
}

Widget returnProfile({required Color color, required double width, required double height}){
  return Container(
    color: color,
    width: width,
    height: height,
    padding: const EdgeInsets.all(0.0),
    margin: const EdgeInsets.all(0.0),
  );
}


/*
import 'package:cookie_app/friends.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key:key);
  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(title:Text('안녕하세요 플러터 초보입니다')),
        body:
          Center(
            child:ElevatedButton(
              child:const Text('화면 이동'),
              onPressed:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FriendsScreen()));
              }
            )
          ),
        bottomNavigationBar: BottomAppBar(child:Text('하단바입니다')),
      );
  }
}*/