import 'package:appwrite/appwrite.dart';
import 'package:vocab/constants.dart';

import "../provider/appwrite_provider.dart";
import "package:appwrite/models.dart" as Models;

class Language {
  String languageId;
  String name;
  int count;
  bool usesLatinAlphabet;

  Language(
      {required this.languageId,
      required this.name,
      required this.count,
      required this.usesLatinAlphabet});

  static Future<Models.DocumentList> getLanguages(
      Databases database, Models.Account user) async {
    return database.listDocuments(
        databaseId: Constants.databaseId,
        collectionId: Constants.languageCollection,
        queries: [Query.equal("userId", user.$id)]);
  }

  static Future<List<Language>> parseDocumentList(
      Databases database, Models.Account user) async {
    var list = await getLanguages(database, user);
    List<Language> returnValue = List.empty(growable: true);

    for (var document in list.documents) {
      returnValue.add(Language(
        languageId: document.data["\$id"],
        name: document.data["name"],
        count: document.data["count"],
        usesLatinAlphabet: document.data["uses_latin_alphabet"],
      ));
    }

    return returnValue;
  }
}
