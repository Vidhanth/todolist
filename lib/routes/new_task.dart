import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/providers/new_task_provider.dart';
import 'package:todolist/providers/todo_provider.dart';

// ignore: must_be_immutable
class NewTask extends StatelessWidget {
  Todo? todo;
  TextEditingController? controller;
  bool ignoreUpdate = false;
  NewTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewTaskProvider(),
      child: Builder(builder: (context) {
        if (ModalRoute.of(context)?.settings.arguments != null) {
          final args = ModalRoute.of(context)?.settings.arguments as List<Todo>;
          todo = Todo(
            args.first.id,
            args.first.text,
            args.first.colorIndex,
            args.first.completed,
          );
          controller ??= TextEditingController(text: todo!.text);
          Future.delayed(const Duration(milliseconds: 100), () {
            if (!ignoreUpdate) {
              context.read<NewTaskProvider>().colorIndex = todo!.colorIndex;
              ignoreUpdate = true;
            }
          });
        } else {
          controller ??= TextEditingController();
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(
              todo != null ? 'Edit Task' : 'New Task',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 23,
                height: 1,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            toolbarHeight: 80,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(
              color: Theme.of(context).colorScheme.onBackground,
            ),
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  maxLines: null,
                  autofocus: true,
                  onSubmitted: (_) async {
                    if (todo == null) {
                      await context.read<TodoProvider>().addTodo(
                            controller!.text.trim(),
                            context.read<NewTaskProvider>().colorIndex,
                          );
                    } else {
                      todo!.text = controller!.text.trim();
                      todo!.colorIndex =
                          context.read<NewTaskProvider>().colorIndex;
                      await context.read<TodoProvider>().updateTodo(todo!);
                    }
                    Navigator.pop(context);
                  },
                  controller: controller,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter task',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 20,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 30,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        context.read<NewTaskProvider>().colorIndex = index;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.accents[index],
                          border: context.watch<NewTaskProvider>().colorIndex ==
                                  index
                              ? Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  width: 2,
                                )
                              : null,
                        ),
                        width: 30,
                        margin: const EdgeInsets.only(right: 7),
                      ),
                    ),
                    itemCount: Colors.accents.length,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
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
                  onPressed: () async {
                    if (controller!.text.trim().isNotEmpty) {
                      if (todo == null) {
                        await context.read<TodoProvider>().addTodo(
                              controller!.text.trim(),
                              context.read<NewTaskProvider>().colorIndex,
                            );
                      } else {
                        todo!.text = controller!.text.trim();
                        todo!.colorIndex =
                            context.read<NewTaskProvider>().colorIndex;
                        await context.read<TodoProvider>().updateTodo(todo!);
                      }
                    }
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Save Task',
                    textAlign: TextAlign.center,
                  ),
                ),
                if (todo != null) ...[
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: GoogleFonts.poppins(
                        fontSize: 20,
                      ),
                      primary: Colors.red,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      minimumSize: Size(
                        MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height * 0.075,
                      ),
                    ),
                    onPressed: () async {
                      await context.read<TodoProvider>().deleteTodo(todo!.id);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Delete Task',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }
}
