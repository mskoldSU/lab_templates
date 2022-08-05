
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

        1.  Analyzes
            \|analystyp\|labb\|utforarlabb\|provtillstand\|provberedning\|forvaringskarl\|analys_metod\|analys_instrument\|
            \|———\|———\|———–\|————-\|————-\|————–\|————\|—————–\|
            \|Metall \|TestLabb \|UtLabbTest \|Bra kvalitet \|Test2
            \|Bägare \|Test3 \|Annat test \| \|Metall
            \|TestLabb2\|UtLabbTest2\|Bra2kvalitet \|Test4 \|Bägare
            \|Test5 \|Annat test 2 \|

        2.  Prover (wide) \|art \|lokal \|Metals \|Metals_hom\|Hg
            \|Hg_hom\|SI
            \|SI_hom\|PCB\|PCB_hom\|CIC\|CIC_hom\|PBDE\|PBDE_hom\|HBCD\|HBCD_hom\|PFAS\|PFAS_hom\|Dioxin\|Dioxin_hom\|SI_för_dioxin\|SI_för_dioxin_hom\|PFAS_fiskar\|PFAS_fiskar_hom\|PAH\|PAH_hom\|Tinorganic\|Tinorganic_hom\|CLC\|CLC_hom\|BFR\|BFR_hom\|
            \|——\|———\|———–\|———-\|—\|——\|—\|——\|—\|——-\|—\|——-\|—-\|——–\|—-\|——–\|—-\|——–\|——\|———-\|————-\|—————–\|———–\|—————\|—\|——-\|———-\|————–\|—\|——-\|—\|——-\|
            \|Blåmussla\|Kvädöfjärden\|10 \|5 \|10 \|5 \|10 \|5 \|5 \|50
            \|5 \|50 \|5 \|50 \|5 \|50 \| \| \| \| \| \| \| \| \| \|75
            \| \| \| \| \| \| \| \|Blåmussla\|Nidingen \|15 \| \|15 \|
            \|15 \| \|5 \|20 \|5 \|20 \|5 \|20 \|5 \|20 \| \| \| \| \|
            \| \| \| \| \|20 \| \| \| \| \| \| \|
            \|Blåmussla\|Fjällbacka\|15 \| \|15 \| \|15 \| \|5 \|20 \|5
            \|20 \|5 \|20 \|5 \|20 \| \| \| \| \| \| \| \| \| \|20 \| \|
            \| \| \| \| \| \|Sillgrissla\|Stora Karlsö\|10 \| \|10 \|
            \|10 \| \|10 \| \|10 \| \|10 \| \|10 \| \| \|10 \| \|10 \|
            \| \| \| \| \| \| \| \| \| \| \| \| \|Fisktärna\|Tjärnö \|
            \|10 \| \|10 \| \|10 \| \|10 \| \|10 \| \|10 \| \|10 \| \|10
            \| \|10 \| \| \| \| \| \| \| \| \| \| \| \| \|
            \|Strandskata\|Tjärnö \| \|10 \| \|10 \| \|10 \| \|10 \|
            \|10 \| \|10 \| \|10 \| \|10 \| \|10 \| \| \| \| \| \| \| \|
            \| \| \| \| \| \|Aborre\|Holmöarna\|10 \| \|10 \| \|10 \|
            \|2 \|10 \|2 \|10 \|2 \|10 \|2 \|10 \|2 \|10 \| \|10 \| \|10
            \| \|10 \| \| \| \|10 \| \| \| \| \| \|Aborre\|Örefjärden\|2
            \|10 \|2 \|10 \|2 \|10 \|2 \|10 \|2 \|10 \|2 \|10 \|2 \|10
            \| \| \| \|10 \| \| \| \| \| \| \| \|10 \| \| \| \| \|
            \|Aborre\|Kvädofjärden\|10 \| \|10 \| \|10 \| \|10 \| \|10
            \| \|10 \| \|10 \| \|2 \|10 \| \|10 \| \|10 \| \|10 \| \| \|
            \|10 \| \| \| \| \| \|Sill \|Rånefjärden\|2 \|12 \|2 \|12
            \|2 \|12 \|2 \|12 \|2 \|12 \|2 \|12 \|2 \|12 \|2 \|12 \|2
            \|12 \| \| \| \| \| \| \| \| \| \| \| \| \|
            \|Strömming\|Harufjärden\|2 \|12 \|2 \|12 \|2 \|12 \|2 \|12
            \|2 \|12 \|2 \|12 \|2 \|12 \|2 \|12 \|2 \|12 \| \| \| \| \|
            \| \| \| \| \| \| \| \| \|Strömming\|Kinnbäcksfjärden\|2
            \|12 \|2 \|12 \|2 \|12 \|2 \|12 \|2 \|12 \|2 \|12 \|2 \|12
            \|2 \|12 \|2 \|12 \| \| \| \| \| \| \| \| \| \| \| \| \|
            \|Strömming\|Holmöarna\|2 \|12 \|2 \|12 \|2 \|12 \|2 \|12
            \|2 \|12 \|2 \|12 \|2 \|12 \|2 \|12 \|2 \|12 \| \| \| \| \|
            \| \| \| \| \| \| \| \| \|Strömming\|Gaviksfjärden\|2 \|12
            \|2 \|12 \|2 \|12 \|2 \|12 \|2 \|12 \|2 \|12 \|2 \|12 \|2
            \|12 \|2 \|12 \| \| \| \| \| \| \| \| \| \| \| \| \|
            \|Strömming\|Långvindsfjärden\|2 \|12 \|2 \|12 \|2 \|12 \|2
            \|12 \|2 \|12 \|2 \|12 \|2 \|12 \|2 \|12 \|2 \|12 \| \| \|
            \| \| \| \| \| \| \| \| \| \| \|Strömming\|Bottenh. Utsjö
            (51G9)\|2 \|12 \|2 \|12 \|2 \|12 \|2 \|12 \|2 \|12 \|2 \|12
            \|2 \|12 \|2 \|12 \|2 \|12 \| \| \| \| \| \| \| \| \| \| \|
            \| \| \|Strömming\|Ängskärsklubb (vår)\|2 \|12 \|2 \|12 \|2
            \|12 \|2 \|12 \|2 \|12 \|2 \|12 \|2 \|12 \|2 \|12 \|2 \|12
            \| \| \| \| \| \| \| \| \| \| \| \| \|
            \|Strömming\|Ängskärsklubb (höst)\|2 \|12 \|2 \|12 \|2 \|12
            \|2 \|12 \|2 \|12 \|2 \|12 \|2 \|12 \|2 \|12 \|2 \|12 \| \|
            \| \| \| \| \| \| \| \| \| \| \|

        3.  Matrices \|analystyp\|art \|organ \| \|———\|———\|———–\| \|Hg
            \|Blåmussla\|Lever \| \|Metals \|Blåmussla\|Muskel \| \|SI
            \|Blåmussla\|Muskel \|

        4.  Parameters \|analystyp\|parameternamn\|matenhet \|
            \|———\|————-\|———–\| \|Metall \|SI \|g / kg \|

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
