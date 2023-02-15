import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kcds/src/auth/view_model/auth_vm.dart';
import 'package:provider/provider.dart';

import '../../../resources/resources.dart';

class SplashView extends StatefulWidget {
  static String route = '/splash';
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  static late BuildContext _context;
  late Animation _animation;
  var vm = Provider.of<AuthVM>(Get.context!, listen: false);
  @override
  void initState() {
    super.initState();

    _animationController = new AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    Animatable animation = () {
      return Tween(begin: 0.0, end: 1.0);
    }();

    _animation = animation.animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInCirc));
    _animationController.forward().then((value) => doTransition());
  }

  /// call function case needed and then jump to next screen
  doTransition() async {
    nextPage();
  }

  @override
  void dispose() {
    _animationController.reset();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> nextPage() async {
    await vm.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: R.colors.theme,
        body: Center(
            child: RotationTransition(
                turns: (_animation as Animation<double>),
                child: SizedBox(
                    height: 200,
                    child: Image.asset(R.images.logo, height: 200)))));
  }
}
