import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewEventPage extends StatefulWidget {
  const NewEventPage({super.key});

  @override
  State<NewEventPage> createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
  final _globalFormKey = GlobalKey<FormState>();

  final _eventNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _eventNameController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future addEvent(String name, String location, String price) async {
    await FirebaseFirestore.instance.collection("events").doc(name).set(
        {'name': name, 'location': location, 'price': double.parse(price)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset(
          "assets/images/logo.jpg",
          height: 30.0,
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _globalFormKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(
                      top: 30.0, left: 10.0, bottom: 10.0),
                  child: const Text("Nome evento",
                      style: TextStyle(fontSize: 20.0)),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return "Il nome dell'evento non può essere vuoto";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    controller: _eventNameController,
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(
                      top: 50.0, left: 10.0, bottom: 10.0),
                  child: const Text("Posizione dell'evento",
                      style: TextStyle(fontSize: 20.0)),
                ),
                Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.all(20.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _locationController,
                    )),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(
                          top: 50.0, left: 10.0, bottom: 10.0),
                      child: const Text("Prezzo dell'evento",
                          style: TextStyle(fontSize: 20.0)),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(
                          top: 50.0, left: 10.0, bottom: 10.0),
                      child: const Text("€", style: TextStyle(fontSize: 20.0)),
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        width: 100,
                        margin: const EdgeInsets.only(
                            top: 50.0, left: 10.0, bottom: 10.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _priceController,
                        )),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30.0, bottom: 30.0),
                  child: ElevatedButton(
                      onPressed: () {
                        if (_globalFormKey.currentState!.validate()) {
                          addEvent(
                              _eventNameController.text.trim(),
                              _locationController.text.trim(),
                              _priceController.text.trim());
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Nuovo evento aggiunto")));
                          Navigator.pop(context, true);
                        }
                      },
                      child: const Text(
                        "Aggiungi nuovo evento",
                        style: TextStyle(fontSize: 20.0),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
