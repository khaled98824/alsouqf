import 'package:alsouqf/models/filter_chip_data.dart';
import '../models/filter_chip_data.dart';
import 'package:flutter/material.dart';

class FilterChips {
  static final all = <FilterChipData>[
    FilterChipData(
      label: Category[0] ,
      isSelected: false,
      color: Colors.green,
    ),
    FilterChipData(
      label: Category[1],
      isSelected: false,
      color: Colors.red,
    ),
    FilterChipData(
      label: Category[2],
      isSelected: false,
      color: Colors.blue,
    ),
    FilterChipData(
      label: Category[3],
      isSelected: false,
      color: Colors.orange,
    ),
    FilterChipData(
      label: Category[4],
      isSelected: false,
      color: Colors.purple,
    ),
    FilterChipData(
      label: Category[5],
      isSelected: false,
      color: Colors.deepPurple,
    ),
    FilterChipData(
      label: Category[6],
      isSelected: false,
      color: Colors.deepPurpleAccent,
    ),
    FilterChipData(
      label: Category[7],
      isSelected: false,
      color: Colors.brown,
    ),
    FilterChipData(
      label: Category[8],
      isSelected: false,
      color: Colors.amber.shade900,
    ),
    FilterChipData(
      label: Category[9],
      isSelected: false,
      color: Colors.redAccent,
    ),
    FilterChipData(
      label: Category[10],
      isSelected: false,
      color: Colors.blue.shade800,
    ),
    FilterChipData(
      label: Category[11],
      isSelected: false,
      color: Colors.brown,
    ),

  ];
}
const Category = [
  'السيارات - الدراجات',
  'الموبايل',
  'أجهزة - إلكترونيات',
  'وظائف وأعمال',
  'مهن وخدمات',
  'المنزل',
  'المعدات والشاحنات',
  'المواشي',
  'الزراعة',
  'ألعاب',
  'ألبسة',
  'أطعمة'
];