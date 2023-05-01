import 'package:chat_gpt_app/states/open_ai_api/open_ai_key_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HasValidApiKeySelector extends BlocSelector<OpenAIKeyCubit, OpenAIKeyState, bool> {
  HasValidApiKeySelector({required Widget Function(BuildContext, bool) builder, super.key})
      : super(
          selector: (state) => state is OpenAIKeyLoadedState,
          builder: builder,
        );
}
