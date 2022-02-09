#!/bin/bash

TEST_DRIVER_DIR="integration_test/test_driver"
TEST_DRIVER="$TEST_DRIVER_DIR/integration_test.dart"
FIXTURE_DIR="integration_test/fixtures"

# capture qr code screenshot
cat "$FIXTURE_DIR/reset.sql" "$FIXTURE_DIR/qr_scan_test.sql" | PGPASSWORD=mysecretpassword psql \
      -h 127.0.0.1 -p 5432 -d postgres -U postgres -f - > /dev/null
# the test will fail due to an open issue for flutter driver for web
# (see https://github.com/flutter/flutter/issues/86985)
# but will still create the screenshot
flutter drive --driver="$TEST_DRIVER_DIR/screenshot_test.dart" \
    --target="integration_test/qr_scan_test.dart" -d web-server "$@" \
    --dart-define="SCREENSHOT=ON" || (exit 0)

for TEST_FILE in integration_test/*_test.dart
do
  filename=$(basename -- "$TEST_FILE")
  filename="${filename%.*}"

  if [ -f "$FIXTURE_DIR/${filename}.sql" ]; then
    echo "Setting up fixture for $TEST_FILE"
    cat "$FIXTURE_DIR/reset.sql" "$FIXTURE_DIR/${filename}.sql" | PGPASSWORD=mysecretpassword psql \
      -h 127.0.0.1 -p 5432 -d postgres -U postgres -q -f -
  else
    echo "Found no fixture for $TEST_FILE. Only resetting to default"
    PGPASSWORD=mysecretpassword psql -h 127.0.0.1 -p 5432 -d postgres -U postgres \
       -f "$FIXTURE_DIR/reset.sql" > /dev/null
  fi

  echo "Running $TEST_FILE"
  flutter drive --driver="$TEST_DRIVER" --target="$TEST_FILE" \
		-d web-server "$@"
done