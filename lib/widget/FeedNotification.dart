import 'dart:math';
import 'package:flutter/material.dart';

class FeedNotification extends StatelessWidget {
  const FeedNotification({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
        ),
        CustomPaint(
          size: Size(250, 250),
          painter: DottedCirclePainter(),
        ),
        Column(
          children: [
            Text(
              'Next Feeding',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Sun, Feb 20',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '07:00 AM',
              style:
                  TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              '15 Portions',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }
}

class DottedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Paint paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final double dashWidth = 5;
    final double dashSpace = 7;

    final int numOfDashes = (5 * radius / (dashWidth + dashSpace)).ceil();
    final double angleStep = 2 * pi / numOfDashes;

    for (int i = 0; i < numOfDashes; i++) {
      final double startX = radius + radius * cos(angleStep * i);
      final double startY = radius + radius * sin(angleStep * i);
      final double endX = radius + (radius - dashWidth) * cos(angleStep * i);
      final double endY = radius + (radius - dashWidth) * sin(angleStep * i);
      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

