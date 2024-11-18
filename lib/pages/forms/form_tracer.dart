import 'package:flutter/material.dart';
import 'package:tugas1_ui/api/service.dart';

class FormTracer extends StatefulWidget {
  const FormTracer({Key? key, required this.odoo, this.alumni}) : super(key: key);

  final OdooConnection odoo;
  final Map<String, dynamic>? alumni;

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

    if (widget.alumni != null) {
      _nameController.text = widget.alumni!['name'] ?? '';
      _nimController.text = widget.alumni!['nim'] ?? '';
      _tahunController.text = widget.alumni!['tahun'] ?? '';
      _emailController.text = widget.alumni!['email'] ?? '';
      _nomorController.text = widget.alumni!['nomor'] ?? '';
      _alamatController.text = widget.alumni!['alamat'] ?? '';

      // Set selected fakultas
      final fakultas = widget.alumni!['fakultas'];
      if (fakultas is List && fakultas.isNotEmpty) {
        _selectedFakultas = fakultas[0]; // Assuming the first item is the ID
      } else {
        _selectedFakultas = fakultas; // If it's already an int
      }

      // Fetch prodi data using the selected fakultas
      if (_selectedFakultas != null) {
        _fetchProdiData(_selectedFakultas!);
      }

      // Set selected prodi if available
      final prodi = widget.alumni!['prodi'];
      if (prodi is List && prodi.isNotEmpty) {
        _selectedProdi = prodi[0]; // Assuming the first item is the ID
      } else {
        _selectedProdi = prodi; // If it's already an int
      }

      _selectedStatus = widget.alumni!['status'];
    }
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
        final alumniData = {
          "name": _nameController.text,
          "nim": _nimController.text,
          "tahun": _tahunController.text,
          "email": _emailController.text,
          "nomor": _nomorController.text,
          "alamat": _alamatController.text,
          "fakultas": _selectedFakultas,
          "prodi": _selectedProdi,
          "status": _selectedStatus,
        };
        
        if (widget.alumni == null) {
          // Buat record baru
          await widget.odoo.createRecord(model: 'annas.traceralumni', data: alumniData);
        } else {
          // Update record yang sudah ada
          await widget.odoo.updateRecord(model: 'annas.traceralumni', recordId: widget.alumni!['id'], data: alumniData);
        }
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
    key: _scaffoldKey,
    appBar: AppBar(
      title: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.assignment_outlined, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                constraints.maxWidth > 400
                    ? "Form Tracer Alumni"
                    : "Form Tracer",
                style: TextStyle(
                    fontSize: constraints.maxWidth > 400 ? 20 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          );
        },
      ),
      backgroundColor: Colors.orangeAccent,
      centerTitle: true,
    ),
    body: Container(
      color: Colors.white.withOpacity(0.95),
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            _buildTextField(_nameController, 'Nama', Icons.person),
            _buildTextField(_nimController, 'NIM', Icons.badge),
            const SizedBox(height: 10.0),
            DropdownButtonFormField<String>(
              value: _tahunController.text.isNotEmpty ? _tahunController.text : null,
              decoration: InputDecoration(
                labelText: 'Tahun Lulus',
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              items: List.generate(
                27,
                (index) => DropdownMenuItem(
                  value: (2000 + index).toString(),
                  child: Text((2000 + index).toString()),
                ),
              ),
              onChanged: (value) => setState(() => _tahunController.text = value!),
              validator: (value) => value == null ? 'Tahun lulus harus dipilih' : null,
            ),
            const SizedBox(height: 5.0),
            _buildTextField(_emailController, 'Email Aktif', Icons.email),
            _buildTextField(_nomorController, 'Nomor Telepon', Icons.phone),
            _buildTextField(_alamatController, 'Alamat Rumah', Icons.home),
            const SizedBox(height: 5.0),
            DropdownButtonFormField<int>(
              value: _selectedFakultas,
              decoration: InputDecoration(
                labelText: 'Fakultas',
                prefixIcon: Icon(Icons.school),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              items: _fakultasData.map<DropdownMenuItem<int>>((fakultas) {
                return DropdownMenuItem<int>(
                  value: fakultas['id'] as int,
                  child: Text(fakultas['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFakultas = value;
                  if (value != null) _fetchProdiData(value);
                });
              },
              validator: (value) => value == null ? 'Fakultas harus dipilih' : null,
            ),
            const SizedBox(height: 15.0),
            if (_prodiLoading)
              const Center(child: CircularProgressIndicator())
            else
              DropdownButtonFormField<int>(
                value: _selectedProdi,
                decoration: InputDecoration(
                  labelText: 'Program Studi',
                  prefixIcon: Icon(Icons.book),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                items: _prodiData.map<DropdownMenuItem<int>>((prodi) {
                  return DropdownMenuItem<int>(
                    value: prodi['id'] as int,
                    child: Text(prodi['name']),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedProdi = value),
                validator: (value) => value == null ? 'Program studi harus dipilih' : null,
              ),
              const SizedBox(height: 15.0),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: InputDecoration(
                labelText: 'Status Anda saat ini',
                prefixIcon: Icon(Icons.work),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'working', child: Text('Bekerja (full time/part time)')),
                DropdownMenuItem(value: 'entrepreneur', child: Text('Wiraswasta')),
                DropdownMenuItem(value: 'studying', child: Text('Melanjutkan pendidikan')),
                DropdownMenuItem(value: 'unemployed', child: Text('Tidak bekerja, sedang mencari kerja')),
              ],
              onChanged: (value) => setState(() => _selectedStatus = value),
              validator: (value) => value == null ? 'Status harus dipilih' : null,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
              ),
              child: const Text('Simpan Data Alumni'),
            ),
          ],
        ),
      ),
    )
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: (value) => value!.isEmpty ? '$labelText harus diisi' : null,
      ),
    );
  }
}
