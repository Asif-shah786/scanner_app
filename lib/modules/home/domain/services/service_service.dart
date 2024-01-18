import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scanner/modules/home/domain/models/dtos/scan_card_res_dto.dart';
import 'package:scanner/services/analytics/event_properties.dart';
import 'package:scanner/services/analytics/posthog.dart';
import 'package:scanner/services/network/api_error.dart';
import 'package:scanner/services/network/network_service.dart';
import 'package:scanner/services/network/url_config.dart';

class ServiceService {
  final NetworkService _networkService;

  ///[ServiceService] constructor class
  ServiceService(this._networkService);

  ///Function to scanCard
  Future<Extraction> scanCard(
    File imageFile,
    String? fileName,
  ) async {
    try {
      final response = await _networkService.call(
        UrlConfig.scanCard,
        RequestMethod.upload,
        formData: FormData.fromMap({
          'front': MultipartFile.fromBytes(
            await imageFile.readAsBytes(),
            filename: fileName ?? 'image_file',
          ),
        }),
      );

      if (response.data['given_name'] == '' &&
          response.data['family_name'] == '') {
        ScanAnalytics.captureEvent(
          'scan.fail',
          properties: EventProperties(
            detail: 'No name found on card',
          ),
        );
        throw ApiError('No business card found in image');
      }

      ScanAnalytics.captureEvent('scan.success');

      return Extraction.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on Exception catch (e) {
      ScanAnalytics.captureEvent(
        'scan.fail',
        properties: EventProperties(
          detail: e.toString(),
        ),
      );

      rethrow;
    }
  }
}

///cardServiceProvider
final cardServiceProvider = Provider<ServiceService>((ref) {
  return ServiceService(ref.watch(netwerkServiceProvider));
});
