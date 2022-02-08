#!/bin/bash
for TEST_FILE in ../integration_test/*_test.dart
do
  filename=$(basename -- "$TEST_FILE")
  filename="${filename%.*}"

  if [ -f "../integration_test/fixtures/${filename}.sql" ]; then
    echo "Setting up fixture for $TEST_FILE"
    cat "../integration_test/fixtures/reset.sql" "../integration_test/fixtures/${filename}.sql" | PGPASSWORD=mysecretpassword psql \
      -h 127.0.0.1 -p 5432 -d postgres -U postgres -f - > /dev/null
  else
    echo "Found no fixture for $TEST_FILE. Only resetting to default"
    PGPASSWORD=mysecretpassword psql -h 127.0.0.1 -p 5432 -d postgres -U postgres \
       -f "../integration_test/fixtures/reset.sql" > /dev/null
  fi

  echo "Running $TEST_FILE"
  flutter drive --driver=../test_driver/integration_test.dart --target="$TEST_FILE" \
		-d web-server "$1"
done