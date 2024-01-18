import 'dart:io';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scanner/generated/assets.dart';
import 'package:scanner/generated/l10n.dart';
import 'package:scanner/modules/home/data/datasources/card_datasource.dart';
import 'package:scanner/modules/home/domain/models/dtos/scanned_card_dto.dart';
import 'package:scanner/modules/home/domain/services/device_contacts_imp_service.dart';
import 'package:scanner/services/analytics/posthog.dart';
import 'package:scanner/services/image/image_saver.dart';
import 'package:scanner/services/navigation/route_url.dart';
import 'package:scanner/utils/extension_utils.dart';
import 'package:scanner/utils/pallets.dart';
import 'package:scanner/utils/snackbar_util.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

/// The line `const ContactDetailsPage({super.key});` is defining a constructor
/// for the `ContactDetailsPage` class.
class ContactDetailsPage extends StatefulWidget {
  /// The line [const ContactDetailsPage({super.key});] is defining
  /// a constructor for the [ContactDetailsPage]` class.
  ///  This constructor takes an optional named parameter [key]`
  ///  and passes it to the superclass constructor using [key].

  final int id;

  /// with a constant expression.
  const ContactDetailsPage({required this.id, super.key});

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

enum MoreActions { open, delete }

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  late ScannedCardDto data;
  bool _showAppBarTitle = false;

  @override
  void initState() {
    super.initState();
    setData();
  }

  void setData() {
    data = CardDataRepo.getCard(widget.id)!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final consolidatedImagePath = '${appDir.path}/${data.imagePath}';

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        final pixels = notification.metrics.pixels;
        if (pixels > 25) {
          setState(() {
            _showAppBarTitle = true;
          });
        } else {
          setState(() {
            _showAppBarTitle = false;
          });
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: _showAppBarTitle
            ? Pallets.scheme.surface
            : Pallets.scheme.background,
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: animation,
                  alignment: Alignment.bottomLeft,
                  child: child,
                ),
              );
            },
            child: _showAppBarTitle
                ? Text(
                    data.fullName,
                  )
                : const SizedBox.shrink(),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                ScanAnalytics.captureEvent('scan.contact.edit');

                final value = await DeviceContactsImpService.openEditWindow(
                  data.deviceId!,
                );
                if (value != null) {
                  await CardDataRepo.updateContact(value);
                  setData();
                }
              },
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              onPressed: () async {
                ScanAnalytics.captureEvent('scan.contact.share');

                DeviceContactsImpService.shareVCFCard(
                  data.deviceId!,
                );
              },
              icon: const Icon(
                Icons.share,
              ),
            ),
            PopupMenuButton<MoreActions>(
              surfaceTintColor: Pallets.scheme.background,
              color: Pallets.scheme.background,
              icon: Icon(Icons.more_vert, color: Pallets.scheme.onBackground),
              shadowColor: Pallets.scheme.secondary,
              onSelected: (action) async {
                if (action == MoreActions.open) {
                  ScanAnalytics.captureEvent('scan.contact.open');

                  await DeviceContactsImpService.openContactView(data.deviceId!);
                } else if (action == MoreActions.delete) {
                  return showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(S.of(context).areYouSureToDelete),
                        actions: <Widget>[
                          TextButton(
                            child: Text(S.of(context).cancel,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text(S.of(context).delete),
                            onPressed: () async {
                              context.goNamed(PageUrl.home);
                              SnackBarUtil.showSnackBar(
                                context,
                                S.of(context).contactDeleted,
                              );
                              await CardDataRepo.deleteCard(data.id);
                              await DeviceContactsImpService.deleteContact(
                                data.deviceId!);

                              ScanAnalytics.captureEvent('scan.contact.delete');
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  throw Exception('Unknown action: $action');
                }
              },
              itemBuilder: (BuildContext context) => 
              <PopupMenuEntry<MoreActions>>[
                PopupMenuItem(
                  value: MoreActions.open,
                  child: Text(S.of(context).openInContacts),
                ),
                PopupMenuItem(
                  value: MoreActions.delete,
                  child: Text(S.of(context).delete),
                ),
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.fullName,
                key: ValueKey<bool>(_showAppBarTitle),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              4.verticalSpace,

              Image.file(
                File(consolidatedImagePath),
                width: double.infinity,
                height: 224,
                fit: BoxFit.cover,
                gaplessPlayback: true,
              ),
              // CachedMemoryImage(
              //   uniqueKey: '${data.imagePath}',
              //   width: double.infinity,
              //   height: 224,
              //   fit: BoxFit.cover,
              //   gaplessPlayback: true,
              //
              //   placeholder: Center(
              //       child: SizedBox(
              //           height: 24,
              //           width: 24,
              //           child: CircularProgressIndicator.adaptive())),
              //   bytes: File(consolidatedImagePath).readAsBytesSync(),
              // ),
              28.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (data.phones.isNotEmpty)
                    DetailsActionIcon(
                      icon: Icons.phone_rounded,
                      onTap: () async {
                        await _openBottomSheet(context, 'Phone', data.phones);
                      },
                    ),
                  if (data.emails.isNotEmpty)
                    DetailsActionIcon(
                      icon: Icons.email,
                      onTap: () async {
                        await _openBottomSheet(context, 'Email', data.emails);
                      },
                    ),
                  if (data.address.isNotEmpty)
                    DetailsActionIcon(
                      icon: Icons.location_on_outlined,
                      onTap: () async {
                        await _openBottomSheet(
                          context,
                          'Address',
                          data.address,
                        );
                      },
                    ),
                  if (data.websites.isNotEmpty)
                    DetailsActionIcon(
                      icon: Icons.language,
                      onTap: () async {
                        await _openBottomSheet(
                          context,
                          'Website',
                          data.websites,
                        );
                      },
                    ),
                ],
              ),
              29.verticalSpace,
              ContactDetailColumn(
                title: S.of(context).name,
                values: [data.fullName],
              ),
              ContactDetailColumn(
                title: S.of(context).company,
                values: [(data.company ?? '')],
              ),
              ContactDetailColumn(
                title: S.of(context).position,
                values: [(data.position ?? '')],
              ),
              ContactDetailColumn(
                tag: 'phone',
                title: S.of(context).phone,
                values: data.phones,
              ),
              ContactDetailColumn(
                tag: 'email',
                title: S.of(context).emailAddress,
                values: data.emails,
              ),
              ContactDetailColumn(
                tag: 'website',
                title: S.of(context).website,
                values: data.websites,
              ),
              ContactDetailColumn(
                tag: 'address',
                title: S.of(context).address,
                values: data.address,
              ),
              ContactDetailColumn(
                tag: 'notes',
                title: S.of(context).notes,
                values: [data.notes],
              ),
              30.verticalSpace,
              Center(
                child: SafeArea(
                  child: Text(
                    '${S.of(context).scan} ID: '
                            '${data.apiId != null ? '${data.apiId} - ' : ''}'
                            '${data.id}'
                        .trim(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              10.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openBottomSheet(
    BuildContext context,
    String title,
    List<String> data,
  ) async {
    if (data.isEmpty) {
      SnackBarUtil.showSnackBar(
        context,
        S.of(context).noAvailableTitles(title),
      );
      return;
    }
    if (data.length == 1) {
      await launchContactInfo(context, title.toLowerCase(), data.first);
      return;
    }

    await showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return ActionBottomSheet(
          title: title,
          data: data,
        );
      },
    );
  }
}

///
class ActionBottomSheet extends StatelessWidget {
  ///
  const ActionBottomSheet({
    required this.data,
    required this.title,
    super.key,
  });

  final List<String> data;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          24.verticalSpace,
          Text(
            S.of(context).whichTitle(title),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          18.verticalSpace,
          ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  data[index],
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await launchContactInfo(
                    context,
                    title.toLowerCase(),
                    data[index],
                  );
                },
              );
            },
            separatorBuilder: (context, index) {
              return Container(
                height: 1,
                width: double.infinity,
                color: const Color(0xffCAC4D0),
              );
            },
            itemCount: data.length,
          ),
        ],
      ),
    );
  }
}

class DetailsActionIcon extends StatelessWidget {
  const DetailsActionIcon({
    required this.icon,
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: IconButton(onPressed: onTap, icon: Icon(icon)),
    );
  }
}

///
class ContactDetailColumn extends StatelessWidget {
  ///
  const ContactDetailColumn({
    required this.title,
    required this.values,
    super.key,
    this.tag,
  });

  final String title;
  final String? tag;
  final List<String?> values;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ...values.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () async {
                if (tag != null) {
                  await launchContactInfo(context, tag?.toLowerCase(), e!)
                      .catchError((va) {
                    debugPrint(va.toString());
                  });
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  // 16.verticalSpace,
                  Text(
                    e ?? 'N/A',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

///

Future<void> launchContactInfo(
  BuildContext context,
  String? type,
  String info,
) async {
  var url = '';

  switch (type) {
    case 'email' || 'email address':
      url = 'mailto:$info';
    case 'phone' || 'phones':
      url = 'tel:$info';
    case 'address' || 'addresses':
      if (Platform.isAndroid) {
        url = 'https://www.google.com/maps/search/?api=1&query=$info';
      } else {
        url = 'https://maps.apple.com/?q=$info';
      }
    case 'website' || 'websites':
      url = info.startsWith('http://') || info.startsWith('https://')
          ? info
          : 'http://$info';
    default:
      return;
    // throw ArgumentError('Invalid contact type');
  }

  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    Future.delayed(Duration.zero, () {
      SnackBarUtil.showSnackBar(context, 'Could not launch $url');
    });

    debugPrint('Could not launch $url');
  }
}
