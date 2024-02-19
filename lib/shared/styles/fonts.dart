import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class WeLinkTextStyles {
  static weLinkRegularMontserrat({color, fw, fs}) {
    return GoogleFonts.montserrat(
      color: color ?? WeLinkColors.weLinkWhite,
      fontWeight: fw ?? FontWeight.w500,
      fontSize: fs ?? 20,
    );
  }

  static weLinkHintMontserrat({color, fw, fs}) {
    return GoogleFonts.montserrat(
      color: color ?? WeLinkColors.weLinkGrey,
      fontWeight: fw ?? FontWeight.w600,
      fontSize: fs ?? 15,
    );
  }

  static weLinkHeadlines({color, fw, fs}) {
    return GoogleFonts.montserrat(
      color: color ?? WeLinkColors.weLinkWhite,
      fontWeight: fw ?? FontWeight.w700,
      fontSize: fs ?? 25,
    );
  }
}
