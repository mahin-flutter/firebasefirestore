import 'package:flutter/material.dart';
import 'package:listapp/models/user_model.dart';

class Displayscreen extends StatelessWidget {
  final UserModel user;
  const Displayscreen({super.key,required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('First Name: ${user.fname}'),
            SizedBox(height: 20,),
            Text('Last Name: ${user.lname}'),
            SizedBox(height: 20,),
            Text('Phone Number: ${user.phonenumber}'),
            SizedBox(height: 20,),
            Text('District: ${user.district}'),
            SizedBox(height: 20,),
            Text('State: ${user.state}'),
            SizedBox(height: 20,),
            Text('Country: ${user.country}'),
          ],
        ),
      ),
    );
  }
}