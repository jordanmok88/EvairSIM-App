import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

/// A customer order as returned by /v1/h5/orders/esim create or /v1/app/orders list.
@freezed
class AppOrder with _$AppOrder {
  const factory AppOrder({
    @JsonKey(name: 'order_no', readValue: _readOrderNo) required String orderNo,
    @JsonKey(readValue: _readStatus) required String status,

    /// Amount in USD. Backend sometimes returns cents (int), sometimes decimal — we normalise to USD double.
    @JsonKey(readValue: _readAmount) required double amount,
    @Default('USD') String currency,
    @JsonKey(name: 'package_code') String? packageCode,
    @JsonKey(name: 'package_name') String? packageName,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'paid_at') DateTime? paidAt,

    /// Populated once the eSIM has been provisioned (usually after payment). This
    /// is the SM-DP+ activation string that we render as a QR code.
    @JsonKey(name: 'lpa_code', readValue: _readLpa) String? lpaCode,

    /// ICCID of the eSIM that was allocated against this order — available on the
    /// order detail endpoint after provisioning completes.
    @JsonKey(name: 'iccid') String? iccid,
  }) = _AppOrder;

  factory AppOrder.fromJson(Map<String, dynamic> json) =>
      _$AppOrderFromJson(json);

  const AppOrder._();

  bool get isPending =>
      status.toUpperCase() == 'PENDING_PAYMENT' ||
      status.toLowerCase() == 'pending';
  bool get isPaid =>
      status.toUpperCase() == 'PAID' || status.toLowerCase() == 'paid';
}

Object? _readOrderNo(Map<dynamic, dynamic> json, String _) =>
    json['order_no'] ?? json['order_number'];

Object? _readStatus(Map<dynamic, dynamic> json, String _) =>
    json['status'] ?? 'pending';

Object? _readLpa(Map<dynamic, dynamic> json, String _) {
  // Different backends use different keys; check the known ones in order.
  final candidates = [
    json['lpa_code'],
    json['lpa'],
    json['lpa_string'],
    json['qr_code'],
    json['activation_code'],
  ];
  for (final c in candidates) {
    if (c is String && c.isNotEmpty) return c;
  }
  return null;
}

Object? _readAmount(Map<dynamic, dynamic> json, String _) {
  // H5 create returns amount as int cents (e.g. 220 = $2.20).
  // App list returns amount as decimal float (e.g. 2.2 = $2.20).
  final raw = json['amount'];
  if (raw is int) return raw / 100.0;
  if (raw is double) return raw;
  if (raw is num) return raw.toDouble();
  if (raw is String) return double.tryParse(raw) ?? 0.0;
  return 0.0;
}
