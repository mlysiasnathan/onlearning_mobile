import 'package:flutter/material.dart';

import 'auth_screen_2.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  int _currentPage = 0;
  final PageController _controller = PageController();
  final List<Map<String, dynamic>> demoData = [
    {
      'image': 'assets/images/onboarding/undraw_time_management_re_tk5w.svg',
      'title': 'Fast and no time consuming as mobile wallet',
      'desc': 'Sending money as faster as possible is now possible'
    },
    {
      'image':
          'assets/images/onboarding/undraw_credit_card_payments_re_qboh.svg',
      'title': 'Get your physical card',
      'desc':
          'For more easiness to pay your bill in the usual expense you can request a physical credit card'
    },
    {
      'image': 'assets/images/onboarding/undraw_happy_news_re_tsbd.svg',
      'title': 'Let \'s go now',
      'desc': 'Are you ready ?'
    },
  ];

  @override
  Widget build(BuildContext context) {
    void getStarted() {
      Navigator.pushReplacementNamed(context, AuthScreen2.routeName);
      // Provider.of<UsersProvider>(context, listen: false).isInit = true;
      // Provider.of<UsersProvider>(context, listen: false).notifyListeners();
    }

    final Color primaryColor = Theme.of(context).primaryColor;
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: demoData.length,
                itemBuilder: (context, index) => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // AspectRatio(
                    //   aspectRatio: 1,
                    //   child: SvgPicture.asset(demoData[index]['image']),
                    // ),
                    AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(demoData[index]['image']),
                    ),
                    Text(
                      demoData[index]['title'],
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: deviceSize.width * 0.07,
                        fontWeight: FontWeight.w900,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      demoData[index]['desc'],
                      style: TextStyle(
                        color: primaryColor.withOpacity(0.7),
                        fontSize: deviceSize.width * 0.045,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    child: _currentPage == demoData.length - 1
                        ? null
                        : GestureDetector(
                            onTap: () =>
                                _controller.jumpToPage(demoData.length),
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w900,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      demoData.length,
                      (index) => AnimatedContainer(
                        height: 6,
                        width: _currentPage == index ? 20 : 6,
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? primaryColor
                              : primaryColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: _currentPage == demoData.length - 1
                        ? TextButton(
                            onPressed: getStarted,
                            child: Text(
                              'GET STARTED',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w900,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : GestureDetector(
                            onTap: () => _controller.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn),
                            child: Text(
                              'Next',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w900,
                              ),
                              textAlign: TextAlign.center,
                            ),
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
