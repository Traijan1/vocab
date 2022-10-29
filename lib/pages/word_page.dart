import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocab/constants.dart';
import 'package:vocab/models/word.dart';
import 'package:vocab/provider/appwrite_provider.dart';

import '../models/language.dart';

class WordPage extends StatefulWidget {
  final Language language;

  const WordPage({super.key, required this.language});

  @override
  State<WordPage> createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  final TextEditingController field = TextEditingController();

  late Future<List<Word>> words;
  Word? word;
  String cache = "";
  int index = -1;
  bool guessedCorrect = true;

  @override
  void initState() {
    super.initState();
    words = Word.getWords(Provider.of<AppwriteProvider>(context, listen: false),
        widget.language.languageId);

    words.then((value) {
      value.shuffle();
      nextWord(value);
    });
  }

  nextWord(List<Word> words) {
    setState(() {
      index++;

      if (words.length != index) {
        word = words[index];
        cache = word?.foreignLanguage ?? "";
      } else {
        word = null;
        cache = "You cleared all words";
      }
    });

    field.text = "";
    guessedCorrect = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Learn")),
      body: FutureBuilder(
        future: words,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!;
            const double heightMargin = 15;

            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$index/${data.length} words done",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const Flexible(
                      child: FractionallySizedBox(
                        heightFactor: 0.35,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          cache,
                          style: Theme.of(context).textTheme.headline2,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: heightMargin),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(word?.type ?? "",
                                style: Theme.of(context).textTheme.bodyText1),
                            const SizedBox(width: 20),
                            Text(word?.difficulty?.toUpperCase() ?? "",
                                style: Theme.of(context).textTheme.bodyText1),
                          ],
                        ),
                        const SizedBox(height: 35),
                        TextField(
                          controller: field,
                          decoration: const InputDecoration(
                              hintText: "Write translation here.."),
                        ),
                        const SizedBox(height: heightMargin),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                child: const Text("Submit"),
                                onPressed: () async {
                                  if (field.text.toLowerCase() ==
                                      word?.motherTongue.toLowerCase()) {
                                    var appwrite =
                                        Provider.of<AppwriteProvider>(context,
                                            listen: false);

                                    appwrite.function.createExecution(
                                        functionId:
                                            Constants.updateWordFunction,
                                        data: "${word?.id};$guessedCorrect",
                                        xasync: true);

                                    nextWord(data);
                                  } else {
                                    guessedCorrect = false;
                                  }
                                }),
                            const SizedBox(width: heightMargin),
                            TextButton(
                                child: const Text("Skip"),
                                onPressed: () => setState(() {
                                      field.text = word?.motherTongue ?? "";
                                      guessedCorrect = false;
                                    })),
                          ],
                        ),
                        if (word?.secondReading != "" &&
                            !widget.language.usesLatinAlphabet) ...[
                          const SizedBox(height: heightMargin),
                          TextButton(
                              child: const Text("Second Reading"),
                              onPressed: () => setState(() {
                                    if (word?.secondReading == cache) {
                                      cache = word?.foreignLanguage ?? "";
                                    } else {
                                      cache = word?.secondReading ?? "";
                                    }
                                  })),
                        ]
                      ],
                    )
                  ]),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.hasError.toString());
          } else {
            return const Text("Waiting for words..");
          }
        }),
      ),
    );
  }
}
