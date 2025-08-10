import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:namer_app/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    // TO DO put key on an env and search if using anon key is secure and how does it maintains session, is it through JWT token or what?
    url: 'https://hzzgulnatcbtjdcgwycg.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh6emd1bG5hdGNidGpkY2d3eWNnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ2ODI3MjMsImV4cCI6MjA3MDI1ODcyM30.Wh6uT2hV5Jx8We_27FkP3IMlZT2w6tAMbYgQiyJmGVc',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MyAppState(),
        child: MaterialApp.router(
          title: 'Namer App',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
          ),
          routerConfig: Routes.router,
        ));
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}
