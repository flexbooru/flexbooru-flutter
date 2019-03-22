import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flexbooru_flutter/transparent_image.dart';

class PoolsPage extends StatelessWidget {
  PoolsPage() : _sizes = List.generate(20, (i) => IntSize(200, 300)).toList();

  final List<IntSize> _sizes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StaggeredGridView.countBuilder(
        primary: false,
        crossAxisCount: 4,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        itemCount: _sizes.length,
        itemBuilder: (context, index) => _Tile(index, _sizes[index]),
        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
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
    return Card(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              //Center(child: CircularProgressIndicator()),
              Center(
                child: AspectRatio(
                  aspectRatio: size.width/size.height,
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: 'https://picsum.photos/${size.width}/${size.height}/',
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Image number $index',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Width: ${size.width}',
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
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
