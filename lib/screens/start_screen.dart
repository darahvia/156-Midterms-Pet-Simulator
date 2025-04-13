import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import '../providers/coin_provider.dart';
import '../services/local_storage.dart';
import '../widgets/pixel_button.dart';
import 'pet_screen.dart';

class StartScreen extends StatefulWidget {
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
    checkExistingPet();
  }

  Future<void> checkExistingPet() async {
    final stats = await LocalStorage().loadPetStats();
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
          Image.asset(
            'assets/images/outdoor.png',
            fit: BoxFit.cover,
          ),
          SizedBox(height:20),
          Center(child: Image.asset(
              'assets/images/PixelPawLogo_fin.png',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height:20),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: petExists
                  ? PixelButton(
                      label: 'Check on $existingName',
                      icon: Icons.pets,
                      color: Colors.orange,
                      onPressed: () {
                        petProvider.loadPetStats(); // load with existing name
                        coinProvider.loadInventory();
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PetScreen())
                        );
                      },
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(labelText: "Name Your Pixel Pet"),
                          onChanged: (_) => setState(() {}),
                        ),
                        SizedBox(height: 20),
                        PixelButton(
                          label: 'Adopt',
                          icon: Icons.pets,
                          color: Colors.orangeAccent,
                          isEnabled: _nameController.text.trim().isNotEmpty,
                          onPressed: _nameController.text.trim().isNotEmpty
                              ? () {
                                  petProvider.loadPetStats(petName: _nameController.text.trim());
                                  coinProvider.loadInventory();
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => PetScreen())
                                  );  
                                }
                              : null,
                        )
                      ],
                    ),
            ),
          ),
        ]
      )
    );
  }
}

