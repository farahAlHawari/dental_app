import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:photo_view/photo_view.dart';

class RadiographViewerPage extends StatelessWidget {
  final String image;
  final String title;
  final String treatment;
  final String date;

  const RadiographViewerPage({
    super.key,
    required this.image,
    required this.title,
    required this.treatment,
    required this.date,
  });

  Future<void> _downloadImage(BuildContext context) async {
    try {
      if (image.startsWith("http")) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Saving network images will be implemented when the API is connected.",
            ),
          ),
        );
        return;
      }

      await Gal.putImage(image);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Image saved successfully."),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to save image\n$e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ImageProvider provider =
        image.startsWith("http")
            ? NetworkImage(image)
            : AssetImage(image) as ImageProvider;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () => _downloadImage(context),
            icon: const Icon(Icons.download_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Hero(
                tag: image,
                child: PhotoView(
                  imageProvider: provider,
                  backgroundDecoration:
                      const BoxDecoration(color: Colors.black),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale:
                      PhotoViewComputedScale.covered * 4,
                ),
              ),
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: Color(0xff1C1C1E),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(
                        Icons.medical_services_outlined,
                        color: Colors.tealAccent,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          treatment,
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.tealAccent,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        date,
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _downloadImage(context),
                      icon: const Icon(Icons.download),
                      label: const Text("Download Image"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}