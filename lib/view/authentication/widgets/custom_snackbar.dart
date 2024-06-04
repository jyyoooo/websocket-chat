import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showCustomSnackbar({
  required BuildContext context,
  required Widget content,
  required bool isPortrait,
  Color backgroundColor = CupertinoColors.lightBackgroundGray,
  Color textColor = CupertinoColors.destructiveRed,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      closeIconColor: Colors.grey,
      width: isPortrait ? MediaQuery.of(context).size.width-20 : 600,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: backgroundColor,
      showCloseIcon: true,
      content: DefaultTextStyle(
        style: TextStyle(color: textColor),
        child: content,
      ),
    ),
  );
}
