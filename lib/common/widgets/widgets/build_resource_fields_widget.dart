// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get_rx/get_rx.dart';
// import 'package:npp/feature/presentation/board_create/controller/board_create_controller.dart';
// import 'package:npp/feature/presentation/board_detail/controller/board_detai_controller.dart';
// import 'package:npp/widgets/custom_mandays_buton.dart';

// class BuildResourceFieldsWidget extends StatelessWidget {
//   final BoardDetaiController? controller;
//   final BoardCreateController? controllerCreate;
//   const BuildResourceFieldsWidget({
//     super.key,
//     this.controller,
//     this.controllerCreate,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final office = controller!.office ?? controllerCreate!.office ?? 0;
//     final sale = controller!.sale.value ?? controllerCreate!.sale.value;
//     final ba = controller!.ba ?? controllerCreate!.ba;
//     final design = controller!.design ?? controllerCreate!.design;
//     final api = controller!.api ?? controllerCreate!.api;
//     final web = controller!.web ?? controllerCreate!.web;
//     final ios = controller!.ios ?? controllerCreate!.ios;
//     final android = controller!.android ?? controllerCreate!.android;
//     final tester = controller!.tester ?? controllerCreate!.tester;
//     final review = controller!.review ?? controllerCreate!.review;
//     final golive = controller!.golive ?? controllerCreate!.golive;
//     final other = controller!.other ?? controllerCreate!.other;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         GridView.count(
//           crossAxisCount: 3,
//           crossAxisSpacing: 16.w,
//           mainAxisSpacing: 0.h,
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           childAspectRatio: 1.3,
//           children: [
//             CustomMandaysButton(
//               title: "Office",
//               isDisabled: !controller!.isUpdate.value ?? false,
//               value: office,
//             ),
//             CustomMandaysButton(
//               title: "Sale",
//               isDisabled: !controller!.isUpdate.value ?? false,
//               value: RxInt(sale),
//             ),
//             CustomMandaysButton(
//               title: "BA",
//               isDisabled: !controller!.isUpdate.value ?? false,
//               value: ba,
//             ),
//             CustomMandaysButton(
//               title: "Design",
//               isDisabled: !controller!.isUpdate.value ?? false,
//               value: controller.design,
//             ),
//             CustomMandaysButton(
//               title: "API",
//               isDisabled: !controller.isUpdate.value,
//               value: controller.api,
//             ),
//             CustomMandaysButton(
//               title: "Web",
//               isDisabled: !controller.isUpdate.value,
//               value: controller.web,
//             ),
//             CustomMandaysButton(
//               title: "iOS",
//               isDisabled: !controller.isUpdate.value,
//               value: controller.ios,
//             ),
//             CustomMandaysButton(
//               title: "Android",
//               isDisabled: !controller.isUpdate.value,
//               value: controller.android,
//             ),
//             CustomMandaysButton(
//               title: "Tester",
//               isDisabled: !controller.isUpdate.value,
//               value: controller.tester,
//             ),
//             CustomMandaysButton(
//               title: "Review",
//               isDisabled: !controller.isUpdate.value,
//               value: controller.review,
//             ),
//             CustomMandaysButton(
//               title: "Go Live",
//               isDisabled: !controller.isUpdate.value,
//               value: controller.golive,
//             ),
//             CustomMandaysButton(
//               title: "Other",
//               isDisabled: !controller.isUpdate.value,
//               value: controller.other,
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }