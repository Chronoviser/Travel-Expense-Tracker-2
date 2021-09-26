import 'package:travel_expense_tracker/models/record.dart';
import 'activity.dart';

class Trip {
  String id;
  String tripName;
  String from;
  String to;
  List<String> travellers = [];
  List<Activity> activities = [];
  List<Record> tally = [];

  Trip(this.tripName, this.from, this.to, this.travellers);

  Trip.withActivity(this.id, this.tripName, this.from, this.to, this.travellers,
      this.activities, this.tally);

  Trip.fromJSON(Map<String, dynamic> json) {
    id = json['id'];
    tripName = json['tripName'];
    from = json['from'];
    to = json['to'];
    json['travellers'].forEach((s) => travellers.add(s));
    json['activities'].forEach((a) => activities.add(Activity.fromJSON(a)));
    json['tally'].forEach((a) => tally.add(Record.fromJSON(a)));
  }

  // ignore: non_constant_identifier_names
  TripToJSON() {
    List<dynamic> _activities = [];
    this.activities.forEach((e) => _activities.add(e.ActivityToJSON()));

    List<dynamic> _tally = [];
    this.tally.forEach((e) => _tally.add(e.RecordToJSON()));

    return {
      'id': this.id,
      'tripName': this.tripName,
      'from': this.from,
      'to': this.to,
      'travellers': this.travellers,
      'activities': _activities,
      'tally': _tally
    };
  }

  // ignore: non_constant_identifier_names
  TripToJsonWithId() {
    List<dynamic> _activities = [];
    this.activities.forEach((e) => _activities.add(e.ActivityToJSON()));

    List<dynamic> _tally = [];
    this.tally.forEach((e) => _tally.add(e.RecordToJSON()));

    return {
      'id': this.id,
      'tripName': this.tripName,
      'from': this.from,
      'to': this.to,
      'travellers': this.travellers,
      'activities': _activities,
      'tally': _tally
    };
  }
}