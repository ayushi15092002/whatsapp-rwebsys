import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/color.dart';
import 'package:whatsapp/common/widgets/error.dart';
import 'package:whatsapp/common/widgets/loader.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';
import 'package:whatsapp/features/landing/screens/landing_screen.dart';
import 'package:whatsapp/firebase_options.dart';
import 'package:whatsapp/router.dart';
import 'package:whatsapp/screen/mobile_screen_layout.dart';
import 'package:whatsapp/screen/web_screen_layout.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return MaterialApp(
        title: 'Whatsapp Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: backgroundColor,
          appBarTheme: const AppBarTheme(
            color: appBarColor
          )
        ),
        onGenerateRoute: (settings) => generateRoute(settings),
        home:ref.watch(userDataAuthProvider).when(data: (user){
          if(user == null){
            return const LandingScreen();
          }
          return const MobileScreenLayout();
        }, error: (err,trace){
          return ErrorScreen(error: err.toString(),);
        }, loading: ()  =>const Loader(),
        )
    );
  }
}