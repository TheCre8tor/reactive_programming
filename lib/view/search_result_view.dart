import 'package:flutter/material.dart';
import 'package:reactive_programming/bloc/search_result.dart';
import 'package:reactive_programming/models/animal.dart';
import 'package:reactive_programming/models/person.dart';

class SearchResultView extends StatelessWidget {
  final Stream<SearchResult?> searchResult;

  const SearchResultView({
    Key? key,
    required this.searchResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: searchResult,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          final result = snapshot.data;

          if (result is SearchResultHasError) {
            return const Text(
              "[error]: server not responding, start the Live-Server",
            );
          } else if (result is SearchResultLoading) {
            return Center(
              child: Column(
                children: const [
                  Text("typing..."),
                  SizedBox(height: 50),
                  CircularProgressIndicator()
                ],
              ),
            );
          } else if (result is SearchResultNoResult) {
            return const Text(
              "No results found for your seach term. Try with another one!",
            );
          } else if (result is SearchResultWithResult) {
            final results = result.results;

            return Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: ((context, index) {
                  final item = results[index];
                  final String title;

                  if (item is Animal) {
                    title = "Animal";
                  } else if (item is Person) {
                    title = "Person";
                  } else {
                    title = "Unknown";
                  }

                  return ListTile(
                    title: Text(title),
                    subtitle: Text(item.toString()),
                  );
                }),
              ),
            );
          } else {
            return const Text("Unknow state!");
          }
        } else {
          return const Text("Waiting.");
        }
      }),
    );
  }
}
