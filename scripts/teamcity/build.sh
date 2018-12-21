#!/usr/bin/env bash

tc_build_problem() {
    echo -n '##'
    echo "teamcity[buildProblem description='$1']"
}

tc_open_block() {
    echo -n '##'
    echo "teamcity[blockOpened name='$1']"
}

tc_close_block() {
    echo -n '##'
    echo "teamcity[blockClosed name='$1']"
}

tc_open_block 'Show R version'
(
    R --version
    R --quiet -e "installed.packages()[,c(1,3:4)]"
    echo "PATH = $PATH"
    which make # Should be in PATH, otherwise check() will fail with "status 127".
)
tc_close_block 'Show R version'

tc_open_block 'Build binary'
(
    mkdir -p artifacts
    R --quiet -e "devtools::build(binary = TRUE, path = 'artifacts', args = '--no-multiarch')"
)
tc_close_block 'Build binary'

tc_open_block 'Build source'
(
    mkdir -p artifacts
    R --quiet -e "devtools::build(binary = FALSE, path = 'artifacts')"
)
tc_close_block 'Build source'

tc_open_block 'Check'
(
    R --quiet -e "devtools::check(check_dir = '.', args = c('--no-examples', '--no-multiarch', '--no-tests'))"
)
tc_close_block 'Check'

tc_open_block 'Test'
(
    R --quiet -e "devtools::test(reporter = testthat::TeamcityReporter)"
)
tc_close_block 'Test'
