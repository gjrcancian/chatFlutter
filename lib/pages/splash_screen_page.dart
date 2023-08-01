import 'package:dio_fire/pages/my_home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    carregarHome();
  }
   carregarHome() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var uuid = const Uuid();
    var userId  = prefs.getString('user_id');

    if(userId == null) {
      userId = uuid.v4();
      await prefs.setString('user_id', userId);
    }

    Future.delayed(const Duration(seconds:2), () {
      if (mounted) {  // verifica se a tela ainda está montada
        return Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) =>  MyHomePage())
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body:Center(
      child:
          Image(
            image: AssetImage('lib/assets/loading.gif'),
            width: 100,
            height: 100,


      ),
    ));
  }
}
