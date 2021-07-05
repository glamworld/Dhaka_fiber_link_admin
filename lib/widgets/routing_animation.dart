import 'package:flutter/cupertino.dart';

class AnimationPageRoute extends PageRouteBuilder {
  final Widget navigateTo;

  AnimationPageRoute({required this.navigateTo})
      : super(
      transitionDuration: Duration(milliseconds: 500),
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation, Widget child) {
        animation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInSine);
        return ScaleTransition(
          scale: animation,
          alignment: Alignment.center,
          child: child,
        );
      },
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secAnimation) {
        return navigateTo;
      });
}

// Navigator.push(context, AnimationPageRoute(navigateTo: NewOrganization()));
