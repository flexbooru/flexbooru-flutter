import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flexbooru_flutter/transparent_image.dart';

class PoolsPage extends StatelessWidget {
  PoolsPage() : _sizes = new List.generate(20, (i) => new IntSize(200, 300)).toList();

  final List<IntSize> _sizes;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          title: Text("Pools"),
        ),
      body: new StaggeredGridView.countBuilder(
        primary: false,
        crossAxisCount: 4,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        itemCount: _sizes.length,
        itemBuilder: (context, index) => new _Tile(index, _sizes[index]),
        staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
      ),
    );
  }
}

class IntSize {
  const IntSize(this.width, this.height);

  final int width;
  final int height;
}

class _Tile extends StatelessWidget {
  const _Tile(this.index, this.size);

  final IntSize size;
  final int index;

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        children: <Widget>[
          new Stack(
            children: <Widget>[
              //new Center(child: new CircularProgressIndicator()),
              new Center(
                child: new AspectRatio(
                  aspectRatio: size.width/size.height,
                  child: new FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: 'https://picsum.photos/${size.width}/${size.height}/',
                  ),
                ),
              ),
            ],
          ),
          new Padding(
            padding: const EdgeInsets.all(4.0),
            child: new Column(
              children: <Widget>[
                new Text(
                  'Image number $index',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                new Text(
                  'Width: ${size.width}',
                  style: const TextStyle(color: Colors.grey),
                ),
                new Text(
                  'Height: ${size.height}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
