
import 'package:flutter/material.dart';

class HeaderImageLogin extends StatelessWidget {
  const HeaderImageLogin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.asset(
            "/home/h/e_com_user/assets/images/ecom_login_image.jpg",
            width: 210,
            height: 210,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
