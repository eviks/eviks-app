import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import './models/filters.dart';
import './models/metro_station.dart';
import './models/pagination.dart';
import './models/post.dart';
import './models/settlement.dart';

// Production
// const baseUrl = 'https://eviks.xyz';
// const baseScheme = 'https';
// const baseHost = 'eviks.xyz';
// const basePort = 443;

// Development
const baseUrl = 'http://192.168.1.108:3000';
const baseScheme = 'http';
const baseHost = '192.168.1.108';
const basePort = 3000;

const primaryColor = Color(0xFFFF337A);
const lightPrimaryColor = Color(0xFFFF4788);
const lightColor = Color(0xFFFFFFFF);
const lightGreyColor = Color(0xFFD8D8D8);
const greyColor = Color(0xFFB4B4B4);
const darkGreyColor = Color(0xFF7A7A7A);
const darkColor = Color(0xFF151316);
const softDarkColor = Color(0xFF342E37);
const dangerColor = Color(0xFFFF337A);
const lightDangerColor = Color(0xFFFF4788);

final currencyFormat =
    NumberFormat.currency(locale: 'az_AZ', symbol: '₼', decimalDigits: 0);

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}

void showSnackBar(BuildContext context, String mesaage) {
  final snackbar = SnackBar(
    content: Text(mesaage),
    duration: const Duration(seconds: 5),
    action: SnackBarAction(
      label: AppLocalizations.of(context)!.close,
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

String priceFormatter(BuildContext context, int price) {
  if (price > 999 && price < 99999) {
    return "${(price / 1000).toStringAsFixed(1)} ${AppLocalizations.of(context)!.thousand}";
  } else if (price > 99999 && price < 999999) {
    return "${(price / 1000).toStringAsFixed(0)} ${AppLocalizations.of(context)!.thousand}";
  } else if (price > 999999 && price < 999999999) {
    return "${(price / 1000000).toStringAsFixed(1)} ${AppLocalizations.of(context)!.million}";
  } else if (price > 999999999) {
    return "${(price / 1000000000).toStringAsFixed(1)} ${AppLocalizations.of(context)!.billion}";
  } else {
    return price.toString();
  }
}

String removeAzerbaijaniChars(String value) {
  String newValue = value;
  newValue = newValue.replaceAll(RegExp('ç', caseSensitive: false), 'c');
  newValue = newValue.replaceAll(RegExp('ə', caseSensitive: false), 'e');
  newValue = newValue.replaceAll(RegExp('ğ', caseSensitive: false), 'g');
  newValue = newValue.replaceAll(RegExp('ı', caseSensitive: false), 'i');
  newValue = newValue.replaceAll(RegExp('ö', caseSensitive: false), 'o');
  newValue = newValue.replaceAll(RegExp('ş', caseSensitive: false), 's');
  newValue = newValue.replaceAll(RegExp('ü', caseSensitive: false), 'u');
  return newValue;
}

Settlement getCapitalCity() {
  return Settlement(
    id: '10',
    name: 'Bakı',
    nameRu: 'Баку',
    nameEn: 'Baku',
    routeName: 'baku',
    type: "2",
    x: 49.8786270618439,
    y: 40.379108951404,
    metroStations: [
      MetroStation(
        id: 1,
        cityId: '10',
        name: '28 May',
        nameRu: '28 Май',
        nameEn: '28 May',
        x: 49.8491334915161,
        y: 40.3798526861589,
      ),
      MetroStation(
        id: 2,
        cityId: '10',
        name: 'Nəriman Nərimanov',
        nameRu: 'Нариман Нариманов',
        nameEn: 'Nariman Narimanov',
        x: 49.8704516887665,
        y: 40.4029003060097,
      ),
      MetroStation(
        id: 3,
        cityId: '10',
        name: 'Qara Qarayev',
        nameRu: 'Кара Караев',
        nameEn: 'Gara Garayev',
        x: 49.93448138237,
        y: 40.4175558116373,
      ),
      MetroStation(
        id: 4,
        cityId: '10',
        name: 'Neftçilər',
        nameRu: 'Нефтчиляр',
        nameEn: 'Neftchilar',
        x: 49.9434989690781,
        y: 40.4105062092501,
      ),
      MetroStation(
        id: 5,
        cityId: '10',
        name: 'Xalqlar Dostluğu',
        nameRu: 'Халглар достлугу',
        nameEn: 'Halglar Doslugu',
        x: 49.9524468183517,
        y: 40.3975650404193,
      ),
      MetroStation(
        id: 6,
        cityId: '10',
        name: 'Koroğlu',
        nameRu: 'Кероглу',
        nameEn: 'Koroglu',
        x: 49.9181360006332,
        y: 40.4209537339068,
      ),
      MetroStation(
        id: 7,
        cityId: '10',
        name: 'Ulduz',
        nameRu: 'Улдуз',
        nameEn: 'Ulduz',
        x: 49.8916035890579,
        y: 40.4148275479144,
      ),
      MetroStation(
        id: 8,
        cityId: '10',
        name: 'Gənclik',
        nameRu: 'Гянджлик',
        nameEn: 'Ganjlik',
        x: 49.8511558771133,
        y: 40.4007147774345,
      ),
      MetroStation(
        id: 9,
        cityId: '10',
        name: 'Həzi Aslanov',
        nameRu: 'Ази Асланов',
        nameEn: 'Hazi Aslanov',
        x: 49.9536591768265,
        y: 40.3721166260112,
      ),
      MetroStation(
        id: 10,
        cityId: '10',
        name: 'Bakmil',
        nameRu: 'Бакмил',
        nameEn: 'Bakmil',
        x: 49.8772484064102,
        y: 40.4189689107337,
      ),
      MetroStation(
        id: 11,
        cityId: '10',
        name: 'Əhmədli',
        nameRu: 'Ахмедлы',
        nameEn: 'Ahmedli',
        x: 49.9539971351624,
        y: 40.3851770968207,
      ),
      MetroStation(
        id: 12,
        cityId: '10',
        name: '20 Yanvar',
        nameRu: '20 января',
        nameEn: '20 Yanvar',
        x: 49.8083209991455,
        y: 40.4043014580299,
      ),
      MetroStation(
        id: 13,
        cityId: '10',
        name: 'İçərişəhər',
        nameRu: 'Ичери Шехер',
        nameEn: 'Icheri Sheher',
        x: 49.8315167427063,
        y: 40.3659083369244,
      ),
      MetroStation(
        id: 14,
        cityId: '10',
        name: 'İnşaatçılar',
        nameRu: 'Иншаатчылар',
        nameEn: 'Inshaatchilar',
        x: 49.8028171062469,
        y: 40.3913386675955,
      ),
      MetroStation(
        id: 15,
        cityId: '10',
        name: 'Nizami',
        nameRu: 'Низами Гянджеви',
        nameEn: 'Nizami Ganjavi',
        x: 49.8299664258957,
        y: 40.3794317823335,
      ),
      MetroStation(
        id: 16,
        cityId: '10',
        name: 'Memar Əcəmi',
        nameRu: 'Мемар Аджеми',
        nameEn: 'Memar Ajami',
        x: 49.8144739866257,
        y: 40.4117111472699,
      ),
      MetroStation(
        id: 17,
        cityId: '10',
        name: 'Sahil',
        nameRu: 'Сахил',
        nameEn: 'Sahil',
        x: 49.8444718122482,
        y: 40.3718918460624,
      ),
      MetroStation(
        id: 18,
        cityId: '10',
        name: 'Elmlər Akademiyası',
        nameRu: 'Элмляр Академиясы',
        nameEn: 'Elmlar Akademiyası',
        x: 49.815428853035,
        y: 40.3750918245097,
      ),
      MetroStation(
        id: 19,
        cityId: '10',
        name: 'Avtovağzal',
        nameRu: 'Автовокзал',
        nameEn: 'Avtovagzal',
        x: 49.7950387001038,
        y: 40.4215050632847,
      ),
      MetroStation(
        id: 20,
        cityId: '10',
        name: 'Nəsimi',
        nameRu: 'Насими',
        nameEn: 'Nasimi',
        x: 49.8239582777023,
        y: 40.4243596520195,
      ),
      MetroStation(
        id: 21,
        cityId: '10',
        name: 'Azadlıq prospekti',
        nameRu: 'Азадлыг проспекти',
        nameEn: 'Azadlig Prospekti',
        x: 49.8427551984787,
        y: 40.4258461137809,
      ),
      MetroStation(
        id: 22,
        cityId: '10',
        name: '8 Noyabr',
        nameRu: '8 ноября',
        nameEn: '8 Noyabr',
        x: 49.8201763629913,
        y: 40.4027777548833,
      ),
      MetroStation(
        id: 23,
        cityId: '10',
        name: 'Dərnəgül',
        nameRu: 'Дарнагюль',
        nameEn: 'Darnagul',
        x: 49.8617023229599,
        y: 40.4250457153759,
      ),
      MetroStation(
        id: 24,
        cityId: '10',
        name: 'Cəfər Cabbarlı',
        nameRu: 'Джафар Джаббарлы',
        nameEn: 'Jafar Jabbarli',
        x: 49.8487848043442,
        y: 40.3795911539942,
      ),
      MetroStation(
        id: 25,
        cityId: '10',
        name: 'Şah İsmayıl Xətai',
        nameRu: 'Шах Исмаил Хатаи',
        nameEn: 'Shah Ismail Hatai',
        x: 49.8720180988312,
        y: 40.3830359415883,
      ),
    ],
    children: [
      Settlement(
        id: "114",
        y: 40.379108951404,
        name: "Xətai",
        nameRu: "Хатаи",
        nameEn: "Khatai",
        type: "8",
        x: 49.8786270618439,
        routeName: "khatai",
      ),
      Settlement(
        id: "111",
        y: 40.3763014830388,
        name: "Nəsimi",
        nameRu: "Насими",
        nameEn: "Nasimi",
        type: "8",
        x: 49.8472934961319,
        routeName: "nasimi",
      ),
      Settlement(
        id: "112",
        y: 40.3955059887146,
        name: "Nərimanov",
        nameRu: "Нариманов",
        nameEn: "Narimanov",
        type: "8",
        x: 49.8594170808792,
        routeName: "narimanov",
      ),
      Settlement(
        id: "115",
        y: 40.3691167736574,
        name: "Səbail",
        nameRu: "Сабаил",
        nameEn: "Sabail",
        type: "8",
        x: 49.8363661766052,
        routeName: "sabail",
      ),
      Settlement(
        id: "120",
        y: 40.517045400302,
        name: "Xəzər",
        nameRu: "Хазар",
        nameEn: "Khazar",
        type: "8",
        x: 50.106834769249,
        routeName: "khazar",
      ),
      Settlement(
        id: "117",
        y: 40.4140392714797,
        name: "Binəqədi",
        nameRu: "Бинагади",
        nameEn: "Binagadi",
        type: "8",
        x: 49.839391708374,
        routeName: "binagadi",
      ),
      Settlement(
        id: "116",
        y: 40.3721125391098,
        name: "Yasamal",
        nameRu: "Ясамал",
        nameEn: "Yasamal",
        type: "8",
        x: 49.817596077919,
        routeName: "yasamal",
      ),
      Settlement(
        id: "121",
        y: 40.3046121997112,
        name: "Qaradağ",
        nameRu: "Гарадаг",
        nameEn: "Garadagh",
        type: "8",
        x: 49.6176052093506,
        routeName: "garadagh",
      ),
      Settlement(
        id: "113",
        y: 40.3974955893046,
        name: "Nizami",
        nameRu: "Низами",
        nameEn: "Nizami",
        type: "8",
        x: 49.9464815855026,
        routeName: "nizami",
      ),
      Settlement(
        id: "119",
        y: 40.3829296992892,
        name: "Suraxanı",
        nameRu: "Сураханы",
        nameEn: "Surakhani",
        type: "8",
        x: 49.9794673919678,
        routeName: "surakhani",
      ),
      Settlement(
        id: "122",
        y: 40.3169904084288,
        name: "Pirallahı",
        nameRu: "Пираллахи",
        nameEn: "Pirallahi",
        type: "8",
        x: 50.5906891822815,
        routeName: "pirallahi",
      ),
      Settlement(
        id: "118",
        y: 40.4428890716172,
        name: "Sabunçu",
        nameRu: "Сабунчи",
        nameEn: "Sabunchu",
        type: "8",
        x: 49.9431449174881,
        routeName: "sabunchu",
      ),
    ],
  );
}

Filters initFilters() {
  return Filters(
    city: getCapitalCity(),
    dealType: DealType.sale,
    estateType: EstateType.apartment,
  );
}

Pagination initPagination() {
  return Pagination(
    current: 0,
  );
}
