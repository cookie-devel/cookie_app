import 'dart:io';
import 'signin.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

void main() {
  runApp(const SignUp());
}

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ko', 'KR'),
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
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _pwCheckController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();

  // Check
  bool _pwCheckErrorText = true;
  bool _idlengthCheck = false;
  bool _pwlengthCheck = false;
  bool _namelengthCheck = false;

  // password visible check
  bool _obscureText = true;
  bool _obscureText1 = true;

  // signup input data
  String _selectedDate = ''; //2023-04-02
  final String _selectedID = ''; //ID
  final String _selectedPW = ''; //password
  final String _selectedCheckPW = ''; //check password
  final String _selectedName = ''; //cookie
  final String _selectedPhoneNumber = ''; //01000000000

  // initialize image file
  File? _imageFile;

  // image picker
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
          title: const Text('새로운 프로필사진'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  child: const Text('갤러리에서 가져오기'),
                  onTap: () {
                    _getImage(context, ImageSource.gallery);
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  child: const Text('카메라로 촬영하기'),
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

  // jsondata to server
  Future<Map<String, dynamic>> sendDataToServer(String data) async {
    try {
      String address = "http://test.parkjb.com/account/signup";
      http.Response res = await http.post(Uri.parse(address),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: data);

      return json.decode(res.body);
    } 
    
    catch (e) {
      print('Error sending data to server: $e');
      return {'error': 'Error sending data to server'};
    }
  }

  // creadte json structure
  String createJsonData(
      String id, String pw, String name, String date, String phoneNumber) {
    Map<String, dynamic> data = {
      "userid": id,
      "password": pw,
      "username": name,
      "birthday": date,
      "phone": phoneNumber,
      "profile": {
        "image": "https://i.imgur.com/1Q9ZQ9r.png",
        "message": "Hello, I'm new here!"
      }
    };

    String jsonData = const JsonEncoder.withIndent('\t').convert(data);

    return jsonData;
  }

  bool allCheck(
      idlengthCheck, pwlengthCheck, pwCheckErrorText, namelengthCheck) {
    if (idlengthCheck == true &&
        pwlengthCheck == true &&
        pwCheckErrorText == true &&
        namelengthCheck == true) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = _selectedDate;
    _idController.text = _selectedID;
    _pwController.text = _selectedPW;
    _pwCheckController.text = _selectedCheckPW;
    _nameController.text = _selectedName;
    _phonenumberController.text = _selectedPhoneNumber;
  }

  @override
  void dispose() {
    // Dispose the TextEditingController
    _dateController.dispose();
    _idController.dispose();
    _pwController.dispose();
    _pwCheckController.dispose();
    _nameController.dispose();
    _phonenumberController.dispose();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final RegExp _regex = RegExp(r'^[a-zA-Z0-9!@#\$&*~-]+$');
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            resizeToAvoidBottomInset: true,
            // appBar: AppBar(
            //   title: Text('Sign Up'),
            // ),

            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 45),

                  // Profile Image
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: _imageFile == null
                        ? const Center(child: Text('No Images'))
                        : Image.file(_imageFile!),
                  ),

                  const SizedBox(height: 10),
                  ElevatedButton(
                    child: const Text('Select Image'),
                    onPressed: () {
                      _showSelectionDialog(context);
                    },
                  ),

                  // ID
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(_regex),
                      ],
                      onChanged: (text) {
                        setState(() {
                          if (text.length < 6) {
                            _idlengthCheck = false;
                          } else {
                            _idlengthCheck = true;
                          }
                        });
                      },
                      controller: _idController,
                      obscureText: false,
                      maxLength: 30,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(90.0),
                        ),
                        labelText: '아이디',
                        helperText: '최소 6자 이상 입력해주세요.',
                        helperStyle: TextStyle(
                            color: !_idlengthCheck ? Colors.red : Colors.green),
                      ),
                    ),
                  ),

                  // Password
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(_regex),
                      ],
                      onChanged: (text) {
                        setState(() {
                          if (text.length < 10) {
                            _pwlengthCheck = false;
                          } else {
                            _pwlengthCheck = true;
                          }
                          if (text != _pwCheckController.text) {
                            _pwCheckErrorText = false;
                          } else {
                            _pwCheckErrorText = true;
                          }
                        });
                      },
                      controller: _pwController,
                      obscureText: _obscureText,
                      maxLength: 30,
                      decoration: InputDecoration(
                        labelText: '비밀번호',
                        helperText: '최소 10자 이상 입력해주세요.',
                        helperStyle: TextStyle(
                            color: !_pwlengthCheck ? Colors.red : Colors.green),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(90.0),
                        ),
                      ),
                    ),
                  ),

                  // check Password
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(_regex),
                      ],
                      controller: _pwCheckController,
                      obscureText: _obscureText1,
                      maxLength: 30,
                      onChanged: (text) {
                        setState(() {
                          if (text != _pwController.text) {
                            _pwCheckErrorText = false;
                          } else {
                            _pwCheckErrorText = true;
                          }
                        });
                      },
                      decoration: InputDecoration(
                        labelText: '비밀번호 확인',
                        helperText: _pwCheckErrorText
                            ? '비밀번호가 일치합니다.'
                            : '비밀번호가 일치하지 않습니다.',
                        helperStyle: TextStyle(
                            color:
                                _pwCheckErrorText ? Colors.green : Colors.red),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText1
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText1 = !_obscureText1;
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
                      controller: _nameController,
                      obscureText: false,
                      maxLength: 10,
                      onChanged: (text) {
                        setState(() {
                          if (text.isEmpty) {
                            _namelengthCheck = false;
                          } else {
                            _namelengthCheck = true;
                          }
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(90.0),
                        ),
                        helperText: '최소 1자 이상 입력해주세요.',
                        helperStyle: TextStyle(
                            color:
                                !_namelengthCheck ? Colors.red : Colors.green),
                        labelText: '이름',
                      ),
                    ),
                  ),

                  // Birth Date
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextField(
                      controller: _dateController,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(90.0),
                        ),
                        labelText: '생년월일',
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        DatePicker.showDatePicker(
                          context,
                          showTitleActions: true,
                          minTime: DateTime(1900, 1, 1),
                          maxTime: DateTime(2100, 12, 31),
                          onConfirm: (date) {
                            setState(() {
                              int daysInMonth =
                                  DateTime(date.year, date.month + 1, 0).day;
                              if (date.day > daysInMonth) {
                                date = DateTime(
                                    date.year, date.month, daysInMonth);
                              }
                              String month =
                                  date.month.toString().padLeft(2, '0');
                              String day = date.day.toString().padLeft(2, '0');
                              _selectedDate = '${date.year}-$month-$day';
                              _dateController.text = _selectedDate;
                            });
                          },
                          currentTime: DateTime(2000, 7, 15),
                          // locale: LocaleType.ko,
                        );
                      },
                    ),
                  ),

                  // Phone Number
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: _phonenumberController,
                      obscureText: false,
                      maxLength: 11,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(90.0),
                        ),
                        labelText: '전화번호 ( \'-\' 없이 입력 )',
                      ),
                      keyboardType: TextInputType.phone,
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
                        onPressed:() async{

                          BuildContext context = this.context;

                          String jsonData = createJsonData(
                              _idController.text,
                              _pwController.text,
                              _nameController.text,
                              _dateController.text,
                              _phonenumberController.text);
                          

                          Map<String, dynamic> jsonMap = await sendDataToServer(jsonData);
                          bool success = jsonMap['success'];
                          
                          Map<String, dynamic> account = {};
                          int errorCode = 0;
                          String errorMessage = '';

                          if (success){
                            Map<String, dynamic> account = jsonMap['account'];
                          }
                          else{
                            int errorCode = jsonMap['error_code'];
                            String errorMessage = jsonMap['message'];
                          }

                          bool valid = allCheck(_idlengthCheck, _pwlengthCheck,
                              _pwCheckErrorText, _namelengthCheck);
                          bool successCheck = valid && success;

                          if (!mounted) return;

                          if (successCheck == true) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('알림'),
                                  content: const Text('회원가입이 완료되었습니다.'),
                                  actions: [
                                    TextButton(
                                      child: const Text('확인'),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const SignInWidget()),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('알림'),
                                  content: Text('회원가입에 실패하였습니다.\n$errorMessage'),
                                  actions: [
                                    TextButton(
                                      child: const Text('확인'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
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
