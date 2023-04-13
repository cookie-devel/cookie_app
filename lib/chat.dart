import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cookie_app/friends.dart';
import 'package:cookie_app/handler/socket.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Chat extends StatelessWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ko', 'KR'),
      ],
      home: ChatWidget(),
    );
  }
}

class ChatWidget extends StatefulWidget {

  final FriendInfo? user;

  const ChatWidget({Key? key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {

  List messages = [];

  final chatFieldController = TextEditingController();
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    socket.on('chat message', (data) {
      if (mounted) {
        setState(() {
          messages.add(data);
        });
      }
    });
  }

  send() {
    if (chatFieldController.text.trim().isNotEmpty) {
      socket.emit("chat message", chatFieldController.text);
      chatFieldController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return chatStructure();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    chatFieldController.dispose();
    super.dispose();
  }

  Widget connectionInfo() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          socket.connected ? Icons.check_circle : Icons.warning,
          color: socket.connected ? Colors.green : Colors.red,
          size: 16.0,
        ),
        const SizedBox(width: 4.0),
        Text(
          socket.connected ? 'Connected' : 'Disconnected',
          style: const TextStyle(fontSize: 16.0),
        ),
        SizedBox(width: 5,),
      ],
    );

  
  Widget chatBubble(FriendInfo user, text) => Column(
    children: [
      Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile Image
        InkWell(
          onTap: () {
            profileWindow();
          },
          child: Material(
            elevation: 5,
            shape: const CircleBorder(
              side: BorderSide(
                color: Color.fromARGB(255, 255, 99, 159),
                width: 1.5,
              ),
            ),
            child: CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: ClipOval(
                child: Image.asset(
                  widget.user?.image??'assets/images/user.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),

        // Margin between profile image and chat bubble
        const SizedBox(width: 10),
        // Chat bubble
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.user?.name??'Unknown',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Container(
              constraints: const BoxConstraints(
                maxWidth: 200,
              ),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 189, 252, 138),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              child: LongPressCopyableText(
                  text: text,
                  style: const TextStyle(fontSize: 16),
                ),
            ),
          ],
        ),
      ],
    ),
      const SizedBox(height: 15), // 수직 간격 조정
    ],
  );

  Widget chatField() => Container(
    decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: chatFieldController,
                onSubmitted: (text) {
                  if (text.isNotEmpty) {
                    send();
                  }
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: ' Type your message...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.message),
                  ),
                ),
              ),
            ),
            IconButton(
              iconSize: 0,
              onPressed: send,
              icon: Stack(
                children: [
                  const Icon(Icons.send),
                  Image.asset('assets/images/cookie_logo.png', width: 24, height: 24),
                ],
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            )
          ],
        ),
      );

  
  Widget chat(FriendInfo user, messages) => Expanded(
    child: SingleChildScrollView(
      reverse: true,
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: messages.length,
            itemBuilder: (BuildContext context, int index) {
              return chatBubble(user, messages[index]);
            },
          ),
        ],
      ),
    ),
  );

  Future profileWindow() => showDialog(
    context: context,
    builder: (BuildContext context) {
      return Container( 
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    image: DecorationImage(
                      image: AssetImage(widget.user?.image??'assets/images/cookie_logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Scrollbar(
                    controller: _scrollController,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              '아 술마시고 싶다 아 술마시고 싶다 아 술마시고 싶다 아 술마시고 싶다 아 술마시고 싶다',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 7),
                          const Divider(height: 1),
                          ListTile(
                            title: Text("이름"),
                            subtitle: Text(widget.user?.name??'Unknown'),
                          ),
                          const Divider(height: 1),
                          ListTile(
                            title: Text("생일"),
                            subtitle: Text('2000-01-01'),
                          ),
                          const Divider(height: 1),
                          ListTile(
                            title: Text("거주지"),
                            subtitle: Text('수원'),
                          ),
                          const Divider(height: 1),
                          ListTile(
                            title: Text("나이"),
                            subtitle: Text('22'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("확인"),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      );
    },
  );
  
  Widget chatStructure(){
    return MaterialApp(
      
      home: Scaffold(
        
        resizeToAvoidBottomInset: true,

        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: AppBar(
            leading: IconButton(
              padding: EdgeInsets.only(left: 8),
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),

            title: Text(widget.user?.name??'Unknown'),
            backgroundColor: Colors.orangeAccent,
            elevation: 0,
            actions: [
              connectionInfo()
            ],
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Colors.orangeAccent,
                    Colors.deepOrangeAccent,
                  ],
                ),
              ),
            ),
          ),
        ),
        
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          child: Column(
            children: [
              // connectionInfo(),
              chat(widget.user??FriendInfo(), messages),
              chatField(),
              const SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}

class LongPressCopyableText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const LongPressCopyableText({
    Key? key,
    required this.text,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: text));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('클립보드에 복사'),
          duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Text(text, style: style),
    );
  }
}