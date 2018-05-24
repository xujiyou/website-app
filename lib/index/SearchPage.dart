import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import "HomePage.dart";

class SearchPage extends StatefulWidget{

  String text;

  SearchPage(this.text);

  @override
  State<StatefulWidget> createState() {
    return new _SearchPageState(text);
  }
}
class _SearchPageState extends State<SearchPage>{

  String text;
  bool start = true;
  bool empty = false;
  List<Article> articleList = new List();

  _SearchPageState(this.text);

  @override
  Widget build(BuildContext context) {
    if (start) {
      init();
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("济宁学院-微官网 "),
      ),
      body: buildList()
    );
  }

  init() {
    searchArticle(text).then((list){
      if (list == null) {
        empty = true;
      }
      articleList = list;
      start = false;
      setState((){});
    });
  }

  Future<List<Article>> searchArticle(String searchDate) async {
    List<Article> articleList = new List();
    var response = await http.get("http://xszhfw.jnxy.edu.cn:2122/article/regex/find/" + searchDate);
    var maps = jsonDecode(response.body);
    if (maps == null) {
      return null;
    } else {
      for (Map map in maps) {
        articleList.add(new Article.formjosn(map));
      }
    }
    return articleList;
  }

  Widget buildList() {
    if (start) {
      return showLoad();
    } else if (empty){
      return new Container(
        child: new Text("没有关于\"" + text + "\"的文章"),
        alignment: Alignment.center,
      );
    } else{
      return new ListView.builder(
          padding: new EdgeInsets.all(16.0),
          itemCount: articleList.length * 2,
          itemBuilder: (BuildContext context, int index) {
            if (index.isOdd) {
              return new Divider();
            }
            final i = index ~/ 2;
            return new EntryItem(articleList[i]);
          }
      );
    }
  }

  Widget showLoad () {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              child: new CircularProgressIndicator(),
              width: 60.0,
              height: 60.0,
              alignment: Alignment.center,
            )
          ],
        )
      ],
    );
  }

}