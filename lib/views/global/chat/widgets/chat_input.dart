// import 'package:flutter/material.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';

// class ChatInput extends StatelessWidget {
//   final Function(types.PartialText) onSendPressed;

//   const ChatInput({Key? key, required this.onSendPressed}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextInput(
//               onSendPressed: onSendPressed,
//               placeholder: 'Type a message...',
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.attach_file),
//             onPressed: () {
//               // Handle attachment
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.image),
//             onPressed: () {
//               // Handle image upload
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
