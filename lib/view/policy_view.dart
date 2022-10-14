import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';

class PolicyView extends StatefulWidget {
  String policy;
  String fileName;
  PolicyView({required this.policy, required this.fileName});

  @override
  _PolicyViewState createState() => _PolicyViewState();
}

class _PolicyViewState extends State<PolicyView> {
  String htmlData = "";
  void LoadAssets() async {
    var data = await rootBundle.loadString("assets/" + widget.fileName);
    setState(() {
      htmlData = data;
      print(htmlData);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadAssets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.policy.toString()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(child: Html(data: htmlData)),
    );
  }
}
