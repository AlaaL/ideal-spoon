import 'package:flutter/material.dart';

class FormSubmitButton extends StatelessWidget {
  final Function() onPressed;
  FormSubmitButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
        child: Container(
          height: 50,
          width: 250,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(20)),
          child: FlatButton(
            onPressed: onPressed,
            child: Text('Save'),
          ),
        ),
        padding: EdgeInsets.only(top: 15));
  }
}
