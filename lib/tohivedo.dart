// import 'package:first_app/sql/ui/sqlHelper.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("task_box");


  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TodoUI(),
  ));
}

class TodoUI extends StatefulWidget {
  @override
  State<TodoUI> createState() => _TodoUIState();
}

class _TodoUIState extends State<TodoUI> {
  List<Map<String, dynamic>> task = [];

  final tbox = Hive.box("task_box"); // object creation of hive

  bool isLoading = true;

  Future<void> createTask(Map<String, dynamic> task) async {
    await tbox.add(task);
    loadTask();
  } // to create new data


  void loadTask() {
    final data = tbox.keys.map((id) {
      final value = tbox.get(id);
      return {'key' : id, 'name' : value['name'], 'details' : value['details']};
    }).toList();

    setState(() {
      task = data.toList();
    });
  }
  @override
  void initState() {
    //refreshing ui
    loadTask();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Sqflite Todo App"),
      ),
      body: task.isEmpty
          ? Center(
        child: Text(
          "no data",
          style: TextStyle(fontSize: 40),
        ),
      )
          : ListView.builder(
          itemCount: task.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.blue,
              child: ListTile(
                title: Text(task[index]['name']),
                subtitle: Text(task[index]['details']),
                trailing: Wrap(
                  children: [
                    IconButton(onPressed: (){
                      showform(context, task[index]['key']);
                    }, icon:const Icon(Icons.edit)),
                    IconButton(onPressed: (){
                      deleteTask(task[index]['key']);
                    }, icon: Icon(Icons.delete)),
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showform(context, null),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  final title = TextEditingController();
  final note = TextEditingController();

  void showform(BuildContext context, int? id) async {
    if (id != null) {
      final ex_task = task.firstWhere((element) => element['key']==id);
      title.text = ex_task['name'];
      note.text = ex_task['details'];
    }

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => Container(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 120,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: title,
                decoration: InputDecoration(
                    hintText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: note,
                decoration: InputDecoration(
                    hintText: "content",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (id == null) {
                    createTask({'name' : title.text, 'details' : note.text});
                    // await addNote();
                  }
                  if (id != null) {
                    updateTask(id, {'name' : title.text, 'details' : note.text});
                  }
                  title.text = "";
                  note.text = "";
                  Navigator.of(context).pop();
                },
                child: Text(id == null ? 'Add' : 'Update'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent.shade400),
              )
            ],
          ),
        ));
  }

  // Future addNote() async {
  //   await Sqlhelper.createNote(title.text, note.text);
  //   refreshdata();
  // }


  /// updating hive data
  Future<void> updateTask(int key, Map<String, dynamic> uptask) async {
    await tbox.put(key, uptask);
    loadTask();
  }



  Future deleteTask(int key) async {
    await tbox.delete(key);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Note Deleted")));
    loadTask();
  }
}