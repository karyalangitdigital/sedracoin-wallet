import 'dart:convert';

import 'package:http/http.dart' as http;

Future<num?> getSedraApiPrice(String fiat) async {
  try {
    final uri = Uri.https(
      'api.sedracoin.com',
      '/info/price',
    );

    final response = await http.get(uri, headers: {
      'Accept': 'application/json',
      'User-Agent': 'Sedra Wallet',
    });

    if (response.statusCode != 200) {
      return null;
    }

    final data = json.decode(response.body);
    if (data is Map && data.containsKey('price')) {
      return data['price'] as num;
    }
    return null;
  } catch (_) {
    return null;
  }
}

Future<num?> getCoinGeckoApiPrice(String fiat) async {
  try {
    final uri = Uri.https(
      'api.coingecko.com',
      '/api/v3/simple/price',
      {'ids': 'sedra-coin', 'vs_currencies': fiat},
    );
    final response = await http.get(uri, headers: {
      'Accept': 'application/json',
      'User-Agent': 'Sedra Wallet',
    });

    if (response.statusCode != 200) {
      return null;
    }
    final data = json.decode(response.body);
    if (data is! Map) {
      throw Exception('Returned data is not a Map');
    }
    final rates = data['sedra-coin'] as Map<String, dynamic>;
    return rates[fiat] as num;
  } catch (_) {
    return null;
  }
}
