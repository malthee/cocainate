# cocainate

Keep a MacBook running with its lid closed for a limited time. `cocainate` uses macOS's `pmset disablesleep` setting and restores normal sleep when the timer ends.

## Quick install

Copy and run this one command on your Mac:

```sh
curl -fsSL https://raw.githubusercontent.com/malthee/cocainate/main/install.sh | sh -s -- --remote
```

This executes the installer from the repository's `main` branch. You can [inspect it first](install.sh) or use the manual steps below. The installer copies the command to `~/.local/bin`. If that directory is not on your `PATH`, it adds it to `~/.zshrc` or `~/.bash_profile` and asks you to open a new terminal. It does not run `sudo` or change your Mac's sleep setting.

## Manual install

```sh
git clone https://github.com/malthee/cocainate.git
cd cocainate
mkdir -p "$HOME/.local/bin"
install -m 755 cocainate "$HOME/.local/bin/cocainate"
```

If `~/.local/bin` is not on your `PATH`, add the following line to your shell startup file and open a new terminal:

```sh
export PATH="$HOME/.local/bin:$PATH"
```

## Use

Connect to your phone hotspot and unplug the charger before starting the timer:

```sh
cocainate 20m   # 20 minutes
cocainate 900s  # 900 seconds
cocainate 1h    # 1 hour
cocainate off   # restore normal sleep immediately
```

Durations require `s`, `m`, or `h` and are capped at 24 hours. The command prompts for an administrator password, verifies that sleep was disabled, and restores normal sleep when the timer finishes. Keep the Terminal session running. Press **Control-C** to end it early. Lock the screen before closing the lid if you want the Mac locked during the trip.

The sleep override is system-wide and can persist if the process is forcibly killed or the Mac restarts before cleanup. In that case, run `cocainate off` and check `pmset -g | grep SleepDisabled`; `0` or no line means normal sleep. The command refuses to start if sleep is already disabled by another app or setting.

Apple does not document this override as a supported lid-closed workflow and [recommends good ventilation](https://support.apple.com/en-us/102336) while a Mac is running. Keeping a closed Mac awake, especially in a bag, can cause heat buildup, battery drain, or hardware damage. Test it for one minute on your Mac model and macOS version, and check the Mac's temperature before putting it in a bag. `cocainate` does not establish or maintain the hotspot connection.

## Why this works

Apple's [`pmset` source](https://github.com/apple-oss-distributions/PowerManagement/blob/main/pmset/pmset.m) maps `disablesleep 1` to the system-wide `SleepDisabled` setting and `0` to normal sleep. Apple [distinguishes lid-close sleep from idle sleep](https://developer.apple.com/library/archive/qa/qa1340/_index.html), which is why `caffeinate -i` is insufficient for this use. The setting is saved to disk, so do not assume a reboot will reset it.

## License

MIT. See [LICENSE](LICENSE). Use it at your own risk. The software is provided **as is**, without warranty. The authors and copyright holders disclaim liability for claims or damage arising from its use, to the extent permitted by applicable law.
