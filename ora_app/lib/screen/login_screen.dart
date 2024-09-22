import 'package:flutter/material.dart';
import 'package:ora_app/screen/home_screen.dart';
import 'package:ora_app/screen/login/registration_screen.dart';
import 'package:ora_app/screen/user_type_selection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.authority});

  final authority;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    _loadLoginStatus();
  }

  Future<void> _loadLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 여기에 조건을 넣습니다
        if (isLoggedIn) {
          return true; // 뒤로 가기 허용
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const UserTypeSelectionScreen()));
          return false; // 뒤로 가기 방지
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('로그인', style: TextStyle(color: Colors.black)),
          elevation: 0,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 10),
                          _buildInputField('이메일', '이메일', _emailController),
                          const SizedBox(height: 20),
                          _buildInputField('비밀번호', '비밀번호', _passwordController),
                          SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              child: Text(
                                '로그인',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff4255F8),
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen()));
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: OutlinedButton(
                              child: Text(
                                '회원가입',
                                style: TextStyle(
                                    color: Color(0xff4255F8), fontSize: 14),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Color(0xff4255F8)),
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const RegistrationScreen()));
                              },
                            ),
                          ),
                          SizedBox(height: 30),
                          Opacity(
                            opacity: 0.6,
                            child: Text(
                              'SNS계정으로 로그인',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                  backgroundImage: AssetImage(
                                      'images/assets/ico_s_kakao_talk.png'),
                                  radius: 20),
                              SizedBox(width: 20),
                              CircleAvatar(
                                  backgroundImage: AssetImage(
                                      'images/assets/btnG_아이콘원형.png')),
                              SizedBox(width: 20),
                              CircleAvatar(
                                  backgroundImage:
                                      AssetImage('images/assets/Google.png')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildBottomText('아이디 찾기'),
                    _buildBottomText('     |'),
                    _buildBottomText('     비밀번호 찾기'),
                  ],
                ),
              ),
              const SizedBox(height: 60)
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildBottomText(String text) {
  return Opacity(
    opacity: 0.8,
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.grey,
        fontSize: 14,
      ),
    ),
  );
}

Widget _buildInputField(
    String label, String hintText, TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        child: TextField(
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.black),
          controller: controller,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ),
      ),
    ],
  );
}
