import 'package:flutter/material.dart';
import 'package:startup_launch/core/extensions/l10n.dart';

class HomeErrorRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const HomeErrorRetry({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onRetry, child: Text(context.l10n.retry)),
        ],
      ),
    );
  }
}
