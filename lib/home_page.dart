import 'package:audioplayers/audioplayers.dart';
import 'package:care_alert_admin/vital_details_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final audioPlayer = AudioPlayer();
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref('/patients');
  String textResult = 'No data received';
  final TextEditingController patientCodeController = TextEditingController();

  List patientCodes = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CareALERT'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<DatabaseEvent>(
          stream: _databaseReference.onValue,
          builder: (context, snapshot) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(325, 50),
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      showBottomSheet(
                          context: context,
                          builder: (builder) {
                            return BottomSheet(
                                onClosing: () {},
                                builder: (builder) {
                                  return Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                      color: Colors.deepPurple,
                                    ),
                                    height: 200,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: TextField(
                                            controller: patientCodeController,
                                            decoration: const InputDecoration(
                                              hintStyle: TextStyle(
                                                  color: Colors.white),
                                              hintText: "Enter Patient Code",
                                              contentPadding:
                                                  EdgeInsets.all(20),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 50,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              200,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white,
                                          ),
                                          child: TextButton(
                                              onPressed: () {
                                                //Implement add patient
                                                patientCodeController
                                                        .text.isNotEmpty
                                                    ? patientCodes.contains(
                                                            patientCodeController
                                                                .text)
                                                        ? null
                                                        : patientCodes.add(
                                                            patientCodeController
                                                                .text)
                                                    : null;
                                                patientCodeController.clear();
                                                Navigator.pop(context);
                                                setState(() {});
                                              },
                                              child: const Text("Add Patient")),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          });
                    },
                    child: const Text("Add Patient"),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),
                  StreamBuilder(
                      stream: _databaseReference.onValue,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {

                          return Expanded(
                            child: ListView.builder(
                                itemCount: patientCodes.length,
                                itemBuilder: (context, index) {
                                  print(snapshot.data!.snapshot
                                      .child(patientCodes[index])
                                      .value
                                      .toString());
                                  if (snapshot.data!.snapshot
                                      .child(patientCodes[index])
                                      .value
                                      .toString()
                                      .contains("true")) {
                                    audioPlayer.play(
                                      AssetSource('alert.wav'),
                                    );
//implement sound alram
                                  }
                                  return ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              VitalDetailsPage(
                                            patientCode: patientCodes[index],
                                          ),
                                        ),
                                      );
                                    },
                                    tileColor: snapshot.data!.snapshot
                                            .child(patientCodes[index])
                                            .value
                                            .toString()
                                            .contains("true")
                                        ? Colors.red
                                        : Colors.white,
                                    leading: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          patientCodes.removeAt(index);
                                        });
                                      },
                                    ),
                                    title: Text(patientCodes[index]),
                                    trailing: TextButton(
                                      onPressed: () {
                                        audioPlayer.stop();
                                        _databaseReference
                                            .child('/${patientCodes[index]}')
                                            .update({'alert': false});
                                      },
                                      child: const Icon(Icons.refresh),
                                    ),
                                  );
                                }),
                          );
                        } else {
                          return const Text("No data");
                        }
                      })
                ],
              ),
            );
          }),
    );
  }
}
