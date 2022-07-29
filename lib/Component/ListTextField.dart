// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: camel_case_types, must_be_immutable
// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class Custom_ListTile_TextField extends StatelessWidget {
  TextEditingController? controller;
  FormFieldValidator? validations;
  ValueChanged<String>? onChange;
  ValueChanged<String>?  onSubmit;
  VoidCallback? onEdit;
  ValueChanged<bool>? onFocusChange;
  AutovalidateMode? autoValidate;
  bool read;
  bool isMask;
  bool isNumber;
  var mask;
  var labelText;
  var hintText;
  int? maxLines;
  bool? obscureText;

  Custom_ListTile_TextField(
      {Key? key, required this.isMask,
        this.mask,
        required this.read,
        this.controller,
        this.validations,
        this.labelText,
        this.hintText,
        this.maxLines,
        this.onChange,
        this.onSubmit,
        this.onEdit,
        this.onFocusChange,
        this.autoValidate,
        required this.isNumber,
        this.obscureText
        //  required this.textInput
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Container(
          margin: EdgeInsets.all(2),
          child: FocusScope(
              onFocusChange: onFocusChange ?? null,
              child: TextFormField(
                obscureText: obscureText ?? false,
                autovalidateMode: autoValidate ?? null,
                onChanged: onChange ?? null,
                onFieldSubmitted: onSubmit ?? null,
                onEditingComplete: onEdit ?? null,
                maxLines: maxLines ?? 1,
                inputFormatters:
                isNumber ?  <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                ] : isMask ? [TextInputMask(mask: mask, reverse: false)] : null,
                readOnly: read,
                // keyboardType: textInput == null ? TextInputType.text : textInput,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                    labelText: labelText,
                    hintText: hintText,
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                    // fillColor: ThemeColors.confidenceBlue,
                    filled: read ? true : false),
                controller: controller,
                validator: validations,
              )
          )
      )

    ;
  }
}

class Custom_ListTile_TextField_Icon extends StatelessWidget {
  TextEditingController controller;
  String Function(String) validations;
  bool read;
  bool isMask;
  var mask;
  var labelText;
  var hintText;
  TextInputType textInput;
  dynamic onPressed;

  Custom_ListTile_TextField_Icon(
      {required this.isMask,
        this.mask,
        required this.read,
        required this.controller,
        required this.validations,
        this.labelText,
        this.hintText,
        required this.textInput,
        required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        flex: 9,
        child:
        TextFormField(
          inputFormatters: isMask
              ? [TextInputMask(mask: this.mask, reverse: false)]
              : null,
          readOnly: this.read,
          keyboardType: textInput == null ? TextInputType.text : textInput,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
              labelText: this.labelText,
              hintText: this.hintText,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              //   fillColor: ThemeColors.confidenceBlue,
              filled: read ? true : false),
          controller: this.controller,
          // validator: this.validations,
        ),

      ),
      Expanded(
        flex: 1,
        child: IconButton(
          icon: Icon(Icons.camera),
          onPressed: this.onPressed,
        ),
      )
    ]);
  }
}
