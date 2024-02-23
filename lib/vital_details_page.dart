import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class VitalDetailsPage extends StatefulWidget {
  final String patientCode;
  const VitalDetailsPage({super.key, required this.patientCode});

  @override
  State<VitalDetailsPage> createState() => _VitalDetailsPageState();
}

class _VitalDetailsPageState extends State<VitalDetailsPage> {
  final DatabaseReference _databaseReference =   FirebaseDatabase.instance.ref('/patients');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vital Details'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            Text("Patient Code: ${widget.patientCode}",style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
            ),
            SizedBox(height: 20,),
            StreamBuilder(stream: _databaseReference.onValue, builder: (context,snapshot){
              if(snapshot.hasData && snapshot.data != null){
               return Table(
                 children: [
                   TableRow(
                     children: [
                       TableCell(child: Text("Heartbeat")),
                       TableCell(child: Text(snapshot.data!.snapshot.value.toString()),)

                     ]
                   ),TableRow(
                       children: [
                         TableCell(child: Text("Temperature")),
                         TableCell(child: Text("98"),)
                       ]
                   ),TableRow(
                       children: [
                         TableCell(child: Text("Respiration")),
                         TableCell(child: Text("98"),)
                       ]
                   ),TableRow(
                       children: [
                         TableCell(child: Text("SpO2")),
                         TableCell(child: Text("98"),)
                       ]
                   ),
                 ],
               );
              }
              return const CircularProgressIndicator();

            })

          ],
        ),
      )
    );
  }
}
