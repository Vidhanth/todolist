import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:todolist/components/task_filter_chip.dart';
import 'package:todolist/components/todo_item.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/providers/todo_provider.dart';
import 'package:provider/provider.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: context.watch<TodoProvider>().loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20,
                      top: 4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome back!",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 19,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        Text(
                          "Here's what you need to do.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            height: 1.45,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 10.0, bottom: 10),
                    child: Builder(builder: (context) {
                      TaskToShow taskToShow =
                          context.watch<TodoProvider>().taskToShow;
                      return FittedBox(
                        child: Row(
                          children: [
                            TaskFilterChip(
                              onTap: () {
                                context.read<TodoProvider>().taskToShow =
                                    TaskToShow.all;
                              },
                              active: taskToShow == TaskToShow.all,
                              label: 'All',
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TaskFilterChip(
                                onTap: () {
                                  context.read<TodoProvider>().taskToShow =
                                      TaskToShow.pending;
                                },
                                active: taskToShow == TaskToShow.pending,
                                label: 'Pending',
                              ),
                            ),
                            TaskFilterChip(
                              onTap: () {
                                context.read<TodoProvider>().taskToShow =
                                    TaskToShow.done;
                              },
                              active: taskToShow == TaskToShow.done,
                              label: 'Completed',
                            )
                          ],
                        ),
                      );
                    }),
                  ),
                  Expanded(
                      child: context.watch<TodoProvider>().todoList.isEmpty
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'No Tasks',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                  ),
                                  Text(
                                    context.read<TodoProvider>().noTaskMessage,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 19,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ImplicitlyAnimatedReorderableList(
                              physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(),
                              ),
                              padding:
                                  const EdgeInsets.only(top: 0, bottom: 10),
                              items: context.watch<TodoProvider>().todoList,
                              itemBuilder:
                                  (context, animation, Todo item, index) {
                                return Reorderable(
                                  key: ValueKey(item.id),
                                  builder: (context, anim, inDrag) =>
                                      SizeFadeTransition(
                                    sizeFraction: 0.7,
                                    curve: Curves.easeInOut,
                                    animation: animation,
                                    child: Handle(
                                      delay: const Duration(milliseconds: 300),
                                      child: TodoItem(
                                        inDrag: inDrag,
                                        todo: item,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              areItemsTheSame: (Todo a, Todo b) => a.id == b.id,
                              onReorderFinished: (Todo item, int from, int to,
                                  List<Todo> newItems) {
                                context
                                    .read<TodoProvider>()
                                    .reorderTodos(from, to);
                              },
                            ))
                ],
              ));
  }
}
