import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HealthPage extends StatefulWidget {
  const HealthPage({super.key});

  @override
  State<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  final String key = 'KtQQvdNp072rSZzEFiI2tKJTaJ1t9dP7JnNnF2Fd';
  final String baseUrl =
      'https://fhir.8af670au7wp7.static-test-account.isccloud.io';

  String? _name;
  String? _race;
  String? _sex;
  String? _location;
  String? _birthDate;
  String? _mrn;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    // fetch data
    final response = await http.get(Uri.parse('$baseUrl/Patient/1'), headers: {
      'x-api-key': key,
    });

    final payload = jsonDecode(response.body);
    final race =
        payload['extension'][0]['extension'][0]['valueCoding']['display'];
    final sex = payload['extension'][3]['valueCode'];
    final city = payload['extension'][4]['valueAddress']['city'];
    final state = payload['extension'][4]['valueAddress']['state'];
    final firstName = payload['name'][0]['given'][0];
    final lastName = payload['name'][0]['family'];
    final birthDate = payload['birthDate'];
    final mrn = payload['identifier'][1]['value'];

    final location = '$city, $state';
    final name = '$firstName $lastName';

    setState(() {
      _name = name;
      _race = race;
      _sex = sex;
      _location = location;
      _birthDate = birthDate;
      _mrn = mrn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 30),
      child: Column(children: [
        Text('Health info', style: Theme.of(context).textTheme.headline4),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _buildGrid(),
        ),
        const SizedBox(),
      ]),
    );
  }

  Widget _buildGrid() {
    if (_name == null) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      );
    }
    final map = {
      'Name: ': _name,
      'Race: ': _race,
      'Sex: ': _sex,
      'Location: ': _location,
      'Birth date: ': _birthDate,
      'Medical Rec. #: ': _mrn,
    };
    final rows = <Widget>[];
    map.forEach((key, value) {
      final row = Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Text(
              key,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w700),
            ),
            Text(value!, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      );
      rows.add(row);
    });
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rows,
      ),
    );
    // return GridView.count(
    //   shrinkWrap: true,
    //   crossAxisCount: 2,
    //   children: [
    //     Text(
    //       'Name',
    //       textAlign: TextAlign.end,
    //       style: Theme.of(context)
    //           .textTheme
    //           .bodyLarge!
    //           .copyWith(fontWeight: FontWeight.w700),
    //     ),
    //     Text(
    //       '$_name',
    //       style: Theme.of(context).textTheme.bodyLarge,
    //     ),
    //     Text(
    //       'Race',
    //       textAlign: TextAlign.end,
    //       style: Theme.of(context)
    //           .textTheme
    //           .bodyLarge!
    //           .copyWith(fontWeight: FontWeight.w700),
    //     ),
    //     Text(
    //       '$_race',
    //       style: Theme.of(context).textTheme.bodyLarge,
    //     ),
    //     Text(
    //       'Sex',
    //       textAlign: TextAlign.end,
    //       style: Theme.of(context)
    //           .textTheme
    //           .bodyLarge!
    //           .copyWith(fontWeight: FontWeight.w700),
    //     ),
    //     Text(
    //       '$_sex',
    //       style: Theme.of(context).textTheme.bodyLarge,
    //     ),
    //     Text(
    //       'Location',
    //       textAlign: TextAlign.end,
    //       style: Theme.of(context)
    //           .textTheme
    //           .bodyLarge!
    //           .copyWith(fontWeight: FontWeight.w700),
    //     ),
    //     Text(
    //       '$_location',
    //       style: Theme.of(context).textTheme.bodyLarge,
    //     ),
    //     Text(
    //       'Birth date',
    //       textAlign: TextAlign.end,
    //       style: Theme.of(context)
    //           .textTheme
    //           .bodyLarge!
    //           .copyWith(fontWeight: FontWeight.w700),
    //     ),
    //     Text(
    //       '$_birthDate',
    //       style: Theme.of(context).textTheme.bodyLarge,
    //     ),
    //     Text(
    //       'Medical record #',
    //       textAlign: TextAlign.end,
    //       style: Theme.of(context)
    //           .textTheme
    //           .bodyLarge!
    //           .copyWith(fontWeight: FontWeight.w700),
    //     ),
    //     Text(
    //       '$_mrn',
    //       style: Theme.of(context).textTheme.bodyLarge,
    //     ),
    //   ],
    // );
  }
}
