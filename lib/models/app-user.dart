class AppUser {
  String email;
  List<String> trips = [];

  AppUser(this.email, this.trips);

  AppUser.fromJSON(Map<String, dynamic> json) {
    email = json['email'];
    json['trips'].forEach((a) => trips.add(a));
  }

  // ignore: non_constant_identifier_names
  AppUserToJSON() {
    return {'email': this.email, 'trips': this.trips};
  }
}
