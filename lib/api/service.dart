import 'dart:convert';

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

  Future<bool> updateRecord({
    required String model,
    required int recordId,
    required Map<String, dynamic> data,
    Map<String, dynamic>? kwargs
  }) async {
    if (_session == null) {
      throw Exception("Not authenticated");
    }

    kwargs = kwargs ?? {};
    kwargs['context'] = kwargs['context'] ?? {};

    try {
      await _odoo.callKw({
        'model': model,
        'method': 'write',
        'args': [
          [recordId], // IDs of records to update
          data       // Values to update
        ],
        'kwargs': kwargs
      });
      return true;
    } on OdooException catch (err) {
      print('Error updating record: $err');
      return false;
    }
  }

  Future<bool> deleteRecord({
    required String model,
    required List<int> recordIds,
    Map<String, dynamic>? kwargs
  }) async {
    if (_session == null) {
      throw Exception("Not authenticated");
    }

    kwargs = kwargs ?? {};
    kwargs['context'] = kwargs['context'] ?? {};

    try {
      await _odoo.callKw({
        'model': model,
        'method': 'unlink',
        'args': [recordIds],
        'kwargs': kwargs
      });
      return true;
    } on OdooException catch (err) {
      print('Error deleting record: $err');
      return false;
    }
  }

  Future<bool> updateMultipleRecords({
    required String model,
    required List<int> recordIds,
    required Map<String, dynamic> data,
    Map<String, dynamic>? kwargs
  }) async {
    if (_session == null) {
      throw Exception("Not authenticated");
    }

    kwargs = kwargs ?? {};
    kwargs['context'] = kwargs['context'] ?? {};

    try {
      await _odoo.callKw({
        'model': model,
        'method': 'write',
        'args': [
          recordIds, // List of IDs to update
          data      // Values to update
        ],
        'kwargs': kwargs
      });
      return true;
    } on OdooException catch (err) {
      print('Error updating multiple records: $err');
      return false;
    }
  }

  // Debug
  Future<void> getFieldsInfo({ required String model }) async {
    if (_session == null) throw Exception("Not Authenticated!");

    try {
      // Call fields_get to retrieve all fields from the 'res.users' model
      final fields = await _odoo.callKw({
        'model': model,
        'method': 'fields_get',
        'args': [],
        'kwargs': {
          'attributes': ['string', 'help', 'type'] // Optional attributes to retrieve
        },
      });

      // Print out the fields or use them as needed
      String fieldsJSON = jsonEncode(fields);
      print(fieldsJSON);
    } on OdooException catch (e) {
      print('Error: $e');
    }
  }

  // Debug
  Future<void> getUsersInfo() async {
    try {
      // Define the fields you want to retrieve for each user
      List<String> fieldsToRetrieve = [
        'name',       // User's name
        'login',      // User's login
        'email',      // User's email
        'phone',      // User's phone number
        'groups_id'
        // Add other fields as needed
      ];

      // Use search_read to get user information
      final users = await _odoo.callKw({
        'model': 'res.users',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'fields': fieldsToRetrieve,
          'limit': 10,  // Optional: limit the number of records
        },
      });

      // Print out the user information
      print(users);
    } on OdooException catch (e) {
      print('Error: $e');
    }
  }

}
