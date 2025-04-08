import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../services/auth_service.dart';

Widget buildSocialLogin() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      socialButton(
        icon: Icons.g_mobiledata_rounded,
        color: Colors.red,
        onTap: () => AuthService().signInWithGoogle(),
      ),
      const SizedBox(width: 20),
      socialButton(
        icon: Icons.facebook,
        color: Colors.blue,
        onTap: () => AuthService().signInWithFacebook(),
      ),
      const SizedBox(width: 20),
      socialButton(
        icon: Icons.apple,
        color: Colors.black,
        onTap: () => AuthService().signInWithApple(),
      ),
    ],
  );
}

Widget socialButton({
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: color,
        size: 30,
      ),
    ),
  );
}
