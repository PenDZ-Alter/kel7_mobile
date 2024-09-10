import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  String? _selectedStatus;
  String? _selectedFakultas;
  String? _selectedProdi;

  List<String> _statuses = [
    'Bekerja (full time/part time)',
    'Wiraswasta',
    'Melanjutkan pendidikan',
    'Tidak kerja tetapi sedang mencari kerja'
  ];

  List<String> _opsiFakultas = [ "Saintek", "Manajemen" ];
  List <String> _opsiProdi = [];

  @override
  Widget build(BuildContext context) {
    AppBar appbarMenu = AppBar(
      title: const Text("Form Alumni"),
    );

    Container formContent = Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row untuk Nama dan NIM
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nama',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'NIM',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Row untuk Nomor Telepon dan Tahun Lulus
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Tahun Lulus',
                  ),
                  items: ['2020', '2021', '2022', '2023']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      // handle change
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nomor Telepon/HP',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Row untuk Email dan Alamat
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Alamat Rumah',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Row untuk Fakultas dan Prodi
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField(
                  decoration: const InputDecoration(
                    labelText: 'Fakultas',
                  ),
                  items: _opsiFakultas.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedFakultas = value;
                      _selectedProdi = null;
                      // Update daftar prodi berdasarkan fakultas yang dipilih
                      if (value == 'Saintek') {
                        _opsiProdi = ['Teknik Informatika', 'Teknik Arsitektur', 'Sistem Informasi'];
                      } else if (value == 'Manajemen') {
                        _opsiProdi = ['Manajemen'];
                      } else {
                        _opsiProdi = [];
                      }
                    });
                  },
                  value: _selectedFakultas,
                ),  
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Prodi',
                  ),
                  items: _opsiProdi.isNotEmpty ? 
                      _opsiProdi.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList() : [],
                  onChanged: (String? value) {
                    setState(() {
                      _selectedProdi = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Area Status
          const Text(
            'Jelaskan status Anda saat ini',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),

          // Opsi untuk Status
          Column(
            children: _statuses.map((status) {
              return RadioListTile<String>(
                title: Text(status),
                value: status,
                groupValue: _selectedStatus,
                onChanged: (String? value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: appbarMenu,
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [ formContent ],
      ),
    );
  }
}
