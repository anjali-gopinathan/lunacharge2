import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;
import 'Patient.dart'

class HealthInfoPage extends StatefulWidget {
  const HealthInfoPage({super.key});

  @override
  State<HealthInfoPage> createState() => _HealthInfoPageState();
}

class _HealthInfoPageState extends State<HealthInfoPage> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    //API key: rwTfGX0PLYds3c2mkwWj8HhabyAGsjr27jDYGHv3
    List<Patient> parsePatients(String responseBody) { 
      final parsed = json.decode(responseBody).cast<Map<String, dynamic>>(); 
      return parsed.map<Patient>((json) => Patient.fromMap(json)).toList(); 
    } 
    return Scaffold(
      body: TextButton(
        // MaterialStateProperty.all<RoundedRectangleBorder>(
        //   RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(18.0),
        //     side: BorderSide(color: Colors.red)
        //   )
        // )
        onPressed: _interssytemsLogin,

        ),
      bottomNavigationBar: BottomAppBar(        
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              const Spacer(),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(MdiIcons.heartCircle, color: Colors.grey),
                      Text('My health', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              const Spacer(),
              const Spacer(),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(MdiIcons.account, color: Colors.grey),
                      Text('Profile', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),

      ),
    );
  }
  void _intersystemsLogin(){
    Response response = await get('') ;
    
  Future<http.Response> fetchPatientData() {
    return http.get(Uri.parse('https://fhir.8af670au7wp7.static-test-account.isccloud.io'));
  }
}
