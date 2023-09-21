import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseApi {
  static const _apiKey = 'appl_toUfVdcFmkpqtVfByEXhChOLlmL';

  static Future init() async {
    await Purchases.setLogLevel(LogLevel.debug);
    PurchasesConfiguration configuration;
    configuration = PurchasesConfiguration(_apiKey);
    await Purchases.configure(configuration);
  }
}
