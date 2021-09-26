class Spending {
  String name;
  int amount;

  Spending(this.name, this.amount);

  Spending.fromJSON(Map<String, dynamic> json) {
    name = json['name'];
    amount = json['amount'];
  }

  // ignore: non_constant_identifier_names
  SpendingToJSON() {
    return {
      'name': this.name,
      'amount': this.amount
    };
  }
}