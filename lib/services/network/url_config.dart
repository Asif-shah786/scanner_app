/// Enumeration representing different application environments or flavors.
enum Environment {
  /// Development environment.
  development,

  /// Staging environment.
  staging,

  /// Quality Assurance (QA) environment.
  qa,

  /// Production environment.
  production,
}

/// Provides URLs and configurations for different application environments.
class UrlConfig {
  /// Private constructor to prevent instantiation.
  UrlConfig._();

  /// The current environment of the application (e.g., staging, production).
  static Environment environment = Environment.staging;

  /// The base URL for the staging environment.
  static const String stagingUrl = 'https://spreadly.app/api/v1/';

  /// The base URL for the production environment.
  static const String productionUrl = 'https://spreadly.app/api/v1/';

  /// The core base URL used based on the selected environment.
  static final coreBaseUrl =
      environment == Environment.production ? productionUrl : stagingUrl;

  /// URL path to [scanCard]
  static const String scanCard = '/business-card-scans';
}
