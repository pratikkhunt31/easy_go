import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/allUsers.dart';


FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
User? currentUser = auth.currentUser;
Users? currentUserInfo;

// String mapKey = "AIzaSyA3t09H7HnhmRdaFlbnO40OPs6ZY3rRspw";
String mapKey = "AIzaSyCKaa37fIg-vZpj89mXMR1VqGpqYW5yago";