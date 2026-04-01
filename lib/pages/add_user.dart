import 'package:flutter/material.dart';
import 'package:firearm_flutter/models/user_model.dart';
import 'package:firearm_flutter/services/user_services.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add user")),
      body: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Column(
          children: [
            //Input Name
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            //Input Email
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            
            //Button Save
            ElevatedButton(
              onPressed: () async {
                final user = UserModel(
                  id: 0,
                  username: usernameController.text,
                  email: emailController.text,
                  password: "password123",
                  role: "user",
                );
                await UserServices.addUser(user);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("User successfully added")),
                );
                await UserServices.getUsers();
                Navigator.pop(context, true);
              },
              child: Text("Save"),
            ),
          ],
        ),),
    );
  }
}