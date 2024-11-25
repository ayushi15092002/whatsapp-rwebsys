import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

import 'package:whatsapp/common/utils/colors.dart';
import 'package:whatsapp/common/enums/message_enum.dart';
import 'package:whatsapp/features/chat/widgets/display_text_image_gif.dart';

import '../../../models/user_model.dart';

class SenderMessageCard extends StatelessWidget {
  SenderMessageCard(
      {Key? key,
      required this.message,
      required this.date,
      required this.type,
      required this.onRightSwipe,
      required this.repliedText,
      required this.username,
      required this.repliedMessageType,
      this.isGroupChat = false,
      this.userDetail,
      required this.messageId,
      required this.ids,
      this.onLongPress})
      : super(key: key);

  final String messageId;
  final Set<String> ids;
  final VoidCallback? onLongPress;

  final String message;
  final String date;
  final MessageEnum type;
  final onRightSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;
  bool isGroupChat;
  UserModel? userDetail;

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;

    var isSelected = ids.contains(messageId);
    return ColoredBox(
      color: isSelected ? Colors.black : Colors.transparent,
      child: InkWell(
        onLongPress: onLongPress,
        onTap: () {
          if (ids.isNotEmpty) {
            onLongPress?.call();
          }
        },
        child: SwipeTo(
          onRightSwipe: onRightSwipe,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
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
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 45,
                  ),
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    color: senderMessageColor,
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
                          bottom: 2,
                          right: 10,
                          child: Text(
                            date,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
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
