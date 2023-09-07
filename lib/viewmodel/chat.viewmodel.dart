import 'package:flutter/material.dart';
import 'package:cookie_app/viewmodel/chat/room.viewmodel.dart';
import 'package:logging/logging.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatViewModel extends ChangeNotifier {
  static final log = Logger('ChatViewModel');
  static final Socket socket = io(
    OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .enableReconnection()
        .build(),
  );

  void connect() {
    log.info("socket connected; id: ${socket.id}");
    socket.connect();
  }

  void disconnect() {
    socket.disconnect();
  }

  ChatViewModel();
  List<ChatRoomViewModel> _roomViewModel = [];
  List<ChatRoomViewModel> get roomViewModel => _roomViewModel;

  void addRoom(ChatRoomViewModel room) {
    // TODO: add room to server
    _roomViewModel.add(room);
  }

  void removeRoom(ChatRoomViewModel room) {
    // TODO: remove room to server
    _roomViewModel.remove(room);
  }

  void updateRoom(ChatRoomViewModel room) {
    // TODO: update room from server
    _roomViewModel[_roomViewModel.indexOf(room)] = room;
  }

  void updateRooms(List<ChatRoomViewModel> rooms) {
    // TODO: update rooms from server
    _roomViewModel = rooms;
  }
}
