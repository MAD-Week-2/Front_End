import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModel/appointment_view_model.dart';

import 'add_appointment_page.dart';

class AppointmentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppointmentViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('특별한 약속'),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: viewModel.appointments.length,
                itemBuilder: (context, index) {
                  final appointment = viewModel.appointments[index];
                  return ListTile(
                    title: Text('${appointment.description} (${appointment.date})'),
                    subtitle: Text('${appointment.time} - ${appointment.type}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddAppointmentPage(),
            ),
          );

          if (result != null && result is Map<String, String>) {
            viewModel.addAppointment(
              result['location']!,
              result['date']!,
              result['time']!,
              result['type']!,
            );
          }
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.add, color: Colors.white),
      ),
      backgroundColor: Colors.white,
    );
  }
}
