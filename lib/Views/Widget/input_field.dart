import 'package:flutter/material.dart';

Container inputField({
  IconData? iconPrefix,
  String? hint,
  TextEditingController? controller,
  TextInputType? textInputType,
  String? Function(String?)? validator,
  Widget? widget,
}) {
  return Container(
    margin: const EdgeInsets.only(top: 16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            readOnly: widget == null ? false : true,
            autofocus: false,
            keyboardType: textInputType,
            cursorColor: Colors.grey[700],
            controller: controller,
            validator: validator,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
            decoration: buildInputDecoration(
              hint,
              iconPrefix,
            ),
          ),
        ),
        if (widget != null)
          Container(
            child: widget,
          )
      ],
    ),
  );
}

InputDecoration buildInputDecoration(
  String? hinttext,
  IconData? iconprefix,
) {
  return InputDecoration(
    hintText: hinttext,
    prefixIcon: Icon(iconprefix),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Colors.purple, width: 1.5),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(
        color: Colors.purple,
        width: 1.5,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(
        color: Colors.purple,
        width: 1.5,
      ),
    ),
  );
}
