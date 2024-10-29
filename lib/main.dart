import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tugas1_ui/api/service.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Odoo Integration Group 7',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: OdooHomePage(),
    );
  }
}

class OdooHomePage extends StatefulWidget {
  @override
  _OdooHomePageState createState() => _OdooHomePageState();
}

class _OdooHomePageState extends State<OdooHomePage> {
  late OdooConnection odoo;
  String url = dotenv.env['URL'] ?? "";
  String db = dotenv.env['DB'] ?? "";
  String user = dotenv.env['USER'] ?? "";
  String pass = dotenv.env['PASS'] ?? "";

  List<dynamic> _data = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    odoo = OdooConnection(url: url);
  }

  Future<void> _fetchData() async {
    setState(() {
      _loading = true;
    });

    try {
      var session = await odoo.auth(db, user, pass);
      print('Logged in as user: ${session.userName}');

      var tracers = await odoo.getData(model: 'annas.traceralumni', fields: ["name", "nim"]);

      setState(() {
        _data = tracers;
        _loading = false;
      });

      print(session);
      print(_data);
    } catch (e) {
      print('Failed to retrieve partners: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Tracer'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _loading ? null : _fetchData,
            child: _loading ? CircularProgressIndicator() : Text('Fetch Partners'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                final partner = _data[index];
                return ListTile(
                  title: Text(partner['name'] ?? 'Unknown Name'),
                  subtitle: Text(partner['nim'] ?? 'No NIM Detected'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}