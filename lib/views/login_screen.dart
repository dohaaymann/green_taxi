import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_taxi/views/driver/register.dart';
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
import '../widgets/login_widget.dart';
import 'driver/profile_setup.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  const  LoginScreen({Key? key}) : super(key: key);


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

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

  bool isLoginAsDriver = false;  decideRoute() {
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
  login()async{
    late BuildContext dialogContext = context;
    if(lpass.text.isEmpty||lemail.text.isEmpty){
      print("emptyyyy");return null;
    }
    else{
      var user;
      try {
        user = await auth.signInWithEmailAndPassword(email:lemail.text, password:lpass.text).
        catchError((err){
          Timer? timer = Timer(Duration(milliseconds: 3000), (){
            Navigator.pop(dialogContext);
          });
          if (err.code == "invalid-email") {
            return showDialog(
                context: context,
                builder: (context) {
                  dialogContext=context;
                  return AlertDialog(insetPadding: EdgeInsets.all(4),contentPadding: EdgeInsets.all(13),shape: OutlineInputBorder(borderSide: BorderSide.none),
                    backgroundColor:Colors.black,
                    // backgroundColor:Color.fromRGBO(103, 0, 92,4),
                    content: Text(
                      "Please enter a valid email address",textAlign:TextAlign.center,style: TextStyle(fontWeight:FontWeight.bold,fontSize: 18,color: Colors.white),),
                  );}).then((value){
              timer?.cancel();
              // timer = null;
            });
          } if (err.message =="The password is invalid or the user does not have a password.") {
            return showDialog(
                context: context,
                builder: (context) {dialogContext=context;return AlertDialog(insetPadding: EdgeInsets.all(4),contentPadding: EdgeInsets.all(13),shape: OutlineInputBorder(borderSide: BorderSide.none),
                  backgroundColor:Colors.black,
                  // backgroundColor:Color.fromRGBO(103, 0, 92,4),
                  content: Container(width: double.infinity,
                    child: Text(
                      "ًWrong email address or password",textAlign:TextAlign.center,style: TextStyle(fontWeight:FontWeight.bold,fontSize: 18,color: Colors.white),),
                  ),
                );}).then((value){
              timer?.cancel();
              // timer = null;
            });
          }  if (err.message =="There is no user record corresponding to this identifier. The user may have been deleted.") {
            return showDialog(
                context: context,
                builder: (context){
                  dialogContext=context;
                  return AlertDialog(insetPadding: EdgeInsets.all(4),contentPadding: EdgeInsets.all(13),shape: OutlineInputBorder(borderSide: BorderSide.none),
                    backgroundColor:Colors.black,
                    // backgroundColor:Color.fromRGBO(103, 0, 92,4),
                    content: Text(
                      "Email is not register with us",textAlign:TextAlign.center,style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20,color: Colors.white),),
                  );}).then((value){
              timer?.cancel();
              // timer = null;
            });
          }
          return showDialog(
              context: context,
              builder: (BuildContext context) {
                dialogContext=context;
                return AlertDialog(insetPadding: EdgeInsets.all(4),contentPadding: EdgeInsets.all(8),shape: OutlineInputBorder(borderSide: BorderSide.none),
                    backgroundColor:Colors.black,
                    // backgroundColor:Color.fromRGBO(103, 0, 92,4),
                    content: Text(err.message,textAlign:TextAlign.center,style: TextStyle(fontWeight:FontWeight.bold,fontSize: 18,color: Colors.white),)
                );});

        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }}
      print("-------------");
      print("email: "+"${ lemail}");
      print("pass: "+"${lpass}");
      if(user!=null){
        showDialog(
            context: context,
            builder: (BuildContext context) {dialogContext=context;
            return Container( color:Colors.black45,height:double.infinity,child: Center(child:
            SizedBox(height:50,width:50,child: CircularProgressIndicator(color: Colors.blueAccent,strokeWidth:7,))));});

        Timer(Duration(seconds: 3), (){
          Get.to((decideRoute()));
          // Bool.ch_F_load();
        });
      }
    }
  }
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
          Column(children: [
            Container( margin: EdgeInsets.only(top:4,left: 8,right: 8),
                child:
                TextField(
                    cursorColor: Colors.indigo,controller: lemail,
                    decoration:InputDecoration(suffixIcon:Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.person),
                    ),border: OutlineInputBorder(borderRadius:BorderRadius.circular(20)),
                      hintText: "Email",
                    ))
            ),
            Container( margin: EdgeInsets.only(top: 8,left: 8,right: 8),
              child: TextFormField(
                cursorColor: Colors.indigo,obscureText:!obscure,controller: lpass,
                decoration:InputDecoration(  hintText: "Password",
                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),border:
                    OutlineInputBorder(borderRadius:BorderRadius.circular(20)),
                    suffixIcon:Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(onPressed:(){
                        print(remail);
                        obscure=!obscure;(context as Element).markNeedsBuild();
                      },icon:Icon(Icons.password)),

                    )),
              ),),
            Align(alignment: Alignment.centerRight,child: TextButton(onPressed: (){
              // Navigator.of(context).pushNamed("forget");
              // Navigator.of(context).pushNamed("f_pass");
              // print(FirebaseAuth.instance.currentUser);
              // Get.offAll(() => HomeScreen());
              Get.offAll(() => register());
              // Get.offAll(() => ProfileSettingScreen());
              // Get.offAll(() => DriverProfileSetup());
            },child: Text("forgot Password?"),),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(onPressed:login, child:Text("Login",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),),style:
              ElevatedButton.styleFrom(fixedSize:Size(200,50),backgroundColor:Colors.green),
              ),
            ),
            ],
          ),
        ]),
      ),
    ));
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