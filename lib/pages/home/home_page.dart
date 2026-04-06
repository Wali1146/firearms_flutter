import 'package:flutter/material.dart';
import 'package:firearm_flutter/pages/home/user_page.dart';
import 'package:firearm_flutter/pages/home/login_page.dart';
import 'package:firearm_flutter/pages/home/product_page.dart';
import 'package:firearm_flutter/services/shared_preferences.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firearms Manager"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Text
              const Text(
                "Welcome to Your",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF1F2937),
                ),
              ),
              const Text(
                "Firearms Inventory",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E40AF),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Manage your products and users efficiently",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 48),

              // Navigation Cards
              _ModernCard(
                icon: Icons.inventory_2,
                title: "Products",
                subtitle: "Browse and manage all firearms",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProductPage()),
                  );
                },
              ),
              const SizedBox(height: 16),
              _ModernCard(
                icon: Icons.people,
                title: "Users",
                subtitle: "Manage user profiles and access",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UserPage()),
                  );
                },
              ),
              const SizedBox(height: 16),
              _ModernCard(
                icon: Icons.logout,
                title: "Logout",
                subtitle: "Sign out from your account",
                onTap: () async {
                  await SessionManager.logout();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  }
                },
                isDestructive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModernCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ModernCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDestructive ? const Color(0xFFFEE2E2) : Colors.white,
            border: Border.all(
              color: isDestructive ? const Color(0xFFFECBCB) : const Color(0xFFE5E7EB),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDestructive
                      ? const Color(0xFFDC2626).withOpacity(0.1)
                      : const Color(0xFF1E40AF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isDestructive ? const Color(0xFFDC2626) : const Color(0xFF1E40AF),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDestructive ? const Color(0xFFDC2626) : const Color(0xFF1E40AF),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isDestructive ? const Color(0xFFDC2626) : const Color(0xFF1E40AF),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
