import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:vocab/provider/appwrite_provider.dart';
import 'package:vocab/widgets/word_form.dart';

import '../constants.dart';
import '../models/language.dart';
import '../models/word.dart';

class ModifyWordPage extends StatelessWidget {
  final Future<List<Language>> languages;
  final Word word;
  final void Function(Word) delete;

  ModifyWordPage(
      {super.key,
      required this.languages,
      required this.word,
      required this.delete});

  @override
  Widget build(BuildContext context) {
    AppwriteProvider appwrite =
        Provider.of<AppwriteProvider>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Modify Word"),
        ),
        body: Column(
          children: [
            WordForm(
              languages: languages,
              word: word,
              action: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      await appwrite.database.updateDocument(
                          databaseId: Constants.databaseId,
                          collectionId: Constants.wordCollection,
                          documentId: word.id,
                          data: {
                            "mother_tongue": word.motherTongue,
                            "foreign_language": word.foreignLanguage,
                            "second_reading": word.secondReading,
                            "type": word.type,
                            "difficulty": word.difficulty,
                            "language_id": word.languageId,
                          });
                    },
                    child: const Text("Update"),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () {
                      appwrite.database.deleteDocument(
                          databaseId: Constants.databaseId,
                          collectionId: Constants.wordCollection,
                          documentId: word.id);

                      delete(word);

                      Navigator.pop(context);
                    },
                    child: const Text("Delete"),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
