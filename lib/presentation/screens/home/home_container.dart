import 'package:chat_gpt_app/presentation/screens/home/model/message_model.dart';
import 'package:chat_gpt_app/presentation/screens/home/states/conversation/conversation_cubit.dart';
import 'package:chat_gpt_app/presentation/widgets/message_bubble.dart';
import 'package:chat_gpt_app/states/open_ai_api/selectors/has_valid_api_key_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreenContainer extends StatefulWidget {
  const HomeScreenContainer({super.key});

  @override
  State<StatefulWidget> createState() => HomeScreenContainerState();
}

class HomeScreenContainerState extends State<HomeScreenContainer> {
  late final _chatBoxTextController = TextEditingController();
  late final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat GPT"),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        reverse: true,
        slivers: [
          HasValidApiKeySelector(
            builder: (context, hasValidKey) {
              if (!hasValidKey) {
                return SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.key_rounded,
                            size: 64,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const Text(
                            "You need to set an API key before starting a conversation!",
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
              return BlocBuilder<ConversationCubit, ConversationState>(
                builder: (context, state) {
                  List<MessageModel> allMessages = [];
                  if (state is ConversationLoadedState) {
                    allMessages = state.messages.reversed.toList();
                  } else if (state is ConversationLoadingState) {
                    allMessages = state.messages.reversed.toList();
                  } else {
                    return const SliverToBoxAdapter(child: SizedBox());
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => MessageBubble(
                        message: allMessages[i],
                      ),
                      childCount: allMessages.length,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Material(
        child: Container(
          height: 72,
          padding: const EdgeInsets.all(8.0),
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          color: Colors.transparent,
          child: HasValidApiKeySelector(
            builder: (context, hasValidKey) {
              return TextFormField(
                controller: _chatBoxTextController,
                onFieldSubmitted: (value) {
                  if (hasValidKey) {
                    _chatBoxTextController.clear();
                    context.read<ConversationCubit>().sendMessage(value);
                  } 
                },
                decoration: InputDecoration(
                  suffixIcon: ValueListenableBuilder(
                    valueListenable: _chatBoxTextController,
                    builder: (context, value, widget) {
                      return IconButton(
                        color: value.text.isNotEmpty ? Theme.of(context).colorScheme.primary : null,
                        onPressed: value.text.isNotEmpty
                            ? () {
                                if (hasValidKey) {
                                  _chatBoxTextController.clear();
                                  context.read<ConversationCubit>().sendMessage(value.text);
                                }
                              }
                            : null,
                        icon: const Icon(Icons.send_rounded),
                      );
                    },
                  ),
                  hintText: "Send a message",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(120),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
