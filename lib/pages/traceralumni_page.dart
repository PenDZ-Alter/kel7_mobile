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
    await odoo.auth(dotenv.env['DB'] ?? "", dotenv.env['USER'] ?? "", dotenv.env['PASS'] ?? "");
    _traceralumniData = await odoo.getData(model: 'annas.traceralumni', fields: ["name", "nim", "tahun", "email", "status"]);
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tracer Alumni Data")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _traceralumniData.length,
              itemBuilder: (context, index) {
                final alumni = _traceralumniData[index];
                return ListTile(
                  title: Text(alumni["name"] ?? "N/A"),
                  subtitle: Text("NIM: ${alumni["nim"]}, Tahun: ${alumni["tahun"]}"),
                  trailing: SizedBox(
                    width: 150,
                    child: Text("Status: ${alumni["status"]}")
                  ),
                );
              },
            ),
    );
  }
}
