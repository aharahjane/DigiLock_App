// lib/screens/content_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContentDetailScreen extends StatefulWidget {
  final String fileUrl;
  final String contentType;

  const ContentDetailScreen({
    super.key,
    required this.fileUrl,
    required this.contentType,
  });

  @override
  State<ContentDetailScreen> createState() => _ContentDetailScreenState();
}

class _ContentDetailScreenState extends State<ContentDetailScreen> {
  VideoPlayerController? _videoController;
  WebViewController? _webController;

  @override
  void initState() {
    super.initState();
    if (widget.contentType == 'Videos') {
      _videoController = VideoPlayerController.network(widget.fileUrl);
      _videoController!.initialize().then((_) {
        setState(() {});
        _videoController!.play();
      });
    } else if (widget.contentType == 'Literature') {
      _webController =
          WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..loadRequest(Uri.parse(widget.fileUrl));
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C1C30),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'DigiLock',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: () {
          switch (widget.contentType) {
            case 'Literature':
              return _webController != null
                  ? WebViewWidget(controller: _webController!)
                  : const CircularProgressIndicator(color: Colors.white);

            case 'Photos':
              return InteractiveViewer(
                child: Image.network(widget.fileUrl, fit: BoxFit.contain),
              );

            case 'Videos':
              if (_videoController != null &&
                  _videoController!.value.isInitialized) {
                return AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  child: VideoPlayer(_videoController!),
                );
              } else {
                return const CircularProgressIndicator(color: Colors.white);
              }

            default:
              return const Text(
                'Unsupported format',
                style: TextStyle(color: Colors.white),
              );
          }
        }(),
      ),
    );
  }
}
