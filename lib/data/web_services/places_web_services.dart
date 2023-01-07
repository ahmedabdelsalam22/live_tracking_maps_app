import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../core/utils/text_manager.dart';

class PlacesWebservices {
  late Dio dio;

  PlacesWebservices() {
    BaseOptions options = BaseOptions(
      connectTimeout: 20 * 1000,
      receiveTimeout: 20 * 1000,
      receiveDataWhenStatusError: true,
    );
    dio = Dio(options);
  }

  Future<List<dynamic>> fetchSuggestionsPlaces(
      String place, String sessionToken) async {
    try {
      Response response = await dio.get(
        TextManager.suggestionsBaseUrl,
        queryParameters: {
          'input': place,
          'types': 'address',
          'components': 'country:eg',
          'key': TextManager.googleMapApiKey,
          'sessiontoken': sessionToken
        },
      );
      debugPrint(response.data['predictions']);
      debugPrint(response.statusCode.toString());
      return response.data['predictions'];
    } catch (error) {
      debugPrint(error.toString());
      return [];
    }
  }
}
