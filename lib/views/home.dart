import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/crud.dart';
import 'create_blog.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CrudMethods crudMethods = CrudMethods();
  Stream blogsStream;
  

  Widget blogsList() {
    return SingleChildScrollView(
      child: Container(
        // child:
        child: blogsStream != null
            ? 
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                StreamBuilder(
                    stream:
                    blogsStream, 
                    // FirebaseFirestore.instance.collection('blogs').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          return BlogsTile(
                            authorName: snapshot.data.docs[index]['authorName'],
                            title: snapshot.data.docs[index]['title'],
                            desc: snapshot.data.docs[index]['description'],
                            imageUrl: snapshot.data.docs[index]['imageUrl'],
                          );
                        },
                        itemCount: snapshot.data.docs.length,
                        shrinkWrap: true,
                      );
                    })
              ])
            : Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    crudMethods.getData().then((result) {
      setState(() {
        blogsStream = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Flutter',
              style: TextStyle(fontSize: 22),
            ),
            Text(
              'Blog',
              style: TextStyle(fontSize: 22, color: Colors.blue),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: blogsList(),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateBlog(),
                    ));
              },
              child: Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }
}

class BlogsTile extends StatelessWidget {
  final String imageUrl, authorName, title, desc;
  BlogsTile({this.authorName, this.desc, this.imageUrl, this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      height: 150,
      child: Stack(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: CachedNetworkImage(imageUrl: imageUrl, width: MediaQuery.of(context).size.width, fit: BoxFit.cover),
        ),
        Container(
          height: 170,
          decoration: BoxDecoration(color: Colors.black45.withOpacity(0.3), borderRadius: BorderRadius.circular(6)),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
              SizedBox(height: 4),
              Text(desc, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
              SizedBox(height: 4),
              Text(authorName,
                  style: TextStyle(
                    fontSize: 17,
                  ))
            ],
          ),
        )
      ]),
    );
  }
}
