import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthStates> {
  late String verificationId;

  PhoneAuthCubit() : super(PhoneAuthInitial());



  Future<void> submitPhoneNumber(String phoneNumber)async
  {
    emit(PhoneAuthLoadingState());

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+2$phoneNumber',
      timeout: const Duration(seconds: 14),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );

  }


  void verificationCompleted(PhoneAuthCredential credential )async
  {
   print('verificationCompleted');

   await signIn(credential);
  }

  void verificationFailed(FirebaseException error)
  {
    print('verificationFailed');
    emit(PhoneAuthErrorState(error.toString()));
  }

  void codeSent(String verificationId, int? resendToken)
  {
    print('codeSent');
     this.verificationId = verificationId;
     emit(PhoneAuthSubmitState());
  }

  void codeAutoRetrievalTimeout(String verificationId)
  {
    print('codeAutoRetrievalTimeout');
  }

  Future<void> submitOtp(String otpCode)async
  {
     PhoneAuthCredential credential = PhoneAuthProvider.credential(
         verificationId: this.verificationId, smsCode: otpCode,
     );
     await signIn(credential);
  }

  Future<void> signIn(PhoneAuthCredential credential)async
  {
    try{
       await FirebaseAuth.instance.signInWithCredential(credential);
       emit(PhoneAuthVerifiedState());
    }catch(onError){
       emit(PhoneAuthErrorState(onError.toString()));
    }
  }

  Future<void> logOut()async
  {
    await FirebaseAuth.instance.signOut();
  }

  User getLoggedInUser ()
  {
    User firebaseUser = FirebaseAuth.instance.currentUser!;
    return firebaseUser;
  }


}
