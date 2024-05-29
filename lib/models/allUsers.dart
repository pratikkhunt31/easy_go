import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Users {
  String? id;
  String? name;
  String? phone;
  String? email;

  Users({this.id, this.name, this.email, this.phone});

  Users.fromSnapshot(DataSnapshot dataSnapshot){
    id = dataSnapshot.key;
    var data = dataSnapshot.value as Map<dynamic, dynamic>;
    name = data["name"];
    email = data["email"];
    phone = data["phone"];
  }
}