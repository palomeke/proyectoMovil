import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class SmokeTestScreen extends StatefulWidget {
  const SmokeTestScreen({super.key});
  @override
  State<SmokeTestScreen> createState() => _SmokeTestScreenState();
}

class _SmokeTestScreenState extends State<SmokeTestScreen> {
  String _status = 'Idle';

  Future<void> _signInAnon() async {
    setState(() => _status = 'Signing in anonymously...');
    await FirebaseAuth.instance.signInAnonymously();
    setState(
        () => _status = 'Signed in: ${FirebaseAuth.instance.currentUser?.uid}');
  }

  Future<void> _addDemoDoc() async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'no-auth';
    setState(() => _status = 'Writing Firestore doc...');
    await FirebaseFirestore.instance.collection('encomiendas').add({
      'createdAt': FieldValue.serverTimestamp(),
      'by': uid,
      'estado': 'creada',
      'codigo': DateTime.now().millisecondsSinceEpoch.toString(),
    });
    setState(() => _status = 'Firestore write OK');
  }

  Future<void> _forceCrash() async {
    FirebaseCrashlytics.instance.crash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smoke Test Firebase')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Status: $_status'),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: _signInAnon,
                child: const Text('Auth: Sign-in Anónimo')),
            ElevatedButton(
                onPressed: _addDemoDoc,
                child: const Text('Firestore: Añadir documento demo')),
            ElevatedButton(
                onPressed: _forceCrash,
                child: const Text('Crashlytics: Forzar crash')),
            const SizedBox(height: 12),
            const Text('Últimas 5 encomiendas:'),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('encomiendas')
                    .orderBy('createdAt', descending: true)
                    .limit(5)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return const Text('Sin datos aún.');
                  }
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, i) {
                      final d = docs[i].data();
                      return ListTile(
                        title: Text(d['codigo']?.toString() ?? 's/codigo'),
                        subtitle: Text('estado: ${d['estado'] ?? 'N/A'}'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
