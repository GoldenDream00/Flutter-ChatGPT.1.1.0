import 'package:chat_gpt_app/states/open_ai_api/open_ai_key_cubit.dart';
import 'package:chat_gpt_app/states/theme_mode/theme_mode_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          BlocBuilder<OpenAIKeyCubit, OpenAIKeyState>(
            builder: (context, state) {
              return ListTile(
                title: const Text("Set Open AI API Key"),
                subtitle: Text(state is OpenAIKeyLoadedState ? "${state.key.substring(1, 10)}*****" : ""),
                trailing: const Icon(Icons.key_rounded),
                onTap: () {
                  final openAIKeyCubit = context.read<OpenAIKeyCubit>();
                  String? key;
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Set OpenAI API Key"),
                        content: TextFormField(
                          autofocus: true,
                          decoration: const InputDecoration(hintText: "OpenAI API Key"),
                          onChanged: (value) {
                            key = value;
                          },
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Clear'),
                            onPressed: () {
                              openAIKeyCubit.clearKey();
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Set'),
                            onPressed: () {
                              if (key != null) {
                                openAIKeyCubit.setKey(key!.trim());
                              }
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
          BlocBuilder<ThemeModeCubit, ThemeMode>(
            builder: (context, state) {
              return ListTile(
                title: const Text("Brigtness"),
                subtitle: Text(state.name.toUpperCase()),
                trailing: Icon(state.icon),
                onTap: () {
                  context.read<ThemeModeCubit>().setMode(
                        ThemeMode.values.elementAt(
                          (state.index + 1) % 3,
                        ),
                      );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

extension ThemeModeExtension on ThemeMode {
  IconData get icon {
    switch (this) {
      case ThemeMode.dark:
        return Icons.dark_mode_rounded;
      case ThemeMode.light:
        return Icons.light_mode_rounded;
      default:
        return Icons.brightness_auto_rounded;
    }
  }
}
