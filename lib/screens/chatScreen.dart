import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/api_services/dio_consumer.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/chat/chat_cubit.dart';
import 'package:graduation_project_frontend/widgets/customTextStyle.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
class ChatScreen extends StatefulWidget {
  final String userId;
  final String userType;
  static String id = 'ChatScreen';

  const ChatScreen({
    Key? key,
    required this.userId,
    required this.userType,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  late ChatCubit chatCubit;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<dynamic> conversations = [];
  List<dynamic> messages = [];
  bool isPartnerOnline = false;
  String partnerId = "";
  String partnerType = "";
  String partnerName = "";
  String partnerImage = "";
  String partnerStatus = "";
  int unreadCount = 0;
  bool isTyping = false;
  bool isLoadingMessages = false;
  //  Timer? _timer;
  @override
  void initState() {
    super.initState();
    
    chatCubit = ChatCubit(
      api: DioConsumer(dio: Dio()),
      userId: widget.userId,
      userType: widget.userType,
    );
    
    // Load conversations initially
    _loadConversations();
    // if(partnerId.isEmpty!)
    // _startAutoRefresh();
    // Listen to chat state changes
    chatCubit.stream.listen((state) {
      if (state is ConversationsLoaded && mounted) {
        setState(() {
          conversations = state.conversations;
        });
      } else if (state is ChatLoaded && mounted) {
        setState(() {
          messages = state.messages;
          isLoadingMessages = false;
        });
        // Scroll to bottom after loading messages
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      } else if (state is ChatError && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error)),
        );
        setState(() {
          isLoadingMessages = false;
        });
      }
    });
  }

  Future<void> _loadConversations() async {
    chatCubit.fetchConversations();
  }
  // void _startAutoRefresh() {
  //   _timer = Timer.periodic(Duration(seconds: 5), (timer) { 
  //      chatCubit.fetchMessages(receiverId: partnerId, receiverType: partnerType); 
  //   });
  // }
  Future<void> _loadMessages(String receiverId, String receiverType) async {
    setState(() {
      isLoadingMessages = true;
    });
    
    chatCubit.fetchMessages(
      receiverId: receiverId,
      receiverType: receiverType,
    );
  }
  
  void _selectConversation(dynamic chat) {
    String receiverType = widget.userType == "Radiologist"
        ? "RadiologyCenter"
        : "Radiologist";
    
    if (partnerId != chat['id']) {
      setState(() {
        chatCubit.setPartner(
          newPartnerId: chat['id'],
          newPartnerType: receiverType,
        );
        partnerId = chat['id'];
        partnerType = receiverType;
        partnerName = "${chat['firstName']} ${chat['lastName']}";
        partnerImage = chat['imageUrl']?.isNotEmpty == true
            ? chat['imageUrl']
            : "https://www.viverefermo.it/images/user.png";
        partnerStatus = chat['status'] ?? "Unknown";
        messages = []; // Clear previous messages
      });

      // Load messages for selected chat
      _loadMessages(partnerId, receiverType);
    }
  }
  
  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      final messageText = _controller.text;
      _controller.clear();
      
      // Optimistic update
      setState(() {
        isTyping = false;
        
        // Add message locally first (optimistic)
        messages.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'sender': widget.userId,
          'content': messageText,
          'createdAt': DateTime.now().toIso8601String(),
          'readStatus': false,
          'isOptimistic': true, // Mark as optimistic update
        });
      });
      
      // Scroll to bottom immediately after adding the message
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      
      // Actually send the message
      chatCubit.sendMessage(messageText).then((_) {
        // Update only the current conversation in the list without reloading all
        setState(() {
          for (int i = 0; i < conversations.length; i++) {
            if (conversations[i]['id'] == partnerId) {
              conversations[i]['lastMessage'] = messageText;
              // Move this conversation to the top
              if (i > 0) {
                final conversation = conversations.removeAt(i);
                conversations.insert(0, conversation);
              }
              break;
            }
          }
        });
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    if (chatCubit.state is! ChatClosedState) {
      chatCubit.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
        ),
        child: Row(
          children: [
            Container(
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: blue,
                    spreadRadius: 5,
                    blurRadius:15,
                     offset: Offset(0, 5),
                  ),
                ],
              ),
              child: buildChatList(),
            ),
            Expanded(child: buildChatScreen()),
          ],
        ),
      ),
    );
  }
  Widget buildChatList() {

     String formatLastTime(String timestamp) {
      try {
        final now = DateTime.now().toUtc();
        final dateTime = DateTime.parse(timestamp).toUtc()
        ;
        final difference = now.difference(dateTime);
        
        if (difference.inDays > 0) {
          return difference.inDays == 1 ? 'Yesterday' : DateFormat('dd/MM').format(dateTime);
        } else if (difference.inHours > 0) {
          return '${difference.inHours}h ago';
        } else if (difference.inMinutes > 0) {
          return '${difference.inMinutes}m ago';
        } else {
          return 'Just now';
        }
      } catch (e) {
        return 'Just now';
      }
    }
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Messages",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: "Search conversations...",
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadConversations,
            child: conversations.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 60, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          "No conversations yet",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: conversations.length,
                    itemBuilder: (context, index) {
                      var chat = conversations[index];
                      final bool isSelected = chat['id'] == partnerId;
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Material(
                          color: isSelected ? blue: blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => _selectConversation(chat),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isSelected ? Colors.white : Colors.transparent,
                                            width: 2,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(28),
                                          child: CachedNetworkImage(
                                            imageUrl: chat['imageUrl']?.isNotEmpty == true
                                                ? chat['imageUrl']
                                                : "https://www.viverefermo.it/images/user.png",
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => 
                                                Container(color: Colors.grey.shade200),
                                            errorWidget: (context, url, error) => 
                                                Icon(Icons.person, size: 36, color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                      if (chat['status'] == 'online')
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            width: 16,
                                            height: 16,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.white, width: 2),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${chat['firstName']} ${chat['lastName']}",
                                              style: TextStyle(
                                                fontWeight: isSelected || chat['unreadCount'] > 0
                                                    ? FontWeight.w600
                                                    : FontWeight.w400,
                                                fontSize: 16,
                                                color: isSelected ? Colors.white : Colors.white,
                                              ),
                                            ),
                                            Text(
                                              formatLastTime(chat['createdAt'] ?? DateTime.now().toIso8601String()),
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                chat['status'] ,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: chat['status'] == 'online' ? Colors.green : Colors.grey,
                                                ),
                                              ),
                                            ),
                                            if (chat['unreadCount'] > 0)
                                              Container(
                                                padding: const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: blue,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Text(
                                                  "${chat['unreadCount']}",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget buildChatScreen() {
    bool isCurrentUser(dynamic message) {
      return message['sender'] == widget.userId;
    }

    String formatTimeOfDay(String timestamp) {
      try {
        final dateTime = DateTime.parse(timestamp);
        return DateFormat('HH:mm').format(dateTime);
      } catch (e) {
        return '';
      }
    }
    if (partnerId.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 24),
            Text(
              "Select a conversation to start chatting",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      );
    }
    
    return Stack(
      children: [
        Column(
          children: [
            // Chat header
            Material(
              color: Colors.white,
              elevation: 3,
              shadowColor: Colors.black12,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: CachedNetworkImage(
                          imageUrl: partnerImage,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(color: Colors.grey.shade200),
                          errorWidget: (context, url, error) => 
                              Icon(Icons.person, size: 32, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            partnerName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: partnerStatus == 'online' ? Colors.green : Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                partnerStatus,
                                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.videocam_outlined, color: blue),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.call_outlined, color: blue),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.grey),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            
            // Messages area
            Expanded(
              child: isLoadingMessages
                  ? Center(child: CircularProgressIndicator())
                  : messages.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.message_outlined,
                                size: 80,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                "Start a conversation",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Send a message to begin chatting",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                            ),
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final message = messages[index];
                                final bool isUser = isCurrentUser(message);
                                final bool showDate = index == 0 || 
                                    DateTime.parse(message['createdAt']).day != 
                                    DateTime.parse(messages[index - 1]['createdAt']).day;
                                
                                final bool isOptimistic = message['isOptimistic'] == true;
                                
                                return Column(
                                  children: [
                                    if (showDate)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        child: Center(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12, 
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              DateFormat('EEEE, MMMM d').format(
                                                DateTime.parse(message['createdAt'])
                                              ),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    Align(
                                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                                      child: Container(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context).size.width * 0.65,
                                        ),
                                        margin: EdgeInsets.only(
                                          bottom: 16,
                                          left: isUser ? 80 : 0,
                                          right: isUser ? 0 : 80,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isUser 
                                              ? blue
                                              : Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(isUser ? 16 : 4),
                                            topRight: Radius.circular(isUser ? 4 : 16),
                                            bottomLeft: const Radius.circular(16),
                                            bottomRight: const Radius.circular(16),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.05),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              message['content'] ?? "Empty message",
                                              style: TextStyle(
                                                color: isUser ? Colors.white : Colors.black87,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  formatTimeOfDay(message['createdAt'] ??
                                                      DateTime.now().toIso8601String()),
                                                  style: TextStyle(
                                                    color: isUser ? Colors.white70 : Colors.grey,
                                                    fontSize: 11,
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                                const SizedBox(width: 4),
                                                if (isUser) ...[
                                                  Icon(
                                                    isOptimistic ? Icons.access_time : 
                                                      message['readStatus'] == true
                                                          ? Icons.done_all
                                                          : Icons.done,
                                                    size: 16,
                                                    color: isOptimistic ? Colors.white54 :
                                                        message['readStatus'] == true
                                                            ? Colors.white
                                                            : Colors.white70,
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
            ),
            
            // Message input
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file, color: Colors.grey),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: const InputDecoration(
                                hintText: "Type a message...",
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 12),
                              ),
                              maxLines: null,
                              textCapitalization: TextCapitalization.sentences,
                              onChanged: (text) {
                                setState(() {
                                  isTyping = text.trim().isNotEmpty;
                                });
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.mic_none_rounded, color: Colors.grey),
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isTyping ? blue : Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: !isTyping ? null : _sendMessage,
                        child: Icon(
                          isTyping ? Icons.send : Icons.mic,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}