// ignore_for_file: prefer_is_empty

import 'dart:async';
import 'dart:io';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:scanner/generated/l10n.dart';
import 'package:scanner/modules/home/data/datasources/card_datasource.dart';
import 'package:scanner/modules/home/domain/models/dtos/scanned_card_dto.dart';
import 'package:scanner/modules/home/presentation/contacts/contacts_controller.dart';
import 'package:scanner/services/analytics/event_properties.dart';
import 'package:scanner/services/analytics/posthog.dart';
import 'package:scanner/services/image/image_saver.dart';
import 'package:scanner/services/navigation/route_url.dart';
import 'package:scanner/utils/extension_utils.dart';
import 'package:scanner/utils/pallets.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// The [ContactsPage] class is a stateful widget in Dart.
class ContactsPage extends StatefulWidget {
  /// The line `const HomePage({super.key});` is defining a constructor for the
  /// [ContactsPage] class.
  const ContactsPage({super.key, this.cards = const []});

  final List<ScannedCardDto>? cards;

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final searchCtrl = TextEditingController();
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey(); // Create a key
  bool showInAppPaymentFeatures = false;

  EventProperties? properties = EventProperties();

  @override
  void initState() {
    super.initState();

    ScanAnalytics.captureEvent('app.open');

    if (widget.cards == null || (widget.cards?.isEmpty ?? false)) {
      _getCards();
    } else {
      _cards = widget.cards ?? [];
    }
    userChanged.listen((event) {
      _getCards();
    });

    _cards.map((e) => _precachaImages(e.imagePath));


    ScanAnalytics.isFeatureEnabled('show_in_app_payment_features').then((value) {
      setState(() {
        showInAppPaymentFeatures = value;
      });
    });
  }

  String? consolidatedImagePath;

  _precachaImages(String? imagePath) {
    if (imagePath != null) {
      Future.delayed(Duration.zero, () async {
        consolidatedImagePath = '${appDir.path}/$imagePath';
        final image1 = Image.file(
          File(consolidatedImagePath!),
          width: 114,
          height: 64,
          fit: BoxFit.cover,
          gaplessPlayback: true,
        );

        await precacheImage(image1.image, context);
      });
    }
  }

  List<ScannedCardDto> _cards = [];

  dynamic _getCards() async {
    _cards = await CardDataRepo.getCards();

    setState(() {});
  }

  Stream<void> userChanged = CardDataRepo.isarDb.scannedCardDtos.watchLazy();

  /// The HomePage class is a stateful widget in Dart.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: Drawer(
        backgroundColor: Pallets.scheme.background,
        // surfaceTintColor: Pallets.scheme.background,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              16.verticalSpace,
              Text(
                S.of(context).scan,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              10.verticalSpace,
              DrawerItemTile(
                title: S.of(context).scans,
                icon: Icons.document_scanner,
                trailing: Text(
                  '${_cards.length}',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Pallets.scheme.onSecondary),
                ),
              ),
              if (showInAppPaymentFeatures) DrawerItemTile(
                title: S.of(context).orderForYourCompany,
                icon: Icons.business_outlined,
                onTap: () async {
                  ScanAnalytics.captureEvent('navigation.click.order-company');

                  await launchUrlString(
                      'https://share-eu1.hsforms.com/1SQtiSUcsTJS3PEEChGxI7wfhyu6?utm_term=about-us&utm_medium=app&utm_source=app.spreadly.scanner');
                },
              ) else Container(),
              if (showInAppPaymentFeatures) DrawerItemTile(
                title: S.of(context).readApiDocumentation,
                icon: Icons.code,
                onTap: () async {
                  ScanAnalytics.captureEvent('navigation.click.api-documentation');

                  await launchUrlString(
                      'https://spreadly.readme.io/reference/business-card-scanner-api?utm_term=api-documentation&utm_medium=app&utm_source=app.spreadly.scanner');
                },
              ) else Container(),
              DrawerItemTile(
                title: S.of(context).loveItShareIt,
                icon: Icons.favorite_outlined,
                onTap: () async {
                  ScanAnalytics.captureEvent('navigation.click.refer');
                    
                  await Share.shareUri(Uri.parse('https://spreadly.app/about/en/tools/business-card-scanner/download'));
                },
              ),
              Divider(color: Pallets.scheme.secondary),
              16.verticalSpace,
              Text(
                S.of(context).aboutUs,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              10.verticalSpace,
              if (showInAppPaymentFeatures) DrawerItemTile(
                title: S.of(context).getADigitalBusinessCard,
                icon: Icons.public,
                onTap: () async {
                  ScanAnalytics.captureEvent('navigation.click.digital-business-card');

                  await launchUrlString(
                      'https://spreadly.app?utm_term=get-digital-business-card&utm_medium=app&utm_source=app.spreadly.scanner');
                },
              ) else Container(),
              if (showInAppPaymentFeatures) DrawerItemTile(
                title: S.of(context).buyANfcBusinessCard,
                icon: Icons.shopping_cart,
                onTap: () async {
                  await launchUrlString(
                    'https://spreadly.app/shop/-/category/NFC%20business%20cards?utm_term=buy-nfc-card&utm_medium=app&utm_source=app.spreadly.scanner',
                  );
                },
              ) else Container(),
              DrawerItemTile(
                title: S.of(context).privacyTerms,
                icon: Icons.shield,
                onTap: () async {
                  ScanAnalytics.captureEvent('navigation.click.nfc-card');

                  await launchUrlString(
                    'https://spreadly.app/about/-/legal/app?utm_term=privacy-terms&utm_medium=app&utm_source=app.spreadly.scanner',
                  );
                },
              ),
              20.verticalSpace,
              Text('Version: ${packageInfo?.version}+${packageInfo?.buildNumber}'),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
          child: Column(
            children: [
              Consumer(
                builder: (context, ref, child) {
                  return TextFormField(
                    decoration: Pallets.searchDecoration.copyWith(
                      prefixIcon: InkWell(
                        onTap: () {
                          _drawerKey.currentState?.openDrawer();
                        },
                        child: const Icon(Icons.menu),
                      ),
                    ),
                    controller: searchCtrl,
                    onChanged: (newValue) {
                      _cards = ref
                          .read(contactsProvider.notifier)
                          .searchContacts(newValue);
                      setState(() {});
                    },
                  );
                },
              ),
              if (_cards.isEmpty)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).welcomeToSpreadlyScan,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      10.verticalSpace,
                      Text(
                        S.of(context).digitizeYourPaperBusinessCards,
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ..._cards.map(
                          (e) => CardTile(cardDto: e),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.pushNamed(PageUrl.scanner);
          _getCards();
        },
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.photo_camera_outlined),
            const SizedBox(
              width: 12,
            ),
            Text(S.of(context).scan),
          ],
        ),
      ),
    );
  }
}

class DrawerItemTile extends StatelessWidget {
  const DrawerItemTile({
    required this.title,
    this.trailing,
    this.onTap,
    Key? key,
    this.icon,
  }) : super(key: key);

  final String title;
  final IconData? icon;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap?.call();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color:
              trailing != null ? Pallets.scheme.secondary : Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Row(
          children: <Widget>[
            Icon(
              icon ?? Icons.circle,
              color: trailing != null
                  ? Pallets.scheme.onSecondary
                  : Pallets.scheme.onBackground,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: trailing != null
                    ? Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: Pallets.scheme.onSecondary)
                    : Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

///CardTile
class CardTile extends StatefulWidget {
  ///CardTile constructor
  const CardTile({
    required this.cardDto,
    super.key,
  });

  ///
  final ScannedCardDto cardDto;

  @override
  State<CardTile> createState() => _CardTileState();
}

class _CardTileState extends State<CardTile> {
  Image? image1;

  @override
  void initState() {
    super.initState();
  }

  String? consolidatedImagePath;

  @override
  Widget build(BuildContext context) {
    consolidatedImagePath = '${appDir.path}/${widget.cardDto.imagePath}';
    image1 = Image.file(
      File(consolidatedImagePath!),
      width: 114,
      height: 64,
      fit: BoxFit.cover,
      gaplessPlayback: true,
    );

    unawaited(precacheImage(image1!.image, context));

    return InkWell(
      onTap: () {
        unawaited(
          context.pushNamed(
            PageUrl.details,
            queryParameters: {'id': '${widget.cardDto.id}'},
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            if (widget.cardDto.imagePath != null)
              Image.file(
                File(consolidatedImagePath!),
                width: 114,
                height: 64,
                fit: BoxFit.cover,
                gaplessPlayback: true,
              ),
            // if (widget.cardDto.imagePath != null)
            //   CachedMemoryImage(
            //     uniqueKey: '${widget.cardDto.imagePath}',
            //     width: 114,
            //     height: 64,
            //     fit: BoxFit.cover,
            //     gaplessPlayback: true,
            //
            //     errorWidget: const SizedBox(
            //       width: 114,
            //       height: 64,
            //       child: Center(
            //         child: Icon(
            //           Icons.error,
            //           color: Colors.red,
            //         ),
            //       ),
            //     ),
            //     placeholder: const SizedBox(
            //       width: 114,
            //       height: 64,
            //       child: Center(
            //         child: SizedBox(
            //           width: 20,
            //           height: 20,
            //           child: CircularProgressIndicator.adaptive(),
            //         ),
            //       ),
            //     ),
            //     bytes: File(consolidatedImagePath!).readAsBytesSync(),
            //   ),

            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.cardDto.fullName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(
                            0xff1D1B20,
                          ),
                        ),
                  ),
                  Text(
                    '${widget.cardDto.position ?? ''}'
                    '${(widget.cardDto.position == null || widget.cardDto.company == null || (widget.cardDto.company?.length == 0) || (widget.cardDto.position?.length == 0)) ? '' : ' @ '}${widget.cardDto.company ?? ''}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(
                            0xff49454F,
                          ),
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
