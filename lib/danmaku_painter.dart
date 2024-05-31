import 'package:flutter/material.dart';
import 'models/danmaku_item.dart';
import '/utils/utils.dart';

class DanmakuPainter extends CustomPainter {
  final double progress;
  final List<DanmakuItem> danmakuItems;
  final int danmakuDurationInSeconds;
  final double fontSize;
  final bool showStroke;
  final bool running;
  final int tick;

  DanmakuPainter(
      this.progress,
      this.danmakuItems,
      this.danmakuDurationInSeconds,
      this.fontSize,
      this.showStroke,
      this.running,
      this.tick);

  @override
  void paint(Canvas canvas, Size size) {
    for (var item in danmakuItems) {
      // final elapsedTime = DateTime.now().difference(item.creationTime).inMilliseconds;
      final elapsedTime = tick - item.creationTime;
      final totalDuration = danmakuDurationInSeconds * 1000;
      final startPosition = size.width;
      final endPosition = -item.width;
      final distance = startPosition - endPosition;

      item.xPosition = startPosition - (elapsedTime / totalDuration) * distance;

      // 如果 Paragraph 没有缓存，则创建并缓存它
      item.paragraph ??=
          Utils.generateParagraph(item.content, size.width, fontSize);

      // 黑色部分
      if (showStroke) {
        item.strokeParagraph ??=
            Utils.generateStrokeParagraph(item.content, size.width, fontSize);

        canvas.drawParagraph(
            item.strokeParagraph!, Offset(item.xPosition, item.yPosition));
      }

      // 白色部分
      canvas.drawParagraph(
          item.paragraph!, Offset(item.xPosition, item.yPosition));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return running;
  }
}
