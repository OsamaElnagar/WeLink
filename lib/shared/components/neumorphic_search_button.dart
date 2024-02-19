// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
//
// class NeumorphicSearchButton extends StatelessWidget {
//   final ValueChanged<String>? onChanged;
//   final VoidCallback? onPressed;
//
//   const NeumorphicSearchButton({
//     Key? key,
//     this.onChanged,
//     this.onPressed,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return NeumorphicButton(
//       onPressed: onPressed,
//       style: NeumorphicStyle(
//         shape: NeumorphicShape.concave,
//         boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
//         depth: 3,
//         intensity: 0.6,
//         color: Colors.white,
//       ),
//       padding: const EdgeInsets.all(12),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Icon(Icons.search, color: Colors.grey),
//           const SizedBox(width: 8),
//           Expanded(
//             child: TextField(
//               onChanged: onChanged,
//               decoration: const InputDecoration(
//                 hintText: 'Search',
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// Usage:
// NeumorphicSearchButton(
//   onChanged: (value) {
//     // Perform search based on value
//   },
//   onPressed: () {
//     // Perform search when button is pressed
//   },
// )
