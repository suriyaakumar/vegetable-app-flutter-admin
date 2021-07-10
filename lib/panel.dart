import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'users.dart';
import 'products.dart';
import 'orders.dart';

var userCount, productCount, orderCount;

class Panel extends StatefulWidget {
  @override
  _PanelState createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  void getDetails() {
    FirebaseFirestore.instance.collection("users").snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((element) {
        setState(() {
          userCount = snapshot.docs.length;
        });
      });
    });

    FirebaseFirestore.instance.collection("products").snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((element) {
        setState(() {
          productCount = snapshot.docs.length;
        });
      });
    });

    FirebaseFirestore.instance.collection("orders").snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((element) {
        setState(() {
          orderCount = snapshot.docs.length;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
            title: Text('ADMIN DASHBOARD',
                style: TextStyle(fontWeight: FontWeight.bold))),
        body: GridView(
          scrollDirection:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? Axis.vertical
                  : Axis.horizontal,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? 2
                      : 1,
              childAspectRatio:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? 0.65
                      : 1.75),
          primary: false,
          children: [
            Tile(
                number: "${userCount.toString()}",
                title: 'USERS',
                page: 'Users'),
            Tile(
                number: "${productCount.toString()}",
                title: 'PRODUCTS',
                page: 'Products'),
            Tile(
              number: "${orderCount.toString()}",
              title: 'ORDERS',
              page: 'Orders',
            ),
            Tile(
                number: '4',
                title: 'NOTIFICATIONS'),
          ],
        ));
  }
}

class Tile extends StatefulWidget {
  final number;
  final title;
  final page;

  Tile({this.number, this.title, this.page});

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 30,
      color: Theme.of(context).primaryColor,
      margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: InkWell(
        onTap: () {
         if(widget.page == 'Users')
         Navigator.push(context, MaterialPageRoute(builder: (context) => Users()));
         else if(widget.page == 'Products')
         Navigator.push(context, MaterialPageRoute(builder: (context) => Products()));
         else if(widget.page == 'Orders')
         Navigator.push(context, MaterialPageRoute(builder: (context) => Orders()));
        },
        child: Column(children: [
          Expanded(
            child: ListTile(
                title: Text(
              'TAP TO VIEW',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
            )),
          ),
          Expanded(
              child: FittedBox(fit: BoxFit.fill, child: Text(widget.number, style: TextStyle(color: Colors.white)))),
          Expanded(
            child: ListTile(
                title: Text(
              widget.title,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            )),
          )
        ]),
      ),
    );
  }
}
