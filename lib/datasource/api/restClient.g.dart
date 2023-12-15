// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restClient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InfoResponse _$InfoResponseFromJson(Map<String, dynamic> json) => InfoResponse(
      id: json['id'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      profile: json['profile'] == null
          ? null
          : Profile.fromJson(json['profile'] as Map<String, dynamic>),
      friendList: (json['friendList'] as List<dynamic>?)
          ?.map((e) => AccountModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      chatRooms: (json['chatRooms'] as List<dynamic>?)
          ?.map((e) => ChatRoomModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InfoResponseToJson(InfoResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'profile': instance.profile,
      'friendList': instance.friendList,
      'chatRooms': instance.chatRooms,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _RestClient implements RestClient {
  _RestClient(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'http://localhost:3000';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<InfoResponse> getInfo({List<String>? fields}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'fields': fields};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<InfoResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/account/info',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = InfoResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<void> patchDeviceToken(
    String udid,
    String token,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'udid': udid,
      'token': token,
    };
    await _dio.fetch<void>(_setStreamType<void>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/account/devices',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
