import 'package:flutter/material.dart';
import 'package:trivia_2/theme/util.dart';
import '../theme/theme.dart';
import '../model/Party.dart';

class PartyCard extends StatelessWidget {
  final Party party;
  final VoidCallback? onTap;

  const PartyCard({
    Key? key,
    required this.party,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          color: Color(0xFFBED5DA),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    party.photoUrl?.isNotEmpty == true
                        ? party.photoUrl!
                        : 'assets/images/frog.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Text(
                        party.name ?? 'Untitled Party',
                        style: MyAppTheme.of(context).titleLarge.override(
                              fontFamily: 'Readex Pro',
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                    Text(
                      'Descriere',
                      style: MyAppTheme.of(context).bodySmall.override(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                          ),
                    ),
                  ],
                ),
              ),
            ].divide(SizedBox(width: 12.0)),
          ),
        ),
      ),
    );
  }
}
