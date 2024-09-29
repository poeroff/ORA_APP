import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final void Function(bool)? onValidityChanged;
  final bool showError;

  const InputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.onValidityChanged,
    required this.showError,
  });

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late ValueNotifier<bool> _isEmptyNotifier;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _isEmptyNotifier = ValueNotifier(widget.controller.text.isEmpty);
    widget.controller.addListener(_validateInput);
  }

  void _validateInput() {
    setState(() {
      _isEmptyNotifier.value = widget.controller.text.isEmpty;
    });
    widget.onValidityChanged?.call(!_isEmptyNotifier.value);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validateInput);
    _isEmptyNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25, bottom: 5),
          child: Text(
            widget.label,
            style: const TextStyle(color: Colors.black, fontSize: 15),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: ValueListenableBuilder<bool>(
            valueListenable: _isEmptyNotifier,
            builder: (context, isEmpty, child) {
              return TextField(
                keyboardType: TextInputType.text,
                style: const TextStyle(color: Colors.black),
                controller: widget.controller,
                onChanged: (value) => {
                  _validateInput(),
                  setState(() {
                    if (widget.label.toLowerCase().contains("email") &&
                        widget.showError) {
                      if (value.isEmpty) {
                        _errorText = '이메일을 입력해주세요';
                      } else if (!value.contains('@')) {
                        _errorText = '올바른 이메일 형식이 아닙니다';
                      } else {
                        _errorText = null;
                      }
                    } else if (widget.label
                            .toLowerCase()
                            .contains("Password") &&
                        widget.showError) {
                      if (value.isEmpty) {
                        _errorText = '패스워드를 입력해주세요';
                      } else {
                        _errorText = null;
                      }
                    }
                  })
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: widget.hintText,
                  errorText: _errorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: (isEmpty && widget.showError)
                            ? Colors.red
                            : Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: (isEmpty && widget.showError)
                            ? Colors.red
                            : Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: (isEmpty && widget.showError)
                            ? Colors.red
                            : Colors.grey),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
