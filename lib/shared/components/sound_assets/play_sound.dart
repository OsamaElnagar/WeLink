import 'package:audioplayers/audioplayers.dart';

class Player {
  static play(String src) async {
    final player = AudioPlayer();
    await player.play(AssetSource(src));
  }
}
