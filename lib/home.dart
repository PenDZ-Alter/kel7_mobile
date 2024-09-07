import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double tileWidth = 300.0;
  double tileHeight = 300.0;
  double tileContainerHeight = 450.0;

  // Tambahkan variabel counter untuk menghitung jumlah klik tombol
  int buttonPressCount = 0;

  List<Map<String, dynamic>> tilesData = [
    {"image": "assets/Images/City3.jpg", "title": "City1"},
    {"image": "assets/Images/City.jpg", "title": "City2"},
    {"image": "assets/Images/City1.jpg", "title": "City3"},
    {"image": "assets/Images/City2.jpg", "title": "City4"}
  ];

  @override
  Widget build(BuildContext context) {
    AppBar AppbarContent = AppBar(
        title: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Icon(Icons.list),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                widget.title,
                style: const TextStyle(fontFamily: 'Times New Roman'),
              ),
            ),
            Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Sign in',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
                )),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 218, 179, 6));

    Container content = Container(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Column(
            children: <Widget>[
              // Topbar
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        print("Lottery Tapped");
                      },
                      child: Column(
                        children: [
                          Icon(Icons.bookmark),
                          SizedBox(height: 8),
                          Text('Lottery'),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        print("Treasury Tapped");
                      },
                      child: Column(
                        children: [
                          Icon(Icons.star),
                          SizedBox(height: 8),
                          Text('Treasury'),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        print("Trivia Tapped");
                      },
                      child: Column(
                        children: [
                          Icon(Icons.help),
                          SizedBox(height: 8),
                          Text('Trivia'),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        print("Karaoke Tapped");
                      },
                      child: Column(
                        children: [
                          Icon(Icons.mic),
                          SizedBox(height: 8),
                          Text('Karaoke'),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        print("Hamcam Tapped");
                      },
                      child: Column(
                        children: [
                          Icon(Icons.camera_alt),
                          SizedBox(height: 8),
                          Text('#hamcam'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Image Tiles, Scrollable horizontal axis
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  height: tileContainerHeight,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: tilesData.length,
                    itemBuilder: (context, i) {
                      return Container(
                        width: tileWidth,
                        margin: EdgeInsets.only(right: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 6.0, color: Color.fromARGB(0, 0, 0, 0)),
                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0)
                              ),
                              child: Image.asset(
                                tilesData[i]['image'],
                                fit: BoxFit.cover,
                                height: tileHeight,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(tilesData[i]['title'])
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
          
              // Content 3
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 3.0, color: Color.fromARGB(0, 0, 0, 0)),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Colors.black12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Mobile Programming Online',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'The UIN Malang Informatic Engineering subject you can do from home!',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      // Button "Learn More"
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              buttonPressCount++;
                            });
                            print("Tombol telah dipencet sebanyak $buttonPressCount kali");
                          },
                          child: Text('Learn More'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Content 4
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'This is just a demo',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ]
      ),
    );

    return Scaffold(
      appBar: AppbarContent,
      body: content,
      resizeToAvoidBottomInset: false,
    );
  }
}
