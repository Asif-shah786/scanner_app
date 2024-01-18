class EventProperties {
  EventProperties({
    this.appNamespace,
    this.appVersion,
    this.appBuild,
    this.osName,
    this.osVersion,
    this.detail,
    this.isAuth,
    this.userId,
    this.emailDomain,
  });

  EventProperties.fromJson(json) {
    appNamespace = json[r'$app_namespace'] as String?;
    appVersion = json[r'$app_version'] as String?;
    appBuild = json[r'$app_build'] as String?;
    osName = json['os_name'] as String?;
    osVersion = json['os_version'] as String?;
    detail = json['detail'] as String?;
    isAuth = json['is_auth'] as bool;
    userId = json['user_id'] as String?;
    emailDomain = json['email_domain'] as String?;
  }
  String? appNamespace;
  String? appVersion;
  String? appBuild;
  String? appBuil;
  String? osName;
  String? osVersion;
  String? detail;
  bool? isAuth;
  String? userId;
  String? emailDomain;
  EventProperties copyWith({
    String? appNamespace,
    String? appVersion,
    String? appBuild,
    String? osName,
    String? osVersion,
    String? detail,
    bool? isAuth,
    String? userId,
    String? emailDomain,
  }) =>
      EventProperties(
        appNamespace: appNamespace ?? this.appNamespace,
        appVersion: appVersion ?? this.appVersion,
        appBuild: appBuild ?? this.appBuild,
        osName: osName ?? this.osName,
        osVersion: osVersion ?? this.osVersion,
        detail: detail ?? this.detail,
        isAuth: isAuth ?? this.isAuth,
        userId: userId ?? this.userId,
        emailDomain: emailDomain ?? this.emailDomain,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map[r'$app_namespace'] = appNamespace;
    map[r'$app_version'] = appVersion;
    map[r'$app_build'] = appBuild;
    map[r'$os_name'] = osName;
    map[r'$os_version'] = osVersion;
    map['detail'] = detail;
    map['is_auth'] = isAuth;
    map['user_id'] = userId;
    map['email_domain'] = emailDomain;
    return map;
  }
}
