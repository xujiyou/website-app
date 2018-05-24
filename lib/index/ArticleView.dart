import 'package:flutter/material.dart';
import "HomePage.dart";

class ArticleView extends StatefulWidget{

  Article entry;

  ArticleView(this.entry);

  @override
  State<StatefulWidget> createState() {
    return new _ArticleViewState(entry);
  }
}
class _ArticleViewState extends State<ArticleView>{

  Article entry;

  _ArticleViewState(this.entry);

  List<Widget> _contextView () {
    List<Container> list = new List();
    for (int i = 0; i < entry.context.length; i++) {
      String content = entry.context[i].replaceAll(" ", "").replaceAll("\t", "").replaceAll("\n", "").replaceAll("  ", "").replaceAll(" ", "");
      list.add(new Container(
        child: new Text("        " + content, style: new TextStyle(height: 1.6, fontSize: 16.0), textAlign: TextAlign.start),
        margin: new EdgeInsets.only(top: 8.0, bottom: 8.0),
        alignment: Alignment.topLeft
      ));
    }
    return list;
  }

  List<Widget> _imgView () {
    List<Container> list = new List();
    for (int i = 0; i < entry.imgurl.length; i++) {
      list.add(new Container(
          child: new Image(image: new NetworkImage(entry.imgurl[i])),
          margin: new EdgeInsets.only(top: 8.0, bottom: 8.0)
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("济宁学院-微官网 "),
        actions: <Widget>[
          new IconButton( // action button
            icon: new Icon(Icons.format_size, color: const Color(0xffdddddd)),
            onPressed: () => settingFont(),
          ),
        ],
      ),
      body: new SingleChildScrollView(
          child: new Container(
            child: new Column(
              children: <Widget>[
                new Container(
                  child: new Center(child: new Text(entry.title, textAlign: TextAlign.center, style: new TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold))),
                  margin: new EdgeInsets.only(top: 16.0, bottom: 16.0),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      child: new Text(entry.date, style: new TextStyle(fontSize: 14.0, color: const Color(0xff999999))),
                      padding: new EdgeInsets.only(right: 10.0),
                    ),
                    new Container(
                        child: new Text(entry.infoSource.length > 8 ? entry.infoSource.substring(0,8) : entry.infoSource, maxLines: 1, style: new TextStyle(fontSize: 14.0, color: const Color(0xff999999))),
                    ),
                  ],
                ),
                new Column(
                    children: _contextView()
                ),
                new Column(
                    children: _imgView()
                ),
                new Row(
                  children: <Widget>[
                    new Text(entry.author, textAlign: TextAlign.left, style: new TextStyle(fontSize: 14.0, color: const Color(0xff999999)))
                  ],
                )
              ],
            ),
            margin: new EdgeInsets.all(24.0),
            padding: new EdgeInsets.all(20.0),
            decoration: new BoxDecoration(
              color: Colors.white,
              //box-shadow: 0 2px 2px 0 rgba(0, 0, 0, 0.14), 0 3px 1px -2px rgba(0, 0, 0, 0.12), 0 1px 5px 0 rgba(0, 0, 0, 0.2);
              boxShadow: <BoxShadow>[
                new BoxShadow (
                    color: const Color(0x0e000000),
                    offset: new Offset(0.0, 2.0),
                    blurRadius: 2.0,
                    spreadRadius: 0.0
                ),
                new BoxShadow (
                    color: const Color(0x0c000000),
                    offset: new Offset(0.0, 3.0),
                    blurRadius: 1.0,
                    spreadRadius: -2.0
                ),
                new BoxShadow (
                    color: const Color(0x15000000),
                    offset: new Offset(0.0, 1.0),
                    blurRadius: 5.0,
                    spreadRadius: 0.0
                ),
              ],
            ),
          )
      )
    );
  }

  settingFont() {
    showModalBottomSheet<Null>(
      context:context,
      builder:(BuildContext context) {
        return new Container(
          child: new Padding(
            padding: const EdgeInsets.all(32.0),
            child: new Container(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      new Text("小"),
                      new IconButton( // action button
                        icon: new Icon(Icons.blur_circular, color: const Color(0xffdddddd)),
                        onPressed: (){},
                      ),
                    ],
                  ),
                  new Column(
                    children: <Widget>[
                      new Text("正常"),
                      new IconButton( // action button
                        icon: new Icon(Icons.blur_circular, color: const Color(0xffdddddd)),
                        onPressed: (){},
                      ),
                    ],
                  ),
                  new Column(
                    children: <Widget>[
                      new Text("大"),
                      new IconButton( // action button
                        icon: new Icon(Icons.blur_circular, color: const Color(0xffdddddd)),
                        onPressed: (){},
                      ),
                    ],
                  ),
                  new Column(
                    children: <Widget>[
                      new Text("特大"),
                      new IconButton( // action button
                        icon: new Icon(Icons.blur_circular, color: const Color(0xffdddddd)),
                        onPressed: (){},
                      ),
                    ],
                  ),
                ],
              ),
              height: 100.0,
            )
          )
        );
    });
  }
}