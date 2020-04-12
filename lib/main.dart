import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Material App', home: AnimatedListExample());
  }
}

class AnimatedListExample extends StatefulWidget {
  @override
  AnimatedListExampleState createState() {
    return new AnimatedListExampleState();
  }
}

class AnimatedListExampleState extends State<AnimatedListExample> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  List<String> _data = [
    WordPair.random().toString(),
    WordPair.random().toString(),
    WordPair.random().toString(),
    WordPair.random().toString(),
    WordPair.random().toString(),
  ];

  Widget _buildItem(BuildContext context, String item, Animation animation) {
    TextStyle textStyle = new TextStyle(fontSize: 20);

    print(animation);

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(1.0, 0),
          end: Offset.zero
        ).animate(animation),
        child: SizedBox(
          height: 50.0,
          child: Card(
            child: Center(
              child: Text(item, style: textStyle),
            ),
          ),
        ),
      ),
      /* child: SizeTransition(
        sizeFactor: animation,
        axis: Axis.vertical,
        child: SizedBox(
          height: 50.0,
          child: Card(
            child: Center(
              child: Text(item, style: textStyle),
            ),
          ),
        ),
      ),*/
    );
  }

  void _removeLastItem() {

    final index = _data.length-1;

    String itemToRemove = _data[index];

    _listKey.currentState.removeItem(
      index,
      (BuildContext context, Animation animation) =>
          _buildItem(context, itemToRemove, animation),
      duration: const Duration(milliseconds: 250),
    );

    _data.removeAt(index);
  }

  void _removeAllItems() {
    final int itemCount = _data.length;

    for (var i = 0; i < itemCount; i++) {
      String itemToRemove = _data[0];
      _listKey.currentState.removeItem(
        0,
        (BuildContext context, Animation animation) =>
            _buildItem(context, itemToRemove, animation),
        duration: const Duration(milliseconds: 250),
      );

      _data.removeAt(0);
    }
  }

  void _addAnItem() {
    _listKey.currentState.insertItem(_data.length);
    _data.add(WordPair.random().toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Animated List'),
        backgroundColor: Colors.blueAccent,
      ),
      persistentFooterButtons: <Widget>[
        RaisedButton(
          child: Text(
            'Add an item',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          onPressed: () {
            _addAnItem();
          },
        ),
        RaisedButton(
          child: Text(
            'Remove last',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          onPressed: () {
            _removeLastItem();
          },
        ),
        RaisedButton(
          child: Text(
            'Remove all',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          onPressed: () {
            _removeAllItems();
          },
        ),
      ],
      body: AnimatedList(
        key: _listKey,
        initialItemCount: _data.length,
        itemBuilder: (context, index, animation) =>
            _buildItem(context, _data[index], animation),
      ),
    );
  }
}
