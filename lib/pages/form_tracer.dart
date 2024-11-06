import 'package:flutter/material.dart';
import 'package:tugas1_ui/api/service.dart';

class FormTracer extends StatefulWidget {
  const FormTracer({Key? key, required this.odoo}) : super(key: key);

  final OdooConnection odoo;

  @override
  _FormTracerState createState() => _FormTracerState();
}

class _FormTracerState extends State<FormTracer> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nimController = TextEditingController();
  final _tahunController = TextEditingController();
  final _emailController = TextEditingController();
  final _nomorController = TextEditingController();
  final _alamatController = TextEditingController();

  int? _selectedFakultas;
  int? _selectedProdi;
  String? _selectedStatus;

  List<dynamic> _fakultasData = [];
  List<dynamic> _prodiData = [];
  bool _prodiLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchFakultasData();
  }

  Future<void> _fetchFakultasData() async {
    try {
      final fakultas = await widget.odoo.getData(
        model: 'annas.fakultas',
        fields: ['id', 'name'],
      );
      setState(() {
        _fakultasData = fakultas;
      });
    } catch (e) {
      print("Error fetching fakultas data: $e");
    }
  }

  Future<void> _fetchProdiData(int fakultasId) async {
    setState(() {
      _prodiLoading = true;
      _prodiData.clear();
      _selectedProdi = null;
    });

    try {
      final prodi = await widget.odoo.getData(
        model: 'annas.prodi',
        fields: ['id', 'name'],
        domain: [
          ['fakultas_id', '=', fakultasId]
        ],
      );
      setState(() {
        _prodiData = prodi;
      });
    } catch (e) {
      print("Error fetching prodi data: $e");
    } finally {
      setState(() {
        _prodiLoading = false;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await widget.odoo.createRecord(
          model: 'annas.traceralumni',
          data: {
            "name": _nameController.text,
            "nim": _nimController.text,
            "tahun": _tahunController.text,
            "email": _emailController.text,
            "nomor": _nomorController.text,
            "alamat": _alamatController.text,
            "fakultas_id": _selectedFakultas,
            "prodi_id": _selectedProdi,
            "status": _selectedStatus,
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data alumni berhasil disimpan!')),
        );
        Navigator.pop(context); // Kembali ke halaman sebelumnya
      } catch (e) {
        print("Error creating tracer alumni record: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan data alumni.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form Tracer Alumni"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (value) =>
                    value!.isEmpty ? 'Nama harus diisi' : null,
              ),
              TextFormField(
                controller: _nimController,
                decoration: const InputDecoration(labelText: 'NIM'),
                validator: (value) => value!.isEmpty ? 'NIM harus diisi' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Tahun Lulus'),
                items: List.generate(
                  27,
                  (index) => DropdownMenuItem(
                    value: (2000 + index).toString(),
                    child: Text((2000 + index).toString()),
                  ),
                ),
                onChanged: (value) =>
                    setState(() => _tahunController.text = value!),
                validator: (value) =>
                    value == null ? 'Tahun lulus harus dipilih' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email Aktif'),
                validator: (value) =>
                    value!.isEmpty ? 'Email harus diisi' : null,
              ),
              TextFormField(
                controller: _nomorController,
                decoration: const InputDecoration(labelText: 'Nomor Telepon'),
                validator: (value) =>
                    value!.isEmpty ? 'Nomor telepon harus diisi' : null,
              ),
              TextFormField(
                controller: _alamatController,
                decoration: const InputDecoration(labelText: 'Alamat Rumah'),
                validator: (value) =>
                    value!.isEmpty ? 'Alamat harus diisi' : null,
              ),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Fakultas'),
                items: _fakultasData.map<DropdownMenuItem<int>>((fakultas) {
                  return DropdownMenuItem<int>(
                    value: fakultas['id'],
                    child: Text(fakultas['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFakultas = value;
                    if (value != null) _fetchProdiData(value);
                  });
                },
                validator: (value) =>
                    value == null ? 'Fakultas harus dipilih' : null,
              ),
              if (_prodiLoading)
                const CircularProgressIndicator()
              else
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Program Studi'),
                  items: _prodiData.map<DropdownMenuItem<int>>((prodi) {
                    return DropdownMenuItem<int>(
                      value: prodi['id'],
                      child: Text(prodi['name']),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedProdi = value),
                  validator: (value) =>
                      value == null ? 'Program studi harus dipilih' : null,
                ),
              DropdownButtonFormField<String>(
                decoration:
                    const InputDecoration(labelText: 'Status Anda saat ini'),
                items: const [
                  DropdownMenuItem(
                      value: 'working',
                      child: Text('Bekerja (full time/part time)')),
                  DropdownMenuItem(
                      value: 'entrepreneur', child: Text('Wiraswasta')),
                  DropdownMenuItem(
                      value: 'studying', child: Text('Melanjutkan pendidikan')),
                  DropdownMenuItem(
                      value: 'unemployed',
                      child: Text('Tidak bekerja, sedang mencari kerja')),
                ],
                onChanged: (value) => setState(() => _selectedStatus = value),
                validator: (value) =>
                    value == null ? 'Status harus dipilih' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Simpan Data Alumni'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
