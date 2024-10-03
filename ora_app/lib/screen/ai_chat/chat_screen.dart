import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ora_app/model/chat.model.dart';
import 'dart:async';

import 'package:ora_app/provider/chat.dart';
import 'package:ora_app/service/LocationService.dart';
import 'package:ora_app/service/getAddressFromCoordinates.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ChatScreenState();
  }
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _sendmessage = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Locationservice _locationservice = Locationservice();
  final GetAddress _address = GetAddress();
  String currentAddress = '';
  List<Chat> chat = [];
  final ChatApi _chatapi = ChatApi();

  final StreamController<List<Chat>> _chatStreamController =
      StreamController<List<Chat>>.broadcast();

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  Future<void> _initializeLocation() async {
    Position position = await _locationservice.getLocation();

    currentAddress = await _address.getAddressFromCoordinates(
        position.latitude, position.longitude);
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _addMessage(String message, bool isMe) async {
    setState(() {
      chat.add(Chat(message: message));
      _chatStreamController.add(chat);
    });

    String aiResponse = await _chatapi.getmessage(message, currentAddress);
    setState(() {
      chat.add(Chat(message: aiResponse));
      _chatStreamController.add(chat);
    });
    _scrollToBottom();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _chatStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "images/assets/text.png",
          fit: BoxFit.cover,
          height: 200,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Chat>>(
              stream: _chatStreamController.stream,
              initialData: chat,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final chat = snapshot.data![index];
                      return ChatBubble(
                        message: chat.message,
                        isMe: index % 2 == 0, // 예시: 짝수 인덱스는 사용자 메시지
                        imageUrl: index % 2 == 0
                            ? 'images/assets/btnG_아이콘원형.png'
                            : 'images/assets/start_picture.webp',
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildInputField(
                      '이메일', 'Type your message here', _sendmessage),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_sendmessage.text.isNotEmpty) {
                      _addMessage(_sendmessage.text, true);
                      _sendmessage.clear();
                    }
                    // 메시지 전송 로직
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildInputField(
    String label, String hintText, TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        child: TextField(
          keyboardType: TextInputType.text,
          style: const TextStyle(color: Colors.black),
          controller: controller,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ),
      ),
    ],
  );
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;

  final String imageUrl;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    if (!isMe) _buildAvatar(),
                    const SizedBox(
                      height: 5,
                    ),
                    if (isMe) _buildAvatar(),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blue[100] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Text(
                        message,
                        softWrap: true,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 50, // 원하는 크기로 조정
      height: 40, // 원하는 크기로 조정
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.cover, // 이미지가 컨테이너를 완전히 채우도록 함
        ),
      ),
    );
  }
}
