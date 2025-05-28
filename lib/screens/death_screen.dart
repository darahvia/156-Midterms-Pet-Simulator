import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/pixel_button.dart';
import '../providers/coin_provider.dart';
import 'start_screen.dart';

//if death condition met, navigate to this screen
class DeathScreen extends StatelessWidget {
  String cause = "";

  DeathScreen(String petCause){
    cause = petCause;
  }

  Future<void> _deleteAllData(BuildContext context) async{
    final petProvider = Provider.of<PetProvider>(context, listen: false);

    petProvider.storage.deleteFbData("petData");
    petProvider.storage.deleteLocalData("petData");
  }
  
  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);
    final coinProvider = Provider.of<CoinProvider>(context);

    petProvider.stopAutoDecrease();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Game Over',
          style: GoogleFonts.pressStart2p(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [ 
          Image.asset('assets/images/dead_bg.png', fit: BoxFit.cover),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 300),
                Text(
                  cause == "death" ?
                  '${petProvider.pet.getName()} passed away':'${petProvider.pet.getName()} will find a new home',
                  style: GoogleFonts.pressStart2p(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                // Cat picture
                Image.asset(
                  cause == "death" ?
                  'assets/images/cat_dead.png' : 'assets/images/cat_hungry.png',
                  height: 150,
                  width: 500,
                ),
                const SizedBox(height: 20),
                PixelButton(
                  label: 'Goodbye',
                  icon: Icons.pets,
                  color: Colors.redAccent,
                  //navigate back to start screen and delete petData
                  onPressed: () async {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => StartScreen()),
                        (route) => false,
                      );
                    });
                    petProvider.storage.savePetHistory('${petProvider.pet.getName()} - $cause');
                    petProvider.petReset();
                    await _deleteAllData(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
