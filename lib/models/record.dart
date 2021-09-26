class Record {
 String by;
 String to;
 int amount;

 Record(this.by, this.to, this.amount);

 Record.fromJSON(Map<String, dynamic> json) {
    by = json['by'];
    to = json['to'];
    amount = json['amount'];
  }

  // ignore: non_constant_identifier_names
 RecordToJSON() {
    return {
      'by': this.by,
      'to': this.to,
      'amount': this.amount
    };
  }
}