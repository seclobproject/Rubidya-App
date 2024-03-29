import 'package:flutter/material.dart';
import '../../../resources/color.dart';
import '../../../services/profile_service.dart';
import '../../../support/logger.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:country_pickers/country_pickers.dart';
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
  late TextEditingController lastnameController;
  late TextEditingController emailController;
  late TextEditingController professionController;
  late TextEditingController genderController;
  late TextEditingController dateOfBirthController;
  late TextEditingController districtController;
  late TextEditingController locationController;
  late TextEditingController phoneController;


  Country _selectedCountry = CountryPickerUtils.getCountryByIsoCode('IN');


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
    // editWorkReport();
    bioController = TextEditingController(text: widget.bio);
    firstnameController = TextEditingController(text: widget.firstname);
    lastnameController = TextEditingController(text: widget.lastName);
    emailController = TextEditingController(text: widget.email);
    professionController = TextEditingController(text: widget.profession);
    genderController = TextEditingController(text: widget.gender);
    dateOfBirthController = TextEditingController(text: widget.dateOfBirth);
    districtController = TextEditingController(text: widget.district);
    locationController = TextEditingController(text: widget.location);
    phoneController = TextEditingController(text: widget.phone);


  }

  Future<void> editWorkReport() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    print(userid);
    var reqData = {
      'firstName': firstnameController.text,
      'lastName': lastnameController.text,
      'countryCode': _selectedCountry.phoneCode,
      'email': emailController.text,
      'bio': bioController.text,
      'profession': professionController.text,
      'gender': genderController.text,
      'dateOfBirth': dateOfBirthController.text,
      'district': districtController.text,
      'location': locationController.text,
      'phone': phoneController.text,

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
          firstname: firstnameController.text,
          lastName: lastnameController.text,
          countryCode: widget.countryCode,
          phone: phoneController.text,
          email: emailController.text,
          dateOfBirth: dateOfBirthController.text,
          gender: genderController.text,
          location: locationController.text,
          profession: professionController.text,
          district: districtController.text,
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
                  EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor),
                  ),
                  // prefixIcon: Icon(
                  //   Icons.person,
                  //   size: 15,
                  //   color: bordercolor,
                  // ),
                ),
                onChanged: (text) {
                  setState(() {
                    firstname = text;

                  });
                },
                style: TextStyle(color: textblack, fontSize: 14),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: lastnameController,
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
                    lastName = text;
                  });
                },
                style: TextStyle(color: textblack, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,),
              child: Row(
                children: [
                  Container(

                    decoration: BoxDecoration(
                        border: Border.all(
                            color: bordercolor
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: CountryPickerDropdown(

                        initialValue: _selectedCountry == null ? 'IN' : _selectedCountry.isoCode,
                        itemBuilder: (Country country) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              CountryPickerUtils.getDefaultFlagImage(country),
                              SizedBox(width: 5),
                              Text(
                                "${country.phoneCode}",
                                style: TextStyle(fontSize: 10),
                              ),
                              SizedBox(width: 5),
                              Text(
                                "${country.isoCode}",
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          );
                        },
                        onValuePicked: (Country country) {
                          setState(() {
                            _selectedCountry = country;
                            print(_selectedCountry);
                          });
                        },
                      ),
                    ),
                  ),

                  // SizedBox(width: 5,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: 169,

                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Phone Number',
                          hintStyle: TextStyle(color: textblack,fontSize: 12),
                          contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: bordercolor, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: bordercolor),
                          ),

                          // prefixIcon: Icon(
                          //   Icons.phone_android,
                          //   size: 15,// You can replace 'Icons.email' with the icon you want
                          //   color: bordercolor,
                          // ),

                        ),

                        onChanged: (text) {
                          setState(() {
                            phone=text;
                          });
                        },
                        style: TextStyle(color: textblack,fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Pay ID',
                  hintStyle: TextStyle(color: textblack, fontSize: 12),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 0),
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
                    email = text;
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
                    bio = text;
                  });
                },
                style: TextStyle(color: textblack, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: professionController,
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
                    profession = text;
                  });
                },
                style: TextStyle(color: textblack, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: genderController,
                decoration: InputDecoration(
                  hintText: 'Enter Your Gender',
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
                    gender = text;
                  });
                },
                style: TextStyle(color: textblack, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: dateOfBirthController,
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
                    dateOfBirth = text;
                  });
                },
                style: TextStyle(color: textblack, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: districtController,
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
                    district = text;
                  });
                },
                style: TextStyle(color: textblack, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: locationController,
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
                    location= text;
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
