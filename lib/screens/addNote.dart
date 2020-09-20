import 'package:AllNote/databases/dbNotesHelper.dart';
import 'package:AllNote/models/notes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController titleController;
  TextEditingController bodyFieldController;
  DbNotesHelper dbHelper;
  DateTime currentDateTime;
  String date;
  String time;
  bool titleAutoFocus = false;
  bool bodyFieldAutoFocus = true;
  Map<String, dynamic> arguments;
  @override
  void initState() {
    super.initState();
    titleController = new TextEditingController();
    bodyFieldController = new TextEditingController();
    print('initState');
    // bodyFieldController.text =
    //     "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis fringilla aliquam lacinia. Donec sed pretium lacus. Sed vehicula laoreet libero vitae vehicula. Suspendisse vitae bibendum ligula. Pellentesque rhoncus maximus erat id imperdiet. Integer eget nunc nec ipsum placerat fermentum ac eu neque. Vivamus accumsan augue a urna fringilla dapibus."
    //     "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis fringilla aliquam lacinia. Donec sed pretium lacus. Sed vehicula laoreet libero vitae vehicula. Suspendisse vitae bibendum ligula. Pellentesque rhoncus maximus erat id imperdiet. Integer eget nunc nec ipsum placerat fermentum ac eu neque. Vivamus accumsan augue a urna fringilla dapibus."
    //     "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis fringilla aliquam lacinia. Donec sed pretium lacus. Sed vehicula laoreet libero vitae vehicula. Suspendisse vitae bibendum ligula. Pellentesque rhoncus maximus erat id imperdiet. Integer eget nunc nec ipsum placerat fermentum ac eu neque. Vivamus accumsan augue a urna fringilla dapibus."
    //     "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis fringilla aliquam lacinia. Donec sed pretium lacus. Sed vehicula laoreet libero vitae vehicula. Suspendisse vitae bibendum ligula. Pellentesque rhoncus maximus erat id imperdiet. Integer eget nunc nec ipsum placerat fermentum ac eu neque. Vivamus accumsan augue a urna fringilla dapibus.";
    currentDateTime = DateTime.now();
    print(currentDateTime.toString());
    date = currentDateTime.day.toString() +
        "-" +
        currentDateTime.month.toString() +
        "-" +
        currentDateTime.year.toString();
    time = currentDateTime.hour.toString() +
        ":" +
        currentDateTime.minute.toString();
    titleController.text = "AllNotes " + currentDateTime.toUtc().toString();
    dbHelper = DbNotesHelper();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    arguments = ModalRoute.of(context).settings.arguments as Map<String,dynamic>;
    if(arguments!=null && arguments['note']!=null){
      Notes note =arguments['note'];
      titleController.text = note.title;
      bodyFieldController.text = note.data;
    }
  }

  void saveNote() {
    Function refreshList = arguments['refreshList'];
    if (titleController.text.trim().isEmpty) {
      showDialog(
          context: context,
          child: CupertinoAlertDialog(
            title: Text("Error"),
            content: Text("Title can't be Empty"),
            actions: <Widget>[
              CupertinoButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      titleAutoFocus = true;
                      bodyFieldAutoFocus = false;
                    });
                  })
            ],
          ));
      return;
    }
    Notes save = new Notes(
      id: currentDateTime,
      updatedOn: currentDateTime,
      createdOn: currentDateTime,
      title: titleController.text,
      data: bodyFieldController.text
    );
    dbHelper.insert(save);
    refreshList();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //Color of Back button
          ),
          backgroundColor: Colors.white, // color of App bar
          title: TextField(
            autofocus: titleAutoFocus,
            controller: titleController,
            maxLines: 1,
            decoration: InputDecoration(border: InputBorder.none),
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ),
        body: Card(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Date: " + date),
                  Text("Time: " + time),
                ],
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 50),
                  color: Colors.lightBlue[100],
                  child: TextField(
                    controller: bodyFieldController,
                    autofocus: bodyFieldAutoFocus,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(border: InputBorder.none),
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: saveNote,
          child: Icon(Icons.save),
        ),
      ),
    );
  }
}
