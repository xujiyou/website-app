import 'package:flutter/material.dart';

import 'index/HomePage.dart';
import 'index/ArticleView.dart';

void main() => runApp(new WebSite());

class WebSite extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: '济宁学院-微官网',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new HomePage()
    );
  }
}

