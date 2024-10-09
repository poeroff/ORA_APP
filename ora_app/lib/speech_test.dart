import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  final SpeechToText _speechToText = SpeechToText();

  bool _speechEnables = false;
  String _wordsSpoken = "";
  double _confidenceLevel = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    print("HELLO");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("APPBAR")),
        body: Center(
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(_speechToText.isListening
                      ? "isListening..."
                      : _speechEnables
                          ? "Tap the microphone to start Listening..."
                          : "speech not available")),
              Expanded(
                  child: Container(
                child: Text(_wordsSpoken),
              )),
              if (_speechToText.isNotListening && _confidenceLevel > 0)
                Text(
                  "Confidence: ${(_confidenceLevel * 100).toStringAsFixed(1)}) %",
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w200),
                )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed:
              _speechToText.isListening ? _stopListening : _startListening,
          tooltip: "LISTEN",
          child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
        ));
  }
}
