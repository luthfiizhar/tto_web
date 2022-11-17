import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signature/signature.dart';
import 'package:tto/constant/color.dart';
import 'package:tto/constant/text.dart';
import 'package:tto/functions/api_request.dart';
import 'package:tto/model/submit_form.dart';
import 'package:tto/widgets/button.dart';
import 'package:tto/widgets/carrier_list_form.dart';
import 'package:tto/widgets/input_field.dart';
import 'package:tto/widgets/item_list_form.dart';
import 'package:tto/widgets/layout_page.dart';
import 'package:http/http.dart' as http;
import 'package:tto/widgets/notif_dialog.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  // final SignatureController _controller = SignatureController(
  //   penStrokeWidth: 5,
  //   penColor: Colors.red,
  //   exportBackgroundColor: Colors.blue,
  // );
  bool isLoading = false;
  bool loadingSubmit = false;

  TextEditingController _nip = TextEditingController();
  TextEditingController _originAddress = TextEditingController();
  TextEditingController _destinationAddress = TextEditingController();
  TextEditingController _createdBy = TextEditingController();
  TextEditingController _notes = TextEditingController();

  FocusNode nipNode = FocusNode();
  FocusNode originAddressNode = FocusNode();
  FocusNode destinationAddressNode = FocusNode();
  FocusNode createdByNode = FocusNode();
  FocusNode notesNode = FocusNode();

  final formKey = GlobalKey<FormState>();

  String nip = "";
  String originAddress = "";
  String destinationAddress = "";
  List itemList = [];
  List transportList = [];
  String createdBy = "";
  String notes = "";

  Item? itemModel = Item(index: 0);
  Carrier? carrierModel = Carrier(index: 0);
  List<ItemListForm> formList = List.empty(growable: true);
  List<CarrierFormList> carrierFormList = List.empty(growable: true);
  ItemListForm? items;
  CarrierFormList? carrierItems;

  List? unitList = [
    {"UnitID": 0, "UnitName": "Choose Unit", "UnitShortName": ""}
  ];

  Future getUnitList() async {
    isLoading = true;
    setState(() {});
    var url = Uri.https(apiUrlGlobal, 'ExitPassHOBackend/public/api/unit/list');

    Map<String, String> requestHeader = {"Content-Type": "application/json"};

    try {
      var response = await http.get(url, headers: requestHeader);

      var data = json.decode(response.body);

      // print(data);
      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future submit() async {
    try {
      onSaveItem();
      onSaveDriver();

      SubmitForm formSubmit;
      formSubmit = SubmitForm(
        nip: nip,
        origin: originAddress,
        destination: destinationAddress,
        notes: notes,
        item: itemList.toString(),
        vehicle: transportList.toString(),
      );
      // print(formSubmit.toJson().);
      // formSubmit.toJson();
      submitForm(formSubmit).then((value) {
        setState(() {
          loadingSubmit = false;
        });
        // print(value['Status']);
        if (value['Status'] == "200") {
          showDialog(
            context: context,
            builder: (context) => AlertDialogBlack(
              title: value['Title'],
              contentText: value['Message'],
            ),
          ).then((value) {
            setState(() {
              formList.clear();
              carrierFormList.clear();
              itemList.clear();
              transportList.clear();
              formList.add(ItemListForm(
                index: 0,
                onRemove: onRemoveListItem,
                itemModel: itemModel,
                unitList: unitList,
              ));
              carrierFormList.add(CarrierFormList(
                index: 0,
                onRemove: onRemoveCarrier,
                carrierModel: carrierModel,
              ));
              _nip.text = "";
              _createdBy.text = "";
              _destinationAddress.text = "";
              _originAddress.text = "";
              _notes.text = "";
            });
          });
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialogBlack(
              title: value['Title'],
              contentText: value['Message'],
              color: orangeAccent,
            ),
          );
        }
        // print('DATA -> $value');
      }).onError((error, stackTrace) {
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: 'Can\'t connect to API',
            contentText: error.toString(),
            color: orangeAccent,
          ),
        );
      });
    } on Error catch (e) {
      return e;
    } on FormatException catch (e) {
      print('format exception');
      return e;
    }
  }

  Future submitForm(SubmitForm form) async {
    setState(() {
      loadingSubmit = true;
    });
    var url =
        Uri.https(apiUrlGlobal, 'ExitPassHOBackend/public/api/form/create');

    Map<String, String> requestHeader = {
      // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      "Content-Type": "application/json"
    };

    var bodySend = """
    {
      "Origin": "${form.origin}",
      "Destination": "${form.destination}",
      "Notes": "${form.notes}",
      "EmpNIP": "${form.nip}",
      "Vehicles": ${form.vehicle},
      "Items": ${form.item}
    }
 """;
    try {
      var response = await http.post(
        url,
        body: form.toJson().toString(),
        // body: bodySend,
        headers: requestHeader,
      );
      var data = json.decode(response.body);
      // var data = response.body.toString();
      return data;
    } on Error catch (e) {
      return e;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nipNode.removeListener(() {});
    originAddressNode.removeListener(() {});
    destinationAddressNode.removeListener(() {});
    createdByNode.removeListener(() {});
    notesNode.removeListener(() {});

    nipNode.dispose();
    originAddressNode.dispose();
    destinationAddressNode.dispose();
    createdByNode.dispose();
    notesNode.dispose();

    _nip.dispose();
    _originAddress.dispose();
    _destinationAddress.dispose();
    _createdBy.dispose();
    _notes.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUnitList().then((value) {
      // print(value);
      setState(() {
        isLoading = false;

        List result = value['Data'];
        result.forEach((element) {
          unitList!.add(element);
        });

        formList.add(ItemListForm(
          index: 0,
          onRemove: onRemoveListItem,
          itemModel: itemModel,
          unitList: unitList,
        ));
        carrierFormList.add(CarrierFormList(
          index: 0,
          onRemove: onRemoveCarrier,
          carrierModel: carrierModel,
        ));
      });
    });

    nipNode.addListener(() {
      setState(() {});
    });
    originAddressNode.addListener(() {
      setState(() {});
    });
    destinationAddressNode.addListener(() {
      setState(() {});
    });
    createdByNode.addListener(() {
      setState(() {});
    });
    notesNode.addListener(() {
      setState(() {});
    });
  }

  onRemoveListItem(Item data) {
    setState(() {
      itemModel = Item(index: 1);
      int index = formList.indexWhere((element) => element.index == data.index);

      if (formList != null) formList.removeAt(index);
    });
  }

  onRemoveCarrier(Carrier data) {
    setState(() {
      carrierModel = Carrier(index: 1);
      int index =
          carrierFormList.indexWhere((element) => element.index == data.index);

      if (carrierFormList != null) carrierFormList.removeAt(index);
    });
  }

  onSaveItem() {
    bool allValid = true;

    for (int i = 0; i < formList.length; i++) {
      items = formList[i];
      itemList.add({
        "\"Name\"": '"${items!.itemModel!.name}"',
        "\"Quantity\"": '"${items!.itemModel!.qty}"',
        "\"UnitID\"": '"${items!.itemModel!.satuan}"',
        "\"UnitName\"": '"${items!.itemModel!.unitName}"',
        "\"Photo\"": '"data:image/png;base64,${items!.itemModel!.photo}"'
      });
    }
  }

  onSaveDriver() {
    bool allValid = true;

    for (int i = 0; i < carrierFormList.length; i++) {
      carrierItems = carrierFormList[i];
      transportList.add({
        "\"Name\"": '"${carrierItems!.carrierModel!.name}"',
        "\"License\"": '"${carrierItems!.carrierModel!.vehicleNumber}"',
        "\"IdPhoto\"":
            '"data:image/png;base64,${carrierItems!.carrierModel!.idPhoto}"',
        "\"FacePhoto\"":
            '"data:image/png;base64,${carrierItems!.carrierModel!.photo}"',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutPage(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 600,
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 50,
            ),
            child: Container(
              // color: Colors.amber,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Exit Pass HO Form',
                      style: helveticaText.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Employee Info',
                      style: helveticaText.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 250,
                      child: InputField(
                        controller: _nip,
                        focusNode: nipNode,
                        keyboardType: TextInputType.number,
                        label: Text('NIP'),
                        prefixIcon: Icon(Icons.badge_outlined),
                        inputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) =>
                            value == "" ? "This field is required" : null,
                        onSaved: (value) {
                          nip = value!.toString();
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Adress Info',
                      style: helveticaText.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      // width: 250,
                      child: InputField(
                        controller: _originAddress,
                        focusNode: originAddressNode,
                        keyboardType: TextInputType.text,
                        label: Text('Origin'),
                        prefixIcon: Icon(Icons.location_on),
                        onSaved: (value) {
                          originAddress = value!.toString();
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      // width: 250,
                      child: InputField(
                        controller: _destinationAddress,
                        focusNode: destinationAddressNode,
                        keyboardType: TextInputType.text,
                        label: Text('Destination'),
                        prefixIcon: Icon(Icons.location_searching),
                        onSaved: (value) {
                          destinationAddress = value!.toString();
                        },
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     SizedBox(
                    //       width: 250,
                    //       child: InputField(
                    //         controller: _originAddress,
                    //         label: Text('Asal'),
                    //         prefixIcon: Icon(Icons.location_on),
                    //         onSaved: (value) {
                    //           originAddress = value!;
                    //         },
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       width: 15,
                    //     ),
                    //     SizedBox(
                    //       width: 250,
                    //       child: InputField(
                    //         controller: _destinationAddress,
                    //         label: Text('Tujuan'),
                    //         prefixIcon: Icon(Icons.location_searching),
                    //         onSaved: (value) {
                    //           destinationAddress = value!;
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(
                      height: 30,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    // Text(
                    //   'Driver Info',
                    //   style: helveticaText.copyWith(
                    //     fontSize: 22,
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    isLoading
                        ? CircularProgressIndicator()
                        : ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: carrierFormList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return carrierFormList[index];
                            },
                          ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: RegularButton(
                    //     padding: ButtonSize().smallSize(),
                    //     text: 'Add Vehicle',
                    //     disabled: false,
                    //     onTap: () {
                    //       setState(() {
                    //         carrierModel = Carrier(index: formList.length);
                    //         carrierFormList.add(
                    //           CarrierFormList(
                    //             index: formList.length,
                    //             carrierModel: carrierModel,
                    //             onRemove: onRemoveCarrier,
                    //           ),
                    //         );
                    //       });
                    //     },
                    //   ),
                    // ),
                    // Text(
                    //   'Item List',
                    //   style: helveticaText.copyWith(
                    //     fontSize: 22,
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    isLoading
                        ? CircularProgressIndicator()
                        : ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: formList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return formList[index];
                            },
                          ),
                    const SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: RegularButton(
                        padding: ButtonSize().smallSize(),
                        text: 'Add Item',
                        disabled: false,
                        onTap: () {
                          setState(() {
                            itemModel = Item(index: formList.length);
                            formList.add(
                              ItemListForm(
                                index: formList.length,
                                itemModel: itemModel,
                                onRemove: onRemoveListItem,
                                unitList: unitList,
                              ),
                            );
                          });
                        },
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Notes',
                      style: helveticaText.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InputField(
                      controller: _notes,
                      focusNode: notesNode,
                      onSaved: (value) {
                        notes = value!;
                      },
                      prefixIcon: Icon(Icons.note_add),
                      maxLines: 3,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: RegularButton(
                        padding: ButtonSize().longSize(),
                        text: 'Submit',
                        disabled: false,
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            submit().onError((error, stackTrace) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialogBlack(
                                  title: 'Can\'t connect to API',
                                  contentText: error.toString(),
                                  color: orangeAccent,
                                ),
                              );
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
