import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:language_learning_app/screens/home/home_screen.dart';
import 'auth_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Hiển thị vòng tròn tải khi đang chờ dữ liệu
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            final user = snapshot.data!;
            if (user.emailVerified) {
              // Chỉ điều hướng đến HomeScreen nếu email đã được xác thực
              return const HomeScreen();
            } else {
              return _buildEmailVerificationScreen(user);
            }
          } else {
            // Hiển thị màn hình đăng nhập nếu chưa có người dùng
            return const AuthPage();
          }
        },
      ),
    );
  }

  Widget _buildEmailVerificationScreen(User user) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification Required'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Please verify your email address to access the application.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await user.sendEmailVerification();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Verification email sent. Please check your inbox.',
                    ),
                  ),
                );
              },
              child: const Text('Send Verification Email'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
