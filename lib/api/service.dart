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
      return null;
    }
  }

  Future<dynamic> getData({ 
    required String model, 
    required List<String> fields, 
    int? limit, 
    int? offset,
    List<dynamic>? domain
    }) async {
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
          'offset': offset ?? 0
        },
      });
    } on OdooException catch (err) {
      print('Error: $err');
      return null;
    }
  }

  Future<dynamic> createRecord({
    required String model,
    required Map<String, dynamic> data,
    Map<String, dynamic>? kwargs
  }) async {
    if (_session == null) {
      throw Exception("Not authenticated");
    }

    kwargs = kwargs ?? {}; // Ensure kwargs is at least an empty map
    kwargs['context'] = kwargs['context'] ?? {}; // Set context if it's not present

    try {
      return await _odoo.callKw({
        'model': model,
        'method': 'create',
        'args': [data],
        'kwargs': kwargs
      });
    } on OdooException catch (err) {
      print('Error creating record: $err');
      return null;
    }
  }
}
