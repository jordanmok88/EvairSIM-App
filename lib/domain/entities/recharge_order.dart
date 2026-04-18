import 'package:freezed_annotation/freezed_annotation.dart';

part 'recharge_order.freezed.dart';
part 'recharge_order.g.dart';

/// Customer-facing view of a `recharge_records` row returned by
/// `POST /v1/app/recharge`, `GET /v1/app/recharge-records`, and
/// `GET /v1/app/recharge-records/{id}`.
///
/// This is NOT the same as `AppOrder` — the admin portal's recharge flow
/// lives in its own table (`recharge_records`) and has its own status
/// machine. We keep them separate so eSIM marketplace orders (legacy)
/// don't leak into top-up logic.
@freezed
class RechargeOrder with _$RechargeOrder {
  const factory RechargeOrder({
    required int id,

    /// Public-facing order number, e.g. `RCHG-20260418-000123`.
    @JsonKey(name: 'order_id') String? orderNo,
    String? iccid,
    @JsonKey(name: 'plan_name') String? planName,
    @JsonKey(name: 'package_code') String? packageCode,
    @JsonKey(name: 'supplier_type') String? supplierType,
    @JsonKey(name: 'data_amount') int? dataBytes,
    @JsonKey(name: 'data_display') String? dataDisplay,
    @JsonKey(name: 'validity_days') int? validityDays,
    @Default(0.0) double amount,
    @Default('USD') String currency,
    @JsonKey(name: 'order_status') String? orderStatus,
    @JsonKey(name: 'payment_status') String? paymentStatus,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'paid_at') DateTime? paidAt,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'failed_at') DateTime? failedAt,
    @JsonKey(name: 'failure_reason') String? failureReason,
  }) = _RechargeOrder;

  factory RechargeOrder.fromJson(Map<String, dynamic> json) =>
      _$RechargeOrderFromJson(json);

  const RechargeOrder._();

  bool get isPaid =>
      (paymentStatus ?? '').toLowerCase() == 'paid' ||
      (paymentStatus ?? '').toLowerCase() == 'completed';

  bool get isPending =>
      (paymentStatus ?? '').toLowerCase() == 'unpaid' ||
      (paymentStatus ?? '').toLowerCase() == 'pending';

  bool get isFailed =>
      (orderStatus ?? '').toLowerCase() == 'failed' ||
      (paymentStatus ?? '').toLowerCase() == 'failed';

  String get amountDisplay => '\$${amount.toStringAsFixed(2)}';
}
