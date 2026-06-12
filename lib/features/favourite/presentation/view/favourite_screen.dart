import 'package:e_com_user/features/favourite/presentation/provider/fav_provider.dart';
import 'package:e_com_user/features/favourite/presentation/widgets/fav_custom_product_card.dart';
import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        title: const Text('Favourites'),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,

          color: Colors.white,
          fontSize: 20,
        ),
      ),
      body: Consumer<FavProvider>(
        builder: (context, value, child) => GridView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: value.favsList.length,

          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: width < 370 ? 280 : 350,
          ),
          itemBuilder: (context, index) {
            return FavProductCard(model: value.favsList[index]);
          },
        ),
      ),
    );
  }
}
