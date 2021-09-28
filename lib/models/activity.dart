import 'spending.dart';

class Activity {
  String activity;
  int price;
  String paidBy;
  String type;
  List<Spending> spendings = [];

  Activity(this.activity, this.price, this.paidBy, this.type, this.spendings);

  Activity.fromJSON(Map<String, dynamic> json) {
    activity = json['activity'];
    price = json['price'];
    paidBy = json['paidBy'];
    type = json['type'];
    json['spendings'].forEach((a) => spendings.add(Spending.fromJSON(a)));
  }

  // ignore: non_constant_identifier_names
  ActivityToJSON() {
    List<dynamic> _spendings = [];
    this.spendings.forEach((e) => _spendings.add(e.SpendingToJSON()));

    return {
      'activity': this.activity,
      'price': this.price,
      'paidBy': this.paidBy,
      'type': this.type,
      'spendings': _spendings
    };
  }
}
