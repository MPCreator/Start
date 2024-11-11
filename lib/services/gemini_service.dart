import 'dart:convert';  // For jsonEncode and jsonDecode
import 'package:http/http.dart' as http;
import '../config.dart';

Future<String?> fetchGeminiResponse(String prompt) async {
  const String url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey';

  final Map<String, dynamic> requestBody = {
    'contents': [
      {
        'parts': [
          {
            'text': prompt
          }
        ]
      }
    ],
    'safetySettings': [
      {
        'category': "HARM_CATEGORY_DANGEROUS_CONTENT",
        'threshold': "BLOCK_ONLY_HIGH"
      }
    ],
    'generationConfig': {
      'stopSequences': ["Title"],
      'temperature': 1.0
    }
  };

  try {
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String result = data['candidates'][0]['content']['parts'][0]['text'].trim();
      return result;
    } else {
      print('Error: ${response.statusCode} - ${response.reasonPhrase}');
      return null;
    }
  } catch (error) {
    print('Error fetching data from Gemini: $error');
    return null;
  }
}
