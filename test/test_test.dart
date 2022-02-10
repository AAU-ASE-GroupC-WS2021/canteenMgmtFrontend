import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fails on purpose for testing circleci pipeline', (){
    expect(1+1, equals(3), reason: 'fails on purpose');
  });
}