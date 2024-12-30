import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../constants/app_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateTimeWidget extends ConsumerWidget {
  const DateTimeWidget({Key? key,
    required this.titleText,
    required this.ValueText,
    required this.iconSection,
  required this.onTap,}) : super(key: key);

  final String titleText;
  final String ValueText;
  final IconData iconSection;
  final VoidCallback onTap;


  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Expanded
      (child: Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
       Text(
      titleText,
      style: AppStyle.headingOne,
      ),
       const Gap(6),
        Material(child:
        Ink(
          decoration: BoxDecoration(
            color:Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: ()=> onTap(),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ), // Espacement interne
              decoration: BoxDecoration(
                color: Colors.transparent, // Fond gris clair
                borderRadius: BorderRadius.circular(8), // Coins arrondis
              ),
              child: Row(
                children:  [
                  Icon(iconSection), // Icône calendrier
                  Gap(6), // Espacement entre icône et texte
                  Text(ValueText), // Texte exemple
                ],
              ),
            ),
          ),
        ),
        )
      ],
    ));
  }
}
