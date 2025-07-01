import 'package:dependencies/flutter_screenutil/flutter_screenutil.dart';
import 'package:dependencies/intl/intl.dart';
import 'package:flutter/material.dart';

class PortfolioTile extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String symbol;
  final double quantity;
  final double value;
  final double lastPrice;
  final double pnl;
  final double avgPrice;
  final double todayPnl;

  const PortfolioTile({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.symbol,
    required this.quantity,
    required this.value,
    required this.lastPrice,
    required this.pnl,
    required this.avgPrice,
    required this.todayPnl,
  });

  String formatNumber(double value) {
    final formatter = NumberFormat.currency(locale: 'en_US', symbol: '', decimalDigits: 2);
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    final isProfit = pnl >= 0;
    final pnlColor = isProfit ? Colors.green : Colors.red;

    return Card(
      color: Colors.grey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(10.r),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.network(
                      imageUrl,
                      height: 25,
                      width: 25,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      symbol.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${isProfit ? '+' : ''}${formatNumber(pnl)}',
                  style: TextStyle(color: pnlColor),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '\$${formatNumber(value)}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today\'s PNL',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  formatNumber(todayPnl),
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Average cost',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '\$${formatNumber(avgPrice)}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
