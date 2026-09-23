import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().currentUser;
    if (user == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    // Mock chats — mode démo
    final mockChats = [
      {'id': 'chat1', 'name': 'Proprio Douala', 'lastMessage': 'Bonjour, le logement est toujours disponible ?', 'time': '10:30'},
      {'id': 'chat2', 'name': 'Marie K.', 'lastMessage': 'Merci pour la visite !', 'time': 'Hier'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: mockChats.isEmpty
          ? const _EmptyChats()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: mockChats.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final chat = mockChats[i];
                return ListTile(
                  leading: CircleAvatar(backgroundColor: AppColors.primaryLight, child: Text(chat['name']![0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700))),
                  title: Text(chat['name']!, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: Text(chat['lastMessage']!, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textSecondaryLight), maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: Text(chat['time']!, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textTertiaryLight)),
                  onTap: () => context.push('/chat/${chat['id']}', extra: {'name': chat['name']}),
                );
              },
            ),
    );
  }
}

class _EmptyChats extends StatelessWidget {
  const _EmptyChats();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 80, height: 80, decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(20)), child: const Icon(Icons.chat_bubble_outline, size: 40, color: AppColors.primary)),
          const SizedBox(height: 16),
          const Text('Aucun message', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimaryLight)),
          const SizedBox(height: 8),
          const Text('Contactez un propriétaire pour démarrer une conversation.', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textSecondaryLight)),
        ]),
      ),
    );
  }
}
