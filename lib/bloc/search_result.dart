import 'package:flutter/foundation.dart' show immutable;
import 'package:reactive_programming/models/thing.dart';

@immutable
abstract class SearchResult {
  const SearchResult();
}

@immutable
class SearchResultLoading extends SearchResult {
  const SearchResultLoading();
}

@immutable
class SearchResultNoResult extends SearchResult {
  const SearchResultNoResult();
}

@immutable
class SearchResultHasError extends SearchResult {
  final Object error;

  const SearchResultHasError(this.error);
}

@immutable
class SearchResultWithResult extends SearchResult {
  final List<Thing> result;

  const SearchResultWithResult(this.result);
}
