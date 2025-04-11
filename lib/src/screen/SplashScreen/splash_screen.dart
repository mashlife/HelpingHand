import 'package:flutter/material.dart';
import 'package:helping_hand/src/constants/device_indentifier.dart';
import 'package:helping_hand/src/constants/globals.dart';
import 'package:helping_hand/src/controllers/pref_controller.dart';
import 'package:helping_hand/src/screen/HomeScreen/home_screen.dart';
import 'package:helping_hand/src/screen/SetUsername/set_username.dart';
import 'package:helping_hand/src/services/navigation_service.dart';
import 'package:helping_hand/src/utils/colors.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool _showLogo = false;
  late AnimationController _animController1;

  late Animation<double> _logoScaleAnimation1;
  late Animation<double> _logoOpacityAnimation;

  bool started = false;
  bool showAnim = false;

  bool? notFirstTime;
  bool? isLoggedIn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _showLogo = true;
      });
    });

    _animController1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));

    // Define scale animation
    _logoScaleAnimation1 = Tween<double>(begin: 1.85, end: 0.85).animate(
      CurvedAnimation(
        parent: _animController1,
        curve: Curves.easeInOut,
      ),
    );

    // Define opacity animation
    _logoOpacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController1,
        curve: Curves.easeInOut,
      ),
    );

    _startAnimationSequence();
  }

  @override
  void dispose() {
    _animController1.dispose();
    super.dispose();
  }

  Future<void> _startAnimationSequence() async {
    notFirstTime = !(await PrefController.isFirstTime());
    isLoggedIn = await PrefController.isLoggedIn();

    started = !started;
    setState(() {});

    if (started) {
      _animController1.forward().whenComplete(() {
        if (!mounted) return; // Ensure widget is still in the tree
        setState(() {
          showAnim = true;
        });
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            _navigate();
          }
        });
      });
    }
  }

  _navigate() async {
    AppGlobal.deviceUniqueId = await DeviceIdentifier.getDeviceUniqueId();
    print("Going to navigate function");
    if (notFirstTime == false) {
      if (isLoggedIn == true) {
        AppGlobal.user ??= await PrefController.readUser();

        NavService.removeAllAndOpen(const HomeScreen());
      } else {
        await showUserName(context);
      }
    } else {
      // NavService.removeAllAndOpen(const IntroPrivacyScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.secondary.withOpacity(0.65),
      appBar: null,
      body: AnimatedOpacity(
        opacity: _showLogo ? 1 : 0,
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeInBack,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: screenHeight,
              width: screenWidth,
              child: Opacity(
                opacity: 0.1,
                child: Image.asset(
                  "media/image/splash-back.png",
                  fit: BoxFit.fitHeight,
                  colorBlendMode: BlendMode.colorBurn,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _animController1,
              builder: (context, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        if (showAnim)
                          Opacity(
                            opacity: 0.8,
                            child: Lottie.asset(
                              "media/anims/connected.json",
                              animate: showAnim,
                              height: 350,
                              width: 350,
                              frameRate: const FrameRate(60),
                              reverse: true,
                            ),
                          ),
                        Hero(
                          tag: 'splash-logo',
                          child: Transform.scale(
                            scale: _logoScaleAnimation1.value,
                            child: Opacity(
                              opacity: _logoOpacityAnimation.value,
                              child: SizedBox(
                                height: 300,
                                width: 300,
                                child: Image.asset(
                                  "media/image/hh-logo.png",
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<dynamic> showUserName(BuildContext context) {
  print("Showing server list");
  return showModalBottomSheet(
    isScrollControlled: true,
    isDismissible: false,
    backgroundColor: AppColors.creamWhite,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    ),
    context: context,
    builder: (context) => Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        initialChildSize: MediaQuery.of(context).viewInsets.bottom > 0
            ? 0.45
            : 0.28, // Starts at 30% of screen height
        minChildSize: 0.2, // Minimum size
        maxChildSize: 0.8, // Can expand up to 60% of screen height
        snapSizes: const [0.4],
        expand: false,
        builder: (context, scrollController) => Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: double.infinity,
          margin: const EdgeInsets.only(top: 10),
          child: const SetUsernameScreen(),
        ),
      ),
    ),
  );
}
