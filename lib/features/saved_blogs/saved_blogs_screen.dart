import 'dart:convert';

import 'package:code/features/home/main/main_screen.dart';
import 'package:code/utils/cached_netwok_image_loader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_markdown_editor/widgets/markdown_parse.dart';

import '../home/blog_viewer.dart';

class SavedBlogsScreen extends StatefulWidget {
  const SavedBlogsScreen({super.key});

  @override
  _SavedBlogsScreenState createState() => _SavedBlogsScreenState();
}

class _SavedBlogsScreenState extends State<SavedBlogsScreen> {
  List<Blog> _blogs = [];

  @override
  void initState() {
    super.initState();
    _loadSavedBlogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Blogs'),
      ),
      body: _blogs.isEmpty
          ? const Center(
              child: Text('No saved blogs'),
            )
          : ListView.builder(
              itemCount: _blogs.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder:(context) => BlogViewerScreen(myBlog: _blogs[index]),)),
                  child: Card(
                      child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      isThreeLine: true,
                      leading: SizedBox(
                        height: 80,
                        width: 100,
                        child: getCachedNetworkImage(
                            _blogs[index].image, BoxShape.rectangle),
                      ),
                      title: Text(_blogs[index].title, maxLines: 2,style: const TextStyle(overflow: TextOverflow.ellipsis),),
                      subtitle:Text( "${_blogs[index].authorName} on ${_blogs[index].date}") ,
                    ),
                  )),
                );
              },
            ),
    );
  }

  void _loadSavedBlogs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();

    for (String key in keys) {
      if (!key.startsWith('saved_blog')) {
        continue;
      }
      String? blogJson = prefs.getString(key);
      // print(blogJson);

      Map<String, dynamic> blog = await json.decode(blogJson!);
      Blog tempBlog = Blog(
          blogId: blog['blogId'] ?? '',
          title: blog['title'] ?? '',
          image: blog['image'] ?? '',
          authorName: blog['authorName'] ?? '',
          authorId: blog['authorId'] ?? '',
          authorPic: blog['authorPic'] ?? '',
          date: blog['date'] ?? '',
          body: blog['body'] ?? '');
      _blogs.add(tempBlog);
    }
    setState(() {});
  }

  void _removeBlog(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String blogKey = 'saved_blog${_blogs[index].blogId}';
    prefs.remove(blogKey);
    setState(() {
      _blogs.removeAt(index);
    });
  }
}
