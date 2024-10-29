import 'package:flutter/material.dart';
import 'package:tugas1_ui/api/service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TracerAlumniPage extends StatefulWidget {
  const TracerAlumniPage({super.key});

  @override
  _TracerAlumniPageState createState() => _TracerAlumniPageState();
}

class _TracerAlumniPageState extends State<TracerAlumniPage> {
  late OdooConnection odoo;
  List<dynamic> _traceralumniData = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    odoo = OdooConnection(url: dotenv.env['URL'] ?? "");
    _fetchTracerAlumniData();
  }

  Future<void> _fetchTracerAlumniData() async {
    await odoo.auth(dotenv.env['DB'] ?? "", dotenv.env['USER'] ?? "",
        dotenv.env['PASS'] ?? "");
    _traceralumniData = await odoo.getData(
      model: 'annas.traceralumni',
      fields: ["name", "nim", "tahun", "email", "status"],
    );
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tracer Alumni Data"),
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
                  itemCount: _traceralumniData.length,
                  itemBuilder: (context, index) {
                    final alumni = _traceralumniData[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      shadowColor: Colors.orange.withOpacity(0.3),
                      child: ListTile(
                        title: Text(
                          alumni["name"] ?? "N/A",
                          style: const TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "NIM: ${alumni["nim"]}, Tahun: ${alumni["tahun"]}",
                          style: const TextStyle(color: Colors.black54),
                        ),
                        trailing: Text(
                          "Status: ${alumni["status"]}",
                          style: const TextStyle(color: Colors.orangeAccent),
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
