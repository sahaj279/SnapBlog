import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/screens/profileScreen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:instagram_clone/widgets/list-card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  bool showUsers = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: Icon(
          Icons.search,
          color: primaryColor,
        ),
        title: TextFormField(
          onChanged: (String _) {
            setState(() {
              showUsers = false;
            });
          },
          cursorColor: blueColor,
          onFieldSubmitted: (String _) {
            print(_);
            setState(() {
              showUsers = true;
            });
          },
          controller: _searchController,
          decoration: InputDecoration(
            // labelText: 'Search for a user',
            hintText: 'Search a user',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(8),
            // enabled: true,
            // filled: true,
            // fillColor: Colors.grey,
          ),
        ),
      ),
      body: showUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username',
                      isGreaterThanOrEqualTo: _searchController.text)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
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
                            snap:
                                (snapshot.data! as dynamic).docs[index].data()),
                      );
                    });
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return GridView.custom(
                  gridDelegate: SliverQuiltedGridDelegate(
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    repeatPattern: QuiltedGridRepeatPattern.inverted,
                    pattern: MediaQuery.of(context).size.width > webdim
                        ? [
                            QuiltedGridTile(1, 1),
                            QuiltedGridTile(1, 1),
                            QuiltedGridTile(1, 1),
                            // QuiltedGridTile(1, 2),
                          ]
                        : [
                            QuiltedGridTile(2, 2),
                            QuiltedGridTile(1, 1),
                            QuiltedGridTile(1, 1),
                            // QuiltedGridTile(1, 2),
                          ],
                  ),
                  childrenDelegate: SliverChildBuilderDelegate(
                    (context, index) => Image.network(
                      (snapshot.data! as dynamic).docs[index]['postUrl'],
                      fit: BoxFit.fill,
                    ),
                    childCount: (snapshot.data! as dynamic).docs.length,
                  ),
                );
                MasonryGridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) => Image.network(
                      (snapshot.data! as dynamic).docs[index]['postUrl']),
                );
              },
            ),
    );
  }
}
