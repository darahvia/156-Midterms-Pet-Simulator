import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FlappyLeaderboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'Flappy Leaderboard',
          style: GoogleFonts.pressStart2p(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.yellowAccent,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .orderBy('highScore', descending: true)
            .limit(10)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return Center(
              child: Text(
                'No scores yet!',
                style: GoogleFonts.pressStart2p(
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final data = docs[i].data() as Map<String, dynamic>;
              return ListTile(
                leading: Text(
                  '#${i + 1}',
                  style: GoogleFonts.pressStart2p(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  data['username'] ?? data['name'] ?? 'Anonymous',
                  style: GoogleFonts.pressStart2p(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellowAccent,
                  ),
                ),
                trailing: Text(
                  '${data['highScore'] ?? 0}',
                  style: GoogleFonts.pressStart2p(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
