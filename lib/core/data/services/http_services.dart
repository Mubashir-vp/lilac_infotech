import 'package:http/http.dart' as http;

class HttpServices {
  downloadVideo(String uri) async {
    return await http.get(
      Uri.parse(uri),
    );
  }
}
