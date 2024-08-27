import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';

Future<Uint8List?> textToImage(String text) async {
  final ui.PictureRecorder recorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(recorder);

  const Size size = Size(200, 100); // Set your desired image size here

  final Paint paint = Paint()
    ..color = Colors.blue // Background color
    ..style = PaintingStyle.fill;

  canvas.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height), paint);

  final TextPainter textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: const TextStyle(
        color: Colors.white, // Text color
        fontSize: 20.0, // Font size
      ),
    ),
    textDirection: TextDirection.ltr,
  );

  textPainter.layout(minWidth: 0, maxWidth: size.width);
  textPainter.paint(
      canvas,
      Offset((size.width - textPainter.width) / 2,
          (size.height - textPainter.height) / 2));

  final ui.Image image = await recorder
      .endRecording()
      .toImage(size.width.toInt(), size.height.toInt());
  final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
  return byteData?.buffer.asUint8List();
}

class CustomWatermark extends StatelessWidget {
  const CustomWatermark({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: textToImage("How Are You Man?"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data != null) {
          return Image.memory(
            snapshot.data!,
            fit: BoxFit.contain,
          );
        } else {
          return const Text('Image data is null');
        }
      },
    );
  }
}
