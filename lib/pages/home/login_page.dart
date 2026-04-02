import 'package:flutter/material.dart';
import 'package:firearm_flutter/pages/home/home_page.dart';
import 'package:firearm_flutter/services/user_services.dart';
import 'package:firearm_flutter/services/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            //Login email
            TextField(
              controller: email,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            //login password
            TextField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            //Button Login
            ElevatedButton(
              onPressed: () async {
                setState(() => isLoading = true);
                try {
                  final result = await UserServices.login(email.text,password.text,);
                  if (result['status'] == 'success') {
                    final user = result['user'];
                    await SessionManager.saveUser(user);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login success")));
                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(builder: (_) => HomePage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'])));
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something went wrong!")));
                }
                setState(() => isLoading = false);
              },
              child: isLoading ? CircularProgressIndicator() : Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
