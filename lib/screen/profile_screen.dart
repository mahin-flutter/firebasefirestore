import 'package:flutter/material.dart';
import 'package:listapp/models/user_model.dart';
import 'package:listapp/repo/user_repository.dart';
import 'package:listapp/screen/display_screen.dart';
import 'package:listapp/screen/user_add_screen.dart';
//import 'package:listapp/services/firebase_service.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  //final service = Firebaseservice();
  List<UserModel> items = [];
  final repo = UserRepository();
  bool isLoading = true;

  Future<void> _init() async {
  await repo.pullFromFirebaseIfOnline();
  await loadUser();
}

  Future<void> loadUser() async{
    setState(() {
      isLoading = true;
    });
    final users = await repo.getUser();
    setState(() {
      items = users;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ListView'), backgroundColor: Colors.teal),
      body: isLoading ? Center(child: CircularProgressIndicator(),)
      : items.isEmpty
              ? Center(child: Text('No User Added'))
              : RefreshIndicator(
                onRefresh: loadUser,
                child: ListView.builder(
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
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () async{
                                    final result =await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UserAddScreen(user: item),
                                      ),
                                    );
                                    if(result != null){
                                      await loadUser();
                                    }
                                    
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
                                                      await repo.deleteUser(item.id);
                                                      Navigator.pop(context);
                                                      await loadUser();
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
                  ),
              ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserAddScreen()),
          );
          if (result != null) {
            await loadUser();
          }
        },
        child: Icon(Icons.add, color: Colors.black, size: 30),
      ),
    );
  }
}
