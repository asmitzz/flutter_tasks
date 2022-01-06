import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class MyPainter extends StatefulWidget {
  const MyPainter({Key? key}) : super(key: key);

  @override
  State<MyPainter> createState() => _MyPainterState();
}

class _MyPainterState extends State<MyPainter> with TickerProviderStateMixin {
  // list of offsets
  final offsets = <Offset?>[];
  int offsetCount = 0;

  // define animation
  late Animation<Offset> moveBoatAnimation;
  late Animation<double> startBoatAnimation;

  // define animation controller
  late AnimationController moveBoatAnimationController;
  late AnimationController startBoatController;

  // define tweens
  late Tween<Offset> offsetTween;
  late Tween<double> startBoatTween;

  // define variables
  double dx = 100;
  double dy = 370;

  @override
  void initState() {
    super.initState();
    // initialized controller
    moveBoatAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    startBoatController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    // initialized tweens
    startBoatTween = Tween(begin: -3, end: 3);
    offsetTween = Tween(begin: Offset(dx, dy), end: Offset(dx, dy));

    // initialized animation
    moveBoatAnimation = offsetTween.animate(CurvedAnimation(
        parent: moveBoatAnimationController, curve: Curves.linear))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (offsets.length == 2) {
          } else if (offsetCount != (offsets.length - 2)) {
            offsetCount++;
            setNewPosition(offsets[offsetCount]!);
          }
        } else if (status == AnimationStatus.dismissed) {
          moveBoatAnimationController.forward();
        }
      });

    startBoatAnimation = startBoatTween.animate(
        CurvedAnimation(parent: startBoatController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          startBoatController.repeat();
        } else if (status == AnimationStatus.dismissed) {
          startBoatController.forward();
        }
      });

    // start animation
    startBoatController.forward();
  }

  setNewPosition(Offset offset) {
    offsetTween.begin = offsetTween.end;
    moveBoatAnimationController.reset();
    offsetTween.end = offset;
    moveBoatAnimationController.forward();
  }

  @override
  void dispose() {
    moveBoatAnimationController.dispose();
    startBoatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          color: Colors.blue.shade400,
          child: AnimatedBuilder(
              animation: moveBoatAnimation,
              builder: (context, snapshot) {
                return GestureDetector(
                  onPanStart: (DragStartDetails details) {
                    moveBoatAnimationController
                        .removeStatusListener((status) {});
                    setState(() {
                      offsets.clear();
                      offsetCount = 0;
                      offsets.add(details.localPosition);
                    });
                  },
                  onPanUpdate: (DragUpdateDetails details) {
                    setState(() {
                      offsets.add(details.localPosition);
                    });
                  },
                  onPanEnd: (DragEndDetails details) {
                    setState(() {
                      offsets.add(null);
                      moveBoatAnimationController.duration =
                          Duration(milliseconds: 3000 ~/ offsets.length);
                    });
                    setNewPosition(offsets[0]!);
                  },
                  child: CustomPaint(
                    painter: Boat(
                        offsets: offsets,
                        startBoat: startBoatAnimation.value,
                        offset: moveBoatAnimation.value),
                    child: Container(),
                  ),
                );
              }),
        ));
  }
}

class Boat extends CustomPainter {
  const Boat(
      {required this.offset, required this.startBoat, required this.offsets});
  final double startBoat;
  final Offset offset;
  final List<Offset?> offsets;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    // draw triangle
    var triangle1 = Path();
    triangle1.moveTo(offset.dx + 50, offset.dy - startBoat);
    triangle1.lineTo(offset.dx, offset.dy - startBoat);
    triangle1.lineTo(offset.dx + 50, offset.dy + 50 - startBoat);
    canvas.drawPath(triangle1, paint);

    canvas.drawRect(
        Offset(offset.dx + 50, offset.dy - startBoat) & const Size(80, 50),
        paint);

    var triangle2 = Path();
    triangle2.moveTo(offset.dx + 130, offset.dy - startBoat);
    triangle2.lineTo(offset.dx + 180, offset.dy - startBoat);
    triangle2.lineTo(offset.dx + 130, offset.dy + 50 - startBoat);
    canvas.drawPath(triangle2, paint);

    // draw flag
    var flag = Path();
    flag.moveTo(offset.dx + 130, offset.dy - startBoat);
    flag.lineTo(offset.dx + 130, offset.dy - 50 - startBoat);
    flag.lineTo(offset.dx + 160, offset.dy - 50 - startBoat);
    flag.lineTo(offset.dx + 160, offset.dy - 25 - startBoat);
    flag.lineTo(offset.dx + 130, offset.dy - 25 - startBoat);

    canvas.drawPath(flag, paint..color = Colors.white);

    // draw flag stick
    var flagStick = Path();
    flagStick.moveTo(offset.dx + 130, offset.dy - startBoat);
    flagStick.lineTo(offset.dx + 130, offset.dy - 50 - startBoat);
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.brown.shade800;
    canvas.drawPath(flagStick, paint);

    // draw points
    for (var i = 0; i < offsets.length; i++) {
      Offset? p1 = offsets[i] ?? const Offset(0, 0);
      Offset? p2;

      if ((offsets.length - 1) != i) {
        p2 = offsets[i + 1] ?? const Offset(0, 0);
      } else {
        p2 = const Offset(0, 0);
      }

      if ((offsets.length - 1) != i &&
          offsets[i] != null &&
          offsets[i + 1] != null) {
        canvas.drawLine(p1, p2, paint);
      } else if ((offsets.length - 1) != i &&
          offsets[i] != null &&
          offsets[i + 1] == null) {
        canvas.drawPoints(PointMode.points, [p1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
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
    double radius = (size.width / sources.length) / 2;
    for (var e in sources) {
      final index = sources.indexOf(e);
      canvas.drawArc(
          Rect.fromCircle(center: Offset(dx, size.height / 2), radius: radius),
          index % 2 == 0 ? 0 : pi,
          pi,
          false,
          paint);
      dx += radius * 2;
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
