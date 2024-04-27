import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:teamsyncai/screens/dashboardscreen/charts/radialP.dart';



class ProjectFourth extends StatelessWidget {
  const ProjectFourth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Dashboard'),
        backgroundColor: const Color(0xFFE89F16),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              _buildCompletionStatus(),
              const SizedBox(height: 10),
              const SizedBox(height: 10),
              _buildCharts(),
              const SizedBox(height: 10),
              _buildModuleCompletionList(),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildCompletionStatus() {
    return Card(

      surfaceTintColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'StuStay',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE89F16)),
            ),
            const SizedBox(height: 15),
        const SizedBox(height: 190,child: CustomPaint(painter: RadialPainter(bgColor: Color(0xFF8D6322),lineColor: Colors.orange,percent: 60 / 100,width: 15.0,),child: Center(child: Text('60%',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.orange,),),),),),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCompletionLegend('60% done', Colors.orange),
                const SizedBox(width: 30),
                _buildCompletionLegend('40% not done', const Color(0xFF8D6322)),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildCompletionLegend(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildModuleCompletionList() {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildModuleCompletion('Module 1', 20, Colors.red),
        _buildModuleCompletion('Module 2', 10, Colors.blue),
        _buildModuleCompletion('Module 3', 15, Colors.green),
        _buildModuleCompletion('Module 4', 25, Colors.orange),
        _buildModuleCompletion('Module 5', 12, Colors.purple),
        _buildModuleCompletion('Module 6', 18, Colors.yellow),
      ],
    );
  }

  Widget _buildModuleCompletion(String title, int percentage, Color color) {
    return Card(
      surfaceTintColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '$percentage%',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharts() {
    return Column(
      children: [
        _buildModuleHoursChart(),
        const SizedBox(height: 20),
        _buildTaskStatusChart(),
        const SizedBox(height: 10),

      ],
    );
  }

  Widget _buildModuleHoursChart() {
    return Card(
      surfaceTintColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Module Hours (Hours per Day)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE89F16)),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 3),
                        FlSpot(1, 4),
                        FlSpot(2, 3),
                        FlSpot(3, 5),
                        FlSpot(4, 4),
                        FlSpot(5, 6),
                        FlSpot(6, 4),

                      ],
                      isCurved: true,
                      colors: [const Color(0xFFE89F16)],
                      barWidth: 3,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                    ),
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 2),
                        FlSpot(1, 3),
                        FlSpot(2, 2),
                        FlSpot(3, 4),
                        FlSpot(4, 3),
                        FlSpot(5, 5),
                        FlSpot(6, 3),

                      ],
                      isCurved: true,
                      colors: [Colors.blue],
                      barWidth: 3,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                    ),
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 2),
                        FlSpot(1, 4),
                        FlSpot(2, 1),
                        FlSpot(3, 3),
                        FlSpot(4, 4),
                        FlSpot(5, 2),
                        FlSpot(6, 5),

                      ],
                      isCurved: true,
                      colors: [Colors.red],
                      barWidth: 3,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: SideTitles(showTitles: true),
                    bottomTitles: SideTitles(showTitles: true),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskStatusChart() {
    return Card(
      surfaceTintColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Task Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE89F16)),
            ),
            Stack(
              children: [
                Center(
                  child: SizedBox(
                    height: 250,
                    width: 250,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: 60,
                            color: Colors.green,
                            title: '60%',
                            radius: 100,
                          ),
                          PieChartSectionData(
                            value: 25,
                            color: Colors.red,
                            title: '25%',
                            radius: 100,
                          ),
                          PieChartSectionData(
                            value: 15,
                            color: Colors.yellow,
                            title: '15%',
                            radius: 100,
                          ),
                        ],
                        centerSpaceRadius: 0,
                        sectionsSpace: 0,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendItem(color: Colors.green, text: 'done'),
                      const SizedBox(width: 20),
                      _buildLegendItem(color: Colors.red, text: 'not done'),
                      const SizedBox(width: 20),
                      _buildLegendItem(color: Colors.yellow, text: 'pending'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildLegendItem({required Color color, required String text}) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 20),
        Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

}