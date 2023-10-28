import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'widgets/responsive.dart';
import 'widgets/score_date_picker.dart';

double wXD(
  double size,
  BuildContext context, {
  double? ws,
  bool mediaWeb = false,
}) {
  if (Responsive.isDesktop(context)) {
    double _size = ws ?? size;
    if (mediaWeb) {
      return MediaQuery.of(context).size.width / 1920 * _size;
    } else {
      return _size;
    }
  }
  return MediaQuery.of(context).size.width / 375 * size;
}

double hXD(double size, BuildContext context) {
  return MediaQuery.of(context).size.height / 667 * size;
}

double maxHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double maxWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double viewPaddingTop(context) => MediaQuery.of(context).viewPadding.top;

Brightness brightness =
    MediaQueryData.fromWindow(WidgetsBinding.instance.window)
        .platformBrightness;

late ColorScheme colors;

ColorScheme getColors(context) => Theme.of(context).colorScheme;

TextTheme getStyles(context) => Theme.of(context).textTheme;

TextStyle textFamily(
  context, {
  double? fontSize,
  FontWeight? fontWeight,
  double? height,
  Color? color,
  FontStyle? fontStyle,
}) {
  return GoogleFonts.montserrat(
    fontSize: fontSize ?? 13,
    color: color ?? getColors(context).onBackground,
    fontWeight: fontWeight ?? FontWeight.w500,
    height: height ?? null,
    fontStyle: fontStyle,
  );
}

SystemUiOverlayStyle getOverlayStyleFromColor(Color color) {
  Brightness brightness = ThemeData.estimateBrightnessForColor(color);
  return brightness == Brightness.dark
      ? SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: colors.surface,
          systemNavigationBarIconBrightness: Brightness.light,
        )
      : SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: colors.surface,
          systemNavigationBarIconBrightness: Brightness.dark);
}

String formatedCurrency(var value) {
  var newValue = new NumberFormat("#,##0.00", "pt_BR");
  if (value != null) {
    return newValue.format(value);
  } else {
    return '0,00';
  }
}

// Future<DateTime?> selectDate(BuildContext context,
//     {DateTime? initialDate}) async {
//   final DateTime? picked = await showDatePicker(
//     initialEntryMode: DatePickerEntryMode.calendarOnly,
//     initialDatePickerMode: DatePickerMode.year,
//     firstDate: DateTime(1900),
//     lastDate: DateTime(2025),
//     context: context,
//     initialDate: initialDate ?? DateTime.now(),
//     builder: (BuildContext context, Widget? child) {
//       return Theme(
//         data: ThemeData.light().copyWith(
//           colors.primaryColor: const Color(0xFF41c3b3),
//           // ignore: deprecated_member_use
//           accentColor: const Color(0xFF21bcce),
//           colorScheme: ColorScheme.light(colors.primary: const Color(0xFF41c3b3)),
//           buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.colors.primary),
//         ),
//         child: child!,
//       );
//     },
//   );
//   return picked;
// }

OverlayEntry? dateOverlay;

Future<void> pickDate(context,
    {required void Function(DateTime?) onConfirm,
    DateTime? initialDate}) async {
  dateOverlay = OverlayEntry(
    maintainState: true,
    builder: (context) => ScoreDatePicker(
      initialDate: initialDate,
      onConfirm: (date) {
        onConfirm(date);
        dateOverlay!.remove();
        dateOverlay = null;
      },
      onCancel: () {
        dateOverlay!.remove();
        dateOverlay = null;
      },
    ),
  );
  Overlay.of(context)!.insert(dateOverlay!);
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

Future<File?> pickImage() async {
  bool permission =
      kIsWeb ? true : await Permission.storage.request().isGranted;
  if (permission) {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return null;
    } else {
      File _file = File(pickedFile.path);
      return _file;
    }
  } else {
    return null;
  }
}

Future<List<File>?> pickMultiImage() async {
  bool permission =
      kIsWeb ? true : await Permission.storage.request().isGranted;
  if (permission) {
    final picker = ImagePicker();
    final pickedListFile = await picker.pickMultiImage();
    if (pickedListFile == null) {
      return null;
    } else {
      List<File> _listFile = [];
      pickedListFile.forEach((xFile) {
        _listFile.add(File(xFile.path));
      });
      return _listFile;
    }
  } else {
    return null;
  }
}

Future<File?> pickCameraImage() async {
  bool permission =
      kIsWeb ? true : await Permission.storage.request().isGranted;
  if (permission) {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
  }
  return null;
}

Future<List?> pickMultiImageWithName() async {
  bool permission =
      kIsWeb ? true : await Permission.storage.request().isGranted;
  if (permission) {
    final picker = ImagePicker();
    final pickedListFile = await picker.pickMultiImage();
    if (pickedListFile == null) {
      return null;
    } else {
      List<File> _listFile = [];
      List<Uint8List> _listUint = [];
      List<String> _listFileName = [];

      for (XFile xFile in pickedListFile) {
        _listFile.add(File(xFile.path));
        _listUint.add(await xFile.readAsBytes());
        _listFileName.add(xFile.name);
      }

      return [
        _listFile,
        _listFileName,
        _listUint,
      ];
    }
  } else {
    return null;
  }
}

Future<List?> pickCameraImageWithName() async {
  bool permission =
      kIsWeb ? true : await Permission.storage.request().isGranted;
  if (permission) {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
    if (pickedFile != null) {
      return [
        File(pickedFile.path),
        [pickedFile.name],
      ];
    }
  }
  return null;
}

// Future<List<File>> pickFilesWeb({FileType type = FileType.any}) async {
//   var picked =
//       await FilePicker.platform.pickFiles(allowMultiple: true, type: type);

//   List<File> files = [];

//   if (picked != null) {
//     print(picked.files.first.name);

//     for (int i = 0; i < picked.files.length; i++) {
//       files.add(File.fromRawPath(picked.files[i].bytes!));
//     }
//   }

//   return files;
// }

showToast(String msg, {bool error = false}) => Fluttertoast.showToast(
      msg: msg,
      webBgColor: error ? "#ff0000" : "#4c4c4c",
      textColor: Colors.white,
      timeInSecForIosWeb: 3,
    );

final nothingMask =
    MaskTextInputFormatter(mask: '', filter: {"#": RegExp(r'[0-9]')});

final cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});

// final rgMask =
//     MaskTextInputFormatter(mask: '###.###.##', filter: {"#": RegExp(r'[0-9]')});

final cnpjMask = MaskTextInputFormatter(
    mask: '##.###.###/####-##', filter: {"#": RegExp(r'[0-9]')});

final openingHoursMask = MaskTextInputFormatter(
    mask: '##:## às ##:##', filter: {"#": RegExp(r'[0-9]')});

final cepMask =
    MaskTextInputFormatter(mask: '##.###-###', filter: {"#": RegExp(r'[0-9]')});

// final agencyMask =
//     MaskTextInputFormatter(mask: '####', filter: {"#": RegExp(r'[0-9]')});

final accountMask = MaskTextInputFormatter(
    mask: '#########-##', filter: {"#": RegExp(r'[0-9]')});

final digitMask =
    MaskTextInputFormatter(mask: '#', filter: {"#": RegExp(r'[0-9]')});

final operationMask =
    MaskTextInputFormatter(mask: '###', filter: {"#": RegExp(r'[0-9]')});

final phoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

final fullNumberMask = MaskTextInputFormatter(
    mask: '+## (##) #####-####', filter: {"#": RegExp(r'[0-9]')});

String getPortugueseStatus(String status) {
  switch (status) {
    case "REQUESTED":
      return "Aguardando confirmação";
    case "DELIVERY_REQUESTED":
      return "Aguardando um agente";
    case "DELIVERY_ACCEPTED":
      return "Aguardando agente";
    case "DELIVERY_REQUESTED":
      return "Procurando agente";
    case "DELIVERY_ACCEPTED":
      return "Aguardando agente";
    case "DELIVERY_REFUSED":
      return "Recusado pelo agente";
    case "DELIVERY_CANCELED":
      return "Cancelado pelo agente";
    case "TIMEOUT":
      return "Tempo esgotado";
    case "PROCESSING":
      return "Em preparação";
    case "SENDED":
      return "A caminho";
    case "CANCELED":
      return "Cancelado";
    case "REFUSED":
      return "Recusado";
    case "CONCLUDED":
      return "Entregue";
    default:
      return "Tradução não estabelecida: $status";
  }
}

Future<HttpsCallableResult?> cloudFunction({
  required String function,
  Map<String, dynamic> object = const {},
  void Function(Object e)? error,
}) async {
  // FirebaseFunctions.instance.useFunctionsEmulator("localhost", 5001);
  print('cloudFunction: funtion: $function - object: $object');
  HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(function);
  HttpsCallableResult? result;
  try {
    result = await callable.call(object);
  } catch (e) {
    print("Error on function: $e");
    if (error != null) error(e);
    return null;
  }
  return result;
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  return await Geolocator.getCurrentPosition();
}

Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(
  BuildContext context,
  String assetName, {
  double height = 50,
  double width = 40,
}) async {
  String svgString = await DefaultAssetBundle.of(context).loadString(assetName);
  //Draws string representation of svg to DrawableRoot
  DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, "");
  ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));
  ui.Image image = await picture.toImage(width.truncate(), height.truncate());
  ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
