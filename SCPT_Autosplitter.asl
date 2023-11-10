// SCPT Autosplitter by Distro & Marius150PL.
// If there are any issues, please message Distro or Marius150PL.

state("SplinterCell2")
{
	string5 map: "SNDDSound3DDLL.dll", 0x62DCC;
	int LevelTime: "Core.dll", 0xB8F30; // Basically IGT. We use this for the run auto start.
	int missionEnd: "Engine.dll", 0x301770, 0x30, 0x0, 0x148, 0x20, 0x34, 0x540, 0xE4; // When mission fininshed, then value decrements from +- 1073450108. On mission complete screen 3147628802. Otherwise 0.
	int missionEnd2: "Core.dll", 0xBBBC8, 0x18C, 0x4, 0xAC, 0x7F4, 0x0, 0x97C; // When mission over 0. Otherwise e.g. 4294967295.
}

startup
{
	settings.Add("subsplit", true, "Subsplits");
    settings.Add("il_mode", false, "IL MODE");

    settings.SetToolTip("subsplit", "Splits on map changes in the same level, i.e. from Dili Part 1 into Dili Part 2.");
	settings.SetToolTip("il_mode", "Splits when the HUD disappears at the end of the level instead of on map change.");
}

// The run is in full RTA so we leave any kind of load removal out (at least for now).

//Run start
start {
	if (current.LevelTime > 20 || current.map == "0_0_0") return false;
	return (current.LevelTime > 2);
}

//Split on map change
split {

	if(settings["il_mode"]){
		return (current.missionEnd != 0 && old.missionEnd == 0 && current.missionEnd2 == 0 && old.missionEnd2 != 0);
	}

	// Will split on HUD disappearance in LAX Part 2.
	if(current.map == "5_1_2" && old.map != "5_1_1"){
		return (current.missionEnd != 0 && old.missionEnd == 0 && current.missionEnd2 == 0 && old.missionEnd2 != 0);
	}

	if (!settings["subsplit"] && (current.map == "1_1_2" || current.map == "2_1_2" || current.map == "3_1_2" 
		|| current.map == "3_1_3" || current.map == "4_1_2" || current.map == "4_1_3" || current.map == "4_2_2"
		|| current.map == "4_3_2")) {
        return false;
    }

	return current.map != old.map;
}

//Resets splits when loading first level
reset {
	return (current.LevelTime == 2 && current.map == "1_1_1");
}


