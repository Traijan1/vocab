import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocab/constants.dart';
import 'package:vocab/pages/add_word.dart';
import 'package:vocab/widgets/word_card.dart';

import '../models/language.dart';
import '../models/word.dart';
import '../provider/appwrite_provider.dart';
import '../widgets/language_card.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  late Future<List<Language>> languages;
  List<Word> words = List.empty(growable: true);
  late AppwriteProvider appwrite;

  @override
  void initState() {
    appwrite = Provider.of<AppwriteProvider>(context, listen: false);
    languages = appwrite.languages;
    super.initState();
  }

  void search(String value) async {
    setState(() => words.clear());

    if (value.isEmpty) {
      return;
    }

    var motherTongue = await appwrite.database.listDocuments(
        databaseId: Constants.databaseId,
        collectionId: Constants.wordCollection,
        queries: [
          Query.search("mother_tongue", value),
        ]);

    var foreignLanguage = await appwrite.database.listDocuments(
        databaseId: Constants.databaseId,
        collectionId: Constants.wordCollection,
        queries: [
          Query.search("foreign_language", value),
        ]);

    var secondReading = await appwrite.database.listDocuments(
        databaseId: Constants.databaseId,
        collectionId: Constants.wordCollection,
        queries: [
          Query.search("second_reading", value),
        ]);

    motherTongue.documents
        .insertAll(motherTongue.documents.length, foreignLanguage.documents);

    motherTongue.documents
        .insertAll(motherTongue.documents.length, secondReading.documents);

    setState(() {
      for (var document in motherTongue.documents) {
        words.add(Word.fromMap(document.data));
      }
    });
  }

  void deleteWord(Word toDelete) {
    setState(() => words.remove(toDelete));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Language"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => AddWordPage(
                    languages: languages,
                  )),
            ),
          );
        },
      ),
      body: FutureBuilder<List<Language>>(
          future: languages,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data!;
              return Column(children: [
                Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    child: TextField(
                        onChanged: search,
                        decoration: InputDecoration(
                            hintText: "Search word..",
                            fillColor:
                                Constants.colorScheme?.primaryContainer))),
                Expanded(
                  child: words.isEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: ((context, index) {
                            return LanguageCard(
                              language: data[index],
                            );
                          }),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: words.length,
                          itemBuilder: ((context, index) => WordCard(
                                word: words[index],
                                delete: deleteWord,
                              )),
                        ),
                ),
              ]);
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error!}");
            } else {
              return const Text("Loading Languages..");
            }
          })),
    );
  }
}
