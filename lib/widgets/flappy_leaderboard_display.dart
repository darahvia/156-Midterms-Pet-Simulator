import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FlappyLeaderboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flappy Leaderboard')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .orderBy('highScore', descending: true)
            .limit(10)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return Center(child: Text('No scores yet!'));
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final data = docs[i].data() as Map<String, dynamic>;
              return ListTile(
                leading: Text('#${i + 1}'),
                title: Text(data['username'] ?? data['name'] ?? 'Anonymous'),
                trailing: Text('${data['highScore'] ?? 0}'),
              );
            },
          );
        },
      ),
    );
  }
}