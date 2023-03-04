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
    {"title": "1st Yeart", "url": "https://pavan72362.github.io/viit/1_st_year.json"},
    {
      "title": "Cse / it / Ai / Ai & Ds",
      "url": "https://pavan72362.github.io/viit/cs_it_aids_ai.json"
    },
    {"title": "EEE", "url": "https://pavan72362.github.io/viit/eee.json"},
    {"title": "ECE", "url": "https://pavan72362.github.io/viit/ece.json"},
    {
      "title": "CHEMICAL",
      "url": "https://pavan72362.github.io/viit/chemical.json"
    },
    {"title": "CIVIL", "url": "https://pavan72362.github.io/viit/civil.json"},
    {"title": "Mech", "url": "https://pavan72362.github.io/viit/mech.json"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Viit B.Tech Docs'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(items[index]['title']!.toUpperCase()),
                    onTap: () {
                      if (items[index]['url'] == "") {
                        Fluttertoast.showToast(
                            msg: "Files are not added at",
                            backgroundColor:
                                const Color.fromARGB(255, 250, 151, 140));
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
            const SizedBox(height: 10),
            GestureDetector(
                onTap: () => launchUrl(
                    Uri.parse("https://pavan6476252.github.io/"),
                    mode: LaunchMode.externalApplication),
                child: const Text("Made with ♥ by Pavan kumar")),
            const SizedBox(height: 20),
          ],
        ),
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
          actions: <Widget>[
            isLoading
                ? IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      showSearch(
                          context: context, delegate: DataSearch(subjectsList));
                    },
                  )
                : const SizedBox()
          ],
        ),
        body: subjectsList != null
            ? Scrollbar(
                interactive: true,
                controller: scrollController,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
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
                      SizedBox(height: 10),
                      GestureDetector(
                          onTap: () => launchUrl(
                              Uri.parse("https://pavan6476252.github.io/"),
                              mode: LaunchMode.externalApplication),
                          child: const Text("Made with ♥ by Pavan kumar")),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              )
            : Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : OutlinedButton.icon(
                        icon: const Icon(Icons.refresh_rounded),
                        onPressed: () => _refreshsubjectsList(),
                        label: const Text("ReLoad"))));
  }
}

class DataSearch extends SearchDelegate<String> {
  Map<String, SubjectService>? data;

  DataSearch(this.data);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text('No results found for "$query"'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? data!.values.toList()
        : data!.values
            .where((item) =>
                item.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (BuildContext context, int index) {
        final item = suggestionList[index];
        return Card(
          child: ListTile(
            title: Text(item.title),
            subtitle: item.url != null
                ? Text(
                    item.url ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : null,
            onTap: () {
              launchUrl(Uri.parse(item.url ?? ""),
                  mode: LaunchMode.externalApplication);
            },
          ),
        );
      },
    );
  }
}
