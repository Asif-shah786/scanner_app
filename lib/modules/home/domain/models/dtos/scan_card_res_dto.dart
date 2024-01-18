/// Represents a model of [ScanCardResDto]
class ScanCardResDto {
  /// [ScanCardResDto] constructor with named parameters.
  ScanCardResDto({
    this.data,
  });

  /// Creates a [ScanCardResDto] instance from a JSON map.
  ScanCardResDto.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? ScannedData.fromJson(json['data'] as Map<String, dynamic>)
        : null;
  }

  ///[data] param of type [ScannedData]
  ScannedData? data;

  /// Creates a copy of this [ScanCardResDto] instance with optional
  /// properties.
  ScanCardResDto copyWith({
    ScannedData? data,
  }) =>
      ScanCardResDto(
        data: data ?? this.data,
      );

  /// Converts this [ScanCardResDto] instance to a JSON map.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

/// Represents a model of [ScannedData]
class ScannedData {
  /// [ScannedData] constructor with named parameters.
  ScannedData({
    this.type,
    this.id,
    this.attributes,
  });

  /// Creates a [ScannedData] instance from a JSON map.
  ScannedData.fromJson(Map<String, dynamic> json) {
    type = json['type'] as String?;
    id = json['id'] as String?;
    attributes = json['attributes'] != null
        ? ScannedAttributes.fromJson(json['attributes'] as Map<String, dynamic>)
        : null;
  }

  ///[type] param of type [String]
  String? type;

  ///[id] param of type [String]
  String? id;

  ///[attributes] param of type [ScannedAttributes]
  ScannedAttributes? attributes;

  /// Creates a copy of this [ScannedData] instance with optional
  /// properties.
  ScannedData copyWith({
    String? type,
    String? id,
    ScannedAttributes? attributes,
  }) =>
      ScannedData(
        type: type ?? this.type,
        id: id ?? this.id,
        attributes: attributes ?? this.attributes,
      );

  /// Converts this [ScannedData] instance to a JSON map.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['id'] = id;
    if (attributes != null) {
      map['attributes'] = attributes?.toJson();
    }
    return map;
  }
}

/// Represents a model of [ScannedAttributes]
class ScannedAttributes {
  /// [ScannedAttributes] constructor with named parameters.
  ScannedAttributes({
    this.runtime,
    this.extraction,
  });

  /// Creates a [ScannedAttributes] instance from a JSON map.
  ScannedAttributes.fromJson(Map<String, dynamic> json) {
    runtime = json['runtime'] as num?;
    extraction = json['extraction'] != null
        ? Extraction.fromJson(json['extraction'] as Map<String, dynamic>)
        : null;
  }

  ///[runtime] param of type [num]
  num? runtime;

  ///[extraction] param of type [Extraction]
  Extraction? extraction;

  /// Creates a copy of this [ScannedAttributes] instance with optional
  /// properties.
  ScannedAttributes copyWith({
    num? runtime,
    Extraction? extraction,
  }) =>
      ScannedAttributes(
        runtime: runtime ?? this.runtime,
        extraction: extraction ?? this.extraction,
      );

  /// Converts this [ScannedAttributes] instance to a JSON map.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['runtime'] = runtime;
    if (extraction != null) {
      map['extraction'] = extraction?.toJson();
    }
    return map;
  }
}

/// Represents a model of [Extraction]
class Extraction {
  /// [Extraction] constructor with named parameters.
  Extraction({
    this.id,
    this.firstName,
    this.lastName,
    this.company,
    this.department,
    this.position,
    this.emails,
    this.phones,
    this.websites,
    this.addresses,
  });

  /// Creates a [Extraction] instance from a JSON map.
  Extraction.fromJson(Map<String, dynamic> json) {
    firstName = json['given_name'] as String?;
    id = json['id'] as int?;
    lastName = json['family_name'] as String?;
    company = json['company'] as String?;
    department = json['department'] as String?;
    position = json['position'] as String?;
    emails = json['emails'] as List<dynamic>?;
    phones = json['phones'] as List<dynamic>?;
    websites = json['websites'] as List<dynamic>?;
    addresses = json['addresses'] as List<dynamic>?;
  }

  ///[id] param of type [int]
  int? id;

  ///[firstName] param of type [String]
  String? firstName;

  ///[lastName] param of type [String]
  String? lastName;

  ///[department] param of type [String]
  String? department;

  ///[company] param of type [String]
  String? company;

  ///[position] param of type [String]
  String? position;

  ///[emails] param of type [List<String>]
  List<dynamic>? emails;

  ///[phones] param of type [List<String>]
  List<dynamic>? phones;

  ///[websites] param of type [List<String>]
  List<dynamic>? websites;

  ///[addresses] param of type [List<String>]
  List<dynamic>? addresses;

  /// Creates a copy of this [Extraction] instance with optional
  /// properties.
  Extraction copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? company,
    String? position,
    String? department,
    List<String>? emails,
    List<String>? phones,
    List<String>? websites,
    List<String>? addresses,
  }) =>
      Extraction(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        company: company ?? this.company,
        department: department ?? this.department,
        position: position ?? this.position,
        emails: emails ?? this.emails,
        phones: phones ?? this.phones,
        websites: websites ?? this.websites,
        addresses: addresses ?? this.addresses,
      );

  /// Converts this [Extraction] instance to a JSON map.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['given_name'] = firstName;
    map['family_name'] = lastName;
    map['company'] = company;
    map['department'] = department;
    map['position'] = position;
    map['emails'] = emails;
    map['phones'] = phones;
    map['websites'] = websites;
    map['addresses'] = addresses;
    return map;
  }
}
