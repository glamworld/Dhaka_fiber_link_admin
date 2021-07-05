class CustomerModel{
  int? id;
  String? name;
  String? address;
  String? phone;
  String? billAmount;
  String? billState;
  String? dueAmount;
  String? lastEntryYear;
  String? lastEntryMonth;
  String? monthYear;
  String? activity;
  String? deductKey;
  String? package;

  CustomerModel(
      {this.id,
      this.name,
      this.address,
      this.phone,
      this.billAmount,
      this.billState,
      this.dueAmount,
      this.lastEntryYear,
      this.lastEntryMonth,
      this.monthYear,
      this.activity,
      this.deductKey,
      this.package});
}