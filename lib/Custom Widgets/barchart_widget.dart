import 'package:digi_forest/Constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarChartWidget extends StatefulWidget {

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  final List<PlantData> plantData = [
    PlantData('Plant A', 100),
    PlantData('Plant B', 200),
    PlantData('Plant C', 180),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          width: 80.0 * plantData.length.toDouble(),
          child: SfCartesianChart(
            isTransposed: true,
            primaryXAxis: CategoryAxis(),
            series: <BarSeries<PlantData, String>>[
              BarSeries<PlantData, String>(
                dataSource: plantData,
                xValueMapper: (PlantData data, _) => data.plantName,
                yValueMapper: (PlantData data, _) => data.numberOfPlants,
                color: myGreenColor, // Set the color of the bars here
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlantData {
  final String plantName;
  final int? numberOfPlants;

  PlantData(this.plantName, this.numberOfPlants);
}
