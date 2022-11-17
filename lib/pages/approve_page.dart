import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tto/constant/color.dart';
import 'package:tto/constant/text.dart';
import 'package:tto/functions/api_request.dart';
import 'package:tto/pages/approve_nip_dialog.dart';
import 'package:tto/pages/picture_detail.dart';
import 'package:tto/widgets/button.dart';
import 'package:tto/widgets/layout_page.dart';
import 'package:http/http.dart' as http;
import 'package:tto/widgets/text_button.dart';

class ApprovalPage extends StatefulWidget {
  ApprovalPage({super.key, this.id = ""});

  String? id;

  @override
  State<ApprovalPage> createState() => _ApprovalPageState();
}

class _ApprovalPageState extends State<ApprovalPage> {
  dynamic result;

  String formId = "";
  String origin = "";
  String destination = "";
  String creator = "";
  String creatorName = "";
  String createdDate = "";
  String notes = "";
  String status = "";
  int? approvalstep;

  List itemList = [];
  List vehicleList = [];

  bool isApproved = false;
  bool isLoading = true;

  Uint8List? webImage = Uint8List(8);

  Future getDetail(String id) async {
    var url = Uri.https(
        apiUrlGlobal, 'ExitPassHOBackend/public/api/form/approve/detail/$id');

    Map<String, String> requestHeader = {"Content-Type": "application/json"};

    try {
      var response = await http.get(url, headers: requestHeader);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    result = '';
    getDetail(widget.id!).then((value) {
      // print(value['Data']);
      setState(() {
        isLoading = false;
        formId = value['Data']['FormID'];
        origin = value['Data']['ItemOrigin'];
        destination = value['Data']['ItemDestination'];
        creator = value['Data']['FormCreator'];
        creatorName = value['Data']['CreatorName'];
        createdDate = value['Data']['CreatedDate'];
        notes = value['Data']['Notes'];
        status = value['Data']['Status'];
        itemList = value['Data']['Items'];
        vehicleList = value['Data']['Carriers'];
        approvalstep = value['Data']['ApprovalStep'];

        if (approvalstep! >= 1) {
          isApproved = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutPage(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
            maxWidth: 600,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 50,
            ),
            child: SingleChildScrollView(
              child: isLoading
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: const Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          color: eerieBlack,
                        ),
                      ),
                    )
                  : status != "SENT"
                      ? Container(
                          height: MediaQuery.of(context).size.height,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(status == "APPROVED"
                                    ? 'assets/Email confirmed.svg'
                                    : 'assets/email failed.svg'),
                                const SizedBox(
                                  height: 15,
                                ),
                                RichText(
                                  text: TextSpan(
                                      text: 'Form already ',
                                      style: helveticaText.copyWith(
                                        fontSize: 24,
                                        color: eerieBlack,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: status,
                                          style: helveticaText.copyWith(
                                            fontSize: 24,
                                            color: eerieBlack,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              'Approval Page',
                              style: helveticaText.copyWith(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            detailInfo(
                              'Form ID :',
                              formId,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            detailInfo(
                              'Origin :',
                              origin,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            detailInfo(
                              'Destination :',
                              destination,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            detailInfo(
                              'Creator :',
                              '$creator - $creatorName',
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            // detailInfo(
                            //   'Name :',
                            //   creatorName,
                            // ),
                            // const SizedBox(
                            //   height: 15,
                            // ),
                            detailInfo(
                              'Created Date :',
                              createdDate,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            detailInfo(
                              'Status :',
                              status,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            vehicleSection(context),
                            const SizedBox(
                              height: 30,
                            ),
                            listItemSection(context),
                            const SizedBox(
                              height: 30,
                            ),
                            Visibility(
                              visible: !isApproved,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RegularButton(
                                    text: 'Approve',
                                    disabled: false,
                                    padding: ButtonSize().mediumSize(),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => ApprovalNIPDIalog(
                                          id: widget.id,
                                        ),
                                      ).then((value) {
                                        getDetail(widget.id!).then((value) {
                                          setState(() {
                                            status = value['Data']['Status'];
                                          });
                                        });
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  TransparentButtonBlack(
                                    text: 'Reject',
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => ApprovalNIPDIalog(
                                            id: widget.id, isRejected: true),
                                      ).then((value) {
                                        getDetail(widget.id!).then((value) {
                                          setState(() {
                                            status = value['Data']['Status'];
                                          });
                                        });
                                      });
                                    },
                                    padding: ButtonSize().mediumSize(),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
            ),
          ),
        ),
      ),
    );
  }

  detailInfo(String label, String content) {
    return Row(
      children: [
        SizedBox(
          width: 150,
          child: Text(
            label,
            style: helveticaText.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        Expanded(
          child: Text(
            content,
            style: helveticaText.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  listItemSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Item List',
          style: helveticaText.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        // Row(
        //   children: [
        //     Expanded(
        //       flex: 2,
        //       child: Align(
        //         alignment: Alignment.centerLeft,
        //         child: Text(
        //           'Item Name',
        //           style: helveticaText.copyWith(
        //             fontSize: 20,
        //             fontWeight: FontWeight.w700,
        //           ),
        //         ),
        //       ),
        //     ),
        //     Expanded(
        //       // flex: 1,
        //       child: Align(
        //         alignment: Alignment.center,
        //         child: Text(
        //           'Qty',
        //           style: helveticaText.copyWith(
        //             fontSize: 20,
        //             fontWeight: FontWeight.w700,
        //           ),
        //         ),
        //       ),
        //     ),
        //     Expanded(
        //       // flex: 1,
        //       child: Align(
        //         alignment: Alignment.center,
        //         child: Text(
        //           'Unit',
        //           style: helveticaText.copyWith(
        //             fontSize: 20,
        //             fontWeight: FontWeight.w700,
        //           ),
        //         ),
        //       ),
        //     ),
        //     Expanded(
        //       child: Align(
        //         alignment: Alignment.center,
        //         child: Text(
        //           'Picture',
        //           style: helveticaText.copyWith(
        //             fontSize: 20,
        //             fontWeight: FontWeight.w700,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // Divider(
        //   thickness: 2,
        // ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: itemList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: platinum,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: '${itemList[index]['ItemName']} - ',
                        style: helveticaText.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: eerieBlack,
                        ),
                        children: [
                          TextSpan(
                            text:
                                '${itemList[index]['Quantity']} ${itemList[index]['UnitName']}',
                            style: helveticaText.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              color: eerieBlack,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   // mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       itemList[index]['ItemName'],
                    //       style: helveticaText.copyWith(
                    //         fontSize: 20,
                    //         fontWeight: FontWeight.w300,
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       height: 10,
                    //     ),
                    //     Text(
                    //       '${itemList[index]['Quantity']} ${itemList[index]['UnitName']}',
                    //       style: helveticaText.copyWith(
                    //         fontSize: 18,
                    //         fontWeight: FontWeight.w700,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => PictureDetail(
                            image: webImage,
                            urlImage: itemList[index]['Photo'],
                          ),
                        );
                      },
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: eerieBlack,
                          image: DecorationImage(
                            image: NetworkImage(
                              itemList[index]['Photo'],
                            ),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    )
                    //       Expanded(
                    //         child: IconButton(
                    //           onPressed: () {
                    //             showDialog(
                    //               context: context,
                    //               builder: (context) => PictureDetail(
                    //                 image: webImage,
                    //                 urlImage: vehicleList[index]['FacePhoto'],
                    //               ),
                    //             );
                    //           },
                    //           icon: Icon(
                    //             Icons.zoom_in,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
            );
            // return Padding(
            //   padding: const EdgeInsets.symmetric(
            //     vertical: 10,
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Expanded(
            //         flex: 2,
            //         child: Align(
            //           alignment: Alignment.centerLeft,
            //           child: Text(
            //             itemList[index]['ItemName'],
            //             style: helveticaText.copyWith(
            //               fontSize: 20,
            //               fontWeight: FontWeight.w300,
            //             ),
            //           ),
            //         ),
            //       ),
            //       Expanded(
            //         child: Align(
            //           alignment: Alignment.center,
            //           child: Text(
            //             itemList[index]['Quantity'],
            //             style: helveticaText.copyWith(
            //               fontSize: 20,
            //               fontWeight: FontWeight.w300,
            //             ),
            //           ),
            //         ),
            //       ),
            //       Expanded(
            //         child: Align(
            //           alignment: Alignment.center,
            //           child: Text(
            //             itemList[index]['UnitName'],
            //             style: helveticaText.copyWith(
            //               fontSize: 20,
            //               fontWeight: FontWeight.w300,
            //             ),
            //           ),
            //         ),
            //       ),
            //       Expanded(
            //         child: Align(
            //           alignment: Alignment.center,
            //           child: IconButton(
            //             onPressed: () {
            //               showDialog(
            //                 context: context,
            //                 builder: (context) => PictureDetail(
            //                   image: webImage,
            //                   urlImage: itemList[index]['Photo'],
            //                 ),
            //               );
            //             },
            //             icon: Icon(
            //               Icons.zoom_in,
            //             ),
            //           ),
            //           // child: InkWell(
            //           //   onTap: () {
            //           //     showDialog(
            //           //       context: context,
            //           //       builder: (context) => PictureDetail(
            //           //         image: webImage,
            //           //         urlImage: itemList[index]['Photo'],
            //           //       ),
            //           //     );
            //           //   },
            //           //   child: Text(
            //           //     'Click',
            //           //     style: helveticaText.copyWith(
            //           //       fontSize: 20,
            //           //       fontWeight: FontWeight.w400,
            //           //       decoration: TextDecoration.underline,
            //           //     ),
            //           //   ),
            //           // ),
            //         ),
            //       ),
            //     ],
            //   ),
            // );
          },
        ),
      ],
    );
  }

  vehicleSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle List',
          style: helveticaText.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        // Row(
        //   children: [
        //     Expanded(
        //       flex: 2,
        //       child: Align(
        //         alignment: Alignment.centerLeft,
        //         child: Text(
        //           'Driver Name',
        //           style: helveticaText.copyWith(
        //             fontSize: 20,
        //             fontWeight: FontWeight.w700,
        //           ),
        //         ),
        //       ),
        //     ),
        //     Expanded(
        //       flex: 2,
        //       child: Align(
        //         alignment: Alignment.centerLeft,
        //         child: Text(
        //           'License',
        //           style: helveticaText.copyWith(
        //             fontSize: 20,
        //             fontWeight: FontWeight.w700,
        //           ),
        //         ),
        //       ),
        //     ),
        //     Expanded(
        //       // flex: 1,
        //       child: Align(
        //         alignment: Alignment.center,
        //         child: Text(
        //           'ID Card Photo',
        //           style: helveticaText.copyWith(
        //             fontSize: 20,
        //             fontWeight: FontWeight.w700,
        //           ),
        //         ),
        //       ),
        //     ),
        //     Expanded(
        //       child: Align(
        //         alignment: Alignment.center,
        //         child: Text(
        //           'Driver Photo',
        //           style: helveticaText.copyWith(
        //             fontSize: 20,
        //             fontWeight: FontWeight.w700,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // Divider(
        //   thickness: 2,
        // ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: vehicleList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: platinum,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: '${vehicleList[index]['Name']} - ',
                      style: helveticaText.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: eerieBlack,
                      ),
                      children: [
                        TextSpan(
                          text: vehicleList[index]['VehicleLicense'],
                          style: helveticaText.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: eerieBlack,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => PictureDetail(
                                image: webImage,
                                urlImage: vehicleList[index]['FacePhoto'],
                              ),
                            );
                          },
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: eerieBlack,
                              image: DecorationImage(
                                image: NetworkImage(
                                  vehicleList[index]['FacePhoto'],
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => PictureDetail(
                                image: webImage,
                                urlImage: vehicleList[index]['IdPhoto'],
                              ),
                            );
                          },
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: eerieBlack,
                              image: DecorationImage(
                                image: NetworkImage(
                                  vehicleList[index]['IdPhoto'],
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     showDialog(
                      //       context: context,
                      //       builder: (context) => PictureDetail(
                      //         image: webImage,
                      //         urlImage: vehicleList[index]['FacePhoto'],
                      //       ),
                      //     );
                      //   },
                      //   child: Wrap(
                      //     children: [
                      //       Text(
                      //         'Driver photo ',
                      //         style: helveticaText.copyWith(
                      //           fontSize: 18,
                      //           color: greenAcent,
                      //         ),
                      //       ),
                      //       Icon(
                      //         Icons.photo,
                      //         size: 16,
                      //       )
                      //     ],
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // InkWell(
                      //   onTap: () {
                      //     showDialog(
                      //       context: context,
                      //       builder: (context) => PictureDetail(
                      //         image: webImage,
                      //         urlImage: vehicleList[index]['IdPhoto'],
                      //       ),
                      //     );
                      //   },
                      //   child: Wrap(
                      //     children: [
                      //       Text(
                      //         'Id Card photo ',
                      //         style: helveticaText.copyWith(
                      //           fontSize: 18,
                      //           color: greenAcent,
                      //         ),
                      //       ),
                      //       Icon(
                      //         Icons.photo,
                      //         size: 16,
                      //       )
                      //     ],
                      //   ),
                      // ),
                    ],
                  )
                  //       Expanded(
                  //         child: IconButton(
                  //           onPressed: () {
                  //             showDialog(
                  //               context: context,
                  //               builder: (context) => PictureDetail(
                  //                 image: webImage,
                  //                 urlImage: vehicleList[index]['FacePhoto'],
                  //               ),
                  //             );
                  //           },
                  //           icon: Icon(
                  //             Icons.zoom_in,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            );
            // return Padding(
            //   padding: const EdgeInsets.symmetric(
            //     vertical: 10,
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Expanded(
            //         flex: 2,
            //         child: Align(
            //           alignment: Alignment.centerLeft,
            //           child: Text(
            //             vehicleList[index]['Name'],
            //             style: helveticaText.copyWith(
            //               fontSize: 20,
            //               fontWeight: FontWeight.w300,
            //             ),
            //           ),
            //         ),
            //       ),
            //       Expanded(
            //         flex: 2,
            //         child: Align(
            //           alignment: Alignment.centerLeft,
            //           child: Text(
            //             vehicleList[index]['VehicleLicense'],
            //             style: helveticaText.copyWith(
            //               fontSize: 20,
            //               fontWeight: FontWeight.w300,
            //             ),
            //           ),
            //         ),
            //       ),
            //       Expanded(
            //         child: Align(
            //           alignment: Alignment.center,
            //           child: IconButton(
            //             onPressed: () {
            //               showDialog(
            //                 context: context,
            //                 builder: (context) => PictureDetail(
            //                   image: webImage,
            //                   urlImage: vehicleList[index]['IdPhoto'],
            //                 ),
            //               );
            //             },
            //             icon: Icon(
            //               Icons.zoom_in,
            //             ),
            //           ),
            //           // child: InkWell(
            //           //   onTap: () {
            //           //     showDialog(
            //           //       context: context,
            //           //       builder: (context) => PictureDetail(
            //           //         image: webImage,
            //           //         urlImage: vehicleList[index]['IdPhoto'],
            //           //       ),
            //           //     );
            //           //   },
            //           //   child: Text(
            //           //     '',
            //           //     style: helveticaText.copyWith(
            //           //       fontSize: 20,
            //           //       fontWeight: FontWeight.w400,
            //           //       decoration: TextDecoration.underline,
            //           //     ),
            //           //   ),
            //           // ),
            //         ),
            //       ),
            //       Expanded(
            //         child: Align(
            //           alignment: Alignment.center,
            //           child: IconButton(
            //             onPressed: () {
            //               showDialog(
            //                 context: context,
            //                 builder: (context) => PictureDetail(
            //                   image: webImage,
            //                   urlImage: vehicleList[index]['FacePhoto'],
            //                 ),
            //               );
            //             },
            //             icon: Icon(
            //               Icons.zoom_in,
            //             ),
            //           ),
            //           // child: InkWell(
            //           //   onTap: () {
            //           //     showDialog(
            //           //       context: context,
            //           //       builder: (context) => PictureDetail(
            //           //         image: webImage,
            //           //         urlImage: vehicleList[index]['FacePhoto'],
            //           //       ),
            //           //     );
            //           //   },
            //           //   child: Text(
            //           //     'Click',
            //           //     style: helveticaText.copyWith(
            //           //       fontSize: 20,
            //           //       fontWeight: FontWeight.w400,
            //           //       decoration: TextDecoration.underline,
            //           //     ),
            //           //   ),
            //           // ),
            //         ),
            //       ),
            //     ],
            //   ),
            // );
          },
        ),
      ],
    );
  }
}
