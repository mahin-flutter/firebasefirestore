import 'package:flutter/material.dart';
import 'package:listapp/models/user_model.dart';
import 'package:listapp/repo/user_repository.dart';
//import 'package:listapp/services/firebase_service.dart';

class UserAddScreen extends StatefulWidget {
  final UserModel? user;
  const UserAddScreen({super.key, this.user});

  @override
  State<UserAddScreen> createState() => _UserAddScreenState();
}

class _UserAddScreenState extends State<UserAddScreen> {
  //final service = Firebaseservice();
  final repo = UserRepository();
  bool isvalidate = false;
  final TextEditingController firstnamecontroller = TextEditingController();
  final TextEditingController lastnamecontroller = TextEditingController();
  final TextEditingController phonenumbercontroller = TextEditingController();
  final TextEditingController districtnamecontroller = TextEditingController();
  final TextEditingController statenamecontroller = TextEditingController();
  final TextEditingController countrynamecontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      firstnamecontroller.text = widget.user!.fname;
      lastnamecontroller.text = widget.user!.lname;
      phonenumbercontroller.text = widget.user!.phonenumber;
      districtnamecontroller.text = widget.user!.district;
      statenamecontroller.text = widget.user!.state;
      countrynamecontroller.text = widget.user!.country;
    }
  }

  Widget textfield(String text, TextEditingController controller, String word) {
    return TextField(
      controller: controller,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        hintText: text,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black, width: 3),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black, width: 3),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red, width: 3),
        ),
        errorText: isvalidate && controller.text.isEmpty ? word : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.user == null ? 'Add User' : 'Edit User'), backgroundColor: Colors.teal),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              textfield(
                'Enter the First Name',
                firstnamecontroller,
                'First Name Cannot be empty',
              ),
              SizedBox(height: 20),
              textfield(
                'Enter the Last Name',
                lastnamecontroller,
                'Last Name Cannot be empty',
              ),
              SizedBox(height: 20),
              textfield(
                'Enter the Phone Number',
                phonenumbercontroller,
                'Phone Number Cannot be empty',
              ),
              SizedBox(height: 20),
              textfield(
                'Enter the District',
                districtnamecontroller,
                'District Cannot be empty',
              ),
              SizedBox(height: 20),
              textfield(
                'Enter the State',
                statenamecontroller,
                'State Cannot be empty',
              ),
              SizedBox(height: 20),
              textfield(
                'Enter the Country',
                countrynamecontroller,
                'Country Cannot be empty',
              ),
              SizedBox(height: 40),
              TextButton(
                onPressed: () async {
                  setState(() {
                    isvalidate =
                        firstnamecontroller.text.isEmpty ||
                        lastnamecontroller.text.isEmpty ||
                        phonenumbercontroller.text.isEmpty ||
                        districtnamecontroller.text.isEmpty ||
                        statenamecontroller.text.isEmpty ||
                        countrynamecontroller.text.isEmpty;
                  });
                  if (!isvalidate) {
                    final newUserModel = UserModel(
                      id: widget.user?.id ?? '',
                      fname: firstnamecontroller.text,
                      lname: lastnamecontroller.text,
                      phonenumber: phonenumbercontroller.text,
                      district: districtnamecontroller.text,
                      state: statenamecontroller.text,
                      country: countrynamecontroller.text,
                      updatedAt: DateTime.now().millisecondsSinceEpoch,
                      isSynced: 0,
                      isDeleted: 0
                    );
                    
                    await repo.addOrUpdateUser(newUserModel);
                    
                    if(mounted){
                      Navigator.pop(context, newUserModel);
                    }
                    
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),
                ),
                child: Text(widget.user == null ?'Add User' : 'Edit User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
