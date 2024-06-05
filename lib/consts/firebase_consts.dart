import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/allUsers.dart';


FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
User? currentUser = auth.currentUser;
Users? currentUserInfo;

String mapKey = "AIzaSyAqipTSsRuhBpesZFWDHYY2muffFj0ziU0";
// String mapKey = "AIzaSyCKaa37fIg-vZpj89mXMR1VqGpqYW5yago";