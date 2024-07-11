import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:hive_flutter/hive_flutter.dart';

void main(){

}


/// creating new data
Future<void> createTask(Map<String,dynamic> task)async{

await tbox.add(task);
}

///read all data
void loadTask(){
final data=tbox.keys.map((id){
final value=tbox.get(id);
return {'key':id,'name':value['name'], 'details':value['details']}
})
}
/// updating hive data
Future <void>updateTask(int key,Map<String ,dynamic>uptask)async{
  await tbox.put(key,uptask);
  loadTask();
}

///delete hive data
Future<void>deleteTask(int task)async{
  await t
}

@override
  Widget build(BuildContext context) {
    return Scaffold(

    body: task.isEmpty?Center(
      child: Text("NO DATA"),
    ):ListView.builder(itemCount: task.length,itemBuilder: (context,index){
      return Card();
    })
    );

    s















