class HtmlUtils {
 static bool isHTML(String str) {
  final htmlRegex = RegExp(r'<[a-zA-Z][\s\S]*>', caseSensitive: false);
  return htmlRegex.hasMatch(str);
}
}
  
