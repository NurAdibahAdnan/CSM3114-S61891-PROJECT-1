import 'package:flutter/material.dart';
import 'package:lab_reservation_app/widgets/lab_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FTKKI Lab Reservation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor:  Color.fromARGB(255, 95, 161, 120),
          brightness: Brightness.dark,
          surface: Color.fromARGB(255, 4, 66, 31),
        ),
        scaffoldBackgroundColor: Color.fromARGB(255, 0, 36, 36),
      ),
      home: LabList(),
    );
  }
}