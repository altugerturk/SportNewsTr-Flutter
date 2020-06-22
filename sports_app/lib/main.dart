import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sports_app/DetailPage.dart';
import 'package:sports_app/News.dart';
import 'Services.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sport News App',
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
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 80),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.blue, Colors.red, Colors.black])),
            child: Column(
              children: <Widget>[
                FutureBuilder<List<News>>(
                  future: fetchLink(http.Client()),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);

                    return snapshot.hasData
                        ? NewsContainer(newss: snapshot.data)
                        : Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            ),
          ),
          FutureBuilder<List<News>>(
            future: fetchLink(http.Client()),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);

              return snapshot.hasData
                  ? NewsList(newss: snapshot.data)
                  : Center(child: CircularProgressIndicator());
            },
          ),
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.03),
            child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: null),
          )
        ],
      ),
    );
  }

  NewsContainer({List<News> newss}) {
    double containerWidth = MediaQuery.of(context).size.width * 0.8;
    double containerHeight = MediaQuery.of(context).size.height * 0.3;
    return CarouselSlider(
      height: containerHeight,
      enableInfiniteScroll: false,
      initialPage: _current,
      scrollDirection: Axis.horizontal,
      onPageChanged: (index) {
        setState(() {
          _current = index;
        });
      },
      items: newss.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return InkWell(
              onTap: () {
                 Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailPage(
                              newss: newss[_current],
                            )));
              },
                          child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                    color: Colors.amberAccent,
                    borderRadius: BorderRadius.circular(24)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(24)),
                      height: containerHeight * 0.6,
                      width: containerWidth,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.network(
                          i.urlImage,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Container(
                      height: containerHeight * 0.4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Center(
                            child: Text(
                              i.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

class NewsList extends StatelessWidget {
  final List<News> newss;

  NewsList({Key key, this.newss}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(builder: (context, controller) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.red, Colors.blue])),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: newss.length,
          controller: controller,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  newss[index].urlImage,
                  fit: BoxFit.fill,
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailPage(
                              newss: newss[index],
                            )));
              },
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              title: Text(
                newss[index].title,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
      );
    });
  }
}
