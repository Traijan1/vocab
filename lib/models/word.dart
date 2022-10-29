import 'package:appwrite/appwrite.dart';
import 'package:vocab/provider/appwrite_provider.dart';

import '../constants.dart';

class Word {
  String id;
  String motherTongue;
  String foreignLanguage;
  String? secondReading;
  String? type;
  String? difficulty;
  String languageId;

  Word(
      {required this.id,
      required this.motherTongue,
      required this.foreignLanguage,
      required this.secondReading,
      required this.type,
      required this.languageId,
      required this.difficulty});

  Word.empty(
      {this.id = "",
      this.motherTongue = "",
      this.foreignLanguage = "",
      this.secondReading = "",
      this.type = "",
      this.languageId = "",
      this.difficulty = ""});

  static Word fromMap(Map<String, dynamic> data) {
    return Word(
        foreignLanguage: data["foreign_language"],
        motherTongue: data["mother_tongue"],
        secondReading: data["second_reading"],
        type: data["type"],
        difficulty: data["difficulty"],
        languageId: data["language_id"],
        id: data["\$id"]);
  }

  static Future<List<Word>> getWords(
      AppwriteProvider appwrite, String languageId) async {
    List<Word> words = List.empty(growable: true);
    const int max = 100;
    int index = 0;

    while (true) {
      var result = await appwrite.database.listDocuments(
          databaseId: Constants.databaseId,
          collectionId: Constants.wordCollection,
          queries: [
            Query.equal("language_id", languageId),
            Query.lessThan("next_shown", DateTime.now().toUtc()),
            Query.limit(max),
            Query.offset(index * max)
          ]);

      for (var document in result.documents) {
        words.add(fromMap(document.data));
      }

      if (words.length == result.total) {
        break;
      }

      index++;
    }

    return words;
  }
}
