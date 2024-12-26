import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../widget/line_chart_widget.dart';


class StaticScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dữ liệu mẫu cho biểu đồ
    final List<FlSpot> sampleSpots = [
      FlSpot(1, 3),
      FlSpot(2, 5),
      FlSpot(3, 2),
      FlSpot(4, 4),
      FlSpot(5, 7),
    ];

    // Tìm maxX và maxY từ dữ liệu mẫu
    final double maxX =
        sampleSpots.map((e) => e.x).reduce((a, b) => a > b ? a : b);
    final double maxY =
        sampleSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(
        title: Text("Thống kê"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Biểu đồ thống kê",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: LineChartWidget(
                spots: sampleSpots,
                maxX: maxX,
                maxY: maxY,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
