import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:injectable/injectable.dart';

abstract class ChatGPTRepositoryProtocol {
  Future<void> setup(String apiKey);
  void dispose();
  Future<AiModel> get models;
  Future<ChatCTResponse?> request({required ChatCompleteText text});
}

@LazySingleton(as: ChatGPTRepositoryProtocol)
class ChatGPTRepository implements ChatGPTRepositoryProtocol {
  late OpenAI _openAI;

  @override
  Future<void> setup(String apiKey) async {
    _openAI = OpenAI.instance.build(
      token: apiKey,
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 60)),
      isLog: true,
    );
  }

  @override
  Future<AiModel> get models {
    return _openAI.listModel();
  }

  @override
  Future<ChatCTResponse?> request({required ChatCompleteText text}) {
    return _openAI.onChatCompletion(request: text);
  }

  @override
  void dispose() {
    _openAI.setToken("");
  }
}
