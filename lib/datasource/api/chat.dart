import 'dart:convert';
import 'package:cookie_app/repository/jwt.repo.dart';
import 'package:cookie_app/types/api/chat/create_room.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';

@Deprecated("use socket.io create_room event instead")
class ChatAPI {
  static Logger log = Logger('ChatAPI');
  static Future<CreateRoomResponse> postCreateRoom(
    CreateRoomRequest request,
  ) async {
    Response res = await post(
      Uri(
        scheme: dotenv.env['API_SCHEME'],
        host: dotenv.env['API_HOST'],
        port: int.parse(dotenv.env['API_PORT']!),
        path: '/chat/create_room',
      ),
      headers: {
        'Authorization': 'Bearer ${JWTRepository.token}',
      },
      body: {
        'name': request.name,
        'members': request.members,
      },
    );

    if (res.statusCode == 200) {
      log.info('create room success');
    } else {
      log.warning('create room failed');
    }

    return CreateRoomResponse.fromJson(json.decode(res.body));
  }
}
