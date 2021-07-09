import 'dart:io';
import 'package:flutter/material.dart';
import '../utils/db_utils.dart';
import '../models/clients.dart';
import '../models/enums/payment_frequency.dart';

class Clients with ChangeNotifier {
  List<Client> _items = [];

  List<Client> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadClients(String filter) async {
    final rowList = await DbUtil.getDataByName('clients', filter, 'name');

    _items = rowList
        .map(
          (row) => Client(
            id: row['id'],
            name: row['name'],
            email: row['email'],
            telephone: row['telephone'],
            address: row['address'],
            birthDate: row['birthDate'] == null
                ? null
                : DateTime.parse(row['birthDate']),
            startDate: row['startDate'] == null
                ? null
                : DateTime.parse(row['startDate']),
            photoFile: row['photoFile'] == null ? null : File(row['photoFile']),
            paymentFrequency: row['paymentFrequency'] == null
                ? null
                : PaymentFrequency.values[row['paymentFrequency']],
          ),
        )
        .toList();

    notifyListeners();

    return Future.value();
  }

  Future<void> addClient(Client newClient) async {
    int newId = await DbUtil.insert('clients', {
      'name': newClient.name,
      'email': newClient.email,
      'telephone': newClient.telephone,
      'address': newClient.address,
      'birthDate': newClient.birthDate == null
          ? null
          : newClient.birthDate.toIso8601String(),
      'startDate': newClient.startDate == null
          ? null
          : newClient.startDate.toIso8601String(),
      'photoFile':
          newClient.photoFile == null ? null : newClient.photoFile.path,
      'paymentFrequency': newClient.paymentFrequency.index,
    });
    Client workClient = new Client(
      id: newId,
      name: newClient.name,
      email: newClient.email,
      telephone: newClient.telephone,
      address: newClient.address,
      birthDate: newClient.birthDate,
      startDate: newClient.startDate,
      photoFile: newClient.photoFile,
      paymentFrequency: newClient.paymentFrequency,
    );
    _items.add(workClient);

    notifyListeners();
  }

  Future<void> updateClient(Client client) async {
    if (client == null || client.id == null) {
      return;
    }

    final index = _items.indexWhere((item) => item.id == client.id);

    if (index >= 0) {
      final _oldPhotoFile = _items[index].photoFile;
      final _oldPhotoFilePath =
          _items[index].photoFile == null ? null : _items[index].photoFile.path;
      final _newPhotoFilePath =
          client.photoFile == null ? null : client.photoFile.path;
      _items[index] = client;

      DbUtil.update(
          'clients',
          {
            'name': client.name,
            'email': client.email,
            'telephone': client.telephone,
            'address': client.address,
            'birthDate': client.birthDate == null
                ? null
                : client.birthDate.toIso8601String(),
            'startDate': client.startDate == null
                ? null
                : client.startDate.toIso8601String(),
            'photoFile': _newPhotoFilePath,
            'paymentFrequency': client.paymentFrequency == null
                ? null
                : client.paymentFrequency.index,
          },
          client.id);

      if (_oldPhotoFilePath != null) {
        if (_newPhotoFilePath != _oldPhotoFilePath) {
          try {
            _oldPhotoFile.delete();
          } catch (error) {}
        }
      }

      notifyListeners();
    }
  }

  Future<void> deleteClient(int id) async {
    final index = _items.indexWhere((client) => client.id == id);

    if (index >= 0) {
      final client = _items[index];
      _items.remove(client);
      DbUtil.delete('clients', client.id);
      notifyListeners();
    }
  }

  void removeClient(Client client) {
    _items.remove(client);
    DbUtil.delete('clients', client.id);
    notifyListeners();
  }
}
