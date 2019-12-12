import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<File> _selectedImage;
  Future<File> _gallaryImage;
  bool diffFlag = false;
  int asd;
  File img1, img2;

  @override
  void initState() {
    diffFlag = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(child: _showImage(true),width: 150, height: 200,),
                Container(child: _showImage(false),width: 150, height: 200,),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  child: Text("Button1"),
                  onPressed: (){
                    asd = null;
                    _getIamge1();
                  },
                ),
                RaisedButton(
                  child: Text("Button2"),
                  onPressed: (){
                    asd = null;
                    _getIamge2();
                  },
                ),
              ],
            ),
            asd != null ?
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border.all(),color: diffFlag ? Colors.tealAccent : Colors.black12),
              child: Text(diffFlag ? "Images are same." : "Images are different"),

            ) : Container(),
            RaisedButton(
              child: Text("Compare Images"),
              onPressed: (){
                asd = 0;
                _compareImage( img1, img2);
              },
            ),
          ],
        ),
      ),
    );
  }

  _getIamge1() async{
    setState(() {
      _gallaryImage = ImagePicker.pickImage(source: ImageSource.gallery);
    });
    img1 = await _gallaryImage;
  }
  _getIamge2() async{
    setState(() {
      _selectedImage = ImagePicker.pickImage(source: ImageSource.gallery);
    });
    img2 = await _selectedImage;
  }

  _compareImage( image1, image2){
    print("${image1.lengthSync()}, ${image2.lengthSync()}");
    int image1Size = image1.lengthSync();
    int image2Size = image2.lengthSync();
    if(image1Size == image2Size){
      print("Same size");
      setState(() {
        diffFlag = true;
      });
    }else{
      print("Images are different.");
      setState(() {
        diffFlag = false;
      });
    }

  }

  Widget _showImage(bool iamgeSelectedFlag){
    return FutureBuilder<File>(
      future: iamgeSelectedFlag ? _gallaryImage : _selectedImage,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot ){
        if(snapshot.connectionState == ConnectionState.done && snapshot.data != null){
          return Image.file(
            snapshot.data,
            width: 200,
            height: 200,
          );
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }
}
