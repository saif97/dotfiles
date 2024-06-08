import { FromKeyParam, ifApp, layer, map, mapPointingButton, rule, simlayer, ToInputSource, writeToProfile } from "karabiner.ts";

let karabinerCliPath = "'/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli' karabiner_cli";

let APP_ID_BROWSERS = ["com.google.Chrome", "com.apple.Safari"];

let APP_ID_VSCODE = "com.microsoft.VSCode";

let inputColemak: ToInputSource = { input_source_id: "com.apple.keylayout.Colemak" };
let InputAbc: ToInputSource = { input_source_id: "com.apple.keylayout.ABC" };
let inputArabic: ToInputSource = { input_source_id: "com.apple.keylayout.Arabic" };

let muteMic = 'osascript -e "set volume input volume 50"; afplay /System/Library/Sounds/Ping.aiff';
let unmuteMic = 'osascript -e "set volume input volume 0"; afplay /System/Library/Sounds/Pop.aiff';
let simlayerTimeout = 5000;

// writeToProfile("--dry-run", [
writeToProfile(
  "Goku",
  [
    layer("left⌘", "VimLayer").manipulators([
      // Indent & outdent
      map("q").to("tab", "shift"),
      map("w").toIfHeldDown("left_shift", ["option"]).toIfAlone("tab"),

      // close apps
      map("escape").to("w", ["command", "shift"]),

      // arrow keys
      mapWithAnyMod("k").to("down_arrow"),
      mapWithAnyMod("i").to("up_arrow"),
      mapWithAnyMod("j").to("left_arrow"),
      mapWithAnyMod("l").to("right_arrow"),

      // Modifiers
      mapWithAnyMod("d").to("left_option"),
      mapWithAnyMod("s").to("left_shift"),

      // delete & backspace
      mapWithAnyMod("h").to("delete_forward"),
      mapWithAnyMod("n").to("delete_or_backspace"),

      // home/ end
      mapWithAnyMod("u").to("left_arrow", ["command"]),
      mapWithAnyMod("o").to("right_arrow", ["command"]),

      // chrome stuff
      map("/").to("w", ["command"]),
      map("comma").to("tab", ["control", "shift"]),
      map("period").to("tab", ["control"]),
      map("m").to("f", ["command", "shift"]),

      // desktop switching
      map("open_bracket").to("left_arrow", ["control"]),
      map("close_bracket").to("right_arrow", ["control"]),

      // back & forward in browser & editors
      map("open_bracket", "shift").to("open_bracket", ["command"]),
      map("close_bracket", "shift").to("close_bracket", ["command"]),

      // trigger screenshot.
      map("c").to("semicolon", ["command", "option"]),
    ]),

    layer("4", "symbolLayer").manipulators([
      map("j").to("9", ["shift"]), // (
      map("k").to("0", ["shift"]), // )
      map("n").to("open_bracket"), // [
      map("m").to("close_bracket"), // ]
      map("u").to("open_bracket", ["shift"]), // {
      map("i").to("close_bracket", ["shift"]), // }
      map("semicolon").to("comma", ["shift"]), // <
      map("period").to("period", ["shift"]), // >
      map("l").to("1", ["shift"]), // !
      map("o").to("2", ["shift"]), // @
      map("h").to("3", ["shift"]), // #
      map("semicolon").to("4", ["shift"]), // $
      map("quote").to("grave_accent_and_tilde"), // `
      map("p").to("5", ["shift"]), // %
      map("b").to("7", ["shift"]), // &
      map("y").to("8", ["shift"]), // *
      map("spacebar").to("hyphen", ["shift"]), // _
    ]),

    layer("0", "MediaLayer").manipulators([
      map("e").to("volume_up"),
      map("d").to("volume_down"),
      map("s").to("vk_consumer_previous"),
      map("f").to("vk_consumer_next"),
      map("a").to("vk_consumer_play"),
      map("g").to("a", ["option", "shift"]), // to toggle dark reader on / off in chrome
      map("r").to("vk_consumer_brightness_up"),
      map("w").to("vk_consumer_brightness_down"),
      map("t").to("up_arrow", ["control"]),
      map("v").to("down_arrow", ["control"]),
      map("y").toInputSource(inputColemak),
      map("h").toInputSource(inputArabic),

      // Mute & unmute mic
      map("1").to$(muteMic),
      map("q").to$(unmuteMic),
    ]),

    layer("2", "NumLayer").manipulators([
      map("u").to("7"),
      map("i").to("8"),
      map("o").to("9"),
      map("j").to("4"),
      map("k").to("5"),
      map("l").to("6"),
      map("n").to("1"),
      map("m").to("2"),
      map("comma").to("3"),
      map("spacebar").to("0"),
    ]), 

    simlayer("-", undefined, simlayerTimeout).manipulators([
      map("c").to$(openApp("com.google.Chrome")),
      map("v").to$(openApp("com.microsoft.VSCode")),
      map("t").to$(openApp("com.microsoft.teams")),
      map("e").to$(openApp("com.apple.finder")),
      map("a").to$(openApp("com.google.android.studio")),
      map("x").to$(openApp("com.apple.dt.Xcode")),
      map("s").to$(openApp("com.apple.iphonesimulator")),
    ]),

    rule("General").manipulators([
      map("0", ["control", "option"])
        .toInputSource(InputAbc)
        .to$(chainCmds([switchProfile("stock"), getCmdToPlayChime(1)])),
      map("caps_lock").to("left_command"),

      // To prevent accidentally hiding windows & minimizing them. Mac doesn't have a way to disable this.
      map("m", "command").to("m", ["command", "shift"]),
      map("h", "command").to("m", ["command", "shift"]),

      mapWithAnyMod("3").to("left_shift").toIfAlone("a", ["command", "shift"]),
      mapWithAnyMod("9").to("right_shift").toIfAlone("return_or_enter"),

      mapWithAnyMod("right_command").toIfAlone("escape").toIfHeldDown("right_command").condition(ifApp(APP_ID_BROWSERS)),
      mapWithAnyMod("right_command").toIfAlone("f15").toIfHeldDown("right_command"),
      mapWithAnyMod("right_option").to("right_option", ["left_command"]).toIfAlone("f14").condition(ifApp(APP_ID_VSCODE)),
      mapWithAnyMod("right_option").to("right_option").toIfAlone("f14"),

      // in finder make enter open files
      map("return_or_enter").to("semicolon", ["command"]).condition(ifApp("com.apple.finder")),

      mapWithAnyMod("tab").toIfHeldDown("left_control").toIfAlone("tab"),
      mapWithAnyMod("right_shift").to("left_command", ["option", "shift"]).toIfAlone("f18"),

      map("1").to("left_command", ["option"]).toIfAlone("f17"), // Amethyst Mode
    ]),

    rule("Mouse configs 123").manipulators([
      //;; Switch back & forward buttons in mouse.
      mapPointingButton("button4").toPointingButton("button5"),
      mapPointingButton("button5").toPointingButton("button4"),

      //;; Switch between workspaces.
      mapPointingButton("button4", "left_control").to("left_arrow", ["control"]),
      mapPointingButton("button5", "left_control").to("right_arrow", ["control"]),

      //;;  open expose mode in macos
      mapPointingButton("button5", "left_command").to("up_arrow", ["control"]),
      mapPointingButton("button4", "left_command").to("down_arrow", ["control"]),
      //;;  Mute & unmute mic
      mapPointingButton("button5", "left_shift").to$(muteMic),
      mapPointingButton("button4", "left_shift").to$(unmuteMic),
    ]),
  ],
  {
    "basic.simultaneous_threshold_milliseconds": 30,
    "basic.to_delayed_action_delay_milliseconds": 0,
    "basic.to_if_alone_timeout_milliseconds": 500,
    "basic.to_if_held_down_threshold_milliseconds": 50,
  }
);

writeToProfile("stock", [
  rule("General").manipulators([
    map("0", ["control", "option"])
      .toInputSource(inputColemak)
      .to$(chainCmds([switchProfile("Goku"), getCmdToPlayChime(0)])),
  ]),
]);

function getCmdToPlayChime(index: number = 0) {
  let cmd = "afplay /System/Library/Sounds/";
  switch (index) {
    case 0:
      cmd += "Blow.aiff";
      break;
    case 1:
      cmd += "Glass.aiff";
      break;
    default:
      break;
  }

  return cmd;
}

function chainCmds(cmds: string[]): string {
  return cmds.join(" ; ");
}

function switchProfile(profileName: string): string {
  return `${karabinerCliPath} --select-profile '${profileName}'`;
}

function mapWithAnyMod(key: FromKeyParam) {
  return map(key, null, "any");
}

function openApp(appId: string) {
  return `open -b ${appId}`;
}
