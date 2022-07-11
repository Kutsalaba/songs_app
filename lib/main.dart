import 'package:flutter/material.dart';
import 'package:songs_app/models/playlist_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Demo Home Page'),
        ),
        body: ListView.builder(
          itemCount: 100,
          itemBuilder: (context, position) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  //Допиши цю діч
                  'PlaylistModel().songs',
                  style: TextStyle(fontSize: 22.0),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
