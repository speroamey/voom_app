import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final Function onTapped;
  final String hint;
  final bool transparent;
  final bool closeButton;
  final String search;

  SearchBar(this.search, this.onTapped, this.hint,
      {Key key, bool withClose, bool isTransparent})
      : transparent = isTransparent ?? true,
        closeButton = withClose ?? false,
        super(key: key);
  @override
  _SearchBarState createState() {
    return new _SearchBarState();
  }
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchController = new TextEditingController();
  String _search;
  @override
  void initState() {
    super.initState();
    _search = widget.search;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: new Card(
            color: widget.transparent ? Colors.transparent : Colors.white,
            elevation: 0.0,
            child: new Row(children: _buildSearch())));
  }

  List<Widget> _buildSearch() {
    if (widget.search == null || widget.search.isEmpty) {
      _searchController.clear();
    }
    List<Widget> children = [
      new Expanded(
          child: new TextField(
              autofocus: true,
              controller: _searchController,
              onChanged: (String value) {
                _search = value;
                widget.onTapped(_search);
              },
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.hint,
                  hintStyle: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontFamily: "Serif"))))
    ];
    if (widget.closeButton == true) {
      children.add(new IconButton(
          padding: new EdgeInsets.all(0.0),
          icon: new Icon(Icons.close),
          onPressed: () {
            _search = "";
          }));
    }
    return children;
  }
}
