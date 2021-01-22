import 'package:flutter/material.dart';
import 'package:static_soccer/logic/cache/prefs.dart';

class EditStrengthDialog extends StatefulWidget {
  final String team;

  EditStrengthDialog({@required this.team});

  @override
  State<StatefulWidget> createState() {
    return _EditStrengthDialogState();
  }
}

class _EditStrengthDialogState extends State<EditStrengthDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          0,
          16,
          MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Material(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.team,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14, bottom: 8),
                  child: SizedBox(
                    width: 200,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        autofocus: true,
                        controller: _textController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Strength',
                          border: OutlineInputBorder(),
                        ),
                        validator: (input) {
                          if (double.tryParse(input) == null)
                            return 'Enter a number';
                          else if (double.tryParse(input) > 100)
                            return 'Max 100';
                          else
                            return null;
                        },
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      child: Text('CANCEL'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      child: Text('SUBMIT'),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await Prefs.instance.setDouble(
                            widget.team + ' strength',
                            double.parse(_textController.text),
                          );
                          Navigator.pop(context, true);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
