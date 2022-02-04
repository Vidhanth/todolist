import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todolist/components/todo_list.dart';
import 'package:provider/provider.dart';
import 'package:todolist/providers/theme_provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: FittedBox(
                            child: Text(
                              'Task Manager',
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: 40,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 5,
                            left: 20,
                          ),
                          child: IconButton(
                            splashRadius: 20,
                            onPressed: () {
                              context.read<ThemeProvider>().isDark =
                                  !context.read<ThemeProvider>().isDark;
                            },
                            iconSize: 30,
                            icon: Icon(
                              !context.read<ThemeProvider>().isDark
                                  ? Icons.dark_mode_outlined
                                  : Icons.light_mode_outlined,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const Expanded(child: TodoList()),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: GoogleFonts.poppins(
                      fontSize: 20,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    minimumSize: Size(
                      MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height * 0.075,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/newTask');
                  },
                  child: const Text(
                    'Add Task',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
