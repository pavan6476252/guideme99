// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(child: HeaderSection(), preferredSize: Size(double.maxFinite, 300)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
              child: Column(
            children:  [
              const HeaderSection(),
              const HomePageContent(),
              GestureDetector( onTap: () => launchUrl(Uri.parse("https://pavan6476252.github.io/"),mode: LaunchMode.externalApplication), child: const Text("Made with ♥ by Pavan kumar"))
            ],
          )),
        ),
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(children: [
        HomePageContentCard(
          title: "Viit Docs",
          subtitle: 'All documents and pdf and reference files',
          content: 'Types : Btech ',
          author: "Pavan Kumar",
          onTap: () =>Navigator.pushNamed(context, '/viitdocspage'),
        ),
        HomePageContentCard(
          title: "Ecet ",
          subtitle: 'All files related to ecet',
          content: 'Types : Docs : videos : papers :  blogs ',
          author: "Pavan Kumar",
          onTap: () =>Navigator.pushNamed(context, '/ecetdocspage'),
        ),
        HomePageContentCard(
          title: "Blogs",
          subtitle: 'All blogs related to students',
          content: 'Types : Ecet : Btech : MBA : MCA ',
          author: "Pavan Kumar",
          onTap: () =>Navigator.pushNamed(context, '/blogspage')
        ),
      ]),
    );
  }
}

class HomePageContentCard extends StatelessWidget {
  String title;
  String subtitle;
  String content;
  String author;
  final VoidCallback onTap;
  HomePageContentCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.author,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 22),
                      ),
                      const SizedBox(height: 8),
                      Text(subtitle,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w300)),
                      Text(content,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w300)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                           CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            child: const Icon(Icons.person_4_outlined),
                          ),
                          const SizedBox(width: 10),
                          Text(author)
                        ],
                      )
                    ],
                  ),
                ),
                 CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.onSecondary,

                    child: const Icon(Icons.rocket_launch))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              CircleAvatar(
                
                child: Icon(Icons.person_4_outlined),
              ),
              SizedBox(height: 5),
              Text(
                "Hello,",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
              ),
              Text(
                "Anonyus user",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
              )
            ],
          ),
          IconButton(
              onPressed: () {},
              icon:  CircleAvatar(                            backgroundColor: Theme.of(context).colorScheme.onSecondary,

                  child: const Icon(Icons.search_rounded)))
        ],
      ),
    ));
  }
}
