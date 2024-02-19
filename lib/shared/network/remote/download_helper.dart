  import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;


// to use this class put these packages into your dependencies:
// path_provider: ^2.0.11
// http: ^0.13.5
class Utils {
  static Future<String> downloadFile({
    required String url,
    required String fileName,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$fileName';
    final response = await http.get(Uri.parse(url));
    final file = File(path);
    await file.writeAsBytes(response.bodyBytes);
    return path;
  }
}
