import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AddTodo extends StatefulWidget {
  void Function({required String todoText}) addTodo;

  AddTodo({super.key, required this.addTodo});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController todoText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Add todo:"),
        TextField(
          onSubmitted: (value) {
            if (todoText.text.isNotEmpty) {
              widget.addTodo(todoText: todoText.text);
            }
            todoText.text = "";
          },
          autofocus: true,
          controller: todoText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(5),
            hintText: "Write your todo here...",
          ),
        ),
        ElevatedButton(
            onPressed: () {
              if (todoText.text.isNotEmpty) {
                widget.addTodo(todoText: todoText.text);
              }
              todoText.text = "";
            },
            child: Text("Add"))
      ],
    );
  }
}
