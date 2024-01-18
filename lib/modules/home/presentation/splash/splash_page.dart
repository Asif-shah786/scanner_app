// ignore_for_file: prefer_is_empty

import 'dart:async';
import 'dart:io';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scanner/generated/assets.dart';
import 'package:scanner/modules/home/data/datasources/card_datasource.dart';
import 'package:scanner/modules/home/domain/models/dtos/scanned_card_dto.dart';
import 'package:scanner/services/image/image_saver.dart';
import 'package:scanner/services/navigation/route_url.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    _getCards();
  }

  Image? image1;

  String? consolidatedImagePath;

  _precachaImages(String? imagePath) {
    if (imagePath != null) {
      Future.delayed(Duration.zero, () async {
        consolidatedImagePath = '${appDir.path}/${imagePath}';
        image1 = Image.file(
          File(consolidatedImagePath!),
          width: 114,
          height: 64,
          fit: BoxFit.cover,
          gaplessPlayback: true,
        );

        await (precacheImage(image1!.image, context));
      });
    }
  }

  final cachedImageManager = CachedImageBase64Manager.instance();

  List<ScannedCardDto> _cards = [];

  dynamic _getCards() async {
    _cards = await CardDataRepo.getCards();

    setState(() {});
    // _cards.take(15).map((e) async => _precachaImages(e.imagePath));

    /// The commented code `// _cards.take(10).map((e) async =>
    /// cachedImageManager.cacheBytes(...));` is iterating over
    /// the first 10 elements
    /// in the `_cards` list and asynchronously caching the images using the
    /// `cachedImageManager.cacheBytes()` method.
    _cards.take(15).map(
          (e) async => cachedImageManager.cacheBytes(
            e.imagePath ?? '',
            File('${appDir.path}/${e.imagePath}').readAsBytesSync(),
          ),
        );

    Future.delayed(const Duration(seconds: 3), () {
      context.goNamed(PageUrl.home, extra: _cards);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ListView(
            children: [
              ..._cards.take(10).map((e) {
                consolidatedImagePath = '${appDir.path}/${e.imagePath}';
                image1 = Image.file(
                  File(consolidatedImagePath!),
                  width: 114,
                  height: 64,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                );
                unawaited(precacheImage(image1!.image, context));

                return image1!;
                // return CachedMemoryImage(
                //   uniqueKey: '${e.imagePath}',
                //   width: 114,
                //   height: 64,
                //   fit: BoxFit.cover,
                //   placeholder: const Center(
                //     child: SizedBox(
                //       height: 24,
                //       width: 24,
                //       child: CircularProgressIndicator.adaptive(),
                //     ),
                //   ),
                //   bytes: File(consolidatedImagePath!).readAsBytesSync(),
                // );
              }),
            ],
          ),
          Positioned.fill(
            child: ColoredBox(
              color: Colors.white,
              child: Center(
                child: Image.asset(
                  Assets.pngSpreadlyIcon,
                  width: 100,
                  height: 100,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
        ],
      ),
    );
  }
}
