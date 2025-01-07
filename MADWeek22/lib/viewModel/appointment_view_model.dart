import 'package:flutter/material.dart';
import '../model/appointment.dart';


class AppointmentViewModel extends ChangeNotifier {
  List<Appointment> _appointments = [];

  List<Appointment> get appointments => _appointments;

  void addAppointment(String location, String date, String time, String type) {
    _appointments.add(Appointment(description: location, date: date, time: time, type: type));
    notifyListeners();
  }
}

