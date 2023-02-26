import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_markdown_editor/widgets/markdown_parse.dart';

import '../../utils/cached_netwok_image_loader.dart';
import 'main/main_screen.dart';

class BlogViewerScreen extends StatefulWidget {
  Blog? myBlog;

  BlogViewerScreen({
    Key? key,
    this.myBlog,
  }) : super(key: key);

  @override
  State<BlogViewerScreen> createState() => _BlogViewerScreenState();
}

class _BlogViewerScreenState extends State<BlogViewerScreen> {

  @override
  void initState() {
    super.initState();
    _loadLikedStatus();
  }

  bool? _isLiked;
  void _toggleLiked() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool liked = prefs.getBool("_like_blog${widget.myBlog!.blogId}") ?? false;

    if (!liked) {
      _saveBlog();
    } else {
      _unSaveBlog();
    }

    setState(() {
      _isLiked = !liked;
    });
    await prefs.setBool("_like_blog${widget.myBlog!.blogId}", _isLiked!);
  }

  void _loadLikedStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool liked = prefs.getBool("_like_blog${widget.myBlog!.blogId}") ?? false;
    setState(() {
      _isLiked = liked;
    });
  }

  void _unSaveBlog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String blogKey = "saved_blog${widget.myBlog!.blogId}";
    prefs.remove(blogKey);
  }

  void _saveBlog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String blogJson = json.encode({
      'blogId': "_like_blog${widget.myBlog!.blogId}",
      'title': widget.myBlog!.title,
      'image': widget.myBlog!.image,
      'authorName': widget.myBlog!.authorName,
      'authorId': widget.myBlog!.authorId,
      'authorPic': widget.myBlog!.authorPic,
      'date': widget.myBlog!.date,
      'body': widget.myBlog!.body,
      // 'hashTags': widget.myBlog.hashTags
    });
    await prefs.setString("saved_blog${widget.myBlog!.blogId}", blogJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottomOpacity: 0.8,
        actions: [
          IconButton(
            icon: Icon(_isLiked!
                ? Icons.bookmark_outlined
                : Icons.bookmark_border_rounded),
            onPressed: () {
              _toggleLiked();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: SizedBox(
                width: double.maxFinite,
                height: 200,
                child: getCachedNetworkImage(
                    widget.myBlog!.image, BoxShape.rectangle),
              ),
            ),
            const SizedBox(height: 5),
            Text(widget.myBlog!.title,
                maxLines: 2,
                style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w400)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                            width: 30,
                            height: 30,
                            child: getCachedNetworkImage(
                                widget.myBlog!.authorPic, BoxShape.circle)),
                        Text(widget.myBlog!.authorName),
                      ],
                    ),
                    Text(" ${widget.myBlog!.date}")
                  ],
                ),
              ],
            ),
            MarkdownParse(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              data: widget.myBlog!.body,
            )
          ],
        ),
      ),
    );
  }
}
