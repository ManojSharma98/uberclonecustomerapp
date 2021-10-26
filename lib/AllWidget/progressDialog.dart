import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {

  String message;

  ProgressDialog({Key? key,required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        margin: EdgeInsets.all(15.0),
        width:  double.infinity,
         decoration: BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.circular(10.0),
         ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(width: 6.0,),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),),
              SizedBox(width: 26.0,),
              Text(message,
              style: TextStyle(color: Colors.black,fontSize: 10.0),
              )

            ],
          ),
        ),

      ),
    );

  }
}
