# Project Zomboid Development Tools

Development tools, configurations, templates, and build scripts for Project Zomboid mod development.

## Features

### EmmyLua

The module deploys a collection of [EmmyLua](https://emmylua.github.io/) typings for the Project Zomboid source code. See the [project page](https://github.com/asledgehammer/Umbrella) on GitHub for more information on how the typings are generated.

This project is also designed to support development in Visual Studio Code using the [EmmyLua extension](https://github.com/EmmyLua/VSCode-EmmyLua). A basic configuration file for the extension is copied to the project directory by default:

```powershell
Update-ZomboidSourceMap -Destination "$env:USERPROFILE\Zomboid\mods\ModName"
```

To skip this step, use the `-SkipConfig` switch.
