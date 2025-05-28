import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class CoinDisplay extends StatelessWidget {
  const CoinDisplay({super.key});

  Future<int> _getCoins() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 0;

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (!doc.exists) return 0;

    final data = doc.data();
    if (data == null) return 0;

    final inventory = data['inventoryData'] as Map<String, dynamic>?;

    if (inventory == null) return 0;

    return inventory['coin'] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _getCoins(),
      builder: (context, snapshot) {
        int coins = 0;
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          coins = snapshot.data!;
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/coin.png',
              width: 24,
              height: 24,
            ),
            SizedBox(width: 8),
            Text(
              snapshot.connectionState == ConnectionState.waiting
                  ? '...'
                  : '$coins',
              style: GoogleFonts.pressStart2p(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    );
  }
}
