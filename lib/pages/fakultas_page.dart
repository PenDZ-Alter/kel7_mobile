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
  List<dynamic> _FilteredfakultasData = [];
  bool _loading = true;
  int _limit = 15;
  int _offset = 0;
  bool _allFetched = false;
  String _searchQuery = "";
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    odoo = OdooConnection(url: dotenv.env['URL'] ?? "");
    _checkAdminStatus();
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

    if (mounted) {
      setState(() {
        _loading = false;
        if (newData.isEmpty) {
          _allFetched = true;
        } else {
          _fakultasData.addAll(newData);
          _FilteredfakultasData = _fakultasData;
          _offset += _limit;
        }
      });
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

  Future<void> deleteData(int id) async {
    try {
      await odoo.deleteRecord(model: 'annas.fakultas', recordIds: [id]);
    } catch (err) {
      print(err);
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _FilteredfakultasData = _fakultasData.where((fakultas) {
        final name = fakultas["name"].toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
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
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Fakultas berhasil ditambahkan")),
                );
              }
            }
          },
        );
      },
    );
  }

  void _openEditFakultasModal(String? id, String? name) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return FakultasFormModal(
          initialData: {"id": id, "name": name},
          onSubmit: (data) async {
            final response = await odoo.updateRecord(
              model: "annas.fakultas",
              recordId: int.parse(data['id']),
              data: {"name": data['name']},
            );
            if (response != null) {
              // setState(() {
              //   _fakultasData.insert(0, data);
              // });
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Fakultas berhasil diedit")),
                );
              }
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Cari Fakultas...',
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
                  : _FilteredfakultasData.isEmpty
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
                          child: _isAdmin ? RefreshIndicator(
                            onRefresh: _fetchFakultasData,
                            child: ListView.builder(
                              itemCount: _FilteredfakultasData.length +
                                  (_allFetched ? 0 : 1),
                              itemBuilder: (context, index) {
                                if (index == _FilteredfakultasData.length &&
                                    !_allFetched) {
                                  return null;
                                }
                                final fakultas = _FilteredfakultasData[index];
                                return Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                  shadowColor: Colors.orange.withOpacity(0.3),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.school,
                                            color: Colors.orangeAccent),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            fakultas["name"] ?? "N/A",
                                            style: const TextStyle(
                                              color: Colors.orangeAccent,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: Colors.blue),
                                          onPressed: () =>
                                              _openEditFakultasModal(
                                                  fakultas['id'].toString(),
                                                  fakultas['name']),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  backgroundColor: Colors.white
                                                      .withOpacity(0.2),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16)),
                                                  title: const Text(
                                                    "Konfirmasi Hapus",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors
                                                            .orangeAccent),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  content: Text(
                                                    "Apakah anda yakin ingin menghapus data ${fakultas["name"]}?",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  actions: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          style: TextButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .redAccent,
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          20,
                                                                      vertical:
                                                                          12),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  )),
                                                          child: const Text(
                                                            "Batal",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    backgroundColor: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.2),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(16)),
                                                                    title: Text(
                                                                      "Data " +
                                                                          fakultas[
                                                                              "name"],
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .orangeAccent,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                    content:
                                                                        Text(
                                                                      "Data " +
                                                                          fakultas[
                                                                              "name"] +
                                                                          " berhasil dihapus!!",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                    actions: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          TextButton(
                                                                            onPressed:
                                                                                Navigator.of(context).pop,
                                                                            style: TextButton.styleFrom(
                                                                                backgroundColor: Colors.blueAccent,
                                                                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(8),
                                                                                )),
                                                                            child:
                                                                                const Text(
                                                                              "OK",
                                                                              style: TextStyle(color: Colors.white),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  );
                                                                });
                                                            setState(() {
                                                              _FilteredfakultasData
                                                                  .remove(
                                                                      fakultas);
                                                            });
                                                            await deleteData(
                                                                fakultas['id']);
                                                            await _fetchFakultasData();
                                                          },
                                                          style: TextButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.blue,
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        12),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                          ),
                                                          child: const Text(
                                                            "Hapus",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ) : const Text("You're not an admin!"),
                        ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: _isAdmin ? FloatingActionButton(
        onPressed: _openAddFakultasModal,
        child: const Icon(Icons.add),
        backgroundColor: Colors.orangeAccent,
      ) : null,
    );
  }
}

class FakultasFormModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;
  final Map<String, dynamic>? initialData; // Optional parameter for edit mode

  const FakultasFormModal({required this.onSubmit, this.initialData, Key? key})
      : super(key: key);

  @override
  _FakultasFormModalState createState() => _FakultasFormModalState();
}

class _FakultasFormModalState extends State<FakultasFormModal> {
  final TextEditingController _nameController = TextEditingController();
  bool _isNameValid = true;

  @override
  void initState() {
    super.initState();
    // Populate the controller with initial data for editing
    if (widget.initialData != null) {
      _nameController.text = widget.initialData!['name'] ?? '';
    }
  }

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

    final updatedFakultas = {"name": _nameController.text};

    // Include the ID if editing an existing record
    if (widget.initialData != null) {
      updatedFakultas['id'] = widget.initialData!['id'].toString();
    }

    widget.onSubmit(updatedFakultas);
    Navigator.of(context).pop();
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.3),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "Konfirmasi Update",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.orangeAccent),
            textAlign: TextAlign.center,
          ),
          content: const Text(
            "Apakah Anda yakin ingin mengupdate data ini?",
            style: TextStyle(fontSize: 14, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    "Tidak",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      _submit();
                      
                    }, // Proceed with update
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      "Ya",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: FractionallySizedBox(
        heightFactor: 0.3,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
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
              Text(
                widget.initialData == null
                    ? "Tambah Data Fakultas"
                    : "Edit Data Fakultas",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
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
                onPressed: widget.initialData == null
                    ? _submit
                    : _showConfirmationDialog, // Call the confirmation dialog
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 32.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.orangeAccent,
                  elevation: 5,
                ),
                child: Text(
                  widget.initialData == null ? "Submit" : "Update",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
