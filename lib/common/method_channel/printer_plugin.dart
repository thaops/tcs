import 'package:flutter/services.dart';

class UrovoPrinter {
  static const MethodChannel _channel = MethodChannel('urovo_printer');

  Future<void> printText(String text) async {
    try {
      final result = await _channel.invokeMethod('printText', {
        'text': text,
      });
      print(result);
    } on PlatformException catch (e) {
      print("Failed to print text: '${e.message}'.");
    }
  }
}
