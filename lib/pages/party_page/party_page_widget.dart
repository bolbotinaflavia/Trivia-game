import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trivia_2/theme/icon_button.dart';
import 'package:trivia_2/theme/model.dart';
import 'package:trivia_2/theme/theme.dart';
import 'package:trivia_2/theme/util.dart';
import 'package:trivia_2/theme/widgets.dart';
import 'package:flutter/material.dart';
import '../../model/Party.dart';
import '../../reusables/menu.dart';
import '../../reusables/party_card.dart';
import '../create_party/create_party_widget.dart';
import '../party/party_widget.dart';
import '../scanqrcode/scanQr_code_widget.dart';
import 'party_page_model.dart';
export 'party_page_model.dart';

class PartyPageWidget extends StatefulWidget {
  const PartyPageWidget({super.key});

  @override
  State<PartyPageWidget> createState() => _PartyPageWidgetState();
}

class _PartyPageWidgetState extends State<PartyPageWidget> {
  late PartyPageModel _model;

  bool isLoading = true;
  List<Party> _partiesList = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late User currentUser;

  Future<void> fetchParties() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }
      currentUser = user;

      final data = await FirebaseFirestore.instance
          .collection("parties")
          .where('creatorId', isEqualTo: currentUser.uid)
          .orderBy('name', descending: true)
          .get();

      final parties = data.docs.map((doc) => Party.fromSnapshot(doc)).toList();
      setState(() {
        _partiesList = parties;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching parties: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PartyPageModel());
    fetchParties();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: MyAppTheme.of(context).primaryBackground,
        drawer: CustomDrawer(),
        appBar: AppBar(
          backgroundColor: Color(0xFF1D5D8A),
          automaticallyImplyLeading: false,
          leading: MyAppIconButton(
            borderColor: Colors.transparent,
            borderRadius: 8.0,
            buttonSize: 40.0,
            fillColor: Color(0xFF1D5D8A),
            icon: Icon(
              Icons.home_rounded,
              color: MyAppTheme.of(context).info,
              size: 24.0,
            ),
            onPressed: () async {
              context.pushNamed('HomePage');
            },
          ),
          actions: [
            MyAppIconButton(
              borderColor: Colors.transparent,
              borderRadius: 8.0,
              buttonSize: 40.0,
              fillColor: Color(0xFF1D5D8A),
              icon: Icon(
                Icons.menu_rounded,
                color: MyAppTheme.of(context).info,
                size: 24.0,
              ),
              onPressed: () async {
                scaffoldKey.currentState!.openDrawer();
              },
            ),
          ],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: FFButtonWidget(
                  onPressed: () async => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CreatePartyWidget(
                                userId: currentUser.uid,
                              )),
                    ),
                  },
                  text: 'New Party',
                  icon: const Icon(Icons.add_box, size: 15.0),
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 50.0,
                    color: const Color(0xFF1D5D8A),
                    textStyle: MyAppTheme.of(context).titleSmall.override(
                          fontFamily: 'Inter',
                          color: Colors.white,
                        ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _partiesList.isEmpty
                        ? const Center(child: Text('No parties found.'))
                        : ListView.builder(
                            padding: const EdgeInsets.all(12.0),
                            itemCount: _partiesList.length,
                            itemBuilder: (context, index) {
                              final party = _partiesList[index];
                              return PartyCard(
                                party: party,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PartyWidget(
                                          userId: currentUser.uid.toString(),
                                          partyId: party.partyId.toString()),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
              ),
              FFButtonWidget(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ScanQRCodeWidget(
                            userId: currentUser.uid.toString())),
                  );
                },
                text: 'Scan QR Code',
                icon: Icon(Icons.qr_code_scanner),
                options: FFButtonOptions(
                  height: 40.0,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  color: Color(0xFF1D5D8A),
                  textStyle: MyAppTheme.of(context).titleSmall.override(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        letterSpacing: 0.0,
                      ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
