import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:graduationproject/admin_screens/admin_dashboard.dart';
import 'screens/welcome_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyA6A9by5KZWiUOquAyz0tG-i9CIUWfFiTw",
      appId: "1:406420749747:android:86b25f1300feebd9b45fc6",
      messagingSenderId: "406420749747",
      projectId: "graduation-project-fdc47",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Learnin App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: WelcomeSceen(),
    );
  }
}
