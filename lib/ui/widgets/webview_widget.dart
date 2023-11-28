import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../constant/app_strings.dart';

class WebViewPage extends StatefulWidget {
  String bannerDetailUrl;
  var bannerName;

  WebViewPage(this.bannerDetailUrl, this.bannerName);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.bannerDetailUrl.isEmpty ? AppStrings.GITHUB : widget.bannerDetailUrl));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bannerName),
        centerTitle: true,
      ),
      body: WebViewWidget(
        controller: _controller,

      ),
    );
  }
}
