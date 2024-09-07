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

  // Variabel counter untuk menghitung jumlah klik tombol
  int buttonPressCount = 0;

  // Variabel untuk skala animasi
  double buttonScale = 1.0;
  bool isAnimating = false;

  List<Map<String, dynamic>> tilesData = [
    {
      "image": "assets/Images/City3.jpg",
      "title": "Seorang wanita melihat pemandangan kota sore hari"
    },
    {
      "image": "assets/Images/City.jpg",
      "title": "Pemandangan kota Lyon pada pagi hari"
    },
    {
      "image": "assets/Images/City1.jpg",
      "title": "Pemandangan kota Chicago pada sore hari"
    },
    {
      "image": "assets/Images/City2.jpg",
      "title": "Pemandangan kota Shanghai pada sore hari"
    }
  ];

  void _onButtonPressed() {
    setState(() {
      // Tambahkan skala tombol untuk animasi
      isAnimating = true;
      buttonScale = 0.9;
      buttonPressCount++;
      print("Tombol telah dipencet sebanyak $buttonPressCount kali");
    });

    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        buttonScale = 1.0;
        isAnimating = false;
      });
    });
  }

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
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    print('Sign in pressed');
                  });
                },
                child: AnimatedScale(
                  scale: isAnimating ? 1.2 : 1.0,
                  duration: Duration(milliseconds: 200),
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onEnd: () {
                    setState(() {
                      isAnimating = false;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 218, 179, 6));

    Container content = Container(
      child: Column(
        children: <Widget>[
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              height: 350.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tilesData.length,
                itemBuilder: (context, i) {
                  return Container(
                    width: tileWidth,
                    margin: EdgeInsets.only(right: 8.0),
                    child: Column(
                      children: [
                        Image.asset(
                          tilesData[i]['image'],
                          fit: BoxFit.cover,
                          height: tileHeight,
                        ),
                        SizedBox(height: 8),
                        Text(
                          tilesData[i]['title'],
                          style: TextStyle(
                            fontFamily: 'Times New Roman',
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                    color: Colors.blueGrey,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              color: Colors.grey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Mobile Programming Online',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'The UIN Malang Informatic Engineering subject you can do from home!',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Button "Learn More"
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // Setiap tombol dipencet, tambahkan counter
                          buttonPressCount++;
                        });
                        print(
                            "Tombol telah dipencet sebanyak $buttonPressCount kali");
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.black54, // Ubah warna shadow tombol
                        elevation: 5, // Ubah elevasi tombol
                        padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12), // Ubah padding tombol
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12), // Ubah bentuk tombol menjadi lebih bulat
                        ),
                      ),
                      child: Text(
                        'Learn More',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
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
