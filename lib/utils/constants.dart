import 'package:flutter/material.dart';

class Constants {
  static final TextStyle posRes =
          TextStyle(color: Colors.black, backgroundColor: Colors.yellow),
      negRes = TextStyle(color: Colors.black, backgroundColor: Colors.white);

  static TextSpan searchMatch(String match, String searchText) {
    if (searchText == "") return TextSpan(text: match, style: Constants.negRes);
    var refinedMatch = match.toLowerCase();
    var refinedSearch = searchText.toLowerCase();
    if (refinedMatch.contains(refinedSearch)) {
      if (refinedMatch.substring(0, refinedSearch.length) == refinedSearch) {
        return TextSpan(
          style: Constants.posRes,
          text: match.substring(0, refinedSearch.length),
          children: [
            searchMatch(
                match.substring(
                  refinedSearch.length,
                ),
                searchText),
          ],
        );
      } else if (refinedMatch.length == refinedSearch.length) {
        return TextSpan(text: match, style: posRes);
      } else {
        return TextSpan(
          style: Constants.negRes,
          text: match.substring(
            0,
            refinedMatch.indexOf(refinedSearch),
          ),
          children: [
            searchMatch(
                match.substring(
                  refinedMatch.indexOf(refinedSearch),
                ),
                searchText),
          ],
        );
      }
    } else if (!refinedMatch.contains(refinedSearch)) {
      return TextSpan(text: match, style: Constants.negRes);
    }
    return TextSpan(
      text: match.substring(0, refinedMatch.indexOf(refinedSearch)),
      style: Constants.negRes,
      children: [
        searchMatch(
            match.substring(refinedMatch.indexOf(refinedSearch)), searchText)
      ],
    );
  }

  static final String visibility = "VISIBILITY";
  static final String grouping = "GROUPING";
}
