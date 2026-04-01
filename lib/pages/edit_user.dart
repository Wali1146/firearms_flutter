import 'package:flutter/material.dart';
import 'package:firearm_flutter/models/user_model.dart';
import 'package:firearm_flutter/services/user_services.dart';

class EditUser extends StatefulWidget {
  final UserModel user;
  const EditUser({super.key, required this.user});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  late TextEditingController usernameController;
  late TextEditingController emailController;
  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.user.username);
    emailController = TextEditingController(text: widget.user.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail User")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            //Name user edit
            Text("Username"),
            TextField(controller: usernameController),
            SizedBox(height: 10),

            //Email user edit
            Text("Email"),
            TextField(controller: emailController),
            SizedBox(height: 20),

            //Button Save
            ElevatedButton(
              onPressed: () async {
                await UserServices.updateUser(
                  widget.user.id,
                  UserModel(
                    id: widget.user.id,
                    username: usernameController.text,
                    email: emailController.text,
                    password: widget.user.password,
                    role: widget.user.role,
                  )
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("User successfully updated")),
                );
                Navigator.pop(context, true);
              },
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
