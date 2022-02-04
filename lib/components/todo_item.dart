import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todolist/models/todo.dart';
import 'package:provider/provider.dart';
import 'package:todolist/providers/todo_provider.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final bool inDrag;
  const TodoItem({
    Key? key,
    required this.todo,
    this.inDrag = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          margin: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 20,
          ),
          elevation: inDrag ? 5 : 0,
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/newTask', arguments: [todo]);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 15,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Colors.accents[todo.colorIndex],
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusColor: Colors.accents[todo.colorIndex],
                        activeColor: Colors.accents[todo.colorIndex],
                        value: todo.completed,
                        onChanged: (checked) {
                          context.read<TodoProvider>().updateTodo(
                                Todo(todo.id, todo.text, todo.colorIndex,
                                    checked!),
                              );
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Text(
                          todo.text,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onBackground,
                            decoration: todo.completed
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
