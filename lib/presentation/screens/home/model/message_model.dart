import 'package:equatable/equatable.dart';

class MessageModel extends Equatable {
  final String role;
  final String content;
  final bool isLoading;

  bool get isChatGPT => role == "assistant";

  const MessageModel(this.role, this.content, {this.isLoading = false});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(json["role"] ?? "", json["content"] ?? "");
  }

  Map<String, String> toJson() => {"role": role, "content": content};

  @override
  List<Object?> get props => [role, content];
}
