import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tto/constant/color.dart';
import 'package:tto/constant/text.dart';
import 'package:tto/pages/picture_detail.dart';
import 'package:tto/widgets/button.dart';
import 'package:tto/widgets/input_field.dart';

class CarrierFormList extends StatefulWidget {
  CarrierFormList({Key? key, this.carrierModel, this.onRemove, this.index})
      : super(key: key);

  TextEditingController _name = TextEditingController();
  TextEditingController _license = TextEditingController();

  String name = "";
  String license = "";

  final index;
  Carrier? carrierModel;
  final Function? onRemove;

  Uint8List? driverImage = Uint8List(8);
  Uint8List? idCardImage = Uint8List(8);

  String? base64imageId = "";
  String? base64imageDriver = "";

  bool emptyIdPhoto = true;
  bool emptyDriverPhoto = true;

  @override
  State<CarrierFormList> createState() => _CarrierFormListState();
}

class _CarrierFormListState extends State<CarrierFormList> {
  //Camera Variable
  File? pickedImage;
  var imageFile;

  final picker = ImagePicker();
  File? _image;
  NetworkImage? imageUpload;
  Uint8List? webImage = Uint8List(8);

  XFile? _imageX;

  Future getImage(Uint8List resultImage, String base64) async {
    // print('getimage');
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
        resultImage = f;
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
    List<int> imageBytes = resultImage;
    base64 = base64Encode(imageBytes);
    // print("base64-> " + base64image.toString());
    // });
    // });
    return {'webImage': resultImage, 'base64': base64};
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.index > 0 ? "Vehicle ${widget.index + 1}" : "Vehicle",
                  style: helveticaText.copyWith(
                    fontSize: 20,
                    color: eerieBlack,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              widget.index == 0
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        widget.onRemove!(widget.carrierModel);
                      },
                      icon: const Icon(
                        Icons.delete_forever_outlined,
                        color: davysGray,
                      ),
                    ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          InputField(
            controller: widget._name,
            label: const Text('Driver Name'),
            prefixIcon: Icon(Icons.person_outline_sharp),
            onSaved: (value) {
              widget.name = value.toString();
              widget.carrierModel!.name = widget.name;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: !widget.emptyDriverPhoto
                ? () {
                    getImage(widget.driverImage!, widget.base64imageDriver!)
                        .then((value) {
                      setState(() {
                        widget.driverImage = value['webImage'];
                        widget.carrierModel!.photo = value['base64'];
                        widget.emptyDriverPhoto = false;
                      });
                    });
                  }
                : null,
            child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: widget.emptyDriverPhoto ? platinum : eerieBlack,
                  borderRadius: BorderRadius.circular(10),
                  image: !widget.emptyDriverPhoto
                      ? DecorationImage(
                          image: MemoryImage(widget.driverImage!),
                          fit: BoxFit.contain,
                        )
                      : null,
                ),
                child: widget.emptyDriverPhoto
                    ? Center(
                        child: RegularButton(
                          text: 'Take Driver Photo',
                          disabled: false,
                          onTap: () {
                            getImage(widget.driverImage!,
                                    widget.base64imageDriver!)
                                .then((value) {
                              setState(() {
                                widget.driverImage = value['webImage'];
                                widget.carrierModel!.photo = value['base64'];
                                widget.emptyDriverPhoto = false;
                              });
                            });
                          },
                          padding: ButtonSize().smallSize(),
                        ),
                      )
                    : SizedBox()),
          ),
          const SizedBox(
            height: 15,
          ),
          InputField(
            controller: widget._license,
            label: const Text(
              'License Number',
            ),
            prefixIcon: Icon(Icons.drive_eta_outlined),
            onSaved: (value) {
              widget.license = value.toString();
              widget.carrierModel!.vehicleNumber = widget.license;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: !widget.emptyIdPhoto
                ? () {
                    getImage(widget.idCardImage!, widget.base64imageId!)
                        .then((value) {
                      setState(() {
                        widget.idCardImage = value['webImage'];
                        widget.carrierModel!.idPhoto = value['base64'];
                        widget.emptyIdPhoto = false;
                      });
                    });
                  }
                : null,
            child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: widget.emptyIdPhoto ? platinum : eerieBlack,
                  borderRadius: BorderRadius.circular(10),
                  image: !widget.emptyIdPhoto
                      ? DecorationImage(
                          image: MemoryImage(widget.idCardImage!),
                          fit: BoxFit.contain,
                        )
                      : null,
                ),
                child: widget.emptyIdPhoto
                    ? Center(
                        child: RegularButton(
                          text: 'Take ID Card Photo',
                          disabled: false,
                          onTap: () {
                            getImage(widget.idCardImage!, widget.base64imageId!)
                                .then((value) {
                              setState(() {
                                widget.idCardImage = value['webImage'];
                                widget.carrierModel!.idPhoto = value['base64'];
                                widget.emptyIdPhoto = false;
                              });
                            });
                          },
                          padding: ButtonSize().smallSize(),
                        ),
                      )
                    : SizedBox()),
          ),
          const SizedBox(
            height: 15,
          ),
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: widget.emptyDriverPhoto
          //       ? InkWell(
          //           onTap: () {
          //             getImage(widget.driverImage!, widget.base64imageDriver!)
          //                 .then((value) {
          //               setState(() {
          //                 widget.driverImage = value['webImage'];
          //                 widget.carrierModel!.photo = value['base64'];
          //                 widget.emptyDriverPhoto = false;
          //               });
          //             });
          //           },
          //           child: Wrap(
          //             children: [
          //               Text(
          //                 'Driver Photo ',
          //                 style: helveticaText.copyWith(
          //                   fontSize: 16,
          //                   color: orangeAccent,
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
          //                 image: widget.driverImage,
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
          //             children: [
          //               Text(
          //                 'Driver Photo ',
          //                 style: helveticaText.copyWith(
          //                   fontSize: 16,
          //                   color: greenAcent,
          //                 ),
          //               ),
          //               const Icon(
          //                 Icons.photo,
          //                 color: greenAcent,
          //                 size: 16,
          //               ),
          //             ],
          //           ),
          //         ),
          // ),
          // const SizedBox(
          //   height: 15,
          // ),
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: widget.emptyIdPhoto
          //       ? InkWell(
          //           onTap: () {
          //             getImage(widget.idCardImage!, widget.base64imageId!)
          //                 .then((value) {
          //               setState(() {
          //                 widget.idCardImage = value['webImage'];
          //                 widget.carrierModel!.idPhoto = value['base64'];
          //                 widget.emptyIdPhoto = false;
          //               });
          //             });
          //           },
          //           child: Wrap(
          //             children: [
          //               Text(
          //                 'ID Card photo ',
          //                 style: helveticaText.copyWith(
          //                   fontSize: 16,
          //                   color: orangeAccent,
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
          //                 image: widget.idCardImage,
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
          //             children: [
          //               Text(
          //                 'ID Card photo ',
          //                 style: helveticaText.copyWith(
          //                   fontSize: 16,
          //                   color: greenAcent,
          //                 ),
          //               ),
          //               const Icon(
          //                 Icons.photo,
          //                 color: greenAcent,
          //                 size: 16,
          //               ),
          //             ],
          //           ),
          //         ),
          // ),
          // const SizedBox(
          //   width: 15,
          // ),
        ],
      ),
    );
  }
}

class Carrier {
  Carrier({
    this.index,
    this.name = "",
    this.photo = "",
    this.idPhoto = "",
    this.vehicleNumber = "",
  });

  int? index;
  String? name;
  String? photo;
  String? idPhoto;
  String? vehicleNumber;
}
