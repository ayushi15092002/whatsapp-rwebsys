import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

import 'package:whatsapp/common/utils/colors.dart';
import 'package:whatsapp/common/enums/message_enum.dart';
import 'package:whatsapp/features/chat/widgets/display_text_image_gif.dart';
import 'package:whatsapp/models/user_model.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final  onLeftSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;
  final bool isSeen;
  bool isGroupChat;
  UserModel? userDetail;
  final String messageId;
  final Set<String> ids;
  final VoidCallback? onLongPress;

  MyMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
    required this.onLeftSwipe,
    required this.repliedText,
    required this.username,
    required this.repliedMessageType,
    required this.isSeen,
    this.isGroupChat = false,
    this.userDetail,
    this.onLongPress, required this.ids, required this.messageId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("isGroupChat >>>>> ${isGroupChat}");
    print("userDetail >>>>> ${userDetail}");
    final isReplying = repliedText.isNotEmpty;

    var isSelected = ids.contains(messageId);
    return ColoredBox(
      color:  isSelected ? Colors.black : Colors.transparent ,
      child: InkWell(
        onLongPress: onLongPress,
        onTap: () {
          if(ids.isNotEmpty) {
            onLongPress?.call();
          }
        },
        child: SwipeTo(
         onLeftSwipe : onLeftSwipe,
          child: Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 45,
                  ),
                  child: Card(
                    elevation: 1,
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    color: messageColor,
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Stack(
                      children: [
                        Padding(
                          padding: type == MessageEnum.text
                              ? const EdgeInsets.only(
                                  left: 10,
                                  right: 30,
                                  top: 5,
                                  bottom: 20,
                                )
                              : const EdgeInsets.only(
                                  left: 5,
                                  top: 5,
                                  right: 5,
                                  bottom: 25,
                                ),
                          child: Column(
                            children: [
                              if (isReplying) ...[
                                Text(
                                  username,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: backgroundColor.withOpacity(0.5),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(
                                        5,
                                      ),
                                    ),
                                  ),
                                  child: DisplayTextImageGIF(
                                    message: repliedText,
                                    type: repliedMessageType,
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                              DisplayTextImageGIF(
                                message: message,
                                type: type,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 4,
                          right: 10,
                          child: Row(
                            children: [
                              Text(
                                date,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white60,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Icon(
                                isSeen ? Icons.done_all : Icons.done,
                                size: 20,
                                color: isSeen ? Colors.blue : Colors.white60,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,2,0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(userDetail?.profilePic ?? ''),
                        radius: 16,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userDetail?.name ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
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
  }
}
