import 'package:flutter/material.dart';
import 'package:tugas1_ui/api/service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FakultasPage extends StatefulWidget {
  const FakultasPage({Key? key}) : super(key: key);

  @override
  _FakultasPageState createState() => _FakultasPageState();
}

class _FakultasPageState extends State<FakultasPage> {
  late OdooConnection odoo;
  List<dynamic> _fakultasData = [];
  bool _loading = true;
  int _limit = 10;
  int _offset = 0;
  bool _allFetched = false;

  @override
  void initState() {
    super.initState();
    odoo = OdooConnection(url: dotenv.env['URL'] ?? "");
    _fetchFakultasData();
  }

  Future<void> _fetchFakultasData() async {
    if (_allFetched) return;

    setState(() {
      _loading = true;
    });

    await odoo.auth(dotenv.env['DB'] ?? "", dotenv.env['USER'] ?? "",
        dotenv.env['PASS'] ?? "");
    final newData = await odoo.getData(
      model: 'annas.fakultas',
      fields: ["name"],
      limit: _limit,
      offset: _offset,
    );

    setState(() {
      _loading = false;
      if (newData.isEmpty) {
        _allFetched = true;
      } else {
        _fakultasData.addAll(newData);
        _offset += _limit;
      }
    });
  }

  void _openAddFakultasModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FakultasFormModal(
          onSubmit: (newFakultas) async {
            final response = await odoo.createRecord(
              model: 'annas.fakultas',
              data: newFakultas,
            );
            if (response != null) {
              setState(() {
                _fakultasData.insert(0, newFakultas);
              });
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fakultas Data"),
        backgroundColor: Colors.orangeAccent, // Warna oranye untuk konsistensi
        centerTitle: true,
      ),
      body: Container(
        color:
            const Color(0xFFE0F7FA), // Warna biru aqua sebagai latar belakang
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: _fakultasData.length + (_allFetched ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (index == _fakultasData.length) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final fakultas = _fakultasData[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      shadowColor: Colors.orange.withOpacity(0.3),
                      child: ListTile(
                        title: Text(
                          fakultas["name"] ?? "N/A",
                          style: const TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    );
                  },
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddFakultasModal,
        child: const Icon(Icons.add),
        backgroundColor: Colors.orangeAccent,
      ),
    );
  }
}

class FakultasFormModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const FakultasFormModal({required this.onSubmit, Key? key}) : super(key: key);

  @override
  _FakultasFormModalState createState() => _FakultasFormModalState();
}

class _FakultasFormModalState extends State<FakultasFormModal> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    final newFakultas = {"name": _nameController.text};
    widget.onSubmit(newFakultas);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Fakultas"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Fakultas Name',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orangeAccent),
              ),
            ),
          )
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orangeAccent,
          ),
          child: const Text("Submit"),
        ),
      ],
    );
  }
}
