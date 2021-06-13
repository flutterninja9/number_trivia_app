import 'package:flutter/material.dart';

class MessageDisplayed extends StatelessWidget {
  final String messageDisplayed;
  const MessageDisplayed({
    Key key,
    this.messageDisplayed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: SingleChildScrollView(
          child: Text(
            messageDisplayed,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ),
      ),
    );
  }
}
