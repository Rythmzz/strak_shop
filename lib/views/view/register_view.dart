import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:strak_shop_project/services/service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = AuthService();

  double _currentProgress = 0.0;
  Text _textProgress = const Text("");

  bool _isLoading = false;
  bool _errorText = false;

  bool _checkFullNameError = false;
  bool _checkAccountError = false;
  bool _checkPasswordError = false;
  bool _checkPasswordAgainError = false;

  final TextEditingController _textEditingControllerFullName =
      TextEditingController();
  final TextEditingController _textEditingControllerAccount =
      TextEditingController();
  final TextEditingController _textEditingControllerPassword =
      TextEditingController();
  final TextEditingController _textEditingControllerPasswordAgain =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _textEditingControllerFullName.dispose();
    _textEditingControllerAccount.dispose();
    _textEditingControllerPassword.dispose();
    _textEditingControllerPasswordAgain.dispose();
    super.dispose();
  }

  Text setTextProgress(String text, Color color) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 10, fontStyle: FontStyle.italic),
    );
  }

  String? validateFullName(String? input) {
    if (input!.isEmpty) {
      setState(() {
        _checkFullNameError = true;
      });
      return ("Please enter your name!");
    }

    setState(() {
      _checkFullNameError = false;
    });
    return null;
  }

  String? validateAccount(String? input) {
    if (input!.isEmpty) {
      setState(() {
        _checkAccountError = true;
      });
      return ("Please enter your username or email");
    }
    setState(() {
      _checkAccountError = false;
    });
    return null;
  }

  String? validatePassword(String? input) {
    if (input!.isEmpty) {
      setState(() {
        _checkPasswordError = true;
      });
      return ("Please enter your password.");
    } else if (input.length <= 6) {
      setState(() {
        _checkPasswordError = true;
      });
      return "Password should be at least 6 characters";
    }
    setState(() {
      _checkPasswordError = false;
    });
    return null;
  }

  String? validatePasswordAgain(String? input) {
    if (input!.isEmpty) {
      setState(() {
        _checkPasswordAgainError = true;
      });
      return ("Please enter the correct password!");
    } else if (_textEditingControllerPassword.text != input) {
      setState(() {
        _checkPasswordAgainError = true;
      });
      return ("Password incorrect!");
    }
    setState(() {
      _checkPasswordAgainError = false;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(false);
        return false;
      },
      child: Scaffold(
        body: SafeArea(
            child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  children: [titleTheme(), inputForm(), loginAccount()],
                ),
              ),
            ),
            Visibility(
              visible: _isLoading ? true : false,
              child: Scaffold(
                backgroundColor: Colors.black26,
                body: Center(
                    child: SpinKitChasingDots(
                  color: Theme.of(context).primaryColor,
                  size: 50,
                )),
              ),
            ),
          ],
        )),
      ),
    );
  }

  Column titleTheme() {
    return Column(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Image.asset("assets/images_app/logo_strak_red.png"),
        ),
        const SizedBox(
          height: 16,
        ),
        const Text(
          "Let's Get Started",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(
          height: 8,
        ),
        const Text(
          "Create an new account",
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }

  Widget inputForm() {
    return Form(
        key: _formKey,
        onChanged: _updateFormProgress,
        child: Column(
          children: [
            TextFormField(
              controller: _textEditingControllerFullName,
              validator: validateFullName,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 3)),
                focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 3)),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: StrakColor.colorTheme6, width: 3)),
                border:
                    const OutlineInputBorder(borderSide: BorderSide(width: 3)),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 3,
                      color: _checkFullNameError
                          ? Colors.red
                          : StrakColor.colorTheme6),
                ),
                labelText: "Full Name",
                prefixIcon: Icon(
                  Icons.account_circle_outlined,
                  size: 24,
                  color: _checkFullNameError ? Colors.red : null,
                ),
                hintText: "Full Name",
              ),
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: _textEditingControllerAccount,
              validator: validateAccount,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 3)),
                focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 3)),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: StrakColor.colorTheme6, width: 3)),
                border:
                    const OutlineInputBorder(borderSide: BorderSide(width: 3)),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 3,
                      color: _checkAccountError
                          ? Colors.red
                          : StrakColor.colorTheme6),
                ),
                labelText: "Your Email",
                prefixIcon: Icon(
                  Icons.mail_outline,
                  size: 24,
                  color: _checkAccountError ? Colors.red : null,
                ),
                hintText: "Your Email",
              ),
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: _textEditingControllerPassword,
              obscureText: true,
              validator: validatePassword,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 3)),
                focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 3)),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: StrakColor.colorTheme6, width: 3)),
                border:
                    const OutlineInputBorder(borderSide: BorderSide(width: 3)),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 3,
                      color: _checkPasswordError
                          ? Colors.red
                          : StrakColor.colorTheme6),
                ),
                labelText: "Password",
                prefixIcon: Icon(
                  Icons.lock_outline,
                  size: 24,
                  color: _checkPasswordError ? Colors.red : null,
                ),
                hintText: "Password",
              ),
              style: const TextStyle(fontSize: 14),
            ),
            Container(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _textProgress,
                  AnimatedProgressIndicator(value: _currentProgress),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: _textEditingControllerPasswordAgain,
              obscureText: true,
              validator: validatePasswordAgain,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 3)),
                focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 3)),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: StrakColor.colorTheme6, width: 3)),
                border:
                    const OutlineInputBorder(borderSide: BorderSide(width: 3)),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 3,
                      color: _checkPasswordAgainError
                          ? Colors.red
                          : StrakColor.colorTheme6),
                ),
                labelText: "Password Again",
                prefixIcon: Icon(
                  Icons.lock_outline,
                  size: 24,
                  color: _checkPasswordAgainError ? Colors.red : null,
                ),
                hintText: "Password Again",
              ),
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(
              height: 8,
            ),
            Visibility(
                visible: _errorText ? true : false,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "The email address is already in use by another account!",
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                )),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });
                        dynamic result = await _auth.registerAccount(
                            _textEditingControllerFullName.text,
                            _textEditingControllerAccount.text,
                            _textEditingControllerPassword.text);
                        if (result == null) {
                          setState(() {
                            _errorText = true;
                            _isLoading = false;
                          });
                        } else {
                          _isLoading = false;
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Register Success!")));
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(StrakColor.colorTheme7)),
                    child: const Text("Sign In"))),
            const SizedBox(
              height: 16,
            ),
          ],
        ));
  }

  Column loginAccount() {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          child: Text(
            "Forgot Password?",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                fontSize: 12),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Have a account?",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(
                "Sign In",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        )
      ],
    );
  }

  void _updateFormProgress() {
    var progress = 0.0;
    // ignore: prefer_is_empty
    if (_textEditingControllerPassword.text.length > 0 &&
        _textEditingControllerPassword.text.length <= 4) {
      progress = 0.2;
      _textProgress = setTextProgress("Super Low", StrakColor.colorTheme5);
    } else {
      if (_textEditingControllerPassword.text.length > 4 &&
          _textEditingControllerPassword.text.length <= 7) {
        progress = 0.4;
        _textProgress = setTextProgress("Low", Colors.red);
      } else if (_textEditingControllerPassword.text.length > 7 &&
          _textEditingControllerPassword.text.length <= 10) {
        progress = 0.6;
        _textProgress = setTextProgress("Medium", Colors.deepOrange);
      } else if (_textEditingControllerPassword.text.length > 10 &&
          _textEditingControllerPassword.text.length <= 12) {
        progress = 0.8;
        _textProgress = setTextProgress("Good", Colors.lightGreen);
      } else if (_textEditingControllerPassword.text.length > 12) {
        _textProgress = setTextProgress("Very Good", Colors.green);
        progress = 0.98;
      }
    }
    setState(() {
      _currentProgress = progress;
    });
  }
}

// ignore: must_be_immutable
class AnimatedProgressIndicator extends StatefulWidget {
  double value;

  AnimatedProgressIndicator({super.key, required this.value});

  @override
  State<AnimatedProgressIndicator> createState() =>
      _AnimatedProgressIndicatorState();
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _controllerCurve;
  late final Animation<Color?> _controllerColor;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    TweenSequence<Color?> tweenSequence = TweenSequence([
      TweenSequenceItem(
          tween: ColorTween(begin: Colors.white, end: StrakColor.colorTheme5),
          weight: 1),
      TweenSequenceItem(
          tween:
              ColorTween(begin: StrakColor.colorTheme5, end: Colors.deepOrange),
          weight: 1),
      TweenSequenceItem(
          tween: ColorTween(begin: Colors.deepOrange, end: Colors.orangeAccent),
          weight: 1),
      TweenSequenceItem(
          tween: ColorTween(begin: Colors.orangeAccent, end: Colors.lightGreen),
          weight: 1),
      TweenSequenceItem(
          tween: ColorTween(begin: Colors.lightGreen, end: Colors.green),
          weight: 1),
    ]);
    _controllerColor = _controller.drive(tweenSequence);
    _controllerCurve = _controller.drive(CurveTween(curve: Curves.easeIn));
    super.initState();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return LinearProgressIndicator(
            backgroundColor: _controllerColor.value?.withOpacity(0.5),
            valueColor: _controllerColor,
            value: _controllerCurve.value,
          );
        });
  }
}
