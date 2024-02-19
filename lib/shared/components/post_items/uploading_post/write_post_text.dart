import 'package:flutter/material.dart';

import '../../../styles/colors.dart';

class WritePostTextField extends StatelessWidget {
  const WritePostTextField({
    Key? key,
    required this.textEditingController,
    this.onChanged, this.onFieldSubmitted,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          controller: textEditingController,
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: WeLinkColors.myColor,
                  ))),
          maxLines: null,
          onChanged:onChanged,
          onFieldSubmitted: onFieldSubmitted,
        ),
      ),
    );
  }
}
