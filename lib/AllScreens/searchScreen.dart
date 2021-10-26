import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';
import 'package:ubercloneapp/AllWidget/Divider.dart';
import 'package:ubercloneapp/AllWidget/progressDialog.dart';
import 'package:ubercloneapp/Assistants/requestAssistants.dart';
import 'package:ubercloneapp/DataHandler/appData.dart';
import 'package:ubercloneapp/Models/address.dart';
import 'package:ubercloneapp/Models/placePredictions.dart';
import 'package:ubercloneapp/configMaps.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickupTextEditingController = TextEditingController();
  TextEditingController dropOfTextEditingController = TextEditingController();

  List<PlacePredictions> placePredictionList = [];

  @override
  Widget build(BuildContext context) {
    String placeAddress =
        Provider.of<AppData>(context).pickUpLocation!.placename ?? "";
    pickupTextEditingController.text = placeAddress;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search Location",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              // Put icon of your preference.
              onPressed: () {
                // your method (function),
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 180.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                )
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  left: 15.0, top: 5.0, right: 15.0, bottom: 20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 5.0,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'images/pickicon.png',
                        height: 16.0,
                        width: 16.0,
                      ),
                      SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TextField(
                            controller: pickupTextEditingController,
                            decoration: InputDecoration(
                              hintText: "PickUp Location",
                              filled: true,
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.only(
                                  left: 11.0, top: 15.0, bottom: 15.0),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'images/desticon.png',
                        height: 16.0,
                        width: 16.0,
                      ),
                      SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TextField(
                            onChanged: (val) {
                              findPlace(val);
                            },
                            controller: dropOfTextEditingController,
                            decoration: InputDecoration(
                              hintText: "Where to go ?",
                              filled: true,
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.only(
                                  left: 11.0, top: 15.0, bottom: 15.0),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),

          //tiles for display predictions
          (placePredictionList.length > 0)
              ? Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListView.separated(
                      padding: EdgeInsets.all(0.0),
                      separatorBuilder: (BuildContext context, int index) =>
                          DividerWidget(),
                      itemCount: placePredictionList.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return PredictionTile(
                            placePredictions: placePredictionList[index]);
                      }),
                )
              : Container(),
        ],
      ),
    );
  }

  void findPlace(String placeName) async {
    if (placeName.length > 1) {
      String autoCompleteUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:in";
      var res = await RequestAssistant.getRequest(autoCompleteUrl);
      if (res == "Failed") {
        return;
      }
      if (res["status"] == "OK") {
        var predictions = res["predictions"];
        var placesList = (predictions as List)
            .map((e) => PlacePredictions.fromJson(e))
            .toList();
        setState(() {
          placePredictionList = placesList;
        });
      }
    }
  }
}

class PredictionTile extends StatelessWidget {
  final PlacePredictions placePredictions;

  const PredictionTile({Key? key, required this.placePredictions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: (){
        getplaceAddressDetails(placePredictions.place_id, context);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(
              width: 14.0,
            ),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 14.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        placePredictions.main_text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        placePredictions.secondary_text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
  void getplaceAddressDetails(String placeId,context) async{
    showDialog(context: context, builder: (BuildContext context)=>ProgressDialog(message: "Settings DropOff, Please wait..."));

    
    String placeDetailsUrl="https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";
    var res=await RequestAssistant.getRequest(placeDetailsUrl);
    Navigator.pop(context);
    if(res=="Failed")
      {
        return;
      }
    if(res["status"]=="OK"){
      UserAddress address=UserAddress(placename: res["result"]["name"],placeId: placeId, latitude: res["result"]["geometry"]["location"]["lat"], longitude: res["result"]["geometry"]["location"]["lng"]);

      Provider.of<AppData>(context,listen: false).updatedropOffLocationAddress(address);
      print(address.placename);

      Navigator.pop(context,"obtainDirection");
    }
  }
}
