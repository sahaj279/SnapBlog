import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:snapblog/screens/profileScreen.dart';
import 'package:snapblog/screens/single_post_screen.dart';
import 'package:snapblog/utils/colors.dart';
import 'package:snapblog/utils/dimensions.dart';
import 'package:snapblog/widgets/explorePostCard.dart';
import 'package:snapblog/widgets/list-card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool showUsers = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width > webdim ? width / 4 : 0),
      child: Scaffold(
        backgroundColor: Color(0xffE6EEFA),
        appBar: AppBar(
          backgroundColor: Color(0xffffffff),
          leading: showUsers
              ? InkWell(
                  onTap: () {
                    _searchController.text = '';
                    setState(() {
                      showUsers = false;
                    });
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Color(0xff6C7A9C),
                  ),
                )
              : const Icon(
                  Icons.search,
                  color: Color(0xff6C7A9C),
                ),
          title: TextFormField(
            onChanged: (String _) {
              setState(() {
                showUsers = false;
              });
            },
            cursorColor: blueAccentColor,
            onFieldSubmitted: (String _) {
              setState(() {
                showUsers = true;
              });
            },
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search a user',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(8),
              // filled: true,
              // fillColor: Colors.white,
            ),
          ),
        ),
        // backgroundColor: blogBgColor,
        body: Padding(
          padding: MediaQuery.of(context).size.width > webdim
              ? EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: MediaQuery.of(context).size.width / 3,
                )
              : const EdgeInsets.all(5.0),
          child: showUsers
              ? FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .where('username',
                          isGreaterThanOrEqualTo: _searchController.text)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!snapshot.hasData ||
                        (snapshot.data! as dynamic).docs.length == 0) {
                      // print('no data bc');
                      return const Center(
                        child: Text('No results found.',
                            style: TextStyle(color: textColor)),
                      );
                    }
                    return ListView.builder(
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                          uid: (snapshot.data! as dynamic)
                                              .docs[index]['uid'])));
                            },
                            child: ListCard(
                                snap: (snapshot.data! as dynamic)
                                    .docs[index]
                                    .data()),
                          );
                        });
                  },
                )
              : FutureBuilder(
                  future: FirebaseFirestore.instance.collection('posts').get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!snapshot.hasData ||
                        (snapshot.data! as dynamic).docs.length == 0) {
                      return const Center(
                        child: Text('No one has posted anything'),
                      );
                    }
                    return GridView.custom(
                      gridDelegate: SliverQuiltedGridDelegate(
                        crossAxisCount: 3,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        repeatPattern: QuiltedGridRepeatPattern.inverted,
                        pattern: MediaQuery.of(context).size.width > webdim
                            ? const [
                                QuiltedGridTile(1, 1),
                                QuiltedGridTile(1, 1),
                                QuiltedGridTile(1, 1),
                                // QuiltedGridTile(1, 2),
                              ]
                            : const [
                                QuiltedGridTile(2, 2),
                                QuiltedGridTile(1, 1),
                                QuiltedGridTile(1, 1),
                                // QuiltedGridTile(1, 2),
                              ],
                      ),
                      childrenDelegate: SliverChildBuilderDelegate(
                        (context, index) => InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return SinglePostCard(
                                    snap: (snapshot.data! as dynamic)
                                        .docs[index]
                                        .data());
                              }));
                            },
                            child: ExplorePostCard(
                              snap: (snapshot.data! as dynamic).docs[index],
                            )),
                        childCount: (snapshot.data! as dynamic).docs.length,
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
