#!/bin/bash
#C: THIS FILE IS PART OF THE CYLC SUITE ENGINE.
#C: Copyright (C) 2008-2013 Hilary Oliver, NIWA
#C: 
#C: This program is free software: you can redistribute it and/or modify
#C: it under the terms of the GNU General Public License as published by
#C: the Free Software Foundation, either version 3 of the License, or
#C: (at your option) any later version.
#C:
#C: This program is distributed in the hope that it will be useful,
#C: but WITHOUT ANY WARRANTY; without even the implied warranty of
#C: MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#C: GNU General Public License for more details.
#C:
#C: You should have received a copy of the GNU General Public License
#C: along with this program.  If not, see <http://www.gnu.org/licenses/>.
#-------------------------------------------------------------------------------
#C: basic tests for suite database contents
. $(dirname $0)/test_header
#-------------------------------------------------------------------------------
set_test_number 5
#-------------------------------------------------------------------------------
install_suite $TEST_NAME_BASE simple
#-------------------------------------------------------------------------------
TEST_NAME=$TEST_NAME_BASE-validate
run_ok $TEST_NAME cylc validate $SUITE_NAME
#-------------------------------------------------------------------------------
TEST_NAME=$TEST_NAME_BASE-run
suite_run_ok $TEST_NAME cylc run --debug $SUITE_NAME
#-------------------------------------------------------------------------------
TEST_NAME=$TEST_NAME_BASE-db-schema
sqlite3 $(cylc get-global-config --print-run-dir)/$SUITE_NAME/cylc-suite.db ".schema" > schema
cmp_ok $TEST_SOURCE_DIR/simple/db-schema schema
#-------------------------------------------------------------------------------
TEST_NAME=$TEST_NAME_BASE-db-states
sqlite3 $(cylc get-global-config --print-run-dir)/$SUITE_NAME/cylc-suite.db "select name, cycle, status from task_states order by name" > states
cmp_ok $TEST_SOURCE_DIR/simple/db-states states
#-------------------------------------------------------------------------------
TEST_NAME=$TEST_NAME_BASE-db-events
sqlite3 $(cylc get-global-config --print-run-dir)/$SUITE_NAME/cylc-suite.db "select name, cycle, event, message, misc from task_events order by name, message" > events
cmp_ok $TEST_SOURCE_DIR/simple/db-events events
#-------------------------------------------------------------------------------
purge_suite $SUITE_NAME