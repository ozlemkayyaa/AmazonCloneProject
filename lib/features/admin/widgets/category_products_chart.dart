import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:amazon/features/admin/models/sales.dart';

class CategoryProductsChart extends StatelessWidget {
  final List<Sales> salesData;
  const CategoryProductsChart({
    super.key,
    required this.salesData,
  });

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(),
      swapAnimationDuration: const Duration(milliseconds: 150),
      swapAnimationCurve: Curves.linear,
    );
  }
}
