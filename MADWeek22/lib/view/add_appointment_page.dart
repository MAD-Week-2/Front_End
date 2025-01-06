import 'package:flutter/material.dart';

class AddAppointmentPage extends StatefulWidget {
  @override
  _AddAppointmentPageState createState() => _AddAppointmentPageState();
}

class _AddAppointmentPageState extends State<AddAppointmentPage> {
  final locationController = TextEditingController();
  DateTime? selectedDate;
  final timeController = TextEditingController();
  final appointmentTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('새 약속 추가'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input for location
            Text(
              '약속 장소는 어디인가요?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                hintText: '장소, 버스, 역, 주소 검색',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Calendar
            Text(
              '약속 시간은 언제인가요?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Colors.black, // 날짜 선택 포인트 색
                ),
              ),
              child: CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365)),
                onDateChanged: (date) => selectedDate = date,
              ),
            ),
            SizedBox(height: 16),

            // Input for time
            TextField(
              controller: timeController,
              decoration: InputDecoration(
                hintText: '예: 8:00 AM',
                labelText: '시간 입력',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Appointment Type
            Text(
              '어떤 약속인가요?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: appointmentTypeController,
              decoration: InputDecoration(
                hintText: '예: 점심 약속, 외근',
                labelText: '약속 유형',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            final location = locationController.text;
            final time = timeController.text;
            final type = appointmentTypeController.text;

            if (location.isNotEmpty && selectedDate != null && time.isNotEmpty && type.isNotEmpty) {
              Navigator.of(context).pop({
                'location': location,
                'date': '${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}',
                'time': time,
                'type': type,
              });
            }
          },
          child: Text('저장'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
