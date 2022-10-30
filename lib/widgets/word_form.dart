import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/language.dart';
import '../models/word.dart';
import '../provider/appwrite_provider.dart';
import 'package:vocab/widgets/card.dart' as vocab;

class WordForm extends StatefulWidget {
  final Future<List<Language>> languages;
  final Word word;
  Widget? action;

  WordForm(
      {super.key, required this.languages, required this.word, this.action});

  @override
  State<WordForm> createState() => _WordFormState();
}

class _WordFormState extends State<WordForm> {
  String dropdownValue = "";
  final TextEditingController motherTongueController = TextEditingController();
  final TextEditingController foreignLanguageController =
      TextEditingController();
  final TextEditingController secondReadingController = TextEditingController();
  final TextEditingController wordTypeController = TextEditingController();
  final TextEditingController difficultyController = TextEditingController();
  late AppwriteProvider appwrite;

  bool hasSecondReading = false;

  void setValues() {
    dropdownValue = widget.word.languageId;
    motherTongueController.text = widget.word.motherTongue;
    foreignLanguageController.text = widget.word.foreignLanguage;
    secondReadingController.text = widget.word.secondReading ?? "";
    wordTypeController.text = widget.word.type ?? "";
    difficultyController.text = widget.word.difficulty ?? "";

    widget.languages.then((data) => checkForSecondReading(data));
  }

  @override
  void initState() {
    appwrite = Provider.of<AppwriteProvider>(context, listen: false);
    setValues();

    super.initState();
  }

  void checkForSecondReading(List<Language> languages) {
    for (Language lang in languages) {
      if (lang.languageId == dropdownValue) {
        setState(() => hasSecondReading = !lang.usesLatinAlphabet);

        break;
      }
    }
  }

  @override
  void didUpdateWidget(covariant WordForm oldWidget) {
    setValues();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.languages,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;
          if (dropdownValue.isEmpty) {
            dropdownValue = data![0].languageId;
            widget.word.languageId = dropdownValue;
          }

          var spacer = const TableRow(
            children: [
              SizedBox(
                height: 15,
              ),
              SizedBox(),
              SizedBox(
                height: 15,
              )
            ],
          );

          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                children: [
                  Table(
                    columnWidths: const {
                      0: FractionColumnWidth(0.35),
                      1: FractionColumnWidth(0.05),
                      2: FractionColumnWidth(0.6),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        children: [
                          vocab.Card(
                            text: "Mother Tongue",
                            backgroundColor: Theme.of(context).canvasColor,
                          ),
                          const SizedBox(),
                          TextField(
                            controller: motherTongueController,
                            onChanged: (value) =>
                                widget.word.motherTongue = value,
                          ),
                        ],
                      ),
                      spacer,
                      TableRow(
                        children: [
                          Container(
                              height: 45,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).canvasColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Center(
                                    child: DropdownButton(
                                      underline: const SizedBox(),
                                      value: dropdownValue,
                                      items: data?.map((Language item) {
                                        return DropdownMenuItem(
                                            value: item.languageId,
                                            child: Text(item.name));
                                      }).toList(),
                                      onChanged: (String? value) =>
                                          setState(() {
                                        dropdownValue = value!;
                                        widget.word.languageId = value;
                                        checkForSecondReading(data!);
                                      }),
                                    ),
                                  ),
                                ),
                              )),
                          const SizedBox(),
                          TextField(
                            controller: foreignLanguageController,
                            onChanged: (value) =>
                                widget.word.foreignLanguage = value,
                          ),
                        ],
                      ),
                      if (hasSecondReading) ...[
                        spacer,
                        TableRow(
                          children: [
                            vocab.Card(
                              text: "Second Reading",
                              backgroundColor: Theme.of(context).canvasColor,
                            ),
                            const SizedBox(),
                            TextField(
                              controller: secondReadingController,
                              onChanged: (value) =>
                                  widget.word.secondReading = value,
                            ),
                          ],
                        )
                      ],
                      spacer,
                      TableRow(
                        children: [
                          vocab.Card(
                            text: "Word Type",
                            backgroundColor: Theme.of(context).canvasColor,
                          ),
                          const SizedBox(),
                          TextField(
                            controller: wordTypeController,
                            onChanged: (value) => widget.word.type = value,
                          ),
                        ],
                      ),
                      spacer,
                      TableRow(
                        children: [
                          vocab.Card(
                            text: "Difficulty",
                            backgroundColor: Theme.of(context).canvasColor,
                          ),
                          const SizedBox(),
                          TextField(
                            controller: difficultyController,
                            onChanged: (value) =>
                                widget.word.difficulty = value,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  if (widget.action != null) ...[widget.action!]
                ],
              ));
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          return const Text("Loading");
        }
      }),
    );
  }
}

/*

Column(children: [
                Row(
                  children: [
                    Column(
                      children: [
                        vocab.Card(
                          text: "Mother Tongue",
                          backgroundColor: Theme.of(context).canvasColor,
                        ),
                        const SizedBox(height: 15),
                        Container(
                            height: 45,
                            child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).canvasColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: DropdownButton(
                                        underline: const SizedBox(),
                                        value: dropdownValue,
                                        items: data?.map((Language item) {
                                          return DropdownMenuItem(
                                              value: item.languageId,
                                              child: Text(item.name));
                                        }).toList(),
                                        onChanged: (String? value) =>
                                            setState(() {
                                              dropdownValue = value!;
                                              widget.word.languageId = value;
                                            }))))),
                        const SizedBox(height: 15),
                        vocab.Card(
                          text: "Second Reading",
                          backgroundColor: Theme.of(context).canvasColor,
                        ),
                        const SizedBox(height: 15),
                        vocab.Card(
                          text: "Word Type",
                          backgroundColor: Theme.of(context).canvasColor,
                        ),
                        const SizedBox(height: 15),
                        vocab.Card(
                          text: "Difficulty",
                          backgroundColor: Theme.of(context).canvasColor,
                        ),
                        const SizedBox(height: 15)
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: Column(
                      children: [
                        TextField(
                          controller: motherTongueController,
                          onChanged: (value) =>
                              widget.word.motherTongue = value,
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: foreignLanguageController,
                          onChanged: (value) =>
                              widget.word.foreignLanguage = value,
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: secondReadingController,
                          onChanged: (value) =>
                              widget.word.secondReading = value,
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: wordTypeController,
                          onChanged: (value) => widget.word.type = value,
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: difficultyController,
                          onChanged: (value) => widget.word.difficulty = value,
                        ),
                      ],
                    ))
                  ],
                ),
                const SizedBox(height: 25),
                if (widget.action != null) ...[widget.action!]
              ])

*/
