import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_app/business_logic/phone_auth/phone_auth_cubit.dart';
import 'package:flutter_maps_app/core/utils/color_manager.dart';
import 'package:flutter_maps_app/core/utils/text_manager.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  late String phoneNumber;
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.white,
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 88, horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderText(),
                  const SizedBox(height: 110),
                  _buildPhoneFormField(),
                  const SizedBox(height: 70,),
                  _buildNextButton(context),
                  _buildPhoneNumberSubmittedBloc(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneNumberSubmittedBloc()
  {
    return BlocListener<PhoneAuthCubit,PhoneAuthStates>(
      listenWhen: (previous,current){
        return previous != current;
      },
      listener: (context,state){
        if(state is PhoneAuthLoadingState){
           showProgressIndicator(context);
        }
        if(state is PhoneAuthSubmitState){
          Navigator.pop(context);
          Navigator.pushNamed(context, TextManager.otpScreen,arguments: phoneNumber);
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


  void showProgressIndicator(context)
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


  Widget _buildNextButton(context)
  {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          showProgressIndicator(context);

          _register(context);
        },
        style:ElevatedButton.styleFrom(
          minimumSize: const Size(110, 50),
          backgroundColor: ColorManager.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          )
        ),
        child: const Text(
          TextManager.nextBtn,
          style: TextStyle(color: ColorManager.white,fontSize: 16),
        ),
      ),
    );
  }

  Future<void> _register(context)
  async {
    if(!formKey.currentState!.validate()){
      Navigator.pop(context);
    }else{
      formKey.currentState!.save();
      BlocProvider.of<PhoneAuthCubit>(context).submitPhoneNumber(phoneNumber);
    }
  }

  Widget _buildPhoneFormField()
  {
    return Row(
      children: [
        //egypt flag and +20 code
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: ColorManager.lightGrey,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(6)),
            ),
            child: Text(
              '${generateCountryFlag()} +20 ',
              style: const TextStyle(
                fontSize: 18,
                letterSpacing: 2.0,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        // phone form field
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(
                color: ColorManager.blue,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(6)),
            ),
            child: TextFormField(
              keyboardType: TextInputType.phone,
              autofocus: true,
              style: const TextStyle(
                fontSize: 18,
                letterSpacing: 2.0,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              cursorColor: ColorManager.black,
              validator: (value) {
                if (value!.isEmpty) {
                  return TextManager.pleaseEnterPhoneNum;
                } else if (value.length < 11) {
                  return TextManager.tooShortPhoneNum;
                }
                return null;
              },
              onSaved: (value) {
                phoneNumber = value!;
              },
            ),
          ),
        ),
      ],
    );
  }

  String generateCountryFlag()
  {
    String countryCode = 'eg';
    String flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
    return flag;
  }

  Widget _buildHeaderText()
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          TextManager.loginHeaderText,
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
          child: const Text(
            TextManager.loginBodyText,
            style: TextStyle(
              color: ColorManager.black,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
