import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

Future apiPostSignUp(data, profile) async {
  String address = '${dotenv.env['BASE_URI']}/account/signup';

  try {
    MultipartRequest request = MultipartRequest('POST', Uri.parse(address));
    print(profile);

    request.fields['userid'] = data['userid'];
    request.fields['password'] = data['password'];
    request.fields['username'] = data['username'];
    request.fields['birthday'] = data['birthday'];
    request.fields['phone'] = data['phone'];
    request.files.add(
      await MultipartFile.fromPath(
        'profile_image',
        profile['image'].path,
      ),
    );

    StreamedResponse res = await request.send();
    final body = await res.stream.bytesToString();
    print(body);
    return json.decode(body);
  } catch (e) {
    print('Error sending data to server: $e');
    return {'error': 'Error sending data to server'};
  }
}
