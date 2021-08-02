import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  static const routeName = "/AboutUs";

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff4d4d4d),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'حول التطبيق',
          style: Theme.of(context).textTheme.headline4
        ),
      ),
      body: ListView(
        children: [
          Padding(padding: EdgeInsets.only(top: 16)),

          Card(
            color: Color(0xff4d4d4d),
            child: Padding(
              padding: EdgeInsets.only(right: 10,left: 10,top: 5,bottom: 7),
              child: Text('حول التطبيق',textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.headline4,),
            ),
          ),
          Card(
            color: Color(0xff4d4d4d),
            child: Padding(
              padding: EdgeInsets.only(right: 10,left: 10,top: 5,bottom: 7),
              child: Text('ان تطبيق سوق الفرات هو منصة تمكن مستخدميه من الإعلان عن اي شئ \nاو عن اي سلعة يريدون بيعها, كما يمكن التطبيق اي شخص من الإعلان عن خدمات او اعمال يقوم بتقديمها. ',textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.headline4,),
            ),
          ),
          Card(
            color: Color(0xff4d4d4d),
            child: Padding(
              padding: EdgeInsets.only(right: 10,left: 10,top: 5,bottom: 7),
              child: Text('وبالمقابل يمكن التطبيق مستخدميه من البحث عن متطلباتهم من سلع واغراض \nوخدمات بكل يسر وامان حتى يستطيع المستخدم التواصل مع اصحاب تلك السلع والخدمات بشكل مباشر دون وجود وسيط',textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.headline4,),
            ),
          ),

          Card(
            color: Color(0xff4d4d4d),
            child: Padding(
              padding: EdgeInsets.only(right: 10,left: 10,top: 5,bottom: 7),
              child: Text(': يحوي التطبيق على الاقسام التالية \nالسيارات والدراجات , الموبايل , أجهزة - إلكترونيات , وظائف وأعمال\n  المنزل , مهن وخدمات , المواشي ,  المعدات والشاحنات , ألعاب , الزراعة , الأطعمة , الألبسة.',textAlign: TextAlign.right,
                style:Theme.of(context).textTheme.headline4,),
            ),
          ),
          Card(
            color: Color(0xff4d4d4d),
            child: Padding(
              padding: EdgeInsets.only(right: 10,left: 10,top: 5,bottom: 7),
              child: Text(': دليل الإستخدام \nلإستخدام تطبيق سوق الفرات اول مره قم بتسجيل حساب خاص بك \nبشكل اعتيادي بواسطة البريد الإلكتروني, بعدها يمكنك تصفح\n الإعلانات الموجودة في كل الأقسام مباشرة ويمكنك التواصل مع المعلنين\n واضافة تعليق على إعلاناتهم .كما يمكنك اظافة اعلانك بشكل مجاني حتى\n يتمكن الناس من رؤيته , وذلك بالانتقال الى واجهة اظافة اعلان جديد التي\n تمكنك من اظافة كل المعلومات التي تحتاج لعرضها في اعلانك  مثل الصور \nواسم الاعلان ووصف المعروض والسعر والمنطقة ورقم الهاتف للتواصل والقسم الخاص باعلانك ',textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.headline4,),
            ),
          ),
          Card(
            color: Color(0xff4d4d4d),
            child: Padding(
              padding: EdgeInsets.only(right: 10,left: 10,top: 5,bottom: 7),
              child: Text(': رؤية \nيهدف تطبيق سوق الفرات الى جعل اي شخص قادر على بيع مايريد من السلع \nوالحاجات وتقديم الخدمات والاعمال بشكل سهل وميسر للوصول الى كل \nالناس .من اهداف انشاء هذا التطبيق هو مساعدة مقدمي الخدمات واصحاب\n المهن والاعمال والحرف للوصول الى نطاق واسع من طالبي تلك الخدمات ,\n كما يهدف التطبيق الى توسيع افق الخدمات والاعمال وفتح سبل للتجارة\n المباشرة بين البائع والشاري  ',textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.headline4,),
            ),
          ),

        ],
      ),
    );
  }}