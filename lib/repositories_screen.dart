import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'commit_screen.dart';
import 'constants.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<dynamic> publicRepos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await http.get(Uri.parse('https://api.github.com/users/freeCodeCamp/repos'));

    publicRepos = json.decode(response.body).toList();

    setState(() {
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(repositoriesScreenTitle),
      ),
      body: Center(
        child: isLoading? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Loading...', style: TextStyle(fontSize: 20),),
            SizedBox(width: 10,),
            CircularProgressIndicator(color: Colors.redAccent,),
          ],
        ) : ListView.builder(
          padding: const EdgeInsets.only(top: 0.0, bottom: 3.0),
          shrinkWrap: true,
          itemCount: publicRepos.length,
          itemBuilder: (context, index) {
            return Container(
              decoration:  BoxDecoration(
                border: Border(
                    bottom:
                    BorderSide(color: Theme.of(context).primaryColor, width: 0.07)),
              ),
              height: 80,
              child: ListTile(
                onTap: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommitScreen(repoName: publicRepos[index]["name"]),
                      ));
                },
                visualDensity: VisualDensity.compact,
                contentPadding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 5.0, bottom: 10.0),
                leading: CircleAvatar(
                  radius: 20.0,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(publicRepos[index]["owner"]["avatar_url"].toString()),
                ),
                title: Text(publicRepos[index]["name"].toString()),
                subtitle: Text(publicRepos[index]["description"].toString()),
                trailing: Text(publicRepos[index]["forks"].toString()),
              ),
            );
          },
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}