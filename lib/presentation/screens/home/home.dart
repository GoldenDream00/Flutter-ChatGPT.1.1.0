// 🐦 Flutter imports:
import 'package:chat_gpt_app/presentation/screens/home/home_container.dart';
import 'package:chat_gpt_app/presentation/screens/home/states/conversation/conversation_cubit.dart';
import 'package:chat_gpt_app/presentation/screens/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentTabIndex,
        children: [
          BlocProvider(
            create: (context) => ConversationCubit(),
            child: const HomeScreenContainer(),
          ),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        currentIndex: _currentTabIndex,
        items: const [
          BottomNavigationBarItem(
            label: "Chat",
            icon: Icon(Icons.chat_bubble_outline_rounded),
            activeIcon: Icon(Icons.chat_bubble_rounded),
          ),
          BottomNavigationBarItem(
            label: "Settings",
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings_rounded),
          )
        ],
      ),
    );
  }
}
