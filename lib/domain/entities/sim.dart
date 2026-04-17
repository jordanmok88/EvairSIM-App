import 'package:freezed_annotation/freezed_annotation.dart';

part 'sim.freezed.dart';
part 'sim.g.dart';

/// A SIM (eSIM or physical) bound to the user account.
/// Union of fields we see across /v1/h5/user/sims, /v1/app/users/sims,
/// and the per-SIM detail endpoints.
@freezed
class Sim with _$Sim {
  const factory Sim({
    required String iccid,
    String? status,
    String? type,
    @JsonKey(name: 'package_name') String? packageName,
    @JsonKey(name: 'country_code') String? countryCode,
    @JsonKey(name: 'country_name') String? countryName,

    /// Total data in bytes.
    @JsonKey(name: 'data_total_bytes') int? totalBytes,
    @JsonKey(name: 'data_used_bytes') int? usedBytes,
    @JsonKey(name: 'data_remaining_bytes') int? remainingBytes,

    /// ISO-8601 expiry timestamp.
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    @JsonKey(name: 'activated_at') DateTime? activatedAt,

    /// eSIM QR / LPA fields (only present for eSIMs).
    String? qrcode,
    @JsonKey(name: 'ac_code') String? acCode,
    @JsonKey(name: 'lpa_code') String? lpaCode,
    @JsonKey(name: 'smdp_address') String? smdpAddress,
  }) = _Sim;

  factory Sim.fromJson(Map<String, dynamic> json) => _$SimFromJson(json);

  const Sim._();

  /// Percent used as 0..1. Null when unknown.
  double? get usagePercent {
    final total = totalBytes;
    final used = usedBytes;
    if (total == null || total <= 0 || used == null) return null;
    return (used / total).clamp(0.0, 1.0);
  }

  String get remainingDisplay {
    final remaining = remainingBytes ??
        ((totalBytes ?? 0) - (usedBytes ?? 0));
    return _bytesToHuman(remaining.clamp(0, 1 << 62));
  }

  String get totalDisplay => _bytesToHuman(totalBytes ?? 0);
  String get usedDisplay => _bytesToHuman(usedBytes ?? 0);

  /// Days until expiry. Negative when already expired. Null when unknown.
  int? get daysLeft {
    final exp = expiresAt;
    if (exp == null) return null;
    final diff = exp.difference(DateTime.now()).inDays;
    return diff;
  }

  bool get isEsim => (type ?? '').toUpperCase().contains('ESIM');
  bool get isInstalled =>
      (status ?? '').toUpperCase() != 'RELEASED' &&
      (status ?? '').toUpperCase() != 'NEW';
}

String _bytesToHuman(int bytes) {
  if (bytes <= 0) return '0 MB';
  const gb = 1024 * 1024 * 1024;
  const mb = 1024 * 1024;
  if (bytes >= gb) {
    final v = bytes / gb;
    return v == v.roundToDouble()
        ? '${v.toInt()} GB'
        : '${v.toStringAsFixed(1)} GB';
  }
  final v = bytes / mb;
  return '${v.toStringAsFixed(0)} MB';
}
