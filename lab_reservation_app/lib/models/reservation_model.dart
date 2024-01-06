
import 'package:lab_reservation_app/models/lab_model.dart';

enum UserType {
  student,
  lecturer,
}

class Reservation {
  final Lab lab;
  final String name;
  final DateTime date;
  final String time;
  final UserType userType;

  Reservation({
    required this.lab,
    required this.name, 
    required this.date, 
    required this.time,
    required this.userType
    
    });
}


