import 'package:flutter/material.dart';
import 'models.dart';

class DayBar extends CustomPainter {
  final int splitCount;
  final Color bgColor;
  final Color highlightColor;
  final Color splitLineColor;
  final List<Range> highlights;
  final double borderRadius;

  DayBar(
      {this.splitCount = 48,
      this.borderRadius = 10,
      this.highlights = const [],
      this.bgColor = const Color.fromARGB(255, 207, 207, 207),
      this.highlightColor = const Color.fromARGB(255, 238, 31, 37),
      this.splitLineColor = const Color.fromARGB(255, 230, 230, 230)});

  @override
  void paint(Canvas canvas, Size size) {
    //Background
    var bgPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
        // Rect.fromLTWH(0, 0, size.width, size.height / 2)
        RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height),
            Radius.circular(borderRadius)),
        bgPaint);

    //Highlights
    var highlightPaint = Paint()
      ..color = highlightColor
      ..style = PaintingStyle.fill;

    for (var h in highlights) {
      canvas.drawRRect(
          // Rect.fromLTWH(0, 0, size.width, size.height / 2)
          RRect.fromRectAndRadius(
              Rect.fromLTWH(0, h.min * size.height, size.width,
                  (h.max - h.min) * size.height),
              Radius.circular(borderRadius)),
          highlightPaint);
    }

//Draw Line
    var linePaint = Paint()
      ..color = splitLineColor
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < this.splitCount - 1; i++) {
      var y = (i + 1) * size.height / this.splitCount;
      canvas.drawLine(
          Offset(
            0,
            y,
          ),
          Offset(size.width, y),
          linePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
