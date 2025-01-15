import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trivia_2/theme/icon_button.dart';
import 'package:trivia_2/theme/model.dart';
import 'package:trivia_2/theme/theme.dart';
import 'package:trivia_2/theme/util.dart';
import 'package:trivia_2/theme/widgets.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:trivia_2/index.dart';
import '../../reusables/menu.dart';
import '../add_friends_to_party/add_friends_to_party_widget.dart';
import 'new_party_model.dart';
export 'new_party_model.dart';

class NewPartyWidget extends StatefulWidget {
  final String userId;
  final String partyId;
  const NewPartyWidget(
      {super.key, required this.userId, required this.partyId});

  @override
  State<NewPartyWidget> createState() => _NewPartyWidgetState();
}

class _NewPartyWidgetState extends State<NewPartyWidget> {
  late NewPartyModel _model;
  int participantsCount = 0; // Current number of participants
  int participantLimit = 0; // Maximum number of participants allowed
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _fetchPartyDetails() async {
    try {
      final partyDoc = await FirebaseFirestore.instance
          .collection('parties')
          .doc(widget.partyId)
          .get();

      if (partyDoc.exists) {
        final data = partyDoc.data()!;
        setState(() {
          participantsCount = (data['users'] as List).length;
          participantLimit = data['participants'] ?? 0;
        });
      }
    } catch (e) {
      print('Error fetching party details: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NewPartyModel());
    _fetchPartyDetails();
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
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: AlignmentDirectional.center,
                    child: Chip(
                      backgroundColor: const Color(0xFF1D5D8A),
                      label: Text(
                        '$participantsCount / $participantLimit',
                        style: MyAppTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              color: Colors.white,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.center,
                    child: BarcodeWidget(
                      data: widget.partyId,
                      barcode: Barcode.qrCode(),
                      width: 200.0,
                      height: 200.0,
                      color: MyAppTheme.of(context).primaryText,
                      backgroundColor: Colors.transparent,
                      errorBuilder: (context, error) => const Text(
                        'Error generating QR code',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Scan to join the party',
                      style: MyAppTheme.of(context).bodySmall.override(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                  FFButtonWidget(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddFriendsToPartyWidget(
                            partyId: widget
                                .partyId, // Pass the partyId to the next screen
                          ),
                        ),
                      );
                    },
                    text: 'Add Friends',
                    icon: Icon(
                      Icons.person_add_alt_1,
                      size: 15.0,
                    ),
                    options: FFButtonOptions(
                      height: 40.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: Color(0xFFBED5DA),
                      textStyle: MyAppTheme.of(context).titleSmall.override(
                            fontFamily: 'Inter',
                            color: Color(0xFF1D5D8A),
                            letterSpacing: 0.0,
                          ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  FFButtonWidget(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PartyWidget(
                            partyId: widget.partyId,
                            userId: widget
                                .userId, // Pass the partyId to the next screen
                          ),
                        ),
                      );
                    },
                    text: 'Next step',
                    icon: Icon(
                      Icons.east,
                      size: 15.0,
                    ),
                    options: FFButtonOptions(
                      height: 40.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: Color(0xFF1D5D8A),
                      textStyle: MyAppTheme.of(context).titleSmall.override(
                            fontFamily: 'Inter',
                            color: Colors.white,
                            letterSpacing: 0.0,
                          ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ].divide(SizedBox(height: 12.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
