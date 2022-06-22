Tests and Coverage
================
22 June, 2022 11:22:55

-   [Coverage](#coverage)
-   [Unit Tests](#unit-tests)

This output is created by
[covrpage](https://github.com/yonicd/covrpage).

## Coverage

Coverage summary is created using the
[covr](https://github.com/r-lib/covr) package.

| Object                                                | Coverage (%) |
|:------------------------------------------------------|:------------:|
| auto.template.creation                                |      0       |
| [R/app_config.R](../R/app_config.R)                   |      0       |
| [R/app_server.R](../R/app_server.R)                   |      0       |
| [R/app_ui.R](../R/app_ui.R)                           |      0       |
| [R/mod_cols_conf.R](../R/mod_cols_conf.R)             |      0       |
| [R/mod_order_spec_conf.R](../R/mod_order_spec_conf.R) |      0       |
| [R/run_app.R](../R/run_app.R)                         |      0       |

<br>

## Unit Tests

Unit Test summary is created using the
[testthat](https://github.com/r-lib/testthat) package.

| file                                                                  |   n |  time | error | failed | skipped | warning |
|:----------------------------------------------------------------------|----:|------:|------:|-------:|--------:|--------:|
| [test-app.R](testthat/test-app.R)                                     |   1 | 0.021 |     0 |      0 |       0 |       0 |
| [test-fct_generate_template.R](testthat/test-fct_generate_template.R) |   1 | 0.002 |     0 |      0 |       0 |       0 |

<details closed>
<summary>
Show Detailed Test Results
</summary>

| file                                                                     | context               | test                 | status |   n |  time |
|:-------------------------------------------------------------------------|:----------------------|:---------------------|:-------|----:|------:|
| [test-app.R](testthat/test-app.R#L2)                                     | app                   | multiplication works | PASS   |   1 | 0.021 |
| [test-fct_generate_template.R](testthat/test-fct_generate_template.R#L2) | fct_generate_template | multiplication works | PASS   |   1 | 0.002 |

</details>
<details>
<summary>
Session Info
</summary>

| Field    | Value                        |
|:---------|:-----------------------------|
| Version  | R version 4.2.0 (2022-04-22) |
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
