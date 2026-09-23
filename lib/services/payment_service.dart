import 'package:flutter/material.dart';

enum PaymentStatus {
  pending,
  processing,
  success,
  failed,
  cancelled,
}

class PaymentResult {
  final PaymentStatus status;
  final String? transactionId;
  final String? errorMessage;

  const PaymentResult({
    required this.status,
    this.transactionId,
    this.errorMessage,
  });

  bool get isSuccess => status == PaymentStatus.success;
}

abstract class PaymentProvider {
  String get name;
  String get displayName;
  IconData get icon;

  Future<PaymentResult> initiatePayment({
    required double amount,
    required String currency,
    required String reservationId,
    required Map<String, String> paymentDetails,
  });

  Future<PaymentResult> checkStatus(String transactionId);
}

class MTNMoMoProvider extends PaymentProvider {
  @override
  String get name => 'mtn_momo';
  @override
  String get displayName => 'MTN Mobile Money';
  @override
  IconData get icon => Icons.phone_android;

  @override
  Future<PaymentResult> initiatePayment({
    required double amount,
    required String currency,
    required String reservationId,
    required Map<String, String> paymentDetails,
  }) async {
    final phone = paymentDetails['phone'];
    if (phone == null || phone.isEmpty) {
      return const PaymentResult(
        status: PaymentStatus.failed,
        errorMessage: 'Numéro de téléphone requis',
      );
    }

    try {
      // TODO: Integrate with MTN MoMo API
      // POST https://sandbox.momodeveloper.mtn.com/collection/v1_0/requesttopay
      // Headers: Authorization, X-Reference-Id, X-Target-Environment
      // Body: { amount, currency, externalId, payer: { partyIdType: "MSISDN", partyId } }

      await Future.delayed(const Duration(seconds: 2));
      return PaymentResult(
        status: PaymentStatus.success,
        transactionId: 'MTN-${DateTime.now().millisecondsSinceEpoch}',
      );
    } catch (e) {
      return PaymentResult(
        status: PaymentStatus.failed,
        errorMessage: 'Erreur MTN MoMo: $e',
      );
    }
  }

  @override
  Future<PaymentResult> checkStatus(String transactionId) async {
    return const PaymentResult(status: PaymentStatus.success);
  }
}

class OrangeMoneyProvider extends PaymentProvider {
  @override
  String get name => 'orange_money';
  @override
  String get displayName => 'Orange Money';
  @override
  IconData get icon => Icons.phone_android;

  @override
  Future<PaymentResult> initiatePayment({
    required double amount,
    required String currency,
    required String reservationId,
    required Map<String, String> paymentDetails,
  }) async {
    final phone = paymentDetails['phone'];
    if (phone == null || phone.isEmpty) {
      return const PaymentResult(
        status: PaymentStatus.failed,
        errorMessage: 'Numéro de téléphone requis',
      );
    }

    try {
      // TODO: Integrate with Orange Money API
      // POST https://api.orange.com/orange-money-webpay/cm/v1/webpayment
      // Headers: Authorization: Bearer {token}
      // Body: { merchant_key, currency, order_id, amount, return_url, cancel_url, notif_url }

      await Future.delayed(const Duration(seconds: 2));
      return PaymentResult(
        status: PaymentStatus.success,
        transactionId: 'OM-${DateTime.now().millisecondsSinceEpoch}',
      );
    } catch (e) {
      return PaymentResult(
        status: PaymentStatus.failed,
        errorMessage: 'Erreur Orange Money: $e',
      );
    }
  }

  @override
  Future<PaymentResult> checkStatus(String transactionId) async {
    return const PaymentResult(status: PaymentStatus.success);
  }
}

class StripeProvider extends PaymentProvider {
  @override
  String get name => 'stripe';
  @override
  String get displayName => 'Carte bancaire';
  @override
  IconData get icon => Icons.credit_card;

  @override
  Future<PaymentResult> initiatePayment({
    required double amount,
    required String currency,
    required String reservationId,
    required Map<String, String> paymentDetails,
  }) async {
    final cardNumber = paymentDetails['cardNumber'];
    final expiry = paymentDetails['expiry'];
    final cvv = paymentDetails['cvv'];

    if (cardNumber == null || expiry == null || cvv == null) {
      return const PaymentResult(
        status: PaymentStatus.failed,
        errorMessage: 'Informations de carte incomplètes',
      );
    }

    try {
      // TODO: Integrate with Stripe
      // 1. Create PaymentIntent on your backend
      //    POST /create-payment-intent { amount, currency }
      // 2. Confirm payment on client
      //    Stripe.instance.confirmPaymentSheetPayment(...)
      // 3. Handle result

      // With flutter_stripe:
      // await Stripe.instance.initPaymentSheet(
      //   paymentSheetParameters: SetupPaymentSheetParameters(
      //     paymentIntentClientSecret: clientSecret,
      //     merchantDisplayName: 'LOKATE',
      //     style: ThemeMode.system,
      //   ),
      // );
      // await Stripe.instance.presentPaymentSheet();

      await Future.delayed(const Duration(seconds: 2));

      return PaymentResult(
        status: PaymentStatus.success,
        transactionId: 'STR-${DateTime.now().millisecondsSinceEpoch}',
      );
    } catch (e) {
      return PaymentResult(
        status: PaymentStatus.failed,
        errorMessage: 'Erreur Stripe: $e',
      );
    }
  }

  @override
  Future<PaymentResult> checkStatus(String transactionId) async {
    return const PaymentResult(status: PaymentStatus.success);
  }
}

class PaymentService extends ChangeNotifier {
  final Map<String, PaymentProvider> _providers = {
    'mtn_momo': MTNMoMoProvider(),
    'orange_money': OrangeMoneyProvider(),
    'stripe': StripeProvider(),
  };

  PaymentProvider? _currentProvider;
  PaymentStatus _status = PaymentStatus.pending;
  String? _errorMessage;
  bool _isProcessing = false;

  PaymentProvider? get currentProvider => _currentProvider;
  PaymentStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isProcessing => _isProcessing;

  List<PaymentProvider> get availableProviders => _providers.values.toList();

  PaymentProvider? getProvider(String name) => _providers[name];

  void selectProvider(String name) {
    _currentProvider = _providers[name];
    notifyListeners();
  }

  Future<PaymentResult> pay({
    required double amount,
    required String reservationId,
    required Map<String, String> paymentDetails,
  }) async {
    if (_currentProvider == null) {
      return const PaymentResult(
        status: PaymentStatus.failed,
        errorMessage: 'Aucun mode de paiement sélectionné',
      );
    }

    _isProcessing = true;
    _status = PaymentStatus.processing;
    _errorMessage = null;
    notifyListeners();

    final result = await _currentProvider!.initiatePayment(
      amount: amount,
      currency: 'FCFA',
      reservationId: reservationId,
      paymentDetails: paymentDetails,
    );

    _status = result.status;
    _errorMessage = result.errorMessage;
    _isProcessing = false;
    notifyListeners();

    return result;
  }

  void reset() {
    _currentProvider = null;
    _status = PaymentStatus.pending;
    _errorMessage = null;
    _isProcessing = false;
    notifyListeners();
  }
}
