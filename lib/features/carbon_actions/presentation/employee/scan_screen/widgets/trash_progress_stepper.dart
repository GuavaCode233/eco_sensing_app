import 'package:flutter/material.dart';

/// -1 means there is no normal progress step (failed or unknown status).
int getStepFromStatus(String status) => switch (status) {
  'waiting' => 0,
  'preparing' || 'ready' => 1,
  'recognizing' || 'uploading' => 2,
  'calculating' => 3,
  'completed' => 4,
  _ => -1,
};

class TrashProgressStepper extends StatelessWidget {
  const TrashProgressStepper({super.key, required this.status});

  final String status;
  static const _labels = ['連線', '準備', '辨識', '計算', '完成'];

  @override
  Widget build(BuildContext context) {
    final step = getStepFromStatus(status);
    if (step < 0) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Semantics(
      label: '垃圾投遞進度，第 ${step + 1} 步，共 5 步：${_labels[step]}',
      child: ExcludeSemantics(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(_labels.length, (index) {
            final active = index == step && status != 'completed';
            final reached = index <= step;
            Widget line(bool filled) => Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 2,
                color: filled ? colors.primary : colors.outlineVariant,
              ),
            );
            return Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 32,
                    child: Row(
                      children: [
                        if (index == 0) const Spacer() else line(index <= step),
                        AnimatedContainer(
                          key: ValueKey('trash-step-$index'),
                          duration: const Duration(milliseconds: 250),
                          width: 24,
                          height: 24,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: active
                                  ? colors.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: reached
                                  ? colors.primary
                                  : colors.outlineVariant,
                            ),
                          ),
                        ),
                        if (index == 4) const Spacer() else line(index < step),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _labels[index],
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: reached ? colors.primary : colors.onSurfaceVariant,
                      fontWeight: active ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
