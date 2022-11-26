import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imdb_test/main.dart';
import 'package:imdb_test/theme/colors.dart';
import 'package:imdb_test/ui/favourite_page.dart';
import 'package:imdb_test/ui/home_page.dart';

class MyNavigationBar extends StatefulWidget {
  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    MyHomePage(),
    FavouritePage(),
  ];

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
        padding: EdgeInsets.all(myPadding),
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        color: MyBlackColor,
        child: DefaultTabController(
          length: 2,
          child: TabBar(
            onTap: (index) {
              _selectedIndex = index;
              setState(() {});
            },
            indicatorColor: PrimaryColor,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(color: PrimaryColor, width: 4.0),
              insets: EdgeInsets.fromLTRB(38.0, 00.0, 38.0, 56.0),
            ),
            tabs: [
              Tab(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.movie_creation_outlined,
                      color: _selectedIndex == 0 ? PrimaryColor : Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Movies',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color:
                            _selectedIndex == 0 ? PrimaryColor : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Tab(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_added_outlined,
                      color: _selectedIndex == 1 ? PrimaryColor : Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Favourites',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color:
                            _selectedIndex == 1 ? PrimaryColor : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
