import 'package:intl/intl.dart'; // Đảm bảo bạn đã import thư viện intl

class DateUtilsCustom {
  // Hàm để định dạng DateTime thành chuỗi ngày tháng
  static String formatDate(DateTime? date) {
    if (date != null) {
      try {
        // Định dạng ngày tháng năm
        return DateFormat('dd/MM/yyyy').format(date); // Định dạng ngày
      } catch (e) {
        print("Error formatting date: $e"); // In ra lỗi nếu có
        return date.toString(); // Nếu không thể định dạng, giữ nguyên chuỗi
      }
    } else {
      return 'N/A'; // Hoặc một thông báo mặc định khác
    }
  }


  String formatToIso8601(DateTime dateTime) {
  return DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(dateTime);
}

  static String formatWithoutTime(DateTime dateTime) {
  return DateFormat("HH:mm dd/MM/yyyy").format(dateTime);
}

  // Hàm để định dạng DateTime thành chuỗi ngày tháng
  static String formatDateHour(DateTime? date ,{bool isHour = false}) {
    if (date != null) {
      try {
        // Định dạng ngày tháng năm
        return isHour ? DateFormat('HH:mm').format(date) : DateFormat('dd/MM : HH:mm').format(date); // Định dạng ngày
      } catch (e) {
        print("Error formatting date: $e"); // In ra lỗi nếu có
        return date.toString(); // Nếu không thể định dạng, giữ nguyên chuỗi
      }
    } else {
      return 'N/A'; // Hoặc một thông báo mặc định khác
    }
  }


    static String formatMoth(DateTime? date) {
    if (date != null) {
      try {
        // Định dạng ngày tháng năm
        return DateFormat('dd/MM').format(date); // Định dạng ngày
      } catch (e) {
        print("Error formatting date: $e"); // In ra lỗi nếu có
        return date.toString(); // Nếu không thể định dạng, giữ nguyên chuỗi
      }
    } else {
      return 'N/A'; // Hoặc một thông báo mặc định khác
    }
  }


static String formatTime(DateTime? date) {
  if (date == null) {
    return 'N/A';
  }

  try {
    final now = DateTime.now();
    final difference = now.difference(date);

    // Trong vòng 24 giờ
    if (difference.inHours < 24 && difference.inDays == 0) {
      if (difference.inMinutes == 0) {
        return 'Vừa xong';
      }
      if (difference.inHours < 1) {
        return '${difference.inMinutes.round()} phút trước';
      }
        return '${difference.inHours.round()} giờ trước';
    }
    // Trong vòng 7 ngày
    else if (difference.inDays <= 7) {
      return '${difference.inDays} ngày trước';
    }
    // Trong vòng 30 ngày
    else if (difference.inDays <= 30) {
      return '${(difference.inDays / 7).floor()} tuần trước';
    }
    // Trong vòng 12 tháng
    else if (difference.inDays <= 365) {
      return '${(difference.inDays / 30).floor()} tháng trước';
    }
    // Trên 1 năm
    else {
      return '${(difference.inDays / 365).floor()} năm trước';
    }
  } catch (e) {
    print("Error formatting date: $e");
    return date.toString();
  }
}

  // Hàm để chuyển đổi chuỗi ISO 8601 thành DateTime và định dạng
  static String formatStringDate(String? date, {bool isMoth = false, isHour = false}) {
    if (date != null && date.isNotEmpty) {
      try {
        DateTime dateTime = DateTime.parse(date); // Phân tích chuỗi ISO 8601 thành DateTime
        
        return isMoth ? formatMoth(dateTime) : isHour ? formatDateHour(dateTime) : formatDate(dateTime); // Sử dụng hàm formatDate để định dạng
      } catch (e) {
        print("Error parsing date: $e"); // In ra lỗi nếu có
        return date; // Nếu không thể phân tích, giữ nguyên chuỗi
      }
    } else {
      return 'N/A'; // Hoặc một thông báo mặc định khác
    }
  }


static String formatDateToVietnamese(String? dateString) {
  if (dateString == null || dateString.isEmpty) {
    return 'N/A';
  }

  // Chuyển chuỗi ngày thành DateTime
  DateTime dateTime = DateTime.parse(dateString);

  // Định dạng ngày, tháng, năm và thứ
  String formattedDate = DateFormat('EEEE, dd MMMM yyyy', 'vi_VN').format(dateTime);

  // Lấy giờ và phút
  int hour = dateTime.hour;
  int minute = dateTime.minute;

  // Xác định buổi sáng hoặc chiều
  String period = hour < 12 ? 'Sáng' : hour < 18 ? 'Chiều' : 'Tối';

  // Định dạng giờ phút
  String timeFormatted = '$hour:${minute.toString().padLeft(2, '0')} $period';

  // Kết hợp ngày và giờ
  return '$formattedDate $timeFormatted';
}




static String formatDateToVietnameseOptional(String? dateString) {
  if (dateString == null || dateString.isEmpty) {
    return 'N/A';
  }

  // Chuyển chuỗi ngày thành DateTime
  DateTime dateTime = DateTime.parse(dateString);

  // Định dạng ngày, tháng, năm và thứ
  String formattedDate = DateFormat('EEEE, dd MMMM yyyy', 'vi_VN').format(dateTime);




  // Kết hợp ngày và giờ
  return '$formattedDate';
}


static String formatDateToVietnameseOptionalevery(String? dateString) {
  if (dateString == null || dateString.isEmpty) {
    return 'N/A';
  }

  // Chuyển chuỗi ngày thành DateTime
  DateTime dateTime = DateTime.parse(dateString);

  // Định dạng ngày, tháng, năm và thứ
  String formattedDate = DateFormat('EEEE, dd MMMM', 'vi_VN').format(dateTime);




  // Kết hợp ngày và giờ
  return '$formattedDate';
}


}