import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mehenty_app/config/config.dart';

class viewCarHistory extends StatefulWidget {
  String? userBooked;
  viewCarHistory({super.key, required this.userBooked});

  @override
  State<viewCarHistory> createState() => _viewCarHistory();
}

class _viewCarHistory extends State<viewCarHistory> {
  @override
  Widget build(BuildContext context) {
    String currentUser = technicianApp.auth!.currentUser!.uid;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "History Of Car Fixing",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Container(),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: technicianApp.firestore!
                          .collection("history")
                          .where("userID", isEqualTo: widget.userBooked)
                          .orderBy("dateOfFixing", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        return !snapshot.hasData
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  var document = snapshot.data!.docs[index];
                                  String comment = document['comment'];
                                  String dateOfFixing =
                                      document['dateOfFixing'];
                                  String technicianName =
                                      document['technisianName'];

                                  return Card(
                                    color: const Color.fromARGB(
                                        255, 206, 205, 205),
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    child: ListTile(
                                      title: Text(comment),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(widget.userBooked.toString()),
                                          Text('Date of Fixing: $dateOfFixing'),
                                          Text(
                                              'Technician Name: $technicianName'),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
