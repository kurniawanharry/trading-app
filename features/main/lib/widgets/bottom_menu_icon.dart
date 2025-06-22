import 'package:dependencies/flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:resources/colors.gen.dart';

class BottomMenuIcon extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String title;
  final bool isSelected;
  final Function() onClick;

  const BottomMenuIcon({
    super.key,
    required this.icon,
    required this.selectedIcon,
    required this.title,
    required this.isSelected,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              (isSelected ? selectedIcon : icon),
              size: 20,
            ),
            SizedBox(
              height: 2.h,
            ),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? ColorName.iconGrey : ColorName.iconWhite,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
