## Project Overview

This project consists of a collection of PowerShell scripts designed to clean and launch The Sims 3. The scripts perform several tasks to ensure a smooth gaming experience, including:

*   **Clearing Caches:** The `cclear.ps1` script clears the game's cache files, which can help resolve common issues and improve performance.
*   **Managing Game Options:** The `check_game_options.ps1` script inspects the `Options.ini` file to determine if the game is set to run in fullscreen or windowed mode.
*   **Borderless Gaming:** If the game is in windowed mode, the `clean_launch.ps1` script can automatically launch the "Borderless Gaming" application.
*   **Launching the Game:** The `clean_launch.ps1` script orchestrates the entire process, clearing the cache, checking game options, and finally launching the game's launcher.
*   **Steam Integration:** The `clean_steam.ps1` script provides a way to launch the game through Steam.
*   **Nvidia Profile Setup:** The `setup_nvidia.ps1` script helps set up an Nvidia profile for the game.

## Building and Running

This project does not require a build process. The scripts can be executed directly from a PowerShell terminal.

### Key Scripts

*   `clean_launch.ps1`: The main script to clean and launch the game.
*   `clean_steam.ps1`: Use this script to launch the game through Steam.
*   `cclear.ps1`: Clears the game's cache files.
*   `check_game_options.ps1`: Checks the game's fullscreen/windowed mode setting.
*   `setup_nvidia.ps1`: Sets up an Nvidia profile for the game.

### Running Tests

The project includes Pester tests for some of the scripts. To run the tests, you will need to have the Pester module installed. You can install it with the following command:

```powershell
Install-Module -Name Pester -Force -SkipPublisherCheck
```

Once Pester is installed, you can run the tests by executing the test files directly:

```powershell
.\check_game_options.Tests.ps1
.\setup_nvidia.Tests.ps1
.\system_utils.Tests.ps1
```

## Development Conventions

*   **Testing:** The project uses Pester for testing. When adding new functionality, it is recommended to also add corresponding tests.
*   **Style:** The scripts follow a consistent style, using comments to explain the purpose of different sections of code.
*   **Utilities:** The `system_utils.ps1` script contains helper functions that are used by other scripts. When adding new helper functions, consider adding them to this file.
