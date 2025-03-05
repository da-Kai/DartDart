flutter pub get junitreport
export PATH="$PATH":"$HOME/.pub-cache/bin"
flutter pub global activate junitreport
sudo apt-get install xmlstarlet

junitFile="./junit.xml"
flutter test --machine --coverage --coverage-path=lcov.info | tojunit --output $junitFile

errors=$(xmlstarlet sel -t -v "sum(//testsuite/@errors)" "$junitFile")
failures=$(xmlstarlet sel -t -v "sum(//testsuite/@failures)" "$junitFile")
tests=$(xmlstarlet sel -t -v "sum(//testsuite/@tests)" "$junitFile")
skipped=$(xmlstarlet sel -t -v "sum(//testsuite/@skipped)" "$junitFile")

if [[ "$errors" == "0" && "$failures" == "0" ]]; then
    echo " All Tests Passed "
    STATUS=0
else
    echo " Some Test Failed "
    STATUS=1
fi

echo "Tests: $tests, Skipped: $skipped, Errors: $errors, Failures: $failures"
exit $STATUS
