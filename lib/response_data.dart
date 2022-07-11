import 'package:dio/dio.dart';
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

  Future<void> getHttp() async {
    Response response = await Dio().get(
        'https://music.apple.com/ua/playlist/a-list-pop/pl.5ee8333dbe944d9f9151e97d92d1ead9');
    if (response.statusCode == 200) {
      document = parse(response.data);
    }
  }

  PlaylistModel createPlaylist() {
    return PlaylistModel(
      name: _addPlaylistName(),
      description: _addPlaylistDescription(),
      avatar: 'avatar',
      songs: _addSongs(),
    );
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
    return descrip.replaceAll('\n', '');
  }

  String _culturingStr(String text) {
    return _culturingStr(text);
  }
}
