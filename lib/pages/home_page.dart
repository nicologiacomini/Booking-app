import 'dart:collection';
import 'package:book_app/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:book_app/pages/result_page.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  // lista che passa i valori alla schermata dei risultati per l'invio dell'email
  List<String> results = [];

  // List<String> promoterList = ['Promoter 1', 'Promoter 2', 'Promoter 3'];
  // List<String> eventList = ['Open Bar Mediterraneo', 'Evento 2', 'Evento 3'];
  List<String> paymentList = ['Full Cash', 'Full Card', 'Acconto'];
  List<String> peopleList = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30'
  ];

  //List<String> eventList = [];

  String selectedPromoter = "";
  String? selectedEvent;
  String? payment;
  String? peopleNumber;
  String? emailString;
  String? idEvent;
  String comments = "";
  int? eventPrice;

  final _globalFormKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _advancepayController = TextEditingController();
  final _dateController = TextEditingController();
  final _commentsController = TextEditingController();

  bool doneOperation = false;
  bool eventLoaded = false;
  bool promoterLoaded = false;
  bool eventPriceLoaded = false;
  // bool togglePayment = false;

  Future<String> getUserByEmail() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(emailString)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        selectedPromoter = data['name'];
        return data['name'];
      }
    });
    return "";
  }

  Future<String> getEventPrice() async {
    await FirebaseFirestore.instance
        .collection('events')
        .doc(selectedEvent)
        .get()
        .then(
      (DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          eventPrice = data['price'];
        }
      },
    );
    return "";
  }

  Future<List<String>> getEventList() async {
    final CollectionReference list =
        FirebaseFirestore.instance.collection('events');
    QuerySnapshot<Object?> querySnapshot = await list.get();

    List<String> eventList = [];
    for (var docSnapshot in querySnapshot.docs) {
      eventList
          .add((docSnapshot.data()! as LinkedHashMap<String, dynamic>)["name"]);
    }

    if (!eventPriceLoaded) {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(eventList.first)
          .get()
          .then(
        (DocumentSnapshot snapshot) {
          if (snapshot.exists) {
            Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
            eventPrice = data['price'];
          }
        },
      );
    }

    return eventList;
  }

  Future<String> getEventById() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(idEvent)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        selectedPromoter = data['name'];
        return data['name'];
      }
    });
    return "";
  }

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isEmpty || !regex.hasMatch(value)
        ? "Inserisci un'email valida"
        : null;
  }

  // void getSelectedPromoter() async {
  //   selectedPromoter = await getUserByEmail();
  // }

  void showConfirm() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Email inviata"),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _advancepayController.dispose();
    _dateController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // _promoter = getUsername();

    // cambiare selceted promoter con il nome utente preso dalla tabella

    //getEventList();
    // selectedEvent = eventList.first;
    // selectedEvent = eventList.first;
    eventLoaded = false;
    promoterLoaded = false;
    eventPriceLoaded = false;
    emailString = user.email!;
    payment = paymentList.first;
    peopleNumber = peopleList.first;
    _dateController.text = DateFormat("dd-MM-yyyy").format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // getSelectedPromoter();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: (emailString == "funawaymyk@gmail.com" ||
                    emailString == "ilnick32@gmail.com"),
                child: Row(
                  children: [
                    // pulsante per aggiungere un nuovo promoter
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          elevation: 0.0,
                          shadowColor: Colors.transparent),
                      // ElevatedButton.styleFrom(
                      //     backgroundColor: Colors.black,
                      //     elevation: 0.0,
                      //     shadowColor: Colors.transparent),
                      onPressed: () =>
                          Navigator.pushNamed(context, '/new_promoter'),
                      child: const Icon(
                        Icons.account_box,
                        color: Colors.white,
                      ),
                    ),
                    // pulsante per aggiungere un nuovo evento
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          elevation: 0.0,
                          shadowColor: Colors.transparent),
                      onPressed: () =>
                          Navigator.pushNamed(context, '/new_event'),
                      child: const Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              (emailString == "funawaymyk@gmail.com" ||
                      emailString == "ilnick32@gmail.com")
                  ? Container(child: null)
                  : Container(
                      margin: const EdgeInsets.only(left: 60.0),
                      child: Image.asset(
                        "assets/images/logo.jpg",
                        height: 30.0,
                      ),
                    ),
              Container(
                margin: const EdgeInsets.only(right: 5.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      elevation: 0.0,
                      shadowColor: Colors.transparent),
                  onPressed: () => Auth.signOut(),
                  child: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.all(20),
                child: Form(
                  key: _globalFormKey,
                  child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: [
                              Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(bottom: 10.0),
                                  child: const Text(
                                    'Promoter: ',
                                    style: TextStyle(fontSize: 20.0),
                                  )),
                              Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(bottom: 10.0),
                                  child: FutureBuilder<String>(
                                    future: getUserByEmail(),
                                    builder: ((context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                "Error: ${snapshot.error}"));
                                      }

                                      if (snapshot.connectionState ==
                                              ConnectionState.waiting &&
                                          !promoterLoaded) {
                                        return const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      promoterLoaded = true;
                                      return Text(
                                        selectedPromoter,
                                        style: const TextStyle(fontSize: 20.0),
                                      );
                                    }),
                                  )),
                            ],
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(bottom: 10.0),
                            child: const Text(
                              'Nome: ',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            margin:
                                const EdgeInsets.only(bottom: 30.0, left: 20.0),
                            child: TextFormField(
                                validator: (String? inputValue) {
                                  if (inputValue != null &&
                                      inputValue.isEmpty) {
                                    return "Questo campo è obbligatorio";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.name,
                                controller: _nameController),
                          ),
                          Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.only(bottom: 10.0),
                              child: const Text(
                                'Cognome: ',
                                style: TextStyle(fontSize: 20.0),
                              )),
                          Container(
                            alignment: Alignment.topLeft,
                            margin:
                                const EdgeInsets.only(bottom: 30.0, left: 20.0),
                            child: TextFormField(
                                validator: (String? inputValue) {
                                  if (inputValue != null &&
                                      inputValue.isEmpty) {
                                    return "Questo campo è obbligatorio";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.name,
                                controller: _surnameController),
                          ),
                          Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.only(bottom: 10.0),
                              child: const Text(
                                'Email: ',
                                style: TextStyle(fontSize: 20.0),
                              )),
                          Container(
                            alignment: Alignment.topLeft,
                            margin:
                                const EdgeInsets.only(bottom: 30.0, left: 20.0),
                            child: TextFormField(
                                validator: validateEmail,
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailController),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(bottom: 10.0),
                            child: const Text(
                              'Telefono: ',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            margin:
                                const EdgeInsets.only(bottom: 30.0, left: 20.0),
                            child: TextFormField(
                                validator: (String? inputValue) {
                                  if ((inputValue != null &&
                                          inputValue.isEmpty) ||
                                      inputValue!.length < 10) {
                                    return "Il numero di telefono non è valido";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.phone,
                                controller: _phoneController),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.only(bottom: 10.0),
                                child: const Text(
                                  'Numero persone: ',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.only(
                                    bottom: 10.0, left: 20.0),
                                child: SizedBox(
                                  width: 50,
                                  child: DropdownButton<String>(
                                    value: peopleNumber,
                                    items: peopleList
                                        .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                  fontSize: 20.0),
                                            )))
                                        .toList(),
                                    onChanged: (item) =>
                                        setState(() => peopleNumber = item),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.only(bottom: 10.0),
                                child: const Text(
                                  'Evento: ',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ),
                              FutureBuilder(
                                future: getEventList(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Container(
                                      alignment: Alignment.topLeft,
                                      margin: const EdgeInsets.only(
                                        bottom: 10.0,
                                        left: 20.0,
                                      ),
                                      child: SizedBox(
                                        width: 250,
                                        child: Text("Error: ${snapshot.error}"),
                                      ),
                                    );
                                  }

                                  if (snapshot.connectionState ==
                                          ConnectionState.waiting &&
                                      !eventLoaded) {
                                    return Container(
                                      alignment: Alignment.topLeft,
                                      margin: const EdgeInsets.only(
                                        bottom: 10.0,
                                        left: 20.0,
                                      ),
                                      child: const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }

                                  eventLoaded = true;
                                  selectedEvent ??= snapshot.data!.first;
                                  return Container(
                                    alignment: Alignment.topRight,
                                    margin: const EdgeInsets.only(
                                        bottom: 10.0, left: 20.0),
                                    child: SizedBox(
                                      width: 230,
                                      child: DropdownButton<String>(
                                        value: selectedEvent,
                                        items: (snapshot.data ?? [])
                                            .map((item) =>
                                                DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: const TextStyle(
                                                          fontSize: 20.0),
                                                    )))
                                            .toList(),
                                        onChanged: (item) => setState(
                                          () {
                                            selectedEvent =
                                                item ?? snapshot.data!.first;
                                            getEventPrice();
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.only(bottom: 10.0),
                                child: const Text(
                                  'Prezzo per persona:    ',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.only(bottom: 10.0),
                                child: FutureBuilder(
                                  future: getEventList(),
                                  builder: ((context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text("Error: ${snapshot.error}"));
                                    }
                                    if (snapshot.connectionState ==
                                            ConnectionState.waiting &&
                                        !eventPriceLoaded) {
                                      return const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    eventPriceLoaded = true;
                                    return Text(
                                      "€ ${eventPrice.toString()}",
                                      style: const TextStyle(fontSize: 20.0),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 20.0, bottom: 20.0),
                                alignment: Alignment.topLeft,
                                child: const Text(
                                  'Data evento: ',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ),
                              Container(
                                width: 250,
                                margin: const EdgeInsets.only(
                                    top: 20.0, bottom: 20.0),
                                alignment: Alignment.topLeft,
                                child: TextField(
                                  controller: _dateController,
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.calendar_today_rounded),
                                    labelText: "Seleziona data",
                                  ),
                                  onTap: () async {
                                    DateTime? pickDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2023),
                                      lastDate: DateTime(2024),
                                    );
                                    if (pickDate != null) {
                                      setState(() {
                                        _dateController.text =
                                            DateFormat("dd-MM-yyyy")
                                                .format(pickDate);
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.only(bottom: 10.0),
                                child: const Text(
                                  'Pagamento: ',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topRight,
                                margin: const EdgeInsets.only(
                                    bottom: 10.0, left: 20.0),
                                child: SizedBox(
                                  width: 110,
                                  child: DropdownButton<String>(
                                    value: payment,
                                    items: paymentList
                                        .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                  fontSize: 20.0),
                                            )))
                                        .toList(),
                                    onChanged: (item) =>
                                        setState(() => payment = item),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: (payment == "Acconto"),
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(bottom: 10.0),
                                  child: const Text(
                                    'Valore acconto: €',
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                ),
                                Container(
                                  width: 150,
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(
                                      bottom: 30.0, left: 20.0),
                                  child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: _advancepayController),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(bottom: 10.0),
                            child: const Text(
                              'Commenti: ',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            margin:
                                const EdgeInsets.only(bottom: 30.0, left: 20.0),
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              controller: _commentsController,
                              maxLines: null,
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(
                                  top: 30.0, bottom: 30.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black),
                                onPressed: () async {
                                  if (_globalFormKey.currentState!.validate()) {
                                    results.add(selectedPromoter);
                                    results.add(_nameController.text.trim());
                                    results.add(_surnameController.text.trim());
                                    results.add(_emailController.text.trim());
                                    results.add(_phoneController.text.trim());
                                    results.add(peopleNumber!);
                                    results.add(selectedEvent!);
                                    results.add(payment!);
                                    results.add(_dateController.text);
                                    results
                                        .add(_commentsController.text.trim());
                                    if (payment == "Acconto") {
                                      results.add(
                                          _advancepayController.text.trim());
                                    }
                                    doneOperation = await Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          ResultPage(data: results),
                                    ));
                                  }
                                  if (doneOperation) {
                                    setState(() {
                                      payment = paymentList.first;
                                      peopleNumber = peopleList.first;
                                      _nameController.text = "";
                                      _surnameController.text = "";
                                      _phoneController.text = "";
                                      _emailController.text = "";
                                      _advancepayController.text = "";
                                      _commentsController.text = "";
                                      _dateController.text =
                                          DateFormat("dd-MM-yyyy")
                                              .format(DateTime.now());
                                      results.clear();
                                      doneOperation = false;
                                    });
                                    showConfirm();
                                  }
                                },
                                child: const Text(
                                  'Conferma',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              )),
                        ]),
                  ),
                ))));
  }
}
