import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../api/response_data.dart';
import '../models/playlist_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _textEditingController = TextEditingController();
  String? userInput;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 100.h,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  hintText: 'url',
                  labelStyle: TextStyle(
                    fontSize: 24.sp,
                    color: Colors.black,
                  ),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _textEditingController.clear();
                    },
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    userInput = _textEditingController.text;
                  });
                },
                color: Colors.blue,
                child: const Text(
                  'search',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              userInput == null
                  ? const Text('')
                  : FutureBuilder<PlaylistModel?>(
                      future: ResponseData(url: userInput!).fetchPlaylist(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasData) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 30.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 600.h,
                                    width: 500.w,
                                    child: snapshot.data!.avatar,
                                  ),
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  SizedBox(
                                    width: 840.w,
                                    child: Column(
                                      children: [
                                        Text(
                                          snapshot.data!.name,
                                          style: TextStyle(
                                            fontSize: 75.sp,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Text(snapshot.data!.description),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.songs.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Card(
                                      color: Colors.white12,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                          vertical: 2.h,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                'Artist name: ${snapshot.data!.songs[index].artistName}'),
                                            Text(
                                                'Song name: ${snapshot.data!.songs[index].songName}'),
                                            Text(
                                                'Duration: ${snapshot.data!.songs[index].duration}'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          final error = snapshot.error;
                          return Center(
                            child: Text(
                              error.toString(),
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 105.sp,
                              ),
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
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
