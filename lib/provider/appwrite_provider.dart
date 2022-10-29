import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import "package:appwrite/models.dart" as Models;

import '../models/language.dart';

class AppwriteProvider extends ChangeNotifier {
  final Client client;
  Models.Account? user;
  late Databases database;
  late Functions function;
  late Future<List<Language>> languages;

  AppwriteProvider({required this.client, this.user}) {
    database = Databases(client);
    function = Functions(client);

    languages = Language.parseDocumentList(database, user!);
  }

  login(String email, String password) async {
    Account account = Account(client);
    await account.createEmailSession(email: email, password: password);
    user = await account.get();
    notifyListeners();
  }

  logout() async {
    Account account = Account(client);
    await account.deleteSessions();
    user = null;
    notifyListeners();
  }

  loadLanguages() {}
}
