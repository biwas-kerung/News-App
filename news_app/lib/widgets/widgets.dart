import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/news_model.dart';
import '../screens/article_screen.dart';

Widget myAppBar() {
  return AppBar(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          "News",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        Text(
          "App",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        )
      ],
    ),
    backgroundColor: Colors.transparent,
    elevation: 0.0,
  );
}

Widget buildNewsCard(NewsModel newsModel, BuildContext context) {
  List imageUrl = newsModel.articles!.map(((e) => e.urlToImage)).toList();
  List title = newsModel.articles!.map(((e) => e.title)).toList();
  List desc = newsModel.articles!.map(((e) => e.description)).toList();
  List postUrl = newsModel.articles!.map(((e) => e.url)).toList();
  List author = newsModel.articles!.map(((e) => e.author)).toList();
  List publishedAt = newsModel.articles!.map(((e) => e.publishedAt)).toList();
  // print('This is :: ${imageUrl.length}');
  return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: newsModel.articles?.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.bottomCenter,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(6),
                  bottomLeft: Radius.circular(6)),
            ),
            //NEWS CARD
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildImage(index, imageUrl, context),
                  const SizedBox(height: 4),
                  //AUTHOR NAME AND PUBLISHED AT
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "By ${author[index].toString()}",
                        ),
                      ),
                      Flexible(
                        child: Text(
                          publishedAt[index].toString(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  //TITLE OF THE NEWS
                  Text(
                    title[index].toString(),
                    maxLines: 3,
                    style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  //DESCRIPTION OF NEWS
                  Text(
                    desc[index].toString(),
                    maxLines: 2,
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => ArticleScreen(
                                postUrl: postUrl[index].toString(),
                              )),
                        ),
                      );
                    },
                    //FOR WEBVIEW
                    child: const Text('Click Me'),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

Widget buildImage(int index, imageUrl, BuildContext context) => ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: CachedNetworkImage(
        height: 200,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
        imageUrl: imageUrl[index].toString(),
        errorWidget: (context, url, error) => Container(
          color: Colors.black12,
          child: const Icon(
            Icons.error,
            color: Colors.red,
          ),
        ),
      ),
    );
