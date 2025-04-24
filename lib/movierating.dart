import 'package:flutter/material.dart';

void main() => runApp(MovieRatingApp());

class MovieRatingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Rating App',
      debugShowCheckedModeBanner: false,
      home: MovieListScreen(),
    );
  }
}

class Movie {
  final String title;
  final String description;
  List<double> ratings;

  Movie({required this.title, required this.description, this.ratings = const []});

  double get averageRating =>
      ratings.isEmpty ? 0 : ratings.reduce((a, b) => a + b) / ratings.length;
}

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  List<Movie> movies = [
    Movie(title: 'Inception', description: 'Sci-fi thriller by Christopher Nolan.'),
    Movie(title: 'The Matrix', description: 'Action-packed sci-fi classic.'),
    Movie(title: 'Interstellar', description: 'Journey through space and time.'),
  ];

  void _rateMovie(Movie movie, double rating) {
    setState(() {
      movie.ratings = [...movie.ratings, rating];
    });
  }

  void _showRatingDialog(Movie movie) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Rate "${movie.title}"'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (i) {
            return IconButton(
              icon: Icon(Icons.star, color: Colors.amber),
              onPressed: () {
                _rateMovie(movie, i + 1.0);
                Navigator.of(context).pop();
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _buildMovieTile(Movie movie) {
    return ListTile(
      title: Text(movie.title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('${movie.description}\nAverage Rating: ${movie.averageRating.toStringAsFixed(1)}'),
      isThreeLine: true,
      trailing: Icon(Icons.star, color: Colors.amber),
      onTap: () => _showRatingDialog(movie),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Movie Ratings'), backgroundColor: Colors.black),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (_, i) => Card(
          margin: EdgeInsets.all(8),
          child: _buildMovieTile(movies[i]),
        ),
      ),
    );
  }
}
