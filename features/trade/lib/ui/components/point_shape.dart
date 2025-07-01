import 'package:flutter/material.dart';

class PointedRightShapeBorder extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();
    final radius = 15.0;

    path.moveTo(rect.left + radius, rect.top);
    path.arcToPoint(
      Offset(rect.left, rect.top + radius),
      radius: Radius.circular(radius),
      clockwise: false,
    );
    path.lineTo(rect.left, rect.bottom - radius);
    path.arcToPoint(
      Offset(rect.left + radius, rect.bottom),
      radius: Radius.circular(radius),
      clockwise: false,
    );
    path.lineTo(rect.right - 20, rect.bottom);
    path.lineTo(rect.right, rect.center.dy);
    path.lineTo(rect.right - 20, rect.top);
    path.lineTo(rect.left + radius, rect.top);

    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;

  OutlinedBorder? resolve(WidgetState states) => null;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    // TODO: implement getInnerPath
    throw UnimplementedError();
  }
}

class PointedLeftShapeBorder extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();
    final radius = 15.0;

    // Start at top-right with rounded corner
    path.moveTo(rect.right - radius, rect.top);
    path.arcToPoint(
      Offset(rect.right, rect.top + radius),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    path.lineTo(rect.right, rect.bottom - radius);
    path.arcToPoint(
      Offset(rect.right - radius, rect.bottom),
      radius: Radius.circular(radius),
      clockwise: true,
    );

    // Draw straight line to left bottom
    path.lineTo(rect.left + 20, rect.bottom);

    // Draw the left-pointing triangle
    path.lineTo(rect.left, rect.center.dy);
    path.lineTo(rect.left + 20, rect.top);

    // Close back to starting point
    path.lineTo(rect.right - radius, rect.top);

    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    // TODO: implement getInnerPath
    throw UnimplementedError();
  }
}
