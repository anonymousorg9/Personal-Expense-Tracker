import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:personal_finance_tracker/features/exchange_rates/exchange_rate_card.dart';
import 'package:personal_finance_tracker/features/exchange_rates/exchange_rate_service.dart';

Map<String, Object> validRateJson() => {
  'date': '2026-10-20',
  'base': 'USD',
  'quote': 'INR',
  'rate': 94.85,
};

http.Response successResponse() => http.Response(
  jsonEncode(validRateJson()),
  200,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

Widget cardApp(ExchangeRateService service) {
  return MaterialApp(
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ExchangeRateCard(service: service),
      ),
    ),
  );
}

void main() {
  group('ExchangeRateService', () {
    test('requests and parses the USD/INR reference rate', () async {
      Uri? requestedUri;
      final client = MockClient((request) async {
        requestedUri = request.url;
        expect(request.method, 'GET');
        return successResponse();
      });
      final service = ExchangeRateService(client: client);

      final result = await service.fetchUsdToInr();

      expect(requestedUri, ExchangeRateService.usdInrEndpoint);
      expect(result.date, DateTime(2026, 10, 20));
      expect(result.base, 'USD');
      expect(result.quote, 'INR');
      expect(result.rate, 94.85);
      client.close();
    });

    test('reports non-success HTTP responses', () async {
      final client = MockClient(
        (_) async => http.Response('service unavailable', 503),
      );
      final service = ExchangeRateService(client: client);

      await expectLater(
        service.fetchUsdToInr(),
        throwsA(isA<ExchangeRateException>()),
      );
      client.close();
    });

    test('rejects malformed rate data', () async {
      final client = MockClient(
        (_) async => http.Response('{"base":"USD"}', 200),
      );
      final service = ExchangeRateService(client: client);

      await expectLater(
        service.fetchUsdToInr(),
        throwsA(isA<FormatException>()),
      );
      client.close();
    });
  });

  group('ExchangeRateCard', () {
    testWidgets('shows loading then the dated rate', (tester) async {
      final response = Completer<http.Response>();
      final client = MockClient((_) => response.future);
      final service = ExchangeRateService(client: client);

      await tester.pumpWidget(cardApp(service));
      expect(find.text('Loading daily exchange rate…'), findsOneWidget);

      response.complete(successResponse());
      await tester.pumpAndSettle();

      expect(find.text('1 USD = ₹94.85 INR'), findsOneWidget);
      expect(
        find.text('Daily reference · updated 20 Oct 2026'),
        findsOneWidget,
      );
      expect(find.textContaining('not a live trading quote'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(const SizedBox.shrink());
      client.close();
    });

    testWidgets('shows a retryable error and recovers', (tester) async {
      var attempts = 0;
      final client = MockClient((_) async {
        attempts++;
        return attempts == 1
            ? http.Response('service unavailable', 503)
            : successResponse();
      });
      final service = ExchangeRateService(client: client);

      await tester.pumpWidget(cardApp(service));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('usd-inr-rate-error')), findsOneWidget);

      await tester.tap(find.byKey(const Key('retry-usd-inr-rate')));
      await tester.pumpAndSettle();

      expect(attempts, 2);
      expect(find.text('1 USD = ₹94.85 INR'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(const SizedBox.shrink());
      client.close();
    });
  });
}
