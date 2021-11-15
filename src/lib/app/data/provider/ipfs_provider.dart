import 'dart:typed_data';

import 'package:get/get_connect.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IPFSProvider extends GetConnect {
  Future<String> uploadImage({
    required Uint8List file,
  }) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://api.nft.storage/upload'));
    request.files.add(http.MultipartFile.fromBytes(
      "file",
      file,
      filename: "Content-Disposition",
    ));
    request.headers.addAll({
      "Authorization":
          "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkaWQ6ZXRocjoweEU1MTBiMGRDQTI1NUJjMjk3OEQwMjZDNzc0Zjc0M0E1M2ViMGNENkIiLCJpc3MiOiJuZnQtc3RvcmFnZSIsImlhdCI6MTYzNjcxMzA4NjY2MCwibmFtZSI6Ik5GVCJ9.AWoc2fS5-602ObnLVJFZHROtawsK2iobN2zv2fMdPxY"
    });

    final response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = await response.stream.bytesToString();
      return jsonDecode(data)["value"]["cid"];
    } else {
      final data = await response.stream.bytesToString();
      throw Exception('MoonProvider Error: $data');
    }
  }
}
