import 'package:flutter/material.dart';
import 'package:imdb_test/main.dart';
import 'package:imdb_test/ui/movie_list.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 23.2),
            Image.asset('assets/images/logo.png',
                height: 28, width: 28, fit: BoxFit.fitWidth)
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(myPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Popular',
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: MovieList(),
            )
          ],
        ),
      ),
    );
  }
}
