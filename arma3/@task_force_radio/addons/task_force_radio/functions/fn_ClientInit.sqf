//#define DEBUG_MODE_FULL

if (isNil "tf_radio_channel_name") then {
	tf_radio_channel_name = "TaskForceRadio";
};
if (isNil "tf_radio_channel_password") then {
	tf_radio_channel_password = "123";
};
if (isNil "tf_west_radio_code") then {
	tf_west_radio_code = "_bluefor";
};
if (isNil "tf_east_radio_code") then {
	tf_east_radio_code = "_opfor";
};
if (isNil "tf_guer_radio_code") then {
	tf_guer_radio_code = "_independent";

	if (([west, resistance] call BIS_fnc_areFriendly) and {!([east, resistance] call BIS_fnc_areFriendly)}) then {
		tf_guer_radio_code = "_bluefor";
	};

	if (([east, resistance] call BIS_fnc_areFriendly) and {!([west, resistance] call BIS_fnc_areFriendly)}) then {
		tf_guer_radio_code = "_opfor";
	};
};
if (isNil "TF_defaultWestBackpack") then {
	TF_defaultWestBackpack = "tf_rt1523g";
};
if (isNil "TF_defaultEastBackpack") then {
	TF_defaultEastBackpack = "tf_mr3000";
};
if (isNil "TF_defaultGuerBackpack") then {
	TF_defaultGuerBackpack = "tf_anprc155";
};

if (isNil "TF_defaultWestPersonalRadio") then {
	TF_defaultWestPersonalRadio = "tf_anprc152";
};
if (isNil "TF_defaultEastPersonalRadio") then {
	TF_defaultEastPersonalRadio = "tf_fadak";
};
if (isNil "TF_defaultGuerPersonalRadio") then {
	TF_defaultGuerPersonalRadio = "tf_anprc148jem";
};

if (isNil "TF_defaultWestRiflemanRadio") then {
	TF_defaultWestRiflemanRadio = "tf_rf7800str";
};
if (isNil "TF_defaultEastRiflemanRadio") then {
	TF_defaultEastRiflemanRadio = "tf_pnr1000a";
};
if (isNil "TF_defaultGuerRiflemanRadio") then {
	TF_defaultGuerRiflemanRadio = "tf_anprc154";
};

if (isNil "TF_defaultWestAirborneRadio") then {
	TF_defaultWestAirborneRadio = "tf_anarc210";
};
if (isNil "TF_defaultEastAirborneRadio") then {
	TF_defaultEastAirborneRadio = "tf_mr6000l";
};
if (isNil "TF_defaultGuerAirborneRadio") then {
	TF_defaultGuerAirborneRadio = "tf_anarc164";
};

if (isNil "TF_terrain_interception_coefficient") then {
	TF_terrain_interception_coefficient = 7.0;
};

disableSerialization;
#include "diary.sqf"

waitUntil {sleep 0.2;time > 0};
if (isNil "tf_no_auto_long_range_radio") then {
	if (!isNil "tf_no_auto_long_range_radio_server") then {
		tf_no_auto_long_range_radio = tf_no_auto_long_range_radio_server;
	}else{
		tf_no_auto_long_range_radio = true;
	};
};
if (isNil "TF_give_personal_radio_to_regular_soldier") then {
	if (!isNil "TF_give_personal_radio_to_regular_soldier_server") then {
		TF_give_personal_radio_to_regular_soldier = TF_give_personal_radio_to_regular_soldier_server;
	}else{
		TF_give_personal_radio_to_regular_soldier = false;
	};
};
waitUntil {sleep 0.1;!(isNull player)};
titleText [localize ("STR_init"), "PLAIN"];

#include "\task_force_radio\define.h"

#include "script.h"

TF_radio_request_mutex = false;

TF_use_saved_sw_setting = false;
TF_saved_active_sw_settings = nil;

TF_use_saved_lr_setting = false;
TF_saved_active_lr_settings = nil;

TF_MAX_SW_VOLUME = 10;
TF_MAX_LR_VOLUME = 10;
TF_MAX_DD_VOLUME = 10;

TF_dd_volume_level = 7;

TF_MIN_DD_FREQ = 32;
TF_MAX_DD_FREQ = 41;

TF_HintFnc = nil;

IDC_ANPRC152_RADIO_DIALOG_EDIT_ID = IDC_ANPRC152_EDIT;
IDC_ANPRC152_RADIO_DIALOG_ID = IDD_ANPRC152_RADIO_DIALOG;

IDC_ANPRC155_RADIO_DIALOG_EDIT_ID = IDC_ANPRC155_EDIT;
IDC_ANPRC155_RADIO_DIALOG_ID = IDD_ANPRC155_RADIO_DIALOG;

IDC_ANPRC148JEM_RADIO_DIALOG_EDIT_ID = IDC_ANPRC148JEM_EDIT;
IDC_ANPRC148JEM_RADIO_DIALOG_ID = IDD_ANPRC148JEM_RADIO_DIALOG;

IDC_FADAK_RADIO_DIALOG_EDIT_ID = IDC_FADAK_EDIT;
IDC_FADAK_RADIO_DIALOG_ID = IDD_FADAK_RADIO_DIALOG;

IDC_RT1523G_RADIO_DIALOG_EDIT_ID = IDC_RT1523G_EDIT;
IDC_RT1523G_RADIO_DIALOG_ID = IDD_RT1523G_RADIO_DIALOG;

IDC_MR3000_RADIO_DIALOG_EDIT_ID = IDC_MR3000_EDIT;
IDC_MR3000_RADIO_DIALOG_ID = IDD_MR3000_RADIO_DIALOG;

IDC_MR6000L_RADIO_DIALOG_EDIT_ID = IDC_MR6000L_EDIT;
IDC_MR6000L_RADIO_DIALOG_ID = IDD_MR6000L_RADIO_DIALOG;

IDC_ANARC164_RADIO_DIALOG_EDIT_ID = IDC_ANARC164_EDIT;
IDC_ANARC164_RADIO_DIALOG_ID = IDD_ANARC164_RADIO_DIALOG;

IDC_ANPRC210_RADIO_DIALOG_EDIT_ID = IDC_ANPRC210_EDIT;
IDC_ANPRC210_RADIO_DIALOG_ID = IDD_ANPRC210_RADIO_DIALOG;

IDC_DIDER_RADIO_DIALOG_ID = IDD_DIVER_RADIO_DIALOG;
IDC_DIVER_RADIO_EDIT_ID = IDC_DIVER_RADIO_EDIT;
IDC_DIVER_RADIO_DEPTH_ID = IDC_DIVER_RADIO_DEPTH_EDIT;

#include "keys.sqf"

TF_tangent_sw_pressed = false;
TF_tangent_lr_pressed = false;
TF_tangent_dd_pressed = false;

TF_dd_frequency = str (round (((random (TF_MAX_DD_FREQ - TF_MIN_DD_FREQ)) + TF_MIN_DD_FREQ) * TF_FREQ_ROUND_POWER) / TF_FREQ_ROUND_POWER);

TF_speak_volume_level = "normal";
TF_speak_volume_meters = 20;
TF_max_voice_volume = 60;
TF_sw_dialog_radio = nil;

TF_lr_dialog_radio = nil;
TF_lr_active_radio = nil;

tf_lastNearFrameTick = diag_tickTime;
tf_lastFarFrameTick = diag_tickTime;
tf_msPerStep = 0;

tf_nearPlayers = [];
tf_farPlayers = [];

tf_nearPlayersIndex = 0;
tf_nearPlayersProcessed = true;

tf_farPlayersIndex = 0;
tf_farPlayersProcessed = true;

tf_msNearPerStepMax = 0.025;
tf_msNearPerStepMin = 0.1;
tf_msNearPerStep = tf_msNearPerStepMax;
tf_nearUpdateTime = 0.3;

tf_msFarPerStepMax = 0.025;
tf_msFarPerStepMin = 1.00;
tf_msFarPerStep = tf_msFarPerStepMax;
tf_farUpdateTime = 3.5;

tf_lastFrequencyInfoTick = 0;
tf_lastNearPlayersUpdate = 0;

tf_lastError = false;

tf_msSpectatorPerStepMax = 0.035;

[] spawn {
	waituntil {sleep 0.1;!(IsNull (findDisplay 46))};
	// Menus
	["TFAR", "Open SW Radio Menu", ["player", [], -3, "_this call TFAR_fnc_swRadioMenu"], [TF_dialog_sw_scancode] + TF_dialog_sw_modifiers] call CBA_fnc_registerKeybindToFleximenu;
	["TFAR", "Open LR Radio Menu", ["player", [], -3, "_this call TFAR_fnc_lrRadioMenu"], [TF_dialog_lr_scancode] + TF_dialog_lr_modifiers] call CBA_fnc_registerKeybindToFleximenu;
	// SW radio keys
	["TFAR", "SW Transmit", {call TFAR_fnc_onSwTangentPressed}, [TF_tangent_sw_scancode] + TF_tangent_sw_modifiers] call cba_fnc_registerKeybind;
	["TFAR", "SW Transmit", {call TFAR_fnc_onSwTangentReleased}, [TF_tangent_sw_scancode] + TF_tangent_sw_modifiers, false, "KeyUp"] call cba_fnc_registerKeybind;
	if (TF_tangent_sw_2_scancode != 0) then {
		["TFAR", "SW Transmit Alt", {call TFAR_fnc_onSwTangentPressed}, [TF_tangent_sw_2_scancode] + TF_tangent_sw_2_modifiers] call cba_fnc_registerKeybind;
		["TFAR", "SW Transmit Alt", {call TFAR_fnc_onSwTangentReleased}, [TF_tangent_sw_2_scancode] + TF_tangent_sw_2_modifiers, false, "KeyUp"] call cba_fnc_registerKeybind;
	};
	["TFAR", "SW Transmit Additional", {call TFAR_fnc_onAdditionalSwTangentPressed}, [TF_tangent_additional_sw_scancode] + TF_tangent_additional_sw_modifiers] call cba_fnc_registerKeybind;
	["TFAR", "SW Transmit Additional", {call TFAR_fnc_onAdditionalSwTangentReleased}, [TF_tangent_additional_sw_scancode] + TF_tangent_additional_sw_modifiers, false, "KeyUp"] call cba_fnc_registerKeybind;

	["TFAR", "SW Channel 1", {[0] call TFAR_fnc_processSWChannelKeys}, [TF_sw_channel_1_scancode] + TF_sw_channel_1_modifiers] call cba_fnc_registerKeybind;
	["TFAR", "SW Channel 2", {[1] call TFAR_fnc_processSWChannelKeys}, [TF_sw_channel_2_scancode] + TF_sw_channel_2_modifiers] call cba_fnc_registerKeybind;
	["TFAR", "SW Channel 3", {[2] call TFAR_fnc_processSWChannelKeys}, [TF_sw_channel_3_scancode] + TF_sw_channel_3_modifiers] call cba_fnc_registerKeybind;
	["TFAR", "SW Channel 4", {[3] call TFAR_fnc_processSWChannelKeys}, [TF_sw_channel_4_scancode] + TF_sw_channel_4_modifiers] call cba_fnc_registerKeybind;
	["TFAR", "SW Channel 5", {[4] call TFAR_fnc_processSWChannelKeys}, [TF_sw_channel_5_scancode] + TF_sw_channel_5_modifiers] call cba_fnc_registerKeybind;
	["TFAR", "SW Channel 6", {[5] call TFAR_fnc_processSWChannelKeys}, [TF_sw_channel_6_scancode] + TF_sw_channel_6_modifiers] call cba_fnc_registerKeybind;
	["TFAR", "SW Channel 7", {[6] call TFAR_fnc_processSWChannelKeys}, [TF_sw_channel_7_scancode] + TF_sw_channel_7_modifiers] call cba_fnc_registerKeybind;
	["TFAR", "SW Channel 8", {[7] call TFAR_fnc_processSWChannelKeys}, [TF_sw_channel_8_scancode] + TF_sw_channel_8_modifiers] call cba_fnc_registerKeybind;
	
	// LR radio keys
	["TFAR", "LR Transmit", {call TFAR_fnc_onLRTangentPressed}, [TF_tangent_lr_scancode] + TF_tangent_lr_modifiers] call cba_fnc_registerKeybind;
	["TFAR", "LR Transmit", {call TFAR_fnc_onLRTangentReleased}, [TF_tangent_lr_scancode] + TF_tangent_lr_modifiers, false, "KeyUp"] call cba_fnc_registerKeybind;
	(findDisplay 46) displayAddEventHandler ["keyUp", "_this call TFAR_fnc_onLRTangentReleasedHack"];
	if (TF_tangent_lr_2_scancode != 0) then {
		["TFAR", "LR Transmit Alt", {call TFAR_fnc_onLRTangentPressed}, [TF_tangent_lr_2_scancode] + TF_tangent_lr_2_modifiers] call cba_fnc_registerKeybind;
		["TFAR", "LR Transmit Alt", {call TFAR_fnc_onLRTangentReleased}, [TF_tangent_lr_2_scancode] + TF_tangent_lr_2_modifiers, false, "KeyUp"] call cba_fnc_registerKeybind;
	};
	["TFAR", "LR Transmit Additional", {call TFAR_fnc_onAdditionalLRTangentPressed}, [TF_tangent_additional_lr_scancode] + TF_tangent_additional_lr_modifiers] call cba_fnc_registerKeybind;
	["TFAR", "LR Transmit Additional", {call TFAR_fnc_onAdditionalLRTangentReleased}, [TF_tangent_additional_lr_scancode] + TF_tangent_additional_lr_modifiers, false, "KeyUp"] call cba_fnc_registerKeybind;

	["TFAR", "LR Channel 1", {[0] call TFAR_fnc_processLRChannelKeys}, [TF_lr_channel_1_scancode] + TF_lr_channel_1_modifiers] call cba_fnc_registerKeybind;
	["TFAR", "LR Channel 2", {[1] call TFAR_fnc_processLRChannelKeys}, [TF_lr_channel_2_scancode] + TF_lr_channel_2_modifiers] call cba_fnc_registerKeybind;
	["TFAR", "LR Channel 3", {[2] call TFAR_fnc_processLRChannelKeys}, [TF_lr_channel_3_scancode] + TF_lr_channel_3_modifiers] call cba_fnc_registerKeybind;
	["TFAR", "LR Channel 4", {[3] call TFAR_fnc_processLRChannelKeys}, [TF_lr_channel_4_scancode] + TF_lr_channel_4_modifiers] call cba_fnc_registerKeybind;
	["TFAR", "LR Channel 5", {[4] call TFAR_fnc_processLRChannelKeys}, [TF_lr_channel_5_scancode] + TF_lr_channel_5_modifiers] call cba_fnc_registerKeybind;
	["TFAR", "LR Channel 6", {[5] call TFAR_fnc_processLRChannelKeys}, [TF_lr_channel_6_scancode] + TF_lr_channel_6_modifiers] call cba_fnc_registerKeybind;
	["TFAR", "LR Channel 7", {[6] call TFAR_fnc_processLRChannelKeys}, [TF_lr_channel_7_scancode] + TF_lr_channel_7_modifiers] call cba_fnc_registerKeybind;
	["TFAR", "LR Channel 8", {[7] call TFAR_fnc_processLRChannelKeys}, [TF_lr_channel_8_scancode] + TF_lr_channel_8_modifiers] call cba_fnc_registerKeybind;
	["TFAR", "LR Channel 9", {[8] call TFAR_fnc_processLRChannelKeys}, [TF_lr_channel_9_scancode] + TF_lr_channel_9_modifiers] call cba_fnc_registerKeybind;

	// DD radio keys
	["TFAR", "DD Transmit", {call TFAR_fnc_onDDTangentReleased}, [TF_tangent_dd_scancode] + TF_tangent_dd_modifiers] call cba_fnc_registerKeybind;
	["TFAR", "DD Transmit", {call TFAR_fnc_onDDTangentPressed}, [TF_tangent_dd_scancode] + TF_tangent_dd_modifiers, false, "KeyUp"] call cba_fnc_registerKeybind;
	(findDisplay 46) displayAddEventHandler ["keyUp", "_this call TFAR_fnc_onDDTangentReleasedHack"];
	if (TF_tangent_dd_2_scancode != 0) then {
		["TFAR", "DD Transmit Alt", {call TFAR_fnc_onDDTangentReleased}, [TF_tangent_dd_2_scancode] + TF_tangent_dd_2_modifiers] call cba_fnc_registerKeybind;
		["TFAR", "DD Transmit Alt", {call TFAR_fnc_onDDTangentPressed}, [TF_tangent_dd_2_scancode] + TF_tangent_dd_2_modifiers, false, "KeyUp"] call cba_fnc_registerKeybind;
	};
	["TFAR", "DD Radio Settings", {call TFAR_fnc_onDDDialogOpen}, [TF_dialog_dd_scancode] + TF_dialog_dd_modifiers] call cba_fnc_registerKeybind;
	
	// Volume and extra keys
	["TFAR", "Change Speaking Volume", {call TFAR_fnc_onSpeakVolumeChange}, [TF_speak_volume_scancode] + TF_speak_volume_modifiers] call cba_fnc_registerKeybind;
	
	["TFAR", "Cycle >> SW Radios", {["next"] call TFAR_fnc_processSWCycleKeys}, [TF_sw_cycle_next_scancode] + TF_sw_cycle_next_modifiers, false, "KeyUp"] call cba_fnc_registerKeybind;
	["TFAR", "Cycle << SW Radios", {["prev"] call TFAR_fnc_processSWCycleKeys}, [TF_sw_cycle_prev_scancode] + TF_sw_cycle_prev_modifiers, false, "KeyUp"] call cba_fnc_registerKeybind;
	["TFAR", "Cycle >> LR Radios", {["next"] call TFAR_fnc_processLRCycleKeys}, [TF_lr_cycle_next_scancode] + TF_lr_cycle_next_modifiers, false, "KeyUp"] call cba_fnc_registerKeybind;
	["TFAR", "Cycle << LR Radios", {["prev"] call TFAR_fnc_processLRCycleKeys}, [TF_lr_cycle_prev_scancode] + TF_lr_cycle_prev_modifiers, false, "KeyUp"] call cba_fnc_registerKeybind;
	
	["TFAR", "SW Stereo: Both", {[0] call TFAR_fnc_processSWStereoKeys}, [TF_sw_stereo_both_scancode] + TF_sw_stereo_both_modifiers] call cba_fnc_registerKeybind;
	["TFAR", "SW Stereo: Left", {[1] call TFAR_fnc_processSWStereoKeys}, [TF_sw_stereo_left_scancode] + TF_sw_stereo_left_modifiers] call cba_fnc_registerKeybind;
	["TFAR", "SW Stereo: Right", {[2] call TFAR_fnc_processSWStereoKeys}, [TF_sw_stereo_right_scancode] + TF_sw_stereo_right_modifiers] call cba_fnc_registerKeybind;
	
	["TFAR", "LR Stereo: Both", {[0] call TFAR_fnc_processLRStereoKeys}, [TF_lr_stereo_both_scancode] + TF_lr_stereo_both_modifiers] call cba_fnc_registerKeybind;
	["TFAR", "LR Stereo: Left", {[1] call TFAR_fnc_processLRStereoKeys}, [TF_lr_stereo_left_scancode] + TF_lr_stereo_left_modifiers] call cba_fnc_registerKeybind;
	["TFAR", "LR Stereo: Right", {[2] call TFAR_fnc_processLRStereoKeys}, [TF_lr_stereo_right_scancode] + TF_lr_stereo_right_modifiers] call cba_fnc_registerKeybind;
	
	if (isMultiplayer) then {
		call TFAR_fnc_sendVersionInfo;
		["processPlayerPositionsHandler", "onEachFrame", "TFAR_fnc_processPlayerPositions"] call BIS_fnc_addStackedEventHandler;

		player addMPEventHandler ["MPKilled", {(_this select 0) call TFAR_fnc_sendPlayerKilled}];
	};
};

TF_first_radio_request = true;
TF_last_request_time = 0;

player addEventHandler ["respawn", {call TFAR_fnc_processRespawn}];
player addEventHandler ["killed", {
	TF_use_saved_sw_setting = true;
	TF_use_saved_lr_setting = true;
	TF_first_radio_request = true;
	call TFAR_fnc_HideHint;
}];
player addEventHandler ["Take", {
    private "_class";
    _class = ConfigFile >> "CfgWeapons" >> (_this select 2);
    if (isClass _class AND {isNumber (_class >> "tf_radio")}) then {
		[(_this select 2),getPlayerUID player] call TFAR_fnc_setRadioOwner;
    };
}];
player addEventHandler ["Put", {
    private "_class";
    _class = ConfigFile >> "CfgWeapons" >> (_this select 2);
    if (isClass _class AND {isNumber (_class >> "tf_radio")}) then {
		[(_this select 2),""] call TFAR_fnc_setRadioOwner;
    };
}];

[] spawn {
	call TFAR_fnc_processRespawn;
};
TF_respawnedAt = time;

[] spawn {
	waitUntil {sleep 0.1;!(isNull player)};
	sleep 5;
	call TFAR_fnc_radioReplaceProcess;
};

[] spawn {
	waitUntil {sleep 0.1;!((isNil "TF_server_addon_version") and (time < 20))};
	if (isNil "TF_server_addon_version") then {
		hintC (localize "STR_no_server");
	} else {
		if (TF_server_addon_version != TF_ADDON_VERSION) then {
			hintC format[localize "STR_different_version", TF_server_addon_version, TF_ADDON_VERSION];
		};
	};
};
