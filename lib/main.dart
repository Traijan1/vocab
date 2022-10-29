import 'package:appwrite/appwrite.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocab/constants.dart';
import 'package:vocab/pages/language_page.dart';
import 'package:vocab/pages/login_page.dart';
import 'package:vocab/provider/appwrite_provider.dart';
import "package:appwrite/models.dart" as Models;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Client client = Client();
  client.setEndpoint("http://home.traijan.de:8080/v1");
  client.setProject("6329de9e365e2d7e8440");

  Account acc = Account(client);

  Models.Account? user;

  try {
    user = await acc.get();
  } catch (e) {}

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppwriteProvider>(
            create: (context) => AppwriteProvider(client: client, user: user))
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: ((lightDynamic, darkDynamic) {
      Constants.colorScheme =
          WidgetsBinding.instance.window.platformBrightness == Brightness.dark
              ? darkDynamic
              : lightDynamic;

      return MaterialApp(
        title: 'Vocab',
        theme: ThemeData(
            brightness: Brightness.light,
            useMaterial3: true,
            scaffoldBackgroundColor: lightDynamic?.background,
            floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: lightDynamic?.primary ?? Colors.deepPurple,
                foregroundColor: lightDynamic?.onPrimary ?? Colors.black),
            appBarTheme: AppBarTheme(backgroundColor: lightDynamic?.background),
            inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: lightDynamic?.secondaryContainer ?? Colors.black,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(15)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(15))),
            textSelectionTheme: TextSelectionThemeData(
                cursorColor: lightDynamic?.primary ?? Colors.grey),
            textTheme: TextTheme(
              subtitle1: TextStyle(
                color: lightDynamic?.onSecondaryContainer ?? Colors.white,
              ),
              headline2: TextStyle(color: lightDynamic?.primary),
              bodyText1: TextStyle(color: lightDynamic?.tertiary, fontSize: 16),
            ), // Subtitle1 is used by Textfield
            textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
              backgroundColor: MaterialStateProperty.all(
                  lightDynamic?.secondaryContainer ?? Colors.black),
              foregroundColor: MaterialStateProperty.all(
                  lightDynamic?.onSecondaryContainer ?? Colors.white),
            ))),
        darkTheme: ThemeData(
          canvasColor: darkDynamic?.secondaryContainer ?? Colors.purple[800],
          brightness: Brightness.dark,
          useMaterial3: true,
          scaffoldBackgroundColor: darkDynamic?.background ?? Colors.black,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: darkDynamic?.primary ?? Colors.deepPurple,
              foregroundColor: darkDynamic?.onPrimary ?? Colors.black),
          appBarTheme: AppBarTheme(
              backgroundColor: darkDynamic?.background ?? Colors.black),
          inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: darkDynamic?.secondaryContainer ?? Colors.purple[800],
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15))),
          textSelectionTheme: TextSelectionThemeData(
              cursorColor: darkDynamic?.primary ?? Colors.grey),
          textTheme: TextTheme(
            subtitle1: TextStyle(
              color: darkDynamic?.onSecondaryContainer ?? Colors.white,
            ),
            headline2: TextStyle(color: darkDynamic?.primary ?? Colors.pink),
            bodyText1: TextStyle(color: darkDynamic?.tertiary, fontSize: 16),
          ), // Subtitle1 is used by Textfield
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
            backgroundColor: MaterialStateProperty.all(
                darkDynamic?.secondaryContainer ?? Colors.purple[800]),
            foregroundColor: MaterialStateProperty.all(
                darkDynamic?.onSecondaryContainer ?? Colors.white),
          )),
        ),
        home: Provider.of<AppwriteProvider>(context).user == null
            ? LoginPage()
            : const LanguagePage(),
      );
    }));
  }
}
