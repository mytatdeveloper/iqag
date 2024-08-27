// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mytat/common-components/CustomAppBar.dart';
// import 'package:mytat/common-components/CustomCenterGridTileWidget.dart';
// import 'package:mytat/utilities/AppConstants.dart';
// import 'package:mytat/utilities/ImageUrls.dart';
// import 'package:mytat/view/syncing_progress_screen.dart';
// import '../../controller/AssessorDashboardController.dart';

// class VivaAndTheoryDashboardScreen extends StatelessWidget {
//   const VivaAndTheoryDashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<AssessorDashboardController>(
//         builder: (assessorDashboardController) {
//       return Scaffold(
//         backgroundColor: AppConstants.appBackground,
//         appBar: CustomAppBar(title: "Viva & Theory Management"),
//         body: Padding(
//           padding: EdgeInsets.all(AppConstants.paddingExtraLarge),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 CustomCenterTileWidget(
//                   title: "DOCUMENTS MANAGEMENT",
//                   onTap: () {
//                     Get.to(const SyncingInProgressScreen());
//                   },
//                   icon: ImageUrls.document,
//                 ),
//                 CustomCenterTileWidget(
//                   title: "Practical/Viva Management",
//                   icon: ImageUrls.startViva,
//                 ),
//                 CustomCenterTileWidget(
//                   title: "STUDENT THEORY",
//                   icon: ImageUrls.gifStudentsList,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }
