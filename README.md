# RedM respawn

Gives players the options of manually reviving or respawning when they die, after a set cooldown period.

# Example

[![Respawn](https://i.imgur.com/TlKWwDqm.jpg)](https://imgur.com/TlKWwDq)

# Requirements

- [uiprompt](https://github.com/kibook/redm-uiprompt) library

# Configuration

| Variable                | Description                                                | Default                 |
|-------------------------|------------------------------------------------------------|-------------------------|
| `Config.ReviveControl`  | Control used to revive.                                    | `0x2EAB0795` (E)        |
| `Config.RespawnControl` | Control used to respawn.                                   | `0xE30CD707` (R)        |
| `Config.ToggleControl`  | Control used to show/hide the death screen.                | `0x6DB8C62F` (Spacebar) |
| `Config.Cooldown`       | Time in milliseconds before players can revive or respawn. | `5000` (5 seconds)      |

# Commands

| Command    | Description                         |
|------------|-------------------------------------|
| `/respawn` | Respawn at the default spawn point. |
| `/revive`  | Revive yourself when dead.          |
