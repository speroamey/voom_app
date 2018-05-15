import 'dart:math' as Math;

class Person {
  String name;
  String phone;
  double lat;
  double long;
  String note;
  String distance;
  bool writing;

  Person(String n, String ph, double l, double lg,
      [String note = '', String distance]) {
    this.name = n;
    this.phone = ph;
    this.lat = l;
    this.long = lg;
    this.note = note;
    this.distance = distance;
  }
}

enum SentStatus { NO_DELIVERED, SENT, RECEIVED, SEEN, NONE }

class AppMessage {
  String content = '';
  int id = 0;
  int date = 0;
  String name = '';
  String from = '';
  String blockquote = '';
  bool unread = false;
  SentStatus status;
  String to = '';
  String url = '';
  AppMessage();
  AppMessage.fromMap(Map<String, dynamic> map) {
    content = map['content'];
    id = map['id'];
    date = map['date'];
    name = map['name'];
    from = map['from'];
    to = map['to'];
    blockquote = map['blockquote'];
    status = map['status'] ?? SentStatus.NO_DELIVERED;
  }
}

class AppPreferences {
  static String phoneNumber = 'phoneNumber';
  static String password = 'password';
}

double toRad(num n) {
  return n * Math.pi / 180;
}

String distVincenty(num lat1, num lon1, num lat2, num lon2) {
  num a = 6378137,
      b = 6356752.3142,
      f = 1 / 298.257223563, // WGS-84 ellipsoid params
      L = toRad(lon2 - lon1),
      u1 = Math.atan((1 - f) * Math.tan(toRad(lat1))),
      u2 = Math.atan((1 - f) * Math.tan(toRad(lat2))),
      sinU1 = Math.sin(u1),
      cosU1 = Math.cos(u1),
      sinU2 = Math.sin(u2),
      cosU2 = Math.cos(u2),
      lambda = L,
      lambdaP,
      iterLimit = 100;
  var cosSigma, sigma, cos2SigmaM, cosSqAlpha, C, sinSigma;
  do {
    var sinLambda = Math.sin(lambda), cosLambda = Math.cos(lambda);
    sinSigma = Math.sqrt((cosU2 * sinLambda) * (cosU2 * sinLambda) +
        (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda) *
            (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda));
    if (0 == sinSigma) {
      return '0'; // co-incident points
    }

    num sinAlpha = cosU1 * cosU2 * sinLambda / sinSigma;
    cosSigma = sinU1 * sinU2 + cosU1 * cosU2 * cosLambda;
    sigma = Math.atan2(sinSigma, cosSigma);
    cosSqAlpha = 1 - sinAlpha * sinAlpha;
    cos2SigmaM = cosSigma - 2 * sinU1 * sinU2 / cosSqAlpha;
    C = f / 16 * cosSqAlpha * (4 + f * (4 - 3 * cosSqAlpha));
    if (cos2SigmaM.isNaN) {
      cos2SigmaM = 0.0; // equatorial line: cosSqAlpha = 0 (§6)
    }
    lambdaP = lambda;
    lambda = L +
        (1 - C) *
            f *
            sinAlpha *
            (sigma +
                C *
                    sinSigma *
                    (cos2SigmaM +
                        C * cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM)));
  } while ((lambda - lambdaP).abs() > 1e-12 && --iterLimit > 0);

  if (iterLimit == null || iterLimit == 0) {
    return double.nan.toString(); // formula failed to converge
  }

  var uSq = cosSqAlpha * (a * a - b * b) / (b * b),
      A = 1 + uSq / 16384 * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq))),
      B = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq))),
      deltaSigma = B *
          sinSigma *
          (cos2SigmaM +
              B /
                  4 *
                  (cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM) -
                      B /
                          6 *
                          cos2SigmaM *
                          (-3 + 4 * sinSigma * sinSigma) *
                          (-3 + 4 * cos2SigmaM * cos2SigmaM))),
      s = b * A * (sigma - deltaSigma);
  return s.toStringAsFixed(3); // round to 1mm precision
}

enum InboxActions { NOTER, DELETE_CHAT, BLOCK }
