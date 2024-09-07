import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              child: Text('Sign in',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400
                ),
              )
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 218, 179, 6));

    /* Edit content here */
    Container content = Container(
      child: Column(
        children: <Widget>[
          // Row for the icons with text labels (Lottery, Treasury, etc.)
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Lottery
                Column(
                  children: [
                    Icon(Icons.bookmark),
                    SizedBox(height: 8),
                    Text('Lottery'),
                  ],
                ),
                // Treasury
                Column(
                  children: [
                    Icon(Icons.star),
                    SizedBox(height: 8),
                    Text('Treasury'),
                  ],
                ),
                // Trivia
                Column(
                  children: [
                    Icon(Icons.help),
                    SizedBox(height: 8),
                    Text('Trivia'),
                  ],
                ),
                // Karaoke
                Column(
                  children: [
                    Icon(Icons.mic),
                    SizedBox(height: 8),
                    Text('Karaoke'),
                  ],
                ),
                // Hamcam
                Column(
                  children: [
                    Icon(Icons.camera_alt),
                    SizedBox(height: 8),
                    Text('#hamcam'),
                  ],
                ),
              ],
            ),
          ),
        
          // Image tiles scrollable horizontal axis
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              height: 350.0, // Adjust the height as needed
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  // Tile 1
                  Container(
                    width: 300.0,
                    margin: EdgeInsets.only(right: 8.0),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/Images/Hamilton.jpg',
                          fit: BoxFit.contain,
                          height: 200,
                        ),
                        SizedBox(height: 8),
                        Text("Tile 1")
                      ],
                    ),
                    color: Colors.blue,
                  ),
              
                  // Tile 2
                  Container(
                    width: 200.0,
                    margin: EdgeInsets.only(right: 8.0),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/Images/Hamilton.jpg',
                          fit: BoxFit.contain,
                          height: 200,
                        ),
                        SizedBox(height: 8),
                        Text("Tile 1")
                      ],
                    ),
                    color: Colors.blue,
                  ),
              
                  // Tile 3
                  Container(
                    width: 200.0,
                    margin: EdgeInsets.only(right: 8.0),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/Images/Hamilton.jpg',
                          fit: BoxFit.contain,
                          height: 200,
                        ),
                        SizedBox(height: 8),
                        Text("Tile 1")
                      ],
                    ),
                    color: Colors.blue
                  ),

                  // Tile 4
                  Container(
                    width: 200.0,
                    margin: EdgeInsets.only(right: 8.0),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/Images/Hamilton.jpg',
                          fit: BoxFit.contain,
                          height: 200,
                        ),
                        SizedBox(height: 8),
                        Text("Tile 1")
                      ],
                    ),
                    color: Colors.blue
                  ),
                ],
              ),
            ),
          ),
        
          // Eduham Online tile
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              color: Colors.black12,
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
                  // Button
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Your logic here
                      },
                      child: Text('Learn More'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        
          // The rest of your content
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
    );


    return Scaffold(
      appBar: AppbarContent,
      body: content,
      resizeToAvoidBottomInset: false,
    );
  }
}
