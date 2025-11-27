// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:ting_x/config/themes/color.dart';
// import 'package:ting_x/widgets/shared/shimmer.dart';
// import 'package:video_player/video_player.dart';
//
// import '../package/player/video_controls.dart';
//
// /// Stateful widget to fetch and then display video content.
// class VideoApp extends StatefulWidget {
//   const VideoApp({
//     required this.controller,
//     this.onPlay,
//     super.key,
//   });
//   final VideoPlayerController controller;
//   final Function()? onPlay;
//   @override
//   // ignore: library_private_types_in_public_api
//   _VideoAppState createState() => _VideoAppState();
// }
//
// class _VideoAppState extends State<VideoApp> {
//   late ChewieController _chewieController;
//
//   @override
//   void initState() {
//     super.initState();
//     widget.controller
//       ..initialize().then((_) {
//         setState(() {});
//       })
//       ..addListener(() {
//         setState(() {});
//       });
//     _chewieController = ChewieController(
//       videoPlayerController: widget.controller,
//       autoPlay: false,
//       looping: false,
//       deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
//       customControls: MyCupertinoControls(
//         iconColor: white,
//         onPlay: widget.onPlay,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(8),
//       child: SizedBox(
//         height: 130.w,
//         width: 231.w,
//         child: widget.controller.value.isInitialized
//             ? InkWell(
//                 onTap: () {
//                   setState(() {
//                     widget.controller.value.isPlaying
//                         ? widget.controller.pause()
//                         : widget.controller.play();
//                   });
//                 },
//                 child: Chewie(
//                   controller: _chewieController,
//                 ),
//               )
//             : ShimmerLoading(
//                 height: 130.w,
//                 width: 231.w,
//               ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     widget.controller.dispose();
//     _chewieController.dispose();
//     super.dispose();
//   }
// }
