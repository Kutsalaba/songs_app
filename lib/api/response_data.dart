import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:songs_app/models/playlist_model.dart';
import 'package:songs_app/models/song_model.dart';

class ResponseData {
  ResponseData({
    required this.url,
  });

  String url;
  Document? document;

  Future<PlaylistModel?> fetchPlaylist() async {
    try {
      Response response = await Dio().get(url);
      if (response.statusCode == 200) {
        document = parse(response.data);
        debugPrint(url);
        return Future.value(
          PlaylistModel(
            name: _addPlaylistName(),
            description: _addPlaylistDescription(),
            avatar: _addAvatar(),
            songs: _addSongs(),
          ),
        );
      }
    } on DioError catch (e) {
      print(e);
    }
    return null;
  }

  List<SongModel> _addSongs() {
    int currVal = document!
        .getElementsByClassName(
            'songs-list-row songs-list-row--web-preview web-preview songs-list-row--two-lines songs-list-row--song')
        .length;
    List<SongModel> songs = [];
    for (int i = 0; i < currVal; i++) {
      songs.add(SongModel(
        songName: _addSongName(i),
        artistName: _addArtistName(i),
        duration: _addDuration(i),
      ));
    }
    return songs;
  }

  String _addSongName(int index) {
    String name = document!
        .getElementsByClassName('songs-list-row__song-name-wrapper')[index]
        .children[0]
        .text;
    return _culturingStr(name);
  }

  String _addArtistName(int index) {
    String name = document!
        .getElementsByClassName('songs-list-row__song-name-wrapper')[index]
        .children[1]
        .text;
    return _culturingStr(name);
  }

  String _addDuration(int index) {
    String duration = document!.getElementsByTagName('time')[1].text;
    return _culturingStr(duration);
  }

  String _addPlaylistName() {
    String name =
        document!.getElementById('page-container__first-linked-element')!.text;
    return _culturingStr(name);
  }

  String _addPlaylistDescription() {
    String descrip =
        document!.getElementsByClassName('truncated-content-container')[0].text;
    return _culturingStr(descrip);
  }

  //I couldn't add avatar from html
  Image _addAvatar() {
    return Image.network(
        'https://is5-ssl.mzstatic.com/image/thumb/Video124/v4/2a/85/e3/2a85e3b4-5503-29fa-ca4d-f6afd9a98f1c/Job14d62ca2-3fc9-4292-a4f8-54dbb0859c94-108238143-PreviewImage_PreviewImageIntermediate_preview_image_nonvideo-Time1607894324638.png/305x305cc.webp');
  }

  String _culturingStr(String text) {
    text = text.replaceAll('\n', '');
    text = text.replaceAll('  ', '');
    return text;
  }
}
