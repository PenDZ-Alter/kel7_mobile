import 'package:flutter/material.dart';
import 'package:tugas1_ui/api/service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FakultasPage extends StatefulWidget {
  const FakultasPage({super.key});

  @override
  _FakultasPageState createState() => _FakultasPageState();
}

class _FakultasPageState extends State<FakultasPage> {
  late OdooConnection odoo;
  List<dynamic> _fakultasData = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    odoo = OdooConnection(url: dotenv.env['URL'] ?? "");
    _fetchFakultasData();
  }

  Future<void> _fetchFakultasData() async {
    await odoo.auth(dotenv.env['DB'] ?? "", dotenv.env['USER'] ?? "", dotenv.env['PASS'] ?? "");
    _fakultasData = await odoo.getData(model: 'annas.fakultas', fields: ["name", "description"]);
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fakultas Data")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _fakultasData.length,
              itemBuilder: (context, index) {
                final fakultas = _fakultasData[index];
                return ListTile(
                  title: Text(fakultas["name"] ?? "N/A")
                );
              },
            ),
    );
  }
}
