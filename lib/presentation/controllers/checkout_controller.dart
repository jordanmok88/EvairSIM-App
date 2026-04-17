import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/entities/order.dart';
import '../../domain/entities/payment_session.dart';
import '../../domain/repositories/order_repository.dart';
import '../providers/order_providers.dart';

class CheckoutState {
  const CheckoutState({
    this.isLoading = false,
    this.order,
    this.session,
    this.error,
    this.receiptSent = false,
  });

  final bool isLoading;
  final AppOrder? order;
  final PaymentSession? session;
  final String? error;
  final bool receiptSent;

  CheckoutState copyWith({
    bool? isLoading,
    AppOrder? order,
    PaymentSession? session,
    String? error,
    bool? receiptSent,
    bool clearError = false,
  }) {
    return CheckoutState(
      isLoading: isLoading ?? this.isLoading,
      order: order ?? this.order,
      session: session ?? this.session,
      error: clearError ? null : (error ?? this.error),
      receiptSent: receiptSent ?? this.receiptSent,
    );
  }
}

class CheckoutController extends StateNotifier<CheckoutState> {
  CheckoutController(this._repo) : super(const CheckoutState());
  final OrderRepository _repo;

  /// Creates an order then opens a Stripe payment session for it.
  Future<AppOrder?> startCheckout({
    required String packageCode,
    required String email,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final orderRes = await _repo.createEsimOrder(
      packageCode: packageCode,
      email: email,
    );

    final orderOrFail = orderRes.match<Either<String, AppOrder>>(
      (l) => Left(l.message),
      (r) => Right(r),
    );

    if (orderOrFail.isLeft()) {
      state = state.copyWith(
        isLoading: false,
        error: orderOrFail.swap().getOrElse((_) => 'Failed to create order'),
      );
      return null;
    }

    final order = orderOrFail.getOrElse((_) => throw Exception('impossible'));

    final sessionRes =
        await _repo.createPaymentSession(orderNo: order.orderNo);
    final sessionOrFail = sessionRes.match<Either<String, PaymentSession>>(
      (l) => Left(l.message),
      (r) => Right(r),
    );

    if (sessionOrFail.isLeft()) {
      state = state.copyWith(
        isLoading: false,
        order: order,
        error: sessionOrFail.swap().getOrElse((_) => 'Payment session failed'),
      );
      return order;
    }

    state = state.copyWith(
      isLoading: false,
      order: order,
      session: sessionOrFail.getOrElse((_) => throw Exception('impossible')),
    );
    return order;
  }

  /// Fire-and-forget receipt email (best effort).
  Future<void> sendReceipt() async {
    final order = state.order;
    if (order == null || state.receiptSent) return;
    final res = await _repo.sendReceiptEmail(orderNo: order.orderNo);
    res.match(
      (_) {},
      (_) => state = state.copyWith(receiptSent: true),
    );
  }

  void reset() => state = const CheckoutState();
}

final checkoutControllerProvider =
    StateNotifierProvider.autoDispose<CheckoutController, CheckoutState>(
  (ref) => CheckoutController(ref.watch(orderRepositoryProvider)),
);
