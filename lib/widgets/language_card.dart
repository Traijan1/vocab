import 'package:flutter/material.dart';
import 'package:vocab/models/language.dart';
import 'package:vocab/pages/word_page.dart';

class LanguageCard extends StatefulWidget {
  final Language language;

  const LanguageCard({super.key, required this.language});

  @override
  State<LanguageCard> createState() => _LanguageCardState();
}

class _LanguageCardState extends State<LanguageCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
      child: TextButton(
        style: Theme.of(context).textButtonTheme.style!.copyWith(
              textStyle: MaterialStateProperty.all(
                Theme.of(context).textTheme.headline2!.copyWith(fontSize: 32),
              ),
            ),
        child: Text(widget.language.name),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => WordPage(
                  language: widget.language,
                )),
          ),
        ),
      ),
    );
  }
}
