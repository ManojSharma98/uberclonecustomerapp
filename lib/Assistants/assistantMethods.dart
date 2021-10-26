
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ubercloneapp/Assistants/requestAssistants.dart';
import 'package:ubercloneapp/DataHandler/appData.dart';
import 'package:ubercloneapp/Models/address.dart';
import 'package:ubercloneapp/Models/allUsers.dart';
import 'package:ubercloneapp/Models/directDetails.dart';
import 'package:ubercloneapp/configMaps.dart';

class AssistantMethods{
  static Future<String> searchCoordinateAddress(Position position,context) async{
    String placeAddress="";
    String str1,str2,str3,str4;

    String url="https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

    var response =await RequestAssistant.getRequest(url);
    if( response!="Failed"){
    //  placeAddress =response['results'][0]['formatted_address'];

      str1=response['results'][0]['address_components'][3]["long_name"];
      str2=response['results'][0]['address_components'][4]["long_name"];
      str3=response['results'][0]['address_components'][5]["long_name"];
      str4=response['results'][0]['address_components'][6]["long_name"];

      placeAddress=str1+" ,"+str2+" ,"+str3+" ,"+str4;


      UserAddress  userpickupAddress=new UserAddress(placename: placeAddress, latitude: position.latitude, longitude: position.longitude);

      Provider.of<AppData>(context,listen: false).updatePickupLocationAddress(userpickupAddress);


    }
     return placeAddress;
  }

  static Future<DirectionDetails?> obtainPlaceDirectionDetails(LatLng initialPosition, LatLng finalPosition) async{
      String directionUrl="https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";
      var res=await RequestAssistant.getRequest(directionUrl);
      if(res=="Failed"){
        return null;
      }

     DirectionDetails directionDetails=DirectionDetails();
      directionDetails.encodedPoints=res["routes"][0]["overview_polyline"]["points"];
      directionDetails.distanceText=res["routes"][0]["legs"][0]["distance"]["text"];
      directionDetails.distanceValue=res["routes"][0]["legs"][0]["distance"]["value"];

      directionDetails.durationText=res["routes"][0]["legs"][0]["duration"]["text"];
      directionDetails.durationValue=res["routes"][0]["legs"][0]["duration"]["value"];

      return directionDetails;
  }


  static int calculateFares(DirectionDetails directionDetails){
    double timeTraveledfare= (directionDetails.durationValue! / 60)*0.20;
    double diatanceTraveledfare= (directionDetails.distanceValue! / 1000)*0.20;

    double totalFareAmount  = timeTraveledfare + diatanceTraveledfare;

    //  1$=160 Rs
    //double totalLocalAmount  = totalFareAmount*160;

    return totalFareAmount.truncate();

  }


  static void getCurrentOnlineUserInfo() async {
    firebaseUser = await FirebaseAuth.instance.currentUser;
    String userId = firebaseUser!.uid;

    DatabaseReference reference = FirebaseDatabase.instance.reference().child(
        "users").child(userId);

    reference.once().then((DataSnapshot dataSnapshot) {
      if(dataSnapshot.value!=null){
        userCurrentInfo=Users.fromSnapshot(dataSnapshot);
      }

    });
  }

}