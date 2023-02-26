// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:code/utils/cached_netwok_image_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_markdown_editor/widgets/markdown_parse.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({super.key});

  @override
  _FeedsScreenState createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'Home'),
                Tab(text: 'For You'),
              ],
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              const HomeFeedsScreen(),
              const ForYouScreen(),
            ],
          ),
        ),
      ],
    );
  }
}

class Blog {
  final String blogId;
  final String title;
  final String image;
  final String authorName;
  final String authorPic;
  final String authorId;
  final String date;
  final String body;
  // final List<String> hashTags;

  Blog({
    required this.blogId,
    required this.title,
    required this.image,
    required this.authorName,
    required this.authorId,
    required this.authorPic,
    required this.date,
    required this.body,
    // required this.hashTags,
  });
}

class ForYouScreen extends StatelessWidget {
  const ForYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('blogs').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        List<Blog> blogs = [];
        for (var doc in snapshot.data!.docs) {
          String blogId = doc.id;
          String title = doc['title'];
          String image = doc['image'];
          String authorName = doc['authorName'];
          String authorPic = doc['authorProfile'];
          String authorId = doc['authorId'];
          DateTime date = doc['date'].toDate();
          String body = doc['body'];
          // List<String> hashTags = doc['hashTags'].map((e) => e.toString()).toList();
          blogs.add(Blog(
            blogId: blogId,
            title: title,
            image: image,
            authorName: authorName,
            authorId: authorId,
            authorPic: authorPic,
            date: "${date.day}/${date.month}/${date.year}",
            body: body,
            // hashTags: hashTags,
          ));
        }
        return ListView.builder(
          itemCount: blogs.length,
          itemBuilder: (context, index) {
            return BlogCard(myBlog: blogs[index]);
          },
        );
      },
    );
  }
}

class BlogCard extends StatefulWidget {
  Blog myBlog;

  BlogCard({
    Key? key,
    required this.myBlog,
  }) : super(key: key);

  @override
  State<BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _loadLikedStatus();
  }

  void _toggleLiked() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool liked = prefs.getBool("_like_blog${widget.myBlog.blogId}") ?? false;

    if (!liked) {
      _saveBlog();
    } else {
      _unSaveBlog();
    }

    setState(() {
      _isLiked = !liked;
    });
    await prefs.setBool("_like_blog${widget.myBlog.blogId}", _isLiked);
  }

  void _loadLikedStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool liked = prefs.getBool("_like_blog${widget.myBlog.blogId}") ?? false;
    setState(() {
      _isLiked = liked;
    });
  }

  void _unSaveBlog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String blogKey = "saved_blog${widget.myBlog.blogId}";
      prefs.remove(blogKey);
   
  }

  void _saveBlog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String blogJson = json.encode({
      'blogId': "_like_blog${widget.myBlog.blogId}",
      'title': widget.myBlog.title,
      'image': widget.myBlog.image,
      'authorName': widget.myBlog.authorName,
      'authorId': widget.myBlog.authorId,
      'authorPic': widget.myBlog.authorPic,
      'date': widget.myBlog.date,
      'body': widget.myBlog.body,
      // 'hashTags': widget.myBlog.hashTags
    });
    await prefs.setString("saved_blog${widget.myBlog.blogId}", blogJson);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(widget.myBlog.authorId),
            // Text(widget.myBlog.hashTags.toString()),
            // Text("_like_blog${widget.myBlog.blogId}"),
            SizedBox(
              width: double.maxFinite,
              height: 200,
              child: getCachedNetworkImage(
                  widget.myBlog.image, BoxShape.rectangle),
            ),
            const SizedBox(height: 5),
            Text(widget.myBlog.title,
                maxLines: 2,
                style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400)),
            // Text(widget.myBlog.body),
            // Container(
            //   height: 500,width: double.maxFinite,
            //   child: MarkdownParse(
            //     data: widget.myBlog.body,
            //   ),
            // ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 5),
                    SizedBox(
                        width: 30,
                        height: 30,
                        child: getCachedNetworkImage(
                            widget.myBlog.authorPic, BoxShape.circle)),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.myBlog.authorName),
                        Text("On : ${widget.myBlog.date}")
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(_isLiked
                      ? Icons.bookmark_outlined
                      : Icons.bookmark_border_rounded),
                  onPressed: () {
                    _toggleLiked();
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HomeFeedsScreen extends StatelessWidget {
  const HomeFeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var u =
        "https://t3.ftcdn.net/jpg/02/48/42/64/240_F_248426448_NVKLywWqArG2ADUxDq6QprtIzsF82dMF.jpg";
    return Center(
      child: Card(
        child: Column(
          children: [
            getCachedNetworkImage(u, BoxShape.rectangle),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  SizedBox(
                      width: 35,
                      child: getCachedNetworkImage(u, BoxShape.circle)),
                  const SizedBox(width: 10),
                  const Text("Pavan kumar")
                ]),
                const Text("🔴 mon-02-2023")
              ],
            )
          ],
        ),
      ),
    );
  }
}
