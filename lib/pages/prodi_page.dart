import 'package:flutter/material.dart';
import 'package:tugas1_ui/api/service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProdiPage extends StatefulWidget {
  const ProdiPage({super.key});

  @override
  _ProdiPageState createState() => _ProdiPageState();
}

class _ProdiPageState extends State<ProdiPage> {
  late OdooConnection odoo;
  List<dynamic> _prodiData = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    odoo = OdooConnection(url: dotenv.env['URL'] ?? "");
    _fetchProdiData();
  }

  Future<void> _fetchProdiData() async {
    await odoo.auth(dotenv.env['DB'] ?? "", dotenv.env['USER'] ?? "",
        dotenv.env['PASS'] ?? "");
    _prodiData = await odoo.getData(
      model: 'annas.prodi',
      fields: ["name", "description", "fakultas_id", "kaprodi"],
      limit: 15,
    );
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prodi Data"),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFE0F7FA), // Aqua blue background
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: _prodiData.length,
                  itemBuilder: (context, index) {
                    final prodi = _prodiData[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      shadowColor: Colors.orange.withOpacity(0.3),
                      child: ListTile(
                        title: Text(
                          prodi["name"] ?? "N/A",
                          style: const TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "Fakultas: ${prodi["fakultas_id"][1]}\nKaprodi: ${prodi["kaprodi"]}",
                          style: const TextStyle(color: Colors.black54),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
