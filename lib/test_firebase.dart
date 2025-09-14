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
      _addLog('✅ Référence Firebase créée');
      
      // Test 2: Lire les données de la racine
      _addLog('🔍 Lecture des données racine...');
      final rootSnapshot = await ref.get();
      _addLog('📊 Données racine: ${rootSnapshot.exists ? 'Trouvées' : 'Vides'}');
      
      if (rootSnapshot.exists) {
        final data = rootSnapshot.value as Map<dynamic, dynamic>;
        _addLog('📁 Clés trouvées: ${data.keys.toList()}');
      }
      
      // Test 3: Vérifier le nœud 'alerts'
      _addLog('🔍 Vérification du nœud alerts...');
      final alertsRef = _database.ref('alerts');
      final alertsSnapshot = await alertsRef.get();
      _addLog('🚨 Nœud alerts: ${alertsSnapshot.exists ? 'Existe' : 'N\'existe pas'}');
      
      if (alertsSnapshot.exists) {
        final alertsData = alertsSnapshot.value as Map<dynamic, dynamic>;
        _addLog('📊 Nombre d\'alertes: ${alertsData.length}');
        
        // Afficher quelques clés d'exemple
        final keys = alertsData.keys.take(3).toList();
        _addLog('🔑 Premiers IDs: $keys');
        
        // Analyser une alerte exemple
        if (keys.isNotEmpty) {
          final firstAlert = alertsData[keys.first] as Map<dynamic, dynamic>;
          _addLog('📋 Champs de la première alerte: ${firstAlert.keys.toList()}');
          
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
          _addLog('📡 Stream reçu: ${data.length} alertes');
        } else {
          _addLog('📡 Stream reçu: aucune donnée');
        }
      });
      
      setState(() {
        _status = 'Tests terminés!';
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