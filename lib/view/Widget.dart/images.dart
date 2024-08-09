import 'package:flutter/cupertino.dart';

class image extends StatelessWidget {
  const image({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("images/kk.jpg"),
                              fit: BoxFit.fill)),
                    );
  }
}