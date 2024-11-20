import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/constants.dart';
import '../providers/auth_provider.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int _currentPage = 0;
  final PageController _controller = PageController();
  final List<Map<String, dynamic>> demoData = [
    {
      'image': assetImages[0],
      'title': 'Fast and no time consuming as mobile teacher',
      'desc': 'Sometime is hard to take courses from youtube'
    },
    {
      'image': assetImages[2],
      'title': 'Get your free certifications now',
      'desc':'Learn for free and get your certifications as soon as you finish'
    },
    {
      'image': assetImages[1],
      'title': 'Let \'s go now',
      'desc': 'Are you ready ?'
    },
  ];

  @override
  Widget build(BuildContext context) {
    void getStarted() {
      Provider.of<Auth>(context, listen: false).initOnBoardingPage();
    }

    final ThemeData theme = Theme.of(context);
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
                    AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(demoData[index]['image']),
                    ),
                    Text(
                      demoData[index]['title'],
                      style: TextStyle(
                        color: theme.primaryColor,
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
                        color: theme.primaryColor.withOpacity(0.7),
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
                                color: theme.primaryColor,
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
                              ? theme.primaryColor
                              : theme.primaryColor.withOpacity(0.3),
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
                                color: theme.primaryColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 10,
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
                                color: theme.primaryColor,
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
