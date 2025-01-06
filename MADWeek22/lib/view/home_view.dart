import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view/appointment_page.dart';
import '../viewModel/home_view_model.dart'; // Import the AppointmentPage view

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double _dragStartY = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<HomeViewModel>(context, listen: false);
      viewModel.fetchNearbyStations(); // 화면 로드 후 API 호출
      viewModel.fetchLateCount(); // 지각 횟수 로드 후 API 호출
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    final bikeInfo = viewModel.bikeInfo;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('오늘은 늦지 말아요, 태건 님'),
      ),
      body: GestureDetector(
        onVerticalDragStart: (details) {
          _dragStartY = details.localPosition.dy;
        },
        onVerticalDragUpdate: (details) {
          // 화면을 위로 드래그했는지 확인
          if (_dragStartY - details.localPosition.dy > 50) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AppointmentPage()),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (viewModel.isLoading)
                Center(child: CircularProgressIndicator()),
              if (!viewModel.isLoading) ...[
                Row(
                  children: [
                    Icon(Icons.pedal_bike, size: 30),
                    SizedBox(width: 8),
                    Text('타봤슈', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${bikeInfo.availableBikes} / ${bikeInfo.totalBikes} 대',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text('여유',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 16
                              )),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '정류소 위치: ${Uri.decodeComponent(bikeInfo.location)}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),
                Text('지도', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(Icons.map, size: 100, color: Colors.blue),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
                          SizedBox(width: 8),
                          Text('지각 ${viewModel.lateCount}회', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black, // 버튼 배경색 검정
                          foregroundColor: Colors.white, // 텍스트 색 흰색
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => AppointmentPage()),
                          );
                        },
                        child: Text('약속 추가'),
                      ),
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
