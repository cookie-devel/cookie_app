import 'dart:io';
import 'signup.dart';
import 'dart:convert';
import 'package:cookie_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cookie_app/signup.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const SignIn());
}

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

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
      home: SignInWidget(),
    );
  }
}

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  bool _idlengthCheck = false;
  bool _pwlengthCheck = false;
  bool _obscureText = true;

  final String _selectedID = '';          //ID
  final String _selectedPW = '';          //password

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

  bool allCheck(idlengthCheck,pwlengthCheck){
    if(idlengthCheck == true && pwlengthCheck == true){
      return true;
    }
    else{
      return false;
    }
  }

    // creadte json structure
  String createJsonData(String id, String pw) {
    Map<String, dynamic> data = {
      "userid": id,
      "password": pw

    };

    String jsonData = const JsonEncoder.withIndent('\t').convert(data);

    return jsonData;
  }

  Future<Map<String, dynamic>> sendDataToServer(String data) async {
    try {
      String address = "http://test.parkjb.com/account/signin";
      http.Response res = await http.post(Uri.parse(address),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: data);
      return json.decode(res.body);
    } catch (e) {
      print('Error sending data to server: $e');
      return {};
    }
  }

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
            
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  
                  const SizedBox(height: 45),

                  // Logo
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                          image: AssetImage('assets/images/newjeans.jpg'), fit: BoxFit.contain),
                      border: Border.all(
                        color: const Color.fromARGB(255, 255, 99, 159),
                      ),
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
                          if (text.length <6) {
                            _idlengthCheck = false;
                          } 
                          else {
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
                          if (text.length <10) {
                            _pwlengthCheck = false;
                          } 
                          else {
                            _pwlengthCheck = true;
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
                        child: const Text('로그인'),
                        onPressed: () async {
                          
                          // id, pw를 json 형식으로 반환
                          String SigninData = createJsonData(_idController.text,
                                                            _pwController.text);
                          
                          Map<String, dynamic> jsonMap = await sendDataToServer(SigninData);
                          print(jsonMap);
                          bool success = jsonMap['success'];
                          bool valid = allCheck(_idlengthCheck, _pwlengthCheck);
                          bool successCheck = valid && success;

                          if (!mounted) return;

                          if (successCheck) {
                            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MyStatefulWidget()),
                            );
                          }

                          else{
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('알림'),
                                  content: Text('로그인에 실패하였습니다.'),
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
                      ) 
                  ),

                  // sing up
                  Container(
                      width: 330,
                      height: 80,
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text('회원가입'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignUpWidget()),
                          );
                        },
                      ) 
                  ),

                ],
              ),
            ),
        ),
      );
  }
}