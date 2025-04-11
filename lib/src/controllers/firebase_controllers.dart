import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helping_hand/src/constants/globals.dart';
import 'package:helping_hand/src/controllers/pref_controller.dart';
import 'package:helping_hand/src/models/trouble_data_model.dart';
import 'package:helping_hand/src/models/trouble_geofire_model.dart';
import 'package:helping_hand/src/models/user_model.dart';
import 'package:helping_hand/src/models/vote_model.dart';

class FirebaseControllers {
  static List<TroubleDataModel> allTroubles = [];

  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static Future<void> sendTroubleData(TroubleDataModel troubleData) async {
    final trouble = troubleData.toMap();
    await db.collection("troubles").add(trouble).then((DocumentReference doc) {
      print('DocumentSnapshot added with ID: ${doc.id}');
      AppGlobal.inTrouble = troubleData.copyWith(id: doc.id);
    });
  }

  static Future<void> createUser(UserModel userData) async {
    final user = userData.toMap();

    final availableUser = await db
        .collection("users")
        .where("deviceUniqueId", isEqualTo: userData.deviceUniqueId)
        .get();

    if (availableUser.docs.isNotEmpty) {
      Fluttertoast.showToast(msg: "You are already logged in");
    }

    await db.collection("users").add(user).then((doc) {
      print('DocumentSnapshot added with ID: ${doc.id}');
      final user = userData.copyWith(id: doc.id);
      PrefController.saveUser(user);
      AppGlobal.user = user;
    });
  }

  static Future<UserModel?> getUserData(String deviceUniqueId) async {
    final availableUser = await db
        .collection("users")
        .where("deviceUniqueId", isEqualTo: deviceUniqueId)
        .get();

    if (availableUser.docs.isEmpty) {
      print("FirebaseController, getUser, No user record found");
      return null;
    } else {
      final userDoc = availableUser.docs.first;
      final user = UserModel.fromMap(userDoc.data());
      return user;
    }
  }

  static Future<void> updateUserData(UserModel userData) async {
    final user = userData.toMap();

    await db
        .collection("users")
        .doc(userData.id)
        .update(user)
        .onError((e, stackTrace) {
      print("Error updating trouble in Firestore: $e");
    });
  }

  static Future<void> voteOnTrouble(LatLng voterPosition, String deviceUniqueId,
      bool isPositive, double distance) async {
    final votedTrouble = await getTroubleDataFromFirestore(deviceUniqueId);
    final troubleIndex =
        allTroubles.indexWhere((e) => e.deviceUniqueId == deviceUniqueId);

    if (votedTrouble != null) {
      final voteSnapShot = await db
          .collection("votes")
          .where("deviceUniqueId", isEqualTo: AppGlobal.deviceUniqueId)
          .where("troubleId", isEqualTo: votedTrouble.id)
          .get();

      if (voteSnapShot.docs.isNotEmpty) {
        Fluttertoast.showToast(msg: "You have already voted");
        return;
      }

      final voteModel = VoteModel(
        deviceUniqueId: AppGlobal.deviceUniqueId,
        troubleId: votedTrouble.id,
        troubleLat: votedTrouble.geofireData!.locationLat,
        troubleLong: votedTrouble.geofireData!.locationLong,
        voterLat: voterPosition.latitude,
        voterLong: voterPosition.longitude,
        voterDistanceTrouble: distance,
        createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
        status: isPositive ? VoteStatus.positive : VoteStatus.negative,
      );

      await db.collection("votes").add(voteModel.toMap()).then((doc) {
        print("Vote added with ID: ${doc.id}");
      });

      TroubleDataModel modifiedData;
      if (isPositive) {
        if (votedTrouble.positiveVotes == 4) {
          modifiedData = votedTrouble.copyWith(
            positiveVotes: (votedTrouble.positiveVotes ?? 0) + 1,
            currentStatus: "confirmed",
          );
        } else {
          modifiedData = votedTrouble.copyWith(
            positiveVotes: (votedTrouble.positiveVotes ?? 0) + 1,
          );
        }
      } else {
        if (votedTrouble.negativeVotes == 9) {
          modifiedData = votedTrouble.copyWith(
            negativeVotes: (votedTrouble.negativeVotes ?? 0) + 1,
            currentStatus: "declined",
            isResolved: true,
          );
        } else {
          modifiedData = votedTrouble.copyWith(
            negativeVotes: (votedTrouble.negativeVotes ?? 0) + 1,
          );
        }
      }

      await db
          .collection("troubles")
          .doc(modifiedData.id)
          .update(modifiedData.toMap())
          .onError((e, stackTrace) {
        print("Error updating trouble in Firestore: $e");
      });

      if (troubleIndex == -1) {
        allTroubles.add(modifiedData);
      } else {
        allTroubles[troubleIndex] = modifiedData;
      }
    } else {
      print("No trouble data found for device ID: $deviceUniqueId");
    }
  }

  static Future<TroubleDataModel?> getTroubleDataFromFirestore(
      String deviceId) async {
    int indexNumber =
        allTroubles.indexWhere((element) => element.deviceUniqueId == deviceId);

    try {
      final querySnapshot = await db
          .collection("troubles")
          .where("deviceUniqueId", isEqualTo: deviceId)
          .where("currentStatus", isNotEqualTo: "resolved")
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No trouble data found for device ID: $deviceId");
        return null;
      }

      final doc = querySnapshot.docs.first;
      final trouble = TroubleDataModel.fromMap(doc.data());
      final updatedTrouble = trouble.copyWith(id: doc.id);

      if (indexNumber != -1) {
        allTroubles[indexNumber] = updatedTrouble;
      } else {
        allTroubles.add(updatedTrouble);
      }

      print("Trouble inside firestore data: ${updatedTrouble.toString()}");
      return updatedTrouble;
    } catch (e) {
      print("Error getting data from firestore: $e");
      return null;
    }
  }

  static TroubleDataModel? getTroubleFromList(String deviceId) {
    int indexNumber =
        allTroubles.indexWhere((element) => element.deviceUniqueId == deviceId);
    if (indexNumber != -1) {
      return allTroubles[indexNumber];
    } else {
      print("Data not found about trouble");
    }
    return null;
  }

  static void updateTroubleData(TroubleGeofireData updatedData) {
    int troubleDataIndex = allTroubles
        .indexWhere((e) => e.deviceUniqueId == updatedData.deviceUniqueId);

    if (troubleDataIndex != -1) {
      allTroubles[troubleDataIndex].geofireData = updatedData;
    } else {
      getTroubleDataFromFirestore(updatedData.deviceUniqueId!);
    }
  }

  static void deleteTroubleData(String deviceId) {
    int indexNumber =
        allTroubles.indexWhere((element) => element.deviceUniqueId == deviceId);
    allTroubles.removeAt(indexNumber);
  }
}
