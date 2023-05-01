// 🐦 Flutter imports:
import 'package:chat_gpt_app/states/open_ai_api/open_ai_key_cubit.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// 🌎 Project imports:
import 'package:chat_gpt_app/core/app_instances.dart';
import 'package:chat_gpt_app/manager/theme/theme_manager.dart';
import 'package:chat_gpt_app/routes.dart';
import 'package:chat_gpt_app/states/theme_mode/theme_mode_cubit.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeModeCubit>(
          create: (context) => ThemeModeCubit(AppInstances.get<ThemeManagerProtocol>().currentTheme),
        ),
        BlocProvider<OpenAIKeyCubit>(
          create: (context) => OpenAIKeyCubit(),
        )
      ],
      child: BlocBuilder<ThemeModeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            themeMode: themeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              useMaterial3: true,
            ),
            routerConfig: appRouter,
            builder: (context, child) => ResponsiveBreakpoints.builder(
              child: child!,
              breakpoints: [
                const Breakpoint(start: 0, end: 450, name: MOBILE),
                const Breakpoint(start: 451, end: 800, name: TABLET),
                const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
              ],
            ),
          );
        },
      ),
    );
  }
}
