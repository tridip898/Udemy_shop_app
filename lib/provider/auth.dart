import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/model/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  bool get isAuth{
    return _token != null;
  }
  String? get token{
    if(_expiryDate != null && _expiryDate!.isAfter(DateTime.now()) && _token != null){
      return _token;
    }
    return null;
  }
  Future<void> userAuthenticate(String email,String password, String urlSegment) async{
    try{
      final url =
      Uri.parse('https://identitytoolkit.googleapis.com/v1/$urlSegment?key=AIzaSyCwZeIbziZjC-d-5Pj5W50r9ezJf10NfSw');
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData=json.decode(response.body);
      if(responseData['error'] != null){
        throw HttpException(responseData['error']['message']);
      }
      _token=responseData['idToken'];
      _userId=responseData['localId'];
      _expiryDate=DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
    }catch(error){
      throw error;
    }
    
  }

  Future<void> signup(String email, String password) async {
    return userAuthenticate(email, password, 'accounts:signUp');
  }

  Future<void> signin(String email, String password) async {
    return userAuthenticate(email, password, 'accounts:signInWithPassword');
  }

  void logOut(){
    _token=null;
    _expiryDate=null;
    _userId=null;
    notifyListeners();
  }

}
