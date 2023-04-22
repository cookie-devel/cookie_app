import 'package:cookie_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cookie_app/signup.dart';
import 'package:cookie_app/design.dart';
import 'package:cookie_app/handler/storage.dart';
import 'package:cookie_app/components/signin/handler_signin.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  bool _isStorageExist = false;
  bool _isLoading = true;

  bool _idlengthCheck = false;
  bool _pwlengthCheck = false;
  bool _idCheck = true;
  bool _pwCheck = true;
  bool _obscureText = true;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  final String _selectedID = ''; //ID
  final String _selectedPW = ''; //password

  final RegExp _regex = RegExp(r'^[a-zA-Z0-9!@#\$&*~-]+$');

  @override
  void initState() {
    super.initState();
    _idController.text = _selectedID;
    _pwController.text = _selectedPW;
    checkStorage();
  }

  Future<void> checkStorage() async {
    final id = await storage.read(key: 'id');
    final pw = await storage.read(key: 'pw');
    // print(id);
    // print(pw);
    // print("===========");
    await Future.delayed(const Duration(milliseconds: 860));

    if (id != null && pw != null) {
      setState(() {
        _isStorageExist = true;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isStorageExist = false;
        _isLoading = false;
      });
    }
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
    if (_isLoading) {
      return isLoadingScreen();
    } else {
      if (_isStorageExist) {
        return const MyStatefulWidget();
      }
    }

    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: cookieAppbar(context, 'c🍪🍪kie'),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 50),

              // Logo
              Container(
                width: 110,
                height: 110,
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
                    helperText: (_idlengthCheck && _idCheck)
                        ? null
                        : '최소 6자 이상 입력해주세요.',
                    helperStyle: TextStyle(
                      color: !_idlengthCheck ? Colors.red : Colors.green,
                    ),
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
                    helperText: (_pwlengthCheck && _pwCheck)
                        ? null
                        : '최소 10자 이상 입력해주세요.',
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
                ),
              ),

              const SizedBox(height: 30),

              // Log In
              Container(
                width: 330,
                height: 80,
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text(
                    '로그인',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    // id, pw를 json 형식으로 반환
                    String SigninData = createJsonData(
                      _idController.text,
                      _pwController.text,
                    );

                    Map<String, dynamic> jsonMap =
                        await sendDataToServer(SigninData);

                    // 로그인 실패했을 경우도 success 여부 반환해야함!
                    bool success = jsonMap['success'];

                    bool valid = allCheck(_idlengthCheck, _pwlengthCheck);
                    bool successCheck = valid && success;

                    if (!_pwlengthCheck) {
                      _pwCheck = false;
                    } else {
                      _pwCheck = true;
                    }
                    if (!_idlengthCheck) {
                      _idCheck = false;
                    } else {
                      _idCheck = true;
                    }

                    if (!mounted) return;

                    if (successCheck) {
                      // 사용자 정보를 저장합니다.
                      await storage.write(key: 'id', value: _idController.text);
                      await storage.write(key: 'pw', value: _pwController.text);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyStatefulWidget(),
                        ),
                      );
                    } else {
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
                    }

                    print("LogIn button pressed");
                  },
                ),
              ),

              // sign up
              Container(
                width: 330,
                height: 80,
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text(
                    '회원가입',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpWidget(),
                      ),
                    );
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
