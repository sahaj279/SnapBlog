import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:snapblog/responsive/mobView.dart';
import 'package:snapblog/responsive/responsive_layout.dart';
import 'package:snapblog/responsive/webView.dart';
import 'package:snapblog/screens/login_screen.dart';
import 'package:provider/provider.dart';

import 'providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBpcViWpyDoUuZ9Gh1HMonJkkfgZT_xrAU",
        authDomain: "instagram-clone-57d81.firebaseapp.com",
        projectId: "instagram-clone-57d81",
        storageBucket: "instagram-clone-57d81.appspot.com",
        messagingSenderId: "293906074268",
        appId: "1:293906074268:web:23f5be9aa5f3d0f8627b59",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SnapBlog',
        theme: ThemeData(useMaterial3: true),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayoutBuilder(
                  mobLayout: MobView(),
                  webLayout: WebView(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
