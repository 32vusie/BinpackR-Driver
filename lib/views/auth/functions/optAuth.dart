import 'package:firebase_auth/firebase_auth.dart';

class OTPAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> sendOTP(String phoneNumber) async {
  String? verificationId; // Declare a variable to store the verification ID

  await _auth.verifyPhoneNumber(
    phoneNumber: '+27$phoneNumber',
    verificationCompleted: (PhoneAuthCredential credential) {},
    verificationFailed: (FirebaseAuthException e) {
      return;
    },
    codeSent: (String verId, int? resendToken) {
      verificationId = verId; // Assign the verification ID to the variable
    },
    codeAutoRetrievalTimeout: (String verId) {},
  );

  return verificationId; // Return the verification ID
}




  Future<bool> verifyOTP(String verificationId, String otp) async {
    try {
      await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: otp,
        ),
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
