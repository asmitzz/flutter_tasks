class Dot {
  const Dot({
    required this.id,
    required this.width,
    required this.height,
  });

  final int id;
  final double width;
  final double height;
}

List<Dot> getDots(size, gap) {
  List<Dot> dots = [
    Dot(
        id: 1,
        width: (size.width / 1.8) - gap * 2,
        height: (size.height / 2) - gap),
    Dot(
      id: 2,
      width: (size.width / 1.8) - gap,
      height: (size.height / 2) - gap,
    ),
    Dot(
      id: 3,
      width: (size.width / 1.8),
      height: (size.height / 2) - gap,
    ),
    Dot(
      id: 4,
      width: (size.width / 1.8) + gap,
      height: (size.height / 2) - gap,
    ),
    Dot(
      id: 5,
      width: (size.width / 1.8) + gap * 2.5,
      height: (size.height / 2) - gap,
    ),
    Dot(
      id: 6,
      width: (size.width / 1.8) - gap * 3.5,
      height: (size.height / 2),
    ),
    Dot(
      id: 7,
      width: (size.width / 1.8) - gap * 2,
      height: (size.height / 2),
    ),
    Dot(
      id: 8,
      width: (size.width / 1.8) - gap,
      height: (size.height / 2),
    ),
    Dot(
      id: 9,
      width: (size.width / 1.8),
      height: (size.height / 2),
    ),
    Dot(
      id: 10,
      width: (size.width / 1.8) + gap,
      height: (size.height / 2),
    ),
    Dot(
      id: 11,
      width: (size.width / 1.8) + gap * 2.5,
      height: (size.height / 2),
    ),
    Dot(
      id: 12,
      width: (size.width / 1.8) - gap * 2,
      height: (size.height / 2) + gap,
    ),
    Dot(
      id: 13,
      width: (size.width / 1.8) - gap,
      height: (size.height / 2) + gap,
    ),
    Dot(
      id: 14,
      width: (size.width / 1.8),
      height: (size.height / 2) + gap,
    ),
    Dot(
      id: 15,
      width: (size.width / 1.8) + gap,
      height: (size.height / 2) + gap,
    ),
    Dot(
      id: 16,
      width: (size.width / 1.8) - gap * 3.5,
      height: (size.height / 2) + gap * 2,
    ),
    Dot(
      id: 17,
      width: (size.width / 1.8) - gap * 2,
      height: (size.height / 2) + gap * 2,
    ),
    Dot(
      id: 18,
      width: (size.width / 1.8) - gap,
      height: (size.height / 2) + gap * 2,
    ),
    Dot(
      id: 19,
      width: (size.width / 1.8),
      height: (size.height / 2) + gap * 2,
    )
  ];

  return dots;
}
