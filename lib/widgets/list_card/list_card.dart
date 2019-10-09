import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListCard extends StatefulWidget {
  final String name;
  final String mobileNo;
  final bool isFavourite;
  final VoidCallback onEditTap;
  final VoidCallback onDelete;
  final VoidCallback onCardTap;
  final VoidCallback onFavouriteTap;
  final VoidCallback onFavDelete;
  final bool showFavouriteButton;

  ListCard(
      {this.name = 'Vikas',
      this.onEditTap,
      this.onDelete,
      this.onCardTap,
      this.onFavouriteTap,
      this.mobileNo,
      this.isFavourite,
        this.onFavDelete,
      this.showFavouriteButton = true});

  @override
  _ListCardState createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        color: Colors.black12,
        child: ListTile(
          onTap: widget.onCardTap,
          leading: CircleAvatar(
            backgroundColor: Colors.indigoAccent,
            child: Text(widget.name[0]),
            foregroundColor: Colors.white,
          ),
          title: Text(
            widget.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: widget.showFavouriteButton
              ? IconButton(
                  icon: Icon(
                    widget.isFavourite ? Icons.star : Icons.star_border,
                    size: 40,
                    color: Colors.black,
                  ),
                  onPressed: widget.onFavouriteTap)
              : IconButton(
                  icon: Icon(
                    Icons.delete,
                    size: 40,
                    color: Colors.black,
                  ),
                  onPressed: widget.onFavDelete),
          subtitle: Text(
            widget.mobileNo,
          ),
        ),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: Colors.black45,
          icon: Icons.edit,
          onTap: widget.onEditTap,
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: widget.onDelete,
        ),
      ],
    );
  }
}
