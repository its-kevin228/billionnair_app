import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/addTodo.dart';
import 'package:todoapp/widgets/todoList.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<String> todoList = [];

  void addTodo({required String todoText}) {
    if (todoList.contains(todoText)) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Already exists"),
              content: const Text("This todo data already exists."),
              actions: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Close"))
              ],
            );
          });

      return;
    }

    setState(() {
      todoList.insert(0, todoText);
    });
    updateLocalData();
    Navigator.pop(context);
  }

  void updateLocalData() async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('todoList', todoList);
  }

  void loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    todoList = prefs.getStringList("todoList") ?? [];
    setState(() {});
  }

  @override
  void initState() {
    loadData();
    // Super.initState
    super.initState();
  }

  void showAddTodoBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              padding: const EdgeInsets.all(20),
              height: 200,
              child: AddTodo(addTodo: addTodo),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
           backgroundColor: Color.fromARGB(255, 243, 246, 243),
          child: const Icon(Icons.add, color: Color.fromARGB(255, 13, 13, 13)),
          onPressed: showAddTodoBottomSheet),
      drawer: Drawer(
          child: Column(
        children: [
          Container(
            color: Color.fromARGB(255, 102, 104, 105),
            height: 200,
            width: double.infinity,
            child: const Center(
              child: Text(
                "Make Your List",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(
              onTap: () {
                launchUrl(Uri.parse("www.linkedin.com/in/pekpeli-gnimdou-kévin-102403249"));
              },
              leading: const Icon(Icons.person),
              title: const Text("About Me",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          ListTile(
              onTap: () {
                launchUrl(Uri.parse("pekpelignimdoukevin@gmail.com"));
              },
              leading: const Icon(Icons.email),
              title: const Text("Contact me",
                  style: TextStyle(fontWeight: FontWeight.bold)))
        ],
      )),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Make Your List"),
      ),
      body: TodoListBuilder(
        todoList: todoList,
        updateLocalData: updateLocalData,
      ),
    );
  }
}
