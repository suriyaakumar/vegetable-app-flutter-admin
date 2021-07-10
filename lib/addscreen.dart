import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Addscreen extends StatefulWidget {

  @override
  _AddscreenState createState() => _AddscreenState();
}

class _AddscreenState extends State<Addscreen> {
  File? image;
  TextEditingController name = new TextEditingController();
  TextEditingController price = new TextEditingController();
  TextEditingController type = new TextEditingController();
  final ImagePicker picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  
    Future pickImage() async {
    final upload = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      image = File(upload!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('ADD PRODUCT', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
           body: Center(
        child: ListView(children: [
          Card(
            margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
            elevation: 20.0,
            child: Form(
                key: formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      FractionallySizedBox(
                          widthFactor: 0.85,
                          child: Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.02),
                              child:(image == null) 
                                  ? Container(
                                      color: Colors.grey[200],
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      child: Center(
                                          child: Text('NO IMAGE SELECTED')))
                                  : Image.file(image!)
                                 )),
                      FractionallySizedBox(
                          widthFactor: 0.85,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.02),
                            child: TextButton(
                                onPressed: () {
                                  pickImage();
                                },
                                child: Text('SELECT IMAGE FROM GALLERY')),
                          )),
                      FractionallySizedBox(
                        widthFactor: 0.85,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.02),
                          child: TextFormField(
                            controller: name,
                            validator: (value) {
                              if (value!.isEmpty) return 'Required';
                              return null;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                                labelText: 'Name'),
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.85,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.02),
                          child: TextFormField(
                              controller: price,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) return 'Required';
                                return null;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Price',
                                  prefixIcon: Icon(Icons.monetization_on))),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.85,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.02),
                          child: TextFormField(
                              controller: type,
                              validator: (value) {
                                if (value!.isEmpty) return 'Required';
                                return null;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Product Type',
                                  prefixIcon: Icon(Icons.shopping_cart))),
                        ),
                      ),
                      FractionallySizedBox(
                          widthFactor: 0.85,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.02,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.02),
                            child: Builder(
                              builder: (context) => TextButton(
                                  onPressed: () async {
                                    FormState formstate = formKey.currentState!;
                                    if (formstate.validate()) {
                                      if (image == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          duration: Duration(seconds: 1),
                                          backgroundColor:
                                              Theme.of(context).accentColor,
                                          content: Row(
                                            children: [
                                              Icon(Icons.image),
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.04),
                                              Text('Add product image'),
                                            ],
                                          ),
                                        ));
                                      } else {
                                        final Reference storage =
                                            FirebaseStorage.instance
                                                .ref()
                                                .child("${name.text}.jpg");
                                        final UploadTask task =
                                            storage.putFile(image!);
                                        task.then((value) async {
                                          String url =
                                              (await storage.getDownloadURL())
                                                  .toString();
                                          FirebaseFirestore.instance
                                              .collection("products")
                                              .add({
                                            "Name": name.text,
                                            "Price": price.text,
                                            "productType": type.text,
                                            "Image": url
                                          });
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .accentColor,
                                                duration: Duration(seconds: 1),
                                                content: Row(children: [
                                                  Icon(Icons.check, color: Colors.white),
                                                  SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.04),
                                                  Text(
                                                          'Added a Product successfully')
                                                ])));
                                      }
                                    }
                                  },
                                  child: Text('ADD PRODUCT')),
                            ),
                          ))
                    ])),
          ),
        ]),
      )
    );
  }
}