import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReaderLoadingView extends StatelessWidget {
  const ReaderLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (_, _) => Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(height: 420, width: double.infinity),
        ),
      ),
    );
  }
}
