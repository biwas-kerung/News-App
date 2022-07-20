import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/models/news_model.dart';
import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StreamController<NewsModel> _streamController = StreamController();

  @override
  void initState() {
    super.initState();
    getPostApi();
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }

  Future<void> getPostApi() async {
    const url =
        'https://newsapi.org/v2/everything?q=bitcoin&apiKey=9952e8c26e004f329a192c6043d6fc79';
    final parsedUrl = Uri.parse(url);
    final response = await http.get(parsedUrl);
    final statusCode = response.statusCode;

    if (statusCode == 200) {
      final rawJsonString = response.body;
      final jsonMap = jsonDecode(rawJsonString);
      NewsModel newsModel = NewsModel.fromJson(jsonMap);

      //add API response to stream controller sink
      _streamController.sink.add(newsModel);
    } else {
      throw HttpException('$statusCode');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: myAppBar(),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              StreamBuilder<NewsModel>(
                stream: _streamController.stream,
                builder: (context, snapdata) {
                  switch (snapdata.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    default:
                      if (snapdata.hasError) {
                        return const Text('Please wait...');
                      } else {
                        return buildNewsCard(snapdata.data!, context);
                      }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
