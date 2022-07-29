Tests and Coverage
================
29 July, 2022 12:50:18

-   <a href="#coverage" id="toc-coverage">Coverage</a>
-   <a href="#unit-tests" id="toc-unit-tests">Unit Tests</a>

This output is created by
[covrpage](https://github.com/yonicd/covrpage).

## Coverage

Coverage summary is created using the
[covr](https://github.com/r-lib/covr) package.

| Object                                                      | Coverage (%) |
|:------------------------------------------------------------|:------------:|
| auto.template.creation                                      |      0       |
| [R/app_config.R](../R/app_config.R)                         |      0       |
| [R/app_server.R](../R/app_server.R)                         |      0       |
| [R/app_ui.R](../R/app_ui.R)                                 |      0       |
| [R/mod_cols_conf.R](../R/mod_cols_conf.R)                   |      0       |
| [R/mod_export.R](../R/mod_export.R)                         |      0       |
| [R/mod_lab_management.R](../R/mod_lab_management.R)         |      0       |
| [R/mod_login_utils_db.R](../R/mod_login_utils_db.R)         |      0       |
| [R/mod_login.R](../R/mod_login.R)                           |      0       |
| [R/mod_order_spec_conf.R](../R/mod_order_spec_conf.R)       |      0       |
| [R/mod_project_management.R](../R/mod_project_management.R) |      0       |
| [R/mod_set_accnr.R](../R/mod_set_accnr.R)                   |      0       |
| [R/mod_user_management.R](../R/mod_user_management.R)       |      0       |
| [R/run_app.R](../R/run_app.R)                               |      0       |
| [R/utils_accnr_helpers.R](../R/utils_accnr_helpers.R)       |      0       |
| [R/utils_provid_helpers.R](../R/utils_provid_helpers.R)     |      0       |

<br>

## Unit Tests

Unit Test summary is created using the
[testthat](https://github.com/r-lib/testthat) package.

| file                                                                  |   n |  time | error | failed | skipped | warning |
|:----------------------------------------------------------------------|----:|------:|------:|-------:|--------:|--------:|
| [test-app.R](testthat/test-app.R)                                     |   1 | 0.021 |     0 |      0 |       0 |       0 |
| [test-fct_generate_template.R](testthat/test-fct_generate_template.R) |   1 | 0.003 |     0 |      0 |       0 |       0 |
| [test-utils_accnr_helpers.R](testthat/test-utils_accnr_helpers.R)     |   1 | 0.002 |     0 |      0 |       0 |       0 |
| [test-utils_provid_helpers.R](testthat/test-utils_provid_helpers.R)   |   1 | 0.003 |     0 |      0 |       0 |       0 |

<details closed>
<summary>
Show Detailed Test Results
</summary>

| file                                                                     | context               | test                 | status |   n |  time |
|:-------------------------------------------------------------------------|:----------------------|:---------------------|:-------|----:|------:|
| [test-app.R](testthat/test-app.R#L2)                                     | app                   | multiplication works | PASS   |   1 | 0.021 |
| [test-fct_generate_template.R](testthat/test-fct_generate_template.R#L2) | fct_generate_template | multiplication works | PASS   |   1 | 0.003 |
| [test-utils_accnr_helpers.R](testthat/test-utils_accnr_helpers.R#L2)     | utils_accnr_helpers   | multiplication works | PASS   |   1 | 0.002 |
| [test-utils_provid_helpers.R](testthat/test-utils_provid_helpers.R#L2)   | utils_provid_helpers  | multiplication works | PASS   |   1 | 0.003 |

</details>
<details>
<summary>
Session Info
</summary>

| Field    | Value                        |
|:---------|:-----------------------------|
| Version  | R version 4.2.1 (2022-06-23) |
| Platform | x86_64-pc-linux-gnu (64-bit) |
| Running  | Arch Linux                   |
| Language | en_US                        |
| Timezone | Europe/Stockholm             |

| Package  | Version |
|:---------|:--------|
| testthat | 3.1.4   |
| covr     | 3.5.1   |
| covrpage | 0.1     |

</details>
<!--- Final Status : pass --->
