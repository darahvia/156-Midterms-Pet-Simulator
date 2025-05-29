import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import '../providers/coin_provider.dart';
import '../widgets/pixel_button.dart';
import 'pet_screen.dart';
import 'login_page.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/handle_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  // Pet Selection
  String selectedPetType = '';

  @override
  void initState() {
    super.initState();
    setup();
  }

  Future<void> setup() async {
    await createStorage();
    await checkExistingPet();
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

  Future<void> _logout() async {
    final petProvider = Provider.of<PetProvider>(context, listen: false);
    petProvider.stopAutoDecrease();
    await petProvider.storage.deleteLocalData("petData");
    await petProvider.storage.deleteLocalData("inventoryData");
    await petProvider.storage.deleteLocalData("petHistory");
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
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
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: SizedBox(
                height: 200, // adjust size as needed
                child: Image.asset(
                  'assets/images/PixelPawLogo_fin.png',
                  fit: BoxFit.contain,
                ),
              ),
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
                      ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          PixelButton(
                            label: existingName,
                            icon: Icons.pets,
                            color: Colors.orange,
                            onPressed: () {
                              petProvider.loadPetStats();
                              coinProvider.loadInventory();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PetScreen(),
                                ),
                              );
                            },
                          ),
                          SizedBox(width: 10),
                          PixelButton(
                            label: 'Pets',
                            icon: Icons.book,
                            color: Colors.green,
                            onPressed: () async {
                              List<String> history = await petProvider.storage.loadPetHistory();
                              showPetHistoryDialog(context, history);
                            },
                          ),
                          ]
                          ),  
                          SizedBox(height: 10),

                          PixelButton(
                            label: 'Logout',
                            icon: Icons.logout,
                            color: Colors.red,
                            onPressed: _logout,
                          ),

                        ],
                      )

                      //if no pet, ask for name and load fixed data for new pet created
                      //button to adopt disabled when textfield empty
                      : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "What kind of pet?",
                            style: GoogleFonts.pressStart2p(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              PixelButton(
                                label: 'Dog',
                                icon: Icons.pets,
                                color: selectedPetType == 'Dog' ? Colors.orangeAccent : Colors.grey,
                                onPressed: () => setState(() {
                                  selectedPetType = 'Dog';
                                }),
                              ),
                              SizedBox(height: 10),
                              PixelButton(
                                label: 'Cat',
                                icon: Icons.pets,
                                color: selectedPetType == 'Cat' ? Colors.orangeAccent : Colors.grey,
                                onPressed: () => setState(() {
                                  selectedPetType = 'Cat';
                                }),
                              ),
                              SizedBox(height: 10),
                              PixelButton(
                                label: 'Dragon',
                                icon: Icons.pets,
                                color: selectedPetType == 'Dragon' ? Colors.orangeAccent : Colors.grey,
                                onPressed: () => setState(() {
                                  selectedPetType = 'Dragon';
                                }),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Name Your Pet",
                            style: GoogleFonts.pressStart2p(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            ),
                            style: GoogleFonts.pressStart2p(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              PixelButton(
                                label: 'Adopt',
                                icon: Icons.pets,
                                color: Colors.orangeAccent,
                                isEnabled: _nameController.text.trim().isNotEmpty && selectedPetType.isNotEmpty,
                                onPressed: (_nameController.text.trim().isNotEmpty && selectedPetType.isNotEmpty)
                                    ? () {
                                        petProvider.loadPetStats(
                                          petName: _nameController.text.trim(),
                                          petType: selectedPetType.toLowerCase(),
                                        );
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
                              SizedBox(width: 10),
                              PixelButton(
                                label: 'Pets',
                                icon: Icons.book,
                                color: Colors.green,
                                onPressed: () async {
                                  List<String> history = await petProvider.storage.loadPetHistory();
                                  showPetHistoryDialog(context, history);
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                PixelButton(
                                label: 'Logout',
                                icon: Icons.logout,
                                color: Colors.red,
                                onPressed: _logout,
                              ),
                          ],)
                        ],
                      ),
            ),
          ),
        ],
      ),
    );
  }

  void showPetHistoryDialog(BuildContext context, List<String> historyList) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  "Pet History",
                  style: GoogleFonts.pressStart2p(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 0, 85, 34),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.close,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        content: historyList.isEmpty
            ? Text(
                'No history yet.',
                style: GoogleFonts.pressStart2p(
                  color: Colors.black,
                ),
              )
            : Container(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: historyList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        historyList[index],
                        style: GoogleFonts.pressStart2p(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}


