import 'package:flutter/material.dart';

class FriendsScreen extends StatelessWidget{
  const FriendsScreen({Key? key}) : super(key:key);

  final double iconWidth = 100;
  final double iconHeight = 100;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
          children: [
            Column(
              children: [

                createSpace(width: 0, height: 50),

                Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                returnProfile(width: iconWidth, height: iconHeight),
                returnProfile(width: iconWidth, height: iconHeight),
                returnProfile(width: iconWidth, height: iconHeight),
                ],
                ),

                createSpace(width: 0, height: 50),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                returnProfile(width: iconWidth, height: iconHeight),
                returnProfile(width: iconWidth, height: iconHeight),
                returnProfile(width: iconWidth, height: iconHeight),
                ],
                ),

                createSpace(width: 0, height: 50),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                returnProfile(width: iconWidth, height: iconHeight),
                returnProfile(width: iconWidth, height: iconHeight),
                returnProfile(width: iconWidth, height: iconHeight),
                ],
                ),

                createSpace(width: 0, height: 50),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                returnProfile(width: iconWidth, height: iconHeight),
                returnProfile(width: iconWidth, height: iconHeight),
                returnProfile(width: iconWidth, height: iconHeight),
                ],
                ),

                createSpace(width: 0, height: 50),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                returnProfile(width: iconWidth, height: iconHeight),
                returnProfile(width: iconWidth, height: iconHeight),
                returnProfile(width: iconWidth, height: iconHeight),
                ],
                ),

                createSpace(width: 0, height: 50),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                returnProfile(width: iconWidth, height: iconHeight),
                returnProfile(width: iconWidth, height: iconHeight),
                returnProfile(width: iconWidth, height: iconHeight),
                ],
                )

              ],
            )
          ]
        )
      );
  }
}

Widget returnProfile({required double width, required double height}){
  return InkWell(
    onTap: (){
    },
    child: Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage('assets/newjeans.jpg'),
          fit: BoxFit.contain       
          ),
      ),
      
    )
  );
}

Widget createSpace({required double width, required double height}){
  return Container(
    width: 1,
    height: height,
  );
}

//https://memostack.tistory.com/329