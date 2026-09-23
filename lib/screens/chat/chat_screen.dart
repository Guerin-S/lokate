import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String otherUserName;
  const ChatScreen({super.key, required this.chatId, required this.otherUserName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final List<Map<String, dynamic>> _messages = [
    {'senderId': 'other', 'content': 'Bonjour ! Le logement est-il toujours disponible ?', 'isMe': false, 'time': '10:30'},
    {'senderId': 'me', 'content': 'Oui, bien sûr ! Quand souhaitez-vous visiter ?', 'isMe': true, 'time': '10:32'},
  ];

  void _send() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    _msgCtrl.clear();
    setState(() => _messages.add({'senderId': 'me', 'content': text, 'isMe': true, 'time': 'Maintenant'}));
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: Text(widget.otherUserName.isEmpty ? 'Chat' : widget.otherUserName)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (_, i) {
                final m = _messages[i];
                final isMe = m['isMe'] as bool;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe ? AppColors.primary : (isDark ? AppColors.surfaceDark : Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(16).copyWith(bottomRight: isMe ? const Radius.circular(4) : null, bottomLeft: !isMe ? const Radius.circular(4) : null),
                    ),
                    child: Column(crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
                      Text(m['content'] as String, style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: isMe ? Colors.white : (isDark ? Colors.white : AppColors.textPrimaryLight))),
                      const SizedBox(height: 4),
                      Text(m['time'] as String, style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: isMe ? Colors.white70 : AppColors.textTertiaryLight)),
                    ]),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            decoration: BoxDecoration(color: Theme.of(context).cardColor, border: Border(top: BorderSide(color: AppColors.borderLight.withValues(alpha: 0.5)))),
            child: Row(children: [
              Expanded(child: TextField(controller: _msgCtrl, decoration: InputDecoration(hintText: 'Votre message...', filled: true, fillColor: isDark ? AppColors.surfaceDark : AppColors.surfaceMutedLight, border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)), onSubmitted: (_) => _send())),
              const SizedBox(width: 8),
              GestureDetector(onTap: _send, child: Container(width: 44, height: 44, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle), child: const Icon(Icons.send, color: Colors.white, size: 20))),
            ]),
          ),
        ],
      ),
    );
  }
}
