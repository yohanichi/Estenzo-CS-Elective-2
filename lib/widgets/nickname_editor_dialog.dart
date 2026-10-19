import 'package:flutter/material.dart';

class NicknameEditorDialog extends StatefulWidget {
  const NicknameEditorDialog({
    super.key,
    required this.pokemonName,
    required this.initialNickname,
  });

  final String pokemonName;
  final String? initialNickname;

  @override
  State<NicknameEditorDialog> createState() => _NicknameEditorDialogState();
}

class _NicknameEditorDialogState extends State<NicknameEditorDialog> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialNickname ?? '');
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nickname for ${_titleCase(widget.pokemonName)}'),
      content: TextField(
        controller: _textController,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(hintText: 'Enter a nickname'),
        onSubmitted: (value) => Navigator.of(context).pop(value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        if (widget.initialNickname != null)
          TextButton(
            onPressed: () => Navigator.of(context).pop(''),
            child: const Text('Remove'),
          ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_textController.text),
          child: const Text('Save'),
        ),
      ],
    );
  }

  String _titleCase(String value) =>
      value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';
}
