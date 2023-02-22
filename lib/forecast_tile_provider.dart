import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ForecastTileProvider implements TileProvider {
  final String mapType;
  final DateTime dateTime;
  int tileSize = 256;
  final double opacity;

  ForecastTileProvider({
    required this.mapType,
    required this.dateTime,
    required this.opacity,
  });

  @override
  Future<Tile> getTile(int x, int y, int? zoom) async {
    Uint8List tileBytes = Uint8List(0);
    try {
      final date = dateTime.millisecondsSinceEpoch ~/ 1000;
      final url =
          "http://maps.openweathermap.org/maps/2.0/weather/$mapType/$zoom/$x/$y?date=$date&opacity=$opacity&fill_bound=true&appid=9de243494c0b295cca9337e1e96b00e2";
      if (TilesCache.tiles.containsKey(url)) {
        tileBytes = TilesCache.tiles[url]!;
      } else {
        final uri = Uri.parse(url);

        final ByteData imageData = await NetworkAssetBundle(uri).load("");
        tileBytes = imageData.buffer.asUint8List();
        TilesCache.tiles[url] = tileBytes;
      }
    } catch (e) {
      print(e.toString());
    }
    return Tile(tileSize, tileSize, tileBytes);
  }
}

class TilesCache {
  static Map<String, Uint8List> tiles = {};
}
