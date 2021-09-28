import '../constants/global-user.dart';
import 'trip.dart';

class MyTrips {
  static List<Trip> trips = new List();

  MyTrips.fromJSON(List<dynamic> json) {
    trips.clear();

    json.forEach((v) {
      if (GlobalUser.trips.contains(v.data()['id'])) {
        trips.add(Trip.fromJSON(v.data()));

      }
    });
  }
}
