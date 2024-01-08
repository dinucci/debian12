#!/bin/bash

# Run hardening.sh with audit-all flag
result=$(bin/hardening.sh --audit-all)

# Extract number of available checks from result string
total_available=${result%% *}

# Extract number of passed and failed checks from result string
passed_and_failed=$(echo "$result" | awk '{print $NF}')

# Extract number of passed checks
passed=${passed_and_failed%%/*}

# Extract number of failed checks
failed=${passed_and_failed##*/}

# Calculate percentage of total checked checks (enabled checks)
enabled=$(( ($passed + $failed) * 100 / $total_available ))

# Calculate percentage of conformant checks
conformity=$(( $passed * 100 / ($passed + $failed) ))

# Print summary to console
echo "############### SUMMARY ###################"
echo "    Total Available Checks : $total_available"
echo "       Total Runned Checks : $(( $passed + $failed))"
echo "       Total Passed Checks : [ $passed/$total_available ]"
echo "       Total Failed Checks : [ $failed/$total_available ]"
echo " Enabled Checks Percentage : $enabled%"
echo "     Conformity Percentage : $conformity%"
