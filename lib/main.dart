import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:test_aws_pin_point/app_config.dart';
import 'package:test_aws_pin_point/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    await AppConfig().configAmplify();

    // await AppConfig().setAccessToken();
    // //
    // await AppConfig().getIdToken();

    await AppConfig().signIn();
    await AppConfig().testPinpoint();
  }

  @override
  void dispose() {
    super.dispose();
    signOut();
  }

  Future<void> signOut() async {
    await AppConfig().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
