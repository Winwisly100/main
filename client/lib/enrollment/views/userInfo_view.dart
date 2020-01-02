import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:com.whitelabel/services/services.dart';

class UserInfoView extends StatelessWidget {
  const UserInfoView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebInfoView(
      title: TitleWidget(
        icon: FontAwesomeIcons.fistRaised,
        title: 'Campaign for Your Cause',
      ),
      child: const _UserInfoView(),
      index: -1,
    );
  }
}

class _UserInfoView extends StatefulWidget {
  const _UserInfoView({Key key}) : super(key: key);

  @override
  _UserInfoViewState createState() => _UserInfoViewState();
}

class _UserInfoViewState extends State<_UserInfoView> {
  final List<String> countries = <String>[
    'Germany',
    'Australia',
    'Pakistan',
    'USA'
  ];

  final List<String> cities = <String>[
    'Berlin',
    'Newyork',
    'Vancouver',
    'Shanghai'
  ];

  final List<String> issues = <String>[
    'Student Debt',
    'Health Care',
    'Climate'
  ];

  final List<String> campaings = <String>[
    'Extinction Rebellion (XR)',
    'Fridays for Future',
    'Children\'s Climate Strike',
    'GreenPeace',
    'None',
  ];
  final List<String> ages = <String>[
    '10-15',
    '16-20',
    '21-30',
    '31-40',
    '41-50',
    '51-60',
    '61-65',
    '66-70',
    '71 and over'
  ];
  final Map<String, String> dropdownValue = <String, String>{};

  @override
  void initState() {
    dropdownValue['countries'] = countries[0];
    dropdownValue['cities'] = cities[0];
    dropdownValue['issues'] = issues[0];
    dropdownValue['campaings'] = campaings[0];
    dropdownValue['ages'] = ages[2];
    dropdownValue['others'] = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveListView(
      children: <Widget>[
        ListTile(
            title: Text(
          '1. Where are you?',
          style: Theme.of(context).textTheme.title,
        )),
        ListTile(
          title: _select(countries, 'Select Country', 'countries'),
        ),
        ListTile(
          title: _select(cities, 'Select City', 'cities'),
        ),
        ListTile(
          title: Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width >= 720.0
                  ? MediaQuery.of(context).size.width * 0.60
                  : 0,
            ),
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Zip Code',
              ),
            ),
          ),
        ),
/*         ListTile(
          title: TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                hintText: 'Your Location', suffix: Icon(Icons.search)),
          ),
        ), */
        const SizedBox(height: 48.0),
        ListTile(
          title: Text(
            '2. Travel distance you can afford?',
            style: Theme.of(context).textTheme.title,
          ),
        ),
        ListTile(
          title: Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width >= 720.0
                  ? MediaQuery.of(context).size.width * 0.60
                  : 0,
            ),
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Distance in KM',
              ),
            ),
          ),
        ),
        const SizedBox(height: 48.0),
        ListTile(
          title: Text(
            '3. Age',
            style: Theme.of(context).textTheme.title,
          ),
        ),
        ListTile(title: _select(ages, 'Select Age Range', 'ages')),
        // TODO(me): Commented Cause for demo
/*         const SizedBox(height: 48.0),
        ListTile(
          title: Text(
            '3. Cause',
            style: Theme.of(context).textTheme.title,
          ),
        ),
        ListTile(title: _select(issues, 'Your Issue', 'issues')), */
        const SizedBox(height: 48.0),
        ListTile(
          title: Text(
            '4. Any Campaign Affiliations ?',
            style: Theme.of(context).textTheme.title,
          ),
        ),
        ListTile(
          title: _select(campaings, 'Select Affiliation ', 'campaings'),
          subtitle: Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width >= 720.0
                  ? MediaQuery.of(context).size.width * 0.60
                  : 0,
            ),
            child: TextFormField(
              initialValue: dropdownValue['others'],
              maxLines: 1,
              decoration: InputDecoration(
                labelText: 'Others',
                alignLabelWithHint: true,
                hintText: 'Others',
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: const BorderSide(),
                ),
              ),
              onSaved: (String value) {
                setState(() {
                  dropdownValue['others'] = value;
                });
              },
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ),
        const SizedBox(height: 48.0),
        ListTile(
          title: Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width >= 720.0
                  ? MediaQuery.of(context).size.width * 0.60
                  : 0,
            ),
            child: ButtonBar(
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/campaignview');
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ),
      ],
      // ),
      //   ),
    );
  }

  Widget _select(List<String> items, String hint, String item) {
    return Padding(
      padding: EdgeInsets.only(
        right: MediaQuery.of(context).size.width >= 720.0
            ? MediaQuery.of(context).size.width * 0.60
            : 0,
      ),
      child: DropdownButton<String>(
        value: dropdownValue[item],
        icon: Icon(Icons.arrow_downward),
        underline: Container(
          height: 2,
          color: Theme.of(context).colorScheme.secondaryVariant,
        ),
        iconSize: 24,
        elevation: 5,
        isExpanded: true,
        hint: Text(hint),
        onChanged: (String newValue) {
          setState(() {
            dropdownValue[item] = newValue;
          });
        },
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
