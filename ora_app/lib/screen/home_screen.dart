import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ora_app/model/reservation.dart';
import 'package:ora_app/provider/today_reservation.dart';
import 'package:ora_app/screen/ai_chat/chat_screen.dart';
import 'package:ora_app/screen/login_screen.dart';
import 'package:ora_app/screen/main/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;
  final TodayReservation todayReservation = TodayReservation();
  List<Reservation> reservations = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  Future<void> _fetchReservations() async {
    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString("email");
      if (email != null) {
        final fetchedReservations =
            await todayReservation.today_reservation(email);
        setState(() {
          reservations = fetchedReservations;
        });
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: _buildBody(),
              ),
            ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        CustomNavigationBar(
          currentIndex: currentPageIndex,
          onTap: (index) {
            setState(() {
              currentPageIndex = index;
              if (index == 3) {
                _showLogoutDialog(context);
              }
            });
          },
        ),
        Positioned(
          top: -15,
          child: _buildChatButton(),
        ),
      ],
    );
  }

  Widget _buildChatButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ChatScreen(),
        ));
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            'images/assets/capture.PNG',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return IndexedStack(
      index: currentPageIndex,
      children: [
        MainScreen(reservations: reservations),
        const NotificationsScreen(),
        const ChatListScreen(),
        const HomePage(),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그아웃'),
          content: const Text('정말 로그아웃하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: _logout,
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const LoginScreen(authority: "OWNER"),
    ));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
  }
}

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, Icons.home_outlined, '홈', 0),
          _buildNavItem(
              Icons.calendar_today, Icons.calendar_today_outlined, '예약', 1),
          const SizedBox(width: 60),
          _buildNavItem(Icons.person, Icons.person_outline, 'MY', 2),
          _buildNavItem(Icons.more_horiz, Icons.more_horiz_outlined, '더보기', 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      IconData selectedIcon, IconData unselectedIcon, String label, int index) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : unselectedIcon,
              color: isSelected ? const Color(0xff4255F8) : Colors.black,
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xff4255F8) : Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 추가적인 화면들은 별도의 파일로 분리하는 것이 좋습니다.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Notifications Screen'));
  }
}

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Chat List Screen'));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Home Page'));
  }
}
