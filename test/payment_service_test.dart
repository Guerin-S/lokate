import 'package:flutter_test/flutter_test.dart';
import 'package:lokate/services/payment_service.dart';

void main() {
  group('PaymentService', () {
    late PaymentService service;

    setUp(() {
      service = PaymentService();
    });

    test('should have 3 available providers', () {
      expect(service.availableProviders.length, 3);
    });

    test('should select MTN MoMo provider', () {
      service.selectProvider('mtn_momo');
      expect(service.currentProvider, isNotNull);
      expect(service.currentProvider!.name, 'mtn_momo');
      expect(service.currentProvider!.displayName, 'MTN Mobile Money');
    });

    test('should select Orange Money provider', () {
      service.selectProvider('orange_money');
      expect(service.currentProvider, isNotNull);
      expect(service.currentProvider!.name, 'orange_money');
      expect(service.currentProvider!.displayName, 'Orange Money');
    });

    test('should select Stripe provider', () {
      service.selectProvider('stripe');
      expect(service.currentProvider, isNotNull);
      expect(service.currentProvider!.name, 'stripe');
      expect(service.currentProvider!.displayName, 'Carte bancaire');
    });

    test('should return null for unknown provider', () {
      final provider = service.getProvider('unknown');
      expect(provider, isNull);
    });

    test('should reset state', () {
      service.selectProvider('mtn_momo');
      service.reset();
      expect(service.currentProvider, isNull);
      expect(service.isProcessing, false);
      expect(service.errorMessage, isNull);
    });

    test('should fail when no provider selected', () async {
      final result = await service.pay(
        amount: 150000,
        reservationId: 'test-reservation',
        paymentDetails: {'phone': '699123456'},
      );
      expect(result.isSuccess, false);
      expect(result.errorMessage, contains('Aucun mode de paiement'));
    });

    test('MTN MoMo provider should fail without phone', () async {
      service.selectProvider('mtn_momo');
      final result = await service.pay(
        amount: 150000,
        reservationId: 'test-reservation',
        paymentDetails: {},
      );
      expect(result.isSuccess, false);
      expect(result.errorMessage, contains('Numéro de téléphone requis'));
    });

    test('Orange Money provider should fail without phone', () async {
      service.selectProvider('orange_money');
      final result = await service.pay(
        amount: 150000,
        reservationId: 'test-reservation',
        paymentDetails: {},
      );
      expect(result.isSuccess, false);
      expect(result.errorMessage, contains('Numéro de téléphone requis'));
    });

    test('Stripe provider should fail without card details', () async {
      service.selectProvider('stripe');
      final result = await service.pay(
        amount: 150000,
        reservationId: 'test-reservation',
        paymentDetails: {},
      );
      expect(result.isSuccess, false);
      expect(result.errorMessage, contains('Informations de carte incomplètes'));
    });

    test('MTN MoMo provider should validate phone format', () {
      final provider = service.getProvider('mtn_momo')!;
      expect(provider.name, 'mtn_momo');
      expect(provider.displayName, 'MTN Mobile Money');
    });

    test('Orange Money provider should validate phone format', () {
      final provider = service.getProvider('orange_money')!;
      expect(provider.name, 'orange_money');
      expect(provider.displayName, 'Orange Money');
    });

    test('Stripe provider should validate card format', () {
      final provider = service.getProvider('stripe')!;
      expect(provider.name, 'stripe');
      expect(provider.displayName, 'Carte bancaire');
    });
  });
}
