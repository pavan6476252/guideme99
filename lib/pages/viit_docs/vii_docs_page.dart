// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:code/services/subjects_api_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class ViitDocsPage extends StatefulWidget {
  @override
  _ViitDocsPageState createState() => _ViitDocsPageState();
}

class _ViitDocsPageState extends State<ViitDocsPage> {
  final List<Map<String, String>> items = [
    {"title": "1st Yeart", "url": ""},
    {
      "title": "Cse / it",
      "url": "https://pavan72362.github.io/viit/cs_it_aids_ai.json"
    },
    {"title": "EEE", "url": ""},
    {"title": "ECE", "url": ""},
    {"title": "CHEMICAL", "url": ""},
    {"title": "CIVIL", "url": ""},
    {"title": "Mech", "url": ""},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Viit'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(items[index]['title'] ?? "unknown"),
              onTap: () {
                if (items[index]['url'] == "") {
                  Fluttertoast.showToast(
                      msg: "Files are not added at",
                      backgroundColor: const Color.fromARGB(255, 250, 151, 140));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubjectsListPage(
                            url: items[index]['url'] ?? "",
                            title: items[index]['title'] ?? "unkown"),
                      ));
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class SubjectsListPage extends StatefulWidget {
  String? url;
  String title;
  SubjectsListPage({
    Key? key,
    required this.url,
    required this.title,
  }) : super(key: key);
  @override
  _SubjectsListPageState createState() => _SubjectsListPageState();
}

class _SubjectsListPageState extends State<SubjectsListPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshsubjectsList();
  }

  bool isLoading = true;
  final SubjectApiService subjectApiService = SubjectApiService();
  Map<String, SubjectService>? subjectsList;

  Future<void> _refreshsubjectsList() async {
    try {
      final subjectsList =
          await subjectApiService.getSubjects(context, widget.url!);
      this.subjectsList = subjectsList;
      setState(() {});
    } catch (e) {
      // print(e);

      isLoading = false;
      setState(() {});
    }
  }

  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    // print(subjectsList[1].title);
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.title}  docs'),
        ),
        body: subjectsList != null
            ? Scrollbar(
                interactive: true,
                controller: scrollController,
                child: ListView.builder(
                    controller: scrollController,
                    itemCount: subjectsList!.length,
                    itemBuilder: (context, index) {
                      final key = subjectsList!.keys.elementAt(index);
                      final item = subjectsList![key];
                      return Card(
                        child: GestureDetector(
                          onTap: () {
                            item.url == null
                                ? Fluttertoast.showToast(
                                    msg: "Opps link not found")
                                : launchUrl(Uri.parse(item.url ?? ""),
                                    mode: LaunchMode.externalApplication);
                          },
                          child: ListTile(title: Text(item!.title)),
                        ),
                      );
                    }),
              )
            : Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : OutlinedButton.icon(
                        icon: Icon(Icons.refresh_rounded),
                        onPressed: () => _refreshsubjectsList(),
                        label: Text("ReLoad"))));
  }
}
