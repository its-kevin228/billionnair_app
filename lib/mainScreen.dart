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
              title: Text("Already exists"),
              content: Text("This todo data already exists."),
              actions: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text("Close"))
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
              padding: EdgeInsets.all(20),
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
          shape: CircleBorder(),
          backgroundColor: Colors.blueGrey[900],
          child: Icon(Icons.add, color: Colors.white),
          onPressed: showAddTodoBottomSheet),
      drawer: Drawer(
          child: Column(
        children: [
          Container(
            color: Colors.blueGrey[900],
            height: 200,
            width: double.infinity,
            child: Center(
              child: Text(
                "Todo App",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(
              onTap: () {
                launchUrl(Uri.parse("https://sujanpokhrelstc.netlify.app"));
              },
              leading: Icon(Icons.person),
              title: Text("About Me",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          ListTile(
              onTap: () {
                launchUrl(Uri.parse("mailto:someone@example.com"));
              },
              leading: Icon(Icons.email),
              title: Text("Contact me",
                  style: TextStyle(fontWeight: FontWeight.bold)))
        ],
      )),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Todo App"),
      ),
      body: TodoListBuilder(
        todoList: todoList,
        updateLocalData: updateLocalData,
      ),
    );
  }
}
