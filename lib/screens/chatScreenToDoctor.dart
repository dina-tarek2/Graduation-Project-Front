import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/api_services/dio_consumer.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/chat/chat_cubit.dart';
import 'package:graduation_project_frontend/screens/Center/center_profile.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatScreenToDoctor extends StatefulWidget {
  final String userId;
  final String userType;
  static String id = 'ChatScreenToDoctor';

  const ChatScreenToDoctor({
    Key? key,
    required this.userId,
    required this.userType,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreenToDoctor> with TickerProviderStateMixin {
  late ChatCubit chatCubit;
  bool _showEmojiPicker = false;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> filteredMessages = [];
  List<Map<String, dynamic>> allMessages = [];
  List<Map<String, dynamic>> filteredCenters = [];
  TextEditingController _searchController = TextEditingController();
  List displayList = [];

  List<dynamic> centers = [];
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
  String searchQuery = '';
  
  // New variables for expanded centers
  Set<String> expandedCenters = {};

  @override
  void initState() {
    super.initState();
    filteredMessages = allMessages; 
    filteredCenters = centers.whereType<Map<String, dynamic>>().toList();
    
    chatCubit = ChatCubit(
      api: DioConsumer(dio: Dio()),
      userId: widget.userId,
      userType: widget.userType,
    );
    
    // Load centers initially
    _loadCenters();
    
    // Listen to chat state changes
    chatCubit.stream.listen((state) {
      if (state is ConversationsLoaded && mounted) {
        setState(() {
          centers = state.conversations;
        });
      } else if (state is ChatLoaded && mounted) {
        setState(() {
          messages = state.messages;
          isLoadingMessages = false;
        });
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

  Future<void> _loadCenters() async {
    chatCubit.fetchConversationsForDoctor();
  }
  
  Future<void> _loadMessages(String receiverId, String receiverType) async {
    setState(() {
      isLoadingMessages = true;
    });
    
    chatCubit.fetchMessages(
      receiverId: receiverId,
      receiverType: receiverType,
    );
  }
  
  // Modified method to handle both center and doctor selection
  void _selectChat(dynamic item, {bool isCenter = false, dynamic center}) {
    String receiverId;
    String receiverType;
    String name;
    String image;
    
    if (isCenter) {
      receiverId = item['_id'] ?? item['id'];
      receiverType = "RadiologyCenter";
      name = item['centerName'];
      image = item['imageUrl']?.isNotEmpty == true
          ? item['imageUrl']
          : "https://www.viverefermo.it/images/user.png";
    } else {
      receiverId = item['_id'];
      receiverType = item['userType'] ?? "Radiologist";  
      name = item['name'];
      image = item['image']?.isNotEmpty == true
          ? item['image']
          : "https://www.viverefermo.it/images/user.png";
    }
    
    if (partnerId != receiverId) {
      setState(() {
        chatCubit.setPartner(
          newPartnerId: receiverId,
          newPartnerType: receiverType,
        );
        partnerId = receiverId;
        partnerType = receiverType;
        partnerName = name;
        partnerImage = image;
        messages = []; 
      });

      _loadMessages(partnerId, receiverType);
    }
  }
  
  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      final messageText = _controller.text;
      _controller.clear();
      
      setState(() {
        isTyping = false;
        
        messages.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'sender': widget.userId,
          'content': messageText,
          'createdAt': DateTime.now().toIso8601String(),
          'readStatus': false,
          'isOptimistic': true, 
        });
      });
      
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      
      chatCubit.sendMessage(messageText).then((_) {
        // Update conversations if needed
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

  void filterSearch(String query) {
    searchQuery = query;
    if (query.isNotEmpty) {
      filteredCenters = centers
          .where((center) => center['centerName']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()) ||
              (center['doctors'] ?? center['radiologists'] ?? []).any((doctor) => 
                  doctor['name']
                      .toString()
                      .toLowerCase()
                      .contains(query.toLowerCase()) &&
                  doctor['_id'] != widget.userId)) // Exclude current user
          .cast<Map<String, dynamic>>()
          .toList();
    } else {
      filteredCenters = centers.cast<Map<String, dynamic>>().toList();
    }

    setState(() {});
  }

  List<dynamic> _getDoctorsList(dynamic center) {
    return (center['doctors'] ?? center['radiologists'] ?? [])
        .where((doctor) => doctor['_id'] != widget.userId) // Exclude current user
        .toList();
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
              width: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: darkBabyBlue,
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: buildCentersList(),
            ),
            Expanded(child: buildChatScreen()),
          ],
        ),
      ),
    );
  }

  Widget buildCentersList() {
    List<dynamic> displayCenters = searchQuery.isEmpty 
        ? centers
         : filteredCenters ;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Centers & Doctors",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                 controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search centers or doctors...",
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: searchQuery.isNotEmpty 
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          filterSearch('');
                        },
                      )
                    : null,
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: filterSearch, 
              ),
            ],
          ),
        ),

        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadCenters,
            child: displayCenters.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_hospital_outlined, size: 60, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          searchQuery.isNotEmpty
                              ? "No results found for '$searchQuery'"
                              : "No centers available",
                          style: TextStyle(color: Colors.grey.shade600),
                            textAlign: TextAlign.center,
                        ),
                  if (searchQuery.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            _searchController.clear();
                            filterSearch('');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text("Clear Search"),
                        ),
                      ],
                    ],
                  ),
                )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: displayCenters.length,
                    itemBuilder: (context, index) {
                      var center = displayCenters[index];
                      final bool isExpanded = expandedCenters.contains(center['id'] ?? center['_id']);
                      final List<dynamic> doctorsList = _getDoctorsList(center);
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Column(
                          children: [
                            // Center Header - Now clickable for direct chat
                            Material(
                              color: (partnerId == (center['_id'] ?? center['id']) && partnerType == "Center") 
                                  ? blue 
                                  : blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  // Toggle expansion and also select center for chat
                                  setState(() {
                                    if (isExpanded) {
                                      expandedCenters.remove(center['id'] ?? center['_id']);
                                    } else {
                                      expandedCenters.add(center['id'] ?? center['_id']);
                                    }
                                  });
                                  
                                  // Select center for chat
                                  _selectChat(center, isCenter: true);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      // Center Image
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: (partnerId == (center['_id'] ?? center['id']) && partnerType == "Center") 
                                                ? Colors.white 
                                                : blue,
                                            width: 2,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(25),
                                          child: CachedNetworkImage(
                                            imageUrl: center['imageUrl']?.isNotEmpty == true
                                                ? center['imageUrl']
                                                : "https://www.viverefermo.it/images/user.png",
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => 
                                                Container(color: Colors.grey.shade200),
                                            errorWidget: (context, url, error) => 
                                                Icon(Icons.local_hospital, size: 30, color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      
                                      // Center Info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              center['centerName'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: (partnerId == (center['_id'] ?? center['id']) && partnerType == "Center") 
                                                    ? Colors.white 
                                                    : darkBlue,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              "${doctorsList.length} Doctors Available",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: (partnerId == (center['_id'] ?? center['id']) && partnerType == "Center") 
                                                    ? Colors.white70 
                                                    : Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      // Expand/Collapse Icon
                                      Icon(
                                        isExpanded ? Icons.expand_less : Icons.expand_more,
                                        color: (partnerId == (center['_id'] ?? center['id']) && partnerType == "Center") 
                                            ? Colors.white 
                                            : blue,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            
                            // Doctors List (when expanded) - Excluding current user
                            if (isExpanded && doctorsList.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              ...doctorsList.map<Widget>((doctor) {
                                final bool isSelected = doctor['_id'] == partnerId && partnerType != "Center";
                                
                                return Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 8, bottom: 4),
                                  child: Material(
                                    color: isSelected ? blue : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () {
                                        _selectChat(doctor, center: center);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            // Doctor Image
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: isSelected ? Colors.white : Colors.grey.shade300,
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(20),
                                                child: CachedNetworkImage(
                                                  imageUrl: doctor['image']?.isNotEmpty == true
                                                      ? doctor['image']
                                                      : "https://www.viverefermo.it/images/user.png",
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) => 
                                                      Container(color: Colors.grey.shade200),
                                                  errorWidget: (context, url, error) => 
                                                      Icon(Icons.person, size: 24, color: Colors.grey),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            
                                            // Doctor Info
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    doctor['name'],
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 14,
                                                      color: isSelected ? Colors.white : Colors.black87,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    doctor['email'] ?? doctor['userType'] ?? 'Radiologist',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: isSelected ? Colors.white70 : Colors.grey.shade600,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            
                                            // Unread Count Badge
                                            if ((doctor['unreadCount'] ?? 0) > 0)
                                              Container(
                                                padding: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: isSelected ? Colors.white : darkBabyBlue,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Text(
                                                  "${doctor['unreadCount']}",
                                                  style: TextStyle(
                                                    color: isSelected ? blue : Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                            
                            // Show message if no doctors available (after excluding current user)
                            if (isExpanded && doctorsList.isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(left: 20, right: 8, top: 8),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "No other doctors available in this center",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
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
    List<String> emojis = [
      "😀",
      "😂",
      "😍",
      "🤔",
      "😢",
      "😎",
      "🔥",
      "❤️",
      "👍"
    ];
    
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
              "Select a center or doctor to start chatting",
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
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: blue, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: CachedNetworkImage(
                          imageUrl: partnerImage,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(color: Colors.grey.shade200),
                          errorWidget: (context, url, error) => 
                              Icon(
                                partnerType == "Center" ? Icons.local_hospital : Icons.person, 
                                size: 32, 
                                color: Colors.grey
                              ),
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
                          Text(
                            partnerType == "Center" ? "Medical Center" : partnerType,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
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
                                                          : Icons.done_all,
                                                    size: 16,
                                                    color: isOptimistic ? Colors.white54 :
                                                        message['readStatus'] == true
                                                             ? Colors.white70
                                                            : const Color.fromARGB(255, 131, 124, 124),
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
            
            if (_showEmojiPicker)
              Container(
                padding: const EdgeInsets.all(8),
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[100],
                ),
                child: Wrap(
                  children: emojis.map((e) {
                    return InkWell(
                      onTap: () {
                        _controller.text += e;
                        _controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: _controller.text.length),
                        );
                        setState(() {
                          isTyping = _controller.text.trim().isNotEmpty;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          e,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    );
                  }).toList(),
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
                            onPressed: () {
                              setState(() {
                                _showEmojiPicker = !_showEmojiPicker;
                              });
                            },
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
                              onSubmitted: (value) {
                                _sendMessage();
                              },
                              textCapitalization: TextCapitalization.sentences,
                              onChanged: (text) {
                                setState(() {
                                  isTyping = text.trim().isNotEmpty;
                                });
                              },
                            ),
                          ),
                         
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
                           Icons.send ,
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