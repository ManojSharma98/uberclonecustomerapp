
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:ubercloneapp/Models/address.dart';

class AppData extends ChangeNotifier{

   UserAddress? pickUpLocation,dropoffLocation;

  void updatePickupLocationAddress(UserAddress pickUpAddress){
    pickUpLocation=pickUpAddress;
    notifyListeners();

  }

   void updatedropOffLocationAddress(UserAddress dropOffAddress){
     dropoffLocation=dropOffAddress;
     notifyListeners();

   }



}