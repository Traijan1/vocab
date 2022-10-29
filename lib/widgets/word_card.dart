import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:vocab/pages/modify_word.dart';
import 'package:vocab/provider/appwrite_provider.dart';

import '../constants.dart';
import '../models/word.dart';
import '../pages/add_word.dart';

class WordCard extends StatelessWidget {
  final Word word;
  final void Function(Word) delete;

  const WordCard({super.key, required this.word, required this.delete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: TextButton(
        style: Theme.of(context).textButtonTheme.style!.copyWith(
              textStyle: MaterialStateProperty.all(
                Theme.of(context).textTheme.headline2!.copyWith(fontSize: 24),
              ),
              backgroundColor: MaterialStateProperty.all(
                  Constants.colorScheme?.tertiaryContainer),
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(word.motherTongue),
            const SizedBox(
              width: 15,
            ),
            Text(word.foreignLanguage),
          ],
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => ModifyWordPage(
                languages: Provider.of<AppwriteProvider>(context, listen: false)
                    .languages,
                word: word,
                delete: delete)),
          ),
        ),
      ),
    );
  }
}
