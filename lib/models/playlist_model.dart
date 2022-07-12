import 'package:flutter/material.dart';
import 'package:songs_app/models/song_model.dart';

class PlaylistModel {

  PlaylistModel({
    required this.name,
    required this.description,
    required this.avatar,
    required this.songs,
  });
  List<SongModel> songs;
  String name;
  String description;
  Image avatar;

}
