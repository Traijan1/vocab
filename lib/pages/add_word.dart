import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocab/constants.dart';
import 'package:vocab/models/language.dart';
import 'package:vocab/provider/appwrite_provider.dart';
import 'package:vocab/widgets/card.dart' as vocab;
import 'package:vocab/widgets/word_form.dart';

import '../models/word.dart';

class AddWordPage extends StatefulWidget {
  final Future<List<Language>> languages;

  AddWordPage({super.key, required this.languages});

  @override
  State<AddWordPage> createState() => _AddWordPageState();
}

class _AddWordPageState extends State<AddWordPage> {
  late AppwriteProvider appwrite;
  late Word word;

  @override
  void initState() {
    appwrite = Provider.of<AppwriteProvider>(context, listen: false);
    word = Word.empty();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Word"),
        ),
        body: WordForm(
          languages: widget.languages,
          word: word,
          action: TextButton(
              onPressed: () async {
                print(word.motherTongue);

                if (word.motherTongue.isEmpty ||
                    word.foreignLanguage.isEmpty ||
                    word.languageId.isEmpty) {
                  return;
                }

                print(word.foreignLanguage);

                var dynamicWord = {
                  "mother_tongue": word.motherTongue,
                  "foreign_language": word.foreignLanguage,
                  "second_reading": word.secondReading,
                  "type": word.type,
                  "difficulty": word.difficulty,
                  "language_id": word.languageId,
                  "next_shown": DateTime.now().toUtc().toString()
                };

                await appwrite.database.createDocument(
                    databaseId: Constants.databaseId,
                    collectionId: Constants.wordCollection,
                    documentId: "unique()",
                    data: dynamicWord);

                setState(() => word = Word.empty());
              },
              child: const Text("Add")),
        ));
  }
}
