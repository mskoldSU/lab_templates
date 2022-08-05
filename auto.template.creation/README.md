
<!-- README.md is generated from README.Rmd. Please edit that file -->

# auto.template.creation

<!-- badges: start -->
<!-- badges: end -->

The goal of auto.template.creation is to automate the process of
generating analytics-lab ready templates with set AccNR and ProvID.

## Modules and Structure

### Modules

-   login
    -   Checks if user is logged in. If not, it will show a login screen
        where the user can enter a username and password. When the
        ‘login’ button is clicked it will check against a global
        `credentials` data.frame. If the user entered correct
        login-details it will render one of the management modules,
        depending on what permission/user-type the login corresponded
        to. It will also contain the logout button.
-   user_management
    -   An user admin that can create new users, delete users, and
        change detals such as name, password and type/permission. To
        edit an user, double-click on the cell and enter the new value.
        The password will be shown as the hash (which is all that is
        saved on the server), but the user will login with the cleartext
        the admin entered. The username must be unique and an empty
        username will delete the user.
-   project_management
    -   Is able to create new projects, enter meta-information such as
        project-name and manager. A tab with project-information
        contains four tables associated with the projects. More
        information on the tables can be found
        [here](https://github.com/mskoldSU/lab_templates/issues/4#issuecomment-1195653136).
        The table called ‘prover’ shall be uploaded in a wide format.
        <details>
        <summary>
        Short table examples
        </summary>
        \#### What Test \#### More Text
        </details>
-   lab_management
-   project_selector
-   samples_preparation
-   set_accnr_and_provid
-   export
    -   This module is not yet created. The idea for it is that it will
        gather all of the relevant information from the sqlite database
        and produce

### Functions

-   generate_template
-   sqlite

### Utils

-   long_and_wide_prover
-   accnr_helpers
-   provid_helpers

### Module Structure

    ui/server
    └── login
        ├── user_management
        ├── project_management
        │   └── project_selector
        └── lab_management
            ├── project_selector
            ├── samples_preparation
            │   └── set_accnr_and_provid
            └── export

## Installation

You can install the development version of auto.template.creation from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("mskoldSU/lab_templates")
```

### Running development version

The server can be started for development using the run_dev.R script in
the `/dev` folder.

``` bash
Rscript dev/run_dev.R
```

### Deploying

To deploy run

``` bash
Rscript dev/03_deploy.R
```

## Build README

You’ll need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/v1/examples>.
