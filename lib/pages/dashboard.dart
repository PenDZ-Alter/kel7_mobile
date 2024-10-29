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
        title: const Text('Odoo Data Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FakultasPage()),
                );
              },
              child: const Text('View Fakultas Data'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProdiPage()),
                );
              },
              child: const Text('View Prodi Data'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TracerAlumniPage()),
                );
              },
              child: const Text('View Tracer Alumni Data'),
            ),
          ],
        ),
      ),
    );
  }
}
