import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tasks/vori_logo/data.dart';

class VoriLogo extends StatefulWidget {
  const VoriLogo({Key? key}) : super(key: key);

  @override
  _VoriLogoState createState() => _VoriLogoState();
}

class _VoriLogoState extends State<VoriLogo> with TickerProviderStateMixin {
  int totalDots = 19;
  late final dotAnimations = <Animation>[];
  late final dotAnimControllers = <AnimationController>[];
  late Tween dotsTween;

  late final Animation triangleAnimation;
  late final AnimationController triangleAnimationController;
  late Tween triangletween;

  late final Animation circleAnimation;
  late final AnimationController circleAnimationController;
  late Tween circletween;

  late final Animation slideCircleAnimation;
  late final AnimationController slideCircleAnimationController;
  late Tween slideCircletween;

  late final Animation iDotAnimation;
  late final AnimationController iDotAnimationController;
  late Tween iDotTween;

  @override
  void initState() {
    super.initState();
    dotsTween = Tween(begin: 0.0, end: 1.0);

    for (var i = 0; i < totalDots; i++) {
      // add dot controller
      AnimationController dotAnimController = AnimationController(
          vsync: this, duration: const Duration(seconds: 1));
      dotAnimControllers.add(dotAnimController);
      //  add dot animation
      Animation dotAnim = dotsTween.animate(
          CurvedAnimation(parent: dotAnimController, curve: Curves.linear))
        ..addListener(() {
          setState(() {});
        })
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            dotAnimController.repeat();
          } else if (status == AnimationStatus.dismissed) {
            dotAnimController.forward();
          }
        });

      dotAnimations.add(dotAnim);

      // run animation
      if ([5, 6, 11, 16].contains(i + 1)) {
        Future.delayed(const Duration(milliseconds: 2000), () {
          dotAnimController.forward();
        });
      } else {
        Future.delayed(Duration(milliseconds: (i % 2 == 0) ? i * 100 : i * 50),
            () {
          dotAnimController.forward();
        });
      }
    }

    // triangle

    triangleAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    triangletween = Tween(begin: 1.0, end: 2.0);

    triangleAnimation = triangletween.animate(CurvedAnimation(
        parent: triangleAnimationController, curve: Curves.linear))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          triangletween = Tween(begin: 1.0, end: 1.0);
          triangleAnimationController.reset();
          triangleAnimationController.stop();
        } else if (status == AnimationStatus.dismissed) {
          triangleAnimationController.forward();
        }
      });

    Future.delayed(const Duration(milliseconds: 1500), () {
      triangleAnimationController.forward();
    });

    // circle

    circleAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    circletween = Tween(begin: 0.0, end: 64.0);

    circleAnimation = circletween.animate(CurvedAnimation(
        parent: circleAnimationController, curve: Curves.linear))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          dotsTween = Tween(begin: 0.0, end: 0.0);
          for (var i = 0; i < dotAnimControllers.length; i++) {
            dotAnimControllers[i].reset();
            dotAnimControllers[i].stop();
          }
        } else if (status == AnimationStatus.dismissed) {
          circleAnimationController.forward();
        }
      });

    Future.delayed(const Duration(milliseconds: 2000), () {
      circleAnimationController.forward();
    });

// slide circle

    slideCircleAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    slideCircletween = Tween(begin: 1.0, end: 0.5);

    slideCircleAnimation = slideCircletween.animate(CurvedAnimation(
        parent: slideCircleAnimationController, curve: Curves.linear))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
        } else if (status == AnimationStatus.dismissed) {
          slideCircleAnimationController.forward();
        }
      });

    Future.delayed(const Duration(milliseconds: 2500), () {
      slideCircleAnimationController.forward();
    });

    // i-dot
    iDotAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    iDotTween = Tween(begin: 1.0, end: 1.33);

    iDotAnimation = iDotTween.animate(
        CurvedAnimation(parent: iDotAnimationController, curve: Curves.easeIn))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
        } else if (status == AnimationStatus.dismissed) {
          iDotAnimationController.forward();
        }
      });

    Future.delayed(const Duration(milliseconds: 3050), () {
      iDotAnimationController.forward();
    });
  }

  @override
  void dispose() {
    for (var i = 0; i < dotAnimControllers.length; i++) {
      dotAnimControllers[i].dispose();
    }
    triangleAnimationController.dispose();
    circleAnimationController.dispose();
    slideCircleAnimationController.dispose();
    iDotAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("Vori logo"),
        ),
        body: CustomPaint(
          painter: VoriPainter(
              iDotSlide: iDotAnimation.value,
              slideCircle: slideCircleAnimation.value,
              dotAnimations: dotAnimations,
              triangleFraction: triangleAnimation.value,
              circleFraction: circleAnimation.value),
          child: Container(),
        ),
      ),
    );
  }
}

class VoriPainter extends CustomPainter {
  VoriPainter(
      {required this.dotAnimations,
      required this.slideCircle,
      required this.iDotSlide,
      required this.circleFraction,
      required this.triangleFraction});
  final List<Animation> dotAnimations;
  final double triangleFraction;
  final double circleFraction;
  final double slideCircle;
  final double iDotSlide;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..strokeWidth = 5
      ..style = PaintingStyle.fill;

    const gap = 50;
    double radius = 12;

    // get dots
    List<Dot> dots = getDots(size, gap);

    // draw dots
    for (var i = 0; i < dots.length; i++) {
      canvas.drawCircle(Offset(dots[i].width, dots[i].height), radius,
          paint..color = Color.fromRGBO(42, 42, 42, dotAnimations[i].value));
    }

    double triangleHeight = ((size.height / 2) - gap * 0.5);
    double triangleWidth = size.width / 3;

    // draw triangle
    var trainglePath = Path();
    trainglePath.moveTo(triangleWidth, triangleHeight);
    trainglePath.lineTo(size.width / 2, triangleHeight * 1.3);
    trainglePath.lineTo(triangleWidth * triangleFraction, triangleHeight);

    paint.color = Colors.white;
    canvas.drawPath(trainglePath, paint);

    // draw circle
    canvas.drawCircle(
        Offset((size.width / 2) * slideCircle, size.height / 1.88),
        circleFraction,
        paint);

    var circleTriangle = Path();
    double startTri = (size.width / 1.85) * slideCircle;

    circleTriangle.moveTo(startTri, size.height / 2);
    circleTriangle.lineTo(startTri + 25, size.height / 2);
    circleTriangle.lineTo(startTri + 12.5, size.height / 1.9);
    paint.color = Colors.black;
    if (circleFraction > 32) {
      canvas.drawPath(circleTriangle, paint);
    }

    var circleLine = Path();
    double startLine = startTri - 48;

    circleLine.moveTo(startLine, size.height / 2);
    circleLine.lineTo(startLine + 20, size.height / 2);
    circleLine.lineTo(startLine + 45, size.height / 1.75);
    circleLine.lineTo(startLine + 35, size.height / 1.7);
    if (circleFraction > 32) {
      canvas.drawPath(circleLine, paint);
    }

    // text paint
    double startText = startLine + 80;
    TextStyle textStyle = const TextStyle(
        color: Colors.white, fontSize: 80, fontWeight: FontWeight.w900);
    final textSpan = TextSpan(
      text: 'Vor',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    Offset textOffset = Offset(startText + 52, size.height / 2.1);

    // i-stick
    Offset iStickP1 = Offset(startText + 216, size.height / 1.91);
    Offset iStickP2 = Offset(startText + 216, size.height / 1.71);
    paint.color = Colors.white;
    paint.strokeWidth = 18;
    if (slideCircle < 0.8) {
      canvas.drawLine(iStickP1, iStickP2, paint);
      textPainter.paint(canvas, textOffset);
    }

    // i-dot
    if (slideCircle == 0.5) {
      canvas.drawCircle(
          Offset(((size.width / 1.8) + gap) * iDotSlide, (size.height / 2)),
          radius,
          paint..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
