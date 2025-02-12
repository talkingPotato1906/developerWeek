import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  List<String> trophies = [];
  List<String> profiles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserCollections();
  }

  Future<void> fetchUserCollections() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          trophies = List<String>.from(data['trophy'] ?? []);
          profiles = List<String>.from(data['profile'] ?? []);
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching collections: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Trophies",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        trophies.isNotEmpty
            ? GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: trophies.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child:
                            Text(trophies[index], textAlign: TextAlign.center)),
                  );
                },
              )
            : Center(child: Text("No trophies yet")),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Profiles",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        profiles.isNotEmpty
            ? GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: profiles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(profiles[index]),
                    ),
                  );
                },
              )
            : Center(child: Text("No profiles yet")),
      ],
    );
  }
}
