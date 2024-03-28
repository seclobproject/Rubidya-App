import 'package:flutter/material.dart';
import '../../../resources/color.dart';
import '../../../services/profile_service.dart';
import '../../../support/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class editprofile extends StatefulWidget {
  editprofile({
    super.key,
    required this.bio,
    required this.firstname,
    required this.lastName,
    required this.countryCode,
    required this.phone,
    required this.email,
    required this.dateOfBirth,
    required this.gender,
    required this.location,
    required this.profession,
    required this.district,
  });

  final String bio;
  final String firstname;
  final String lastName;
  final String countryCode;
  final String phone;
  final String email;
  final String dateOfBirth;
  final String gender;
  final String location;
  final String profession;
  final String district;

  @override
  State<editprofile> createState() => _editprofileState();
}

class _editprofileState extends State<editprofile> {
  late TextEditingController bioController;
  late TextEditingController firstnameController;


  late String bio;
  late String firstname;
  late String lastName;
  late String countryCode;
  late String phone;
  late String email;
  late String dateOfBirth;
  late String gender;
  late String location;
  late String profession;
  late String district;

  var userid;

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    bioController = TextEditingController(text: widget.bio);
    firstnameController = TextEditingController(text: widget.firstname);
  }

  Future<void> editWorkReport() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    print(userid);
    var reqData = {
      'bio': bioController.text,
    };

    print(bioController.text);
    setState(() {
      isLoading = true; // Start loading indicator
    });
    try {
      var response = await ProfileService.ProfileEditing(reqData);
      log.i('Profile Editing Page. $response');

      // Pop the current page from the stack
      Navigator.pop(context);

      // Push the current page again to reload it
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => editprofile(
          // Pass the same parameters to recreate the page
          bio: bioController.text,
          firstname: widget.firstname,
          lastName: widget.lastName,
          countryCode: widget.countryCode,
          phone: widget.phone,
          email: widget.email,
          dateOfBirth: widget.dateOfBirth,
          gender: widget.gender,
          location: widget.location,
          profession: widget.profession,
          district: widget.district,
        )),
      );
    } catch (error) {
      print('Error editing work report: $error');
    } finally {
      setState(() {
        isLoading = false; // Stop loading indicator
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile", style: TextStyle(fontSize: 14)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
        
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: firstnameController,
                decoration: InputDecoration(
                  hintText: 'Pay ID',
                  hintStyle: TextStyle(color: textblack, fontSize: 12),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor),
                  ),
                  prefixIcon: Icon(
                    Icons.person,
                    size: 15,
                    color: bordercolor,
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                     bio = text;
                     print(">>......>.>>...>$bio");
                  });
                },
                style: TextStyle(color: textblack, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: bioController,
                decoration: InputDecoration(
                  hintText: 'Pay ID',
                  hintStyle: TextStyle(color: textblack, fontSize: 12),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor),
                  ),
                  prefixIcon: Icon(
                    Icons.person,
                    size: 15,
                    color: bordercolor,
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    // description = text;
                  });
                },
                style: TextStyle(color: textblack, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: bioController,
                decoration: InputDecoration(
                  hintText: 'Pay ID',
                  hintStyle: TextStyle(color: textblack, fontSize: 12),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor),
                  ),
                  prefixIcon: Icon(
                    Icons.person,
                    size: 15,
                    color: bordercolor,
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    // description = text;
                  });
                },
                style: TextStyle(color: textblack, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: bioController,
                decoration: InputDecoration(
                  hintText: 'Pay ID',
                  hintStyle: TextStyle(color: textblack, fontSize: 12),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor),
                  ),
                  prefixIcon: Icon(
                    Icons.person,
                    size: 15,
                    color: bordercolor,
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    // description = text;
                  });
                },
                style: TextStyle(color: textblack, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: bioController,
                decoration: InputDecoration(
                  hintText: 'Pay ID',
                  hintStyle: TextStyle(color: textblack, fontSize: 12),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor),
                  ),
                  prefixIcon: Icon(
                    Icons.person,
                    size: 15,
                    color: bordercolor,
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    // description = text;
                  });
                },
                style: TextStyle(color: textblack, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: bioController,
                decoration: InputDecoration(
                  hintText: 'Pay ID',
                  hintStyle: TextStyle(color: textblack, fontSize: 12),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor),
                  ),
                  prefixIcon: Icon(
                    Icons.person,
                    size: 15,
                    color: bordercolor,
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    // description = text;
                  });
                },
                style: TextStyle(color: textblack, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: bioController,
                decoration: InputDecoration(
                  hintText: 'Pay ID',
                  hintStyle: TextStyle(color: textblack, fontSize: 12),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor),
                  ),
                  prefixIcon: Icon(
                    Icons.person,
                    size: 15,
                    color: bordercolor,
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    // description = text;
                  });
                },
                style: TextStyle(color: textblack, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: bioController,
                decoration: InputDecoration(
                  hintText: 'Pay ID',
                  hintStyle: TextStyle(color: textblack, fontSize: 12),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor),
                  ),
                  prefixIcon: Icon(
                    Icons.person,
                    size: 15,
                    color: bordercolor,
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    // description = text;
                  });
                },
                style: TextStyle(color: textblack, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: bioController,
                decoration: InputDecoration(
                  hintText: 'Pay ID',
                  hintStyle: TextStyle(color: textblack, fontSize: 12),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor),
                  ),
                  prefixIcon: Icon(
                    Icons.person,
                    size: 15,
                    color: bordercolor,
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    // description = text;
                  });
                },
                style: TextStyle(color: textblack, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: bioController,
                decoration: InputDecoration(
                  hintText: 'Pay ID',
                  hintStyle: TextStyle(color: textblack, fontSize: 12),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor),
                  ),
                  prefixIcon: Icon(
                    Icons.person,
                    size: 15,
                    color: bordercolor,
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    // description = text;
                  });
                },
                style: TextStyle(color: textblack, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: bioController,
                decoration: InputDecoration(
                  hintText: 'Pay ID',
                  hintStyle: TextStyle(color: textblack, fontSize: 12),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor),
                  ),
                  prefixIcon: Icon(
                    Icons.person,
                    size: 15,
                    color: bordercolor,
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    // description = text;
                  });
                },
                style: TextStyle(color: textblack, fontSize: 14),
              ),
            ),

            SizedBox(height: 40,),


            InkWell(
              onTap: () {
                editWorkReport();

              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height:40,
                  width: 400,
                  decoration: BoxDecoration(
                      color: bluetext,
                      borderRadius: BorderRadius.all(Radius.circular(10))),

                  child: Center(child: Text("Create new account",style: TextStyle(fontSize: 12,color: white),)),

                ),
              ),
            ),




            SizedBox(height: 50,),

          ],
        ),
      ),
    );
  }
}
