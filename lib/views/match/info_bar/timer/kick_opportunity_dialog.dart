import 'package:flutter/material.dart';

class KickDialog extends StatefulWidget {
  final String label;

  KickDialog({@required this.label});

  @override
  State<StatefulWidget> createState() {
    return _KickDialogState();
  }
}

class _KickDialogState extends State<KickDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Future.delayed(
        const Duration(seconds: 1),
        () => Navigator.pop(context, true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: widget.label.contains('Red')
                  ? Colors.red.shade300
                  : Theme.of(context).primaryColor,
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 48,
              child: Center(
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }
}
