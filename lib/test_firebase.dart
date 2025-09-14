import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseTestPage extends StatefulWidget {
  const FirebaseTestPage({Key? key}) : super(key: key);

  @override
  State<FirebaseTestPage> createState() => _FirebaseTestPageState();
}

class _FirebaseTestPageState extends State<FirebaseTestPage> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  String _status = 'En attente...';
  List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _testFirebaseConnection();
  }

  void _addLog(String message) {
    setState(() {
      _logs.add('${DateTime.now().toString().substring(11, 19)}: $message');
    });
    print('🔥 FIREBASE TEST: $message');
  }

  Future<void> _testFirebaseConnection() async {
    try {
      _addLog('🔍 Test de connexion Firebase...');
      
      // Test 1: Connexion basique
      final ref = _database.ref();
      _addLog('✅ Firebase reference created');
      
      // Test 2: Read root data
      _addLog('🔍 Reading root data...');
      final rootSnapshot = await ref.get();
      _addLog('📊 Root data: ${rootSnapshot.exists ? 'Found' : 'Empty'}');
      
      if (rootSnapshot.exists) {
        final data = rootSnapshot.value as Map<dynamic, dynamic>;
        _addLog('📁 Keys found: ${data.keys.toList()}');
      }
      
      // Test 3: Vérifier le nœud 'alerts'
      _addLog('🔍 Vérification du nœud alerts...');
      final alertsRef = _database.ref('alerts');
      final alertsSnapshot = await alertsRef.get();
      _addLog('🚨 Nœud alerts: ${alertsSnapshot.exists ? 'Existe' : 'N\'existe pas'}');
      
      if (alertsSnapshot.exists) {
        final alertsData = alertsSnapshot.value as Map<dynamic, dynamic>;
        _addLog('📊 Number of alerts: ${alertsData.length}');
        
        // Display some example keys
        final keys = alertsData.keys.take(3).toList();
        _addLog('🔑 First IDs: $keys');
        
        // Analyze an example alert
        if (keys.isNotEmpty) {
          final firstAlert = alertsData[keys.first] as Map<dynamic, dynamic>;
          _addLog('📋 Fields of first alert: ${firstAlert.keys.toList()}');
          
          if (firstAlert.containsKey('alert_type')) {
            _addLog('🎯 Type: ${firstAlert['alert_type']}');
          }
          if (firstAlert.containsKey('severity')) {
            _addLog('⚠️ Sévérité: ${firstAlert['severity']}');
          }
        }
      }
      
      // Test 4: Stream en temps réel
      _addLog('🔍 Test du stream temps réel...');
      alertsRef.limitToLast(5).onValue.listen((event) {
        if (event.snapshot.exists) {
          final data = event.snapshot.value as Map<dynamic, dynamic>;
          _addLog('📡 Stream received: ${data.length} alerts');
        } else {
          _addLog('📡 Stream received: no data');
        }
      });
      
      setState(() {
        _status = 'Tests completed!';
      });
      
    } catch (e) {
      _addLog('❌ ERREUR: $e');
      setState(() {
        _status = 'Erreur de connexion';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Firebase'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statut: $_status',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text('Configuration Firebase:'),
                    const Text('• Projet: ampdefender-9bf8e'),
                    const Text('• Database: Realtime Database'),
                    const Text('• Nœud: /alerts'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Logs de test:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        _logs[index],
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _logs.clear();
            _status = 'En attente...';
          });
          _testFirebaseConnection();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}