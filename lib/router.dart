import 'package:flutter/material.dart';
import 'package:whatsapp/common/widgets/error.dart';
import 'package:whatsapp/features/auth/screens/login_screen.dart';
import 'package:whatsapp/features/auth/screens/otp_screen.dart';
import 'package:whatsapp/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp/features/select_contacts/screens/select_contact_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());

    case OtpScreen.routeName:
      final verificatonId= settings.arguments as String;
      return MaterialPageRoute(builder: (context) => OtpScreen(verificationId : verificatonId));

    case UserInformationScreen.routeName:
      return MaterialPageRoute(builder: (context) =>const UserInformationScreen());

    case SelectContactsScreen.routeName:
      return MaterialPageRoute(builder: (context) =>const SelectContactsScreen());

    case MobileChatScreen.routeName:
      final argumments=settings.arguments as Map<String, dynamic>;
      final name= argumments['name'];
      final uid= argumments['uid'];
      return MaterialPageRoute(builder: (context) => MobileChatScreen(
        name: name,
        uid: uid,
      ));

    default:
      return MaterialPageRoute(
          builder: (context) => const Scaffold(
                body: ErrorScreen(error: "This Page Doesn't exist"),
              ));
  }
}
