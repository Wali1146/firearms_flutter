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
      appBar: AppBar(title: Text("Home")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            //Button Produk
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 60),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProductPage()),
                );
              },
              child: Text("Products List"),
            ),
            SizedBox(height: 20),

            //Button User
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 60),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => UserPage()),
                );
              },
              child: Text("Users List"),
            ),

            //Button Logout
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 60),
              ),
              onPressed: () async {
                await SessionManager.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                  (route) => false,
                );
              },
              child: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
