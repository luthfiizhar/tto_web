import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tto/constant/color.dart';
import 'package:tto/constant/text.dart';
import 'package:tto/functions/api_request.dart';
import 'package:tto/pages/picture_detail.dart';
import 'package:tto/widgets/button.dart';
import 'package:tto/widgets/input_field.dart';
import 'package:http/http.dart' as http;

class ItemListForm extends StatefulWidget {
  ItemListForm({
    Key? key,
    this.itemModel,
    this.onRemove,
    this.index,
    this.unitList,
  }) : super(key: key);
  final index;
  Item? itemModel;
  final Function? onRemove;

  TextEditingController _itemName = TextEditingController();
  TextEditingController _itemCount = TextEditingController();
  TextEditingController _unitName = TextEditingController();

  String itemName = "";
  String itemCount = "";
  String unitName = "";

  List? unitList;
  var selectedUnit = 0;

  String? base64image = "";

  Uint8List? webImage = Uint8List(8);

  bool emptyPhoto = true;

  @override
  State<ItemListForm> createState() => _ItemListFormState();
}

class _ItemListFormState extends State<ItemListForm> {
  //Camera Variable
  File? pickedImage;
  var imageFile;

  final picker = ImagePicker();
  File? _image;
  NetworkImage? imageUpload;

  XFile? _imageX;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // widget._itemCount.text = '1';
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   _itemCount.dispose();
  //   _itemName.dispose();
  // }

  Future getImage() async {
    imageCache.clear();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    imageFile = await pickedFile!.readAsBytes();
    imageFile = await decodeImageFromList(imageFile);
    // Image? fromPicker = await ImagePickerWeb.getImageAsWidget();

    // setState(() {
    if (kIsWeb) {
      // Check if this is a browser session
      // imageUpload = NetworkImage(pickedFile.path);
      // _image = File(pickedFile.path);
      var f = await pickedFile.readAsBytes();
      setState(() {
        widget.webImage = f;
        _image = File('a');
      });
    } else {
      _image = File(pickedFile.path);
    }
    // pr.show();
    // isLoading = true;
    // compressImage(_image).then((value) {
    // pr.hide();
    // _image = value;
    // imageUpload = NetworkImage(_image!.path);
    // List<int> imageBytes = _image!.readAsBytesSync();
    List<int> imageBytes = widget.webImage!;
    widget.base64image = base64Encode(imageBytes);
    // print("base64-> " + base64image.toString());
    // });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.index > 0
                      ? 'Item ' + (widget.index + 1).toString()
                      : 'Item',
                  style: helveticaText.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                    color: eerieBlack,
                  ),
                ),
              ),
              widget.index == 0
                  ? SizedBox()
                  : IconButton(
                      onPressed: () {
                        widget.onRemove!(widget.itemModel);
                      },
                      icon: Icon(
                        Icons.close_sharp,
                        color: davysGray,
                      ),
                    ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          InputField(
            controller: widget._itemName,
            keyboardType: TextInputType.text,
            label: Text('Item Name'),
            prefixIcon: Icon(Icons.archive_outlined),
            onSaved: (value) {
              widget.itemModel!.name = value.toString();
            },
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              SizedBox(
                width: 125,
                child: InputField(
                  maxLines: 1,
                  controller: widget._itemCount,
                  keyboardType: TextInputType.number,
                  label: Text('Qty'),
                  prefixIcon: Icon(Icons.format_list_numbered),
                  inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                  onSaved: (value) {
                    if (value == "") {
                      widget.itemCount = '0';
                      widget.itemModel!.qty = int.parse(widget.itemCount);
                    } else {
                      widget.itemCount = value.toString();
                      widget.itemModel!.qty = int.parse(widget.itemCount);
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: DropdownButtonFormField2(
                    icon: Icon(Icons.keyboard_arrow_down_sharp),
                    style: helveticaText.copyWith(
                      fontSize: 16,
                      color: davysGray,
                    ),
                    items: widget.unitList!.map((e) {
                      return DropdownMenuItem(
                        enabled: e['UnitID'] != 0 ? true : false,
                        value: e['UnitID'],
                        child: Text(e['UnitName']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      widget.selectedUnit = int.parse(value.toString());
                      widget.itemModel!.satuan = value.toString();
                      // print(widget.unitList!
                      //     .where((element) =>
                      //         element['UnitID'] ==
                      //         int.parse(value.toString()))
                      //     .toList());
                      setState(() {
                        widget.unitList!
                            .where((element) =>
                                element['UnitID'] ==
                                int.parse(value.toString()))
                            .toList()
                            .forEach((e) {
                          if (e['UnitName'] == "Other") {
                            widget._unitName.text = "";
                          } else if (e['UnitName'] == "Choose Unit") {
                            widget._unitName.text = "";
                          } else {
                            widget._unitName.text = e['UnitName'];
                          }
                        });
                      });
                    },
                    onSaved: (value) {
                      widget.selectedUnit = int.parse(value.toString());
                      widget.itemModel!.satuan = widget.selectedUnit.toString();
                    },
                    value: widget.selectedUnit,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: davysGray,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: davysGray,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: davysGray,
                          width: 2,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: grayx11,
                          width: 1,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: orangeAccent,
                          width: 1,
                        ),
                      ),
                      errorStyle: const TextStyle(
                        color: orangeAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                      fillColor: culturedWhite,
                      filled: true,
                      isDense: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 125,
                child: InputField(
                  controller: widget._unitName,
                  keyboardType: TextInputType.text,
                  enabled: widget.selectedUnit != 3 ? false : true,
                  label: const Text('Unit'),
                  onSaved: (value) {
                    widget.unitName = value.toString();
                    widget.itemModel!.unitName = widget.unitName;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: !widget.emptyPhoto
                ? () {
                    getImage().then((value) {
                      setState(() {
                        widget.emptyPhoto = false;
                        widget.itemModel!.photo = widget.base64image;
                      });
                    });
                  }
                : null,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: widget.emptyPhoto ? platinum : eerieBlack,
                  borderRadius: BorderRadius.circular(10),
                  image: !widget.emptyPhoto
                      ? DecorationImage(
                          image: MemoryImage(widget.webImage!),
                          fit: BoxFit.contain,
                        )
                      : null),
              child: widget.emptyPhoto
                  ? Center(
                      child: RegularButton(
                        text: 'Take Item Photo',
                        disabled: false,
                        onTap: () {
                          getImage().then((value) {
                            setState(() {
                              widget.emptyPhoto = false;
                              widget.itemModel!.photo = widget.base64image;
                            });
                          });
                        },
                        padding: ButtonSize().smallSize(),
                      ),
                    )
                  : SizedBox(),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: widget.emptyPhoto
          //       ? InkWell(
          //           onTap: () {
          //             getImage().then((value) {
          //               setState(() {
          //                 widget.emptyPhoto = false;
          //                 widget.itemModel!.photo = widget.base64image;
          //               });
          //             });
          //           },
          //           child: Wrap(
          //             children: [
          //               Text(
          //                 'Item photo ',
          //                 style: helveticaText.copyWith(
          //                   color: orangeAccent,
          //                   fontSize: 16,
          //                 ),
          //               ),
          //               const Icon(
          //                 Icons.photo,
          //                 color: orangeAccent,
          //                 size: 16,
          //               ),
          //             ],
          //           ),
          //         )
          //       : InkWell(
          //           onTap: () {
          //             showDialog(
          //               context: context,
          //               builder: (context) => PictureDetail(
          //                 image: widget.webImage,
          //                 urlImage: "",
          //               ),
          //             );
          //             // Navigator.push(
          //             //   context,
          //             //   MaterialPageRoute(
          //             //     builder: (context) => PictureDetail(
          //             //       image: webImage,
          //             //     ),
          //             //   ),
          //             // );
          //           },
          //           child: Wrap(
          //             alignment: WrapAlignment.center,
          //             children: [
          //               Text(
          //                 'Item photo ',
          //                 style: helveticaText.copyWith(
          //                   color: greenAcent,
          //                   fontSize: 16,
          //                 ),
          //               ),
          //               Icon(
          //                 Icons.photo,
          //                 color: greenAcent,
          //                 size: 16,
          //               ),
          //             ],
          //           ),
          //         ),
          // ),
        ],
      ),
    );
  }
}

class Item {
  Item({
    this.index,
    this.name = "",
    this.qty = 1,
    this.satuan = "1",
    this.photo = "",
    this.unitName = "",
  });
  int? index;
  String? name;
  int? qty;
  String? satuan;
  String? photo;
  String? unitName;

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Quantity": qty,
        "UnitID": satuan,
        "Photo": photo,
        "UnitName": unitName
      };

  // @override
  // String toString() {
  //   // TODO: implement toString
  //   return "{index: $index, name: $name, qty: $qty, satuan:$satuan, photo, $photo}";
  // }
}
