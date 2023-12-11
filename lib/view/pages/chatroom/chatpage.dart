import 'dart:io';

import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:cookie_app/service/account.service.dart';
import 'package:cookie_app/viewmodel/chat/chatroom.viewmodel.dart';

class ChatPage extends StatefulWidget {
  final ChatRoomViewModel room;

  const ChatPage({
    super.key,
    required this.room,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final types.User _user;
  late ChatRoomViewModel _room;
  late List<types.Message> _messages;

  @override
  void initState() {
    super.initState();
    _user = context.read<AccountService>().my.toFlyer;
    this._room = widget.room;
    this._messages = widget.room.messages;

    // Just notice that this way also works.
    // widget.room.addListener(() {
    //   setState(() {
    //     _messages = widget.room.messages;
    //   });
    // });
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) => Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  title: const Text('Photo'),
                  leading: const Icon(Icons.photo),
                  onTap: _handleImageSelection,
                ),
                ListTile(
                  title: const Text('File'),
                  leading: const Icon(Icons.attach_file),
                  onTap: _handleFileSelection,
                ),
                ListTile(
                  title: const Text('Cancel'),
                  leading: const Icon(Icons.cancel),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleFileSelection() async {
    Navigator.pop(context);
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      sendChat(message);
    }
  }

  void _handleImageSelection() async {
    Navigator.pop(context);
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        // Should be uploaded to server in real app
        uri: result.path,
        width: image.width.toDouble(),
      );

      sendChat(message);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          this._room.updateChat(index, updatedMessage);

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          this._room.updateChat(index, updatedMessage);
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );
    this._room.updateChat(index, updatedMessage);
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    sendChat(textMessage);
  }

  void sendChat(types.Message message) {
    this._room.sendChat(message);
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider.value(
        value: this._room,
        builder: (context, chiid) => Scaffold(
          appBar: AppBar(
            title: Text(this._room.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.exit_to_app),
                onPressed: () {
                  _room.leave();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          body: Chat(
            theme: DefaultChatTheme(
              // inputPadding: EdgeInsets.all(24),
              inputBackgroundColor: Colors.orangeAccent,
              inputTextStyle: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              inputTextDecoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.orangeAccent,
                  ),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              inputTextColor: Colors.black,
            ),
            messages: context.watch<ChatRoomViewModel>().messages,
            onAttachmentPressed: _handleAttachmentPressed,
            onMessageTap: _handleMessageTap,
            onPreviewDataFetched: _handlePreviewDataFetched,
            onSendPressed: _handleSendPressed,
            showUserAvatars: true,
            showUserNames: true,
            user: _user,
          ),
        ),
      );
}
