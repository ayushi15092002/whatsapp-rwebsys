import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/utils/colors.dart';
import 'package:whatsapp/common/widgets/loader.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';
import 'package:whatsapp/features/call/controller/call_controller.dart';
import 'package:whatsapp/features/call/screens/call_pickup_screen.dart';
import 'package:whatsapp/features/chat/controller/chat_controller.dart';
import 'package:whatsapp/features/chat/widgets/bottom_chat_field.dart';
import 'package:whatsapp/models/user_model.dart';
import 'package:whatsapp/features/chat/widgets/chat_list.dart';

import '../../group/screens/group_profile_screen.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  final bool isGroupChat;
  final String profilePic;
  final List<UserModel> members;
  MobileChatScreen({
    super.key,
    required this.name,
    required this.uid,
    required this.isGroupChat,
    required this.profilePic,
    this.members = const <UserModel>[],
  }) : _key = GlobalObjectKey('${uid}head');

  GlobalObjectKey _key;

  void makeCall(WidgetRef ref, BuildContext context) {
    ref.read(callControllerProvider).makeCall(
          context,
          name,
          uid,
          profilePic,
          isGroupChat,
        );
  }

  Set<String> ids = {};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("AS>>>>> } $uid");

    return CallPickupScreen(
      scaffold: Scaffold(
        appBar: _Head(
          key: _key,
          name: name,
          uid: uid,
          isGroupChat: isGroupChat,
          profilePic: profilePic,
          ref: ref,
          ids: ids,
          onConfirm: () {
            ref.read(chatControllerProvider).chatRepository.deleteData(ids, isGroupChat, uid);
          },
        ),
        body: Column(
          children: [
            Expanded(
              child: ChatList(
                  ids: ids, recieverUserId: uid, isGroupChat: isGroupChat, members: members, refreshHead: refreshHead),
            ),
            BottomChatField(
              recieverUserId: uid,
              isGroupChat: isGroupChat,
            ),
          ],
        ),
      ),
    );
  }

  void refreshHead() {
    (_key?.currentState as _HeadState?)?.refresh();
  }
}

class _Head extends StatefulWidget implements PreferredSizeWidget {
  final String name;
  final String uid;
  final bool isGroupChat;
  final String profilePic;
  final List<UserModel> members;
  final WidgetRef ref;
  final Set<String> ids;
  final VoidCallback onConfirm;
  const _Head({
    Key? key,
    required this.name,
    required this.uid,
    required this.isGroupChat,
    required this.profilePic,
    this.members = const <UserModel>[],
    required this.ref,
    required this.ids,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<_Head> createState() => _HeadState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size(double.maxFinite, 48);
}

class _HeadState extends State<_Head> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var ref = widget.ref;
    var name = widget.name;
    var uid = widget.uid;

    return AppBar(
      backgroundColor: appBarColor,
      title: widget.isGroupChat
          ? Text(widget.name)
          : StreamBuilder<UserModel>(
              stream: ref.read(authControllerProvider).userDataById(uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }
                return Column(
                  children: [
                    Text(name),
                    Text(
                      snapshot.data!.isOnline ? 'online' : 'offline',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                );
              }),
      centerTitle: false,
      actions: [
        // if(!isGroupChat)
        // IconButton(
        //   onPressed: () => makeCall(ref, context),
        //   icon: const Icon(Icons.video_call),
        // ),
        // IconButton(
        //   onPressed: () {},
        //   icon: const Icon(Icons.call),
        // ),
        if (widget.ids.isNotEmpty)
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text('Delete'),
                      content: const Text(
                        'Are you sure you want to delete the messages.',
                        style: TextStyle(),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            widget.onConfirm?.call();
                          },
                          child: const Text('Ok'),
                        ),
                        const SizedBox.square(
                          dimension: 8,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                      ],
                    );
                  });
            },
            icon: const Icon(Icons.delete_outline),
          ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'Group Profile') {
              openGroupProfile(context);
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              if (widget.isGroupChat)
                const PopupMenuItem<String>(
                  value: 'Group Profile',
                  child: Text('Group Profile'),
                ),
              const PopupMenuItem<String>(
                value: 'Settings',
                child: Text('Settings'),
              ),
            ];
          },
        ),
      ],
    );
  }

  void openGroupProfile(BuildContext context) {
    Navigator.pushNamed(context, GroupProfileScreen.routeName, arguments: {
      'groupName': widget.name,
      'profilePic': widget.profilePic,
      'members': widget.members,
    });
  }
}
