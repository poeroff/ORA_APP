import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ChatScreenState();
  }
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "images/assets/텍스트.webp",
          fit: BoxFit.contain,
          height: 50,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ChatBubble(
                  message: '안녕하세요, 나 목이 아픈거같아.',
                  isMe: true,
                  time: '10:15 AM',
                  imageUrl: 'images/assets/btnG_아이콘원형.png',
                ),
                ChatBubble(
                  message:
                      '네, 목 증상이 언제부터 시작되었고, 통증 양상은 어떤가요? 수기적으로 봐야될 것 같아 보입니다. 직접오실 수 있으신가요?',
                  isMe: false,
                  time: '10:15 AM',
                  imageUrl: 'images/assets/start.webp',
                ),
                ChatBubble(
                  message: '수요일부터 목이 아프고 통증은 삼킬때, 그리고 가래가 끓는것과, 목소리도 갈라지고 간조함.',
                  isMe: true,
                  time: '10:16 AM',
                  imageUrl: 'images/assets/btnG_아이콘원형.png',
                ),
                ChatBubble(
                  message:
                      '알겠습니다. 증상을 보니 인후염이나 비염 관련 감염일 가능성이 높습니다. 직접 진찰을 통해 정확한 진단과 치료 계획을 세우는 것이 좋겠습니다. 내원 시 필요한 준비사항은 없습니다.',
                  isMe: false,
                  time: '10:16 AM',
                  imageUrl: 'images/assets/start.webp',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type your message here',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
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

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String time;
  final String imageUrl;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isMe,
    required this.time,
    required this.imageUrl,
  }) : super(key: key);

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
                    SizedBox(
                      height: 5,
                    ),
                    if (isMe) _buildAvatar(),
                    SizedBox(
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
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Text(
                        message,
                        softWrap: true,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      time,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
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
