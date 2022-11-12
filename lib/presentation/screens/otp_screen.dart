import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_app/core/utils/color_manager.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../business_logic/phone_auth/phone_auth_cubit.dart';
import '../../core/utils/text_manager.dart';

class OtpScreen extends StatelessWidget {
   OtpScreen({Key? key,required this.phoneNumber}) : super(key: key);


  final phoneNumber;
  String? otpCode;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: ColorManager.white,
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32,vertical: 88),
              child: Column(
                children: [
                  _buildHeaderText(),
                  const SizedBox(height: 88),
                  _buildPinCodeFields(context),
                  const SizedBox(height: 60),
                  _buildVerifyButton(context),
                  _buildPhoneVerificationBloc(),
                ],
              ),
            ),
          ),
        )
    );
  }

  Widget _buildPhoneVerificationBloc()
  {
    return BlocListener<PhoneAuthCubit,PhoneAuthStates>(
      listenWhen: (previous,current){
        return previous != current;
      },
      listener: (context,state){
        if(state is PhoneAuthLoadingState){
          showProgressIndicator(context);
        }
        if(state is PhoneAuthVerifiedState){
          Navigator.pushReplacementNamed(context, TextManager.mapScreen);
        }
        if(state is PhoneAuthErrorState){
          String errorMessage = (state).errorMessage;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: ColorManager.black,duration: const Duration(days: 4),
            ),
          );
        }
      },
      child: Container(),
    );
  }




  Widget _buildVerifyButton(BuildContext context)
  {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          showProgressIndicator(context);
          _login(context);
        },
        style:ElevatedButton.styleFrom(
            minimumSize: const Size(110, 50),
            backgroundColor: ColorManager.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            )
        ),
        child: const Text(
          TextManager.verifyBtn,
          style: TextStyle(color: ColorManager.white,fontSize: 16),
        ),
      ),
    );
  }

  void _login(context)
  {
    BlocProvider.of<PhoneAuthCubit>(context).submitOtp(otpCode!);
  }

   void showProgressIndicator(BuildContext context)
   {
     AlertDialog alertDialog = const AlertDialog(
       backgroundColor: Colors.transparent,
       elevation: 0.0,
       content: Center(
         child: CircularProgressIndicator(
           valueColor: AlwaysStoppedAnimation<Color>(ColorManager.black),
         ),
       ),
     );
     showDialog(
         context: context,
         barrierColor: ColorManager.white.withOpacity(0),
         barrierDismissible: false,
         builder: (context){
           return alertDialog;
         });

   }



   Widget _buildPinCodeFields(context)
  {
    return Container(
      child: PinCodeTextField(
        appContext: context,
        autoFocus: true,
        keyboardType: TextInputType.number,
        cursorColor: ColorManager.black,
        length: 6,
        obscureText: false,
        animationType: AnimationType.scale,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 40,
          borderWidth: 1,
          activeFillColor: ColorManager.lightBlue,
          inactiveFillColor: ColorManager.white,
          activeColor: ColorManager.blue,
          inactiveColor: ColorManager.blue,
          selectedColor: ColorManager.blue,
          selectedFillColor: ColorManager.white,
        ),
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: ColorManager.white,
        enableActiveFill: true,
        onCompleted: (code) {
          otpCode = code;
          print("Completed");
        },
        onChanged: (value) {
          print(value);
          },
      ),
    );
  }



  Widget _buildHeaderText()
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          const Text(
          TextManager.otpHeaderText,
          style: TextStyle(
              color: ColorManager.black,
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: RichText(
              text:  TextSpan(
                  text: TextManager.enter6NumToVerify,
                  style: const TextStyle(color: ColorManager.black,fontSize: 18,height: 1.4),
                  children: <TextSpan>[
                    TextSpan(
                      text: '$phoneNumber',
                      style: const TextStyle(color: ColorManager.blue,fontSize: 18,),
                    )
                  ],
              ),
          ),
        ),
      ],
    );
  }

}
