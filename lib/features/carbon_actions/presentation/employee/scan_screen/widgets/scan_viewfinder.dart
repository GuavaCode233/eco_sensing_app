import 'package:flutter/material.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';
import 'package:eco_sensing_app/core/theme/app_decorations.dart';

/// 仿相機對焦框 + 循環掃描線
class ScanViewfinder extends StatefulWidget {
  const ScanViewfinder({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  State<ScanViewfinder> createState() => _ScanViewfinderState();
}

class _ScanViewfinderState extends State<ScanViewfinder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.neutralWarm,
            borderRadius: BorderRadius.circular(AppDecorations.cardRadius),
            border: Border.all(color: AppColors.ceramic),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDecorations.cardRadius),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: _ViewfinderPainter(
                    scanProgress: _controller.value,
                  ),
                  child: child,
                );
              },
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.document_scanner_outlined,
                      size: 40,
                      color: AppColors.starbucksGreen.withValues(alpha: 0.35),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '將單據對準框內',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.starbucksGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '點擊開啟相機',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewfinderPainter extends CustomPainter {
  _ViewfinderPainter({required this.scanProgress});

  final double scanProgress;
  static const _cornerLen = 28.0;
  static const _stroke = 3.0;
  static const _inset = 24.0;

  @override
  void paint(Canvas canvas, Size size) {
    final cornerPaint = Paint()
      ..color = AppColors.greenAccent
      ..strokeWidth = _stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    _drawCorner(canvas, cornerPaint, Offset(_inset, _inset), true, true);
    _drawCorner(
      canvas,
      cornerPaint,
      Offset(size.width - _inset, _inset),
      false,
      true,
    );
    _drawCorner(
      canvas,
      cornerPaint,
      Offset(_inset, size.height - _inset),
      true,
      false,
    );
    _drawCorner(
      canvas,
      cornerPaint,
      Offset(size.width - _inset, size.height - _inset),
      false,
      false,
    );

    final scanY = _inset + (size.height - _inset * 2) * scanProgress;
    final linePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          AppColors.greenAccent.withValues(alpha: 0),
          AppColors.greenAccent.withValues(alpha: 0.85),
          AppColors.greenAccent.withValues(alpha: 0),
        ],
        stops: const [0, 0.5, 1],
      ).createShader(Rect.fromLTWH(_inset, scanY - 2, size.width - _inset * 2, 4));

    canvas.drawLine(
      Offset(_inset, scanY),
      Offset(size.width - _inset, scanY),
      linePaint..strokeWidth = 2,
    );
  }

  void _drawCorner(
    Canvas canvas,
    Paint paint,
    Offset origin,
    bool left,
    bool top,
  ) {
    final dx = left ? 1.0 : -1.0;
    final dy = top ? 1.0 : -1.0;
    canvas.drawLine(origin, origin + Offset(_cornerLen * dx, 0), paint);
    canvas.drawLine(origin, origin + Offset(0, _cornerLen * dy), paint);
  }

  @override
  bool shouldRepaint(_ViewfinderPainter oldDelegate) {
    return oldDelegate.scanProgress != scanProgress;
  }
}
