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
  List<dynamic> _filteredTracerData = [];
  bool _loading = true;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    odoo = OdooConnection(url: dotenv.env['URL'] ?? "");
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      await odoo.auth(dotenv.env['DB'] ?? "", dotenv.env['USER'] ?? "",
          dotenv.env['PASS'] ?? "");
      _traceralumniData = await odoo.getData(
        model: 'annas.traceralumni',
        fields: ["name", "nim", "tahun", "email", "status"],
      );
      _filteredTracerData =
          List.from(_traceralumniData); // Salin data awal ke filtered data
    } catch (e) {
      print("Error fetching initial data: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showAddTracerAlumniForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormTracer(odoo: odoo)),
    );
  }

  // void _showSearch() {
  //   showSearch(context: context, delegate: AlumniSearch(_traceralumniData));
  // }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filteredTracerData = _traceralumniData.where((traceralumni) {
        final name = traceralumni["name"]?.toLowerCase() ?? '';
        return name.contains(query.toLowerCase());
      }).toList();
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
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
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
                          padding: const EdgeInsets.all(16.0),
                          child: RefreshIndicator(
                            onRefresh: _fetchData,
                            child: ListView.builder(
                              itemCount: _filteredTracerData.length,
                              itemBuilder: (context, index) {
                                final alumni = _filteredTracerData[index];
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 5,
                                  shadowColor: Colors.orange.withOpacity(0.3),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
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
                                    onTap: () {
                                      // Implement action when an alumni item is tapped
                                    },
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
