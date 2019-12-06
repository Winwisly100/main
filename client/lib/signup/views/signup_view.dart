import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import 'package:com.winwisely99.app/services/services.dart';

enum MeetUpWithOthers { Yes, No }

class SignUpView extends StatelessWidget {
  const SignUpView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebInfoView(
      title: TitleWidget(
        icon: FontAwesomeIcons.users,
        title: 'Sign Up',
      ),
      child: const _SignUpView(),
      index: -1,
    );
  }
}

class _SignUpView extends StatefulWidget {
  const _SignUpView({Key key}) : super(key: key);

  @override
  __SignUpViewState createState() => __SignUpViewState();
}

class __SignUpViewState extends State<_SignUpView> {
  MeetUpWithOthers _character = MeetUpWithOthers.No;
  bool _emailSwitch = false;
  bool _appMessagingSwitch = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/icon/Logo.png',
              width: 200,
              height: 100,
            ),
          ),
          ListTile(
            title: Text("Sign up for you account",
                style: Theme.of(context).textTheme.display1),
          ),
          ListTile(
            title: TextFormField(
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                labelText: "Email Address",
                labelStyle: Theme.of(context).textTheme.body2,
                suffix: Icon(MdiIcons.emailOutline),
              ),
            ),
          ),
          ListTile(
            title: TextFormField(
              cursorColor: Colors.grey,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: Theme.of(context).textTheme.body2,
                suffix: Icon(Icons.lock_outline),
              ),
            ),
          ),
          ListTile(
            title: Text("Meet up with others?"),
          ),
          RadioListTile<MeetUpWithOthers>(
            title: const Text('Yes'),
            value: MeetUpWithOthers.Yes,
            groupValue: _character,
            onChanged: (MeetUpWithOthers value) {
              setState(() {
                _character = value;
              });
            },
          ),
          RadioListTile<MeetUpWithOthers>(
            title: const Text('No'),
            value: MeetUpWithOthers.No,
            groupValue: _character,
            onChanged: (MeetUpWithOthers value) {
              setState(() {
                _character = value;
              });
            },
          ),
          //   ],
          // ),
          ListTile(
            title: Text("Setup notification channel"),
          ),
          //Center(
          //  child:
          SwitchListTile(
            title: const Text('Email'),
            value: _emailSwitch,
            onChanged: (bool value) {
              setState(() {
                _emailSwitch = value;
              });
            },
            secondary: const Icon(Icons.email),
          ),
          // ),
          //Center(
          // child:
          SwitchListTile(
            title: const Text('App Messaging'),
            value: _appMessagingSwitch,
            onChanged: (bool value) {
              setState(() {
                _appMessagingSwitch = value;
              });
            },
            secondary: const Icon(Icons.message),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: RaisedButton(
                    color: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text("Sign Up",
                        style: Theme.of(context).textTheme.body2.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      final AuthUserService _user =
                          Provider.of<AuthUserService>(context);
                      _user.userLoggedIn = true;
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/home', ModalRoute.withName('/signup'));
                    }, // TODO
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Need a protonmail?"),
                InkWell(
                  onTap: () {
                    _showBottomSheet(context);
                  },
                  child: Text("Explain why?",
                      style: Theme.of(context).textTheme.body2.copyWith(
                          color: Colors.blue, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          //)
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet<Widget>(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        context: context,
        builder: (BuildContext con) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Utils.verticalMargin(4),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 40,
                    color: Colors.grey,
                    height: 4,
                  ),
                ),
                Utils.verticalMargin(32),
                Text(
                  "Why Protonmail",
                  style: Theme.of(context).textTheme.display1,
                ),
                Utils.verticalMargin(32),
                Text(
                    " It uses end-to-end encryption, meaning that only the people sending and receiving messages can read them, and it was founded by former CERN and MIT scientists, so the implication is that it’s basically the Fort Knox of email providers. It’s the email provider of choice for Elliot, the hacker protagonist on Mr. Robot."),
                Utils.verticalMargin(16),
                Text("Would you like to get the protonmail?"),
                Utils.verticalMargin(16),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text("No",
                          style: Theme.of(context).textTheme.body2.copyWith(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    RaisedButton(
                      color: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text("Yes",
                          style: Theme.of(context).textTheme.body2.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {}, // TODO
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
