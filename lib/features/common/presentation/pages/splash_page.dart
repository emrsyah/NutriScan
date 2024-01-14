import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nutriscan/features/auth/presentation/auth_controller.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {

  @override
  void initState(){
    super.initState();
    initPage();
  }

   Future<void> initPage() async {
    final users = await ref.read(authControllerProvider.notifier).checkUsers();
    Future.delayed(const Duration(seconds: 2), () {
      if (users != '') {
        context.goNamed("home");
      } else {
        context.goNamed("sign-up");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              "assets/image/nutriscan-logo.png",
              height: 200,
              width: 200,
              alignment: Alignment.bottomCenter,
            ),
          ],
        ),
      ),
    ));
  }
}
