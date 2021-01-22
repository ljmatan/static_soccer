import 'package:flutter/material.dart';
import 'package:static_soccer/views/home/start_match_button.dart';
import 'package:static_soccer/views/home/top_bar/top_bar.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            left: 16,
            top: 16 + MediaQuery.of(context).padding.top,
            right: 16,
            child: TopBar(),
          ),
          Positioned(
            left: 16,
            bottom: 16,
            right: 16,
            child: StartMatchButton(),
          ),
        ],
      ),
    );
  }
}
