import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseApi {
  static const _apiKey = 'appl_toUfVdcFmkpqtVfByEXhChOLlmL';

  static Future init() async {
    await Purchases.setLogLevel(LogLevel.debug);
    PurchasesConfiguration configuration;
    configuration = PurchasesConfiguration(_apiKey);
    await Purchases.configure(configuration);
  }

  // static Future purchasePackage() async {
  //   try {
  //     var offerings = await Purchases.getOfferings();
  //     CustomerInfo customerInfo = await Purchases.purchasePackage(
  //         offerings.current!.availablePackages.first);
  //     var isPro = customerInfo.entitlements.all['Truth or Dare']!.isActive;
  //     if (isPro) {
  //       // Unlock that great "pro" content
  //     }
  //   } on PlatformException catch (e) {
  //     var errorCode = PurchasesErrorHelper.getErrorCode(e);
  //     if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
  //       throw Exception;
  //     }
  //   }
  // }
}
