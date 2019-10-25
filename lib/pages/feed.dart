import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feedly/pages/create.dart';
import 'package:flutter_feedly/widgets/compose_box.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

List<Widget> _posts = [];
List<DocumentSnapshot> _postDocuments = [];
Future _getFeedFuture;

Firestore _firestore = Firestore.instance;
FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class _FeedPageState extends State<FeedPage> {
  _navigateToCreatePage() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext ctx) {
      return CreatePage();
    }));
  }

  Future _getFeed() async {
    Query _query = _firestore.collection('posts').orderBy('created', descending: true).limit(10);
    QuerySnapshot _quertSnapshot =  await _query.getDocuments();

    print(_quertSnapshot.documents.length);

    _postDocuments = _quertSnapshot.documents;

    return _postDocuments;
  }

  _getItems() {
    List<Widget> _items = [];

    Widget _composeBox = GestureDetector(
      child: ComposeBox(),
      onTap: () {
        _navigateToCreatePage();
      },
    );

    _items.add(_composeBox);

    return _items;
  }

  @override
  void initState() {
    super.initState();

    _getFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.rss_feed),
        title: Text('Your Feed'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {},
          )
        ],
      ),
      body: ListView(
        children: _getItems(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _navigateToCreatePage();
        },
      ),
    );
  }
}
