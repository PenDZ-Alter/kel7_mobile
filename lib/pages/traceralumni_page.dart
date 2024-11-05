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
  List<dynamic> _fakultasData = [];
  List<dynamic> _prodiData = [];
  bool _loading = true;
  bool _fakultasLoading = true;
  bool _prodiLoading = false; // Default to false to avoid unnecessary spinner

  int? selectedFakultasId;
  int? selectedProdiId;

  @override
  void initState() {
    super.initState();
    odoo = OdooConnection(url: dotenv.env['URL'] ?? "");
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      await odoo.auth(dotenv.env['DB'] ?? "", dotenv.env['USER'] ?? "", dotenv.env['PASS'] ?? "");

      // Fetch Tracer Alumni data
      _traceralumniData = await odoo.getData(
        model: 'annas.traceralumni',
        fields: ["name", "nim", "tahun", "email", "status"],
      );

      // Fetch Fakultas data
      _fakultasData = await odoo.getData(
        model: 'annas.fakultas',
        fields: ["id", "name"],
      );
    } catch (e) {
      print("Error fetching initial data: $e");
    } finally {
      setState(() {
        _loading = false;
        _fakultasLoading = false;
      });
    }
  }

  Future<void> _fetchProdiData(int fakultasId) async {
    setState(() {
      _prodiLoading = true;
      _prodiData.clear(); // Clear existing data to reset dropdown options
      selectedProdiId = null;
    });

    try {
      // Fetch Prodi data filtered by selected Fakultas
      _prodiData = await odoo.getData(
        model: 'annas.prodi',
        fields: ["id", "name"],
        domain: [
          ['fakultas_id', '=', fakultasId]
        ],
      );
    } catch (e) {
      print("Error fetching prodi data: $e");
    } finally {
      setState(() {
        _prodiLoading = false;
      });
    }
  }

  Future<void> _createTracerAlumniRecord(
    String name,
    String nim,
    String tahun,
    String email,
    String nomor,
    String alamat,
    int fakultasId,
    int prodiId,
    String status,
  ) async {
    try {
      final newRecord = await odoo.createRecord(
        model: 'annas.traceralumni',
        data: {
          "name": name,
          "nim": nim,
          "tahun": tahun,
          "email": email,
          "nomor": nomor,
          "alamat": alamat,
          "fakultas_id": fakultasId,
          "prodi_id": prodiId,
          "status": status,
        },
      );
      if (newRecord != null) {
        _fetchData(); // Refresh data after creation
      }
    } catch (e) {
      print("Error creating tracer alumni record: $e");
    }
  }

  void _showAddTracerAlumniForm(BuildContext context) {
    final nameController = TextEditingController();
    final nimController = TextEditingController();
    final tahunController = TextEditingController();
    final emailController = TextEditingController();
    final nomorController = TextEditingController();
    final alamatController = TextEditingController();
    String? selectedStatus;

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
                    decoration: const InputDecoration(labelText: 'Nama'),
                  ),
                  TextField(
                    controller: nimController,
                    decoration: const InputDecoration(labelText: 'NIM'),
                  ),
                  TextField(
                    controller: tahunController,
                    decoration: const InputDecoration(labelText: 'Tahun Lulus'),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email Aktif'),
                  ),
                  TextField(
                    controller: nomorController,
                    decoration: const InputDecoration(labelText: 'Nomor Telepon'),
                  ),
                  TextField(
                    controller: alamatController,
                    decoration: const InputDecoration(labelText: 'Alamat Rumah'),
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
                              if (value != null) {
                                _fetchProdiData(value);
                              }
                            });
                          },
                        ),
                  _prodiLoading
                      ? const CircularProgressIndicator()
                      : DropdownButtonFormField<int>(
                          value: selectedProdiId,
                          decoration: const InputDecoration(labelText: 'Program Studi'),
                          items: _prodiData.map((prodi) {
                            return DropdownMenuItem<int>(
                              value: prodi["id"],
                              child: Text(prodi["name"]),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedProdiId = value;
                              if (value != null) {
                                _fetchProdiData(value); // Fetch prodi data based on selected fakultas in real-time
                              }
                            });
                          },
                        ),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: const InputDecoration(labelText: 'Status Saat Ini'),
                    items: const [
                      DropdownMenuItem(value: 'working', child: Text('Bekerja (full time/part time)')),
                      DropdownMenuItem(value: 'entrepreneur', child: Text('Wiraswasta')),
                      DropdownMenuItem(value: 'studying', child: Text('Melanjutkan pendidikan')),
                      DropdownMenuItem(value: 'unemployed', child: Text('Tidak kerja tetapi sedang mencari kerja')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedFakultasId != null && selectedProdiId != null && selectedStatus != null) {
                        _createTracerAlumniRecord(
                          nameController.text,
                          nimController.text,
                          tahunController.text,
                          emailController.text,
                          nomorController.text,
                          alamatController.text,
                          selectedFakultasId!,
                          selectedProdiId!,
                          selectedStatus!,
                        );
                        Navigator.pop(ctx);
                      }
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
        title: const Text("Tracer Alumni Data"),
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
                        subtitle: Text("NIM: ${alumni["nim"] ?? "N/A"}\nTahun: ${alumni["tahun"] ?? "N/A"}"),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {},
                      ),
                    );
                  },
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTracerAlumniForm(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
