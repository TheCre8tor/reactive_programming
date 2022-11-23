import 'package:flutter/foundation.dart' show immutable;
import 'package:reactive_programming/blocs/bloc.dart';
import 'package:reactive_programming/blocs/views_bloc/current_view.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class ViewsBloc implements Bloc {
  final Sink<CurrentView> goToView;
  final Stream<CurrentView> currentView;

  const ViewsBloc._({
    required this.goToView,
    required this.currentView,
  });

  @override
  void dispose() {
    goToView.close();
  }

  factory ViewsBloc() {
    final goToViewSubject = BehaviorSubject<CurrentView>();

    return ViewsBloc._(
      goToView: goToViewSubject.sink,
      currentView: goToViewSubject.startWith(CurrentView.login),
    );
  }
}
