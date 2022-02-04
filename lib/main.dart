import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todolist/providers/theme_provider.dart';
import 'package:todolist/providers/todo_provider.dart';
import 'package:todolist/routes/home.dart';
import 'package:todolist/routes/new_task.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => TodoProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
      )
    ], child: const TodoListApp()),
  );
}

class TodoListApp extends StatefulWidget {
  const TodoListApp({Key? key}) : super(key: key);

  @override
  _TodoListAppState createState() => _TodoListAppState();
}

class _TodoListAppState extends State<TodoListApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: context.watch<ThemeProvider>().isDark
            ? const Color.fromARGB(255, 35, 35, 35)
            : Colors.grey.shade200,
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
          TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: OpenUpwardsPageTransitionsBuilder(),
        }),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        colorScheme: context.watch<ThemeProvider>().isDark
            ? const ColorScheme.dark(
                primary: Colors.white,
              )
            : const ColorScheme.light(
                primary: Colors.black,
              ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/newTask': (context) => NewTask(),
      },
    );
  }
}
