import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:tcs_flutter/common/Services/device_udid.dart';

class CurrencyUtils {
  static String formatCurrency(double value) {
    try {
      return NumberFormat("#,##0", "vi_VN").format(value);
    } catch (e) {
      print("Error formatting currency: $e");
      return "Invalid number";
    }
  }

String getTextFromDescription(String description) {
  try {
    // Giải mã chuỗi JSON
    List<dynamic> decodedDescription = json.decode(description);

    // Kiểm tra nếu decodedDescription không rỗng và phần tử đầu tiên có trường 'content'
    if (decodedDescription.isNotEmpty) {
      // Lặp qua các phần tử trong decodedDescription để lấy tất cả nội dung text
      List<String> texts = [];
      for (var item in decodedDescription) {
        if (item['content'] != null) {
          // Kiểm tra từng phần tử của 'content' có trường 'text'
          for (var contentItem in item['content']) {
            if (contentItem['text'] != null) {
              texts.add(contentItem['text']);
            }
          }
        }
      }

      // Nếu tìm thấy các text, trả về chuỗi kết hợp các text với nhau
      if (texts.isNotEmpty) {
        return texts.join('\n'); // Nối các text với dấu xuống dòng
      }
    }
  } catch (e) {
    print('Error decoding description: $e');
  }

  return ''; // Trả về chuỗi rỗng nếu không có dữ liệu
}


  Future<List<Map<String, dynamic>>> sendCustomDescription(String description) async {
    DeviceUdid deviceUdid = await DeviceUdid.createDeviceUdid();
    String udid = await deviceUdid.getUdid();

    // Tạo dữ liệu cho trường "description"
    List<Map<String, dynamic>> descriptionData = [
      {
        "id": udid,
        "type": "paragraph",
        "props": {
          "textColor": "default",
          "backgroundColor": "default",
          "textAlignment": "left"
        },
        "content": [
          {"type": "text", "text": description, "styles": {}}
        ],
        "children": []
      }
    ];
    return descriptionData;
  }
}
