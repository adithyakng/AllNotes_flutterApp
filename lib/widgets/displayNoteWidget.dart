import 'package:AllNote/models/notes.dart';
import 'package:flutter/material.dart';

class DisplayNote extends StatelessWidget {
  final Notes _note;

  DisplayNote(this._note);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Card(
        color: Colors.pink[100],
        elevation: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 50,
              color: Colors.white,
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 4,
                    child: Text(
                      _note.title,
                      style: TextStyle(fontSize: 23, color: Colors.pink),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Text(
                      _note.createdOn.toString(),
                      style: TextStyle(fontSize: 15, color: Colors.pink),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Flexible(
                      flex: 1,
                      child: PopupMenuButton(
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.pink,
                          ),
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                child: ListTile(
                                  leading: Icon(
                                    Icons.edit,
                                    color: Colors.pink,
                                  ),
                                  title: Text('Edit'),
                                ),
                              ),
                              PopupMenuItem(
                                child: ListTile(
                                  leading: Icon(
                                    Icons.delete_forever,
                                    color: Colors.pink,
                                  ),
                                  title: Text('Delete'),
                                ),
                              ),
                              PopupMenuItem(
                                child: ListTile(
                                  leading: Icon(
                                    Icons.share,
                                    color: Colors.pink,
                                  ),
                                  title: Text('Share'),
                                ),
                              ),
                            ];
                          })),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                _note.data,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
