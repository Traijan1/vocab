import 'package:flutter/material.dart';
import 'package:vocab/models/language.dart';
import 'package:vocab/pages/word_page.dart';

class Card extends StatefulWidget {
  final String text;
  final Color? backgroundColor;

  const Card(
      {super.key, required this.text, this.backgroundColor = Colors.black});

  @override
  State<Card> createState() => _CardState();
}

class _CardState extends State<Card> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.5, horizontal: 10),
        child: Center(child: Text(widget.text)),
      ),
    );
  }
}
