import 'package:flutter/material.dart';

showMsg(BuildContext context, String mgs) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mgs)));

showSingleTextFiledDialog({
  required BuildContext context,
  required String title,
  required String hint,
  TextInputType inputType = TextInputType.name,
  String positiveBtText = 'SAVE',
  String negativeBtText = 'CANCEL',
  required Function(String) onSave,
}) {
  final controller = TextEditingController();
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AlertDialog(
            title: Text(title),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller,
                keyboardType: inputType,
                decoration: InputDecoration(
                  hintText: hint,
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(negativeBtText)),
              ElevatedButton(
                  onPressed: () {
                    if (controller.text.isEmpty) {
                      return;
                    }
                    Navigator.pop(context);
                    onSave(controller.text);
                  },
                  child: Text(positiveBtText)),
            ],
          ));
}
