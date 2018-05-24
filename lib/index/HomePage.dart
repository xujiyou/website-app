import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'ArticleView.dart';
import 'SearchPage.dart';

class Article {
  String tagID;
  String id;
  String title;
  String date;
  String infoSource;
  List<String> context;
  List<String> imgurl;
  String author;

  Article (this.tagID, this.id, this.title, this.date, this.infoSource, this.context, this.imgurl, this.author);
  factory Article.formjosn(Map<String, dynamic> map) {
    return new Article(map["tagId"], map["Id"], map["Title"], map["Date"], map["InfoSource"], map["Context"], map["ImgUrl"], map["Author"]);
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {

  Map<String, List<EntryItem>> _entryMap = {"1021": new List(), "1022": new List(), "1129": new List()};
  Map<String, Map<String, int>> _numMap = {"1021": {"skip": 0, "count": 0}, "1022": {"skip": 0, "count": 0}, "1129": {"skip": 0, "count": 0}};
  final TextEditingController _textController = new TextEditingController();
  bool start = true;
  bool load = false;

  init () {
    getArticles("1021").then((list) => setState(() => _entryMap["1021"].addAll(list)));
    getArticles("1022").then((list) => setState(() => _entryMap["1022"].addAll(list)));
    getArticles("1129").then((list) => setState((){
      _entryMap["1129"].addAll(list);
      start = false;
    }));
    initArticleNum("1021");
    initArticleNum("1022");
    initArticleNum("1129");
  }

  initArticleNum(String id) async {
    var response = await http.get("http://xszhfw.jnxy.edu.cn:2122/article/tag/count/" + id);
    _numMap[id]["count"] = int.parse(response.body);
  }

  Future<List<EntryItem>> getArticles(String id) async {
    List<EntryItem> entryList = new List();
    var response = await http.post("http://xszhfw.jnxy.edu.cn:2122/article/findTag",
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {"skip": _numMap[id]["skip"].toString(), "limit": "10", "TagId": id});
    for (Map map in jsonDecode(response.body)) {
      entryList.add(new EntryItem(new Article.formjosn(map)));
    }
    return entryList;
  }

  @override
  Widget build(BuildContext context) {
    if (start) {
      init();
    }
    return new MaterialApp(
      home: new DefaultTabController(
        length: 3,
        child: new Scaffold(
          appBar: new AppBar(
            title: new Container(
              child: new TextField(
                decoration: new InputDecoration.collapsed(
                  hintText: '搜索...',
                  hintStyle: new TextStyle(color: const Color(0xffdddddd)),
                ),
                style: new TextStyle(
                  color: const Color(0xffffffff),
                  fontSize: 16.0
                ),
                controller: _textController,
                onSubmitted: _handleSubmitted,
              ),
              color: const Color(0xff5B98FF),
              padding: new EdgeInsets.only(top:6.0, bottom: 6.0, left: 6.0, right: 6.0),
            ),
            actions: <Widget>[
              new IconButton( // action button
                icon: new Icon(Icons.search, color: const Color(0xffdddddd)),
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            ],
            bottom: new TabBar(
              tabs: [
                new Tab(icon: new Icon(Icons.book), text: "学院要闻"),
                new Tab(icon: new Icon(Icons.phone_missed), text: "通知公告"),
                new Tab(icon: new Icon(Icons.all_inclusive), text: "学术动态"),
              ],
            ),
          ),
          body: new TabBarView(
            children: [
              buildListView("1021"),
              buildListView("1022"),
              buildListView("1129")
            ]
          ),
        ),
      ),
    );
  }

  Widget buildListView(String id) {
    if (start) {
      return showLoad();
    }
    return new ListView.builder(
        padding: new EdgeInsets.all(16.0),
        itemCount: _entryMap[id].length * 2 + 1,
        itemBuilder: (BuildContext context, int index){
          if (index.isOdd) {
            return new Divider();
          }
          final i = index ~/ 2;
          if (i >= _entryMap[id].length) {
            if (load) {
              return new ListTile(title: showLoad());
            } else if (load == false && _numMap[id]["skip"] + 10 < _numMap[id]["count"]) {
              return new ListTile(
                  title: new Center(
                      child: new FlatButton(
                        child: new Text("加载更多"),
                        onPressed: () => loadMore(id),
                        textTheme: ButtonTextTheme.primary,
                      )
                  )
              );
            } else if (load == false && _numMap[id]["skip"] + 10 >= _numMap[id]["count"]){
              return new ListTile(title: new Center(child: new Text("没有更多了", style: new TextStyle(color: const Color(0xff999999), fontSize: 14.0))));
            }
          } else {
            return _entryMap[id][i];  //显示标题
          }
        },
    );
  }

  loadMore(String id) {
    setState(() => load = true);
    _numMap[id]["skip"] += 10;
    getArticles(id).then((list) => setState((){
      _entryMap[id].addAll(list);
      load = false;
    })
    );
  }

  void _handleSubmitted(String text) {
    if (text != "") {
      print(text);
      Navigator.of(context).push(
        new MaterialPageRoute(
          builder: (context) {
            return new SearchPage(text);
          },
        ),
      );
    }
    _textController.clear();
  }

  alert(String text) {
    showDialog<Null>(
        context: context,
        child: new AlertDialog(
            content: new Text("没有关于\"" + text + "\"的文章"),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text('确定')
              )
            ]
        )
    );
  }

  Widget showLoad () {
    return new Container(
      child: new CircularProgressIndicator(),
      width: 60.0,
      height: 60.0,
      alignment: Alignment.center,
    );
  }
}

class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Article entry;

  @override
  Widget build(BuildContext context) {
    String rowTitle = "";
    if (entry.title.length > 25) {
      rowTitle = entry.title.substring(0, 25) + "...";
    } else {
      rowTitle = entry.title;
    }
    return new ListTile(
      title: new Row(
        children: <Widget>[
          new Container(
            child: new Text(entry.date.split("-")[1] + "-" + entry.date.split("-")[2]),
            margin: new EdgeInsets.only(right: 16.0),
          ),
          new Expanded(
            child: new Text(rowTitle),
          )
        ],
      ),
      onTap: (){
        Navigator.of(context).push(
          new MaterialPageRoute(
            builder: (context) {
              return new ArticleView(entry);
            },
          ),
        );
      },
    );
  }

}



//  FutureBuilder<List<Article>> buildFromHttp(String id) {
//    return new FutureBuilder<List<Article>>(
//      future: getArticles(id), // 用户定义的需要异步执行的代码，类型为Future<String>或者null的变量或函数
//      builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {      //snapshot就是_calculation在时间轴上执行过程的状态快照
//        switch (snapshot.connectionState) {
//          case ConnectionState.none: return new Text('Press button to start');    //如果_calculation未执行则提示：请点击开始
//          case ConnectionState.waiting: return new Text('Awaiting result...');  //如果_calculation正在执行则提示：加载中
//          default:    //如果_calculation执行完毕
//            if (snapshot.hasError) {
//              return new Text('Error: ${snapshot.error}');
//            } else {
//              for (int i = 0; i < _map[id].length; i++) {
//                _entryMap[id].add(new EntryItem(_map[id][i]));
//              }
//              return buildListView(id);
//            }
//        }
//      },
//    );
//  }