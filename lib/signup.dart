import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

void main() {
  runApp(SignUp());
}

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('ko', 'KR'),
      ],
      home: SignUpWidget(),
    );
  }
}


class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignUpWidgetState();
}


class _SignUpWidgetState extends State<SignUpWidget> {

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _IDController = TextEditingController();
  final TextEditingController _PWController = TextEditingController();
  final TextEditingController _NameController = TextEditingController();
  final TextEditingController _PhoneNumberController = TextEditingController();


  String _selectedDate = '2023-04-02';
  String _selectedID = 'ID';
  String _selectedPW = 'password';
  String _selectedName = 'cookie';
  String _selectedPhoneNumber = '01000000000';

  bool _obscureText = true;

  File? _imageFile;

  void _getImage(BuildContext context, ImageSource source) async {
    
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('Image deselected');
      }
    });

    Navigator.pop(context);
  }

  void _showSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Upload Image'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  child: Text('Upload from Gallery'),
                  onTap: () {
                    _getImage(context, ImageSource.gallery);
                  },
                ),
                SizedBox(height: 20),
                GestureDetector(
                  child: Text('Upload from Camera'),
                  onTap: () {
                    _getImage(context, ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = _selectedDate;
    _IDController.text = _selectedID;
    _PWController.text = _selectedPW;
    _NameController.text = _selectedName;
    _PhoneNumberController.text = _selectedPhoneNumber;
  }

  @override
  void dispose() {
    // Dispose the TextEditingController
    _dateController.dispose();
    _IDController.dispose();
    _PWController.dispose();
    _NameController.dispose();
    _PhoneNumberController.dispose();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    print(_dateController.text);
    print(_IDController.text);
    print(_PWController.text);
    print(_NameController.text);
    print(_PhoneNumberController.text);

    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: Text('Sign Up'),
            ),
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  // Profile Image
                  Container(

                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                      color: Colors.grey,
                      width: 1,
                      ),
                    ),
                    child: _imageFile == null
                        ? Center(
                            child: Text('이미지가 없습니다.'),
                          )
                        : Image.file(_imageFile!),
                    
                    // padding: const EdgeInsets.fromLTRB(20, 20, 20, 70),
                    // decoration: BoxDecoration(
                    //   shape: BoxShape.circle,
                    //   image: const DecorationImage(
                    //       image: AssetImage('assets/images/newjeans.jpg'), fit: BoxFit.contain),
                    //   border: Border.all(
                    //     color: const Color.fromARGB(255, 255, 99, 159),
                    //   ),
                    // ),
                  ),
                  
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text('이미지 추가'),
                    onPressed: () {
                      _showSelectionDialog(context);
                    },
                  ),

                  // ID
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextField(
                      controller: _IDController,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(90.0),
                        ),
                        labelText: 'ID',
                      ),
                    ),
                  ),

                  // Password
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextField(        
                      controller: _PWController,   
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText; // 값 반전
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(90.0),
                        ),
                      ),
                    ),
                  ),

                  // Name
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextField(
                      controller: _NameController,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(90.0),
                        ),
                        labelText: 'Name',
                      ),
                    ),
                  ),

                  // Birth Date
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextField(
                      controller:  _dateController,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(90.0),
                        ),
                        labelText: 'Birth date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () {
                        DatePicker.showDatePicker(
                          context,
                          showTitleActions: true,
                          minTime: DateTime(1900),
                          maxTime: DateTime(2100),
                          onConfirm: (date) {
                            setState(() {
                              String month = date.month.toString().padLeft(2, '0');
                              String day = date.day.toString().padLeft(2, '0');
                              _selectedDate = '${date.year}-${month}-${day}';
                              _dateController.text = _selectedDate;
                            });
                          },
                          currentTime: DateTime.now(),
                          // locale: LocaleType.ko,
                        );
                      },
                    ),
                  ),

                  // Phone Number
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextField(
                      controller: _PhoneNumberController,
                      obscureText: false,
                      maxLength: 11,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(90.0),
                        ),
                        labelText: 'Phone number ( \'-\' 없이 입력)',
                      ),
                    ),
                  ),

                  // Sign up
                  Container(
                      height: 80,
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text('Sign up'),
                        onPressed: () {
                          
                        },
                      ) 
                  ),
                ],
              ),
            )
          )
        );
  }
}
