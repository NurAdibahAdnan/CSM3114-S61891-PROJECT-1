import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab_reservation_app/data/dummy_reservation.dart';
import 'package:lab_reservation_app/models/lab_model.dart';
import 'package:lab_reservation_app/models/reservation_model.dart';
import 'package:lab_reservation_app/widgets/reserved_lab_list.dart';

class ReservationScreen extends StatefulWidget {
  final Lab lab;
  final Function(Lab) updateLabAvailability; // Add this line

  ReservationScreen(this.lab, {required this.updateLabAvailability});

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  UserType _selectedUserType = UserType.student; 

  void _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate == null) {
      return;
    }
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

//method to submit form to the lab reserved list
  void _submitForm() {
  if (_formKey.currentState?.validate() ?? false) {
    String name = _nameController.text;

    if (_selectedDate != null && _selectedTime != null) {
      DateTime reservationDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      // Check if the lab is already reserved at the selected date and time
      if (isLabAvailable(widget.lab, reservationDateTime)) {
        Reservation newReservation = Reservation(
          lab: widget.lab,
          name: name,
          date: reservationDateTime,
          time: _selectedTime!.format(context),
          userType: _selectedUserType,
        );

        reservations.add(newReservation);

        // Update lab availability using the passed method
        widget.updateLabAvailability(widget.lab);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ReservedListPage(reservations, deleteReservation),
          ),
        );
      } else {
        // Lab is already reserved, show an error message or handle accordingly
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Lab Not Available'),
              content: Text('The lab is already reserved at the selected date and time.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }
}

bool isLabAvailable(Lab lab, DateTime selectedDateTime) {
  // Check if the lab is available at the selected date and time
  return !reservations.any((reservation) =>
      reservation.lab == lab &&
      reservation.date == selectedDateTime &&
      reservation.userType == _selectedUserType);
}

  void deleteReservation(Reservation reservation) {
    setState(() {
      reservation.lab.updateAvailability(true); // Set availability back to true
      reservations.remove(reservation);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserve ${widget.lab.name}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Please fill the form below to reserve for the lab..!'),
              SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Your Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: _selectDate,
                        child: Text('Select Date'),
                      ),
                      SizedBox(height: 16),
                      _selectedDate != null
                          ? Text(
                              'Selected Date: ${DateFormat('MM/dd/yyyy').format(_selectedDate!)}')
                          : Text('No date selected'),
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: _selectTime,
                        child: Text('Select Time'),
                      ),
                      SizedBox(height: 16),
                      _selectedTime != null
                          ? Text(
                              'Selected Time: ${_selectedTime!.format(context)}')
                          : Text('No time selected'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DropdownButtonFormField<UserType>(
                      value: _selectedUserType,
                      onChanged: (UserType? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedUserType = newValue;
                          });
                        }
                      },
                      items: UserType.values.map((UserType userType) {
                        return DropdownMenuItem<UserType>(
                          value: userType,
                          child: Text(
                              userType == UserType.student ? 'Student' : 'Lecturer'),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'User Type',
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Submit Reservation'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
