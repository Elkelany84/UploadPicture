import 'dart:io';

import 'package:flutter/material.dart';
import '../services/crud.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  String authorName, title, desc;

  CrudMethods crudMethods = CrudMethods();
  File selectedImage;
  bool _isLoading = false;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = image;
    });
  }

  uploadBlog() async {
    if (selectedImage != null) {
      setState(() {
        _isLoading = true;
      });
      Reference firebasebaseStorageRef = FirebaseStorage.instance.ref().child('blogimages').child('${randomAlphaNumeric(9)}.jpg');
      final UploadTask task = firebasebaseStorageRef.putFile(selectedImage);
      var downloadUrl = await (await task).ref.getDownloadURL();
      print('this is the download url');
      Map<String, String> blogMap = {
        'imageUrl': downloadUrl,
        'authorName': authorName,
        'title': title,
        'description': desc
      };
      crudMethods.addData(blogMap).then((result) {
        Navigator.pop(context);
      });
    } else {}
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
        actions: [
          GestureDetector(
              onTap: () {
                uploadBlog();
              },
              child: Container(padding: EdgeInsets.symmetric(horizontal: 16), child: Icon(Icons.file_upload)))
        ],
      ),
      body: _isLoading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Column(children: [
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: selectedImage != null
                      ? Container(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.file(
                                selectedImage,
                                fit: BoxFit.cover,
                              )),
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          height: 170,
                          width: MediaQuery.of(context).size.width,
                        )
                      : Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          height: 170,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                          width: MediaQuery.of(context).size.width,
                          child: Icon(
                            Icons.add_a_photo,
                            color: Colors.black45,
                          ),
                        ),
                ),
                SizedBox(height: 8),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(hintText: 'Author Name'),
                        onChanged: (value) {
                          authorName = value;
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(hintText: 'Title'),
                        onChanged: (value) {
                          title = value;
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(hintText: 'Description'),
                        onChanged: (value) {
                          desc = value;
                        },
                      ),
                    ],
                  ),
                )
              ]),
            ),
    );
  }
}
