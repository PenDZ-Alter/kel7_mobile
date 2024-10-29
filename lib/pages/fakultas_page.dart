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

    await odoo.auth(dotenv.env['DB'] ?? "", dotenv.env['USER'] ?? "", dotenv.env['PASS'] ?? "");
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

  // Function to open modal form
  void _openAddFakultasModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FakultasFormModal(
          onSubmit: (newFakultas) async {
            // Call to create new fakultas in Odoo
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
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _openAddFakultasModal,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _fakultasData.length + (_allFetched ? 0 : 1),
        itemBuilder: (context, index) {
          if (index == _fakultasData.length) {
            return null;
          }
          final fakultas = _fakultasData[index];
          return ListTile(
            title: Text(fakultas["name"] ?? "N/A")
          );
        },
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
    final newFakultas = {
      "name": _nameController.text
    };
    widget.onSubmit(newFakultas);
    Navigator.of(context).pop(); // Close modal
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
            decoration: const InputDecoration(labelText: 'Fakultas Name'),
          )
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: _submit,
          child: const Text("Submit"),
        ),
      ],
    );
  }
}
