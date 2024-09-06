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
          Align(alignment: Alignment.centerRight, child: Text('Sign in')),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 218, 179, 6)
    );

    /* Edit content here */
    Container content = Container(
      child: Column(
        children: <Widget>[
          // Row for the icons with text labels
          Padding(
            padding: const EdgeInsets.all(16.0),
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

          // New Block of Tickets tile
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              color: Colors.black12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/hamilton.jpg', // Ensure this is added to your assets folder and declared in pubspec.yaml
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'August 20',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'New Block of Tickets for Hamilton on Broadway Released!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Eduham Online tile
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              color: Colors.black12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Eduham Online',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'The American History curriculum you can do from home!',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  // Button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
            padding: const EdgeInsets.all(16.0),
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
      )
    );

    return Scaffold(
      appBar: AppbarContent,
      body: content,
    );
  }
}
