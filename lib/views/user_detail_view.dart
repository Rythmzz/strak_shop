import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:strak_shop_project/models/info_user_model.dart';
import 'package:strak_shop_project/services/database.dart';

import '../services/auth.dart';
import '../services/colors.dart';
import '../services/storage_repository.dart';
import 'order_detail_view.dart';

class DetailUserPage extends StatelessWidget{
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Consumer<InfoUserModel>(builder: (context,snapshot,_){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserDetailView()));
            },
            child: ListTile(
              title: Text("Profile",style: TextStyle(
                color: StrakColor.colorTheme7,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),),
              leading: Icon(Icons.account_circle,color: Colors.lightBlueAccent,),
            ),
          ),
          Divider(height: 3,color: StrakColor.colorTheme6),
          InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderView(currentUserUid: snapshot.getListInfoUser!.uid,)));
            },
            child: ListTile(
              title: Text("Order",style: TextStyle(
                color: StrakColor.colorTheme7,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),),
              leading: Icon(Icons.sticky_note_2_outlined,color: Colors.lightBlueAccent,),
            ),
          ),
          Divider(height: 3,color: StrakColor.colorTheme6),
          InkWell(
            onTap: (){
              showDialog(context: context, builder: (context) => AlertDialog(
                title: Text("Log out"),
                content: Container(
                  width: 100,
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Are you sure you want to log out?"),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(onPressed: (){
                            Navigator.of(context).dispose();
                          }, child: Text("Cancel")),
                          ElevatedButton(onPressed: (){
                            Navigator.of(context).pop();
                            _authService.signOut();
                          }, child: Text("OK"))
                        ],
                      )
                    ],
                  ),
                ),

              ));
            },
            child: ListTile(
              title: Text("Sign Out",style: TextStyle(
                color: StrakColor.colorTheme7,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),),
              leading: Icon(Icons.exit_to_app,color: Colors.lightBlueAccent,),
            ),
          ),


        ],
      );
    });
  }

}

class UserDetailView extends StatelessWidget{
  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    DateTime date =  DateTime(now.year,now.month,now.day);
    return Consumer<InfoUserModel>(builder: (context,snapshot,_){
      return Scaffold(
        appBar: AppBar( actions: [
          Container(
            width: 50,
            height: 50,
            decoration: ShapeDecoration(shape: CircleBorder(side: BorderSide(color: StrakColor.colorTheme6,width: 2)),image: DecorationImage(image: AssetImage("assets/images_app/logo_strak_red.png"),fit: BoxFit.fitWidth)),
          ),
          SizedBox(width: 30,)
        ],
          backgroundColor: Colors.white,
          title: Container(
            alignment: Alignment.centerLeft,
            height: 50,
            child: Text("Profile",style: TextStyle(
                color: StrakColor.colorTheme7,
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),),
          ),
          toolbarHeight: 80,
          foregroundColor: Colors.grey,
        ),
        body: SafeArea(child: SingleChildScrollView(
          child: Card(
            elevation: 8,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(onTap: () async{
                        final ImagePicker _picked = ImagePicker();
                        final XFile? image =await _picked.pickImage(source: ImageSource.gallery);
                        if(image?.name != null){
                          StorageRepository().uploadFileImageAvatar(image!, 'user', snapshot.getListInfoUser!.uid,snapshot.getListInfoUser!.imageName);
                        }
                      },
                          child: snapshot.getListInfoUser?.imageUrls == "" ? SizedBox(width: 72,height: 72,
                            child: CircleAvatar(
                              child: Icon(Icons.account_circle_outlined),
                            ),
                          ) : SizedBox(width: 72,height: 72,child: CircleAvatar(backgroundColor: StrakColor.colorTheme6,backgroundImage: CachedNetworkImageProvider(snapshot.getListInfoUser?.imageUrls ?? "https://www.iconpacks.net/icons/2/free-user-icon-3296-thumb.png"),))
                      ),
              SizedBox(width: 20,),
                      Column(
                        children: [
                          Text(snapshot.getListInfoUser!.fullName,style: TextStyle(
                            color: StrakColor.colorTheme7,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),),
                          SizedBox(height: 5,),
                          Text("@${snapshot.getListInfoUser!.fullName.replaceAll(' ', '_')}",style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12
                          ),)

                        ],
                      ),

                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      InkWell(
                          onTap: (){
                            showDialog(context: context, builder: (context){
                              gender _selectGender;
                              if (snapshot.getListInfoUser!.gender == "male"){
                                _selectGender = gender.male;
                              }
                              else {
                                _selectGender = gender.female;
                              }
                              return AlertDialog(
                                title: Text("Edit Gender"),
                                content: StatefulBuilder(
                                  builder: (BuildContext context,StateSetter setState){
                                    return  Container(
                                      width: 200,
                                      height: 200,
                                      child: Column(
                                        children: [
                                          ListTile(
                                            title: const Text('Male'),
                                            trailing: Icon(Icons.male,color: Colors.lightBlueAccent,),
                                            leading: Radio<gender>(
                                              value: gender.male,
                                              groupValue: _selectGender,
                                              onChanged: (gender? value) {
                                                setState(() {
                                                  _selectGender = value!;
                                                });
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            title: const Text('Female'),
                                            trailing:Icon(Icons.female,color: Colors.pinkAccent,),
                                            leading: Radio<gender>(
                                              value: gender.female,
                                              groupValue: _selectGender,
                                              onChanged: (gender? value) {
                                                setState(() {
                                                  _selectGender = value!;
                                                });
                                              },
                                            ),
                                          ),
                                         SizedBox(height: 20,),
                                         Row(
                                           mainAxisAlignment: MainAxisAlignment.end,
                                           children: [
                                             ElevatedButton(onPressed: () async {
                                               await DatabaseService(snapshot.getListInfoUser!.uid).updateGenderUser(_selectGender.name);
                                               Navigator.of(context).pop();
                                             }, child: Text("Confirm")),
                                             SizedBox(width: 20,),
                                             ElevatedButton(onPressed: () {
                                               Navigator.of(context).pop();
                                             }, child: Text("Cancel"))
                                           ],
                                         )
                                        ],
                                      ),
                                    );
                                  },
                                )
                              );


                            });

                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  snapshot.getListInfoUser!.gender == "male" ? Icon(Icons.male,color: Colors.lightBlueAccent,) :
                                  Icon(Icons.female,color: Colors.pinkAccent,),
                                 SizedBox(width: 10,),
                                 Text("Gender",style: TextStyle(
                                    color: StrakColor.colorTheme7,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(snapshot.getListInfoUser!.gender == "male" ? "Male" : "Female",style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey
                                  ),),
                                  SizedBox(width: 10,),
                                  Icon(Icons.chevron_right,color: Colors.grey,)
                                ],
                              )
                            ],
                          )
                      ),
                      SizedBox(height: 20,),
                      InkWell(
                          onTap: () async {
                           DateTime? newDate = await showDatePicker(context: context, initialDate: date, firstDate: DateTime(1900), lastDate: DateTime(2100)
                            );
                           if (newDate == null) return;
                           else {
                             date = newDate;
                             await DatabaseService(snapshot.getListInfoUser!.uid).updateBirthDayUser(date);
                           }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.calendar_month,color: Colors.lightBlueAccent,) ,
                                  SizedBox(width: 10,),
                                  Text("Birthday",style: TextStyle(
                                    color: StrakColor.colorTheme7,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(snapshot.getListInfoUser!.birthDay,style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey
                                  ),),
                                  SizedBox(width: 10,),
                                  Icon(Icons.chevron_right,color: Colors.grey,)
                                ],
                              )
                            ],
                          )
                      ),
                      SizedBox(height: 20,),
                      InkWell(
                          onTap: (){
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.email_outlined,color: Colors.lightBlueAccent,) ,
                                  SizedBox(width: 10,),
                                  Text("Email",style: TextStyle(
                                    color: StrakColor.colorTheme7,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(snapshot.getListInfoUser!.email,style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey
                                  ),),
                                  SizedBox(width: 10,),
                                  Icon(Icons.chevron_right,color: Colors.grey,)
                                ],
                              )
                            ],
                          )
                      ),
                      SizedBox(height: 20,),
                      InkWell(
                          onTap: (){
                            showDialog(context: context, builder: (context){
                              List<String> phone = ["+84",""].toList(growable: false);
                              return AlertDialog(
                                  title: Text("Edit Phone Number"),
                                  content: StatefulBuilder(
                                    builder: (BuildContext context,StateSetter setState){
                                      return  Container(
                                        width: 250,
                                        height: 150,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                          Row(
                                            children: [
                                              CountryCodePicker(
                                                flagWidth: 20,
                                                onChanged: (CountryCode countryCode){
                                                  phone[0] = countryCode.toString();
                                                },
                                                initialSelection: '+84',
                                                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                                favorite: ['+39','FR'],
                                                // optional. Shows only country name and flag
                                                showCountryOnly: false,
                                                // optional. Shows only country name and flag when popup is closed.
                                                showOnlyCountryWhenClosed: false,
                                                // optional. aligns the flag and the Text left
                                                alignLeft: false,
                                              ),
                                              SizedBox(width: 5,),
                                             Expanded(child: TextField(
                                               onChanged: (val ){
                                                 phone[1] = val;
                                               },
                                               decoration: InputDecoration(
                                                 enabledBorder: OutlineInputBorder(
                                                     borderSide: BorderSide(color: StrakColor.colorTheme6,width:3)
                                                 ),
                                                 border: OutlineInputBorder(
                                                     borderSide: BorderSide(width:3)
                                                 ),
                                                 hintText: "Enter Number Phone",
                                               ),style: TextStyle(
                                                 fontSize: 12
                                             ),
                                             ))
                                            ],
                                          ),SizedBox(height: 20,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                ElevatedButton(onPressed: () async {
                                                  if(phone[1] != ""){
                                                    await DatabaseService(snapshot.getListInfoUser!.uid).updatePhoneNumberUser(phone);
                                                  }
                                                  Navigator.of(context).pop();
                                                }, child: Text("Confirm")),
                                                SizedBox(width: 20,),
                                                ElevatedButton(onPressed: () {
                                                  Navigator.of(context).pop();
                                                }, child: Text("Cancel"))
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  )
                              );


                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.phone_android_outlined,color: Colors.lightBlueAccent,) ,
                                  SizedBox(width: 10,),
                                  Text("Phone",style: TextStyle(
                                    color: StrakColor.colorTheme7,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(snapshot.getListInfoUser!.phone,style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey
                                  ),),
                                  SizedBox(width: 10,),
                                  Icon(Icons.chevron_right,color: Colors.grey,)
                                ],
                              )
                            ],
                          )
                      ),
                    ],
                  ),
                )



              ],
            ),
          ),
        )),
      );
    });
  }
//   ElevatedButton(onPressed: () async{
//   _authService.signOut();
// }, child: Text("Sign Out"))



}

enum gender {male,female}
