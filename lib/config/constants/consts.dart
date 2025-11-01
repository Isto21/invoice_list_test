import 'package:flutter/material.dart';

enum PaymentType { offer, exchange, product }

class ApkConstants {
  // Language
  static String language(int index) {
    switch (index) {
      case 0:
        return 'English';
      case 1:
        return 'Spanish';
      case 2:
        return 'System';
      default:
        return 'System';
    }
  }

  static int paymentType(PaymentType index) {
    switch (index) {
      case PaymentType.offer:
        return 0;
      case PaymentType.exchange:
        return 1;
      case PaymentType.product:
        return 2;
    }
  }

  static PaymentType paymentTypeInt(int index) {
    switch (index) {
      case 0:
        return PaymentType.offer;
      case 1:
        return PaymentType.exchange;
      case 2:
        return PaymentType.product;
      default:
        return PaymentType.product;
    }
  }

  // Brightness
  static const int lightMode = 0;
  static const int darkMode = 1;
  static const int autoMode = 2;

  // Marca
  static const int isNotLogged = 0;
  static const int onRegister = 1;
  static const int isLogged = 2;

  // Veirification Code
  static const int isVerificationCode = 0;
  static const int isChangeMainSession = 1;

  // static const int isLogged = 2;

  // static const String MontserratFont = 'Montserrat';
  // static const String MontserratBoldFont = 'MontserratBold';
  // static const String MontserratMediumFont = 'MontserratMedium';
  // static const String MontserratLightFont = 'MontserratLight';

  // SLivers
  static const double maxExtentTemp = 180;
  static const double minExtentTemp = 120;
  static const double ordersExtentTemp = 120;
  static const double moveSearch = 10;

  //Colors
  static const Color primaryApkColor = Color(0xFFD94D01);
  static const Color lightApkColor = Color(0xffFFD6BF);
  static const Color lightGreenApkColor = Color(0xffDDE8A3);
  static const Color redApkColor = Color(0xffD80027);
  static const Color greyApkColor = Color(0xffCBCBCB);
}

class AccountConsts {
  static const String myOrders = 'assets/account_icons/bag-2.svg';
  static const String collections = 'assets/account_icons/camera.svg';
  static const String myOffers = 'assets/account_icons/coin.svg';
  static const String wishList = 'assets/account_icons/heart.svg';
  static const String notifications = 'assets/account_icons/notification.svg';
  static const String myExchanges = 'assets/account_icons/refresh-2.svg';
  static const String message = 'assets/account_icons/sms.svg';
  static const String itemsList = 'assets/account_icons/Vector.svg';
  static const String person = 'assets/account_icons/profile.svg';
  static const String preferences = 'assets/account_icons/archive-tick.svg';
  static const String premium = 'assets/account_icons/eos.svg';
  static const String payment = 'assets/account_icons/payment.svg';
}

class AppConfig {
  static const String languageDefault = "en";
  static final Map<String, AppLanguage> languagesSupported = {
    "en": AppLanguage("English"),
    // "ar": AppLanguage("عربى"),
    // "pt": AppLanguage("Portugal"),
    // "fr": AppLanguage("Français"),
    // "id": AppLanguage("Bahasa Indonesia"),
    "es": AppLanguage("Español"),
    // "it": AppLanguage("italiano"),
    // "tr": AppLanguage("Türk"),
    // "sw": AppLanguage("Kiswahili"),
    // "de": AppLanguage("Deutsch"),
    // "ro": AppLanguage("Română"),
  };
}

class AppLanguage {
  final String name;
  // final Map<String, String> values;
  AppLanguage(this.name);
}

class ImageConsts {
  static const String loginBackground = 'assets/placeholder/placeholder.png';
  static const String noPhoto = 'assets/placeholder/noPhoto.jpg';
  // static const String logoApk = 'assets/images/logoApk.png';
}

class IconConsts {
  static const String googleLogo = 'assets/google_logo.png';
  static const String appleLogo = 'assets/apple_logo.png';
  static const String splashLogo = 'assets/adpt.png';
  static const String bottomNavBar = 'assets/bottombar/icon.svg';
  static const String bottomNavBar1 = 'assets/bottombar/icon1.svg';
  static const String bottomNavBar2 = 'assets/bottombar/icon2.svg';
  static const String bottomNavBar3 = 'assets/bottombar/icon3.svg';
}

class ApkConsts {
  static const String splashLogo = 'assets/appbarIcon.svg';
  static const String apkName = 'Collectors Court';
  static const String apkVersion = "V 0.1.2+22";
  static const String apkLogo = 'assets/adaptiveFore.png';
  static const String loadingGifPlaceholder =
      'assets/splash collector court.gif';
}

class MetricsConsts {
  static const double clipperSize = 250;
  // vertical: 32, horizontal: 40
  static const double bottomVerticalPadding = 32;
  static const double bottomHorizontalPadding = 40;
}

class HeroTagConsts {
  static const String showImage6 = 'ShowImage';
  static const String profileImage = 'ProfileImage';
  static String cardImage(String image) => 'CardImage$image';
  static heroAnimation(int index, String tag) => "heroAnimation$index$tag";
}

class Docs {
  static const String terms = 'assets/terms/terms.docx';
}

class ViewConsts {
  static const int withoutConectionView = 0;
  static const int homeView = 1;
  static const int settingsView = 2;
}
