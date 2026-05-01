import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ZoomableMangaPage extends StatefulWidget {
  final String imageUrl;

  const ZoomableMangaPage({super.key, required this.imageUrl});

  @override
  State<ZoomableMangaPage> createState() => _ZoomableMangaPageState();
}

class _ZoomableMangaPageState extends State<ZoomableMangaPage> {
  late TransformationController controller;

  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    super.initState();

    controller = TransformationController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    final position = _doubleTapDetails?.localPosition;

    if (position == null) return;

    final current = controller.value;

    final isZoomed = current != Matrix4.identity();

    if (isZoomed) {
      controller.value = Matrix4.identity();
      return;
    }

    final zoom = 2.5;

    controller.value = Matrix4.identity()
      ..translateByDouble(
        -position.dx * (zoom - 1),
        -position.dy * (zoom - 1),
        0,
        1,
      )
      ..scaleByDouble(zoom, zoom, 1, 1);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final dpr = MediaQuery.of(context).devicePixelRatio;

    return GestureDetector(
      onDoubleTapDown: (details) {
        _doubleTapDetails = details;
      },
      onDoubleTap: _handleDoubleTap,
      child: InteractiveViewer(
        transformationController: controller,
        minScale: 1,
        maxScale: 4,
        panEnabled: true,
        scaleEnabled: true,
        clipBehavior: Clip.none,
        child: CachedNetworkImage(
          imageUrl: widget.imageUrl,
          fit: BoxFit.fitWidth,
          memCacheWidth: (width * dpr * 2).toInt(),
          fadeInDuration: Duration.zero,
          placeholder: (_, _) => AspectRatio(
            aspectRatio: .7,
            child: ColoredBox(color: Colors.black12),
          ),
          errorWidget: (_, _, _) => const SizedBox(
            height: 220,
            child: Center(child: Icon(Icons.broken_image)),
          ),
        ),
      ),
    );
  }
}
