import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().currentUser;
    if (user == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('participants', arrayContains: user.id)
            .orderBy('lastMessageAt', descending: true)
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) return _EmptyChats();
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final data = docs[i].data() as Map<String, dynamic>;
              final otherName = data['participantNames']?[data['participants'].indexOf(
                data['participants'].firstWhere((p) => p != user.id, orElse: () => '')
              )] ?? 'Utilisateur';
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  child: Text(otherName.isNotEmpty ? otherName[0] : '?',
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
                title: Text(otherName, style: AppTextStyles.label),
                subtitle: Text(data['lastMessage'] ?? '', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondaryLight),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (data['lastMessageAt'] != null)
                      Text(_timeAgo((data['lastMessageAt'] as Timestamp).toDate()),
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondaryLight)),
                    if ((data['unreadCount_${user.id}'] ?? 0) > 0) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                        child: Text('${data['unreadCount_${user.id}']}',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'Poppins')),
                      ),
                    ],
                  ],
                ),
                onTap: () => context.push('/chat/${docs[i].id}', extra: {'name': otherName}),
              );
            },
          );
        },
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'maintenant';
    if (diff.inHours < 1) return '${diff.inMinutes}min';
    if (diff.inDays < 1) return '${diff.inHours}h';
    return '${diff.inDays}j';
  }
}

class _EmptyChats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('💬', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text('Aucun message', style: AppTextStyles.h4),
          const SizedBox(height: 8),
          Text('Contactez un propriétaire pour démarrer une conversation.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondaryLight)),
        ],
      ),
    );
  }
}
