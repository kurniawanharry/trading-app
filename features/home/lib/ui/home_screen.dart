import 'package:dependencies/flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const List<Map<String, Object>> menuList = [
  {
    'name': 'Rewards Hub',
    'icon': Icons.confirmation_num_outlined,
  },
  {
    'name': 'Referral',
    'icon': Icons.person_add_alt,
  },
  {
    'name': 'Traders League',
    'icon': Icons.tornado_rounded,
  },
  {
    'name': 'Earn',
    'icon': Icons.money,
  },
  {
    'name': 'More',
    'icon': Icons.dashboard_customize_outlined,
  },
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: Icon(
          Icons.menu,
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Flexible(
              child: TextField(
                enabled: false,
                decoration: InputDecoration(hintText: '#MarketPullback'),
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(width: 20),
          Icon(
            Icons.insert_comment_outlined,
          ),
          SizedBox(width: 15),
          Icon(
            Icons.headset_mic_outlined,
          ),
          SizedBox(width: 15),
          Icon(
            Icons.paypal_rounded,
          ),
          SizedBox(width: 15),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              'Onboarding Task',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            subtitle: Text(
              'Deposit Your First Crypto',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            trailing: ElevatedButton(onPressed: () {}, child: Text('Add Funds')),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                menuList.length,
                (index) {
                  var menu = menuList[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        color: Color(0xFF1E1E1E),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(6.r)),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(menu['icon'] as IconData),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        menu['name'] as String,
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
