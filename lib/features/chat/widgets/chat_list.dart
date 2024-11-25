import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:whatsapp/common/enums/message_enum.dart';
import 'package:whatsapp/common/providers/message_reply_provider.dart';
import 'package:whatsapp/common/widgets/loader.dart';

import 'package:whatsapp/features/chat/controller/chat_controller.dart';
import 'package:whatsapp/features/chat/widgets/my_message_card.dart';
import 'package:whatsapp/features/chat/widgets/sender_message_card.dart';
import 'package:whatsapp/models/message.dart';
import 'package:whatsapp/models/user_model.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;
  final bool isGroupChat;
  final List<UserModel> members;
  final Set<String> ids;
  final VoidCallback refreshHead;
  const ChatList(
      {required this.refreshHead,
      required this.ids,
      Key? key,
      required this.recieverUserId,
      required this.isGroupChat,
      required this.members})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: widget.isGroupChat
            ? ref.read(chatControllerProvider).groupChatStream(widget.recieverUserId)
            : ref.read(chatControllerProvider).chatStream(widget.recieverUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageController.jumpTo(messageController.position.maxScrollExtent);
          });

          print("SD>>> ${snapshot.data}");
          print("members >>>> ${widget.members}");
          return _List(
            recieverUserId: widget.recieverUserId,
            isGroupChat: widget.isGroupChat,
            members: widget.members,
            messages: snapshot.data ?? [],
            controller: messageController,
            ref: ref,
            ids: widget.ids,
            refreshHead: widget.refreshHead,
          );
        });
  }
}

class _List extends StatefulWidget {
  const _List(
      {Key? key,
      required this.recieverUserId,
      required this.isGroupChat,
      required this.members,
      required this.messages,
      required this.controller,
      required this.ref,
      required this.ids,
      required this.refreshHead})
      : super(key: key);
  final String recieverUserId;
  final bool isGroupChat;
  final List<UserModel> members;
  final List<Message> messages;
  final WidgetRef ref;
  final Set<String> ids;
  final VoidCallback refreshHead;

  final ScrollController controller;
  @override
  State<_List> createState() => _ListState();
}

class _ListState extends State<_List> {
  void onMessageSwipe(
    String message,
    bool isMe,
    MessageEnum messageEnum,
  ) {
    widget.ref.read(messageReplyProvider.state).update(
          (state) => MessageReply(
            message,
            isMe,
            messageEnum,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    var ids = widget.ids;
    return ListView.builder(
      controller: widget.controller,
      itemCount: widget.messages!.length,
      itemBuilder: (context, index) {
        final messageData = widget.messages![index];
        var timeSent = DateFormat.Hm().format(messageData.timeSent);

        if (!messageData.isSeen && messageData.recieverid == FirebaseAuth.instance.currentUser!.uid) {
          widget.ref.read(chatControllerProvider).setChatMessageSeen(
                context,
                widget.recieverUserId,
                messageData.messageId,
              );
        }
        if (messageData.senderId == FirebaseAuth.instance.currentUser!.uid) {
          String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
          var currentUser = widget.members.where((member) => member.uid == currentUserUid).firstOrNull;

          return MyMessageCard(
            message: messageData.text,
            date: timeSent,
            type: messageData.type,
            repliedText: messageData.repliedMessage,
            username: messageData.repliedTo,
            repliedMessageType: messageData.repliedMessageType,
            onLeftSwipe: (_) => onMessageSwipe(
              messageData.text,
              true,
              messageData.type,
            ),
            ids: ids,
            messageId: messageData.messageId,
            onLongPress: () {
              if (ids.contains(messageData.messageId)) {
                setState(() {
                  ids.remove(messageData.messageId);
                });
              } else {
                setState(() {
                  ids.add(messageData.messageId);
                });
              }
              widget.refreshHead?.call();
            },
            isSeen: messageData.isSeen,
            isGroupChat: widget.isGroupChat,
            userDetail: currentUser,
          );
        }
        var senderUser = widget.members.where((member) => member.uid == messageData.senderId).firstOrNull;
        print("senderUser >>>> ${senderUser}");
        return SenderMessageCard(
          message: messageData.text,
          date: timeSent,
          type: messageData.type,
          username: messageData.repliedTo,
          repliedMessageType: messageData.repliedMessageType,
          onRightSwipe: (_) => onMessageSwipe(
            messageData.text,
            false,
            messageData.type,
          ),
          repliedText: messageData.repliedMessage,
          isGroupChat: widget.isGroupChat,
          userDetail: senderUser,
          ids: ids,
          messageId: messageData.messageId,
          onLongPress: () {
            if (ids.contains(messageData.messageId)) {
              setState(() {
                ids.remove(messageData.messageId);
              });
            } else {
              setState(() {
                ids.add(messageData.messageId);
              });
            }
            widget.refreshHead?.call();
          },

        );
      },
    );
  }
}
