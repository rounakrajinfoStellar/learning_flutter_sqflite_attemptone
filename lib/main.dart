import 'package:flutter/material.dart';
import 'package:learning_flutter_sqflite_attemptone/services/db_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameCreateController = TextEditingController();
  TextEditingController nameUpdateController = TextEditingController();
  TextEditingController idUpdateController = TextEditingController();
  TextEditingController idDeleteController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(controller: nameCreateController, decoration: InputDecoration(
                      hintText: "Enter Name",
                    ),),
                  ),
                ),
                ElevatedButton(onPressed: () async{

                  if(nameCreateController.text != ""){
                    await DatabaseHelper.instance.insertRecord(
                        {DatabaseHelper.columnName:nameCreateController.text});
                  }
                  setState(() {
                    nameCreateController.text = "";
                  });
                  }, child: Text("Create")
                ),
              ],
            ),

            ElevatedButton(onPressed: () async {
              var dbquery = await DatabaseHelper.instance.queryDatabase();
              print(dbquery);
              },
                child: Text("Read")
            ),

            ElevatedButton(onPressed: () async {

              if(idUpdateController.text != "" && nameUpdateController.text != ""){
                 await DatabaseHelper.instance.updateRecord({
                  //todo try passing string one time in id
                  DatabaseHelper.columnId: int.tryParse(idUpdateController.text),
                  DatabaseHelper.columnName: nameUpdateController.text
                });
                setState(() {
                  idUpdateController.text = "";
                  nameUpdateController.text = "";
                });
              }

              },
                child: Row(
                  children: [
                    Expanded(child: TextField(controller: idUpdateController, decoration: InputDecoration(
                      hintText: "Enter Id",
                    ),)),
                    SizedBox(width: 20,),
                    Expanded(child: TextField(controller: nameUpdateController, decoration: InputDecoration(
                      hintText: "Enter Name",
                    ),)),
                    Text("Update"),
                  ],
                )),

            ElevatedButton(onPressed: () async {
              if(idDeleteController.text != ""){
                await DatabaseHelper.instance.deleteRecord(int.parse(idDeleteController.text));
                setState(() {
                  idDeleteController.text = "";
                });
              }
            },
                child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: idDeleteController, decoration: InputDecoration(hintText: "Enter Id")),
                  ),
                  Text("Delete"),
              ],
            )),
          ]
        )
      )
    );
  }
}
