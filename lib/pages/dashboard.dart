import 'package:flutter/material.dart';
import 'fakultas_page.dart';
import 'prodi_page.dart';
import 'traceralumni_page.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final double cardSize = MediaQuery.of(context).size.width * 0.35;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Odoo Data Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent, // Warna oranye pada AppBar
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Menu',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent, // Warna oranye untuk judul utama
                ),
              ),
              const SizedBox(height: 20),

              // GridView untuk menampilkan button cards
              Flexible(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  shrinkWrap: true,
                  children: [
                    // Fakultas Data Card
                    buildCard(
                      context,
                      title: 'View Fakultas Data',
                      destinationPage: const FakultasPage(),
                    ),

                    // Prodi Data Card
                    buildCard(
                      context,
                      title: 'View Prodi Data',
                      destinationPage: const ProdiPage(),
                    ),

                    // Tracer Alumni Data Card
                    buildCard(
                      context,
                      title: 'View Tracer Alumni Data',
                      destinationPage: const TracerAlumniPage(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFE0F7FA), // Warna biru aqua yang lembut
    );
  }

  // Fungsi bantuan untuk membuat kartu menu
  Card buildCard(BuildContext context,
      {required String title, required Widget destinationPage}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 6,
      shadowColor: Colors.orange.withOpacity(0.3),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destinationPage),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.orangeAccent, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
