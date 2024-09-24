import 'package:uuid/uuid.dart';

class Chat {
  final String id;
  final String message;


  Chat({
    String? id,
    required this.message,

  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,

    };
  }

  // Map에서 Chat 객체를 생성하는 팩토리 생성자
  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'],
      message: map['text'],

    );
  }


}