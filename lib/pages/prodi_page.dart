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
    await odoo.auth(dotenv.env['DB'] ?? "", dotenv.env['USER'] ?? "", dotenv.env['PASS'] ?? "");
    _prodiData = await odoo.getData(model: 'annas.prodi', fields: ["name", "description", "fakultas_id", "kaprodi"], limit: 15);
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Prodi Data")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _prodiData.length,
              itemBuilder: (context, index) {
                final prodi = _prodiData[index];
                return ListTile(
                  title: Text(prodi["name"] ?? "N/A"),
                  subtitle: Text("Fakultas: ${prodi["fakultas_id"][1]}"),
                  trailing: SizedBox(
                    width: 100,
                    child: Text("Kaprodi: ${prodi["kaprodi"]}")
                  ),
                );
              },
            ),
    );
  }
}
