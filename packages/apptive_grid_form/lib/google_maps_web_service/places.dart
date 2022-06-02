// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:convert';

import 'package:apptive_grid_form/google_maps_web_service/core.dart';
import 'package:apptive_grid_form/google_maps_web_service/utils.dart';
import 'package:http/http.dart';

part 'places.g.dart';

const _placesUrl = '/place';
const _detailsSearchUrl = '/details/json';
const _queryAutocompleteUrl = '/queryautocomplete/json';

/// https://developers.google.com/places/web-service/
class GoogleMapsPlaces extends GoogleWebService {
  GoogleMapsPlaces({
    String? apiKey,
    String? baseUrl,
    Client? httpClient,
    Map<String, String>? apiHeaders,
  }) : super(
          apiKey: apiKey,
          baseUrl: baseUrl,
          apiPath: _placesUrl,
          httpClient: httpClient,
          apiHeaders: apiHeaders,
        );

  Future<PlacesDetailsResponse> getDetailsByPlaceId(
    String placeId, {
    String? sessionToken,
    List<String> fields = const [],
    String? language,
    String? region,
  }) async {
    final url = buildDetailsUrl(
      placeId: placeId,
      sessionToken: sessionToken,
      fields: fields,
      language: language,
      region: region,
    );
    return _decodeDetailsResponse(await doGet(url, headers: apiHeaders));
  }

  Future<PlacesAutocompleteResponse> queryAutocomplete(
    String input, {
    num? offset,
    Location? location,
    num? radius,
    String? language,
  }) async {
    final url = buildQueryAutocompleteUrl(
      input: input,
      location: location,
      offset: offset,
      radius: radius,
      language: language,
    );
    return _decodeAutocompleteResponse(await doGet(url, headers: apiHeaders));
  }

  String buildDetailsUrl({
    String? placeId,
    String? reference,
    String? sessionToken,
    String? language,
    List<String> fields = const [],
    String? region,
  }) {
    if (placeId != null && reference != null) {
      throw ArgumentError("You must supply either 'placeid' or 'reference'");
    }

    final params = <String, String>{};

    if (placeId != null) {
      params['placeid'] = placeId;
    }

    if (reference != null) {
      params['reference'] = reference;
    }

    if (language != null) {
      params['language'] = language;
    }

    if (region != null) {
      params['region'] = region;
    }

    if (fields.isNotEmpty) {
      params['fields'] = fields.join(',');
    }

    if (apiKey != null) {
      params['key'] = apiKey!;
    }

    if (sessionToken != null) {
      params['sessiontoken'] = sessionToken;
    }

    return url
        .replace(
          path: '${url.path}$_detailsSearchUrl',
          queryParameters: params,
        )
        .toString();
  }

  String buildQueryAutocompleteUrl({
    required String input,
    num? offset,
    Location? location,
    num? radius,
    String? language,
  }) {
    final params = <String, String>{
      'input': input,
    };

    if (language != null) {
      params['language'] = language;
    }

    if (location != null) {
      params['location'] = location.toString();
    }

    if (radius != null) {
      params['radius'] = radius.toString();
    }

    if (offset != null) {
      params['offset'] = offset.toString();
    }

    if (apiKey != null) {
      params['key'] = apiKey!;
    }

    return url
        .replace(
          path: '${url.path}$_queryAutocompleteUrl',
          queryParameters: params,
        )
        .toString();
  }

  PlacesDetailsResponse _decodeDetailsResponse(Response res) =>
      PlacesDetailsResponse.fromJson(json.decode(res.body));

  PlacesAutocompleteResponse _decodeAutocompleteResponse(Response res) =>
      PlacesAutocompleteResponse.fromJson(json.decode(res.body));
}

class PlaceDetails {
  PlaceDetails({
    this.adrAddress,
    required this.name,
    required this.placeId,
    this.utcOffset,
    this.id,
    this.internationalPhoneNumber,
    this.addressComponents = const [],
    this.photos = const [],
    this.types = const [],
    this.reviews = const [],
    this.formattedAddress,
    this.formattedPhoneNumber,
    this.reference,
    this.icon,
    this.rating,
    this.openingHours,
    this.priceLevel,
    this.scope,
    this.url,
    this.vicinity,
    this.website,
    this.geometry,
  });

  factory PlaceDetails.fromJson(Map<String, dynamic> json) =>
      _$PlaceDetailsFromJson(json);

  /// JSON address_components

  final List<AddressComponent> addressComponents;

  /// JSON adr_address
  final String? adrAddress;

  /// JSON formatted_address
  final String? formattedAddress;

  /// JSON formatted_phone_number
  final String? formattedPhoneNumber;

  final String? id;

  final String? reference;

  final String? icon;

  final String name;

  /// JSON opening_hours
  final OpeningHoursDetail? openingHours;

  final List<Photo> photos;

  /// JSON place_id
  final String placeId;

  /// JSON international_phone_number
  final String? internationalPhoneNumber;

  /// JSON price_level
  final PriceLevel? priceLevel;

  final num? rating;

  final String? scope;

  final List<String> types;

  final String? url;

  final String? vicinity;

  /// JSON utc_offset
  final num? utcOffset;

  final String? website;

  final List<Review> reviews;

  final Geometry? geometry;
  Map<String, dynamic> toJson() => _$PlaceDetailsToJson(this);
}

class OpeningHoursDetail {
  factory OpeningHoursDetail.fromJson(Map<String, dynamic> json) =>
      _$OpeningHoursDetailFromJson(json);

  OpeningHoursDetail({
    this.openNow = false,
    this.periods = const <OpeningHoursPeriod>[],
    this.weekdayText = const <String>[],
  });
  final bool openNow;

  final List<OpeningHoursPeriod> periods;

  final List<String> weekdayText;
  Map<String, dynamic> toJson() => _$OpeningHoursDetailToJson(this);
}

class OpeningHoursPeriodDate {
  factory OpeningHoursPeriodDate.fromJson(Map<String, dynamic> json) =>
      _$OpeningHoursPeriodDateFromJson(json);

  OpeningHoursPeriodDate({required this.day, required this.time});
  final int day;
  final String time;

  /// UTC Time
  @Deprecated('use `toDateTime()`')
  DateTime get dateTime => toDateTime();

  DateTime toDateTime() => dayTimeToDateTime(day, time);
  Map<String, dynamic> toJson() => _$OpeningHoursPeriodDateToJson(this);
}

class OpeningHoursPeriod {
  OpeningHoursPeriod({this.open, this.close});

  factory OpeningHoursPeriod.fromJson(Map<String, dynamic> json) =>
      _$OpeningHoursPeriodFromJson(json);
  final OpeningHoursPeriodDate? open;
  final OpeningHoursPeriodDate? close;
  Map<String, dynamic> toJson() => _$OpeningHoursPeriodToJson(this);
}

class Photo {
  Photo({
    required this.photoReference,
    required this.height,
    required this.width,
    this.htmlAttributions = const <String>[],
  });

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);

  /// JSON photo_reference
  final String photoReference;
  final num height;
  final num width;

  /// JSON html_attributions

  final List<String> htmlAttributions;
  Map<String, dynamic> toJson() => _$PhotoToJson(this);
}

enum PriceLevel {
  free,

  inexpensive,

  moderate,

  expensive,

  veryExpensive,
}

class PlacesDetailsResponse extends GoogleResponseStatus {
  factory PlacesDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$PlacesDetailsResponseFromJson(json);

  PlacesDetailsResponse({
    required String status,
    String? errorMessage,
    required this.result,
    required this.htmlAttributions,
  }) : super(
          status: status,
          errorMessage: errorMessage,
        );
  final PlaceDetails result;

  /// JSON html_attributions

  final List<String> htmlAttributions;
  Map<String, dynamic> toJson() => _$PlacesDetailsResponseToJson(this);
}

class Review {
  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Review({
    required this.authorName,
    required this.authorUrl,
    required this.language,
    required this.profilePhotoUrl,
    required this.rating,
    required this.relativeTimeDescription,
    required this.text,
    required this.time,
  });

  /// JSON author_name
  final String authorName;

  /// JSON author_url
  final String authorUrl;

  final String? language;

  /// JSON profile_photo_url
  final String profilePhotoUrl;

  final num rating;

  /// JSON relative_time_description
  final String relativeTimeDescription;

  final String text;

  final num time;
  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}

class PlacesAutocompleteResponse extends GoogleResponseStatus {
  PlacesAutocompleteResponse({
    required String status,
    String? errorMessage,
    required this.predictions,
  }) : super(
          status: status,
          errorMessage: errorMessage,
        );

  factory PlacesAutocompleteResponse.fromJson(Map<String, dynamic> json) =>
      _$PlacesAutocompleteResponseFromJson(json);
  final List<Prediction> predictions;
  Map<String, dynamic> toJson() => _$PlacesAutocompleteResponseToJson(this);
}

class Prediction {
  factory Prediction.fromJson(Map<String, dynamic> json) =>
      _$PredictionFromJson(json);

  Prediction({
    this.description,
    this.id,
    this.terms = const <Term>[],
    this.distanceMeters,
    this.placeId,
    this.reference,
    this.types = const <String>[],
    this.matchedSubstrings = const <MatchedSubstring>[],
    this.structuredFormatting,
  });
  final String? description;
  final String? id;

  final List<Term> terms;

  final int? distanceMeters;

  /// JSON place_id
  final String? placeId;
  final String? reference;

  final List<String> types;

  /// JSON matched_substrings

  final List<MatchedSubstring> matchedSubstrings;

  final StructuredFormatting? structuredFormatting;
  Map<String, dynamic> toJson() => _$PredictionToJson(this);
}

class Term {
  Term({
    required this.offset,
    required this.value,
  });

  factory Term.fromJson(Map<String, dynamic> json) => _$TermFromJson(json);
  final num offset;
  final String value;
  Map<String, dynamic> toJson() => _$TermToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Term &&
          runtimeType == other.runtimeType &&
          offset == other.offset &&
          value == other.value;

  @override
  int get hashCode => offset.hashCode ^ value.hashCode;
}

class MatchedSubstring {
  MatchedSubstring({
    required this.offset,
    required this.length,
  });

  factory MatchedSubstring.fromJson(Map<String, dynamic> json) =>
      _$MatchedSubstringFromJson(json);
  final num offset;
  final num length;
  Map<String, dynamic> toJson() => _$MatchedSubstringToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchedSubstring &&
          runtimeType == other.runtimeType &&
          offset == other.offset &&
          length == other.length;

  @override
  int get hashCode => offset.hashCode ^ length.hashCode;
}

class StructuredFormatting {
  factory StructuredFormatting.fromJson(Map<String, dynamic> json) =>
      _$StructuredFormattingFromJson(json);

  StructuredFormatting({
    required this.mainText,
    this.mainTextMatchedSubstrings = const <MatchedSubstring>[],
    this.secondaryText,
  });
  final String mainText;

  final List<MatchedSubstring> mainTextMatchedSubstrings;
  final String? secondaryText;
  Map<String, dynamic> toJson() => _$StructuredFormattingToJson(this);
}
