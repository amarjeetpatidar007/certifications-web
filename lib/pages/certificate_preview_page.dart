import 'dart:html';
import 'dart:ui' as ui;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../provider/certification_provider.dart';

class IframeScreen extends StatefulWidget {
  final String url;

  const IframeScreen({super.key, required this.url});

  @override
  State<IframeScreen> createState() => _IframeScreenState();
}

class _IframeScreenState extends State<IframeScreen> {
  late final IFrameElement _iFrameElement;

  @override
  void initState() {
    super.initState();

    _iFrameElement = IFrameElement()
      ..style.height = '100%'
      ..style.width = '100%'
      ..src = widget.url
      ..style.border = 'none'
      ..style.boxShadow = '0 4px 8px rgba(0, 0, 0, 0.2)'
      ..style.borderRadius = '10px';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => _iFrameElement,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificate Preview'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: HtmlElementView(
              viewType: 'iframeElement',
              key: UniqueKey(),
            ),
          ),
        ),
      ),
    );
  }
}
