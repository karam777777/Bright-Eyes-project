import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:get/get.dart';

class Awareness extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medical Information',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MedicalInfoPage(),
    );
  }
}

class MedicalInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText(
              'Medical Information',
              textStyle: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              colors: [
               
                Colors.blue,
                Colors.yellow,
                Colors.red,
              ],
            ),
          ],
          isRepeatingAnimation: true,
          repeatForever: true,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: AnimationLimiter(
        child: ListView(
          padding: EdgeInsets.all(10.0),
          children: [
            _buildAnimatedInfoCard(
              context,
              'إجراء فحص دوري للعيون يساعد في الكشف المبكر عن مشاكل العيون مثل الجلوكوما، التنكس البقعي، واعتلال الشبكية السكري.',
              'images/المعلومةالأولى.jpg',
            ),
            SizedBox(height: 10.0),
            _buildAnimatedInfoCard(
              context,
              'تناول أطعمة غنية بالأوميغا-3، اللوتين، الزنك، والفيتامينات C وE يساعد في تقليل خطر التنكس البقعي المرتبط بالعمر.',
              'images/المعلومةالثانية.jpg',
            ),
            SizedBox(height: 10.0),
            _buildAnimatedInfoCard(
              context,
              'التدخين يزيد من خطر الإصابة بالتنكس البقعي وإعتام عدسة العين، ويؤدي إلى تلف العصب البصري.',
              'images/المعلومةالثالثة.jpg',
            ),
            SizedBox(height: 10.0),
            _buildAnimatedInfoCard(
              context,
              'ارتداء النظارات الشمسية التي تحجب الأشعة فوق البنفسجية (UV) يحمي العينين من الضرر الذي تسببه هذه الأشعة، مما يقلل من خطر إعتام عدسة العين وتلف الشبكية.',
              'images/المعلومةالرابعة.jpg',
            ),
            SizedBox(height: 10.0),
            _buildAnimatedInfoCard(
              context,
              'اتباع قاعدة 20-20-20 (الراحة لمدة 20 ثانية كل 20 دقيقة بالنظر إلى شيء يبعد 20 قدمًا) يساعد في تقليل إجهاد العينين الناجم عن استخدام الحاسوب والأجهزة الرقمية.',
              'images/المعلومةالخامسة.jpg',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedInfoCard(BuildContext context, String text, String imagePath) {
    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: const Duration(milliseconds: 375),
      child: SlideAnimation(
        horizontalOffset: 50.0,
        child: FadeInAnimation(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade200,
                  blurRadius: 5.0,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
