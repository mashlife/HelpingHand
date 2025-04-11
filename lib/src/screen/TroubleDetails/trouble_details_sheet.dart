import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helping_hand/src/constants/globals.dart';
import 'package:helping_hand/src/controllers/firebase_controllers.dart';
import 'package:helping_hand/src/models/trouble_data_model.dart';
import 'package:helping_hand/src/utils/colors.dart';

class TroubleDetailsSheet extends StatefulWidget {
  const TroubleDetailsSheet(
      {super.key, required this.geoKey, required this.position});

  final String geoKey;
  final LatLng position;

  @override
  State<TroubleDetailsSheet> createState() => _TroubleDetailsSheetState();
}

class _TroubleDetailsSheetState extends State<TroubleDetailsSheet> {
  TroubleDataModel? troubleData;
  Position? pos;
  double? distance;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllDetails();
  }

  _getAllDetails() async {
    troubleData = FirebaseControllers.getTroubleFromList(widget.geoKey);
    pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    distance = Geolocator.distanceBetween(pos!.latitude, pos!.longitude,
        widget.position.latitude, widget.position.longitude);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (troubleData == null) {
      return const SizedBox(
        height: 120,
        width: 120,
        child: CircularProgressIndicator(
          strokeWidth: 5,
          color: Colors.greenAccent,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 35,
                child: Image.asset(
                  troubleData!.currentStatus == "confirmed"
                      ? 'media/image/trouble.png'
                      : 'media/image/not-confirmed.png',
                  height: 32,
                  width: 32,
                  fit: BoxFit.contain,
                ),
              ),
              const Gap(10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    troubleData!.userName!,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Gap(5),
                  if (distance != null)
                    Text.rich(
                      TextSpan(
                          style: TextStyle(
                            color: AppColors.secondaryText,
                          ),
                          children: [
                            const TextSpan(text: "Distance: "),
                            TextSpan(
                              text: _formatDistance(distance!),
                              style: const TextStyle(
                                color: AppColors.texty,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ]),
                    )
                ],
              ),
            ],
          ),
          const Gap(2),
          const Divider(
            thickness: 4,
            color: AppColors.placeHolder,
          ),
          const Gap(2),
          const Text(
            "Trouble Detected",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Gap(5),
          if (troubleData?.currentStatus == "uploaded")
            Text(
              isLoading
                  ? "Registering your vote"
                  : "Vote to confirm or decline",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          const Gap(20),
          isLoading
              ? const SizedBox(
                  height: 120,
                  width: 120,
                  child: CircularProgressIndicator(
                    strokeWidth: 5,
                    color: Colors.green,
                    padding: EdgeInsets.all(20),
                  ),
                )
              : troubleData?.currentStatus != "uploaded"
                  ? ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        padding:
                            const WidgetStatePropertyAll(EdgeInsets.all(10)),
                        backgroundColor: const WidgetStatePropertyAll<Color>(
                            AppColors.secondary),
                        shape: WidgetStatePropertyAll<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Trouble confirmed. Need immediate help!",
                            style: TextStyle(
                              color: AppColors.creamWhite,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Need immediate help!",
                            style: TextStyle(
                              color: AppColors.declineColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            isLoading = true;
                            setState(() {});
                            await _getAllDetails();
                            final latLng =
                                LatLng(pos!.latitude, pos!.longitude);
                            await FirebaseControllers.voteOnTrouble(latLng,
                                    AppGlobal.deviceUniqueId!, true, distance!)
                                .then((_) {
                              isLoading = false;
                              setState(() {});
                              Navigator.pop(context);
                            });
                          },
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              color:
                                  AppColors.confirmColor.withValues(alpha: 0.9),
                              border: Border.all(color: AppColors.creamWhite),
                              shape: BoxShape.circle,
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.done_rounded,
                                      size: 15,
                                      color: AppColors.creamWhite,
                                    ),
                                    Gap(6),
                                    Text(
                                      "confirm",
                                      style: TextStyle(
                                        color: AppColors.creamWhite,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ],
                                ),
                                Gap(10),
                                Text(
                                  "Votes needed: 5",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.creamWhite,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Gap(10),
                        InkWell(
                          onTap: () async {
                            isLoading = true;
                            setState(() {});
                            await _getAllDetails();
                            final latLng =
                                LatLng(pos!.latitude, pos!.longitude);
                            await FirebaseControllers.voteOnTrouble(latLng,
                                    AppGlobal.deviceUniqueId!, false, distance!)
                                .then((_) {
                              isLoading = false;
                              setState(() {});
                              Navigator.pop(context);
                            });
                          },
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              color:
                                  AppColors.creamWhite.withValues(alpha: 0.9),
                              border: Border.all(
                                  color: AppColors.declineColor, width: 3),
                              shape: BoxShape.circle,
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.wrong_location_outlined,
                                      size: 15,
                                    ),
                                    Gap(6),
                                    Text(
                                      "decline",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ],
                                ),
                                Gap(10),
                                Text(
                                  "Votes needed: 10",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
        ],
      ),
    );
  }

  String _formatDistance(double distanceInMeters) {
    if (distanceInMeters >= 1000) {
      return "${(distanceInMeters / 1000).toStringAsFixed(2)} km";
    } else {
      return "${distanceInMeters.toStringAsFixed(2)} meters";
    }
  }
}
