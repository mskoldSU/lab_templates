
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

        Metadata associated with a project.

        | analystyp | labb      | utforarlabb | provtillstand | provberedning | forvaringskarl | analys_metod | analys_instrument |
        |-----------|-----------|-------------|---------------|---------------|----------------|--------------|-------------------|
        | Metall    | TestLabb  | UtLabbTest  | Bra kvalitet  | Test2         | Bägare         | Test3        | Annat test        |
        | Metall    | TestLabb2 | UtLabbTest2 | Bra2kvalitet  | Test4         | Bägare         | Test5        | Annat test 2      |

        2.  Prover (wide)

        The `_hom` column contain the size of ecah homogenate. These can
        be individually edited by lab-users later if not only 49/50
        samples were found and one of the homogenate must be decresed to
        9.

        WARNING! Uploading a new table will override all information
        regarding AccNR and ProvID that has been entered.

        | art         | lokal                 | Metals | Metals_hom | Hg  | Hg_hom | SI  | SI_hom | PCB | PCB_hom | CIC | CIC_hom | PBDE | PBDE_hom | HBCD | HBCD_hom | PFAS | PFAS_hom | Dioxin | Dioxin_hom | SI_för_dioxin | SI_för_dioxin_hom | PFAS_fiskar | PFAS_fiskar_hom | PAH | PAH_hom | Tinorganic | Tinorganic_hom | CLC | CLC_hom | BFR | BFR_hom |
        |-------------|-----------------------|--------|------------|-----|--------|-----|--------|-----|---------|-----|---------|------|----------|------|----------|------|----------|--------|------------|---------------|-------------------|-------------|-----------------|-----|---------|------------|----------------|-----|---------|-----|---------|
        | Blåmussla   | Kvädöfjärden          | 10     | 5          | 10  | 5      | 10  | 5      | 5   | 50      | 5   | 50      | 5    | 50       | 5    | 50       |      |          |        |            |               |                   |             |                 |     | 75      |            |                |     |         |     |         |
        | Blåmussla   | Nidingen              | 15     |            | 15  |        | 15  |        | 5   | 20      | 5   | 20      | 5    | 20       | 5    | 20       |      |          |        |            |               |                   |             |                 |     | 20      |            |                |     |         |     |         |
        | Blåmussla   | Fjällbacka            | 15     |            | 15  |        | 15  |        | 5   | 20      | 5   | 20      | 5    | 20       | 5    | 20       |      |          |        |            |               |                   |             |                 |     | 20      |            |                |     |         |     |         |
        | Sillgrissla | Stora Karlsö          | 10     |            | 10  |        | 10  |        | 10  |         | 10  |         | 10   |          | 10   |          |      | 10       |        | 10         |               |                   |             |                 |     |         |            |                |     |         |     |         |
        | Fisktärna   | Tjärnö                |        | 10         |     | 10     |     | 10     |     | 10      |     | 10      |      | 10       |      | 10       |      | 10       |        | 10         |               |                   |             |                 |     |         |            |                |     |         |     |         |
        | Strandskata | Tjärnö                |        | 10         |     | 10     |     | 10     |     | 10      |     | 10      |      | 10       |      | 10       |      | 10       |        | 10         |               |                   |             |                 |     |         |            |                |     |         |     |         |
        | Aborre      | Holmöarna             | 10     |            | 10  |        | 10  |        | 2   | 10      | 2   | 10      | 2    | 10       | 2    | 10       | 2    | 10       |        | 10         |               | 10                |             | 10              |     |         |            | 10             |     |         |     |         |
        | Aborre      | Örefjärden            | 2      | 10         | 2   | 10     | 2   | 10     | 2   | 10      | 2   | 10      | 2    | 10       | 2    | 10       |      |          |        | 10         |               |                   |             |                 |     |         |            | 10             |     |         |     |         |
        | Aborre      | Kvädofjärden          | 10     |            | 10  |        | 10  |        | 10  |         | 10  |         | 10   |          | 10   |          | 2    | 10       |        | 10         |               | 10                |             | 10              |     |         |            | 10             |     |         |     |         |
        | Sill        | Rånefjärden           | 2      | 12         | 2   | 12     | 2   | 12     | 2   | 12      | 2   | 12      | 2    | 12       | 2    | 12       | 2    | 12       | 2      | 12         |               |                   |             |                 |     |         |            |                |     |         |     |         |
        | Strömming   | Harufjärden           | 2      | 12         | 2   | 12     | 2   | 12     | 2   | 12      | 2   | 12      | 2    | 12       | 2    | 12       | 2    | 12       | 2      | 12         |               |                   |             |                 |     |         |            |                |     |         |     |         |
        | Strömming   | Kinnbäcksfjärden      | 2      | 12         | 2   | 12     | 2   | 12     | 2   | 12      | 2   | 12      | 2    | 12       | 2    | 12       | 2    | 12       | 2      | 12         |               |                   |             |                 |     |         |            |                |     |         |     |         |
        | Strömming   | Holmöarna             | 2      | 12         | 2   | 12     | 2   | 12     | 2   | 12      | 2   | 12      | 2    | 12       | 2    | 12       | 2    | 12       | 2      | 12         |               |                   |             |                 |     |         |            |                |     |         |     |         |
        | Strömming   | Gaviksfjärden         | 2      | 12         | 2   | 12     | 2   | 12     | 2   | 12      | 2   | 12      | 2    | 12       | 2    | 12       | 2    | 12       | 2      | 12         |               |                   |             |                 |     |         |            |                |     |         |     |         |
        | Strömming   | Långvindsfjärden      | 2      | 12         | 2   | 12     | 2   | 12     | 2   | 12      | 2   | 12      | 2    | 12       | 2    | 12       | 2    | 12       | 2      | 12         |               |                   |             |                 |     |         |            |                |     |         |     |         |
        | Strömming   | Bottenh. Utsjö (51G9) | 2      | 12         | 2   | 12     | 2   | 12     | 2   | 12      | 2   | 12      | 2    | 12       | 2    | 12       | 2    | 12       | 2      | 12         |               |                   |             |                 |     |         |            |                |     |         |     |         |
        | Strömming   | Ängskärsklubb (vår)   | 2      | 12         | 2   | 12     | 2   | 12     | 2   | 12      | 2   | 12      | 2    | 12       | 2    | 12       | 2    | 12       | 2      | 12         |               |                   |             |                 |     |         |            |                |     |         |     |         |
        | Strömming   | Ängskärsklubb (höst)  | 2      | 12         | 2   | 12     | 2   | 12     | 2   | 12      | 2   | 12      | 2    | 12       | 2    | 12       | 2    | 12       | 2      | 12         |               |                   |             |                 |     |         |            |                |     |         |     |         |

        3.  Matrices

        This table is critical to operation but allows the program to
        show the lab-users entering AccNR and ProvID which Organ is
        connected to certain combinations of species and types of
        analyzes.

        | analystyp | art       | organ  |
        |-----------|-----------|--------|
        | Hg        | Blåmussla | Lever  |
        | Metals    | Blåmussla | Muskel |
        | SI        | Blåmussla | Muskel |

        4.  Parameters

        Used for the export and specifies which substances shall be
        analyzed based on what type of analysis it is.

        | analystyp | parameternamn | matenhet |
        |-----------|---------------|----------|
        | Metall    | SI            | g / kg   |

    </details>
-   lab_management
    -   Allows the user to select a project (through the
        `project_selector` and then shows the `samples_preparation` once
        the selection has been made).
-   project_selector
    -   Allows the user to select a project. Lists all projects and
        allows one to be selected. Upon seletion it will load the
        relevant sqlite database into memory.
-   samples_preparation
    -   Shows all samples/prover in a wide format. Each cell has the
        format `X * [(~)Y]`. It means there are `X` samples, each a
        homogenate of size `Y`. If the `~` is present, it means the
        homogenates are different sizes but the largest in the group is
        `Y`. The user can select some cells and click `Set AccNR` to
        enter AccNR and ProvID, and edit the sizes of the homogenates or
        the number of samples.
-   set_accnr_and_provid
    -   Contains a checkbox called `expand`. If `expand` is not checked
        it will allow the user to enter the first AccNR and ProvID for a
        group of samples (same species and location). The app will
        automatically assign sequent AccNR and ProvID for all samples in
        the group. If multiple groups shall have the same AccNR for
        example (e.g. multiple tests are to be done on the same
        homogenates) the button `Copy AccNR from first to rest` can be
        used. It it quite self-explanatory.
    -   If `expand` is checked. It will show each sample in the group on
        a separate row, the sizes of the homogenates can be edited by
        double-clicking on it, a row (/sample) can be removed by setting
        the homogenate size to `0` and a new row can be added by
        clicking on `Add another entry for ${group}`. (OBS!) If rows are
        added, removed or the homogenate sizes are edited all AccNR and
        ProvID for that group will be cleared.
-   export
    -   This module is not yet created. The idea for it is that it will
        gather all of the relevant information from the sqlite database
        and produce. OBS! The SQLite database does not save any accnr on
        the homogenate format, these must be created with the helper
        function in `accnr_helpers` utils.

### Functions

-   generate_template
    -   No current functionality, planned to house the export modules
        data functions.
-   sqlite
    -   Holds various functions that reads and writes to the SQLite
        database.
        1.  Reads and writes entire table of credentials
        2.  Reads table of projects. Inserts new projects and updates
            information about existing project.
        3.  Reads all four tables from project file. Overrides entire
            table in project file. Functions to update accnr and provid
            for sample table in project file, insert new sample, update
            sample ‘individer_per_prov’ information, and detele sample.
        4.  Initiate database folder structure used manually when
            setting up project.

### Utils

-   long_and_wide_prover
    -   Functions to convert sample table between the wide format (that
        the users enters in `project_management` and views in
        `samples_preparation`) and the long format (that is saved in the
        database, and viewed when `set_accnr_and_provid` is expanded).
-   accnr_helpers
    -   Functions to validate if string is accnr, increase accnr (add
        number to accnr), create an accnr on the homogenate format
        (e.g. `A2022/00001-000010`), get the minimum/maximum of multiple
        accnr (this functions currently assumes the year are the same).
-   provid_helpers
    -   Functions to validate if string is provid and increase provid
        (add number to provid). These funcions are currently the same as
        the accnr functions, but were separated to allow different
        validate functions and more flexability further on.

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

## Install and Run

You can install the development version of auto.template.creation from
[GitHub](https://github.com/) and create the database folder structure
with the function `create_database_folder_structure` with:

The first time it will create a user called `user-admin`, with password
`user-admin`, that has the role `user-adimn`.

``` r
# install.packages("devtools")
devtools::install_github("mskoldSU/lab_templates", subdir = "auto.template.creation")
library(auto.template.creation)
create_database_folder_structure()
run_app()
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
