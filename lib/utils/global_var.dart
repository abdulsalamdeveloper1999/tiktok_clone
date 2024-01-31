import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tiktok_clone/controllers/authentication_controllers/auth_controller.dart';

//Firebase variables
final firebaseAuth = FirebaseAuth.instance;
final firebaseFirestore = FirebaseFirestore.instance;
final firebaseStorage = FirebaseStorage.instance;

//Getx variables
var authController = AuthController.instance;
