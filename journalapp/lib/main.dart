import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journalapp/Data/data.dart';
import 'package:journalapp/firebase_options.dart';
import 'package:journalapp/screens/app.dart';

Future<void> main() async {
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
 );
 await loadJournalEntries();

 runApp(const ProviderScope(child: MyJournalApp()));
}