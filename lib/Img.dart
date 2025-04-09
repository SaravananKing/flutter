import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home: ImageGallery(),
  debugShowCheckedModeBanner: false,
));

class ImageGallery extends StatelessWidget {
  final List<String> images = [
    'https://picsum.photos/seed/1/600',
    'https://picsum.photos/seed/2/600',
    'https://picsum.photos/seed/3/600',
    'https://picsum.photos/seed/4/600',
    'https://picsum.photos/seed/5/600',
    'https://picsum.photos/seed/6/600',
    'https://picsum.photos/seed/7/600',
    'https://picsum.photos/seed/8/600',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image Gallery")),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FullScreenImage(imageUrl: images[index]),
                ),
              );
            },
            child: Hero(
              tag: images[index],
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  images[index],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
          tag: imageUrl,
          child: InteractiveViewer(
            child: Image.network(imageUrl),
          ),
        ),
      ),
    );
  }
}
