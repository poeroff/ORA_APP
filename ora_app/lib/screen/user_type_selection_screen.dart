import 'package:flutter/material.dart';

import 'package:ora_app/screen/login_screen.dart';

class UserTypeSelectionScreen extends StatefulWidget {
  const UserTypeSelectionScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UserTypeSelectionScreenState();
  }
}

class _UserTypeSelectionScreenState extends State<UserTypeSelectionScreen> {
  bool isFirstCardSelected = false;
  bool isSecondCardSelected = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double baseFontSize = screenWidth * 0.04;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "시작전 잠깐!",
                  style: TextStyle(
                      fontSize: baseFontSize * 1.5,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff4255F8)),
                ),
                Text(
                  '어떤 서비스를 이용하시나요?',
                  style: TextStyle(
                      fontSize: baseFontSize * 1.5,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildOptionCard(
                  icon: Icons.calendar_today,
                  title: '예약을 관리하고 싶어요',
                  subtitle: '업체전용으로, \n다양한 예약관리를 할 수 있어요',
                  isSelected: isFirstCardSelected,
                  baseFontSize: baseFontSize,
                  onTap: () {
                    setState(() {
                      isFirstCardSelected = !isFirstCardSelected;
                      isSecondCardSelected = false;
                    });
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LoginScreen(
                              authority: "owner",
                            )));
                  },
                ),
                const SizedBox(height: 16),
                _buildOptionCard(
                  icon: Icons.person,
                  title: '예약을 하고 싶어요',
                  subtitle: '음성인식으로 다양한 곳을 자유롭게 예약할 수 있어요',
                  isSelected: isSecondCardSelected,
                  baseFontSize: baseFontSize,
                  onTap: () {
                    setState(() {
                      isSecondCardSelected = !isSecondCardSelected;
                      isFirstCardSelected = false;
                    });
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LoginScreen(
                              authority: "user",
                            )));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildOptionCard(
    {required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    required double baseFontSize}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: isSelected ? const Color(0xff4255F8) : Colors.white,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: baseFontSize * 1.2,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: baseFontSize * 0.9,
                      color: isSelected ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Icon(icon,
                size: 40, color: isSelected ? Colors.white : Colors.black),
          ],
        ),
      ),
    ),
  );
}
