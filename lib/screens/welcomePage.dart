import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/screens/signup_page.dart';
import 'package:graduation_project_frontend/widgets/customTextStyle.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = "WelcomeScreen";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  List<OnboardingItem> onboardingItems = [
    OnboardingItem(
      title: "AI-Powered Radiology",
      description:
          "Advanced AI algorithms analyze DICOM images to provide accurate diagnostic assistance",
      image: "assets/images/Ai.png",
    ),
    OnboardingItem(
      title: "Interactive DICOM Viewer",
      description:
          "View and manipulate medical images with our advanced interactive tools",
      image: "assets/images/CT-Scan.jpg",
    ),
    OnboardingItem(
      title: "Seamless Communication",
      description:
          "Chat directly with radiologists and healthcare providers for immediate consultation",
      image: "assets/images/chat.png",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, SignupPage.id);
                },
                child: Text(
                  "Skip",
                  style: customTextStyle(25,FontWeight.w600, blue).copyWith(
                    shadows :[
                      Shadow(
                    offset:Offset(1.5,1.5),
                    blurRadius:3.0,
                    color : Colors.black26
                   ) ]
                  )
                  
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingItems.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                    _animationController.forward(from: 0.0);
                  });
                },
                itemBuilder: (context, index) {
                  return SlideTransition(
                    position: _slideAnimation,
                    child: buildOnboardingPage(onboardingItems[index]),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingItems.length,
                  (index) => buildDot(index: index),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(30),
              child: SizedBox(
                width: 125.5,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < onboardingItems.length - 1) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    } else {
                      Navigator.of(context).pushReplacementNamed(SignupPage.id);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentPage < onboardingItems.length - 1
                        ? "Next"
                        : "Join Us",
                    style:  customTextStyle(18,FontWeight.w600, Colors.white)
                    
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOnboardingPage(OnboardingItem item) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: blue,
                  blurRadius: 10,
                  spreadRadius: 3,
                  offset: Offset(2, 4),
                )
              ],
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                item.image,
                height: 400,
              ),
            ),
          ),
          SizedBox(height: 30),
          Text(
            item.title,
            style: customTextStyle(28,FontWeight.w600, Colors.black)
            
          ),
          SizedBox(height: 15),
          Text(
            item.description,
            textAlign: TextAlign.center,
            style:  customTextStyle(18,FontWeight.w400, blue)
           
          ),
        ],
      ),
    );
  }

  Widget buildDot({required int index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.only(right: 6),
      height: 10,
      width: _currentPage == index ? 24 : 10,
      decoration: BoxDecoration(
        color:
            _currentPage == index ? blue : sky,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final String image;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
  });
}
