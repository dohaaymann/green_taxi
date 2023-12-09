import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_taxi/views/driver/profile_setup.dart';
import 'package:green_taxi/views/otp_verification_screen.dart';
import 'package:green_taxi/views/profile_settings.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_taxi/utils/app_constants.dart';
import 'package:green_taxi/views/otp_verification_screen.dart';
import 'package:green_taxi/widgets/text_widget.dart';

import '../widgets/green_intro_widget.dart';
import 'home.dart';
import 'login_screen.dart';
// import '../widgets/green_intro_widget.dart';
// import '../widgets/login_widget.dart';
// import 'driver/profile_setup.dart';

class register extends StatefulWidget {
  const  register({Key? key}) : super(key: key);


  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {

  final countryPicker = const FlCountryCodePicker();
  CountryCode countryCode = CountryCode(name: 'EGYPT', code: "EG", dialCode: "+20");

  // onSubmit(String? input){
  //   Navigator.of(context).push(MaterialPageRoute(builder: (context) =>;
  //   // Get.to((OtpVerificationScreen(countryCode.dialCode+input!))))=>);
  // }
  var isDecided = false;
  String userUid = '';
  var verId = '';
  int? resendTokenId;
  bool phoneAuthCheck = false;
  dynamic credentials;
  var isProfileUploading = false.obs;
  bool isLoginAsDriver = false;
  decideRoute() {
    if (isDecided) {
      return;
    }
    isDecided = true;

    print("called");
    ///step 1- Check user login?
 var user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      /// step 2- Check whether user profile exists?
      ///isLoginAsDriver == true means navigate it to the driver module
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((value) {
        ///isLoginAsDriver == true means navigate it to driver module
        if(isLoginAsDriver){
          if (value.exists) {
            print("Driver HOme Screen");
          } else {
            Get.offAll(() => DriverProfileSetup());
          }

        }else{
          if (value.exists) {
            Get.offAll(() => HomeScreen());
          } else {
            Get.offAll(() => ProfileSettingScreen());
          }
        }
      }).catchError((e) {
        print("Error while decideRoute is $e");
      });
    }
  }
  var obscure=false;
  var fname='',lname='',remail='',rpass='';
  TextEditingController lpass=new TextEditingController();
  TextEditingController lemail=new TextEditingController();
  final auth=FirebaseAuth.instance;
  final User=FirebaseFirestore.instance.collection('users');


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Container(
          width: Get.width,
          height: Get.height,
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  greenIntroWidget(),
                  SizedBox(height: 20,),
                  //   ElevatedButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) =>ProfileSettingScreen() ,));
                  // }, child: Text("d"))
                  //   loginWidget(countryCode,()async{
                  //     final code = await countryPicker.showPicker(context: context);
                  //     if (code != null)  countryCode = code;
                  //     setState(() {
                  //     });
                  //   }),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(children: [
                Row(children: [
                  Expanded(
                    child: Container( margin: EdgeInsets.all(4),
                        child: TextFormField(cursorColor: Colors.indigo,onChanged: (v){setState(() {
                          fname=v;
                        });},
                            decoration:InputDecoration(border: OutlineInputBorder(borderRadius:BorderRadius.circular(20)),
                              hintText: "First name",
                            ))),
                  ), Expanded(
                    child: Container( margin: EdgeInsets.all(4),
                        child: TextFormField(cursorColor: Colors.indigo,onChanged: (v){setState(() {
                          lname=v;
                        });},
                            decoration:InputDecoration(border: OutlineInputBorder(borderRadius:BorderRadius.circular(20)),
                              hintText: "Last name",
                            ))),
                  ),
                ],),
                Container( margin: EdgeInsets.all(4),
                    child: TextFormField(cursorColor: Colors.indigo,onChanged: (v){setState(() {
                      remail=v;
                    });},
                        decoration:InputDecoration(suffixIcon:Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.email_outlined,size: 25,),
                        ),border: OutlineInputBorder(borderRadius:BorderRadius.circular(20)),
                          hintText: "Email",
                        ))),

                Container( margin: EdgeInsets.all(4),
                    child: TextFormField(cursorColor: Colors.indigo,obscureText:!obscure,onChanged: (v){setState(() {
                      rpass=v;
                    });}, scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                        decoration:InputDecoration(suffixIcon: IconButton(onPressed: () async{
                          obscure=!obscure;(context as Element).markNeedsBuild();
                        }, icon:Icon(Icons.password)),border: OutlineInputBorder(borderRadius:BorderRadius.circular(20)),
                          hintText: "Password",
                        ))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [ Text(
                        'Aleardy have an account?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                         TextButton(
                      onPressed: (){
                       Get.to(LoginScreen());
                      },
                      child: Text(
                        'login',
                        style: TextStyle(
                          color: Color(0xff0000EE),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: ()async{
                    var user;
                    late BuildContext dialogContext = context;
                    late BuildContext mdialogContext = context;
                    if(rpass.isEmpty||remail.isEmpty||fname.isEmpty||lname.isEmpty){
                      print("emptyyyy");
                      Get.snackbar('Warning','Please fill the fields',colorText: Colors.white,
                          backgroundColor: Colors.red);
                      return null;
                    }
                    else{
                      Timer? timer = Timer(Duration(milliseconds: 3000), (){
                        Navigator.pop(dialogContext);
                      });
                      try{
                        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: remail, password: rpass)
                            .then((value)async {
                          user=await auth.signInWithEmailAndPassword(email:remail,password:rpass).then((value)async{
                            await FirebaseFirestore.instance.collection("account").doc("${remail}").
                            set({"fname":fname,"lname":lname,"pass":rpass,"phone":null});


                          });
                        }
                        ).catchError((err) {
                          return showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                dialogContext = context;
                                return
                                  AlertDialog(insetPadding: EdgeInsets.all(4),
                                      contentPadding: EdgeInsets.all(12),
                                      shape: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      backgroundColor: Colors.black,
                                      content: Text(
                                        err.message, textAlign: TextAlign.center,
                                        style: TextStyle(fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.white),)
                                  );
                              });
                        } );
                      }catch (e) {
                        print("%%%%%%%%%%%%%%5$e");
                      }
                      if(user!=null){
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              mdialogContext=context;
                              return Container( color:Colors.black45,height:double.infinity,child: Center(child:
                              SizedBox(height:50,width:50,child: CircularProgressIndicator(color: Colors.black,strokeWidth:7,))));});

                        Timer(Duration(seconds: 3), (){
                          Navigator.pop(mdialogContext);
                          Get.to((decideRoute()));
                        });}
                    }}, child:Text("Sign up",style: TextStyle(fontSize: 20,color: Colors.white),),style:
                  ElevatedButton.styleFrom(fixedSize:Size(200,50),backgroundColor:Colors.green),
                  ),
                ),

              ],),
            ),
          ]),
        )));
  }
}
Widget loginWidget(CountryCode countryCode, Function onCountryChange) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget(text: AppConstants.helloNiceToMeetYou),
        textWidget(
            text: AppConstants.getMovingWithGreenTaxi,
            fontSize: 22,
            fontWeight: FontWeight.bold),
        const SizedBox(
          height: 40,
        ),
        Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 3,
                    blurRadius: 3)
              ],
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () => onCountryChange(),
                  child: Container(
                    child: Row(
                      children: [
                        const SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            child: countryCode.flagImage(), // Use flagImage directly
                          ),
                        ),
                        textWidget(text: countryCode.dialCode),
                        Icon(Icons.keyboard_arrow_down_rounded)
                      ],
                    ),
                  ),
                ),),
              Container(
                width: 1,
                height: 55,
                color: Colors.black.withOpacity(0.2),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    onSubmitted: (String? input) {
                      // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>OtpVerificationScreen(countryCode.dialCode+input!)));
                      // Get.to((OtpVerificationScreen(countryCode.dialCode+input!)));
                    },
                    decoration: InputDecoration(
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 12, fontWeight: FontWeight.normal),
                        hintText: AppConstants.enterMobileNumber,
                        border: InputBorder.none),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                style: GoogleFonts.poppins(color: Colors.black, fontSize: 12),
                children: [
                  TextSpan(
                    text: AppConstants.byCreating + " ",
                  ),
                  TextSpan(
                      text: AppConstants.termsOfService + " ",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  TextSpan(
                    text: "and ",
                  ),
                  TextSpan(
                      text: AppConstants.privacyPolicy + " ",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                ]),
          ),
        )
      ],
    ),
  );
}
// Widget loginWidget(CountryCode countryCode, Function onCountryChange) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 20),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         textWidget(text: AppConstants.helloNiceToMeetYou),
//         textWidget(
//             text: AppConstants.getMovingWithGreenTaxi,
//             fontSize: 22,
//             fontWeight: FontWeight.bold),
//         const SizedBox(
//           height: 40,
//         ),
//         Container(
//           width: double.infinity,
//           height: 55,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 spreadRadius: 3,
//                 blurRadius: 3,
//               )
//             ],
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 flex: 1,
//                 child: InkWell(
//                   onTap: () => onCountryChange(),
//                   child: Container(
//                     child: Row(
//                       children: [
//                         const SizedBox(width: 5),
//                         Expanded(
//                           child: Container(
//                             child: countryCode.flagImage, // Use flagImage directly
//                           ),
//                         ),
//                         textWidget(text: countryCode.dialCode),
//                         Icon(Icons.keyboard_arrow_down_rounded)
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 width: 1,
//                 height: 55,
//                 color: Colors.black.withOpacity(0.2),
//               ),
//               Expanded(
//                 flex: 3,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                   child: TextField(
//                     onSubmitted: (String? input) {
//                       // Handle submission logic
//                     },
//                     decoration: InputDecoration(
//                       hintStyle: GoogleFonts.poppins(
//                         fontSize: 12,
//                         fontWeight: FontWeight.normal,
//                       ),
//                       hintText: AppConstants.enterMobileNumber,
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         // ... (existing code)
//       ],
//     ),
//   );
// }
