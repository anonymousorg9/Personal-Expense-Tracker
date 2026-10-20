import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'exchange_rate_service.dart';

class ExchangeRateCard extends StatefulWidget {
  const ExchangeRateCard({super.key, this.service});

  final ExchangeRateService? service;

  @override
  State<ExchangeRateCard> createState() => _ExchangeRateCardState();
}

class _ExchangeRateCardState extends State<ExchangeRateCard> {
  late final ExchangeRateService _service;
  late final bool _ownsService;
  late Future<ExchangeRateQuote> _rateFuture;

  static final _inrFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '\u20B9',
    decimalDigits: 2,
  );
  static final _dateFormat = DateFormat('d MMM yyyy');

  @override
  void initState() {
    super.initState();
    _ownsService = widget.service == null;
    _service = widget.service ?? ExchangeRateService();
    _rateFuture = _service.fetchUsdToInr();
  }

  @override
  void dispose() {
    if (_ownsService) _service.close();
    super.dispose();
  }

  void _retry() {
    setState(() {
      _rateFuture = _service.fetchUsdToInr();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      key: const Key('usd-inr-rate-card'),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.currency_exchange_rounded,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Text(
                  'USD / INR reference rate',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            FutureBuilder<ExchangeRateQuote>(
              future: _rateFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const _RateLoadingState();
                }

                if (snapshot.hasError || snapshot.data == null) {
                  return _RateErrorState(onRetry: _retry);
                }

                final rate = snapshot.data!;
                return Column(
                  key: const Key('usd-inr-rate-success'),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1 ${rate.base} = ${_inrFormat.format(rate.rate)} ${rate.quote}',
                      key: const Key('usd-inr-rate-value'),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Daily reference · updated ${_dateFormat.format(rate.date)}',
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'For reference only; not a live trading quote.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RateLoadingState extends StatelessWidget {
  const _RateLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        SizedBox(width: 12),
        Text('Loading daily exchange rate…'),
      ],
    );
  }
}

class _RateErrorState extends StatelessWidget {
  const _RateErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.cloud_off_outlined,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text(
            'Exchange rate unavailable. The tracker still works offline.',
            key: Key('usd-inr-rate-error'),
          ),
        ),
        TextButton(
          key: const Key('retry-usd-inr-rate'),
          onPressed: onRetry,
          child: const Text('Retry'),
        ),
      ],
    );
  }
}
