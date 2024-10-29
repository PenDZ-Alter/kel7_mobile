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
  List<dynamic> _fakultasData = [];
  bool _loading = true;
  bool _fakultasLoading = true;

  @override
  void initState() {
    super.initState();
    odoo = OdooConnection(url: dotenv.env['URL'] ?? "");
    _fetchData();
  }

  Future<void> _fetchData() async {
    await odoo.auth(dotenv.env['DB'] ?? "", dotenv.env['USER'] ?? "", dotenv.env['PASS'] ?? "");

    final prodiData = await odoo.getData(
      model: 'annas.prodi',
      fields: ["name", "fakultas_id", "kaprodi"],
      limit: 20,
    );

    final fakultasData = await odoo.getData(
      model: 'annas.fakultas',
      fields: ["id", "name"],
      limit: 20,
    );

    setState(() {
      _prodiData = prodiData;
      _fakultasData = fakultasData;
      _loading = false;
      _fakultasLoading = false;
    });
  }

  Future<void> _createProdiRecord(String name, String kodeProdi, int fakultasId, String kaprodi) async {
    final newRecord = await odoo.createRecord(
      model: 'annas.prodi',
      data: {
        "name": name,
        "kode_prodi": kodeProdi,
        "fakultas_id": fakultasId,
        "kaprodi": kaprodi,
      },
    );
    if (newRecord != null) {
      _fetchData(); // Refresh the data after creation
    }
  }

  void _showAddProdiForm(BuildContext context) {
    final nameController = TextEditingController();
    final kodeProdiController = TextEditingController();
    final kaprodiController = TextEditingController();

    int? selectedFakultasId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Program Studi'),
                  ),
                  TextField(
                    controller: kodeProdiController,
                    decoration: const InputDecoration(labelText: 'Kode Program Studi'),
                  ),
                  _fakultasLoading
                      ? const CircularProgressIndicator()
                      : DropdownButtonFormField<int>(
                          value: selectedFakultasId,
                          decoration: const InputDecoration(labelText: 'Fakultas'),
                          items: _fakultasData.map((fakultas) {
                            return DropdownMenuItem<int>(
                              value: fakultas["id"],
                              child: Text(fakultas["name"]),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedFakultasId = value;
                            });
                          },
                        ),
                  TextField(
                    controller: kaprodiController,
                    decoration: const InputDecoration(labelText: 'Ketua Program Studi'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _createProdiRecord(
                        nameController.text,
                        kodeProdiController.text,
                        selectedFakultasId!,
                        kaprodiController.text,
                      );
                      Navigator.pop(ctx);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prodi Data"),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProdiForm(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
