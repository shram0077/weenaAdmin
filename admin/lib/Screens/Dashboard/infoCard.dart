import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final Color topColor;
  final IconData icon;

  const InfoCard({
    key,
    required this.title,
    required this.value,
    required this.topColor,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 136,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 6),
                color: Colors.green.withOpacity(.1),
                blurRadius: 12)
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Container(
                  color: topColor,
                  height: 5,
                ))
              ],
            ),
            Expanded(child: Container()),
            Icon(
              icon,
              size: 30,
              color: topColor,
            ),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text: title,
                      style: GoogleFonts.barlow(
                          fontSize: 30,
                          color: topColor,
                          fontWeight: FontWeight.w600)),
                  TextSpan(
                      text: " $value",
                      style: GoogleFonts.lato(
                          fontSize: 28,
                          color: topColor,
                          fontWeight: FontWeight.bold)),
                ])),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
