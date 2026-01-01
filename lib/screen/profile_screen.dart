import 'package:flutter/material.dart';
import 'package:listapp/models/user_model.dart';
import 'package:listapp/screen/display_screen.dart';
import 'package:listapp/screen/user_add_screen.dart';
import 'package:listapp/services/firebase_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final service = Firebaseservice();
  List<UserModel> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ListView'), backgroundColor: Colors.teal),
      body: StreamBuilder(
        stream: service.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No users found'));
          }
          final items = snapshot.data!;
          return items.isEmpty
              ? Center(child: Text('No User Added'))
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          title: Text(item.fname),
                          subtitle: Text(item.country),
                          trailing: Row(
                            mainAxisSize: .min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UserAddScreen(user: item),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.edit, color: Colors.blue),
                              ),
                              SizedBox(width: 10),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Delete User'),
                                        content: Text(
                                          'Are sure want to delete this User',
                                        ),
                                        actions: [
                                          Divider(
                                            height: 10,
                                            color: Colors.black,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.teal,
                                                    foregroundColor:
                                                        Colors.black,
                                                    shape:
                                                        RoundedRectangleBorder(),
                                                  ),
                                                  child: Text('Cancel'),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: TextButton(
                                                  onPressed: () async {
                                                    await service.deleteUser(
                                                      item.id,
                                                    );
                                                    Navigator.pop(context);
                                                  },
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    foregroundColor:
                                                        Colors.black,
                                                    shape:
                                                        RoundedRectangleBorder(),
                                                  ),
                                                  child: Text('Delete'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Displayscreen(user: item),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserAddScreen()),
          );
          if (result != null) {
            setState(() {
              items.add(result);
            });
          }
        },
        child: Icon(Icons.add, color: Colors.black, size: 30),
      ),
    );
  }
}
