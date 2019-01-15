import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_webview_plugin_example/newpage.dart';



class PostView extends StatefulWidget {
  @override
  _PostViewState createState() => new _PostViewState();
}

class _PostViewState extends State<PostView> {
  _PostViewState();

  String title = 'Post Message';
  BuildContext _ctx;

  final flutterWebViewPlugin = FlutterWebviewPlugin();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  StreamSubscription<String> _onWebviewMessaged;

  String htmlContent = '<h1>hello</h1>';
  var selectedUrl = 'https://www.baidu.com';

  Future<String> loadHTMLString() async {
    return await rootBundle.loadString('assets/index.html');
  }

  @override
  void initState() {
    super.initState();

    loadHTMLString().then((value) {
      setState(() {
        htmlContent = value;
      });
    });

    _webviewHandler();
  }

  _webviewHandler() {
    flutterWebViewPlugin.onStateChanged.listen((state) {
      print(state.type);
      if (state.type == WebViewState.finishLoad) {
        flutterWebViewPlugin.evalJavascript('test(\'mimimi\')').then((result) {
          print('---- insert result ----');
          print(result);
        });
      }
    });

    _onWebviewMessaged = flutterWebViewPlugin.onWebviewMessage.listen((data) {
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
      if (data.toString().indexOf('go') != -1) {
        print('go');
//        flutterWebViewPlugin.hide();
        Navigator.of(_ctx).push(MaterialPageRoute(
            builder: (context) => NewPage()
        )).then((res) {
//          flutterWebViewPlugin.show();
        });
      }
    });
  }

  @override
  void dispose() {
    _onWebviewMessaged.cancel();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;

    print('++++++++ render');
//    flutterWebViewPlugin.show();

    var viewInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    print(viewInsetsBottom);

    return WebviewScaffold(
//      url: selectedUrl,
      url: new Uri.dataFromString(htmlContent, mimeType: 'text/html', encoding: utf8).toString(),
      appBar: AppBar(
        title: Text(title),
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      initialChild: Container(
        color: Colors.white,
        child: const Center(
          child: Text('Waiting.....'),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: viewInsetsBottom),
        width: double.infinity,
        height: 44.0 + viewInsetsBottom,
        color: Colors.black12,
        child: TextField(
          decoration: InputDecoration(
            hintText: 'input something...'
          ),
        )
      ),
//      bottomNavigationBar: bottomButtons(),
    );
  }

  Widget bottomButtons() {
    return BottomAppBar(
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              flutterWebViewPlugin.goBack();
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              flutterWebViewPlugin.goForward();
            },
          ),
          IconButton(
            icon: const Icon(Icons.autorenew),
            onPressed: () {
              flutterWebViewPlugin.reload();
            },
          ),
          IconButton(
            icon: const Icon(Icons.plus_one),
            onPressed: () {
              flutterWebViewPlugin.postMessage('hello from flutter');
            },
          ),
        ],
      ),
    );
  }
}