import 'package:flutter/foundation.dart' show immutable;
import 'package:reactive_programming/bloc/api.dart';
import 'package:reactive_programming/bloc/search_result.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class SearchBloc {
  final Sink<String> search;
  final Stream<SearchResult?> results;

  const SearchBloc._({
    required this.search,
    required this.results,
  });

  void dispose() {
    search.close();
  }

  factory SearchBloc({required Api api}) {
    final textChanges = BehaviorSubject<String>();

    // The .seeded operator set the default search value to a
    // and return every items that contains a.
    // final textChanges = BehaviorSubject<String>.seeded("a");
    // print(textChanges.value.runtimeType);

    final results = textChanges
        .distinct()
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap<SearchResult?>((searchTerm) {
      if (searchTerm.isEmpty) {
        // search is empty ->
        return Stream<SearchResult?>.value(null);
      } else {
        return Rx.fromCallable(() => api.search(searchTerm))
            .delay(const Duration(seconds: 1))
            .map((items) {
              return items.isEmpty
                  ? const SearchResultNoResult()
                  : SearchResultWithResult(items);
            })
            .startWith(const SearchResultLoading())
            .onErrorReturnWith(
              (error, _) => SearchResultHasError(error),
            );
      }
    });

    return SearchBloc._(
      search: textChanges.sink,
      results: results,
    );
  }
}
