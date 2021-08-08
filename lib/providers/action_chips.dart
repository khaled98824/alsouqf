import 'package:alsouqf/models/action_chip_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../models/action_chip_data.dart';
import 'package:flutter/material.dart';

class DevicesAndElectronicsList {
  static final all = <ActionChipData>[
    ActionChipData(
      label:DevicesAndElectronics[0],
      icon: Icons.computer_outlined,
      iconColor: Colors.orange,
    ),
    ActionChipData(
      label: DevicesAndElectronics[1],
      icon: Icons.tv_sharp,
      iconColor: Colors.red,
    ),
    ActionChipData(
      label: DevicesAndElectronics[2],
      icon: Icons.camera_enhance_outlined,
      iconColor: Colors.blue,
    ),
    ActionChipData(
      label: DevicesAndElectronics[3],
      icon: Icons.print,
      iconColor: Colors.purple,
    ),
    ActionChipData(
      label: DevicesAndElectronics[4],
      icon: Icons.router_outlined,
      iconColor: Colors.pink,
    ),
    ActionChipData(
      label: DevicesAndElectronics[5],
      icon: Icons.more_horiz_rounded,
      iconColor: Colors.green,
    ),
  ];
}
//
class MobileList {
  static final all = <ActionChipData>[
    ActionChipData(
      label: Mobile[0],
      icon: FontAwesomeIcons.apple,
      iconColor: Colors.orange,
    ),
    ActionChipData(
      label: Mobile[1],
      icon: FontAwesomeIcons.microchip,
      iconColor: Colors.red,
    ),
    ActionChipData(
      label:Mobile[2],
      icon: Icons.view_comfortable_sharp,
      iconColor: Colors.blue,
    ),
    ActionChipData(
      label: Mobile[3],
      icon: FontAwesomeIcons.screwdriver,
      iconColor: Colors.purple,
    ),
    ActionChipData(
      label: Mobile[4],
      icon: FontAwesomeIcons.mobileAlt,
      iconColor: Colors.pink,
    ),
  ];
}
//
class CarsList {
  static final all = <ActionChipData>[
    ActionChipData(
      label: Cars[0],
      icon: FontAwesomeIcons.car,
      iconColor: Colors.orange,
    ),
    ActionChipData(
      label: Cars[1],
      icon: FontAwesomeIcons.retweet,
      iconColor: Colors.red,
    ),
    ActionChipData(
      label:Cars[2],
      icon: FontAwesomeIcons.truckPickup,
      iconColor: Colors.blue,
    ),
    ActionChipData(
      label: Cars[3],
      icon: FontAwesomeIcons.motorcycle,
      iconColor: Colors.purple,
    ),
  ];
}

//
class HomeList {
  static final all = <ActionChipData>[
    ActionChipData(
      label: Home[0],
      icon: FontAwesomeIcons.plug,
      iconColor: Colors.orange,
    ),
    ActionChipData(
      label: Home[1],
      icon: FontAwesomeIcons.couch,
      iconColor: Colors.red,
    ),
    ActionChipData(
      label:Home[2],
      icon: FontAwesomeIcons.check,
      iconColor: Colors.blue,
    ),
    ActionChipData(
      label: Home[3],
      icon: FontAwesomeIcons.sink,
      iconColor: Colors.purple,
    ),
    ActionChipData(
      label: Home[4],
      icon: FontAwesomeIcons.doorOpen,
      iconColor: Colors.purple,
    ),
    ActionChipData(
      label: Home[5],
      icon: Icons.more_horiz,
      iconColor: Colors.purple,
    ),
  ];
}

//
class ClothesList {
  static final all = <ActionChipData>[
    ActionChipData(
      label: Clothes[0],
      icon: Icons.person,
      iconColor: Colors.orange,
    ),
    ActionChipData(
      label: Clothes[1],
      icon: MdiIcons.faceWoman,
      iconColor: Colors.red,
    ),
    ActionChipData(
      label:Clothes[2],
      icon: MdiIcons.humanMaleBoy,
      iconColor: Colors.blue,
    ),
    ActionChipData(
      label: Clothes[3],
      icon: MdiIcons.humanChild,
      iconColor: Colors.purple,
    ),
    ActionChipData(
      label: Clothes[4],
      icon: Icons.more,
      iconColor: Colors.purple,
    ),
  ];
}


//
class FarmingList {
  static final all = <ActionChipData>[
    ActionChipData(
      label: Farming[0],
      icon: FontAwesomeIcons.tractor,
      iconColor: Colors.orange,
    ),
    ActionChipData(
      label: Farming[1],
      icon:FontAwesomeIcons.braille,
      iconColor: Colors.red,
    ),
    ActionChipData(
      label:Farming[2],
      icon: MdiIcons.humanQueue,
      iconColor: Colors.blue,
    ),
    ActionChipData(
      label: Farming[3],
      icon: MdiIcons.treeOutline,
      iconColor: Colors.purple,
    ),
  ];
}


//
class LivestocksList {
  static final all = <ActionChipData>[
    ActionChipData(
      label: Livestocks[0],
      icon: MdiIcons.sheep,
      iconColor: Colors.orange,
    ),
    ActionChipData(
      label: Livestocks[1],
      icon: MdiIcons.cow,
      iconColor: Colors.red,
    ),
    ActionChipData(
      label:Livestocks[2],
      icon: MdiIcons.bird,
      iconColor: Colors.blue,
    ),
    ActionChipData(
      label: Livestocks[3],
      icon: MdiIcons.grass,
      iconColor: Colors.purple,
    ),
  ];
}

//
class FoodList {
  static final all = <ActionChipData>[
    ActionChipData(
      label: Food[0],
      icon: MdiIcons.foodVariant,
      iconColor: Colors.orange,
    ),
    ActionChipData(
      label: Food[1],
      icon: MdiIcons.foodCroissant,
      iconColor: Colors.red,
    ),
    ActionChipData(
      label:Food[2],
      icon: MdiIcons.foodForkDrink,
      iconColor: Colors.blue,
    ),
    ActionChipData(
      label: Food[3],
      icon: Icons.more,
      iconColor: Colors.purple,
    ),
  ];
}

//
class OccupationsAndServicesList {
  static final all = <ActionChipData>[
    ActionChipData(
      label: OccupationsAndServices[0],
      icon: MdiIcons.officeBuildingOutline,
      iconColor: Colors.orange,
    ),
    ActionChipData(
      label: OccupationsAndServices[1],
      icon: MdiIcons.homeAnalytics,
      iconColor: Colors.red,
    ),
    ActionChipData(
      label:OccupationsAndServices[2],
      icon: Icons.cleaning_services,
      iconColor: Colors.blue,
    ),
    ActionChipData(
      label: OccupationsAndServices[3],
      icon: MdiIcons.partyPopper,
      iconColor: Colors.purple,
    ),
    ActionChipData(
      label: OccupationsAndServices[4],
      icon:MdiIcons.truckDeliveryOutline,
      iconColor: Colors.purple,
    ),
    ActionChipData(
      label: OccupationsAndServices[5],
      icon: MdiIcons.more,
      iconColor: Colors.purple,
    ),
  ];
}

//
class GamesList {
  static final all = <ActionChipData>[
    ActionChipData(
      label: Games[0],
      icon: Icons.mobile_friendly_rounded,
      iconColor: Colors.orange,
    ),
    ActionChipData(
      label: Games[1],
      icon: Icons.computer,
      iconColor: Colors.red,
    ),
    ActionChipData(
      label:Games[2],
      icon: Icons.gamepad_outlined,
      iconColor: Colors.blue,
    ),
    ActionChipData(
      label: Games[3],
      icon: Icons.more,
      iconColor: Colors.purple,
    ),
  ];
}


const  Games = [
  'ألعاب موبايل',
  'ألعاب كمبيوتر',
  "ألعاب وتسالي الأطفال",
  "أخرى"
];
const OccupationsAndServices = [
  'البناء',
  'صيانة المنزل',
  "خدمات التنظيف",
  "خدمات مناسبات",
  "خدمات توصيل",
  "أخرى"
];
const Food = [
  'أجبان ألبان - مونة',
  'حلويات',
  "أطعمة شعبية",
  "أخرى"
];
const Livestocks = [
  'أغنام',
  'أبقار',
  "طيور",
  "أعلاف"
];
const Farming = [
  'معدات زراعية',
  'مواد زراعية وبذور',
  "ورش الأعمال الزراعية",
  "مشاتل - أغراس"
];
const Clothes = [
  'ألبسة رجالية',
  'ألبسة نسائية',
  "ألبسة ولادي-بناتي",
  "ألبسة أطفال",
  "أقمشة"
];
const Home = [
  'أجهزة كهربائية',
  'أثاث',
  "منسوجات - سجاد",
  "أدوات المطبخ",
  "أبواب - شبابيك - ألمنيوم",
  "أخرى"
];
const DevicesAndElectronics = [
  'لابتوب - كمبيوتر',
  'تلفزيون شاشات',
  "كاميرات - تصوير",
  "طابعات",
  "راوترات - أجهزة إنترنت",
  "أخرى"
];
const Cars = [
  'سيارات للبيع',
  'سيارات للإيجار',
  "قطع غيار",
  "دراجات نارية للبيع"
];
const Mobile = [
  'أبل',
  'هواوي',
  'سامسونج',
  'صيانة الموبايل',
  'إكسسوارات'
];
