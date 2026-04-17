import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/user.dart';

part 'login_response_data.freezed.dart';
part 'login_response_data.g.dart';

/// Maps the `data` field of a successful /users/login or /users/register response.
/// Expected shape: `{ access_token, token_type?, expires_in?, user: {...} }`.
@freezed
class LoginResponseData with _$LoginResponseData {
  const factory LoginResponseData({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') String? refreshToken,
    @JsonKey(name: 'token_type') String? tokenType,
    @JsonKey(name: 'expires_in') int? expiresIn,
    required User user,
  }) = _LoginResponseData;

  factory LoginResponseData.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDataFromJson(json);
}
