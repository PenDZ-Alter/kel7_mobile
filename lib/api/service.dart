import 'package:odoo_rpc/odoo_rpc.dart';

class OdooConnection {
  final OdooClient _odoo;
  var _session;

  OdooConnection({required String url}) :
    _odoo = OdooClient(url);

  Future<dynamic> auth(String db, String user, String pass) async {
    try {
      _session = await _odoo.authenticate(db, user, pass);
      return _session;
    } on OdooException catch (err) {
      print('Error: $err');
      _odoo.close();
      return null;
    }
  }

  Future<dynamic> getData({ required String model, required List<String> fields, int? limit, List<String>? domain }) async {
    if (_session == null) {
      throw Exception("Not authenticated");
    }

    try {
      return await _odoo.callKw({
        'model': model,
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'fields': fields,
          'domain' : domain ?? [],
          'limit': limit ?? 10,
        },
      });
    } on OdooException catch (err) {
      print('Error: $err');
      return null;
    }
  }
}
