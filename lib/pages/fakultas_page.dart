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
  int _limit = 15;
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Fakultas berhasil ditambahkan")),
              );
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
        title: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.school_rounded, color: Colors.white),
                const SizedBox(
                    width:
                        8), // Mengurangi jarak agar lebih kompak di layar kecil
                Text(
                  constraints.maxWidth > 400
                      ? "Data Fakultas"
                      : "Data Fakultas",
                  style: TextStyle(
                      fontSize: constraints.maxWidth > 400 ? 20 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            );
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      body: Container(
        color: const Color(0xFFE0F7FA),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: RefreshIndicator(
                  onRefresh: _fetchFakultasData,
                  child: ListView.builder(
                    itemCount: _fakultasData.length + (_allFetched ? 0 : 1),
                    itemBuilder: (context, index) {
                      if (index == _fakultasData.length) {
                        return null;
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
                          leading: const Icon(Icons.school,
                              color: Colors.blueAccent),
                          title: Text(
                            fakultas["name"] ?? "N/A",
                            style: const TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                          onTap: () {
                            // Optional: Tambah detail fakultas saat di-tap
                          },
                        ),
                      );
                    },
                  ),
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
  bool _isNameValid = true;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameController.text.isEmpty) {
      setState(() {
        _isNameValid = false;
      });
      return;
    }
    final newFakultas = {"name": _nameController.text};
    widget.onSubmit(newFakultas);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type:
          MaterialType.transparency, // Material widget untuk menghindari error
      child: FractionallySizedBox(
        heightFactor: 0.3,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Tambah Fakultas",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Fakultas',
                  errorText:
                      _isNameValid ? null : 'Nama fakultas tidak boleh kosong',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.orangeAccent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (text) {
                  if (!_isNameValid && text.isNotEmpty) {
                    setState(() {
                      _isNameValid = true;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 32.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.orangeAccent,
                  elevation: 5,
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
