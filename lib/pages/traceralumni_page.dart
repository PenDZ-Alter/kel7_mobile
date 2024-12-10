import 'package:flutter/material.dart';
import 'package:tugas1_ui/api/service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tugas1_ui/pages/forms/form_tracer.dart';

class TracerAlumniPage extends StatefulWidget {
  const TracerAlumniPage({super.key});

  @override
  _TracerAlumniPageState createState() => _TracerAlumniPageState();
}

class _TracerAlumniPageState extends State<TracerAlumniPage> {
  late OdooConnection odoo;
  List<dynamic> _traceralumniData = [];
  List<dynamic> _filteredTracerData = [];
  bool _loading = true;
  String _searchQuery = "";
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    odoo = OdooConnection(url: dotenv.env['URL'] ?? "");
    _filteredTracerData = [];
    _checkAdminStatus();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      await odoo.auth(dotenv.env['DB'] ?? "", dotenv.env['USER'] ?? "",
          dotenv.env['PASS'] ?? "");
      _traceralumniData = await odoo.getData(
        model: 'annas.traceralumni',
        fields: [
          'name',
          'nim',
          'tahun',
          'email',
          'nomor',
          'alamat',
          'fakultas',
          'prodi',
          'status'
        ],
      );
      _filteredTracerData =
          List.from(_traceralumniData); // Salin data awal ke filtered data
    } catch (e) {
      print("Error fetching initial data: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _checkAdminStatus() async {
    try {
      // Fetch user credentials
      final user = await odoo.getUser();
      
      // Check if the user is "Administrator"
      if (user.toLowerCase() == "administrator") {
        setState(() {
          _isAdmin = true; // Set flag to true if user is admin
        });
      }
    } catch (e) {
      print("Error checking admin status: $e");
    }
  }

  Future<void> _deleteTracer(int recordId, int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "Konfirmasi Hapus",
            style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: const Text(
            "Apakah anda yakin ingin menghapus data alumni ini?",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: const Text(
                    "Batal",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                TextButton(
                  child: const Text("Hapus",
                      style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    try {
                      final success = await odoo.deleteRecord(
                        model: 'annas.traceralumni',
                        recordIds: [recordId],
                      );
                      if (success) {
                        if (mounted) {
                          setState(() {
                            _traceralumniData.removeAt(index);
                            _filteredTracerData = _traceralumniData;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Data alumni berhasil dihapus")),
                          );
                        }
                      } else {
                        print("Failed when deleting data!");
                      }
                    } catch (e) {
                      print("Failed when deleting data : $e");
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Gagal menghapus alumni: $e")),
                        );
                      }
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showAddTracerAlumniForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormTracer(odoo: odoo)),
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filteredTracerData = _traceralumniData.where((traceralumni) {
        final name = traceralumni["name"]?.toLowerCase() ?? '';
        return name.contains(query.toLowerCase());
      }).toList();
    });
  }

  void _showEditTracerAlumniForm(BuildContext context, dynamic alumni) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormTracer(
          odoo: odoo,
          alumni: alumni, // Kirim data alumni untuk diedit
        ),
      ),
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
        backgroundColor: Colors.orangeAccent,
      ),
      body: Container(
        color: const Color(0xFFE0F7FA),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Cari Alumni...',
                  hintStyle: TextStyle(fontWeight: FontWeight.normal),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredTracerData.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.info_outline,
                                  size: 60, color: Colors.orange),
                              const SizedBox(height: 10),
                              const Text("Tidak ada data alumni.",
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 4.0),
                          child: RefreshIndicator(
                            onRefresh: _fetchData,
                            child: ListView.builder(
                              itemCount: _filteredTracerData.length,
                              itemBuilder: (context, index) {
                                final alumni = _filteredTracerData[index];
                                String nama =
                                    _filteredTracerData[index]['name'];
                                String NIM = _filteredTracerData[index]['nim'];
                                String Tahun =
                                    _filteredTracerData[index]['tahun'];
                                String tatus =
                                    _filteredTracerData[index]['status'];

                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 0.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                  shadowColor: Colors.orange.withOpacity(0.3),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(16),
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.orangeAccent,
                                      child: Icon(
                                        alumni["status"] == "working"
                                            ? Icons.work_outline
                                            : alumni["status"] == "studying"
                                                ? Icons.school
                                                : Icons.person,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Text(
                                      alumni["name"] ?? "N/A",
                                      style: const TextStyle(
                                        color: Colors.deepOrange,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 4),
                                        Text("NIM: ${alumni["nim"] ?? "N/A"}",
                                            style: TextStyle(
                                                color: Colors.grey[600])),
                                        Text(
                                            "Tahun: ${alumni["tahun"] ?? "N/A"}",
                                            style: TextStyle(
                                                color: Colors.grey[600])),
                                      ],
                                    ),
                                    trailing: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.orangeAccent),
                                    onTap: _isAdmin ? () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor:
                                                Colors.white.withOpacity(0.2),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            title: Text(
                                              "Detail Data $nama",
                                              style: TextStyle(
                                                  color: Colors.orangeAccent,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                            content: Text(
                                              "Mahasiswa $nama dengan NIM $NIM" +
                                                  "\nTelah lulus dari Universitas UIN Maulana Malik Ibrahim Malang pada tahun " +
                                                  "$Tahun" +
                                                  "\nYang dimana sekarang dia sedang menjalani " +
                                                  "$tatus",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                            actions: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  // Tombol Edit
                                                  TextButton(
                                                    onPressed: () {
                                                      _showEditTracerAlumniForm(context, alumni);
                                                    },
                                                    style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.blueAccent,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20,
                                                          vertical: 12),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      "Edit",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  // Tombol Delete
                                                  TextButton(
                                                    onPressed: () async {
                                                      Navigator.of(context)
                                                          .pop();
                                                      await _deleteTracer(
                                                          alumni['id'], index);
                                                    },
                                                    style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20,
                                                          vertical: 12),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  // Tombol Back
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // Tutup dialog
                                                    },
                                                    style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.deepPurple,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20,
                                                          vertical: 12),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      "Back",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } : null,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
            ),
          ],
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

class AlumniSearch extends SearchDelegate {
  final List<dynamic> alumniData;

  AlumniSearch(this.alumniData);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = alumniData.where((alumni) {
      final name = alumni["name"]?.toLowerCase() ?? '';
      final nim = alumni["nim"]?.toLowerCase() ?? '';
      return name.contains(query.toLowerCase()) ||
          nim.contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final alumni = results[index];
        return ListTile(
          title: Text(alumni["name"] ?? "N/A"),
          subtitle: Text("NIM: ${alumni["nim"] ?? "N/A"}"),
          onTap: () {
            close(context, alumni);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = alumniData.where((alumni) {
      final name = alumni["name"]?.toLowerCase() ?? '';
      final nim = alumni["nim"]?.toLowerCase() ?? '';
      return name.contains(query.toLowerCase()) ||
          nim.contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final alumni = suggestions[index];
        return ListTile(
          title: Text(alumni["name"] ?? "N/A"),
          subtitle: Text("NIM: ${alumni["nim"] ?? "N/A"}"),
          onTap: () {
            query = alumni["name"] ?? '';
            showResults(context);
          },
        );
      },
    );
  }
}
