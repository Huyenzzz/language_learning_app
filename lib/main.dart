import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:language_learning_app/auth/auth_page.dart';
import 'package:language_learning_app/auth/main_page.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // demoProjectId: "demo-project-id",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // localizationsDelegates: [
      //   AppLocalizations.delegate,
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate
      // ],
      title: "o2",
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      // routes: {
      //   '/': (context) => const MainPage(),
      //   '/login': (context) => const AuthPage()
      // },
    );
  }
}
