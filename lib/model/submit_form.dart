import 'package:tto/widgets/carrier_list_form.dart';
import 'package:tto/widgets/item_list_form.dart';

class SubmitForm {
  SubmitForm({
    this.origin,
    this.destination,
    this.nip,
    this.notes,
    this.vehicle,
    this.item,
  });
  String? origin;
  String? destination;
  String? notes;
  String? nip;
  String? vehicle;
  String? item;

  Map<String, dynamic> toJson() => {
        "\"Origin\"": '"$origin"',
        "\"Destination\"": '"$destination"',
        "\"Notes\"": '"$notes"',
        "\"EmpNIP\"": '"$nip"',
        "\"Vehicles\"": vehicle.toString(),
        "\"Items\"": item.toString()
      };
}
