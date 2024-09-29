import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("계정 생성"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'images/assets/capture.PNG',
              width: 100, // 이미지의 너비 조절
              height: 100, // 이미지의 높이 조절
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //      const Padding(
                //   padding: EdgeInsets.only(left: 25, bottom: 5),
                //   child: Text(
                //     "Create an account",
                //     style: TextStyle(color: Colors.black, fontSize: 35),
                //   ),
                // ),
                const SizedBox(height: 20),
                Container(child: _buildInputField("이름 *", "Full name")),

                const SizedBox(height: 20),
                Container(child: _buildInputField("이메일 *", "Email address")),
                const SizedBox(height: 30),
                _buildEmailWithVerification(),
                const SizedBox(height: 20),
                Container(child: _buildInputField("비밀번호 *", "Password")),
                const SizedBox(height: 20),

                Container(child: _buildInputField("전화번호 *", "phone number")),
                const SizedBox(height: 40),
                _buildSignupButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25, bottom: 5),
          child: Text(
            label,
            style: const TextStyle(color: Colors.black, fontSize: 15),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: TextField(
            keyboardType: TextInputType.text,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              labelText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignupButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', false);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 102, 89, 228),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text("회원 가입", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildEmailWithVerification() {
    return Container(
      padding: const EdgeInsets.only(left: 25, bottom: 5),
      width: 400,
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: '인증번호 *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 56, // TextFormField의 기본 높이와 맞춤
              child: ElevatedButton(
                onPressed: () {
                  // 이메일 인증 로직
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: Text('인증'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
