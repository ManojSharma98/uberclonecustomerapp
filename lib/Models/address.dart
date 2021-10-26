class UserAddress {
  String? placeFormattedAddress;
  String placename;
  String? placeId;
  double latitude;
  double longitude;

  UserAddress(
      { this.placeFormattedAddress,
      required this.placename,
       this.placeId,
      required this.latitude,
      required this.longitude});
}
