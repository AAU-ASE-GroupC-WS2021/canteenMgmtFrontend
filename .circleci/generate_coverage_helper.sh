#!/bin/sh

file=test/coverage_helper_test.dart

# extract package name from pubspec
package="$( cat pubspec.yaml | grep -m 1 '^name: ' | sed 's/^name: \([a-z_]\+\).*$/\1/' )"

{
  echo "// Helper file to make coverage work for all dart files"
  echo "// ignore_for_file: unused_import"

  # list relevant files in lib/ and add imports to file
  find lib '!' -path 'generated*/*' '!' -name '*.g.dart' '!' -name '*.part.dart' '!' -name '*.freezed.dart' -name '*.dart' \
    | cut -c4- | sed "s/.*/import 'package:$package\0';/"

  echo "// ignore: no-empty-block"
  echo "void main(){}"
} > $file
