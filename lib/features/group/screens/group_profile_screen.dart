import 'package:flutter/material.dart';
import 'package:whatsapp/models/user_model.dart';

class GroupProfileScreen extends StatelessWidget {
  static const routeName = '/group-profile-page';
  final String groupName;
  final String profilePic;
  final List<UserModel> members;

  const GroupProfileScreen({
    Key? key,
    required this.groupName,
    required this.profilePic,
    required this.members,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(groupName),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20
          ),
          // Display Group Profile Picture
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(profilePic),
          ),
          const SizedBox(height: 16),
          Align(alignment:Alignment.topLeft,child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
            child: Text('Members',  textAlign: TextAlign.left,),
          )),
          const SizedBox(height: 10),
          // Display Members List
          Expanded(
            child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(member.profilePic),
                  ),
                  title: Text(member.name),
                  subtitle: Text(member.isOnline ? 'Online' : 'Offline'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
