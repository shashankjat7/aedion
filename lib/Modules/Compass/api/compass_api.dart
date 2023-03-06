import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CompassApi {
  Future<GeoPoint?> getHeartLocation() async {
    Map heartData = {};
    CollectionReference heartLocationRef = FirebaseFirestore.instance.collection('Heart-Location');
    try {
      QuerySnapshot fetchedLocation = await heartLocationRef.where('heart_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid).limit(1).get();
      return fetchedLocation.docs[0].get('location');
    } catch (e) {
      log('Error while fetching heart location from database : $e');
      return null;
    }
  }

  Future<void> setCurrentLocation(GeoPoint location) async {
    DocumentReference myLocationDoc = FirebaseFirestore.instance.collection('Heart-Location').doc(FirebaseAuth.instance.currentUser!.uid);
    try {
      myLocationDoc.update({
        'location': location,
      });
    } catch (e) {
      log('Error while saving current location for compass : $e');
    }
  }
}
