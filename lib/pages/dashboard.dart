import 'package:flutter/material.dart';
import 'fakultas_page.dart';
import 'prodi_page.dart';
import 'traceralumni_page.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.computer_rounded, color: Colors.white),
                const SizedBox(
                    width:
                        8), // Mengurangi jarak agar lebih kompak di layar kecil
                Text(
                  constraints.maxWidth > 400
                      ? "Dashboard Mahasiswa"
                      : "Dashboard Mahasiswa",
                  style:
                      TextStyle(fontSize: constraints.maxWidth > 400 ? 20 : 18),
                ),
              ],
            );
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.menu,
                    color: Colors.orangeAccent,
                  ),
                  SizedBox(
                      width:
                          8), // Tambahkan jarak antara ikon dan teks jika diperlukan
                  Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Flexible(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  shrinkWrap: true,
                  children: [
                    buildCard(
                      context,
                      title: 'Fakultas',
                      icon: Icons.school,
                      destinationPage: const FakultasPage(),
                    ),
                    buildCard(
                      context,
                      title: 'Prodi',
                      icon: Icons.book,
                      destinationPage: const ProdiPage(),
                    ),
                    buildCard(
                      context,
                      title: 'Tracer Alumni',
                      icon: Icons.people,
                      destinationPage: const TracerAlumniPage(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFE0F7FA),
    );
  }

  Card buildCard(BuildContext context,
      {required String title,
      required IconData icon,
      required Widget destinationPage}) {
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
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.orangeAccent, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
