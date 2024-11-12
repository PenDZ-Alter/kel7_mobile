import 'package:flutter/material.dart';
import 'package:tugas1_ui/api/service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tugas1_ui/pages/form_tracer.dart';

class TracerAlumniPage extends StatefulWidget {
  const TracerAlumniPage({super.key});

  @override
  _TracerAlumniPageState createState() => _TracerAlumniPageState();
}

class _TracerAlumniPageState extends State<TracerAlumniPage> {
  late OdooConnection odoo;
  List<dynamic> _traceralumniData = [];
  List<dynamic> _filteredTraceralumniData = [];
  List<dynamic> _fakultasData = [];
  List<dynamic> _prodiData = [];
  bool _loading = true;
  bool _fakultasLoading = true;
  bool _prodiLoading = false;
  String _searchQuery = "";

  int? selectedFakultasId;
  int? selectedProdiId;

  @override
  void initState() {
    super.initState();
    odoo = OdooConnection(url: dotenv.env['URL'] ?? "");
    _filteredTraceralumniData = [];
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      await odoo.auth(dotenv.env['DB'] ?? "", dotenv.env['USER'] ?? "",
          dotenv.env['PASS'] ?? "");

      // Fetch Tracer Alumni data
      _traceralumniData = await odoo.getData(
        model: 'annas.traceralumni',
        fields: ["name", "nim", "tahun", "email", "status"],
      );

      // Initialize filtered data
      _filteredTraceralumniData = List.from(_traceralumniData);

      // Fetch Fakultas data
      _fakultasData = await odoo.getData(
        model: 'annas.fakultas',
        fields: ["id", "name"],
      );
    } catch (e) {
      print("Error fetching initial data: $e");
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
          _fakultasLoading = false;
        });
      }
    }
  }

  Future<void> _fetchProdiData(int fakultasId) async {
    setState(() {
      _prodiLoading = true;
      _prodiData.clear();
      selectedProdiId = null;
    });

    try {
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
          "fakultas": fakultasId,
          "prodi": prodiId,
          "status": status,
        },
      );
      if (newRecord != null) {
        _fetchData(); // Refresh data after creation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data alumni berhasil disimpan!')),
        );
      }
    } catch (e) {
      print("Error creating tracer alumni record: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan data alumni.')),
      );
    }
  }

  void _showAddTracerAlumniForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormTracer(odoo: odoo),
      ),
    );
  }

  void _onSearchChanged(String query) {
  setState(() {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredTraceralumniData = List.from(_traceralumniData);
    } else {
      _filteredTraceralumniData = _traceralumniData.where((tracer) {
        final name = tracer["name"]?.toString().toLowerCase() ?? '';
        final nim = tracer["nim"]?.toString().toLowerCase() ?? '';
        return name.contains(query.toLowerCase()) || 
               nim.contains(query.toLowerCase());
      }).toList();
    }
  });
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
                const Icon(Icons.people_rounded, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  constraints.maxWidth > 400 ? "Data Alumni" : "Data Alumni",
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
        backgroundColor: Colors.orangeAccent
      ),
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _traceralumniData.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info, size: 50, color: Colors.orange),
                        const SizedBox(height: 10),
                        const Text(
                          "Tidak ada data alumni.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextField(
                            onChanged: _onSearchChanged,
                            decoration: InputDecoration(
                              hintText: 'Cari Alumni...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: _fetchData,
                            child: Builder(
                              builder: (context) {
                                final displayData = _searchQuery.isEmpty 
                                    ? _traceralumniData 
                                    : _filteredTraceralumniData;
                                
                                if (displayData.isEmpty) {
                                  return Center(
                                    child: Text(
                                      _searchQuery.isEmpty 
                                          ? "Tidak ada data alumni" 
                                          : "Tidak ada hasil pencarian",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  itemCount: displayData.length,
                                  itemBuilder: (context, index) {
                                    final alumni = displayData[index];
                                    return Card(
                                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 4,
                                      shadowColor: Colors.orange.withOpacity(0.3),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 16),
                                        title: Text(
                                          alumni["name"] ?? "N/A",
                                          style: const TextStyle(
                                            color: Colors.deepPurple,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "NIM: ${alumni["nim"] ?? "N/A"}\nTahun: ${alumni["tahun"] ?? "N/A"}",
                                          style: const TextStyle(color: Colors.grey),
                                        ),
                                        trailing: Icon(
                                          alumni["status"] == "working"
                                              ? Icons.work
                                              : alumni["status"] == "studying"
                                                  ? Icons.school
                                                  : Icons.person,
                                          color: Colors.orangeAccent,
                                        ),
                                        onTap: () {},
                                      ),
                                    );
                                  },
                                );
                              }
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        onPressed: () => _showAddTracerAlumniForm(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}