// import 'package:flutter/material.dart';
// import 'package:ora_app/screen/login/chat_screen.dart';
// import 'package:ora_app/screen/login_screen.dart';
// import 'package:ora_app/screen/main/main_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => HomeScreenState();
// }

// class HomeScreenState extends State<HomeScreen> {
//   int currentPageIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     final ThemeData theme = Theme.of(context);
//     return Scaffold(
//       extendBody: true,
//       bottomNavigationBar: Stack(
//         clipBehavior: Clip.none,
//         alignment: Alignment.topCenter,
//         children: [
//           NavigationBar(
//             height: 60,
//             onDestinationSelected: (int index) {
//               setState(() {
//                 currentPageIndex = index;
//                 if (index == 3) {
//                   _showLogoutDialog(context);
//                 }
//               });
//             },
//             indicatorColor: Colors.amber,
//             selectedIndex: currentPageIndex,
//             destinations: const <Widget>[
//               NavigationDestination(
//                 selectedIcon: Icon(Icons.home),
//                 icon: Icon(
//                   Icons.home_outlined,
//                 ),
//                 label: '홈',
//               ),
//               NavigationDestination(
//                 icon: Badge(
//                     child: Icon(
//                   Icons.calendar_today,
//                   size: 24,
//                 )),
//                 label: '예약',
//               ),
//               NavigationDestination(
//                 icon: Badge(
//                   label: Text('2'),
//                   child: Icon(Icons.settings),
//                 ),
//                 label: '설정',
//               ),
//               NavigationDestination(
//                 selectedIcon: Icon(Icons.logout_outlined),
//                 icon: Icon(Icons.logout),
//                 label: '로그아웃',
//               ),
//             ],
//           ),
//           Positioned(
//             top: -15, // 버튼을 위로 올립니다.
//             child: GestureDetector(
//               onTap: () {
//                 print("HELLO");
//                 Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => const ChatScreen()));
//               },
//               child: Container(
//                 width: 60,
//                 height: 60,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       spreadRadius: 1,
//                       blurRadius: 3,
//                       offset: Offset(0, 1),
//                     ),
//                   ],
//                 ),
//                 child: ClipOval(
//                   child: Image.asset(
//                     'images/assets/capture.PNG',
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: <Widget>[
//         /// Home page
//         MainScreen(),

//         /// Notifications page
//         const Padding(
//           padding: EdgeInsets.all(1.0),
//           child: Column(
//             children: <Widget>[
//               Card(
//                 child: ListTile(
//                   leading: Icon(Icons.notifications_sharp),
//                   title: Text('Notification 1'),
//                   subtitle: Text('This is a notification'),
//                 ),
//               ),
//               Card(
//                 child: ListTile(
//                   leading: Icon(Icons.notifications_sharp),
//                   title: Text('Notification 2'),
//                   subtitle: Text('This is a notification'),
//                 ),
//               ),
//             ],
//           ),
//         ),

//         /// Messages page
//         ListView.builder(
//           reverse: true,
//           itemCount: 2,
//           itemBuilder: (BuildContext context, int index) {
//             if (index == 0) {
//               return Align(
//                 alignment: Alignment.centerRight,
//                 child: Container(
//                   margin: const EdgeInsets.all(1.0),
//                   padding: const EdgeInsets.all(1.0),
//                   decoration: BoxDecoration(
//                     color: theme.colorScheme.primary,
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   child: Text(
//                     'Hello',
//                     style: theme.textTheme.bodyLarge!
//                         .copyWith(color: theme.colorScheme.onPrimary),
//                   ),
//                 ),
//               );
//             }
//             return Align(
//               alignment: Alignment.centerLeft,
//               child: Container(
//                 margin: const EdgeInsets.all(8.0),
//                 padding: const EdgeInsets.all(8.0),
//                 decoration: BoxDecoration(
//                   color: theme.colorScheme.primary,
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: Text(
//                   'Hi!',
//                   style: theme.textTheme.bodyLarge!
//                       .copyWith(color: theme.colorScheme.onPrimary),
//                 ),
//               ),
//             );
//           },
//         ),
//         Card(
//           shadowColor: Colors.transparent,
//           margin: const EdgeInsets.all(8.0),
//           child: SizedBox.expand(
//             child: Center(
//               child: Text(
//                 'Home page',
//                 style: theme.textTheme.titleLarge,
//               ),
//             ),
//           ),
//         ),
//       ][currentPageIndex],
//     );
//   }

//   void _showLogoutDialog(BuildContext context) {
//     showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
//                 color: Theme.of(context).colorScheme.onPrimaryContainer,
//               ),
//           backgroundColor: Theme.of(context).colorScheme.primaryContainer,
//           iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
//           contentTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                 color: Theme.of(context).colorScheme.onPrimaryContainer,
//               ),
//           title: const Text('로그아웃'),
//           content: const Text('정말 로그아웃하시겠습니까?'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('취소'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 Navigator.of(context).pushReplacement(MaterialPageRoute(
//                     builder: (context) => const LoginScreen(
//                           authority: "OWNER",
//                         )));
//                 SharedPreferences prefs = await SharedPreferences.getInstance();
//                 await prefs.setBool('isLoggedIn', false);
//               },
//               child: const Text('확인'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:ora_app/screen/login/chat_screen.dart';
import 'package:ora_app/screen/login_screen.dart';
import 'package:ora_app/screen/main/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Stack(
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
            child: GestureDetector(
              onTap: () {
                print("HELLO");
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ChatScreen()));
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
                      offset: Offset(0, 1),
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
            ),
          ),
        ],
      ),
      body: <Widget>[
        MainScreen(),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 1'),
                  subtitle: Text('This is a notification'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 2'),
                  subtitle: Text('This is a notification'),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          reverse: true,
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Hello',
                    style: theme.textTheme.bodyLarge!
                        .copyWith(color: theme.colorScheme.onPrimary),
                  ),
                ),
              );
            }
            return Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'Hi!',
                  style: theme.textTheme.bodyLarge!
                      .copyWith(color: theme.colorScheme.onPrimary),
                ),
              ),
            );
          },
        ),
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'Home page',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
        ),
      ][currentPageIndex],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
          contentTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
          title: const Text('로그아웃'),
          content: const Text('정말 로그아웃하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const LoginScreen(
                          authority: "OWNER",
                        )));
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
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
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, Icons.home_outlined, '홈', 0),
          _buildNavItem(
              Icons.calendar_today, Icons.calendar_today_outlined, '예약', 1),
          SizedBox(width: 60), // 가운데 버튼을 위한 공간
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
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : unselectedIcon,
              color: isSelected ? Color(0xff4255F8) : Colors.black,
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Color(0xff4255F8) : Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
