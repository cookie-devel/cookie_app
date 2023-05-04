import 'package:cookie_app/handler/signin.validator.dart';
import 'package:cookie_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cookie_app/pages/signup.dart';
import 'package:cookie_app/cookie.appbar.dart';
import 'package:cookie_app/handler/signinout.handler.dart';
import 'package:cookie_app/components/NavigatePage.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  bool _idlengthCheck = false;
  bool _pwlengthCheck = false;
  bool _obscureText = true;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  final String _selectedID = ''; //ID
  final String _selectedPW = ''; //password

  @override
  void initState() {
    super.initState();
    _idController.text = _selectedID;
    _pwController.text = _selectedPW;
  }

  @override
  void dispose() {
    // Dispose the TextEditingController
    _idController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: cookieAppbar(context, 'C🍪🍪KIE'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(10, 55, 10, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/cookie_logo.png'),
                    fit: BoxFit.contain,
                  ),
                  // border: Border.all(
                  //   // color: const Color.fromARGB(255, 255, 99, 159),
                  // ),
                ),
              ),

              const SizedBox(height: 30),

              // ID
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(IDPW_REGEX),
                  ],
                  onChanged: (text) {
                    setState(() {
                      _idlengthCheck = text.length < 6 ? false : true;
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
                    helperText: _idlengthCheck ? null : '최소 6자 이상 입력해주세요.',
                    helperStyle: TextStyle(
                      color: !_idlengthCheck ? Colors.red : Colors.green,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 18, // 입력 text 크기 조정
                  ),
                ),
              ),

              // Password
              Container(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(IDPW_REGEX),
                  ],
                  onChanged: (text) {
                    setState(() {
                      _pwlengthCheck = text.length < 10 ? false : true;
                    });
                  },
                  controller: _pwController,
                  obscureText: _obscureText,
                  maxLength: 30,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(90.0),
                    ),
                    labelText: '비밀번호',
                    helperText: _pwlengthCheck ? null : '최소 10자 이상 입력해주세요.',
                    helperStyle: TextStyle(
                      color: !_pwlengthCheck ? Colors.red : Colors.green,
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
                  ),
                  style: const TextStyle(
                    fontSize: 18, // 입력 text 크기 조정
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Log In
              Container(
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
                    '로그인',
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    bool signin = isValid(
                          _idController.text,
                          _pwController.text,
                        ) &&
                        await handleSignIn(
                          _idController.text,
                          _pwController.text,
                        );
                    signin
                        ? Future<void>.microtask(() {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyStatefulWidget(),
                              ),
                            );
                          })
                        : Future<void>.microtask(() {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('알림'),
                                  content: const Text('로그인에 실패하였습니다.'),
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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: const Text(
                      '> 아이디/비밀번호 찾기',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    onPressed: () {
                      // navigateSlide(context, const FindIdPwWidget());
                    },
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    child: const Text(
                      '> 회원가입',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    onPressed: () {
                      navigateSlide(context, const SignUpWidget());
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
