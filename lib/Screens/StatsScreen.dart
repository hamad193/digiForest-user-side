import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_forest/Constants/constants.dart';
import 'package:digi_forest/Custom%20Widgets/barchart_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  late int allPlantedTrees;
  late int allCuttingTrees;
  late int totalRemainingTrees;

  @override
  void initState() {
    super.initState();
    fetchTreeData();
  }

  Future<void> fetchTreeData() async {
    allPlantedTrees = 0;
    allCuttingTrees = 0;

    final snapshot = await FirebaseFirestore.instance
        .collection("plantsData")
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (snapshot.docs.isNotEmpty) {
      for (var data in snapshot.docs) {
        allPlantedTrees += int.parse(data['numberOfPlants']);
        allCuttingTrees += int.parse(data['cuttingTrees']);
      }
    }

    totalRemainingTrees = allPlantedTrees - allCuttingTrees;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
        centerTitle: true,
        backgroundColor: myGreenColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("All Planted Trees Till Now: $allPlantedTrees"),
                    Text("All Cut Trees Till Now: $allCuttingTrees"),
                    Text("Total Remaining Trees: $totalRemainingTrees"),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            child: BarChartWidget(
              allPlantedTrees: allPlantedTrees,
              allCuttingTrees: allCuttingTrees,
              totalRemainingTrees: totalRemainingTrees,
            ),
          ),
        ],
      ),
    );
  }
}




class BarChartWidget extends StatelessWidget {
  final int allPlantedTrees;
  final int allCuttingTrees;
  final int totalRemainingTrees;

  BarChartWidget({
    required this.allPlantedTrees,
    required this.allCuttingTrees,
    required this.totalRemainingTrees,
  });

  @override
  Widget build(BuildContext context) {
    final List<PlantData> plantData = [
      PlantData('All Planted', allPlantedTrees.toDouble()),
      PlantData('All Cut', allCuttingTrees.toDouble()),
      PlantData('Total Remaining', totalRemainingTrees.toDouble()),
    ];

    return Container(
      width: double.infinity,
      child: SfCartesianChart(
        isTransposed: true,
        primaryXAxis: CategoryAxis(
          labelRotation: -45,
          labelIntersectAction: AxisLabelIntersectAction.rotate45,
        ),
        primaryYAxis: NumericAxis(),
        series: <BarSeries<PlantData, String>>[
          BarSeries<PlantData, String>(
            dataSource: plantData,
            xValueMapper: (PlantData data, _) => data.plantName,
            yValueMapper: (PlantData data, _) => data.numberOfPlants,
            color: myGreenColor,
            width: 0.8,
          ),
        ],
      ),
    );
  }
}

class PlantData {
  final String plantName;
  final double numberOfPlants;

  PlantData(this.plantName, this.numberOfPlants);
}
