import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ExchangeRateQuote {
  const ExchangeRateQuote({
    required this.date,
    required this.base,
    required this.quote,
    required this.rate,
  });

  final DateTime date;
  final String base;
  final String quote;
  final double rate;

  factory ExchangeRateQuote.fromJson(Object? value) {
    if (value is! Map<String, dynamic>) {
      throw const FormatException('Expected an exchange-rate object.');
    }

    final dateValue = value['date'];
    final baseValue = value['base'];
    final quoteValue = value['quote'];
    final rateValue = value['rate'];
    if (dateValue is! String ||
        baseValue != 'USD' ||
        quoteValue != 'INR' ||
        rateValue is! num ||
        !rateValue.isFinite ||
        rateValue <= 0) {
      throw const FormatException('The USD/INR response is incomplete.');
    }

    final date = DateTime.tryParse(dateValue);
    if (date == null) {
      throw const FormatException('The exchange-rate date is invalid.');
    }

    return ExchangeRateQuote(
      date: date,
      base: baseValue as String,
      quote: quoteValue as String,
      rate: rateValue.toDouble(),
    );
  }
}

class ExchangeRateException implements Exception {
  const ExchangeRateException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ExchangeRateService {
  ExchangeRateService({http.Client? client})
    : _client = client ?? http.Client(),
      _ownsClient = client == null;

  static final usdInrEndpoint = Uri.https(
    'api.frankfurter.dev',
    '/v2/rate/usd/inr',
  );

  final http.Client _client;
  final bool _ownsClient;

  Future<ExchangeRateQuote> fetchUsdToInr() async {
    final response = await _client
        .get(usdInrEndpoint)
        .timeout(const Duration(seconds: 8));

    if (response.statusCode != 200) {
      throw ExchangeRateException(
        'The exchange-rate service returned ${response.statusCode}.',
      );
    }

    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    return ExchangeRateQuote.fromJson(decoded);
  }

  void close() {
    if (_ownsClient) _client.close();
  }
}
