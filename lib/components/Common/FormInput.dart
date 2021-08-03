import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  const FormInput(
      {Key? key,
      required TextEditingController controller,
      String? Function(String? value)? validator,
      FocusNode? nextFieldFocusNode,
      bool autoFocus = true,
      required String hintText,
      TextInputType keyboardType = TextInputType.name,
      FocusNode? focusNode,
      void Function(String)? onChanged})
      : _controller = controller,
        _validator = validator,
        _nextFieldFocusNode = nextFieldFocusNode,
        _autoFocus = autoFocus,
        _hintText = hintText,
        _keyboardType = keyboardType,
        _focusNode = focusNode,
        _onChanged = onChanged,
        super(key: key);

  final TextEditingController _controller;
  final String? Function(String? value)? _validator;
  final FocusNode? _nextFieldFocusNode;
  final bool _autoFocus;
  final String _hintText;
  final TextInputType _keyboardType;
  final FocusNode? _focusNode;
  final void Function(String value)? _onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: TextFormField(
          onChanged: _onChanged,
          focusNode: _focusNode,
          autofocus: _autoFocus,
          controller: _controller,
          keyboardType: _keyboardType,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: _hintText,
          ),
          validator: (String? value) {
            if (_validator != null && _validator!(value) != null) {
              return _validator!(value);
            }
          },
          onFieldSubmitted: (value) {
            if (_nextFieldFocusNode != null)
              _nextFieldFocusNode!.requestFocus();
          },
        ),
        margin: EdgeInsets.only(bottom: 5));
  }
}
