import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AuthError {
  String messageError;
  String title;
  AuthError({
    required this.messageError,
    required this.title,
  });

  AuthError copyWith({
    String? messageError,
    String? title,
  }) {
    return AuthError(
      messageError: messageError ?? this.messageError,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messageError': messageError,
      'title': title,
    };
  }

  factory AuthError.fromMap(Map<String, dynamic> map) {
    return AuthError(
      messageError: map['messageError'] as String,
      title: map['title'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthError.fromJson(String source) => AuthError.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AuthError(messageError: $messageError, title: $title)';

  @override
  bool operator ==(covariant AuthError other) {
    if (identical(this, other)) return true;
  
    return 
      other.messageError == messageError &&
      other.title == title;
  }

  @override
  int get hashCode => messageError.hashCode ^ title.hashCode;
}
