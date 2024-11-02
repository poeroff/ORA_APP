import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ora_app/model/chat.model.dart';
import 'package:ora_app/provider/recommand_store.dart';
import 'package:ora_app/screen/home_screen.dart';
import 'package:ora_app/screen/main/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:ora_app/provider/chat.dart';
import 'package:ora_app/service/LocationService.dart';
import 'package:ora_app/service/getAddressFromCoordinates.dart';
import 'package:speech_to_text/speech_to_text.dart';

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
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnables = false;
  String _wordsSpoken = "";
  double _confidenceLevel = 0;
  Timer? _debounceTimer;
  var companyData;

  List<Chat> chat = [];
  final ChatApi _chatapi = ChatApi();
  final RecommandStore _recommandStore = RecommandStore();

  final StreamController<List<Chat>> _chatStreamController =
      StreamController<List<Chat>>.broadcast();

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    initSpeech();
    _speechToText.statusListener = (status) async {
      if (status == SpeechToText.listeningStatus) {
      } else if (status == SpeechToText.notListeningStatus) {
        setState(() {
          chat.add(Chat(message: _wordsSpoken));
          _chatStreamController.add(chat);
        });
        Map<String, dynamic> responseData =
            await _chatapi.getmessage(_wordsSpoken, currentAddress);
        String aiResponse = responseData["message"];
        companyData = responseData["company"];

        setState(() {
          chat.add(Chat(message: aiResponse));
          _chatStreamController.add(chat);
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    };
  }

  void initSpeech() async {
    _speechEnables = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _confidenceLevel = 0;
    });
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = "${result.recognizedWords}";
      _confidenceLevel = result.confidence;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
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

    Map<String, dynamic> responseData =
        await _chatapi.getmessage(message, currentAddress);
    String aiResponse = responseData["message"];
    companyData = responseData["company"];

    setState(() {
      chat.add(Chat(message: aiResponse));
      _chatStreamController.add(chat);
    });

    if (companyData.length > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              child: ListView(
                children: [
                  SizedBox(height: 16),
                  ...companyData.map((company) => Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 55,
                              child: Container(
                                padding: EdgeInsets.only(left: 16),
                                height: 200,
                                child: ClipRRect(
                                  // 이미지도 모서리를 둥글게 하려면 추가
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    'images/assets/capture.PNG',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 45,
                              child: Container(
                                height: 200, // 이미지와 같은 높이로 설정
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween, // 내용물을 위아래로 분산
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 14)),
                                              Text(
                                                company['name'],
                                                style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          const Row(
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 14)),
                                              Icon(Icons.star,
                                                  color: Colors.blue, size: 20),
                                              Icon(Icons.star,
                                                  color: Colors.blue, size: 20),
                                              Icon(Icons.star,
                                                  color: Colors.blue, size: 20),
                                              Icon(Icons.star,
                                                  color: Colors.blue, size: 20),
                                              Icon(Icons.star_border,
                                                  color: Colors.blue, size: 20),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromARGB(
                                                  255, 212, 212, 219)),
                                          onPressed: () {},
                                          child: Text(
                                            '업체 정보',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xff4255F8)),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('예약하시겠습니까?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('취소'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // 다이얼로그 닫기
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('확인'),
                                                      onPressed: () {
                                                        reservation(
                                                          company["id"],
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text(
                                            '예약가능',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            );
          },
        );
      });
    }
  }

  void reservation(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await _recommandStore.recommand_store(id, prefs.getString("email"));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
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
                Container(
                  decoration: const BoxDecoration(
                    color:
                        Color(0xff4255F8), // Set the background color to purple
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                        _speechToText.isNotListening
                            ? Icons.mic_off
                            : Icons.mic,
                        color: Colors.white), // Set the icon color to white
                    onPressed: _speechToText.isListening
                        ? _stopListening
                        : _startListening,
                  ),
                ),
                const SizedBox(width: 8),
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
