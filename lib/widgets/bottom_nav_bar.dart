import 'package:flutter/material.dart';
import 'package:language_learning_app/screens/dictionary/dictionary_screen.dart';
import 'package:language_learning_app/screens/home/home_screen.dart';

import 'package:language_learning_app/screens/myTopic/my_topic_screen.dart';
import 'package:language_learning_app/screens/setting/sign_out.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;

  const BottomNavBar({super.key, required this.selectedIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == selectedIndex) return; // Nếu mục được chọn, không làm gì cả.

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DictionaryScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const MyTopicScreen(), // Chuyển đến màn hình My Topics
          ),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignOutPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex, // Chỉ số của mục đang được chọn
      onTap: (index) => _onItemTapped(context, index), // Xử lý khi nhấn vào mục
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Dictionary',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle),
          label: 'My Topics', // Đổi nhãn thành My Topics
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      selectedItemColor: Colors.blue.shade900, // Màu khi mục được chọn
      unselectedItemColor: Colors.grey, // Màu khi mục không được chọn
      backgroundColor: Colors.white, // Màu nền của thanh điều hướng
      type: BottomNavigationBarType.fixed, // Hiển thị tất cả các mục cố định
    );
  }
}
