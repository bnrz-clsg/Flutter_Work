class Address {
  String placeName;
  String placeId;
  String placeFormattedAddress;
  double latitude;
  double longitude;

  Address(
      {
      this.placeId,
      this.latitude,
      this.longitude,
      this.placeName,
      this.placeFormattedAddress});
}
