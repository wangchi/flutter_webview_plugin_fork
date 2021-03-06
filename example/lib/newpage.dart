import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/services.dart' show rootBundle;



class NewPage extends StatefulWidget {
  @override
  _PostViewState createState() => new _PostViewState();
}

class _PostViewState extends State<NewPage> {
  _PostViewState();

  String title = 'Post Message';
  BuildContext _ctx;

  final flutterWebViewPlugin = FlutterWebviewPlugin();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String htmlContent = '<h1>hello</h1>';
  var selectedUrl = 'https://www.baidu.com';

  Future<String> loadHTMLString() async {
    return await rootBundle.loadString('assets/index.html');
  }

  @override
  void initState() {
    super.initState();
//
//    loadHTMLString().then((value) {
//      setState(() {
//        htmlContent = value;
//      });
//    });

//    _webviewHandler();
  }

  _webviewHandler() {
    flutterWebViewPlugin.onStateChanged.listen((state) {
      if (state.type == WebViewState.finishLoad) {
        flutterWebViewPlugin.evalJavascript('test(\'mimimi\')').then((result) {
          print('---- insert result ----');
          print(result);
        });
      }
    });


    flutterWebViewPlugin.onWebviewMessage.listen((data) {
      print('---- ++++ -----');
      print(data);
      if (data.toString().indexOf('updateTitle') != -1) {
        print('update title');
        setState(() {
          title = 'title changed by h5';
        });
      }
      if (data.toString().indexOf('back') != -1) {
        print('back');
        Navigator.pop(_ctx);
      }
    });
  }

  @override
  void dispose() {
    flutterWebViewPlugin.show();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;

    flutterWebViewPlugin.hide();

    return Scaffold(
      appBar: AppBar(
        title: Text('TITLE')
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Text('111'),
        ),
      ),
    );

//    return WebviewScaffold(
//      url: selectedUrl,
////      url: new Uri.dataFromString(htmlContent, mimeType: 'text/html', encoding: utf8).toString(),
//      appBar: AppBar(
//        title: Text(title),
//      ),
//      withZoom: true,
//      withLocalStorage: true,
//      hidden: true,
//      initialChild: Container(
//        color: Colors.redAccent,
//        child: const Center(
//          child: Text('Waiting.....'),
//        ),
//      ),
//      bottomNavigationBar: BottomAppBar(
//        child: Row(
//          children: <Widget>[
//            IconButton(
//              icon: const Icon(Icons.arrow_back_ios),
//              onPressed: () {
//                flutterWebViewPlugin.goBack();
//              },
//            ),
//            IconButton(
//              icon: const Icon(Icons.arrow_forward_ios),
//              onPressed: () {
//                flutterWebViewPlugin.goForward();
//              },
//            ),
//            IconButton(
//              icon: const Icon(Icons.autorenew),
//              onPressed: () {
//                flutterWebViewPlugin.reload();
//              },
//            ),
//            IconButton(
//              icon: const Icon(Icons.plus_one),
//              onPressed: () {
//                flutterWebViewPlugin.postMessage('hello from flutter');
//              },
//            ),
//          ],
//        ),
//      ),
//    );
  }
}