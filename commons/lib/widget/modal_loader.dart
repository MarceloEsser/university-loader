import 'package:flutter/material.dart';

class ModalLoader extends StatelessWidget {
  const ModalLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: Colors.pink,
        ),
      ),
    );
  }
}
