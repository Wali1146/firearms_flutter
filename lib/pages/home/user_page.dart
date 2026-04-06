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
      appBar: AppBar(
        title: const Text("Users"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No Users Yet",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Add your first user to get started",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: fetchUsers,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return UserCard(
                        username: users[index],
                        onEdit: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditUser(user: users[index]),
                            ),
                          );
                          if (result == true) {
                            await fetchUsers();
                          }
                        },
                        onDelete: () async {
                          final confirm = await showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Delete User"),
                              content: const Text("Are you sure you want to delete this user?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Color(0xFFDC2626)),
                                  ),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            final deletedUser = users[index];
                            setState(() {
                              users.removeAt(index);
                            });
                            try {
                              await UserServices.deleteUser(deletedUser.id);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("User successfully deleted"),
                                  ),
                                );
                              }
                            } catch (e) {
                              setState(() {
                                users.insert(index, deletedUser);
                              });
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Failed to delete user")),
                                );
                              }
                            }
                          }
                        },
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddUser()),
          );
          if (result == true) {
            await fetchUsers();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
