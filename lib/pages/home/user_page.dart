import 'package:flutter/material.dart';
import 'package:firearm_flutter/pages/add_user.dart';
import 'package:firearm_flutter/pages/edit_user.dart';
import 'package:firearm_flutter/models/user_model.dart';
import 'package:firearm_flutter/widgets/user_card.dart';
import 'package:firearm_flutter/services/user_services.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<UserModel> users = [];
  bool isLoading = true;
  Future<void> fetchUsers() async {
    setState(() => isLoading = true);
    try {
      final result = await UserServices.getUsers();
      users = result ?? [];
    } catch (e) {
      users = [];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to load users")));
    }
    setState(() => isLoading = false);
  }
  
  @override
  void initState() {
    super.initState();
    fetchUsers();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Users")),
      body: isLoading? Center(child: CircularProgressIndicator()):
      RefreshIndicator(
        onRefresh: fetchUsers, 
        child: ListView.builder(
          itemCount: users.isEmpty ? 0 : users.length,
          itemBuilder: (context, index) {
            return UserCard(
              username: users[index], 

              //Edit user
              onEdit: () async {
                final result = await Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (_) => EditUser(user: users[index])
                  ),
                );
                if (result == true) {await fetchUsers();}
              },

              //Delete user
              onDelete: () async {
                final confirm = await showDialog(
                  context: context, 
                  builder: (_) => AlertDialog(
                    title: Text("Delete Product"),
                    content: Text("Are you sure to delete this user?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false), 
                        child: Text("No, i'am not sure"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true), 
                        child: Text("Yes, i'am sure"),
                      ),
                    ],
                  ),
                );
                if (confirm == true){
                  final deletedUser = users[index];
                  setState(() {users.removeAt(index);});
                  try {
                    await UserServices.deleteUser(deletedUser.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("User successfully deleted"))
                    );
                  } catch (e) {
                    setState(() {
                      users.insert(index, deletedUser);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to delete user"))
                    );
                  }
                }
              },
            );
          },
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddUser()),
          );
          if (result == true) {
            await fetchUsers();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
