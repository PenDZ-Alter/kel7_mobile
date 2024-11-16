import 'package:flutter/material.dart';
import 'package:tugas1_ui/api/service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProdiPage extends StatefulWidget {
  const ProdiPage({Key? key}) : super(key: key);

  @override
  _ProdiPageState createState() => _ProdiPageState();
}

class _ProdiPageState extends State<ProdiPage> {
  late OdooConnection odoo;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> _prodiData = [];
  List<dynamic> _filteredProdiData = [];
  List<dynamic> _fakultasData = [];
  bool _loading = true;
  bool _fakultasLoading = true;
  int _limit = 20;
  int _offset = 0;
  bool _allFetched = false;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    odoo = OdooConnection(url: dotenv.env['URL'] ?? "");
    _fetchProdiData();
  }

  Future<void> _fetchProdiData() async {
    if (_allFetched) return;

    setState(() {
      _loading = true;
    });

    await odoo.auth(dotenv.env['DB'] ?? "", dotenv.env['USER'] ?? "",
        dotenv.env['PASS'] ?? "");

    final prodiData = await odoo.getData(
      model: 'annas.prodi',
      fields: ["name", "fakultas_id", "kaprodi", "kode_prodi"],
      limit: _limit,
      offset: _offset,
    );

    final fakultasData = await odoo.getData(
        model: 'annas.fakultas', fields: ["id", "name"], limit: 15);

    if (mounted) {
      setState(() {
        _loading = false;
        _fakultasLoading = false;
        _fakultasData = fakultasData;
        if (prodiData.isEmpty) {
          _allFetched = true;
        } else {
          _prodiData.addAll(prodiData);
          _filteredProdiData = _prodiData;
          _offset += _limit;
        }
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filteredProdiData = _prodiData.where((prodi) {
        final name = prodi["name"].toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
    });
  }

  void _openAddProdiModal() {
    if (!mounted)
      return; // Prevents accessing the context if the widget is not mounted.

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return ProdiFormModal(
          fakultasData: _fakultasData,
          onSubmit: (newProdi) async {
            try {
              final response = await odoo.createRecord(
                model: 'annas.prodi',
                data: newProdi,
              );
              if (response != null) {
                setState(() {
                  _prodiData.insert(0, newProdi);
                  _filteredProdiData = _prodiData;
                });
                // Wait briefly to allow UI to stabilize
                await Future.delayed(const Duration(milliseconds: 300));
                if (mounted)
                  Navigator.of(_scaffoldKey.currentContext!)
                      .pop(); // Close the modal after updating
                ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
                  const SnackBar(content: Text("Prodi berhasil ditambahkan")),
                );
              }
            } catch (e) {
              print("Error creating record : $e");
              if (mounted) {
                ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
                  SnackBar(content: Text("Failed to create record: $e")),
                );
              }
            }
          },
        );
      },
    );
  }

  String _getFakultasName(dynamic fakultasId) {
    if (fakultasId is List && fakultasId.length > 1) {
      return fakultasId[1].toString(); // Assuming it's a list with [ID, Name]
    } else if (fakultasId is int) {
      // If it's an ID, try to match with the name in `_fakultasData`
      final fakultas = _fakultasData.firstWhere(
        (f) => f['id'] == fakultasId,
        orElse: () => null,
      );
      return fakultas != null ? fakultas['name'] : "Unknown Fakultas";
    }
    return "Unknown Fakultas";
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
                const Icon(Icons.book_rounded, color: Colors.white),
                const SizedBox(
                    width:
                        8), // Mengurangi jarak agar lebih kompak di layar kecil
                Text(
                  constraints.maxWidth > 400
                      ? "Data Program Studi"
                      : "Data Program Studi",
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
                  hintText: 'Cari Prodi...',
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
                  : _filteredProdiData.isEmpty
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
                        ) // Loading indicator di atas
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 2.0, vertical: 6.0),
                          child: RefreshIndicator(
                            onRefresh: _fetchProdiData,
                            child: ListView.builder(
                              itemCount: _filteredProdiData.length +
                                  (_allFetched ? 0 : 1),
                              itemBuilder: (context, index) {
                                if (index == _filteredProdiData.length &&
                                    !_allFetched) {
                                  return null;
                                }
                                final prodi = _filteredProdiData[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                  shadowColor:
                                      Colors.orangeAccent.withOpacity(0.3),
                                  child: ListTile(
                                    title: Text(
                                      prodi["name"] ?? "N/A",
                                      style: const TextStyle(
                                        color: Colors.orangeAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 4),
                                        Text(
                                          "Fakultas: ${_getFakultasName(prodi["fakultas_id"])}\nKaprodi: ${prodi["kaprodi"]}",
                                          style: const TextStyle(
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                    contentPadding: const EdgeInsets.all(16),
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
        onPressed: _openAddProdiModal,
        child: const Icon(Icons.add),
        backgroundColor: Colors.orangeAccent,
      ),
    );
  }
}

class ProdiFormModal extends StatefulWidget {
  final List<dynamic> fakultasData;
  final Function(Map<String, dynamic>) onSubmit;

  const ProdiFormModal(
      {required this.fakultasData, required this.onSubmit, Key? key})
      : super(key: key);

  @override
  _ProdiFormModalState createState() => _ProdiFormModalState();
}

class _ProdiFormModalState extends State<ProdiFormModal> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _kodeProdiController = TextEditingController();
  final TextEditingController _kaprodiController = TextEditingController();
  int? _selectedFakultasId;
  bool _isNameValid = true;
  bool _isKodeProdiValid = true;
  bool _isKaprodiValid = true;

  // @override
  // void dispose() {
  //   _nameController.dispose();
  //   _kodeProdiController.dispose();
  //   _kaprodiController.dispose();
  //   super.dispose();
  // }

  void _submit() {
    setState(() {
      _isNameValid = _nameController.text.isNotEmpty;
      _isKodeProdiValid = _kodeProdiController.text.isNotEmpty;
      _isKaprodiValid = _kaprodiController.text.isNotEmpty;
    });

    if (_isNameValid &&
        _isKodeProdiValid &&
        _isKaprodiValid &&
        _selectedFakultasId != null) {
      final newProdi = {
        "name": _nameController.text,
        "kode_prodi": _kodeProdiController.text,
        "fakultas_id": _selectedFakultasId,
        "kaprodi": _kaprodiController.text,
      };
      widget.onSubmit(newProdi);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: FractionallySizedBox(
        heightFactor: 0.6,
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
                "Tambah Program Studi",
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
                  labelText: 'Nama Prodi',
                  errorText:
                      _isNameValid ? null : 'Nama prodi tidak boleh kosong',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _kodeProdiController,
                decoration: InputDecoration(
                  labelText: 'Kode Prodi',
                  errorText: _isKodeProdiValid
                      ? null
                      : 'Kode prodi tidak boleh kosong',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _selectedFakultasId,
                items: widget.fakultasData.map((fakultas) {
                  return DropdownMenuItem<int>(
                    value: fakultas['id'] as int,
                    child: Text(fakultas['name']),
                  );
                }).toList(),
                onChanged: (value) => setState(() {
                  _selectedFakultasId = value;
                }),
                decoration: const InputDecoration(
                  labelText: 'Fakultas',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _kaprodiController,
                decoration: InputDecoration(
                  labelText: 'Nama Kaprodi',
                  errorText: _isKaprodiValid
                      ? null
                      : 'Nama kaprodi tidak boleh kosong',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
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
