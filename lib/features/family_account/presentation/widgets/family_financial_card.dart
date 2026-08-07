import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


class FamilyFinancialCard extends StatelessWidget {

  const FamilyFinancialCard({
    super.key
  });


  @override
  Widget build(BuildContext context) {


    return Container(

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: Theme.of(context)
            .colorScheme
            .primaryContainer,

        borderRadius:
        BorderRadius.circular(20),

      ),


      child: Row(

        children: [


          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(

              color: Colors.white,

              borderRadius:
              BorderRadius.circular(15),
            ),

            child: const Icon(
              Icons.receipt_long,
            ),
          ),



          const SizedBox(width:15),



          Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,


              children: [

                Text(
                  "Family Financial Statement".tr(),

                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),


                const SizedBox(height:6),


                Text(
                  "View all invoices and payments".tr(),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall,
                ),

              ],
            ),
          ),



          const Icon(
            Icons.arrow_forward_ios,
            size:18,
          )

        ],
      ),
    );
  }
}