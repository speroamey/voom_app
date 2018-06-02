import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:voom_app/src/core.dart';
import 'package:voom_app/src/enums.dart';
import 'package:xml/xml/nodes/element.dart';

class Person {
  String name;
  String phone;
  double lat;
  double long;
  String note;
  String distance;
  bool available = true;

  Person(String n, String ph, double l, double lg,
      [String note = "", String distance]) {
    this.name = n;
    this.phone = ph;
    this.lat = l;
    this.long = lg;
    this.note = note;
    this.distance = distance;
  }

  Person.map(dynamic obj) {
    this.name = obj["username"];
    this.phone = obj["telephone"];
    this.long = obj["longitude"];
    this.lat = obj["latitude"];
    this.note = obj["note"];
    this.distance = obj["distance"];
  }

  String get username => name;
  String get telephone => phone;
  double get longitude => long;
  double get latitude => lat;
  String get stars => note;
  String get distances => distance;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = name;
    map["password"] = phone;
    map["longitude"] = long;
    map["latitude"] = lat;
    map["note"] = note;
    map["distance"] = distance;

    return map;
  }
}

enum SentStatus { NO_DELIVERED, SENT, RECEIVED, SEEN, NONE }
enum UserTitle { User, Driver }

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

class UserCommand {
  String destination;
  String depart;
  int time;
  Person client;
  UserCommand(this.depart, this.destination, this.time, this.client);
}

class CoPublish {
  String destination;
  String depart;
  int date;
  String time;
  int price;
  int places;
  String engin;
  CoPublish() {
    this.destination = '';
    this.depart = '';
    this.date = new DateTime.now().millisecondsSinceEpoch;
    TimeOfDay timeOfDay = new TimeOfDay.now();
    this.time = "${timeOfDay.hour}h:${timeOfDay.minute}";
    this.price = 0;
    this.places = 1;
  }
  XmlElement buildStanza() {
    StanzaBuilder builder = Strophe.Builder("covoiturage", attrs: {
      'destination': destination,
      'depart': depart,
      'date': date,
      'time': time,
      'price': price,
      'places': places,
      'engin': engin
    });
    return builder.tree();
  }
}

class TypeEngin {
  String name;
  String imageUrl;
  TypeEngin(this.name, this.imageUrl);
  @override
  String toString() {
    return this.name;
  }
}

class AppPreferences {
  static String phoneNumber = 'phoneNumber';
  static String note = 'note';
  static String title = 'title';
}

class Settings {
  int distanceToShow = 2; // en Km
  int noteSetting = 5;
  String taxation = '150';
  bool orderDriverByName = false;
  bool covoiturageNotif = false;
  bool commandNotif = true;
}

double toRad(num n) {
  if (n == null) return 0.0;
  return n * Math.pi / 180;
}

num distVincenty(num lat1, num lon1, num lat2, num lon2) {
  if (lat1 == null || lat2 == null || lon1 == null || lon2 == null) return 0.0;
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
      return 0; // co-incident points
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
    return double.nan; // formula failed to converge
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
  return s; // round to 1mm precision
}

enum InboxActions { NOTER, DELETE_CHAT, BLOCK }
