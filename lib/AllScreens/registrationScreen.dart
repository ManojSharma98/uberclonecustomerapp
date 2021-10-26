import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ubercloneapp/AllScreens/loginScreen.dart';
import 'package:ubercloneapp/AllScreens/main_screen.dart';
import 'package:ubercloneapp/AllWidget/progressDialog.dart';
import 'package:ubercloneapp/main.dart';

class RegistrationScreen extends StatelessWidget {

  TextEditingController nameTextEditingController=TextEditingController();
  TextEditingController phoneTextEditingController=TextEditingController();
  TextEditingController emailTextEditingController=TextEditingController();
  TextEditingController passwordTextEditingController=TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 65.0,
              ),
              Image(
                image: AssetImage("images/uberlogo.png"),
                width: 250.0,
                height: 250.0,
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                "Register to uber Clone",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
              ),


              Padding(padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 1.0,),
                    TextField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "name",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(color: Colors.grey,fontSize: 10.0),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(color: Colors.grey,fontSize: 10.0),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(color: Colors.grey,fontSize: 10.0),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),


                    SizedBox(height: 1.0,),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(color: Colors.grey,fontSize: 10.0),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 10.0,),
                    RaisedButton(onPressed: (){

                      if(nameTextEditingController.text.length<5){
                          displayToastMessage("name must be atleast 3 Characters", context);
                      }
                      else if(!emailTextEditingController.text.contains("@")){
                        displayToastMessage("Email address is not valid", context);
                      }
                      else if(phoneTextEditingController.text.isEmpty){
                        displayToastMessage("Phone Number is mandatory", context);
                      }
                      else if(passwordTextEditingController.text.length<7){
                      displayToastMessage("Password must be atleast 6 characters", context);
                      }
                      else{
                        registerNewUser(context);
                      }
                    },
                      color: Colors.yellow,
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text("Register",style: TextStyle(fontSize: 18.0,fontFamily: "Brand Bold"),),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    )


                  ],
                ),
              ),

              FlatButton(onPressed: (){
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                        (Route<dynamic> route) => false);

              }, child: Text("Already have an Account? Login Here"),),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ProgressDialog(
            message: "Register yet, Please wait....",
          );
        });


    final UserCredential firebaseUser= (await _firebaseAuth.createUserWithEmailAndPassword(email: emailTextEditingController.text, password: passwordTextEditingController.text).catchError((errmsg){
      Navigator.pop(context);
      displayToastMessage("Error : "+ errmsg.toString(),  context);

    },));
    if(firebaseUser != null){
      // save user info to database
      Map userDataMap={
        "name" : nameTextEditingController.text.trim(),
        "email" : emailTextEditingController.text.trim(),
        "phone" : phoneTextEditingController.text.trim(),
      };

      userRef.child(firebaseUser.user!.uid).set(userDataMap);
      print('${firebaseUser.user!.uid}');
      displayToastMessage("Congratulations , your account has been created.", context);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => MainScreen()),
              (Route<dynamic> route) => false);
    }else{
      Navigator.pop(context);
      displayToastMessage("New user account has not been Created. ", context);
    }
  }

  void  displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }
}
