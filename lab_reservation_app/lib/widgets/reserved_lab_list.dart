import 'package:flutter/material.dart';
import 'package:lab_reservation_app/models/reservation_model.dart';
import 'package:lab_reservation_app/widgets/lab_list.dart';

class ReservedListPage extends StatelessWidget {
  final List<Reservation> reservations;
  final Function(Reservation) deleteReservation;

  ReservedListPage(this.reservations, this.deleteReservation);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserved Lab List'),
      ),
      body: _buildReservedList(),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LabList()),
          );
        },
        child: Text('Return to List of Labs'),
      ),
    );
  }

  Widget _buildReservedList() {
    if (reservations.isEmpty) {
      return Center(
        child: Text('No reservations yet.'),
      );
    } else {
      return ListView.builder(
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          Reservation reservation = reservations[index];

          return ListTile(
            title: Text('Lab: ${reservation.lab.name}'),
            subtitle: Text(
              'Reserved by: ${reservation.name}\n'
              'User Type: ${reservation.userType == UserType.student ? 'Student' : 'Lecturer'}\n'
              'Date: ${reservation.date}\nTime: ${reservation.time}',
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                deleteReservation(reservation);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LabList()),
                );
              },
            ),
          );
        },
      );
    }
  }
}
