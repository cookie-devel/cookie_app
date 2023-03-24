import 'package:flutter/material.dart';
import 'main.dart' as main;

const double iconWidth = 85;
const double iconHeight = 85;

const double iconWidthRatio = 0.1344;
const double iconHeightRatio = 0.1344;

const double spaceWidth = 70;
const double spaceHeight = 70;

const double spaceBetweenContainerText = 8;

const int cnt = 0;
class FriendsScreen extends StatelessWidget{
  const FriendsScreen({Key? key}) : super(key:key);
  
  final int friendCount = 31;
  
  @override
  Widget build(BuildContext context){

    print(MediaQuery.of(context).size.height);

    final int rowCount = ((friendCount/3).ceil());
    final int ext = friendCount%3;

    return Scaffold(

      backgroundColor: Colors.white,

      body: ListView.builder(

        itemCount: rowCount,
        itemBuilder:(context, index) {

        if ((rowCount==index+1)&&(ext==1)){
          return Column(
            children:[
              createSpace(context: context, width: 0, height: spaceHeight),
              rowBlock1(context: context, iconWidth: iconWidth, iconHeigth: iconHeight),
              createSpace(context: context, width: 0, height: spaceHeight),
            ]
          );
          }
        
        if ((rowCount==index+1)&&(ext==2)){
          return Column(
            children:[
              createSpace(context: context, width: 0, height: spaceHeight),
              rowBlock2(context: context, iconWidth: iconWidth, iconHeigth: iconHeight),
              createSpace(context: context, width: 0, height: spaceHeight),
            ]
          );
          }

        else{
          return Column(
            children:[
              createSpace(context: context, width: 0, height: spaceHeight),
              rowBlock3(context: context, iconWidth: iconWidth, iconHeigth: iconHeight),
              createSpace(context: context, width: 0, height: spaceHeight),
            ]
          );
          }

        },
      )
    );
  }
}


Widget returnProfile({required double width, required double height}){
  
  return InkWell(
    onTap: (){
      print("Clicked!!!");
    },
    child: Column(

      children: [
        Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: const DecorationImage(
            image: AssetImage('assets/newjeans.jpg'),
            fit: BoxFit.contain       
            ),
          border: Border.all(
            color: const Color.fromARGB(255, 255, 99, 159),
            width: width*0.04,
          ),
        ),
        ),

        const SizedBox(
          height: spaceBetweenContainerText,),
          
        const Text(
          'name',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w200,
            color:Color.fromARGB(221, 70, 70, 70)
          )
        )
      ]
    )
  );
}

Widget returnSpaceProfile({required double width, required double height}){

  return InkWell(
    child: Container(
      width: width,
      height: height,
    )
  );
}

Widget rowBlock3({required BuildContext context, required double iconWidth,
                required double iconHeigth}){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children:[
      returnProfile(width: iconWidth, height: iconHeight),
      returnProfile(width: iconWidth, height: iconHeight),
      returnProfile(width: iconWidth, height: iconHeight),
    ]
  );
}

Widget rowBlock2({required BuildContext context, required double iconWidth,
                required double iconHeigth}){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children:[
      returnProfile(width: iconWidth, height: iconHeight),
      returnProfile(width: iconWidth, height: iconHeight),
      returnSpaceProfile(width: iconWidth, height: iconHeight),
    ]
  );
}

Widget rowBlock1({required BuildContext context, required double iconWidth,
                required double iconHeigth}){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children:[
      returnProfile(width: iconWidth, height: iconHeight),
      returnSpaceProfile(width: iconWidth, height: iconHeight),
      returnSpaceProfile(width: iconWidth, height: iconHeight),
    ]
  );
}

Widget createSpace({required BuildContext context, required double width, required double height}){
  final double realHeight = MediaQuery.of(context).size.height;
  final int numberOfRow = 3;
  return SizedBox(
    width: 1,
    height: (realHeight-numberOfRow*(iconHeight+spaceBetweenContainerText+16)
              -main.bottomNavigationBarHeight-main.appBarHeight)/(numberOfRow*2),
  );
}

//https://memostack.tistory.com/329