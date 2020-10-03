import 'package:AllNote/databases/dbNotesHelper.dart';
import 'package:AllNote/widgets/displayNoteWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/notes.dart';
import 'package:share/share.dart';

class ShowNotes extends StatefulWidget {
  @override
  _ShowNotesState createState() => _ShowNotesState();
}

class _ShowNotesState extends State<ShowNotes> {
  Future<List<Notes>> allnotes;
  DbNotesHelper dbNotesHelper;

  bool mainScreen = true;

  FutureBuilder homeBuilder() {
    return FutureBuilder(
        future: allnotes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0) {
              return Center(
                child: mainScreen
                    ? Text('Click on + to add a Note')
                    : Text("Double click on card to make it favourite"),
              );
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/addNotes", arguments: {
                      'note': snapshot.data[index],
                      'mainScreen': mainScreen
                    });
                  },
                  onLongPress: () {
                    deleteWithNotification(snapshot.data[index]);
                  },
                  onDoubleTap: () {
                    // shareNote(snapshot.data[index]);
                    changeFavourite(snapshot.data[index], context);
                  },
                  child: DisplayNote(
                    snapshot.data[index],
                  ),
                );
              },
              itemCount: snapshot.data.length,
            );
          } else {
            return Center(
              child: Text('Loading'),
            );
          }
        });
  }

  changeFavourite(Notes note, BuildContext context) async {
    var k = await dbNotesHelper.toggleFavourite(note);
    k == 1
        ? showMessage("Added to Favourites", context)
        : showMessage("Removed from Favourites", context);
    if (!mainScreen) {
      setState(() {
        allnotes = dbNotesHelper.getAllFavouriteNotes();
      });
    }
  }

  refreshList() {
    setState(() {
      allnotes = dbNotesHelper.getAllNotes();
    });
  }

  deleteWithNotification(Notes note) async {
    bool value = await showDialog(
        context: context,
        child: CupertinoAlertDialog(
          title: Text("Alert! "),
          content: Text('Are you sure you want to delete? '),
          actions: <Widget>[
            CupertinoButton(
                child: Text('Yes'),
                onPressed: () {
                  return Navigator.pop(context, true);
                }),
            CupertinoButton(
                child: Text('No'),
                onPressed: () {
                  return Navigator.pop(context, false);
                })
          ],
        ));
    if (value) {
      dbNotesHelper.delete(note);
      refreshList();
    }
  }

  shareNote(Notes note) {
    Share.share(note.data, subject: note.title);
  }

  void showMessage(String msg, BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: Duration(
          seconds: 1,
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    dbNotesHelper = Provider.of<DbNotesHelper>(context, listen: false);
    refreshList();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: homeBuilder(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink,
          onPressed: () async{
            dynamic result = await Navigator.pushNamed(context, "/addNotes", arguments: {
              'refreshList': refreshList,
              'mainScreen': mainScreen
            });
            if(result.toInt() == 1){
              setState(() {
                mainScreen = false;
                allnotes = dbNotesHelper.getAllFavouriteNotes();
              });
            }

          },
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.home,
                    size: 40,
                    color: Colors.pink,
                  ),
                  onPressed: () {
                    setState(() {
                      mainScreen = true;
                      allnotes = dbNotesHelper.getAllNotes();
                    });
                  }),
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  size: 40,
                  color: Colors.pink,
                ),
                onPressed: () {
                  setState(() {
                    mainScreen = false;
                    allnotes =
                        dbNotesHelper.getAllFavouriteNotes(favourites: 1);
                  });
                },
              ),
            ],
          ),
          elevation: 20,
        ),
      ),
    );
  }
}
