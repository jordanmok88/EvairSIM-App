import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

/// Backend response envelope: `{code, msg, data}`.
/// Success when `code == "0"` or `code == "SUCCESS"`.
@Freezed(genericArgumentFactories: true)
class ApiResponse<T> with _$ApiResponse<T> {
  const ApiResponse._();

  const factory ApiResponse({
    required String code,
    required String msg,
    T? data,
  }) = _ApiResponse;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  bool get isSuccess => code == '0' || code == 'SUCCESS' || code.toUpperCase() == 'OK';
}
