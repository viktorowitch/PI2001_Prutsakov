import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response = await client.get(Uri.parse(
      'https://kubsau.ru/api/getNews.php?key=6df2f5d38d4e16b5a923a6d4873e2ee295d0ac90'));
  Bidi.stripHtmlIfNeeded('');
  return compute(parsePhotos, response.body);
}

List<Photo> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  Bidi.stripHtmlIfNeeded('');
  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

class Photo {
  final String ID;
  final String ACTIVE_FROM;
  final String TITLE;
  final String PREVIEW_TEXT;
  final String PREVIEW_PICTURE_SRC;
  final String DETAIL_PAGE_URL;
  final String DETAIL_TEXT;
  final String LAST_MODIFIED;

  const Photo({
    required this.ID,
    required this.ACTIVE_FROM,
    required this.TITLE,
    required this.PREVIEW_TEXT,
    required this.PREVIEW_PICTURE_SRC,
    required this.DETAIL_PAGE_URL,
    required this.DETAIL_TEXT,
    required this.LAST_MODIFIED,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      ID: json['ID'] as String,
      ACTIVE_FROM: json['ACTIVE_FROM'] as String,
      TITLE: json['TITLE'] as String,
      PREVIEW_TEXT: json['PREVIEW_TEXT'] as String,
      PREVIEW_PICTURE_SRC: json['PREVIEW_PICTURE_SRC'] as String,
      DETAIL_PAGE_URL: json['DETAIL_PAGE_URL'] as String,
      DETAIL_TEXT: json['DETAIL_TEXT'] as String,
      LAST_MODIFIED: json['LAST_MODIFIED'] as String,
    );
  }
}

void main() {
  runApp(const MyApp());
  HttpOverrides.global = MyHttpOverrides();
}

String stripHtmlIfNeeded(String text) {
  return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Лента новостей КубГАУ';

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: FutureBuilder<List<Photo>>(
        future: fetchPhotos(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Ошибка'));
          } else if (snapshot.hasData) {
            return PhotosList(photos: snapshot.data!);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class PhotosList extends StatefulWidget {
  const PhotosList({Key? key, required this.photos}) : super(key: key);
  final List<Photo> photos;
  @override
  State<PhotosList> createState() => _PhotosList();
}

class _PhotosList extends State<PhotosList> {
  bool b = false;
  String text = '';
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        text = widget.photos[index].PREVIEW_TEXT;

        void fotki() {
          setState(() {
            if (b = true) {
              text = widget.photos[index].PREVIEW_TEXT;
              b = false;
            }
            if (b = false) {
              text = widget.photos[index].DETAIL_TEXT;
              b = true;
            }
          });
        }

        return Card(
            margin: const EdgeInsets.all(10),
            color: Colors.blue[100],
            shadowColor: Colors.grey,
            elevation: 10,
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.black)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              Image.network(widget.photos[index].PREVIEW_PICTURE_SRC),
              Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(stripHtmlIfNeeded(widget.photos[index].ACTIVE_FROM),
                          style: const TextStyle(fontStyle: FontStyle.italic)),
                      Text(stripHtmlIfNeeded(widget.photos[index].TITLE),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const Divider(),
                      TextButton(
                        child: Text(stripHtmlIfNeeded(text)),
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                        ),
                        onPressed: fotki,
                      ),
                    ],
                  ))
            ]));
      },
    );
  }
}
