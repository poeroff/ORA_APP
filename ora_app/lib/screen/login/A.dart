import 'package:flutter/material.dart';

class AScreen extends StatefulWidget {
  const AScreen({super.key, required this.authority});

  final authority;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AScreenState();
  }
}

class AScreenState extends State<AScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: '이메일',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '비밀번호',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  child: Text(
                    '로그인',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff4255F8),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // 4픽셀의 둥근 모서리
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  child: Text(
                    '회원가입',
                    style: TextStyle(color: Color(0xff4255F8), fontSize: 14),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.blue),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // 4픽셀의 둥근 모서리
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
              SizedBox(height: 20),
              Text('SNS계정으로 로그인', textAlign: TextAlign.center),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(backgroundColor: Colors.yellow, radius: 20),
                  SizedBox(width: 20),
                  CircleAvatar(backgroundColor: Colors.blue, radius: 20),
                  SizedBox(width: 20),
                  CircleAvatar(backgroundColor: Colors.green, radius: 20),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('아이디 찾기'),
                  Text('비밀번호 찾기'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
