// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';

// import 'components/tabs.dart';
// import 'components/tgl.dart';
// import 'tabs/audio_context.dart';
// import 'tabs/controls.dart';
// import 'tabs/logger.dart';
// import 'tabs/sources.dart';
// import 'tabs/streams.dart';

// typedef OnError = void Function(Exception exception);

// class ExampleApp extends StatefulWidget {
//   const ExampleApp({Key? key}) : super(key: key);

//   @override
//   _ExampleAppState createState() => _ExampleAppState();
// }

// class _ExampleAppState extends State<ExampleApp> {
//   List<AudioPlayer> players = List.generate(4, (_) => AudioPlayer());
//   int selectedPlayerIdx = 0;

//   AudioPlayer get selectedPlayer => players[selectedPlayerIdx];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('audioplayers example'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Center(
//               child: Tgl(
//                 options: const ['P1', 'P2', 'P3', 'P4'],
//                 selected: selectedPlayerIdx,
//                 onChange: (v) => setState(() => selectedPlayerIdx = v),
//               ),
//             ),
//           ),
//           Expanded(
//             child: Tabs(
//               tabs: [
//                 TabData(
//                   key: 'sourcesTab',
//                   label: 'Src',
//                   content: SourcesTab(player: selectedPlayer),
//                 ),
//                 TabData(
//                   key: 'controlsTab',
//                   label: 'Ctrl',
//                   content: ControlsTab(player: selectedPlayer),
//                 ),
//                 TabData(
//                   key: 'streamsTab',
//                   label: 'Stream',
//                   content: StreamsTab(player: selectedPlayer),
//                 ),
//                 TabData(
//                   key: 'audioContextTab',
//                   label: 'Ctx',
//                   content: AudioContextTab(player: selectedPlayer),
//                 ),
//                 TabData(
//                   key: 'loggerTab',
//                   label: 'Log',
//                   content: const LoggerTab(),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
