// screens/shop_screen.dart
import 'package:flutter/material.dart';
import 'package:pet_simulator/widgets/pet_display.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/coin_provider.dart';
import '../widgets/pixel_button.dart';
import '../widgets/coin_display.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final coinProvider = Provider.of<CoinProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Shop",
          style: GoogleFonts.pressStart2p(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Display current coin count in the app bar
          Padding(padding: const EdgeInsets.all(12.0), child: CoinDisplay()),
        ],
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset('assets/images/store.png', fit: BoxFit.cover),
          ),
          // Cat image positioned in the lower-right corner
          // Positioned(
          //   bottom: 50,
          //   right: 50,
          //   child: SizedBox(
          //     width: 10,
          //     height: 10,
          //     child: PetDisplay(onTap: (tapPosition) {}),
          //   ),
          // ),
          Positioned(
            top: 8,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 8),
                // Food inventory
                Row(
                  children: [
                    Image.asset(
                      'assets/images/food_biscuit.png',
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${coinProvider.inventory.getFood('biscuit')}',
                      style: GoogleFonts.pressStart2p(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    Image.asset(
                      'assets/images/food_can.png',
                      width: 40,
                      height: 40,
                    ),
                    Text(
                      '${coinProvider.inventory.getFood('can')}',
                      style: GoogleFonts.pressStart2p(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    Image.asset(
                      'assets/images/food_bag.png',
                      width: 40,
                      height: 40,
                    ),
                    Text(
                      '${coinProvider.inventory.getFood('bag')}',
                      style: GoogleFonts.pressStart2p(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Soap inventory
                Row(
                  children: [
                    Image.asset(
                      'assets/images/pet_wipes.png',
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${coinProvider.inventory.getSoap('wipes')}',
                      style: GoogleFonts.pressStart2p(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    Image.asset(
                      'assets/images/pet_soap.png',
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${coinProvider.inventory.getSoap('soap')}',
                      style: GoogleFonts.pressStart2p(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    Image.asset(
                      'assets/images/pet_shampoo.png',
                      width: 40,
                      height: 40,
                    ),
                    Text(
                      '${coinProvider.inventory.getSoap('shampoo')}',
                      style: GoogleFonts.pressStart2p(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/medicine.png',
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${coinProvider.inventory.getMedicine()}',
                      style: GoogleFonts.pressStart2p(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Shop board with buttons
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Board image
                Image.asset(
                  'assets/images/board.png',
                  width: 350,
                  height: 350,
                  fit: BoxFit.contain,
                ),
                // Buttons inside the board
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Food Items
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 7.0,
                      children: [
                        PixelButton(
                          label: 'Biscuit - 5',
                          icon: Icons.restaurant,
                          color: Colors.orange,
                          onPressed:
                              () => _confirmPurchase(
                                context,
                                coinProvider,
                                5,
                                () {
                                  coinProvider.buyFood('biscuit', 1);
                                },
                              ),
                        ),
                        PixelButton(
                          label: 'Can - 10 ',
                          icon: Icons.restaurant,
                          color: Colors.orange,
                          onPressed:
                              () => _confirmPurchase(
                                context,
                                coinProvider,
                                10,
                                () {
                                  coinProvider.buyFood('can', 1);
                                },
                              ),
                        ),
                        PixelButton(
                          label: 'Bag - 20',
                          icon: Icons.restaurant,
                          color: Colors.orange,
                          onPressed:
                              () => _confirmPurchase(
                                context,
                                coinProvider,
                                10,
                                () {
                                  coinProvider.buyFood('bag', 1);
                                },
                              ),
                        ),
                      ],
                    ),
                    SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 7.0,
                      children: [
                        PixelButton(
                          label: 'Wipes - 5',
                          icon: Icons.soap,
                          color: Colors.blue,
                          onPressed:
                              () => _confirmPurchase(
                                context,
                                coinProvider,
                                5,
                                () {
                                  coinProvider.buySoap('wipes', 1);
                                },
                              ),
                        ),
                        PixelButton(
                          label: 'Soap - 10',
                          icon: Icons.soap,
                          color: Colors.blue,
                          onPressed:
                              () => _confirmPurchase(
                                context,
                                coinProvider,
                                10,
                                () {
                                  coinProvider.buySoap('soap', 1);
                                },
                              ),
                        ),
                        PixelButton(
                          label: 'Shampoo - 20',
                          icon: Icons.soap,
                          color: Colors.blue,
                          onPressed:
                              () => _confirmPurchase(
                                context,
                                coinProvider,
                                5,
                                () {
                                  coinProvider.buySoap('shampoo', 1);
                                },
                              ),
                        ),
                      ],
                    ),
                    SizedBox(height: 60),
                    PixelButton(
                      label: 'Meds - 20',
                      icon: Icons.medical_services,
                      color: Colors.red,
                      onPressed:
                          () => _confirmPurchase(context, coinProvider, 20, () {
                            coinProvider.buyMedicine(
                              1,
                            ); // Add 1 medicine to inventory
                          }),
                    ),
                    //Clothing Shop Button
                    // PixelButton(
                    //   label: 'Clothing',
                    //   icon: Icons.checkroom,
                    //   color: Colors.purple,
                    //   onPressed: (){
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => ClothingShopScreen(),
                    //       ),
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ],
            ),
          ),

          // Back button
        ],
      ),
    );
  }

  //handles purchases with confirmation query
  void _confirmPurchase(
    BuildContext context,
    CoinProvider coinProvider,
    int cost,
    VoidCallback onSuccess,
  ) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: Color(0xFFFF6F71),
            title: Text(
              'Confirm Purchase',
              style: GoogleFonts.pressStart2p(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            content: Text(
              'Are you sure you want to buy this item for $cost coins?',
              style: GoogleFonts.pressStart2p(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.pressStart2p(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  if (coinProvider.inventory.getCoin() >= cost) {
                    coinProvider.spendCoins(cost); // Deduct coins
                    onSuccess(); // Add item to inventory
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Purchase successful!',
                          style: GoogleFonts.pressStart2p(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Not enough coins!',
                          style: GoogleFonts.pressStart2p(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  'Buy',
                  style: GoogleFonts.pressStart2p(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
