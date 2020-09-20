import 'package:AllNote/databases/dbNotesHelper.dart';
import 'package:AllNote/screens/addNote.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/showNotes.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(AllNote());
}

class AllNote extends StatefulWidget {
  @override
  _AllNoteState createState() => _AllNoteState();
}

class _AllNoteState extends State<AllNote> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DbNotesHelper(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ShowNotes(),
        routes: {
          "/addNotes": (context) {
            return AddNote();
          },
        },
        title: "AllNotes",
      ),
    );
  }
}
