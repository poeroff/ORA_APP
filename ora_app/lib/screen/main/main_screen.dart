import 'package:flutter/material.dart';
import 'package:ora_app/model/reservation.dart';
import 'package:ora_app/provider/today_reservation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.reservations});

  final List<Reservation> reservations;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: ElevatedButton(
              onPressed: () {
                // 버튼 클릭 시 동작 추가
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff4255F8), // 버튼 색상
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // 둥근 모서리
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12), // 여백
              ),
              child: const Text(
                '오늘의 예약',
                style: TextStyle(color: Colors.white, fontSize: 16), // 텍스트 스타일
              ),
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 450, // 카드 높이와 동일하게 설정
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              itemCount: reservations.length, // 실제 예약 개수
              itemBuilder: (context, index) {
                final reservation = reservations[index];
                print(reservation);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color.fromARGB(255, 163, 153, 153),
                          width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10)),
                          child: Image.network(
                            'https://i.pinimg.com/736x/a7/5a/1f/a75a1f1abe4022e772b873877ef6d45d.jpg',
                            width: 300,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(reservation.company.name,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),

                              const SizedBox(height: 10),
                              const Text(
                                  '진료과목: [진료과목 정보 없음]'), // 진료과목 정보가 없으면 이 부분을 수정해야 합니다
                              const SizedBox(height: 10),
                              Text('위치: ${reservation.company.location}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
