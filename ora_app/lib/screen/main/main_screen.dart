import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Stack(
      children: [
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            // 카드 모양을 둥글게 설정
            borderRadius: BorderRadius.circular(16.0), // 원하는 반지름 설정
          ),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'Home ',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            onPressed: () {
              // 버튼을 눌렀을 때 실행할 동작
            },
            child: Image.asset(
              'images/assets/capture.PNG', // 여기에 이미지 경로를 넣으세요
              width: 50, // 이미지 크기 조절
              height: 50,
            ),
            backgroundColor: Colors.white,
          ),
        ),
      ],
    ));
  }
}
