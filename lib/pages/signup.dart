import 'dart:io';
import 'package:cookie_app/handler/account.validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cookie_app/pages/signin.dart';
import 'package:cookie_app/cookie.appbar.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:cookie_app/components/ImageSelection.dart';
import 'package:cookie_app/handler/signup.handler.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _pwCheckController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();

  // Check
  bool _pwCheckErrorText = false;
  bool _isValidID = false;
  bool _isValidPW = false;
  bool _isValidName = false;

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

  File? _imageFile;

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: cookieAppbar(context, '회원가입'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(10, 45, 10, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Profile Image
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey,
                    width: 2,
                  ),
                ),
                child: _imageFile == null
                    ? const Center(
                        child: Text('이미지가 없습니다'),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),

              const SizedBox(height: 10),

              // select image button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.black45, width: 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('이미지 불러오기'),
                onPressed: () async {
                  final imageSelectionDialog = ImageSelectionDialog();
                  final imageFile = await imageSelectionDialog.show(context);
                  setState(() {
                    if (imageFile != null) {
                      _imageFile = File(imageFile.path);
                    }
                  });
                },
              ),

              // ID
              Container(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(IDPW_REGEX),
                  ],
                  onChanged: (text) {
                    setState(() {
                      _isValidID = isValidID(text);
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
                    helperText: _isValidID ? null : '최소 6자 이상 입력해주세요.',
                    helperStyle: TextStyle(
                      color: !_isValidID ? Colors.red : Colors.green,
                    ),
                  ),
                ),
              ),

              // Password
              Container(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(IDPW_REGEX),
                  ],
                  onChanged: (text) {
                    setState(() {
                      _isValidPW = isValidPW(text);
                      _pwCheckErrorText =
                          isValidPWCheck(text, _pwCheckController.text);
                    });
                  },
                  controller: _pwController,
                  obscureText: _obscureText,
                  maxLength: 30,
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                    helperText: _isValidPW ? null : '최소 10자 이상 입력해주세요.',
                    helperStyle: TextStyle(
                      color: !_isValidPW ? Colors.red : Colors.green,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
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
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(IDPW_REGEX),
                  ],
                  controller: _pwCheckController,
                  obscureText: _obscureText1,
                  maxLength: 30,
                  onChanged: (text) {
                    setState(() {
                      _pwCheckErrorText =
                          isValidPWCheck(_pwController.text, text);
                    });
                  },
                  decoration: InputDecoration(
                    labelText: '비밀번호 확인',
                    helperText:
                        _pwCheckErrorText ? '비밀번호가 일치합니다.' : '비밀번호가 일치하지 않습니다.',
                    helperStyle: TextStyle(
                      color: _pwCheckErrorText ? Colors.green : Colors.red,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText1 ? Icons.visibility : Icons.visibility_off,
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
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: TextField(
                  controller: _nameController,
                  obscureText: false,
                  maxLength: 10,
                  onChanged: (text) {
                    setState(() {
                      _isValidName = isValidName(text);
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(90.0),
                    ),
                    helperText: _isValidName ? null : '최소 1자 이상 입력해주세요.',
                    helperStyle: TextStyle(
                      color: !_isValidName ? Colors.red : Colors.green,
                    ),
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
                              date.year,
                              date.month,
                              daysInMonth,
                            );
                          }
                          String month = date.month.toString().padLeft(2, '0');
                          String day = date.day.toString().padLeft(2, '0');
                          _selectedDate = '${date.year}-$month-$day';
                          _dateController.text = _selectedDate;
                        });
                      },
                      currentTime: DateTime(2000, 1, 1),
                    );
                  },
                ),
              ),

              // Phone Number
              Container(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
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
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: Colors.black45, width: 2),
                    ),
                  ),
                  child: const Text(
                    '회원가입',
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    bool success = isValidSignUp(
                          _idController.text,
                          _pwController.text,
                          _pwCheckController.text,
                          _nameController.text,
                          _dateController.text,
                          _phonenumberController.text,
                        ) &&
                        await signupHandler(
                          _idController.text,
                          _pwController.text,
                          _pwCheckController.text,
                          _nameController.text,
                          _dateController.text,
                          _phonenumberController.text,
                        );
                    success
                        ? Future<void>.microtask(() {
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
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SignInWidget(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          })
                        : Future<void>.microtask(() {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('알림'),
                                  content: const Text('회원가입에 실패하였습니다.\n'),
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
                          });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
