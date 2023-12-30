import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required this.data});
  final List<String> data;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final serviceId = 'service_hrrfr9w';
  final templateId = 'template_e9oqg4e';
  final userId = 'th_aHj3azOFdM27SM';

  String? nameEvent;
  bool doneOperation = false;
  bool emailSent = false;

  String? promoter;
  String? name;
  String? surname;
  String? email;
  String? phone;
  String? peopleNumber;
  String? event;
  String? payment;
  int? advancedPayment;
  int? totalPayment;
  String? emailMessage;
  String? dateEvent;
  String? comments;

  String? location;
  int? eventPrice;

  Future<String> getEventData() async {
    await FirebaseFirestore.instance
        .collection('events')
        .doc(nameEvent)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        location = data['location'];
        eventPrice = data['price'];
        totalPayment = eventPrice! * int.parse(peopleNumber!);
        if (payment == "Acconto") {
          emailMessage =
              "\nThis email confirm the booking to the event.\n\nPromoter: $promoter\nName: $name\nSurname: $surname\nEmail: $email\nPhone: $phone\nPeople number: $peopleNumber\nEvent: $event\nLocation: $location\nDate event: $dateEvent\nPayment method: $payment\nAdvanced payment: € $advancedPayment.00\nRemains to pay: € ${totalPayment! - advancedPayment!}.00\nComments: $comments\n\nEnjoy!";
        } else {
          emailMessage =
              "\nThis email confirm the booking to the event.\n\nPromoter: $promoter\nName: $name\nSurname: $surname\nEmail: $email\nPhone: $phone\nPeople number: $peopleNumber\nEvent: $event\nLocation: $location\nDate event: $dateEvent\nPayment method: $payment\nTotal payment: € $totalPayment.00\nComments: $comments\n\nEnjoy!";
        }
        return data['location'];
      }
    });
    return "";
  }

  Future countEvent(String countEventName, String countDate) async {
    String eventTimestamp = countEventName.trim();
    eventTimestamp += "_$countDate";
    int count = 0;
    await FirebaseFirestore.instance
        .collection("counter")
        .doc(eventTimestamp)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        count = data['number'];
      }
      count += 1;
      FirebaseFirestore.instance
          .collection("counter")
          .doc(eventTimestamp)
          .set({'number': count});
    });
  }

  void comeBack(String countEventName, String countDate) {
    if (emailSent) {
      emailSent = false;
      countEvent(countEventName, countDate);

      Navigator.of(context).pop(true);
    }
  }

  void sendEmail(String countEventName, String countDate) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'user_subject': 'Funway booking confirm',
            'receiver_name': name,
            'user_name': promoter,
            'receiver_email': email,
            'user_message': emailMessage,
          }
        }));
    if (response.statusCode == 200) {
      setState(() {
        emailSent = true;
      });
    }
    comeBack(countEventName, countDate);
    // else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text("Email non valida, riprovare")));
    // }
  }

  @override
  void initState() {
    List<String> data = widget.data;
    promoter = data.elementAt(0);
    name = data.elementAt(1);
    surname = data.elementAt(2);
    email = data.elementAt(3);
    phone = data.elementAt(4);
    peopleNumber = data.elementAt(5);
    event = data.elementAt(6);
    payment = data.elementAt(7);
    dateEvent = data.elementAt(8);
    comments = data.elementAt(9);
    if (payment == "Acconto") {
      advancedPayment = int.parse(data.elementAt(10));
    }

    nameEvent = event;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Result'),
          leading: BackButton(
            onPressed: () {
              widget.data.clear();
              Navigator.of(context).pop(false);
            },
          )),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.topLeft,
                margin:
                    const EdgeInsets.only(bottom: 10.0, left: 20.0, top: 20.0),
                child: Text(
                  'Promoter: $promoter',
                  style: const TextStyle(fontSize: 20.0),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin:
                    const EdgeInsets.only(bottom: 10.0, left: 20.0, top: 20.0),
                child: Text(
                  'Nome: $name',
                  style: const TextStyle(fontSize: 20.0),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin:
                    const EdgeInsets.only(bottom: 10.0, left: 20.0, top: 20.0),
                child: Text(
                  'Cognome: $surname',
                  style: const TextStyle(fontSize: 20.0),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin:
                    const EdgeInsets.only(bottom: 10.0, left: 20.0, top: 20.0),
                child: Text(
                  'Email: $email',
                  style: const TextStyle(fontSize: 20.0),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin:
                    const EdgeInsets.only(bottom: 10.0, left: 20.0, top: 20.0),
                child: Text(
                  'Telefono: $phone',
                  style: const TextStyle(fontSize: 20.0),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin:
                    const EdgeInsets.only(bottom: 10.0, left: 20.0, top: 20.0),
                child: Text(
                  'Numero persone: $peopleNumber',
                  style: const TextStyle(fontSize: 20.0),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin:
                    const EdgeInsets.only(bottom: 10.0, left: 20.0, top: 20.0),
                child: Text(
                  'Evento: $event',
                  style: const TextStyle(fontSize: 20.0),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin:
                    const EdgeInsets.only(bottom: 10.0, left: 20.0, top: 20.0),
                child: Text(
                  'Data evento: $dateEvent',
                  style: const TextStyle(fontSize: 20.0),
                ),
              ),
              FutureBuilder(
                  future: getEventData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(children: [
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(
                              bottom: 10.0, left: 20.0, top: 20.0),
                          child: Text(
                            'Pagamento: $payment',
                            style: const TextStyle(fontSize: 20.0),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(
                              bottom: 10.0, left: 20.0, top: 20.0),
                          child: const Text(
                            'Totale pagamento: € 00.00',
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ]);
                    }
                    return Column(children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.only(
                            bottom: 10.0, left: 20.0, top: 20.0),
                        child: Text(
                          'Location: $location',
                          style: const TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.only(
                            bottom: 10.0, left: 20.0, top: 20.0),
                        child: Text(
                          'Pagamento: $payment',
                          style: const TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Visibility(
                        visible: (payment == "Acconto"),
                        child: Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(
                              bottom: 10.0, left: 20.0, top: 20.0),
                          child: Text(
                            'Valore acconto: € $advancedPayment',
                            style: const TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.only(
                            bottom: 10.0, left: 20.0, top: 20.0),
                        child: Text(
                          (payment != "Acconto")
                              ? 'Totale pagamento: € $totalPayment.00'
                              : 'Restante da pagare: € ${totalPayment! - advancedPayment!}.00',
                          style: const TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Visibility(
                        visible: (comments != null),
                        child: Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(
                              bottom: 10.0, left: 20.0, top: 20.0),
                          child: Text(
                            'Commenti: $comments',
                            style: const TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ),
                    ]);
                  }),
              Container(
                margin: const EdgeInsets.only(top: 30.0, bottom: 30.0),
                child: ElevatedButton(
                  onPressed: () async {
                    doneOperation = await showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Avviso'),
                        content: const Text("L'email verrà inviata"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Annulla'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                    if (doneOperation) {
                      sendEmail(event!, dateEvent!);
                      // countEvent(event!, dateEvent!);
                    }
                  },
                  child: const Text(
                    'Invia email',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
