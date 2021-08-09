import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:food_group/session.dart';

//TODO: when you finally find an API, remember to preload some cards (if possible while clients are waiting)

class Selection extends StatefulWidget {
  final String code;
  final bool sessionLeader;
  const Selection({Key key, this.code, this.sessionLeader}) : super(key: key);

  @override
  _SelectionState createState() => _SelectionState();
}

class _SelectionState extends State<Selection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Group'),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.cancel,
              color: Colors.grey[200],
            ),
            onPressed: () {
              // TODO: remove leader, code and other users from database - update other users pages
              if(widget.sessionLeader) freeCode(widget.code);
              Navigator.pushReplacementNamed(
                context,
                '/home',
              );
            },
          )
        ],
      ),
      body: new Swiper(
          layout: SwiperLayout.STACK,
          itemWidth: 500.0,
          itemBuilder: (context, index) {
            return new RestaurantCard(
              name: 'Name',
              imageUrl: 'assets/dummy.jpg',
              rating: 3,
              priceLevel: 3,
              types: ['Modern','Cozy'],
              description: 'This is a random placehodler description. I am getting tired but hopes this works. Ok bye now.',
            );
          },
          itemCount: 10),
    );
  }
}

class RestaurantCard extends StatefulWidget {
  // TODO: add more variables like url, id, distance, etc.
  final String imageUrl;
  final String name;
  final int rating;
  final int priceLevel;
  final List<String> types;
  final String description;

  const RestaurantCard({Key key, this.imageUrl, this.name, this.rating, this.priceLevel, this.types,this.description}) : super(key: key);
  
  @override
  _RestaurantCardState createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  bool favorited = false;

  @override
  Widget build(BuildContext context) {
    String typeString = widget.types.join(", ");
    typeString = typeString.length > 30 ? typeString.substring(0, 26) + "..." : typeString;
    String priceString = '';
    for(int i = 0; i < widget.priceLevel; ++i){
      priceString = priceString + "\$";
    }

    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TODO: probably need to resize the images to be consistent
          ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(35),),
            child: Image.asset(
              widget.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10,20,10,20),
            child: Row(
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: 10,
                  ),
                ),
                IconButton(
                    icon: Icon(
                      favorited ? Icons.favorite : Icons.favorite_border,
                      color: Colors.pinkAccent[100],
                      size: 30.0,
                    ),
                    onPressed: (){
                      setState(() {
                        // TODO: figure out how to remember this state
                        // TODO: update database
                        favorited = !favorited;
                      });
                    },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: RatingBarIndicator(
              rating: 4.5,
              itemBuilder: (context, index) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              itemCount: 5,
              itemSize: 20.0,
              direction: Axis.horizontal,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10,0,10,10),
            child: Text(
              '$priceString - $typeString',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              widget.description,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(7),
            child: Divider(
              height: 30.0,
              thickness: 5.0,
            ),
          ),
          // TODO : add more fields
        ],
      ),
    );
  }
}

