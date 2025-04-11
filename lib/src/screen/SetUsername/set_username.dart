import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:helping_hand/src/constants/globals.dart';
import 'package:helping_hand/src/controllers/firebase_controllers.dart';
import 'package:helping_hand/src/models/user_model.dart';
import 'package:helping_hand/src/screen/HomeScreen/home_screen.dart';
import 'package:helping_hand/src/services/navigation_service.dart';
import 'package:helping_hand/src/utils/colors.dart';
import 'package:helping_hand/src/utils/submit-button.dart';
import 'package:helping_hand/src/utils/text.dart';
import 'package:helping_hand/src/utils/textfield.dart';

class SetUsernameScreen extends StatefulWidget {
  const SetUsernameScreen({super.key});

  @override
  State<SetUsernameScreen> createState() => _SetUsernameScreenState();
}

class _SetUsernameScreenState extends State<SetUsernameScreen> {
  late final TextEditingController usernameController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usernameController = TextEditingController();
    _getUserData();
  }

  _getUserData() async {
    await FirebaseControllers.getUserData(AppGlobal.deviceUniqueId!)
        .then((user) {
      if (user != null) {
        AppGlobal.user = user;
        final text = usernameController.text.trim();
        setState(() {
          usernameController.text = user.name ?? text;
        });
      }
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
              text: "Enter your name to continue",
              fontSize: 21,
              fontWeight: FontWeight.w500,
              fontColor: AppColors.texty,
            ),
            const Gap(25),
            MyTextField(
              controller: usernameController,
              hintText: 'e.g. Mushfiq',
              suffixIcon: const Icon(
                Icons.person_rounded,
                size: 24,
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            const Gap(20),
            SubmitButton(onPress: () async {
              if (usernameController.text.isEmpty) return;
              if (usernameController.text == "") return;
              if (AppGlobal.user != null) {
                final previousName = AppGlobal.user?.name;

                if (previousName != usernameController.text.trim()) {
                  final user = AppGlobal.user!
                      .copyWith(name: usernameController.text.trim());

                  await FirebaseControllers.updateUserData(user).then((_) {
                    NavService.removeAllAndOpen(const HomeScreen());
                  });
                } else {
                  NavService.removeAllAndOpen(const HomeScreen());
                }
              } else {
                final user = UserModel(
                  deviceUniqueId: AppGlobal.deviceUniqueId,
                  name: usernameController.text.trim(),
                  currentStatus: UserStatus.safe,
                );
                await FirebaseControllers.createUser(user).then((_) {
                  NavService.removeAllAndOpen(const HomeScreen());
                });
              }
            })
          ],
        ),
      ),
    );
  }
}
