
import 'package:chat_gpt_app/presentation/screens/home/model/message_model.dart';
import 'package:chat_gpt_app/presentation/screens/home/states/conversation/conversation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({Key? key, required this.message}) : super(key: key);

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatar = CircleAvatar(
      backgroundColor: message.isChatGPT ? theme.colorScheme.secondaryContainer : theme.colorScheme.primaryContainer,
      child: message.isChatGPT ? const Icon(Icons.psychology_rounded) : const Icon(Icons.account_circle_rounded),
    );
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: message.isChatGPT ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (message.isChatGPT) ...[
            avatar,
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: message.isChatGPT ? theme.colorScheme.secondaryContainer : theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  final conversationCubit = context.read<ConversationCubit>();
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          padding: const EdgeInsets.only(top: 16),
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.copy_rounded),
                                title: const Text("Copy Text"),
                                onTap: () {
                                  Navigator.pop(context);
                                  Clipboard.setData(ClipboardData(text: message.content));
                                },
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.delete_forever_rounded,
                                  color: theme.colorScheme.error,
                                ),
                                title: const Text("Clear chat history"),
                                onTap: () {
                                  conversationCubit.clearChat();
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      });
                },
                child: Column(
                  crossAxisAlignment: message.isChatGPT ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                  children: [Text(message.content)],
                ),
              ),
            ),
          ),
          if (!message.isChatGPT) ...[
            const SizedBox(width: 12),
            avatar,
          ],
        ],
      ),
    );
  }
}
