import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';


class CommitScreen extends StatefulWidget {
  const CommitScreen({super.key, required this.repoName});
  final String repoName;


  @override
  State<CommitScreen> createState() => _CommitScreenState();
}

class _CommitScreenState extends State<CommitScreen> {

  List<dynamic> commits = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await http.get(Uri.parse('https://api.github.com/repos/freeCodeCamp/${widget.repoName}/commits'));

    commits = json.decode(response.body).toList();

    setState(() {
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(commitScreenTitle),
      ),
      body: isLoading? Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Loading...', style: TextStyle(fontSize: 20),),
            SizedBox(width: 10),
            CircularProgressIndicator(color: Colors.redAccent),
          ],
        ),
      ) : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customCard("Repository Name : ", widget.repoName),
            customCard("Committer Name : ", commits[0]['commit']["committer"]["name"].toString()),
            customCard("Commit Message : ", commits[0]['commit']["message"].toString()),
            customCard("Date & Time: ", commits[0]['commit']["committer"]["date"].toString()),
            customCard("Email : ", commits[0]['commit']["committer"]["email"]),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Card customCard(String left,String right){
  return Card(
      elevation: 20,
      shadowColor: Colors.black,
      color: cardColor,
      margin: const EdgeInsets.only(top:25,left: 10,right: 10),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0,right: 10.0,top: 15.0,bottom: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(left)),
            Flexible(child: Text(right,style: const TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
      )
  );
}