import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HtmlView extends StatefulWidget {
  final AdViewModel model;

  HtmlView({Key key, @required this.model}) : super(key: key);

  @override
  _HtmlViewState createState() => _HtmlViewState();
}

class _HtmlViewState extends State<HtmlView> {
  final _controller = Completer<WebViewController>();

  @override
  void initState() {
    _controller.future.then((webViewController) {
      return webViewController.loadUrl(
        Uri.directory(widget.model.filePath).toString(),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'about:blank',
      onWebViewCreated: (WebViewController webViewController) {
        if (!_controller.isCompleted) _controller.complete(webViewController);
      },
    );
  }
}
