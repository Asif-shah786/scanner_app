import 'package:flutter_test/flutter_test.dart';
import 'package:scanner/services/network/url_config.dart';

void main() {
  test('coreBaseUrl should be stagingUrl for staging environment', () {
    UrlConfig.environment = Environment.staging;
    expect(UrlConfig.coreBaseUrl, UrlConfig.stagingUrl);
  });

  test('coreBaseUrl should be productionUrl for production environment', () {
    UrlConfig.environment = Environment.production;
    expect(UrlConfig.coreBaseUrl, UrlConfig.productionUrl);
  });

  test('coreBaseUrl should be stagingUrl by default', () {
    UrlConfig.environment = Environment.development;
    expect(UrlConfig.coreBaseUrl, UrlConfig.stagingUrl);
  });

  test('getAccountData URL should be correct', () {
    expect(UrlConfig.scanCard, '/business-card-scans');
  });
}
