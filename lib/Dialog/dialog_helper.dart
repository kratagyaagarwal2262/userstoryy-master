import 'exitconformation.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  static exit(context) =>
      showDialog(context: context, builder: (context) => ExitConfirmation());
}