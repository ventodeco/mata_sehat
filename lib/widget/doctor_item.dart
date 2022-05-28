import 'package:image_class/models/doctor.dart';
import 'package:image_class/theme.dart';
import 'package:flutter/material.dart';

class DoctorItem extends StatelessWidget {
  final Doctor doctor;

  DoctorItem(this.doctor);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 313,
        color: Color(0xffF6F7F8),
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  doctor.imageUrl,
                  width: 313,
                  height: 185,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            SizedBox(
              height: 11,
            ),
            Text(
              doctor.name,
              style: blackTextStyle.copyWith(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              doctor.phoneNumber,
              style: blackTextStyle.copyWith(
                  fontSize: 16, fontWeight: FontWeight.w300),
            ),
            Text(
              doctor.location,
              style: blackTextStyle.copyWith(
                  fontSize: 16, fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }
}
