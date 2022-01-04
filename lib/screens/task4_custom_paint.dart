import 'dart:math';

import 'package:flutter/material.dart';

class MyPainter extends StatefulWidget {
  const MyPainter({Key? key}) : super(key: key);

  @override
  State<MyPainter> createState() => _MyPainterState();
}

class _MyPainterState extends State<MyPainter> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: CustomPaint(
          painter: SineGraph(),
          child: Container(),
        ));
  }
}

class SineGraph extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;
    Offset p1 = Offset(0, size.height / 2);
    Offset p2 = Offset(size.width, size.height / 2);

    canvas.drawLine(p1, p2, paint);
    paint.color = Colors.yellow;

    List sources = [0, 1, 2, 3, 4, 5];
    double dx = 30;
    double radius = (size.width / sources.length)/2;
    for (var e in sources) {
      final index = sources.indexOf(e);
      canvas.drawArc(
          Rect.fromCircle(center: Offset(dx, size.height / 2), radius: radius),
          index % 2 == 0 ? 0 : pi,
          pi,
          false,
          paint);
      dx += radius*2;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.yellow.shade700
      ..strokeWidth = 10;

    // square
    canvas.drawRect(const Offset(100, 50) & const Size(100, 100), paint);

    // cicle
    canvas.drawCircle(const Offset(100, 250), 40, paint..color = Colors.red);

    // arc
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.blue;
    paint.strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: const Offset(100, 350), radius: 30),
        0, pi, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class PaintSmiley extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double radius = 100;
    var paint = Paint()
      ..color = Colors.yellow.shade700
      ..strokeWidth = 5;

    Offset center = Offset(size.width / 2, size.height / 2);
    Offset eye1 = Offset(
      center.dx - radius / 2.5,
      center.dy - radius / 2.5,
    );
    Offset eye2 = Offset(
      center.dx + radius / 2.5,
      center.dy - radius / 2.5,
    );

    canvas.drawCircle(center, radius, paint);
    paint.color = Colors.black;
    canvas.drawCircle(eye1, 15, paint);
    canvas.drawCircle(eye2, 15, paint);
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.round;
    paint.strokeWidth = 15;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius / 1.5), 0.5,
        2, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
