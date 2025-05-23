import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import '../providers/coin_provider.dart';
import '../widgets/pixel_button.dart';
import 'pet_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/handle_storage.dart';

//welcome page for user
class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool petExists = false;
  String existingName = "";

  @override
  void initState() {
    super.initState();
    createStorage();
    checkExistingPet();
  }

  Future<void> createStorage() async{
      HandleStorage storage = HandleStorage();
      final petProvider = Provider.of<PetProvider>(context, listen: false);
      final coinProvider = Provider.of<CoinProvider>(context, listen: false);
      petProvider.setStorage(storage);
      coinProvider.setStorage(storage);
  }

  //check if user already has pet and assign existing name
  Future<void> checkExistingPet() async {
    final petProvider = Provider.of<PetProvider>(context, listen: false);
    final stats = await petProvider.storage.loadPetStats();
    if (stats.isNotEmpty && stats["name"] != null) {
      setState(() {
        petExists = true;
        existingName = stats["name"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context, listen: false);
    final coinProvider = Provider.of<CoinProvider>(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/outdoor.png', fit: BoxFit.cover),
          SizedBox(height: 20),
          Center(
            child: Image.asset(
              'assets/images/PixelPawLogo_fin.png',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(20),
              child:
                  //if pet exists button shows petName and loads available data
                  petExists
                      ? PixelButton(
                        label: existingName,
                        icon: Icons.pets,
                        color: Colors.orange,
                        onPressed: () {
                          petProvider.loadPetStats(); // load with existing name
                          coinProvider.loadInventory();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PetScreen(),
                            ),
                          );
                        },
                      )
                      //if no pet, ask for name and load fixed data for new pet created
                      //button to adopt disabled when textfield empty
                      : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: "Name Your Pixel Pet",
                              labelStyle: GoogleFonts.pressStart2p(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                            style: GoogleFonts.pressStart2p(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                          SizedBox(height: 20),
                          PixelButton(
                            label: 'Adopt',
                            icon: Icons.pets,
                            color: Colors.orangeAccent,
                            isEnabled: _nameController.text.trim().isNotEmpty,
                            onPressed:
                                _nameController.text.trim().isNotEmpty
                                    ? () {
                                      petProvider.loadPetStats(
                                        petName: _nameController.text.trim(),
                                      ); //get name from text field
                                      coinProvider.loadInventory();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PetScreen(),
                                        ),
                                      );
                                    }
                                    : null,
                          ),
                        ],
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
