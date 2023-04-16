import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/model/http_exception.dart';
import 'package:shop_app/provider/auth.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin:
                          EdgeInsets.only(bottom: 20.0, right: 10, left: 15),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 90.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _slideAnimation = Tween<Offset>(
            begin: Offset(0, -1.5), end: Offset(0, 0))
        .animate(
            CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    _slideAnimation.addListener(() => setState(() {}));
    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("An error occured!"),
            content: Text(message),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Okay'))
            ],
          );
        });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false)
            .signin(_authData['email']!, _authData['password']!);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData['email']!, _authData['password']!);
      }
      // Navigator.of(context).pushNamed('/product-overview');
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed!';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This mail is already used';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Email with user not found!';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Please enter a valid password';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      var errorMessage = 'Could not authenticate you. Please try again later';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8.0,
        child: AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, ch) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  height: _authMode == AuthMode.Signup ? 320 : 260,
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.Signup ? 320 : 260,
                  ),
                  width: deviceSize.width * 0.85,
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(labelText: 'E-Mail'),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return 'Invalid email!';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _authData['email'] = value!;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            controller: _passwordController,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 5) {
                                return 'Password is too short!';
                              }
                            },
                            onSaved: (value) {
                              _authData['password'] = value!;
                            },
                          ),
                          AnimatedContainer(
                            constraints: BoxConstraints(
                                minHeight:
                                    _authMode == AuthMode.Signup ? 60 : 0,
                                maxHeight:
                                    _authMode == AuthMode.Signup ? 60 : 0),
                            curve: Curves.easeIn,
                            duration: Duration(milliseconds: 300),
                            child: FadeTransition(
                              opacity: _opacityAnimation,
                              child: SlideTransition(
                                position: _slideAnimation,
                                child: TextFormField(
                                  enabled: _authMode == AuthMode.Signup,
                                  decoration: InputDecoration(
                                      labelText: 'Confirm Password'),
                                  obscureText: true,
                                  validator: _authMode == AuthMode.Signup
                                      ? (value) {
                                          if (value != _passwordController.text) {
                                            return 'Passwords do not match!';
                                          }
                                        }
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          if (_isLoading)
                            CircularProgressIndicator()
                          else
                            ElevatedButton(
                              child: Text(
                                _authMode == AuthMode.Login
                                    ? 'LOGIN'
                                    : 'SIGN UP',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40.0, vertical: 10.0),
                              ),
                            ),
                          ElevatedButton(
                            child: Text(
                              '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                              style: TextStyle(color: Colors.purple),
                            ),
                            onPressed: _switchAuthMode,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )));
  }
}