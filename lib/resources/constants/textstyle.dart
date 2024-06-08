import 'package:fix_mates_user/resources/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText {
  static TextStyle get xSmall => const TextStyle(
      fontSize: 11.5,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins',
      color: AppColors.whiteColor,
      overflow: TextOverflow.ellipsis);

  static TextStyle get smallDark => const TextStyle(
      fontSize: 12,
      color: AppColors.whiteColor,
      overflow: TextOverflow.ellipsis);

  static TextStyle get smallBlack => const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Color.fromARGB(255, 0, 0, 0),
      overflow: TextOverflow.ellipsis);

  static TextStyle get averagewhite => const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.whiteColor,
      overflow: TextOverflow.ellipsis);

  static TextStyle get labeltext => const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: AppColors.whiteColor,
      overflow: TextOverflow.ellipsis);

  static TextStyle get smallabeltext => const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: AppColors.whiteColor,
      overflow: TextOverflow.ellipsis);

  static TextStyle get smalldestext => const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.whiteColor,
      );

  static TextStyle get labeltextbig => const TextStyle(
      fontSize: 21,
      fontWeight: FontWeight.w500,
      color: AppColors.whiteColor,
      overflow: TextOverflow.ellipsis);

  static TextStyle get mediumWhite => const TextStyle(
      fontSize: 23,
      fontWeight: FontWeight.w600,
      color: AppColors.whiteColor,
      overflow: TextOverflow.ellipsis);

  static TextStyle get largeDark => const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.whiteColor,
      overflow: TextOverflow.ellipsis);

  static TextStyle get xLarge => const TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w600,
      color: AppColors.whiteColor,
      overflow: TextOverflow.ellipsis);

  static TextStyle get button => const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.blackColor,
      overflow: TextOverflow.ellipsis);

  static TextStyle get incontainer => const TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w400,
      color: AppColors.whiteColor,
      overflow: TextOverflow.ellipsis);

  static const TextStyle privacyText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  static TextStyle get appname => GoogleFonts.lobster(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppColors.whiteColor,
      );
  static TextStyle get appnamesplash => GoogleFonts.lobster(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        color: AppColors.whiteColor,
      );

  static TextStyle get versionName => GoogleFonts.lobster(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: const Color.fromARGB(158, 255, 255, 255),
      );
}
