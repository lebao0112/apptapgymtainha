import 'package:doan_tapgymtainha/screen/forum/search_result_screen.dart';
import 'package:flutter/material.dart';

class SearchPostScreen extends StatefulWidget {
  const SearchPostScreen({super.key});

  @override
  State<SearchPostScreen> createState() => _SearchPostState();
}

class _SearchPostState extends State<SearchPostScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearch(String keyword) {
    if (keyword.trim().isNotEmpty) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => Searchresultscreen(keyword: keyword),
      //   ),
      // );
      goToScreen(context, SearchResultScreen(query: keyword));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a keyword to search.')),
      );
    }
  }

  void goToScreen(BuildContext context, Widget screen){
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios)
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      autofocus: true,
                      onSubmitted: _onSearch,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () => _onSearch(_searchController.text),
                        ),
                      ),
                      // onSubmitted: _onSearch(_searchController.text),

                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
