import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../core/utils.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({
    super.key,
    required this.images,
    this.onRemove,
    this.showRemove = false,
  });

  final List<Uint8List> images;
  final Function(int index)? onRemove;
  final bool showRemove;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List<Widget>.generate(images.length, (int index) {
        final Uint8List img = images[index];
        return Stack(
          children: <Widget>[
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) =>
                      Dialog(child: Image.memory(img, fit: BoxFit.contain)),
                );
              },
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: DefaultBorders.container,
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                ),
                child: ClipRRect(
                  borderRadius: DefaultBorders.container,
                  child: Image.memory(img, fit: BoxFit.cover),
                ),
              ),
            ),
            if (showRemove && onRemove != null)
              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                  onTap: () => onRemove!(index),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
