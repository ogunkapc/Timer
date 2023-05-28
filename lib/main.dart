import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Duration duration = const Duration();

final timer = StreamProvider.autoDispose(
  (ref) {
    return Stream.periodic(
      const Duration(seconds: 1),
      (_) {
        addTimer(ref);
      },
    );
  },
);

final addSecondsProvider = StateProvider((ref) => 1);

void addTimer(ref) {
  final seconds =
      ref.watch(addSecondsProvider.notifier).state + duration.inSeconds;
  duration = Duration(seconds: seconds);
}

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer app',
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const Timer(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Timer extends ConsumerWidget {
  const Timer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamCount = ref.watch(timer);
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    String hours = twoDigits(duration.inHours);
    final backgroundColor =
        Colors.primaries[Random().nextInt(Colors.primaries.length)];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Timer'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          streamCount.when(
            data: (value) {
              return Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left: 40, right: 40),
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 5,
                    )),
                child: Text(
                  "$hours:$minutes:$seconds",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),
              );
            },
            error: (error, stackTrace) => Text('Error: $error'),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          // TODO: Add controller buttons
          // const SizedBox(
          //   height: 20,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     ElevatedButton(
          //       onPressed: () {},
          //       child: const Text("Start"),
          //     ),
          //     const SizedBox(width: 20),
          //     ElevatedButton(
          //       // onPressed: timerController.pauseTimer,
          //       onPressed: () {},
          //       child: const Text('Pause'),
          //     ),
          //     const SizedBox(width: 20),
          //     ElevatedButton(
          //       // onPressed: timerController.resumeTimer,
          //       onPressed: () {},
          //       child: const Text('Resume'),
          //     ),
          //     const SizedBox(width: 20),
          //     ElevatedButton(
          //       // onPressed: timerController.stopTimer,
          //       onPressed: () {},
          //       child: const Text('Stop'),
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}
