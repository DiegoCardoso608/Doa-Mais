import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  static const String cloudName = 'dx43mbrhl';

  static const String uploadPreset =
      'Doa-mais-Imagens';

  Future<String?> uploadImagem() async {
    try {
      final picker = ImagePicker();

      final XFile? imagem =
          await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (imagem == null) {
        return null;
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
        ),
      );

      request.fields['upload_preset'] =
          uploadPreset;

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imagem.path,
        ),
      );

      final response =
          await request.send();

      final responseData =
          await response.stream.bytesToString();

      final data =
          jsonDecode(responseData);

      if (response.statusCode == 200) {
        return data['secure_url'];
      }

      throw Exception(data.toString());
    } catch (e) {
      throw Exception(
        'Erro ao enviar imagem: $e',
      );
    }
  }
}