

import 'package:flutter/material.dart';
import 'package:journalapp/screens/auth_wrapper.dart';


class MyJournalApp extends StatelessWidget {
  const MyJournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Journal App',
      debugShowCheckedModeBanner: false,
      home : const AuthWrapper(),
    );
  }
}