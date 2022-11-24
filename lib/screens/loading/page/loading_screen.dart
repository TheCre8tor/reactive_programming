import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reactive_programming/screens/loading/controller/loading_screen.controller.dart';

class LoadingScreen {
  // singleton ->
  LoadingScreen._sharedInstance();
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  factory LoadingScreen.instance() => _shared;

  LoadingScreenController? controller;

  void show({
    required BuildContext context,
    required String text,
  }) {
    if (controller?.update(text) ?? false) return;

    controller = _showOverlay(context: context, text: text);
  }

  void hide() {
    controller?.close();
    controller = null;
  }

  LoadingScreenController _showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final controller = StreamController<String>();
    controller.add(text);

    final renderBox = context.findRenderObject() as RenderBox;
    final availableSize = renderBox.size;

    final overlay = OverlayEntry(builder: (context) {
      return Material(
        color: Colors.black.withAlpha(150),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              // Take 80% of the screen width ->
              maxWidth: availableSize.width * 0.8,
              minWidth: availableSize.width * 0.5,
              maxHeight: availableSize.height * 0.8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 26,
                right: 16,
                bottom: 16,
                left: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: StreamBuilder<String>(
                        stream: controller.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(snapshot.requireData);
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });

    // display the overlay
    final state = Overlay.of(context);
    state?.insert(overlay);

    bool closeScreen() {
      controller.close();
      overlay.remove();
      return true;
    }

    bool updateScreen(String input) {
      controller.add(input);
      return true;
    }

    return LoadingScreenController(
      close: closeScreen,
      update: updateScreen,
    );
  }
}
