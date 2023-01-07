part of 'phone_auth_cubit.dart';

abstract class PhoneAuthStates {}

class PhoneAuthInitial extends PhoneAuthStates {}

class PhoneAuthLoadingState extends PhoneAuthStates {}

class PhoneAuthSuccessState extends PhoneAuthStates {}

class PhoneAuthErrorState extends PhoneAuthStates {
  final String errorMessage;

  PhoneAuthErrorState(this.errorMessage);
}

class PhoneAuthSubmitState extends PhoneAuthStates {}

class PhoneAuthVerifiedState extends PhoneAuthStates {}
