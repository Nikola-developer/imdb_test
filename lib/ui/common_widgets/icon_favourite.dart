import 'package:flutter/material.dart';
import 'package:imdb_test/database/dao/movie_dao.dart';
import 'package:imdb_test/models/movie_model.dart';
import 'package:imdb_test/theme/colors.dart';

class IconFavourite extends StatefulWidget {
  IconFavourite({super.key, required this.movie});

  MovieModel movie;

  @override
  State<IconFavourite> createState() => _IconFavouriteState();
}

class _IconFavouriteState extends State<IconFavourite>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _bodyWidget() {
    return AnimatedBuilder(
      animation:
          CurvedAnimation(parent: _controller!, curve: Curves.fastOutSlowIn),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ...List.generate(
              3,
              (index) => _containerWidget((54 * index) * _controller!.value),
            ),
            Align(
                child: widget.movie.favourite
                    ? const Icon(Icons.bookmark_added, color: SecondaryColor)
                    : const Icon(Icons.bookmark_border)),
          ],
        );
      },
    );
  }

  Widget _containerWidget(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: MyRedColor.withOpacity(1 - _controller!.value)),
    );
  }

  bool showAnimation = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      width: 54,
      child: GestureDetector(
          onTap: () async {
            widget.movie.favourite = !widget.movie.favourite;
            if (!await MovieDao().toggleFavourite(
                widget.movie.id, widget.movie.favourite ? 1 : 0)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Something went wrong!'),
                ),
              );
            }

            _controller ??= AnimationController(
              vsync: this,
              lowerBound: 0.5,
              duration: const Duration(milliseconds: 1000),
            )
              ..repeat()
              ..addStatusListener((status) {
                if (status == AnimationStatus.completed) {
                  setState(() {});
                }
              });

            showAnimation = true;
            setState(() {});
            await Future.delayed(const Duration(milliseconds: 800));
            showAnimation = false;
            setState(() {});
          },
          child: showAnimation
              ? _bodyWidget()
              : widget.movie.favourite
                  ? const Icon(Icons.bookmark_added, color: SecondaryColor)
                  : const Icon(Icons.bookmark_border)),
    );
  }
}
