import 'package:dependencies/flutter_screenutil/flutter_screenutil.dart';
import 'package:dependencies/flutter_toast/flutter_toast.dart';
import 'package:flutter/material.dart';

class CustomToast {
  static void showErrorToast({required String errorMessage}) => Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.sp,
      );

  static void showSuccessToast({required String errorMessage}) => Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14.sp,
      );
}
