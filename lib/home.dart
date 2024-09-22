import 'package:flutter/material.dart';
import 'package:tugas1_ui/login.dart';

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
  double tileContainerHeights = 200.0;
  double tileWidths = 150.0;
  double tileHeights = 150.0;

  // Variabel counter untuk menghitung jumlah klik tombol
  int buttonPressCount = 0;

  // Variabel untuk skala animasi
  double buttonScale = 1.0;
  bool isAnimating = false;

  // Variabel untuk menyimpan indeks ikon yang dipilih
  int selectedIconIndex = -1;

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
    },
    {
      "image": "assets/Images/City4.jpg",
      "title": "Pemandangan kota Denmark pada sore hari"
    }
  ];

  List<Map<String, dynamic>> tilesDatas = [
    {"images": "assets/Images/satisfied.jpg", "titles": "Satisfied"},
    {"images": "assets/Images/Hamcam.jpg", "titles": "Share a #HamCam"},
    {"images": "assets/Images/yayhamlet.jpg", "titles": "Today's Sticker"},
  ];

  // Fungsi buildCircularIcon
  Widget buildCircularIcon(
      IconData icon, String label, int index, VoidCallback onTap) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedIconIndex = index; // Simpan indeks ikon yang diklik
        });
        onTap();
        // Kembalikan warna setelah 1 detik
        Future.delayed(Duration(milliseconds: 300), () {
          setState(() {
            selectedIconIndex = -1; // Reset warna ikon kembali ke semula
          });
        });
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(1),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: Offset(2, 3),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 25,
              color: selectedIconIndex == index
                  ? Colors.blue
                  : Colors.black, // Ubah warna berdasarkan pemilihan
            ),
          ),
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppBar AppbarContent = AppBar(
        automaticallyImplyLeading: false,
        title: Stack(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Builder(builder: (context) {
                  return GestureDetector(
                      child: Icon(Icons.list),
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      });
                })),
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
                    // Navigasi ke halaman login
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: AnimatedScale(
                    scale: isAnimating ? 1.2 : 1.0,
                    duration: Duration(milliseconds: 300),
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    onEnd: () {
                      setState(() {
                        isAnimating = false;
                      });
                    },
                  ),
                )),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 218, 179, 6));

    // Drawer
    Drawer sideMenu = Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Today'),
            onTap: () {
              // Handle tap on Today
            },
          ),
          ListTile(
            leading: Icon(Icons.confirmation_number),
            title: Text('Buy Tickets'),
            onTap: () {
              // Handle tap on Buy Tickets
            },
          ),
          ListTile(
            leading: Icon(Icons.bookmark),
            title: Text('Lottery'),
            onTap: () {
              // Handle tap on Lottery
            },
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Treasury'),
            onTap: () {
              // Handle tap on Treasury
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Trivia'),
            onTap: () {
              // Handle tap on Trivia
            },
          ),
          ListTile(
            leading: Icon(Icons.mic),
            title: Text('Karaoke'),
            onTap: () {
              // Handle tap on Karaoke
            },
          ),
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('#hamcam'),
            onTap: () {
              // Handle tap on #hamcam
            },
          ),
          ListTile(
            leading: Icon(Icons.sticky_note_2),
            title: Text('Stickers'),
            onTap: () {
              // Handle tap on Stickers
            },
          ),
          ListTile(
            leading: Icon(Icons.store),
            title: Text('Merchandise'),
            onTap: () {
              // Handle tap on Merchandise
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              // Handle tap on Profile
            },
          ),
          ListTile(
            leading: Icon(Icons.support),
            title: Text('Support'),
            onTap: () {
              // Handle tap on Support
            },
          ),
        ],
      ),
    );

    Container content = Container(
      child: ListView(scrollDirection: Axis.vertical, children: [
        Column(
          children: <Widget>[
            // Topbar
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildCircularIcon(Icons.bookmark, 'Lottery', 0, () {
                    print("Lottery Tapped");
                  }),
                  buildCircularIcon(Icons.star, 'Treasury', 1, () {
                    print("Treasury Tapped");
                  }),
                  buildCircularIcon(Icons.help, 'Trivia', 2, () {
                    print("Trivia Tapped");
                  }),
                  buildCircularIcon(Icons.mic, 'Karaoke', 3, () {
                    print("Karaoke Tapped");
                  }),
                  buildCircularIcon(Icons.camera_alt, '#hamcam', 4, () {
                    print("Hamcam Tapped");
                  }),
                ],
              ),
            ),

            // Image Tiles, Scrollable horizontal axis
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                height: tileContainerHeight,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Shadow color
                      spreadRadius: 2, // Spread radius
                      blurRadius: 6, // Blur radius
                      offset: Offset(0, 3), // Position of shadow (x, y)
                    ),
                  ],
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tilesData.length,
                  itemBuilder: (context, i) {
                    return Container(
                      width: tileWidth,
                      margin: EdgeInsets.only(right: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 6.0,
                          color: Color.fromARGB(0, 0, 0, 0),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0)),
                            child: Image.asset(
                              tilesData[i]['image'],
                              fit: BoxFit.cover,
                              height: tileHeight,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            tilesData[i]['title'],
                            textAlign: TextAlign.center,
                          )
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
                  border:
                      Border.all(width: 3.0, color: Color.fromARGB(0, 0, 0, 0)),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: Colors.black12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Widget Gambar untuk logo topi wisuda
                          Image.asset(
                            'assets/Images/graduation_hat.jpg', // pastikan file logo ada di folder assets
                            width: 24, // Sesuaikan ukuran gambar
                            height: 24,
                          ),
                          SizedBox(
                              width:
                                  10), // Memberikan jarak antara logo dan teks
                          Text(
                            'Eduham Online',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'The UIN Malang Informatic Engineering subject you can do from home!',
                        style: TextStyle(
                          fontSize: 12,
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
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Center(
                                          child: Container(
                                              child: Text("Learn More"))),
                                      content: Text(
                                          "Unfortunately, this feature is still on maintenance. Please contact support if the feature is still not working."),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text(
                                            "OK",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Menutup dialog
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                buttonPressCount++;
                              });
                              print(
                                  "Tombol telah dipencet sebanyak $buttonPressCount kali");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shadowColor:
                                  Colors.black, // Ubah warna shadow tombol
                              elevation: 8, // Ubah elevasi tombol
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10), // Ubah padding tombol
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // Ubah bentuk tombol menjadi lebih bulat
                              ),
                            ),
                            child: Text(
                              'Learn More',
                              style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.blueGrey),
                            ))),
                  ],
                ),
              ),
            ),

            // Image Tiles, Scrollable horizontal axis 2
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                height: tileContainerHeights,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Shadow color
                      spreadRadius: 2, // Spread radius
                      blurRadius: 6, // Blur radius
                      offset: Offset(0, 3), // Position of shadow (x, y)
                    ),
                  ],
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tilesDatas.length,
                  itemBuilder: (context, i) {
                    return Container(
                      width: tileWidths,
                      margin: EdgeInsets.only(right: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 6.0,
                          color: Color.fromARGB(0, 0, 0, 0),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0)),
                            child: Image.asset(
                              tilesDatas[i]['images'],
                              fit: BoxFit.cover,
                              height: tileHeights,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            tilesDatas[i]['titles'],
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // Content 4
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(width: 3.0, color: Color.fromARGB(0, 0, 0, 0)),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: Colors.black12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Widget Gambar untuk logo topi wisuda
                          Image.asset(
                            'assets/Images/Mic.jpg', // pastikan file logo ada di folder assets
                            width: 24, // Sesuaikan ukuran gambar
                            height: 24,
                          ),
                          SizedBox(
                              width:
                                  10), // Memberikan jarak antara logo dan teks
                          Text(
                            'The Hamilcast',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Fun conversation with the cast, crew, and creatives of Hamilton',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Button "Listen now"
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Center(
                                          child: Container(
                                              child: Text("Listen Now"))),
                                      content: Text(
                                          "Unfortunately, this feature is still on maintenance. Please contact support if the feature is still not working."),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text(
                                            "OK",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Menutup dialog
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                buttonPressCount++;
                              });
                              print(
                                  "Tombol telah dipencet sebanyak $buttonPressCount kali");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shadowColor:
                                  Colors.black, // Ubah warna shadow tombol
                              elevation: 7, // Ubah elevasi tombol
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10), // Ubah padding tombol
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // Ubah bentuk tombol menjadi lebih bulat
                              ),
                            ),
                            child: Text(
                              'Listen Now',
                              style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.blueGrey),
                            ))),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Baris ikon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Twitter icon
                      Image.asset(
                        'assets/Images/X.jpg',
                        width: 36.0,
                        height: 36.0,
                      ),
                      // Facebook icon
                      Image.asset(
                        'assets/Images/Facebook.png',
                        width: 36.0,
                        height: 36.0,
                      ),
                      // Instagram icon
                      Image.asset(
                        'assets/Images/Instagram.png',
                        width: 36.0,
                        height: 36.0,
                      ),
                      // YouTube icon
                      Image.asset(
                        'assets/Images/Youtube.png',
                        width: 36.0,
                        height: 36.0,
                      ),
                      // Hamilton icon (bintang)
                      Image.asset(
                        'assets/Images/Hamilton.png',
                        width: 36.0,
                        height: 36.0,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ]),
    );

    return Scaffold(
      appBar: AppbarContent,
      drawer: sideMenu,
      body: content,
      resizeToAvoidBottomInset: false,
    );
  }
}
