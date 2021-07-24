// import 'package:flutter/material.dart';
// import 'package:my_time_tracker/common_widgets/custom_text_style.dart';
// import 'package:my_time_tracker/common_widgets/form_submit_button.dart';
// import 'package:my_time_tracker/services/auth_base.dart';
// import 'package:provider/provider.dart';

// class ResetPasswordPage extends StatelessWidget {
//   const ResetPasswordPage({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final auth = Provider.of<AuthBase>(context);
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topRight,
//               end: Alignment.bottomLeft,
//               colors: [
//                 Color.fromRGBO(66, 150, 152, 0.8),
//                 Color.fromRGBO(255, 228, 115, 1),
//               ],
//             ),
//           ),
//           padding: EdgeInsets.all(20),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Text(
//                     'Email Verification',
//                     style: CustomTextStyles.textStyleBold(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w900,
//                         color: Colors.teal[700]),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Text(
//                     'A verification link has been sent to the email provided. Please Click on the link in email to activate your account.',
//                     style: CustomTextStyles.textStyleBold(
//                       fontSize: 12.0,
//                       color: Colors.grey[800],
//                       fontWeight: FontWeight.w800,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: FormSubmitButton(
//                     focusNode: FocusNode(),
//                     text: 'Confirm My Email',
//                     onPressed: () async {

//                     },
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
