import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tto/constant/color.dart';
import 'package:tto/constant/text.dart';
import 'package:tto/functions/api_request.dart';
import 'package:tto/widgets/button.dart';
import 'package:tto/widgets/input_field.dart';
import 'package:http/http.dart' as http;
import 'package:tto/widgets/notif_dialog.dart';

class ApprovalNIPDIalog extends StatefulWidget {
  ApprovalNIPDIalog({
    super.key,
    this.id,
    this.isRejected = false,
  });

  String? id;
  bool? isRejected;

  @override
  State<ApprovalNIPDIalog> createState() => _ApprovalNIPDIalogState();
}

class _ApprovalNIPDIalogState extends State<ApprovalNIPDIalog> {
  TextEditingController _nip = TextEditingController();
  TextEditingController _notes = TextEditingController();
  String nip = "";
  String notes = "";

  bool isLoading = false;

  final formKey = GlobalKey<FormState>();

  Future approveForm() async {
    var url =
        Uri.https(apiUrlGlobal, 'ExitPassHOBackend/public/api/form/approve');

    Map<String, String> requestHeader = {"Content-Type": "application/json"};

    var bodySend = """
    {
        "FormID" : "${widget.id}",
        "EmpNIP" : "$nip",
        "Notes" : "$notes"
    }
    """;

    try {
      // print(bodySend);
      var response =
          await http.post(url, body: bodySend, headers: requestHeader);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future rejectForm() async {
    var url =
        Uri.https(apiUrlGlobal, 'ExitPassHOBackend/public/api/form/reject');

    Map<String, String> requestHeader = {"Content-Type": "application/json"};

    var bodySend = """
    {
        "FormID" : "${widget.id}",
        "EmpNIP" : "$nip",
        "Notes" : "$notes"
    }
    """;

    try {
      // print(bodySend);
      var response =
          await http.post(url, body: bodySend, headers: requestHeader);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  @override
  Widget build(BuildContext context) {
    String status = widget.isRejected! ? 'reject' : 'approve';
    return Dialog(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: 500, minHeight: 375, maxHeight: 400),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 30,
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Insert NIP',
                  style: helveticaText.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Please insert your NIP to $status this form.',
                  style: helveticaText.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                InputField(
                  controller: _nip,
                  label: Text('NIP'),
                  prefixIcon: Icon(Icons.badge),
                  validator: (value) => value == "" ? "NIP is required" : null,
                  onSaved: (value) {
                    nip = value!;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                InputField(
                  controller: _notes,
                  label: Text('Notes'),
                  prefixIcon: Icon(Icons.note_alt_outlined),
                  maxLines: 3,
                  onSaved: (value) {
                    notes = value!;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                RegularButton(
                  text: 'Submit',
                  disabled: false,
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      setState(() {
                        isLoading = true;
                      });
                      if (!widget.isRejected!) {
                        approveForm().then((value) {
                          // print(value);
                          setState(() {
                            isLoading = false;
                          });
                          if (value['Status'] == "200") {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialogBlack(
                                  title: 'Success',
                                  contentText: value["Message"]),
                            ).then((value) {
                              Navigator.of(context).pop(true);
                            });
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialogBlack(
                                title: 'Failed',
                                contentText: value['Message'],
                                color: orangeAccent,
                              ),
                            ).then((value) {
                              Navigator.of(context).pop(false);
                            });
                          }
                        });
                      } else {
                        rejectForm().then((value) {
                          print(value);
                          setState(() {
                            isLoading = false;
                          });
                          if (value['Status'] == "200") {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialogBlack(
                                  title: 'Success',
                                  contentText: value["Message"]),
                            ).then((value) {
                              Navigator.of(context).pop(true);
                            });
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialogBlack(
                                title: 'Failed',
                                contentText: value['Message'],
                                color: orangeAccent,
                              ),
                            ).then((value) {
                              Navigator.of(context).pop(false);
                            });
                          }
                        });
                      }
                    }
                  },
                  padding: ButtonSize().smallSize(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
