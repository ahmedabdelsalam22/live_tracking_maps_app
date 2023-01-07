class TextManager {
  // screens
  static const String loginScreen = '/loginScreen';
  static const String otpScreen = '/otpScreen';
  static const String mapScreen = '/mapScreen';

  //google map api key

  static const String apiKey = 'AIzaSyClHjS1_2CHiZhm5HO61HYGVMM5xR4gBrs';

  /*
  https://maps.googleapis.com/maps/api/place/autocomplete/output?parameters
   */

  // texts
  static const String loginHeaderText = "what's your number?";
  static const String loginBodyText =
      'Please enter your phone number to verify your account';
  static const String pleaseEnterPhoneNum = 'please enter your phone number';
  static const String tooShortPhoneNum = 'phone number must be 11 num';
  static const String otpHeaderText = "Verify your phone number";
  static const String enter6NumToVerify =
      "Enter your 6 digit code numbers sent to you at ";

  static const String nextBtn = 'Next';
  static const String verifyBtn = 'Verify';
}
