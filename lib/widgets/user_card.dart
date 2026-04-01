import 'package:flutter/material.dart';
import 'package:firearm_flutter/models/user_model.dart';

class UserCard extends StatelessWidget {
  final UserModel username;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  const UserCard({super.key, required this.username, required this.onDelete, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(username.username),
      subtitle: Text(username.email),
      onTap: onEdit,
      trailing: IconButton(
        onPressed: onDelete, 
        icon: Icon(Icons.delete)
      ),
    );
  }
}