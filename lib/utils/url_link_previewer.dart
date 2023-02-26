import 'package:flutter/material.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';


class UrlLinkPreviewer extends StatefulWidget {
  String link;
   UrlLinkPreviewer(this.link, {super.key});

  @override
  State<UrlLinkPreviewer> createState() => _UrlLinkPreviewerState();
}

class _UrlLinkPreviewerState extends State<UrlLinkPreviewer> {
  var _previewData;
  @override
  Widget build(BuildContext context) {
    return LinkPreview(
      enableAnimation: true,
      onPreviewDataFetched: (data) {
        setState(() {
         _previewData = data;
        });
      },
      previewData: _previewData, // Pass the preview data from the state
      text: widget.link,
      width: MediaQuery.of(context).size.width,
    );
  }
}
