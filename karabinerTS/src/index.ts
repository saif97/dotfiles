// Docs: https://karabiner.ts.evanliu.dev/

import {
	duoLayer,
	FromAndToKeyCode,
	FromKeyParam,
	ifApp,
	ifDevice,
	ifVar,
	layer,
	map,
	mapPointingButton,
	rule,
	ToInputSource,
	withCondition,
	writeToProfile,
} from "karabiner.ts";

const karabinerCliPath = "'/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli' karabiner_cli";

const APP_ID_BROWSERS = ["com.google.Chrome", "com.apple.Safari", "org.mozilla.firefox"];
const APP_ID_TERMINALS = ["com.mitchellh.ghostty", "com.googlecode.iterm2", "dev.warp.Warp-Stable"];

const APP_ID_FIREFOX = "org.mozilla.firefox";
const APP_ID_VSCODE = "com.microsoft.VSCode";
const APP_ID_CURSOR = "com.todesktop.230313mzl4w4u92";
const inputColemak: ToInputSource = { input_source_id: "com.apple.keylayout.Colemak" };
const InputAbc: ToInputSource = { input_source_id: "com.apple.keylayout.ABC" };
const inputArabic: ToInputSource = { input_source_id: "com.apple.keylayout.Arabic" };

const muteMic = 'osascript -e "set volume input volume 50"; afplay /System/Library/Sounds/Ping.aiff';
const unmuteMic = 'osascript -e "set volume input volume 0"; afplay /System/Library/Sounds/Pop.aiff';
const simlayerTimeout = 5000;

const personalMachine = { product_id: 0x0340, vendor_id: 0x05ac };

const rightLetterPad: FromAndToKeyCode[][] = [
	["u", "i", "o", "p"],
	["j", "k", "l", "semicolon"],
	["n", "m", "comma", "period"],
];

// writeToProfile("--dry-run", [ 
writeToProfile(
	"Goku",
	[
		duoLayer("left⌘", "e", "amethyst_throw_mode").manipulators(rightLetterPad.flat().map((key) => map(key).to(key, ["shift", "control"]))),

		layer("f1", "desktop_switch_mode")
			.configKey((v) => v.toIfAlone("vk_consumer_brightness_down"), true)
			.manipulators([
			// u  i  o  p     →  Desktop 9, 10, 11, 12
			// j  k  l  ;     →  Desktop 5, 6, 7, 8
			// n  m  ,  .     →  Desktop 1, 2, 3, 4
			
			map("n").to("1", ["control"]), // Desktop 1
			map("m").to("2", ["control"]), // Desktop 2
			map("comma").to("3", ["control"]), // Desktop 3
			map("period").to("4", ["control"]), // Desktop 4
			map("j").to("5", ["control"]), // Desktop 5
			map("k").to("6", ["control"]), // Desktop 6
			map("l").to("7", ["control"]), // Desktop 7
			map("semicolon").to("8", ["control"]), // Desktop 8
			map("u").to("9", ["control"]), // Desktop 9
			map("i").to("0", ["control"]), // Desktop 10
			map("o").to("1", ["control", "option"]), // Desktop 11
			map("p").to("2", ["control", "option"]), // Desktop 12
		]),

		layer("left⌘", "VimLayer").manipulators([
			withCondition(
				ifVar("amethyst_throw_mode").unless(),
				ifVar("amethyst_focus_mode").unless(),
			)([
				map("tab").to("tab", ["shift"]),
				map("escape").to("w", ["command", "shift"]),
				// arrow keys
				mapWithAnyMod("k").to("down_arrow"),
				mapWithAnyMod("i").to("up_arrow"),
				mapWithAnyMod("j").to("left_arrow"),
				mapWithAnyMod("l").to("right_arrow"),

				// Modifiers
				mapWithAnyMod("d").to("left_option"),
				mapWithAnyMod("s").to("left_shift"),

				map("n", "option").to("w", "control").condition(ifApp(APP_ID_TERMINALS)),

				// delete & backspace
				mapWithAnyMod("h").to("delete_forward"),
				mapWithAnyMod("n").to("delete_or_backspace"),

				// home/ end
				mapWithAnyMod("u").to("left_arrow", ["command"]).condition(ifApp(APP_ID_TERMINALS).unless()),
				mapWithAnyMod("o").to("right_arrow", ["command"]).condition(ifApp(APP_ID_TERMINALS).unless()),
				mapWithAnyMod("u").to("home").condition(ifApp(APP_ID_TERMINALS)),
				mapWithAnyMod("o").to("end").condition(ifApp(APP_ID_TERMINALS)),

				// general browser stuff
				map("/").to("w", ["command"]),
				map("m").to("f", ["command", "shift"]),

				// Chrome only shortcuts 
				map("comma").to("tab", ["control", "shift"]).condition(ifApp([...APP_ID_TERMINALS, APP_ID_FIREFOX]).unless()),
				map("period").to("tab", ["control"]).condition(ifApp([...APP_ID_TERMINALS, APP_ID_FIREFOX]).unless()),

				// Fireforx only shortcuts 
				map("comma").to("page_up", ["control"]).condition(ifApp(APP_ID_FIREFOX)),
				map("period").to("page_down", ["control"]).condition(ifApp(APP_ID_FIREFOX)),

				// Nvim stuff
				map("comma").to("comma", ["control"]).condition(ifApp(APP_ID_TERMINALS)),
				map("period").to("period", ["control"]).condition(ifApp(APP_ID_TERMINALS)),

				// desktop switching
				map("open_bracket").to("left_arrow", ["control"]),
				map("close_bracket").to("right_arrow", ["control"]),

				// back & forward in browser & editors
				map("open_bracket", "shift").to("open_bracket", ["command"]),
				map("close_bracket", "shift").to("close_bracket", ["command"]),

				// trigger screenshot.
				map("c").to("4", ["command", "control", "shift"]),
			]),
		]),

		layer("4", "symbolLayer")
			.configKey((v) => v.toIfAlone("b", ["control"]), true)
			.manipulators([
				map("u").to("[", ['shift']), // {
				map("i").to("]", ["shift"]), // }
				map("j").to("9", ["shift"]), // (
				map("k").to("0", ["shift"]), // )
				map("l").to("1", ["shift"]), // ! i for !
				map("n").to("7", ["shift"]), // &
				map("o").to("5", ["shift"]), // %
				map("semicolon").to("2", ["shift"]), // @ O for @
				map("h").to("3", ["shift"]), // #
				map("r").to("5", ["shift"]), // % Percent
				map("period").to("8", ["shift"]), // . for times 
				map("m").to("grave_accent_and_tilde", ["shift"]), // hoMe ~
				map("quote").to("grave_accent_and_tilde"), // `
				map("spacebar").to("hyphen", ["shift"]), // _
			]),

		layer("0", "MediaLayer")
			.configKey((v) => v.toIfAlone("0"), true)
			.manipulators([
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

		layer("2", "NumLayer")
			.configKey((v) => v.toIfAlone("2"), true)
			.manipulators([
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

		//duoLayer("right⌘", "l").manipulators([
		//// Personal machine specific
		//withCondition(ifDevice(personalMachine))([map("f").to$(openApp("com.TickTick.task.mac"))]),

		//// Work machine specific
		//withCondition(ifDevice(personalMachine).unless())([
		//map("f").to$(openApp("com.microsoft.teams2")),
		//map("g").to$(openApp("com.google.android.studio")),
		//map("x").to$(openApp("com.apple.dt.Xcode")),
		//map("d").to$(openApp("com.apple.iphonesimulator")),
		//]),
		//map("c").to$(openApp("com.google.Chrome")),
		//map("v").to$(openApp("com.todesktop.230313mzl4w4u92")), // Cursor AI
		//map("e").to$(openApp("com.apple.finder")),
		//]),

		rule("General").manipulators([
			map("0", ["control", "option"])
				.toInputSource(InputAbc)
				.to$(chainCmds([switchProfile("stock"), getCmdToPlayChime(1)])),
			map("caps_lock").to("left_command"),

			// To prevent accidentally hiding windows & minimizing them. Mac doesn't have a way to disable this.
			map("m", "command").to("m", ["command", "shift"]),
			map("h", "command").to("m", ["command", "shift"]),

			// Fix ctrl-i / tab issue
			map("l", "control").to("l", ["command", "shift"]).condition(ifApp(APP_ID_TERMINALS)),

			mapWithAnyMod("3").to("left_shift").toIfAlone("b", ["control"]).condition(ifApp(APP_ID_TERMINALS)),
			mapWithAnyMod("3").to("left_shift").toIfAlone("a", ["command", "shift"]),
			mapWithAnyMod("9").to("right_shift").toIfAlone("return_or_enter"),
			// map("-").toHyper().toIfAlone("-"),

			mapWithAnyMod("right_command")
				.toIfAlone("escape")
				.toIfHeldDown("right_command")
				.condition(ifApp(APP_ID_BROWSERS.concat(APP_ID_TERMINALS).concat(APP_ID_CURSOR))),
			mapWithAnyMod("right_command").toIfAlone("f15").toIfHeldDown("right_command"),
			mapWithAnyMod("right_option").to("right_option", ["left_command"]).toIfAlone("f16").condition(ifApp(APP_ID_VSCODE)),
			mapWithAnyMod("right_option").to("right_option").toIfAlone("f16"),

			// in finder make enter open files
			map("return_or_enter").to("semicolon", ["command"]).condition(ifApp("com.apple.finder")),

			mapWithAnyMod("tab").toIfHeldDown("left_control").toIfAlone("tab"),
			map("l", ["control"]).to("tab", ["control"]).condition(ifApp(APP_ID_FIREFOX)),
			map("j", ["control"]).to("tab", ["control", "shift"]).condition(ifApp(APP_ID_FIREFOX)),
			mapWithAnyMod("right_shift").to("left_command", ["option", "shift"]).toIfAlone("f18"),
			// map("v", "right_shift").to("f18").to("4"),

			map("1").to("left_command", ["option"]).toIfAlone("f17"), // Amethyst Mode

			withCondition(ifDevice(personalMachine).unless(), ifApp("com.raycast.macos"))([map("v", "command").toMeh()]),
		]),

		rule("Mouse configs 123").manipulators([
			// Switch back & forward buttons in mouse.
			mapPointingButton("button4").toPointingButton("button5"),
			mapPointingButton("button5").toPointingButton("button4"),

			// Switch between workspaces.
			mapPointingButton("button4", "left_control").to("left_arrow", ["control"]),
			mapPointingButton("button5", "left_control").to("right_arrow", ["control"]),

			//  open expose mode in macos
			mapPointingButton("button5", "left_command").to("up_arrow", ["control"]),
			mapPointingButton("button4", "left_command").to("down_arrow", ["control"]),
			//  Mute & unmute mic
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
