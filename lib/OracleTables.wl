(* ::Package:: *)

(* ::Title:: *)
(*Oracle Tables*)


(* ::Chapter:: *)
(*Introduction*)


(* ::Text:: *)
(*This file contains data used by the Iron Library for implementing consultations to the Oracle.*)


(* ::Chapter:: *)
(*Code*)


(* ::Section::Closed:: *)
(*Package header*)


BeginPackage["OracleTables`"];


(* ::Section::Closed:: *)
(*Public symbols*)


oracles::usage = "Association of oracle tables.";
yesNo::usage = "yesNo[yesOutcome, noOutcome] returns a Yes/No oracle table with those two outcomes.";
revealDangerCombinedTable::usage = "revealDangerCombinedTable[theme, domain] constructs the full oracle table for Reveal a Danger using the given theme and domain.";
revealDangerAlternateTable::usage = "revealDangerAlternateTable is an oracle table for Reveal a Danger with no specified theme nor domain.";
delveSiteFeatureTable::usage = "delveSiteFeatureTable[theme, domain] constructs the full oracle table for Delve features using the given theme and domain.";


(* ::Section::Closed:: *)
(*Implementation details*)


(* ::Subsection::Closed:: *)
(*Private context header*)


Begin["`Private`"]; 


(* ::Subsection::Closed:: *)
(*Oracle association*)


oracles = <||>;


(* ::Subsection::Closed:: *)
(*Pay the Price*)


oracles["Pay the Price"] = <|
	2 -> "Roll again and apply that result but make it worse. If you roll this result yet again, think of something dreadful that changes the course of your quest (Ask the Oracle if unsure).",
	5 -> "A person or community you trusted loses faith in you, or acts against you.",
	9 -> "A person or community you care about is exposed to danger.",
	16 -> "You are separated from something or someone.",
	23 -> "Your action has an unintended effect.",
	32 -> "Something of value is lost or destroyed.",
	41 -> "The current situation worsens.",
	50 -> "A new danger or foe is revealed.",
	59 -> "It causes a delay or puts you at a disadvantage.",
	68 -> "It is harmful.",
	76 -> "It is stressful.",
	85 -> "A surprising development complicates your quest.",
	90 -> "It wastes resources.",
	94 -> "It forces you to act against your best intentions.",
	98 -> "A friend, companion, or ally is put in harm\[CloseCurlyQuote]s way (or you are, if alone).",
	100 -> "Roll twice more on this table. Both results occur. If they are the same result, make it worse."
|>;


(* ::Subsection::Closed:: *)
(*Yes/No*)


yesNoOddsValues = <|
	"Almost Certain" -> 11,
	"Likely" -> 26,
	"50/50" -> 51,
	"Unlikely" -> 76,
	"Small Chance" -> 91
|>;
yesNo[odds_String] := Module[{oddsValue},
	oddsValue = yesNoOddsValues[odds];
	<|oddsValue - 1 -> "No", 100 -> "Yes"|>
];
yesNo[yesOutcome_String, noOutcome_String] := <|25 -> noOutcome, 100 -> yesOutcome|>;

oracles["Yes/No: Almost Certain"] = yesNo["Almost Certain"];
oracles["Yes/No: Likely"] = yesNo["Likely"];
oracles["Yes/No: 50/50"] = yesNo["50/50"];
oracles["Yes/No: Unlikely"] = yesNo["Unlikely"];
oracles["Yes/No: Small Chance"] = yesNo["Small Chance"];


(* ::Subsection::Closed:: *)
(*Encounter Index*)


oracles["Encounter Index"] = <|
	1 -> "Atanya: Dangerous Firstborn (Delve 112)",
	2 -> "Basilisk: Extreme Beast (Ironsworn 151)",
	5 -> "Bear: Formidable Animal (Ironsworn 147)",
	7 -> "Bladewing: Dangerous Animal (Delve 114)",
	8 -> "Blighthound: Formidable Horror (Delve 128)",
	9 -> "Blood Thorn: Dangerous Anomaly (Delve 138)",
	12 -> "Boar: Dangerous Animal (Ironsworn 148)",
	13 -> "Bog Rot: Dangerous Horror (Delve 129)",
	14 -> "Bonehorde: Extreme Horror (Delve 130)",
	16 -> "Bonewalker: Dangerous Horror (Ironsworn 157)",
	18 -> "Broken: Troublesome Ironlander (Ironsworn 138)",
	20 -> "Carrion Newt: Formidable Animal (Delve 115)",
	22 -> "Cave Lion: Formidable Animal (Delve 116)",
	23 -> "Chimera: Extreme Horror (Ironsworn 158)",
	25 -> "Chitter: Dangerous Beast (Delve 121)",
	26 -> "Circle of Stones: Dangerous Anomaly (Delve 140)",
	29 -> "Common Folk: Troublesome Ironlander (Ironsworn 139)",
	31 -> "Deep Rat: Troublesome Animal (Delve 117)",
	33 -> "Elder Beast: Extreme Beast (Ironsworn 152)",
	35 -> "Elf: Dangerous Firstborn (Ironsworn 142)",
	37 -> "Frostbound: Formidable Horror (Ironsworn 158)",
	39 -> "Gaunt: Dangerous Animal (Ironsworn 148)",
	41 -> "Giant: Extreme Firstborn (Ironsworn 143)",
	42 -> "Glimmer: Dangerous Anomaly (Delve 142)",
	43 -> "Gloom: Dangerous Anomaly (Delve 144)",
	45 -> "Gnarl: Extreme Beast (Delve 122)",
	47 -> "Harrow Spider: Dangerous Beast (Ironsworn 153)",
	49 -> "Haunt: Formidable Horror (Ironsworn 159)",
	50 -> "Hollow: Extreme Horror (Ironsworn 160)",
	53 -> "Hunter: Dangerous Ironlander (Ironsworn 139)",
	55 -> "Husk: Formidable Ironlander (Delve 110)",
	56 -> "Iron Revenant: Extreme Horror (Ironsworn 161)",
	57 -> "Iron-Wracked Beast: Formidable Beast (Delve 123)",
	58 -> "Kraken: Epic Beast (Delve 124)",
	59 -> "Leviathan: Epic Beast (Ironsworn 154)",
	60 -> "Maelstrom: Dangerous Anomaly (Delve 146)",
	62 -> "Mammoth: Extreme Beast (Ironsworn 155)",
	64 -> "Marsh Rat: Troublesome Animal (Ironsworn 149)",
	65 -> "Merrow: Dangerous Firstborn (Delve 113)",
	67 -> "Mystic: Dangerous Ironlander (Ironsworn 140)",
	69 -> "Nightmare Spider: Dangerous Animal (Delve 118)",
	71 -> "Nightspawn: Formidable Beast (Delve 125)",
	72 -> "Primordial: Extreme Firstborn (Ironsworn 144)",
	75 -> "Raider: Dangerous Ironlander (Ironsworn 140)",
	76 -> "Rhaskar: Extreme Beast (Delve 126)",
	77 -> "Shroud Crab: Troublesome Animal (Delve 119)",
	79 -> "Sodden: Formidable Horror (Ironsworn 162)",
	80 -> "Tempest: Dangerous Anomaly (Delve 148)",
	81 -> "Thrall: Dangerous Horror (Delve 131)",
	83 -> "Trog: Dangerous Animal (Delve 120)",
	85 -> "Troll: Formidable Firstborn (Ironsworn 145)",
	87 -> "Varou: Dangerous Firstborn (Ironsworn 146)",
	90 -> "Warrior: Dangerous Ironlander (Ironsworn 141)",
	91 -> "Wight: Formidable Horror (Delve 132)",
	94 -> "Wolf: Dangerous Animal (Ironsworn 150)",
	95 -> "Wyrm: Epic Beast (Delve 127)",
	97 -> "Wyvern: Extreme Beast (Ironsworn 156)",
	100 -> "Zealot: Troublesome Ironlander (Delve 111)"
|>;


(* ::Subsection::Closed:: *)
(*Harm and Stress Outcome oracles*)


(* ::Subsubsection::Closed:: *)
(*Harm Outcome*)


oracles["Harm Outcome"] = <|
	10 -> "The harm is mortal. Face Death.",
	20 -> "You are dying. You need to Heal within an hour or two, or Face Death.",
	35 -> "You are unconscious and out of action. If left alone, you come back to your senses in an hour or two. If you are vulnerable to a foe not inclined to show mercy, Face Death.",
	50 -> "You are reeling and fighting to stay conscious. If you engage in any vigorous activity (such as running or fighting) before taking a breather for a few minutes, roll on this table again (before resolving the other move).",
	100 -> "You are battered but still standing."
|>;


(* ::Subsubsection::Closed:: *)
(*Stress Outcome*)


oracles["Stress Outcome"] = <|
	10 -> "You are overwhelmed. Face Desolation.",
	25 -> "You give up. Forsake Your Vow (if possible, one relevant to the current crisis).",
	50 -> "You give in to a fear or compulsion, and act against your better instincts.",
	100 -> "You persevere."
|>;


(* ::Subsection::Closed:: *)
(*Feature base tables*)


featureBaseTables = Association[];


(* ::Subsubsection::Closed:: *)
(*Theme Feature: Ancient*)


featureBaseTables["Ancient"] = <|
	4 -> "Evidence of lost knowledge",
	8 -> "Inscrutable relics",
	12 -> "Ancient artistry or craft",
	16 -> "Preserved corpses or fossils",
	20 -> "Visions of this place in another time"
|>;


(* ::Subsubsection::Closed:: *)
(*Theme Feature: Corrupted*)


featureBaseTables["Corrupted"] = <|
	4 -> "Mystic focus or conduit",
	8 -> "Strange environmental disturbances",
	12 -> "Mystic runes or markings",
	16 -> "Blight or decay",
	20 -> "Evidence of a foul ritual"
|>;


(* ::Subsubsection::Closed:: *)
(*Theme Feature: Fortified*)


featureBaseTables["Fortified"] = <|
	4 -> "Camp or quarters",
	8 -> "Guarded location",
	12 -> "Storage or repository",
	16 -> "Work or training area",
	20 -> "Command center or leadership"
|>;


(* ::Subsubsection::Closed:: *)
(*Theme Feature: Hallowed*)


featureBaseTables["Hallowed"] = <|
	4 -> "Temple or altar",
	8 -> "Offerings or atonements",
	12 -> "Religious relic or idol",
	16 -> "Consecrated ground",
	20 -> "Dwellings or gathering place"
|>;


(* ::Subsubsection::Closed:: *)
(*Theme Feature: Haunted*)


featureBaseTables["Haunted"] = <|
	4 -> "Tomb or burial site",
	8 -> "Blood was spilled here",
	12 -> "Unnatural mists or darkness",
	16 -> "Messages from beyond the grave",
	20 -> "Apparitions of a person or event"
|>;


(* ::Subsubsection::Closed:: *)
(*Theme Feature: Infested*)


featureBaseTables["Infested"] = <|
	4 -> "Inhabited nest",
	8 -> "Abandoned nest",
	12 -> "Ravaged terrain or architecture",
	16 -> "Remains or carrion",
	20 -> "Hoarded food"
|>;


(* ::Subsubsection::Closed:: *)
(*Theme Feature: Ravaged*)


featureBaseTables["Ravaged"] = <|
	4 -> "Path of destruction",
	8 -> "Abandoned or ruined dwelling",
	12 -> "Untouched or preserved area",
	16 -> "Traces of what was lost",
	20 -> "Ill-fated victims"
|>;


(* ::Subsubsection::Closed:: *)
(*Theme Feature: Wild*)


featureBaseTables["Wild"] = <|
	4 -> "Denizen\[CloseCurlyQuote]s lair",
	8 -> "Territorial markings",
	12 -> "Impressive flora or fauna",
	16 -> "Hunting ground or watering hole",
	20 -> "Remains or carrion"
|>;


(* ::Subsubsection::Closed:: *)
(*Domain Feature: Barrow*)


featureBaseTables["Barrow"] = <|
	43 -> "Burial chambers",
	56 -> "Maze of narrow passages",
	64 -> "Shrine",
	68 -> "Stately vault",
	72 -> "Offerings to the dead",
	76 -> "Statuary or tapestries",
	80 -> "Remains of a grave robber",
	84 -> "Mass grave",
	88 -> "Exhumed corpses",
	98 -> "Something unusual or unexpected",
	99 -> "You transition into a new theme",
	100 -> "You transition into a new domain"
|>;


(* ::Subsubsection::Closed:: *)
(*Domain Feature: Cavern*)


featureBaseTables["Cavern"] = <|
	43 -> "Twisting passages",
	56 -> "Cramped caves",
	64 -> "Vast chamber",
	68 -> "Subterranean waterway",
	72 -> "Cave pool",
	76 -> "Natural bridge",
	80 -> "Towering stone formations",
	84 -> "Natural illumination",
	88 -> "Dark pit",
	98 -> "Something unusual or unexpected",
	99 -> "You transition into a new theme",
	100 -> "You transition into a new domain"
|>;


(* ::Subsubsection::Closed:: *)
(*Domain Feature: Frozen Cavern*)


featureBaseTables["Frozen Cavern"] = <|
	43 -> "Maze of icy tunnels",
	56 -> "Glistening cave",
	64 -> "Vast chamber",
	68 -> "Frigid waterway",
	72 -> "Icy pools",
	76 -> "Magnificent ice formations",
	80 -> "Frozen waterfall",
	84 -> "Deep crevasses",
	88 -> "Discovery locked in the ice",
	98 -> "Something unusual or unexpected",
	99 -> "You transition into a new theme",
	100 -> "You transition into a new domain"
|>;


(* ::Subsubsection::Closed:: *)
(*Domain Feature: Icereach*)


featureBaseTables["Icereach"] = <|
	43 -> "Plains of ice and snow",
	56 -> "Seawater channel",
	64 -> "Icy highlands",
	68 -> "Crevasse",
	72 -> "Ice floes",
	76 -> "Ship trapped in ice",
	80 -> "Animal herd or habitat",
	84 -> "Frozen carcass",
	88 -> "Camp or outpost",
	98 -> "Something unusual or unexpected",
	99 -> "You transition into a new theme",
	100 -> "You transition into a new domain"
|>;


(* ::Subsubsection::Closed:: *)
(*Domain Feature: Mine*)


featureBaseTables["Mine"] = <|
	43 -> "Cramped tunnels",
	56 -> "Mine works",
	64 -> "Excavated chamber",
	68 -> "Mineshaft",
	72 -> "Collapsed tunnel",
	76 -> "Cluttered storage",
	80 -> "Housing or common areas",
	84 -> "Flooded chamber",
	88 -> "Unearthed secret",
	98 -> "Something unusual or unexpected",
	99 -> "You transition into a new theme",
	100 -> "You transition into a new domain"
|>;


(* ::Subsubsection::Closed:: *)
(*Domain Feature: Pass*)


featureBaseTables["Pass"] = <|
	43 -> "Winding mountain path",
	56 -> "Snowfield or glacial rocks",
	64 -> "River gorge",
	68 -> "Crashing waterfall",
	72 -> "Highland lake",
	76 -> "Forgotten cairn",
	80 -> "Bridge",
	84 -> "Overlook",
	88 -> "Camp or outpost",
	98 -> "Something unusual or unexpected",
	99 -> "You transition into a new theme",
	100 -> "You transition into a new domain"
|>;


(* ::Subsubsection::Closed:: *)
(*Domain Feature: Ruin*)


featureBaseTables["Ruin"] = <|
	43 -> "Crumbling corridors and chambers",
	56 -> "Collapsed architecture",
	64 -> "Rubble-choked hall",
	68 -> "Courtyard",
	72 -> "Archive or library",
	76 -> "Broken statuary or fading murals",
	80 -> "Preserved vault",
	84 -> "Temple to forgotten gods",
	88 -> "Mausoleum",
	98 -> "Something unusual or unexpected",
	99 -> "You transition into a new theme",
	100 -> "You transition into a new domain"
|>;


(* ::Subsubsection::Closed:: *)
(*Domain Feature: Sea Cave*)


featureBaseTables["Sea Cave"] = <|
	43 -> "Watery tunnels",
	56 -> "Eroded chamber",
	64 -> "Flooded chamber",
	68 -> "Vast chamber",
	72 -> "Dry passages",
	76 -> "Freshwater inlet",
	80 -> "Rocky island",
	84 -> "Waterborne debris",
	88 -> "Shipwreck or boat",
	98 -> "Something unusual or unexpected",
	99 -> "You transition into a new theme",
	100 -> "You transition into a new domain"
|>;


(* ::Subsubsection::Closed:: *)
(*Domain Feature: Shadowfen*)


featureBaseTables["Shadowfen"] = <|
	43 -> "Narrow path through a fetid bog",
	56 -> "Stagnant waterway",
	64 -> "Flooded thicket",
	68 -> "Island of dry land",
	72 -> "Submerged discovery",
	76 -> "Preserved corpses",
	80 -> "Overgrown structure",
	84 -> "Tall reeds",
	88 -> "Camp or outpost",
	98 -> "Something unusual or unexpected",
	99 -> "You transition into a new theme",
	100 -> "You transition into a new domain"
|>;


(* ::Subsubsection::Closed:: *)
(*Domain Feature: Stronghold*)


featureBaseTables["Stronghold"] = <|
	43 -> "Connecting passageways",
	56 -> "Barracks or common quarters",
	64 -> "Large hall",
	68 -> "Workshop or library",
	72 -> "Command center or leadership",
	76 -> "Ladder or stairwell",
	80 -> "Storage",
	84 -> "Kitchen or larder",
	88 -> "Courtyard",
	98 -> "Something unusual or unexpected",
	99 -> "You transition into a new theme",
	100 -> "You transition into a new domain"
|>;


(* ::Subsubsection::Closed:: *)
(*Domain Feature: Tanglewood*)


featureBaseTables["Tanglewood"] = <|
	43 -> "Dense thicket",
	56 -> "Overgrown path",
	64 -> "Waterway",
	68 -> "Clearing",
	72 -> "Elder tree",
	76 -> "Brambles",
	80 -> "Overgrown structure",
	84 -> "Rocky outcrop",
	88 -> "Camp or outpost",
	98 -> "Something unusual or unexpected",
	99 -> "You transition into a new theme",
	100 -> "You transition into a new domain"
|>;


(* ::Subsubsection::Closed:: *)
(*Domain Feature: Underkeep*)


featureBaseTables["Underkeep"] = <|
	43 -> "Carved passages",
	56 -> "Hall or chamber",
	64 -> "Stairs into the depths",
	68 -> "Grand doorway or entrance",
	72 -> "Tomb or catacombs",
	76 -> "Rough-hewn cave",
	80 -> "Foundry or workshop",
	84 -> "Shrine or temple",
	88 -> "Imposing architecture or artistry",
	98 -> "Something unusual or unexpected",
	99 -> "You transition into a new theme",
	100 -> "You transition into a new domain"
|>;


(* ::Subsection::Closed:: *)
(*Danger base tables*)


dangerBaseTables = Association[];


(* ::Subsubsection::Closed:: *)
(*Theme Danger: Ancient*)


dangerBaseTables["Ancient"] = <|
	5 -> "Ancient trap",
	10 -> "Hazardous architecture or terrain",
	12 -> "Blocked or broken path",
	14 -> "Denizen protects an ancient secret",
	16 -> "Denizen reveres an ancient power",
	18 -> "Living relics of a lost age",
	20 -> "Ancient evil resurgent",
	22 -> "Warnings of a long-buried danger",
	24 -> "Ancient disease or contamination",
	26 -> "Artifact of terrible purpose",
	28 -> "Evidence of ancient wrongs",
	30 -> "Others seek power or knowledge"
|>;


(* ::Subsubsection::Closed:: *)
(*Theme Danger: Corrupted*)


dangerBaseTables["Corrupted"] = <|
	5 -> "Denizen spawned from dark magic",
	10 -> "Denizen controls dark magic",
	12 -> "Denizen corrupted by dark magic",
	14 -> "Corruption marks you",
	16 -> "Innocents held in thrall",
	18 -> "Revelations of a terrible truth",
	20 -> "Mystic trap or trigger",
	22 -> "Mystic barrier or ward",
	24 -> "Illusions lead you astray",
	26 -> "Dark ritual in progress",
	28 -> "Lingering effects of a dark ritual",
	30 -> "Dread harbingers of a greater magic"
|>;


(* ::Subsubsection::Closed:: *)
(*Theme Danger: Fortified*)


dangerBaseTables["Fortified"] = <|
	5 -> "Denizen patrols the area",
	10 -> "Denizen on guard",
	12 -> "Denizen ready to sound the alarm",
	14 -> "Denizen sets an ambush",
	16 -> "Denizen lures you into a trap",
	18 -> "Denizens converge on this area",
	20 -> "Pets or underlings",
	22 -> "Unexpected alliance revealed",
	24 -> "Nefarious plans revealed",
	26 -> "Unexpected leader revealed",
	28 -> "Trap",
	30 -> "Alarm trigger"
|>;


(* ::Subsubsection::Closed:: *)
(*Theme Danger: Hallowed*)


dangerBaseTables["Hallowed"] = <|
	5 -> "Denizen defends their sanctum",
	10 -> "Denizen enacts the will of their god",
	12 -> "Denizen seeks martyrdom",
	14 -> "Secret of the faith is revealed",
	16 -> "Greater purpose is revealed",
	18 -> "Unexpected disciples are revealed",
	20 -> "Divine manifestations",
	22 -> "Aspect of the faith beguiles you",
	24 -> "Unexpected leader is revealed",
	26 -> "Embodiment of a god or myth",
	28 -> "Protective ward or barrier",
	30 -> "Prophecies reveal a dark fate"
|>;


(* ::Subsubsection::Closed:: *)
(*Theme Danger: Haunted*)


dangerBaseTables["Haunted"] = <|
	5 -> "Denizen haunts this area",
	10 -> "Unsettling sounds or signs",
	12 -> "Denizen attacks without warning",
	14 -> "Denizen makes a costly demand",
	16 -> "Denizen seizes your body or mind",
	18 -> "Denizen taunts or lures you",
	20 -> "A disturbing truth is revealed",
	22 -> "Frightening visions",
	24 -> "Environment is used against you",
	26 -> "Trickery leads you astray",
	28 -> "True nature of this place is revealed",
	30 -> "Sudden, shocking manifestation"
|>;


(* ::Subsubsection::Closed:: *)
(*Theme Danger: Infested*)


dangerBaseTables["Infested"] = <|
	5 -> "Denizens swarm and attack",
	10 -> "Toxic or sickening environment",
	12 -> "Denizen stalks you",
	14 -> "Denizen takes or destroys something",
	16 -> "Denizen shows surprising cleverness",
	18 -> "Denizen guided by a greater threat",
	20 -> "Denizen blocks the path",
	22 -> "Denizen funnels you on a new path",
	24 -> "Denizen undermines the path",
	26 -> "Denizen lays in wait",
	28 -> "Trap or snare",
	30 -> "Victim\[CloseCurlyQuote]s horrible fate is revealed"
|>;


(* ::Subsubsection::Closed:: *)
(*Theme Danger: Ravaged*)


dangerBaseTables["Ravaged"] = <|
	5 -> "Precarious architecture or terrain",
	10 -> "Imminent collapse or destruction",
	12 -> "Path undermined",
	14 -> "Blocked or broken path",
	16 -> "Vestiges of a destructive force",
	18 -> "Unexpected environmental threat",
	20 -> "Echoes of a troubling past",
	22 -> "Signs of a horrible fate",
	24 -> "Denizen seeks retribution",
	26 -> "Denizen leverages the environment",
	28 -> "Denizen restores what was lost",
	30 -> "Ravages return anew"
|>;


(* ::Subsubsection::Closed:: *)
(*Theme Danger: Wild*)


dangerBaseTables["Wild"] = <|
	5 -> "Denizen hunts",
	10 -> "Denizen strikes without warning",
	12 -> "Denizen leverages the environment",
	14 -> "Denizen wields unexpected abilities",
	16 -> "Denizen guided by a greater threat",
	18 -> "Denizen protects something",
	20 -> "Hazardous terrain",
	22 -> "Weather or environmental threat",
	24 -> "Benign aspect becomes a threat",
	26 -> "Overzealous hunter",
	28 -> "Evidence of a victim\[CloseCurlyQuote]s fate",
	30 -> "Ill-fated victim in danger"
|>;


(* ::Subsubsection::Closed:: *)
(*Domain Danger: Barrow*)


dangerBaseTables["Barrow"] = <|
	33 -> "Denizen guards this area",
	36 -> "Trap",
	39 -> "Death makes its presence known",
	42 -> "Crumbling architecture",
	45 -> "Grave goods with hidden dangers"
|>;


(* ::Subsubsection::Closed:: *)
(*Domain Danger: Cavern*)


dangerBaseTables["Cavern"] = <|
	33 -> "Denizen lairs here",
	36 -> "Cave-in",
	39 -> "Flooding",
	42 -> "Perilous climb or descent",
	45 -> "Fissure or sinkhole"
|>;


(* ::Subsubsection::Closed:: *)
(*Domain Danger: Frozen Cavern*)


dangerBaseTables["Frozen Cavern"] = <|
	33 -> "Denizen lairs here",
	36 -> "Fracturing ice",
	39 -> "Crumbling chasm",
	42 -> "Bitter chill",
	45 -> "Disorienting reflections"
|>;


(* ::Subsubsection::Closed:: *)
(*Domain Danger: Icereach*)


dangerBaseTables["Icereach"] = <|
	33 -> "Denizen hunts",
	36 -> "Fragile ice above watery depths",
	39 -> "Perilous climb or descent",
	42 -> "Avalanche or icefall",
	45 -> "Foul weather"
|>;


(* ::Subsubsection::Closed:: *)
(*Domain Danger: Mine*)


dangerBaseTables["Mine"] = <|
	33 -> "Cave-in",
	36 -> "Flooding",
	39 -> "Unstable platforms or architecture",
	42 -> "Hazardous gas pocket",
	45 -> "Weakened terrain"
|>;


(* ::Subsubsection::Closed:: *)
(*Domain Danger: Pass*)


dangerBaseTables["Pass"] = <|
	33 -> "Denizen lairs here",
	36 -> "Denizen hunts",
	39 -> "Perilous climb or descent",
	42 -> "Avalanche or rockslide",
	45 -> "Foul weather"
|>;


(* ::Subsubsection::Closed:: *)
(*Domain Danger: Ruin*)


dangerBaseTables["Ruin"] = <|
	33 -> "Ancient mechanism or trap",
	36 -> "Collapsing wall or ceiling",
	39 -> "Blocked or broken passage",
	42 -> "Unstable floor above a new danger",
	45 -> "Ancient secrets best left buried"
|>;


(* ::Subsubsection::Closed:: *)
(*Domain Danger: Sea Cave*)


dangerBaseTables["Sea Cave"] = <|
	33 -> "Denizen strikes without warning",
	36 -> "Denizen lurks below",
	39 -> "Flooding",
	42 -> "Rushing current",
	45 -> "Claustrophobic squeeze"
|>;


(* ::Subsubsection::Closed:: *)
(*Domain Danger: Shadowfen*)


dangerBaseTables["Shadowfen"] = <|
	33 -> "Denizen hunts",
	36 -> "Deep water blocks the path",
	39 -> "Toxic environment",
	42 -> "Concealing or disorienting mist",
	45 -> "Hidden quagmire"
|>;


(* ::Subsubsection::Closed:: *)
(*Domain Danger: Stronghold*)


dangerBaseTables["Stronghold"] = <|
	33 -> "Blocked or guarded path",
	36 -> "Caught in the open",
	39 -> "Chokepoint",
	42 -> "Trap",
	45 -> "Alarm trigger"
|>;


(* ::Subsubsection::Closed:: *)
(*Domain Danger: Tanglewood*)


dangerBaseTables["Tanglewood"] = <|
	33 -> "Denizen hunts",
	36 -> "Denizen lairs here",
	39 -> "Trap or snare",
	42 -> "Path leads you astray",
	45 -> "Entangling plant life"
|>;


(* ::Subsubsection::Closed:: *)
(*Domain Danger: Underkeep*)


dangerBaseTables["Underkeep"] = <|
	33 -> "Ancient mechanism or trap",
	36 -> "Crumbling architecture",
	39 -> "Blocked or broken passage",
	42 -> "Artifact with a hidden danger",
	45 -> "Denizen lurks in darkness"
|>;


(* ::Subsection::Closed:: *)
(*Delving oracles*)


(* ::Subsubsection::Closed:: *)
(*Delve Site Feature*)


delveSiteFeatureTable[theme_String, domain_String] :=
	Join[featureBaseTables[theme], featureBaseTables[domain]];


(* ::Subsubsection::Closed:: *)
(*Delve the Depths Weak Hit: Edge*)


oracles["Delve the Depths Weak Hit: Edge"] = <|
	45 -> "Mark progress and Reveal a Danger.",
	65 -> "Mark progress.",
	75 -> "Choose one: Mark progress or Find an Opportunity.",
	80 -> "Take both: Mark progress and Find an Opportunity.",
	100 -> "Mark progress twice and Reveal a Danger."
|>;


(* ::Subsubsection::Closed:: *)
(*Delve the Depths Weak Hit: Shadow*)


oracles["Delve the Depths Weak Hit: Shadow"] = <|
	30 -> "Mark progress and Reveal a Danger.",
	65 -> "Mark progress.",
	90 -> "Choose one: Mark progress or Find an Opportunity.",
	99 -> "Take both: Mark progress and Find an Opportunity.",
	100 -> "Mark progress twice and Reveal a Danger."
|>;


(* ::Subsubsection::Closed:: *)
(*Delve the Depths Weak Hit: Wits*)


oracles["Delve the Depths Weak Hit: Wits"] = <|
	40 -> "Mark progress and Reveal a Danger.",
	55 -> "Mark progress.",
	80 -> "Choose one: Mark progress or Find an Opportunity.",
	99 -> "Take both: Mark progress and Find an Opportunity.",
	100 -> "Mark progress twice and Reveal a Danger."
|>;


(* ::Subsubsection::Closed:: *)
(*Find an Opportunity*)


oracles["Find an Opportunity"] = <|
	25 -> "The terrain favors you, or you find a hidden path.",
	45 -> "An aspect of the history or nature of this place is revealed.",
	57 -> "You locate a secure area.",
	68 -> "A clue offers insight or direction.",
	78 -> "You get the drop on a denizen.",
	86 -> "This area provides an opportunity to scavenge, forage, or hunt.",
	90 -> "You locate an interesting or helpful object.",
	94 -> "You are alerted to a potential threat.",
	98 -> "You encounter a denizen who might support you.",
	100 -> "You encounter a denizen in need of help."
|>;


(* ::Subsubsection::Closed:: *)
(*Reveal a Danger: Base Table*)


revealDangerBaseTable = <|
	57 -> "You encounter a hostile denizen.",
	68 -> "You face an environmental or architectural hazard.",
	76 -> "A discovery undermines or complicates your quest.",
	79 -> "You confront a harrowing situation or sensation.",
	82 -> "You face the consequences of an earlier choice or approach.",
	85 -> "Your way is blocked or trapped.",
	88 -> "A resource is diminished, broken, or lost.",
	91 -> "You face a perplexing mystery or tough choice.",
	94 -> "You lose your way or are delayed.",
	100 -> "Roll twice more on this table. Both results occur. If they are the same result, make it worse."
|>;


(* ::Subsubsection::Closed:: *)
(*Reveal a Danger: Alternate Table*)


revealDangerAlternateTable = <|
	22 -> "You encounter a hostile denizen.",
	42 -> "You face an environmental or architectural hazard.",
	58 -> "A discovery undermines or complicates your quest.",
	64 -> "You confront a harrowing situation or sensation.",
	70 -> "You face the consequences of an earlier choice or approach.",
	76 -> "Your way is blocked or trapped.",
	82 -> "A resource is diminished, broken, or lost.",
	88 -> "You face a perplexing mystery or tough choice.",
	94 -> "You lose your way or are delayed.",
	100 -> "Roll twice more on this table. Both results occur. If they are the same result, make it worse."
|>;


(* ::Subsubsection::Closed:: *)
(*Reveal a Danger: Combined Table*)


revealDangerCombinedTable[theme_String, domain_String] := Join[dangerBaseTables[theme],dangerBaseTables[domain],revealDangerBaseTable];


(* ::Subsection::Closed:: *)
(*Core oracles*)


(* ::Subsubsection::Closed:: *)
(*Core: Prompt*)


oracles["Core: Prompt"] = <|
	20 -> "Action + Theme",
	40 -> "Descriptor + Focus",
	55 -> "Action + Focus",
	70 -> "Descriptor + Theme",
	85 -> "Action + Descriptor + Focus",
	100 -> "Action + Descriptor + Theme"
|>;


(* ::Subsubsection::Closed:: *)
(*Core: Action*)


oracles["Core: Action"] = <|
	1 -> "Scheme",
	2 -> "Clash",
	3 -> "Weaken",
	4 -> "Initiate",
	5 -> "Create",
	6 -> "Swear",
	7 -> "Avenge",
	8 -> "Guard",
	9 -> "Defeat",
	10 -> "Control",
	11 -> "Break",
	12 -> "Risk",
	13 -> "Surrender",
	14 -> "Inspect",
	15 -> "Raid",
	16 -> "Evade",
	17 -> "Assault",
	18 -> "Deflect",
	19 -> "Threaten",
	20 -> "Attack",
	21 -> "Leave",
	22 -> "Preserve",
	23 -> "Manipulate",
	24 -> "Remove",
	25 -> "Eliminate",
	26 -> "Withdraw",
	27 -> "Abandon",
	28 -> "Investigate",
	29 -> "Hold",
	30 -> "Focus",
	31 -> "Uncover",
	32 -> "Breach",
	33 -> "Aid",
	34 -> "Uphold",
	35 -> "Falter",
	36 -> "Suppress",
	37 -> "Hunt",
	38 -> "Share",
	39 -> "Destroy",
	40 -> "Avoid",
	41 -> "Reject",
	42 -> "Demand",
	43 -> "Explore",
	44 -> "Bolster",
	45 -> "Seize",
	46 -> "Mourn",
	47 -> "Reveal",
	48 -> "Gather",
	49 -> "Defy",
	50 -> "Transform",
	51 -> "Persevere",
	52 -> "Serve",
	53 -> "Begin",
	54 -> "Move",
	55 -> "Coordinate",
	56 -> "Resist",
	57 -> "Await",
	58 -> "Impress",
	59 -> "Take",
	60 -> "Oppose",
	61 -> "Capture",
	62 -> "Overwhelm",
	63 -> "Challenge",
	64 -> "Acquire",
	65 -> "Protect",
	66 -> "Finish",
	67 -> "Strengthen",
	68 -> "Restore",
	69 -> "Advance",
	70 -> "Command",
	71 -> "Refuse",
	72 -> "Find",
	73 -> "Deliver",
	74 -> "Hide",
	75 -> "Fortify",
	76 -> "Betray",
	77 -> "Secure",
	78 -> "Arrive",
	79 -> "Affect",
	80 -> "Change",
	81 -> "Defend",
	82 -> "Debate",
	83 -> "Support",
	84 -> "Follow",
	85 -> "Construct",
	86 -> "Locate",
	87 -> "Endure",
	88 -> "Release",
	89 -> "Lose",
	90 -> "Reduce",
	91 -> "Escalate",
	92 -> "Distract",
	93 -> "Journey",
	94 -> "Escort",
	95 -> "Learn",
	96 -> "Communicate",
	97 -> "Depart",
	98 -> "Search",
	99 -> "Charge",
	100 -> "Summon"
|>;


(* ::Subsubsection::Closed:: *)
(*Core: Theme*)


oracles["Core: Theme"] = <|
	1 -> "Risk",
	2 -> "Ability",
	3 -> "Price",
	4 -> "Ally",
	5 -> "Battle",
	6 -> "Safety",
	7 -> "Survival",
	8 -> "Weapon",
	9 -> "Wound",
	10 -> "Shelter",
	11 -> "Leader",
	12 -> "Fear",
	13 -> "Time",
	14 -> "Duty",
	15 -> "Secret",
	16 -> "Innocence",
	17 -> "Renown",
	18 -> "Direction",
	19 -> "Death",
	20 -> "Honor",
	21 -> "Labor",
	22 -> "Solution",
	23 -> "Tool",
	24 -> "Balance",
	25 -> "Love",
	26 -> "Barrier",
	27 -> "Creation",
	28 -> "Decay",
	29 -> "Trade",
	30 -> "Bond",
	31 -> "Hope",
	32 -> "Superstition",
	33 -> "Peace",
	34 -> "Deception",
	35 -> "History",
	36 -> "World",
	37 -> "Vow",
	38 -> "Protection",
	39 -> "Nature",
	40 -> "Opinion",
	41 -> "Burden",
	42 -> "Vengeance",
	43 -> "Opportunity",
	44 -> "Faction",
	45 -> "Danger",
	46 -> "Corruption",
	47 -> "Freedom",
	48 -> "Debt",
	49 -> "Hate",
	50 -> "Possession",
	51 -> "Stranger",
	52 -> "Passage",
	53 -> "Land",
	54 -> "Creature",
	55 -> "Disease",
	56 -> "Advantage",
	57 -> "Blood",
	58 -> "Language",
	59 -> "Rumor",
	60 -> "Weakness",
	61 -> "Greed",
	62 -> "Family",
	63 -> "Resource",
	64 -> "Structure",
	65 -> "Dream",
	66 -> "Community",
	67 -> "War",
	68 -> "Portent",
	69 -> "Prize",
	70 -> "Destiny",
	71 -> "Momentum",
	72 -> "Power",
	73 -> "Memory",
	74 -> "Ruin",
	75 -> "Mysticism",
	76 -> "Rival",
	77 -> "Problem",
	78 -> "Idea",
	79 -> "Revenge",
	80 -> "Health",
	81 -> "Fellowship",
	82 -> "Enemy",
	83 -> "Religion",
	84 -> "Spirit",
	85 -> "Fame",
	86 -> "Desolation",
	87 -> "Strength",
	88 -> "Knowledge",
	89 -> "Truth",
	90 -> "Quest",
	91 -> "Pride",
	92 -> "Loss",
	93 -> "Law",
	94 -> "Path",
	95 -> "Warning",
	96 -> "Relationship",
	97 -> "Wealth",
	98 -> "Home",
	99 -> "Strategy",
	100 -> "Supply"
|>;


(* ::Subsubsection::Closed:: *)
(*Core: Descriptor*)


oracles["Core: Descriptor"] = <|
	1 -> "Small",
	2 -> "Collapsed",
	3 -> "Protected",
	4 -> "Infested",
	5 -> "Misty",
	6 -> "Towering",
	7 -> "Light",
	8 -> "Marked",
	9 -> "Crafted",
	10 -> "Remote",
	11 -> "Deep",
	12 -> "Captured",
	13 -> "Ruined",
	14 -> "Safe",
	15 -> "Precious",
	16 -> "Abandoned",
	17 -> "Inaccessible",
	18 -> "Barren",
	19 -> "Guarded",
	20 -> "Impassable",
	21 -> "Corrupted",
	22 -> "Foreboding",
	23 -> "Wild",
	24 -> "Fragile",
	25 -> "Isolated",
	26 -> "Inhabited",
	27 -> "Defended",
	28 -> "Active",
	29 -> "Bloody",
	30 -> "Dying",
	31 -> "Grim",
	32 -> "Shrouded",
	33 -> "Dead",
	34 -> "Sealed",
	35 -> "Flooded",
	36 -> "Withered",
	37 -> "Lush",
	38 -> "Fortified",
	39 -> "Beautiful",
	40 -> "Blocked",
	41 -> "Desolate",
	42 -> "Deadly",
	43 -> "Massive",
	44 -> "Hallowed",
	45 -> "Confined",
	46 -> "Unusual",
	47 -> "Mysterious",
	48 -> "Strange",
	49 -> "Depleted",
	50 -> "Crowded",
	51 -> "Fertile",
	52 -> "Diverse",
	53 -> "Sheltered",
	54 -> "Destroyed",
	55 -> "Open",
	56 -> "Exposed",
	57 -> "Contested",
	58 -> "Blighted",
	59 -> "Rugged",
	60 -> "Unnatural",
	61 -> "Secret",
	62 -> "Dark",
	63 -> "Sunken",
	64 -> "Abundant",
	65 -> "Raided",
	66 -> "Suspended",
	67 -> "Hostile",
	68 -> "Empty",
	69 -> "Overgrown",
	70 -> "Chaotic",
	71 -> "Peaceful",
	72 -> "Broken",
	73 -> "Ensnaring",
	74 -> "Frozen",
	75 -> "Ravaged",
	76 -> "Expansive",
	77 -> "Toxic",
	78 -> "High",
	79 -> "Sacred",
	80 -> "Low",
	81 -> "Forsaken",
	82 -> "Fallen",
	83 -> "Shadowy",
	84 -> "Unstable",
	85 -> "Hidden",
	86 -> "Haunted",
	87 -> "Buried",
	88 -> "Damaged",
	89 -> "Ancient",
	90 -> "Scarred",
	91 -> "Elevated",
	92 -> "Forgotten",
	93 -> "Preserved",
	94 -> "Trapped",
	95 -> "Mystic",
	96 -> "Natural",
	97 -> "Treacherous",
	98 -> "Watery",
	99 -> "Moving",
	100 -> "Foul"
|>;


(* ::Subsubsection::Closed:: *)
(*Core: Focus*)


oracles["Core: Focus"] = <|
	1 -> "Bridge",
	2 -> "Being",
	3 -> "Archive",
	4 -> "Gap",
	5 -> "Message",
	6 -> "Denizen",
	7 -> "Commodity",
	8 -> "Vegetation",
	9 -> "Rubble",
	10 -> "Rendezvous",
	11 -> "Hideaway",
	12 -> "Vault",
	13 -> "Crossing",
	14 -> "Camp",
	15 -> "Inhabitant",
	16 -> "Landscape",
	17 -> "Boundary",
	18 -> "Entry",
	19 -> "Grave",
	20 -> "Beast",
	21 -> "Construction",
	22 -> "Iron",
	23 -> "Threshold",
	24 -> "Sound",
	25 -> "Debris",
	26 -> "Monument",
	27 -> "Terrain",
	28 -> "Battlefield",
	29 -> "Stone",
	30 -> "Shortcut",
	31 -> "Symbol",
	32 -> "Ambush",
	33 -> "Water",
	34 -> "Viewpoint",
	35 -> "Environment",
	36 -> "Excavation",
	37 -> "Person",
	38 -> "Gathering",
	39 -> "Enclosure",
	40 -> "Ritual",
	41 -> "Weather",
	42 -> "Precipice",
	43 -> "Opening",
	44 -> "Rift",
	45 -> "Bones",
	46 -> "Transport",
	47 -> "Territory",
	48 -> "Clearing",
	49 -> "Hole",
	50 -> "Growth",
	51 -> "Portal",
	52 -> "Route",
	53 -> "Hazard",
	54 -> "Habitat",
	55 -> "Trail",
	56 -> "Illusion",
	57 -> "Refuge",
	58 -> "Relic",
	59 -> "Span",
	60 -> "Formation",
	61 -> "Nest",
	62 -> "Treasure",
	63 -> "Prominence",
	64 -> "Predator",
	65 -> "Trap",
	66 -> "People",
	67 -> "Tracks",
	68 -> "Combatant",
	69 -> "Storage",
	70 -> "Riches",
	71 -> "Anomaly",
	72 -> "Outpost",
	73 -> "Settlement",
	74 -> "Cultivation",
	75 -> "Craftwork",
	76 -> "Caravan",
	77 -> "Void",
	78 -> "Fire",
	79 -> "Smell",
	80 -> "Remains",
	81 -> "Artifact",
	82 -> "Energy",
	83 -> "Puzzle",
	84 -> "Equipment",
	85 -> "Discovery",
	86 -> "Apparition",
	87 -> "Remnant",
	88 -> "Guardian",
	89 -> "Shrine",
	90 -> "Barricade",
	91 -> "Insects",
	92 -> "Waterway",
	93 -> "Material",
	94 -> "Worksite",
	95 -> "Mire",
	96 -> "Lair",
	97 -> "Obstacle",
	98 -> "Wood",
	99 -> "Animal",
	100 -> "Corpse"
|>;


(* ::Subsection::Closed:: *)
(*Location oracles*)


(* ::Subsubsection::Closed:: *)
(*Location: Overland Landmark*)


oracles["Location: Overland Landmark"] = <|
	2 -> "Ruins",
	4 -> "Wall",
	6 -> "Battlefield",
	8 -> "Hovel",
	10 -> "Springs",
	12 -> "Campsite",
	14 -> "Bridge",
	16 -> "Barrow",
	18 -> "Gravesite",
	20 -> "Waterfall",
	22 -> "Cave",
	24 -> "Swamp",
	26 -> "Road",
	28 -> "Tree",
	30 -> "Pond",
	32 -> "Field",
	34 -> "Marsh",
	37 -> "Settlement",
	39 -> "Rapids",
	41 -> "Pass",
	43 -> "Trail",
	45 -> "Ridge",
	47 -> "Cliff",
	49 -> "Grove",
	51 -> "Moor",
	53 -> "Thicket",
	55 -> "River ford",
	57 -> "Valley",
	59 -> "Fjord / Ravine",
	61 -> "Foothills",
	63 -> "Lake",
	66 -> "River",
	68 -> "Forest",
	70 -> "Hill",
	72 -> "Peak",
	75 -> "Woods",
	78 -> "Stream",
	80 -> "Clearing",
	82 -> "Mine",
	84 -> "Ritual site",
	86 -> "Monument",
	88 -> "Standing stones",
	90 -> "Watchtower",
	92 -> "Sinkhole",
	94 -> "Crater",
	96 -> "Shrine",
	98 -> "Crag",
	100 -> "Anomaly"
|>;


(* ::Subsubsection::Closed:: *)
(*Location: Overland Waypoint*)


oracles["Location: Overland Waypoint"] = <|
	1 -> "A camp or settlement comes into view",
	2 -> "A long-dead corpse or skeleton lies here",
	3 -> "A herd of wildlife cuts across your path",
	4 -> "A wide river winds across the landscape",
	5 -> "Flies swarm around an enormous pile of scat",
	6 -> "A stone wall marks an old boundary line",
	7 -> "A cold fire pit hints at the passage of another traveler",
	8 -> "An unsettling silence falls over this area",
	9 -> "You discover the remnants of a ritual",
	10 -> "A crude wall or barricade marks a makeshift fortification",
	11 -> "You cross paths with a lone traveler",
	12 -> "Ash surrounds a long-cold funeral pyre",
	13 -> "A creature stands in defense of its nest or young",
	14 -> "Trinkets and offerings hang from a tree or monument",
	15 -> "A stone-framed doorway marks the entrance to a barrow mound",
	16 -> "Tracks show that others have passed this way",
	17 -> "You catch a gleam of metal in the distance",
	18 -> "A waterway cuts through the landscape",
	19 -> "A ford or ferry marks a river crossing",
	20 -> "You encounter a procession of refugees or nomads",
	21 -> "A grim marker denotes a territorial boundary",
	22 -> "A former worksite lies abandoned",
	23 -> "You hear the footfalls or stirrings of a large creature",
	24 -> "Something about this place evokes an unnerving sensation",
	25 -> "An abandoned or lifeless settlement lingers in silence",
	26 -> "The temperature shifts unnaturally",
	27 -> "A storm brews on the horizon",
	28 -> "A lake, pond, or pool reflects its surroundings",
	29 -> "This place gives you the discomforting feeling that you are being watched",
	30 -> "A rope bridge sways in the wind",
	31 -> "A broken bridge marks a now-unused crossing",
	32 -> "A series of ramshackle bridges connect high places",
	33 -> "Phantom voices or song carry on the wind",
	34 -> "A constructed bridge spans a river or gap",
	35 -> "Something about this place spurs a memory",
	36 -> "You encounter a small group of travelers",
	37 -> "You discover the aftermath of a fight or battle",
	38 -> "A recent landslide, collapse, or rockfall scars the landscape",
	39 -> "Just ahead, a column of smoke rises into the sky",
	40 -> "A cave opening is carved into the side of a hill or cliff",
	41 -> "Several gravesites are here, each marked by an earthen or stone mound",
	42 -> "An overlook offers an expansive view of the landscape ahead",
	43 -> "Nature flourishes here",
	44 -> "Abandoned construction is all that remains of a failed project",
	45 -> "Ancient ruins stand here",
	46 -> "A great tree or rocky spire stands tall above its surroundings",
	47 -> "Carrion birds circle overhead\[LongDash]a bad omen",
	48 -> "You spot the banners of an armed force on the move",
	49 -> "Mist rises from a plunging waterfall",
	50 -> "You find disturbing remains or evidence of a violent death",
	51 -> "A natural bridge spans a river or gap",
	52 -> "Mystic stones or strange pillars stand here",
	53 -> "The landscape is strewn with a maze of rocky spires",
	54 -> "Fallen trees or upturned earth mark a destructive path",
	55 -> "Cleared, cultivated, or barren ground stands apart from its surroundings",
	56 -> "The nature of the landscape or environment changes",
	57 -> "Ghostlights dance above the landscape",
	58 -> "Scorched ground marks the location of a recent fire",
	59 -> "Steam rises from bubbling pools",
	60 -> "Stones or markings form a mystic circle",
	61 -> "Creatures gather at a source of water",
	62 -> "The path ascends a hill or ridgeline",
	63 -> "Carved symbols or likenesses adorn the landscape",
	64 -> "A great flying creature circles overhead",
	65 -> "A road or trail marks a well-used path",
	66 -> "The weather shifts, a portent of things to come",
	67 -> "The skeleton of a massive animal or beast lies here",
	68 -> "A large stone bears an inscription or message",
	69 -> "A ragged banner hangs from a leaning pole",
	70 -> "A makeshift shelter or solitary home lies abandoned",
	71 -> "A large creature hunts or forages here, but pays you no heed",
	72 -> "Carrion animals pick at scattered remains",
	73 -> "You hear the sounds of a nearby battle",
	74 -> "You hear the calls of unusual wildlife",
	75 -> "A spectral manifestation appears",
	76 -> "Natural or carved steps lead up a slope or cliffside",
	77 -> "An altar, shrine, or memorial marks a hallowed place",
	78 -> "The landscape is divided by a ravine or fissure",
	79 -> "A natural oasis stands amid an otherwise ruined or barren landscape",
	80 -> "A dry riverbed or trench cuts through the landscape like a scar",
	81 -> "Nature is stunted or diseased in this place",
	82 -> "An ancient monument or statue stands here",
	83 -> "A shadowy path leads along a narrow canyon or pass",
	84 -> "Tracks or claw marks reveal the passage of a large animal or beast",
	85 -> "A caravan is camped here or passing through",
	86 -> "Laborers toil at a worksite",
	87 -> "A signal station, lookout, or tower sits on high ground",
	88 -> "Scattered stones mark a toppled structure or monument",
	89 -> "A lingering fog clings to the terrain",
	90 -> "You top a rise, and catch sight of a trailing person or creature",
	91 -> "Intricately stacked cairn stones mark a lonely gravesite or remembrance",
	92 -> "A promontory or summit rises above the landscape",
	93 -> "A wagon or cart sits abandoned",
	94 -> "A crudely-fashioned effigy watches over the surroundings",
	95 -> "A sinkhole or pit leads to unseen depths",
	96 -> "An unusual tree or rock formation stands apart from its surroundings",
	97 -> "The path descends into a valley or basin",
	98 -> "The ground is scattered with broken bones",
	99 -> "The plants here are strangely at odds with their environment",
	100 -> "Blood-spattered ground or a bloody trail mark a violent end"
|>;


(* ::Subsubsection::Closed:: *)
(*Location: Overland Peril*)


oracles["Location: Overland Peril"] = <|
	4 -> "Lingering foul weather tests your endurance",
	8 -> "A piece of important gear is damaged or broken",
	12 -> "Provisions are lost, wasted, or spoiled",
	16 -> "The weather takes a turn for the worse",
	20 -> "Rugged terrain or dense vegetation hampers your progress",
	23 -> "An injury or old pain causes trouble",
	26 -> "A cleverly camouflaged or hidden predator attacks",
	29 -> "You stumble into the lair or nest of dangerous creatures",
	32 -> "You are caught in a trap or ambush",
	35 -> "An impassable path forces a dangerous detour",
	38 -> "The path forces a treacherous crossing over a river or gap",
	41 -> "A steep cliff or precipitous drop stands in your way",
	44 -> "Confounding paths cause you to lose your way",
	47 -> "Disease or sickness takes hold",
	50 -> "You realize something important was lost or left behind",
	53 -> "You come upon a settlement or camp in crisis",
	56 -> "Someone who watches over this area makes a costly demand or threat",
	59 -> "An enemy patrol or outpost guards this area",
	62 -> "You encounter a dangerous animal or pack",
	65 -> "Insects or small creatures swarm to attack",
	68 -> "You are caught in a flood or forced to navigate a perilous waterway",
	71 -> "You encounter a fellow traveler in peril",
	74 -> "Fog or darkness hides a lurking danger",
	76 -> "You suffer the effects of toxic plants or venomous creatures",
	78 -> "You are caught within unnatural mist or darkness",
	80 -> "A companion or fellow traveler stumbles into danger",
	82 -> "Muddy ground or a quagmire threatens to drag you down",
	84 -> "You encounter a monstrous beast",
	86 -> "A deceptively peaceful location lures you into a false sense of safety",
	88 -> "Spooked creatures stampede along your path",
	90 -> "A companion or fellow traveler is injured or falls ill",
	92 -> "You face a dreadful vision or hallucination",
	94 -> "A sinkhole or pit opens beneath you",
	96 -> "A supernatural entity seeks vengeance or absolution",
	98 -> "Unstable terrain causes a rockfall or landslide",
	100 -> "Your presence triggers a spell or supernatural anomaly"
|>;


(* ::Subsubsection::Closed:: *)
(*Location: Overland Opportunity*)


oracles["Location: Overland Opportunity"] = <|
	4 -> "Ideal weather takes hold",
	8 -> "The terrain favors you",
	12 -> "There are plentiful hunting or foraging opportunities in this area",
	16 -> "A clear path leads through otherwise dangerous terrain",
	20 -> "You find an ideal location for a campsite",
	23 -> "An awe-inspiring vista offers comfort or inspiration",
	26 -> "You find a useful item",
	29 -> "A helpful traveler crosses your path",
	32 -> "An intriguing site offers opportunities for exploration",
	35 -> "A vantage point reveals a key landmark",
	38 -> "A nearby settlement flies a friendly banner",
	41 -> "Something about this journey sparks a fond or helpful memory",
	44 -> "You encounter a helpful or useful animal",
	47 -> "You encounter a friendly group of local denizens",
	50 -> "A sheltered refuge offers a place to hide, plan, or recover",
	53 -> "A monument or relic reveals something of the history of this land",
	56 -> "You find plants or herbs with potentially helpful qualities",
	59 -> "Tracks or a cooling campfire show that others have passed this way",
	62 -> "You are forewarned of a dangerous path",
	65 -> "A desolate settlement or camp offers scavenging opportunities",
	68 -> "You find an opening to distract, escape, or avoid foes",
	71 -> "A clue offers insight into a current quest or mystery",
	74 -> "You encounter a potential benefactor in need of help",
	76 -> "You learn or improve a useful skill",
	78 -> "A caravan offers the potential comforts and safety of a community",
	80 -> "You experience a helpful dream or vision",
	82 -> "The terrain offers a defensible position against a threat",
	84 -> "A supernatural entity offers helpful guidance",
	86 -> "You encounter a majestic or previously unknown creature",
	88 -> "A lurking foe unwittingly reveals themselves, giving you the drop on them",
	90 -> "You spot a friendly animal keeping pace with you\[LongDash]a good omen",
	92 -> "A signpost or marker provides guidance",
	94 -> "An otherwise dangerous predator shows benign interest in you",
	96 -> "A stone or tree bears helpful or inspiring markings from past travelers",
	98 -> "You experience a moment of fellowship or inner peace",
	100 -> "You find an object or resource of great value"
|>;


(* ::Subsubsection::Closed:: *)
(*Location: Coastal Waters Landmark*)


oracles["Location: Coastal Waters Landmark"] = <|
	4 -> "Anchorage",
	8 -> "Sargassum",
	13 -> "Wreck",
	17 -> "Harbor",
	21 -> "Beacon",
	25 -> "Shoal",
	30 -> "Fjord",
	34 -> "Estuary",
	38 -> "Sea arch",
	42 -> "Cove",
	46 -> "Bay",
	50 -> "Iceberg",
	55 -> "Island",
	59 -> "Settlement",
	63 -> "Ice shelf",
	68 -> "Sea cave",
	72 -> "Ruins",
	76 -> "Landing",
	80 -> "Kelp forest",
	84 -> "Sea stack",
	88 -> "Islet",
	92 -> "Beach",
	96 -> "Sea cliff",
	100 -> "Anomaly"
|>;


(* ::Subsubsection::Closed:: *)
(*Location: Coastal Waters Waypoint*)


oracles["Location: Coastal Waters Waypoint"] = <|
	2 -> "A wrecked ship or boat lies broken upon rocks",
	4 -> "Mist clings to a shoreline ruin",
	6 -> "Dancing ribbons of colorful lights appear in a dark sky",
	8 -> "The wind and waters are eerily calm",
	10 -> "A ship is anchored in a sheltered bay",
	12 -> "A wide river empties into the sea",
	14 -> "A large animal or beast watches from the shore",
	16 -> "A ship flounders in high seas",
	18 -> "A pod of orca glides past",
	20 -> "An abandoned settlement is partially reclaimed by the sea",
	22 -> "Waves break upon a wide rocky beach",
	24 -> "A beached ship is under repair",
	26 -> "The weather shifts, a portent of things to come",
	28 -> "A waterfall spills from a seaside bluff",
	30 -> "The skeletal ribs of an old wreck sit upon the shore",
	32 -> "Whalers or beast hunters prowl these waters in sleek ships",
	34 -> "A ruin lies half-submerged in shallow waters",
	36 -> "The water churns as a large school of fish flees a predator",
	38 -> "A bleak-looking island appears uninhabited",
	40 -> "A landed boat or ship sits upon the shore",
	42 -> "Imposing cliffs rise from the sea",
	44 -> "A dense fog clings to the water",
	46 -> "Boats and ships gather at a seaside settlement",
	48 -> "Hordes of seabirds nest upon a guano-spattered sea stack",
	50 -> "Whales crest the surface",
	52 -> "Laborers toil at a waterside worksite",
	54 -> "An ancient statue or monument stands on the shore",
	56 -> "Rocky shoals lie within shallow waters",
	58 -> "Just under the surface, a thick kelp forest dances in the current",
	60 -> "Fisher folk gather their catch",
	62 -> "A column of smoke rises from the interior of an island",
	64 -> "Gulls peck at a floating carcass",
	66 -> "A makeshift shelter or solitary home sits on the shore",
	68 -> "Darkness beckons from within a sea cave",
	70 -> "A storm gathers in the distance",
	72 -> "You spot a seaside camp or settlement",
	74 -> "Seals rest on a wave-swept rock",
	76 -> "A boat or ship comes into view",
	78 -> "The water stirs with the movement of a great creature",
	80 -> "Steep cliffs flank a narrow fjord",
	81 -> "A rogue iceberg drifts with the current",
	82 -> "A long line of ships appears on the horizon",
	83 -> "Sharks circle menacingly",
	84 -> "A capsized ship or boat drifts on the water",
	85 -> "A beacon tower glimmers with a warning flame",
	86 -> "Debris collects in a swirling eddy",
	87 -> "Eerie voices carry on the wind",
	88 -> "The temperature shifts unnaturally",
	89 -> "A shelf of glacial ice divides sea from land",
	90 -> "You spot ships engaged in a battle",
	91 -> "A lookout post or tower stands at water's edge",
	92 -> "A narrow channel leads through an icy expanse",
	93 -> "A whale corpse lies bloated on a beach",
	94 -> "A large natural arch towers over the surrounding waters",
	95 -> "A great flying creature circles overhead",
	96 -> "A bridge connects the mainland to an offshore island",
	97 -> "Mystic stones or strange pillars stand on the shore",
	98 -> "A stone fortification stands at water's edge",
	99 -> "Thickly-packed seaweed carpets the water",
	100 -> "A spectral manifestation appears"
|>;


(* ::Subsubsection::Closed:: *)
(*Location: Coastal Waters Peril*)


oracles["Location: Coastal Waters Peril"] = <|
	4 -> "Provisions are lost, wasted, or spoiled",
	8 -> "The weather takes a turn for the worse",
	12 -> "Rough seas hamper your progress",
	16 -> "Lingering foul weather tests your endurance",
	20 -> "A piece of important gear is damaged or broken",
	23 -> "Rocky shoals or shallows slow your progress",
	26 -> "Powerful currents or winds pull you off course",
	29 -> "You realize something important was lost or left behind",
	32 -> "An injury or old pain causes trouble",
	35 -> "Fog or darkness hides a lurking danger",
	38 -> "A sudden storm assails you",
	41 -> "A rogue wave crashes into you",
	44 -> "A critical component of your watercraft is lost or damaged",
	47 -> "Disease or sickness takes hold",
	50 -> "You lose your way amidst an accursed fog",
	53 -> "A ship or boat is in distress",
	56 -> "Your hull is fouled or leaking",
	59 -> "An enemy ship closes on you",
	62 -> "You are lost or off course",
	65 -> "Dangerous creatures harass your watercraft",
	68 -> "You encounter a monstrous sea creature",
	71 -> "You are trapped in frozen seas",
	74 -> "You spot a settlement or camp in crisis",
	76 -> "A flying beast attacks",
	78 -> "You are caught within unnatural mist or darkness",
	80 -> "A blockade of ships stands in your way",
	82 -> "You face a dreadful apparition or hallucination",
	84 -> "A companion or fellow traveler is injured or falls ill",
	86 -> "A supernatural entity seeks vengeance or absolution",
	88 -> "A companion or fellow traveler draws the attention of a new danger",
	90 -> "An unnatural mist or darkness surrounds you",
	92 -> "A dangerous current or whirlpool takes hold",
	94 -> "You run aground in shallow waters",
	96 -> "A maze of rocky outcroppings or ice flows forces careful navigation",
	98 -> "A companion or fellow traveler causes a delay",
	100 -> "Your presence triggers a spell or supernatural anomaly"
|>;


(* ::Subsubsection::Closed:: *)
(*Location: Coastal Waters Opportunity*)


oracles["Location: Coastal Waters Opportunity"] = <|
	5 -> "A fortuitous wind or current speeds your way",
	10 -> "Ideal weather takes hold",
	15 -> "There are plentiful fishing opportunities in these waters",
	19 -> "A desolate shoreline settlement or camp offers scavenging opportunities",
	23 -> "A nearby settlement flies a friendly banner",
	27 -> "A nearby shore offers plentiful opportunities for hunting or foraging",
	31 -> "A sheltered bay offers safe harbor",
	35 -> "An intriguing shoreline location offers opportunities for exploration",
	39 -> "You find an ideal location for a safe landing",
	43 -> "You find clear passage through otherwise perilous seas",
	47 -> "You spot a shipwreck ripe for the picking",
	51 -> "Something about this journey sparks a fond or helpful memory",
	54 -> "A clue offers insight into a current quest or mystery",
	57 -> "A friendly sea creature or bird keeps pace with you\[LongDash]a good omen",
	60 -> "A large ship offers the potential comforts and safety of a community",
	63 -> "An awe-inspiring vista offers comfort or inspiration",
	66 -> "You are forewarned of a lurking danger",
	69 -> "You encounter a helpful or useful animal",
	72 -> "You experience a moment of fellowship or inner peace",
	75 -> "You spot a friendly ship or boat",
	78 -> "A key landmark comes into view",
	81 -> "A helpful mariner crosses your path",
	84 -> "A monument or relic reveals something of the history of this area",
	87 -> "The winds or terrain offer the means to avoid a threat",
	90 -> "You learn or improve a helpful skill",
	92 -> "A supernatural entity offers helpful guidance",
	94 -> "An otherwise dangerous sea creature shows benign interest in you",
	96 -> "You encounter a majestic or previously unknown creature",
	98 -> "You experience a helpful dream or vision",
	100 -> "You spot an object or resource of great value"
|>;


(* ::Subsection::Closed:: *)
(*Settlement oracles*)


(* ::Subsubsection::Closed:: *)
(*Settlement: Type (Settled Lands)*)


oracles["Settlement: Type (Settled Lands)"] = <|
	15 -> "Stead: Tiny, self-sustaining settlement with a few family dwellings",
	25 -> "Camp: Temporary settlement for nomadic people, soldiers, or seasonal workers",
	30 -> "Outpost: Border or frontier settlement for defense, trade, or exploration",
	55 -> "Hamlet: Small settlement with a few homes, limited services, and informal leadership",
	85 -> "Village: Moderate-sized settlement with communal buildings and recognized leadership",
	100 -> "Hold: Large, fortified settlement with diverse trade skills and well-established leadership"
|>;


(* ::Subsubsection::Closed:: *)
(*Settlement: Type (Boundary Lands)*)


oracles["Settlement: Type (Boundary Lands)"] = <|
	20 -> "Stead: Tiny, self-sustaining settlement with a few family dwellings",
	35 -> "Camp: Temporary settlement for nomadic people, soldiers, or seasonal workers",
	60 -> "Outpost: Border or frontier settlement for defense, trade, or exploration",
	80 -> "Hamlet: Small settlement with a few homes, limited services, and informal leadership",
	95 -> "Village: Moderate-sized settlement with communal buildings and recognized leadership",
	100 -> "Hold: Large, fortified settlement with diverse trade skills and well-established leadership"
|>;


(* ::Subsubsection::Closed:: *)
(*Settlement: Type (Remote Lands)*)


oracles["Settlement: Type (Remote Lands)"] = <|
	25 -> "Stead: Tiny, self-sustaining settlement with a few family dwellings",
	50 -> "Camp: Temporary settlement for nomadic people, soldiers, or seasonal workers",
	75 -> "Outpost: Border or frontier settlement for defense, trade, or exploration",
	90 -> "Hamlet: Small settlement with a few homes, limited services, and informal leadership",
	98 -> "Village: Moderate-sized settlement with communal buildings and recognized leadership",
	100 -> "Hold: Large, fortified settlement with diverse trade skills and well-established leadership"
|>;


(* ::Subsubsection::Closed:: *)
(*Settlement: Condition*)


oracles["Settlement: Condition"] = <|
	5 -> "Abandoned",
	10 -> "Devastated",
	15 -> "Besieged",
	20 -> "Under construction",
	35 -> "Wretched",
	50 -> "Ramshackle",
	70 -> "Modest",
	85 -> "Well-kept",
	95 -> "Prosperous",
	100 -> "Grand"
|>;


(* ::Subsubsection::Closed:: *)
(*Settlement: Disposition*)


oracles["Settlement: Disposition"] = <|
	5 -> "Hostile",
	15 -> "Threatening",
	25 -> "Demanding",
	35 -> "Unwelcoming",
	50 -> "Wary",
	60 -> "Indifferent",
	70 -> "In need",
	80 -> "Welcoming",
	90 -> "Friendly",
	100 -> "Helpful"
|>;


(* ::Subsubsection::Closed:: *)
(*Settlement: First Look*)


oracles["Settlement: First Look"] = <|
	2 -> "At a crossroads",
	4 -> "Beacon or signal fire",
	6 -> "Boundary of standing stones",
	8 -> "Breached or collapsed wall",
	10 -> "Built among ancient ruins",
	12 -> "Built on a hill or crag",
	14 -> "Built over or beside water",
	16 -> "Carved animal motifs",
	18 -> "Central tree",
	20 -> "Building a prominent structure",
	22 -> "Decorated for a festival",
	24 -> "Dense smoke from worksites",
	26 -> "Nearby encampment",
	28 -> "Encroaching woodland",
	30 -> "Expansive fields or agriculture",
	32 -> "Large barrow mound",
	34 -> "Filled with song and music",
	36 -> "Flying a familiar banner",
	38 -> "Hastily improvised defenses",
	40 -> "Heavily armed guards",
	42 -> "Hung with charms and wards",
	44 -> "In the shadow of a terrain feature",
	46 -> "Large communal building",
	48 -> "Numerous grazing animals",
	50 -> "Protected by stout walls",
	52 -> "Ringed by a moat or ditch",
	54 -> "Sections divided by walls",
	56 -> "Watchtowers or lookouts",
	57 -> "Adorned with colorful banners",
	58 -> "Armed with heavy weapons",
	59 -> "Built into the terrain",
	60 -> "Burning pit or pyre",
	61 -> "Circling carrion birds",
	62 -> "Connected by bridges",
	63 -> "Large monolith or tower",
	64 -> "Large statue or effigy",
	65 -> "Loud laughter or merrymaking",
	66 -> "Marked with cryptic symbols",
	67 -> "Numerous comings and goings",
	68 -> "Oddly quiet",
	69 -> "One building set apart",
	70 -> "Partially abandoned",
	71 -> "Prisoners or dead on display",
	72 -> "Repairs underway",
	73 -> "Scars of an attack or disaster",
	74 -> "Shrouded by mist",
	75 -> "Signs of sickness",
	76 -> "Signs of an occupying force",
	77 -> "Signs of unrest",
	78 -> "Surrounded by fresh graves",
	79 -> "Surrounded by lush terrain",
	80 -> "Trophies of defeated foes",
	81 -> "Lush gardens",
	82 -> "Visited by large caravan or fleet",
	83 -> "Widely dispersed structures",
	84 -> "Alluring fragrances",
	85 -> "Built from unusual materials",
	86 -> "Busy marketplace",
	87 -> "Festooned with bones and skulls",
	88 -> "Flooded or waterlogged section",
	89 -> "Foul stench",
	90 -> "Partially destroyed by fire",
	91 -> "Oddly-shaped structures",
	92 -> "Old siege weapons left to rot",
	93 -> "Signs of infestation or corruption",
	94 -> "Solemn procession",
	95 -> "Hung with countless torches",
	96 -> "Eerie light or strange energies",
	97 -> "Surrounded by blighted terrain",
	98 -> "Unusual domesticated creatures",
	99 -> "Eerie chanting or keening",
	100 -> "Spectral manifestations"
|>;


(* ::Subsubsection::Closed:: *)
(*Settlement: Projects*)


oracles["Settlement: Projects"] = <|
	4 -> "Farming",
	7 -> "Celebration",
	10 -> "Conquest",
	14 -> "Religion",
	16 -> "Secrecy",
	18 -> "Debauchery",
	21 -> "Construction",
	23 -> "Evacuation",
	25 -> "Diplomacy",
	29 -> "Mysticism",
	31 -> "History",
	33 -> "Beast hunting",
	35 -> "Scavenging",
	39 -> "Brewing",
	43 -> "Defense",
	46 -> "Exploration",
	48 -> "Patrolling",
	52 -> "Mining",
	54 -> "Entertainment",
	58 -> "Herding",
	62 -> "Foraging",
	66 -> "Trade",
	70 -> "Forestry",
	74 -> "Healing",
	78 -> "Hunting or fishing",
	81 -> "Hospitality",
	85 -> "Craftwork",
	89 -> "Smithing",
	92 -> "Raiding",
	94 -> "Treasure hunting",
	96 -> "Taming",
	98 -> "Preservation",
	100 -> "Education"
|>;


(* ::Subsubsection::Closed:: *)
(*Settlement: Troubles*)


oracles["Settlement: Troubles"] = <|
	2 -> "Outsiders rejected",
	4 -> "Dangerous discovery",
	6 -> "Dreadful omens",
	8 -> "Natural disaster",
	10 -> "Old wounds reopened",
	12 -> "Important object is lost",
	14 -> "Someone is captured",
	16 -> "Mysterious phenomenon",
	18 -> "Revolt against a leader",
	20 -> "Vengeful outcast",
	22 -> "Rival settlement",
	24 -> "Nature strikes back",
	26 -> "Someone is missing",
	28 -> "Production halts",
	30 -> "Mysterious murders",
	32 -> "Debt comes due",
	34 -> "Unjust leadership",
	36 -> "Disastrous accident",
	38 -> "In league with the enemy",
	40 -> "Raiders prey on the weak",
	42 -> "Cursed past",
	44 -> "An innocent is accused",
	46 -> "Corrupted by dark magic",
	48 -> "Isolated by brutal weather",
	50 -> "Provisions are scarce",
	52 -> "Sickness run amok",
	54 -> "Allies become enemies",
	56 -> "Attack is imminent",
	58 -> "Lost caravan",
	60 -> "Dark secret revealed",
	62 -> "Urgent expedition",
	64 -> "A leader falls",
	66 -> "Families in conflict",
	68 -> "Incompetent leadership",
	70 -> "Reckless warmongering",
	72 -> "Beast on the hunt",
	74 -> "Betrayed from within",
	76 -> "Broken truce",
	78 -> "Wrathful haunt",
	80 -> "Conflict with firstborn",
	82 -> "Trade route blocked",
	84 -> "Caught in the crossfire",
	86 -> "Stranger causes discord",
	88 -> "Important event threatened",
	90 -> "Dangerous tradition",
	100 -> "Roll twice"
|>;


(* ::Subsubsection::Closed:: *)
(*Settlement: Cultural Touchstones*)


oracles["Settlement: Cultural Touchstones"] = <|
	2 -> "Austere styles",
	4 -> "Prophecy",
	6 -> "Rites of adulthood",
	8 -> "Feasting and merrymaking",
	10 -> "Gambling",
	12 -> "Code of pacifism",
	14 -> "Suspicion of outsiders",
	16 -> "Formal duels",
	18 -> "Mysticism",
	20 -> "Adherence to authority",
	22 -> "Song and dance",
	24 -> "Uncommon languages",
	26 -> "Heavily-accented speech",
	28 -> "Artistic expression",
	30 -> "Distinctive armor",
	32 -> "Bartering",
	34 -> "Long mourning periods",
	36 -> "Seasonal festivals",
	38 -> "Blood feuds",
	40 -> "Banishment of the disloyal",
	42 -> "Rigid hierarchy",
	44 -> "Unbreakable vows",
	46 -> "Communal resources",
	48 -> "Spirituality",
	50 -> "Strict laws",
	52 -> "Respect of elders",
	54 -> "Courtesy and hospitality",
	56 -> "Body modifications or tattoos",
	58 -> "Pilgrimages",
	60 -> "Superstition",
	62 -> "Ceremonies and rituals",
	64 -> "Blood debts",
	66 -> "Familial clans",
	68 -> "Isolationism and privacy",
	70 -> "Communal hunts",
	72 -> "Competitive tournaments",
	74 -> "Code of honor",
	76 -> "Storytelling",
	78 -> "Conquest and battle prowess",
	80 -> "Martyred heroes",
	82 -> "Sacred texts",
	84 -> "Rites of courtship",
	86 -> "Bonded creatures",
	88 -> "Signature weapon",
	90 -> "Hidden identities",
	92 -> "Gift-giving",
	94 -> "Animal or nature motifs",
	96 -> "Independence from authority",
	98 -> "Unusual death rites",
	100 -> "Elaborate styles"
|>;


(* ::Subsubsection::Closed:: *)
(*Settlement: Name (Category)*)


oracles["Settlement: Name (Category)"] = <|
	15 -> "Terrain Feature",
	30 -> "Key Structure",
	45 -> "Creature",
	60 -> "Historical Event",
	75 -> "Old Language",
	90 -> "Environment",
	100 -> "Something Else"
|>;


(* ::Subsubsection::Closed:: *)
(*Settlement: Name (Terrain Feature)*)


oracles["Settlement: Name (Terrain Feature)"] = <|
	10 -> "Highmount",
	20 -> "Brackwater",
	30 -> "Frostwood",
	40 -> "Redcrest",
	50 -> "Grimtree",
	60 -> "Stoneford",
	70 -> "Deepwater",
	80 -> "Whitefall",
	90 -> "Graycliff",
	100 -> "Three Rivers"
|>;


(* ::Subsubsection::Closed:: *)
(*Settlement: Name (Key Structure)*)


oracles["Settlement: Name (Key Structure)"] = <|
	10 -> "Whitebridge",
	20 -> "Lonefort",
	30 -> "Highcairn",
	40 -> "Redhall",
	50 -> "Darkwell",
	60 -> "Timberwall",
	70 -> "Stonetower",
	80 -> "Thornhall",
	90 -> "Cinderhome",
	100 -> "Fallowfield"
|>;


(* ::Subsubsection::Closed:: *)
(*Settlement: Name (Creature)*)


oracles["Settlement: Name (Creature)"] = <|
	10 -> "Ravencliff",
	20 -> "Bearmark",
	30 -> "Wolfcrag",
	40 -> "Eaglespire",
	50 -> "Wyvern's Rest",
	60 -> "Boarwood",
	70 -> "Foxhollow",
	80 -> "Elderwatch",
	90 -> "Elkfield",
	100 -> "Dragonshadow"
|>;


(* ::Subsubsection::Closed:: *)
(*Settlement: Name (Historical Event)*)


oracles["Settlement: Name (Historical Event)"] = <|
	10 -> "Swordbreak",
	20 -> "Fool's Fall",
	30 -> "Firstmeet",
	40 -> "Brokenhelm",
	50 -> "Mournhaunt",
	60 -> "Olgar's Stand",
	70 -> "Lostwater",
	80 -> "Rojirra's Lament",
	90 -> "Lastmarch",
	100 -> "Rockfall"
|>;


(* ::Subsubsection::Closed:: *)
(*Settlement: Name (Old Language)*)


oracles["Settlement: Name (Old Language)"] = <|
	10 -> "Abon",
	20 -> "Daveza",
	30 -> "Damula",
	40 -> "Essus",
	50 -> "Sina",
	60 -> "Kazeera",
	70 -> "Khazu",
	80 -> "Sova",
	90 -> "Nabuma",
	100 -> "Tiza"
|>;


(* ::Subsubsection::Closed:: *)
(*Settlement: Name (Environment)*)


oracles["Settlement: Name (Environment)"] = <|
	10 -> "Winterhome",
	20 -> "Windhaven",
	30 -> "Stormrest",
	40 -> "Bleakfrost",
	50 -> "Springtide",
	60 -> "Duskmoor",
	70 -> "Frostcrag",
	80 -> "Springbrook",
	90 -> "Icebreak",
	100 -> "Summersong"
|>;


(* ::Subsubsection::Closed:: *)
(*Settlement: Name (Something Else)*)


oracles["Settlement: Name (Something Else)"] = <|
	10 -> "Trade good (Ironhome)",
	20 -> "Old World city (New Arkesh)",
	30 -> "Founder or elder (Kei's Hall)",
	40 -> "God (Elisora)",
	50 -> "Historical item (Blackhelm)",
	60 -> "Firstborn heritage (Elfbrook)",
	70 -> "Elvish word or name (Nessana)",
	80 -> "Mythic belief or event (Ghostwalk)",
	90 -> "Positive term (Hope)",
	100 -> "Negative term (Forsaken)"
|>;


(* ::Subsubsection::Closed:: *)
(*Settlement: Quick Name (Prefix)*)


oracles["Settlement: Quick Name (Prefix)"] = <|
	4 -> "Lost- or Forge-",
	8 -> "Gloom- or Fallow-",
	12 -> "Night- or Red-",
	16 -> "Stone- or Wyrd-",
	20 -> "Bright- or Bleak-",
	24 -> "Dusk- or Wood-",
	28 -> "White- or Gray-",
	32 -> "Grim- or Draug-",
	36 -> "Wrath- or High-",
	40 -> "Sword- or Raven-",
	43 -> "Wyrm- or Deep-",
	46 -> "Shield- or Tide-",
	49 -> "Keld- or Ash-",
	52 -> "Low- or Frost-",
	55 -> "Troll- or Dark-",
	58 -> "New- or Storm-",
	61 -> "Mead- or Ember-",
	64 -> "Drift- or Flint-",
	67 -> "Wolf- or Thorn-",
	70 -> "Long- or Axe-",
	73 -> "Iron- or Black-",
	76 -> "Shale- or Nettle-",
	79 -> "Woad- or Broad-",
	82 -> "Rock- or Hearth-",
	85 -> "Murk- or Ice-",
	88 -> "Moon- or Bitter-",
	91 -> "Fire- or Great-",
	94 -> "Green- or Bear-",
	97 -> "Gold- or Skarn-",
	100 -> "Mourn- or Shade-"
|>;


(* ::Subsubsection::Closed:: *)
(*Settlement: Quick Name (Suffix)*)


oracles["Settlement: Quick Name (Suffix)"] = <|
	4 -> "-grove or -break",
	8 -> "-haven or -mire",
	12 -> "-bourne or -brook",
	16 -> "-bridge or -wick",
	20 -> "-peak or -harrow",
	24 -> "-shard or -hall",
	28 -> "-glade or -watch",
	32 -> "-hold or -well",
	36 -> "-stead or -gate",
	40 -> "-crest or -mount",
	43 -> "-rock or -ridge",
	46 -> "-fall or -ward",
	49 -> "-mark or -mere",
	52 -> "-fen or -field",
	55 -> "-barrow or -river",
	58 -> "-ford or -hill",
	61 -> "-wood or -tarn",
	64 -> "-run or -spire",
	67 -> "-croft or -scar",
	70 -> "-knoll or -roost",
	73 -> "-march or -shade",
	76 -> "-reach or -stone",
	79 -> "-bluff or -nest",
	82 -> "-holt or -pass",
	85 -> "-home or -point",
	88 -> "-hope or -vault",
	91 -> "-wark or -cairn",
	94 -> "-burrow or -hollow",
	97 -> "-glen or -moor",
	100 -> "-mist or -crag"
|>;


(* ::Subsection::Closed:: *)
(*Character oracles*)


(* ::Subsubsection::Closed:: *)
(*Character: First Look*)


oracles["Character: First Look"] = <|
	2 -> "Well-armed",
	4 -> "Alluring",
	6 -> "Mystical",
	8 -> "Pursued",
	10 -> "Beastly",
	12 -> "Stout",
	14 -> "Confused",
	16 -> "Equipped",
	18 -> "Distressed",
	20 -> "Fearsome",
	22 -> "Cloaked",
	24 -> "Guarded",
	26 -> "Commanding",
	28 -> "Weathered",
	30 -> "Unassuming",
	32 -> "Attractive",
	34 -> "Youthful",
	36 -> "Armored",
	38 -> "Drunk",
	40 -> "Silent",
	42 -> "Brutish",
	44 -> "Ghostly",
	46 -> "Sickly",
	48 -> "Accented",
	50 -> "Poised",
	52 -> "Well-mannered",
	54 -> "Menacing",
	56 -> "Filthy",
	58 -> "Wounded",
	60 -> "Mysterious",
	62 -> "Imposing",
	64 -> "Ill-equipped",
	66 -> "Scarred",
	68 -> "Slight",
	70 -> "Tattooed",
	72 -> "Grim",
	74 -> "Masked",
	76 -> "Distinguished",
	78 -> "Fit",
	80 -> "Firstborn",
	82 -> "Bloodstained",
	84 -> "Overburdened",
	86 -> "Furtive",
	88 -> "Aged",
	90 -> "Graceful",
	92 -> "Inhuman",
	94 -> "Sinister",
	96 -> "Visibly disabled",
	98 -> "Concealed",
	100 -> "Uncanny"
|>;


(* ::Subsubsection::Closed:: *)
(*Character: Activity*)


oracles["Character: Activity"] = <|
	2 -> "Guarding",
	4 -> "Preserving",
	6 -> "Constructing",
	8 -> "Mending",
	10 -> "Assisting",
	12 -> "Securing",
	14 -> "Learning",
	16 -> "Sneaking",
	18 -> "Fleeing",
	20 -> "Sacrificing",
	22 -> "Creating",
	24 -> "Luring",
	26 -> "Hunting",
	28 -> "Seizing",
	30 -> "Bargaining",
	32 -> "Mimicking",
	34 -> "Tricking",
	36 -> "Tracking",
	38 -> "Escorting",
	40 -> "Hiding",
	42 -> "Raiding",
	44 -> "Socializing",
	46 -> "Exploring",
	48 -> "Journeying",
	50 -> "Supporting",
	52 -> "Avoiding",
	54 -> "Disabling",
	56 -> "Leading",
	58 -> "Assaulting",
	60 -> "Ensnaring",
	62 -> "Defending",
	64 -> "Recovering",
	66 -> "Patrolling",
	68 -> "Resting",
	70 -> "Distracting",
	72 -> "Leaving",
	74 -> "Fighting",
	76 -> "Ambushing",
	78 -> "Controlling",
	80 -> "Observing",
	82 -> "Gathering",
	84 -> "Suffering",
	86 -> "Threatening",
	88 -> "Searching",
	90 -> "Destroying",
	92 -> "Restoring",
	94 -> "Consuming",
	96 -> "Removing",
	98 -> "Inspecting",
	100 -> "Summoning"
|>;


(* ::Subsubsection::Closed:: *)
(*Character: Disposition*)


oracles["Character: Disposition"] = <|
	6 -> "Helpful",
	13 -> "Friendly",
	20 -> "Cooperative",
	28 -> "Curious",
	36 -> "Indifferent",
	47 -> "Suspicious",
	57 -> "Wanting",
	67 -> "Desperate",
	76 -> "Demanding",
	85 -> "Unfriendly",
	93 -> "Threatening",
	100 -> "Hostile"
|>;


(* ::Subsubsection::Closed:: *)
(*Character: Role*)


oracles["Character: Role"] = <|
	2 -> "Criminal",
	4 -> "Healer",
	6 -> "Bandit",
	9 -> "Guide",
	12 -> "Performer",
	15 -> "Miner",
	18 -> "Mercenary",
	21 -> "Outcast",
	24 -> "Vagrant",
	27 -> "Forester",
	30 -> "Traveler",
	33 -> "Mystic",
	36 -> "Priest",
	39 -> "Sailor",
	42 -> "Pilgrim",
	45 -> "Thief",
	48 -> "Adventurer",
	51 -> "Forager",
	54 -> "Leader",
	58 -> "Guard",
	62 -> "Artisan",
	66 -> "Scout",
	70 -> "Herder",
	74 -> "Fisher",
	79 -> "Warrior",
	84 -> "Hunter",
	89 -> "Raider",
	94 -> "Trader",
	99 -> "Farmer",
	100 -> "Unusual role"
|>;


(* ::Subsubsection::Closed:: *)
(*Character: Goal*)


oracles["Character: Goal"] = <|
	3 -> "Obtain an object",
	6 -> "Make an agreement",
	9 -> "Build a relationship",
	12 -> "Undermine a relationship",
	15 -> "Seek a truth",
	18 -> "Pay a debt",
	21 -> "Refute a falsehood",
	24 -> "Harm a rival",
	27 -> "Cure an ill",
	30 -> "Find a person",
	33 -> "Find a home",
	36 -> "Seize power",
	39 -> "Restore a relationship",
	42 -> "Create an item",
	45 -> "Travel to a place",
	48 -> "Secure provisions",
	51 -> "Rebel against power",
	54 -> "Collect a debt",
	57 -> "Protect a secret",
	60 -> "Spread faith",
	63 -> "Enrich themselves",
	66 -> "Protect a person",
	69 -> "Protect the status quo",
	72 -> "Advance status",
	75 -> "Defend a place",
	78 -> "Avenge a wrong",
	81 -> "Fulfill a duty",
	84 -> "Gain knowledge",
	87 -> "Prove worthiness",
	90 -> "Find redemption",
	92 -> "Escape from something",
	95 -> "Resolve a dispute",
	100 -> "Roll twice"
|>;


(* ::Subsubsection::Closed:: *)
(*Character: Revealed Details*)


oracles["Character: Revealed Details"] = <|
	1 -> "Stoic",
	2 -> "Attractive",
	3 -> "Passive",
	4 -> "Aloof",
	5 -> "Affectionate",
	6 -> "Generous",
	7 -> "Smug",
	8 -> "Armed",
	9 -> "Clever",
	10 -> "Brave",
	11 -> "Ugly",
	12 -> "Sociable",
	13 -> "Doomed",
	14 -> "Connected",
	15 -> "Bold",
	16 -> "Jealous",
	17 -> "Angry",
	18 -> "Active",
	19 -> "Suspicious",
	20 -> "Hostile",
	21 -> "Hardhearted",
	22 -> "Successful",
	23 -> "Talented",
	24 -> "Experienced",
	25 -> "Deceitful",
	26 -> "Ambitious",
	27 -> "Aggressive",
	28 -> "Conceited",
	29 -> "Proud",
	30 -> "Stern",
	31 -> "Dependent",
	32 -> "Wary",
	33 -> "Strong",
	34 -> "Insightful",
	35 -> "Dangerous",
	36 -> "Quirky",
	37 -> "Cheery",
	38 -> "Disfigured",
	39 -> "Intolerant",
	40 -> "Skilled",
	41 -> "Stingy",
	42 -> "Timid",
	43 -> "Insensitive",
	44 -> "Wild",
	45 -> "Bitter",
	46 -> "Cunning",
	47 -> "Remorseful",
	48 -> "Kind",
	49 -> "Charming",
	50 -> "Oblivious",
	51 -> "Critical",
	52 -> "Cautious",
	53 -> "Resourceful",
	54 -> "Weary",
	55 -> "Wounded",
	56 -> "Anxious",
	57 -> "Powerful",
	58 -> "Athletic",
	59 -> "Driven",
	60 -> "Cruel",
	61 -> "Quiet",
	62 -> "Honest",
	63 -> "Infamous",
	64 -> "Dying",
	65 -> "Reclusive",
	66 -> "Artistic",
	67 -> "Disabled",
	68 -> "Confused",
	69 -> "Manipulative",
	70 -> "Relaxed",
	71 -> "Stealthy",
	72 -> "Confident",
	73 -> "Weak",
	74 -> "Friendly",
	75 -> "Wise",
	76 -> "Influential",
	77 -> "Young",
	78 -> "Adventurous",
	79 -> "Oppressed",
	80 -> "Vengeful",
	81 -> "Cooperative",
	82 -> "Armored",
	83 -> "Apathetic",
	84 -> "Determined",
	85 -> "Loyal",
	86 -> "Sick",
	87 -> "Religious",
	88 -> "Selfish",
	89 -> "Old",
	90 -> "Fervent",
	91 -> "Violent",
	92 -> "Agreeable",
	93 -> "Hot-tempered",
	94 -> "Stubborn",
	95 -> "Incompetent",
	96 -> "Greedy",
	97 -> "Cowardly",
	98 -> "Obsessed",
	99 -> "Careless",
	100 -> "Ironsworn"
|>;


(* ::Subsubsection::Closed:: *)
(*Character: Name (Ironlander Set 1)*)


oracles["Character: Name (Ironlander Set 1)"] = <|
	1 -> "Solana",
	2 -> "Keelan",
	3 -> "Cadigan",
	4 -> "Sola",
	5 -> "Kodroth",
	6 -> "Kione",
	7 -> "Katja",
	8 -> "Tio",
	9 -> "Artiga",
	10 -> "Eos",
	11 -> "Bastien",
	12 -> "Elli",
	13 -> "Maura",
	14 -> "Haleema",
	15 -> "Abella",
	16 -> "Morter",
	17 -> "Wulan",
	18 -> "Mai",
	19 -> "Farina",
	20 -> "Pearce",
	21 -> "Wynne",
	22 -> "Haf",
	23 -> "Aeddon",
	24 -> "Khinara",
	25 -> "Milla",
	26 -> "Nakata",
	27 -> "Kynan",
	28 -> "Kiah",
	29 -> "Jaggar",
	30 -> "Beca",
	31 -> "Ikram",
	32 -> "Melia",
	33 -> "Sidan",
	34 -> "Deshi",
	35 -> "Tessa",
	36 -> "Sibila",
	37 -> "Morien",
	38 -> "Mona",
	39 -> "Padma",
	40 -> "Avella",
	41 -> "Naila",
	42 -> "Lio",
	43 -> "Cera",
	44 -> "Ithela",
	45 -> "Zhan",
	46 -> "Kaivan",
	47 -> "Valeri",
	48 -> "Hirsham",
	49 -> "Pemba",
	50 -> "Edda",
	51 -> "Lestara",
	52 -> "Lago",
	53 -> "Elstan",
	54 -> "Saskia",
	55 -> "Kabeera",
	56 -> "Caldas",
	57 -> "Nisus",
	58 -> "Serene",
	59 -> "Chenda",
	60 -> "Themon",
	61 -> "Erin",
	62 -> "Alban",
	63 -> "Parcell",
	64 -> "Jelma",
	65 -> "Willa",
	66 -> "Nadira",
	67 -> "Gwen",
	68 -> "Amara",
	69 -> "Masias",
	70 -> "Kanno",
	71 -> "Razeena",
	72 -> "Mira",
	73 -> "Perella",
	74 -> "Myrick",
	75 -> "Qamar",
	76 -> "Kormak",
	77 -> "Zura",
	78 -> "Zanita",
	79 -> "Brynn",
	80 -> "Tegan",
	81 -> "Pendry",
	82 -> "Quinn",
	83 -> "Fanir",
	84 -> "Glain",
	85 -> "Emelyn",
	86 -> "Kendi",
	87 -> "Althus",
	88 -> "Leela",
	89 -> "Ishana",
	90 -> "Flint",
	91 -> "Delkash",
	92 -> "Nia",
	93 -> "Nan",
	94 -> "Keeara",
	95 -> "Katania",
	96 -> "Morell",
	97 -> "Temir",
	98 -> "Bas",
	99 -> "Sabine",
	100 -> "Tallus"
|>;


(* ::Subsubsection::Closed:: *)
(*Character: Name (Ironlander Set 2)*)


oracles["Character: Name (Ironlander Set 2)"] = <|
	1 -> "Segura",
	2 -> "Gethin",
	3 -> "Bataar",
	4 -> "Basira",
	5 -> "Joa",
	6 -> "Glynn",
	7 -> "Toran",
	8 -> "Arasen",
	9 -> "Kuron",
	10 -> "Griff",
	11 -> "Owena",
	12 -> "Adda",
	13 -> "Euros",
	14 -> "Kova",
	15 -> "Kara",
	16 -> "Morgan",
	17 -> "Nanda",
	18 -> "Tamara",
	19 -> "Asha",
	20 -> "Delos",
	21 -> "Torgan",
	22 -> "Makari",
	23 -> "Selva",
	24 -> "Kimura",
	25 -> "Rhian",
	26 -> "Tristan",
	27 -> "Siorra",
	28 -> "Sayer",
	29 -> "Cortina",
	30 -> "Vesna",
	31 -> "Kataka",
	32 -> "Keyshia",
	33 -> "Mila",
	34 -> "Lili",
	35 -> "Vigo",
	36 -> "Sadia",
	37 -> "Malik",
	38 -> "Dag",
	39 -> "Kuno",
	40 -> "Reva",
	41 -> "Kai",
	42 -> "Kalina",
	43 -> "Jihan",
	44 -> "Hennion",
	45 -> "Abram",
	46 -> "Aida",
	47 -> "Myrtle",
	48 -> "Nekun",
	49 -> "Menna",
	50 -> "Tahir",
	51 -> "Sarria",
	52 -> "Nakura",
	53 -> "Akiya",
	54 -> "Talan",
	55 -> "Mattick",
	56 -> "Okoth",
	57 -> "Khulan",
	58 -> "Verena",
	59 -> "Beltran",
	60 -> "Del",
	61 -> "Ranna",
	62 -> "Alina",
	63 -> "Muna",
	64 -> "Mura",
	65 -> "Torrens",
	66 -> "Yuda",
	67 -> "Nazmi",
	68 -> "Ghalen",
	69 -> "Sarda",
	70 -> "Shona",
	71 -> "Kalidas",
	72 -> "Wena",
	73 -> "Sendra",
	74 -> "Kori",
	75 -> "Setara",
	76 -> "Lucia",
	77 -> "Maya",
	78 -> "Reema",
	79 -> "Yorath",
	80 -> "Rhodri",
	81 -> "Shekhar",
	82 -> "Servan",
	83 -> "Reese",
	84 -> "Kenrick",
	85 -> "Indirra",
	86 -> "Giliana",
	87 -> "Jebran",
	88 -> "Kotama",
	89 -> "Fara",
	90 -> "Katrin",
	91 -> "Namba",
	92 -> "Lona",
	93 -> "Taylah",
	94 -> "Kato",
	95 -> "Esra",
	96 -> "Eleri",
	97 -> "Irsia",
	98 -> "Kayu",
	99 -> "Bevan",
	100 -> "Chandra"
|>;


(* ::Subsubsection::Closed:: *)
(*Character: Name (Firstborn - Elf)*)


oracles["Character: Name (Firstborn - Elf)"] = <|
	2 -> "Arsula",
	4 -> "Tishetu",
	6 -> "Naidita",
	8 -> "Leucia",
	10 -> "Belesunna",
	12 -> "Sutahe",
	14 -> "Vidarna",
	16 -> "Dotani",
	18 -> "Ninsunu",
	20 -> "Uktannu",
	22 -> "Balathu",
	24 -> "Retenay",
	26 -> "Dorosi",
	28 -> "Kendalanu",
	30 -> "Gezera",
	32 -> "Tahuta",
	34 -> "Zursan",
	36 -> "Mattissa",
	38 -> "Seleeku",
	40 -> "Anatu",
	42 -> "Utamara",
	44 -> "Aralu",
	46 -> "Nebakay",
	48 -> "Arakhi",
	50 -> "Dismashk",
	52 -> "Ibrahem",
	54 -> "Mitunu",
	56 -> "Sinosu",
	58 -> "Atani",
	60 -> "Jemshida",
	62 -> "Kinzura",
	64 -> "Visapni",
	66 -> "Sumula",
	68 -> "Hullata",
	70 -> "Ukames",
	72 -> "Sidura",
	74 -> "Ahmeshki",
	76 -> "Kerihu",
	78 -> "Ilsit",
	80 -> "Ereshki",
	82 -> "Mayatanay",
	84 -> "Cybela",
	86 -> "Etana",
	88 -> "Anunna",
	90 -> "Gamanna",
	92 -> "Otani",
	94 -> "Nessana",
	96 -> "Ditani",
	98 -> "Uralar",
	100 -> "Faraza"
|>;


(* ::Subsubsection::Closed:: *)
(*Character: Name (Firstborn - Giant)*)


oracles["Character: Name (Firstborn - Giant)"] = <|
	4 -> "Chony",
	8 -> "Banda",
	12 -> "Jochu",
	16 -> "Kira",
	20 -> "Khatir",
	24 -> "Chaidu",
	28 -> "Atan",
	32 -> "Buandu",
	36 -> "Jayyn",
	40 -> "Khashin",
	44 -> "Bayara",
	48 -> "Temura",
	52 -> "Kidha",
	56 -> "Kathos",
	60 -> "Tanua",
	64 -> "Bashtu",
	68 -> "Jaran",
	72 -> "Othos",
	76 -> "Khutan",
	80 -> "Otaan",
	84 -> "Martu",
	88 -> "Baku",
	92 -> "Tuban",
	96 -> "Qudan",
	100 -> "Denua"
|>;


(* ::Subsubsection::Closed:: *)
(*Character: Name (Firstborn - Varou)*)


oracles["Character: Name (Firstborn - Varou)"] = <|
	4 -> "Vata",
	8 -> "Zora",
	12 -> "Jasna",
	16 -> "Charna",
	20 -> "Tana",
	24 -> "Soveen",
	28 -> "Radka",
	32 -> "Zlata",
	36 -> "Leesla",
	40 -> "Byna",
	44 -> "Meeka",
	48 -> "Iskra",
	52 -> "Jarek",
	56 -> "Darya",
	60 -> "Neda",
	64 -> "Keha",
	68 -> "Zhivka",
	72 -> "Kvata",
	76 -> "Staysa",
	80 -> "Evka",
	84 -> "Vuksha",
	88 -> "Muko",
	92 -> "Dreko",
	96 -> "Aleko",
	100 -> "Vojan"
|>;


(* ::Subsubsection::Closed:: *)
(*Character: Name (Firstborn - Troll)*)


oracles["Character: Name (Firstborn - Troll)"] = <|
	4 -> "Rattle",
	8 -> "Scratch",
	12 -> "Wallow",
	16 -> "Groak",
	20 -> "Gimble",
	24 -> "Scar",
	28 -> "Cratch",
	32 -> "Creech",
	36 -> "Shush",
	40 -> "Glush",
	44 -> "Slar",
	48 -> "Gnash",
	52 -> "Stoad",
	56 -> "Grig",
	60 -> "Bleat",
	64 -> "Chortle",
	68 -> "Cluck",
	72 -> "Slith",
	76 -> "Mongo",
	80 -> "Creak",
	84 -> "Burble",
	88 -> "Vrusk",
	92 -> "Snuffle",
	96 -> "Leech",
	100 -> "Herk"
|>;


(* ::Subsection::Closed:: *)
(*Delve Site oracles*)


(* ::Subsubsection::Closed:: *)
(*Delve Site: Theme*)


oracles["Delve Site: Theme"] = <|
	11 -> "Ancient: This place holds the secrets of a bygone age",
	23 -> "Corrupted: This place is tainted by dark magic",
	35 -> "Fortified: Foes defend this place against intruders",
	48 -> "Hallowed: The faithful worship here",
	61 -> "Haunted: Restless spirits are bound to this place",
	74 -> "Infested: Foul creatures dwell here",
	87 -> "Ravaged: Time, disaster, or strife have taken their toll",
	100 -> "Wild: Nature prevails in this place"
|>;


(* ::Subsubsection::Closed:: *)
(*Delve Site: Domain*)


oracles["Delve Site: Domain"] = <|
	6 -> "Barrow: The dead are enshrined here",
	18 -> "Cavern: A place of stone and darkness",
	28 -> "Frozen Cavern: A place of deep caves and eternal cold",
	32 -> "Icereach: A frigid landscape formed of frozen seas",
	38 -> "Mine: Tunnels dug greedily and deep",
	48 -> "Pass: Treacherous paths over high mountains",
	58 -> "Ruin: The crumbling legacy of a dead civilization",
	68 -> "Sea Cave: Stone passages carved by ocean waves",
	78 -> "Shadowfen: A primeval marsh, cloaked in mist",
	83 -> "Stronghold: A fortress secured against trespassers",
	95 -> "Tanglewood: A perilous forest of eternal shadow",
	100 -> "Underkeep: An age-old subterranean dungeon"
|>;


(* ::Subsubsection::Closed:: *)
(*Delve Site: Name (Template)*)


oracles["Delve Site: Name (Template)"] = <|
	25 -> "[Description] [Place]",
	50 -> "[Place] of [Detail]",
	70 -> "[Place] of [Description] [Detail]",
	80 -> "[Place] of [Namesake's] [Detail]",
	85 -> "[Namesake's] [Place]",
	95 -> "[Description] [Place] of [Namesake]",
	100 -> "[Place] of [Namesake]"
|>;


(* ::Subsubsection::Closed:: *)
(*Delve Site: Name (Description)*)


oracles["Delve Site: Name (Description)"] = <|
	2 -> "Deep",
	4 -> "Tainted",
	6 -> "Grey",
	8 -> "Forgotten",
	10 -> "Flooded",
	12 -> "Forbidden",
	14 -> "Barren",
	16 -> "Lost",
	18 -> "Cursed",
	20 -> "Fell",
	22 -> "Sunken",
	24 -> "Nightmare",
	26 -> "Infernal",
	28 -> "Dark",
	30 -> "Bloodstained",
	32 -> "Haunted",
	34 -> "White",
	36 -> "Shrouded",
	38 -> "Wasted",
	40 -> "Grim",
	42 -> "Endless",
	44 -> "Crumbling",
	46 -> "Undying",
	48 -> "Bloodied",
	50 -> "Forsaken",
	52 -> "Silent",
	54 -> "Blighted",
	56 -> "Iron",
	58 -> "Frozen",
	60 -> "Abyssal",
	62 -> "Crimson",
	64 -> "Silver",
	66 -> "Desecrated",
	68 -> "Ashen",
	70 -> "Elder",
	72 -> "Scorched",
	74 -> "Unknown",
	76 -> "Scarred",
	78 -> "Broken",
	80 -> "Chaotic",
	82 -> "Black",
	84 -> "Hidden",
	86 -> "Sundered",
	88 -> "Shattered",
	90 -> "Dreaded",
	92 -> "Secret",
	94 -> "High",
	96 -> "Sacred",
	98 -> "Fallen",
	100 -> "Ruined"
|>;


(* ::Subsubsection::Closed:: *)
(*Delve Site: Name (Detail)*)


oracles["Delve Site: Name (Detail)"] = <|
	2 -> "Blight",
	4 -> "Strife",
	6 -> "Nightfall",
	8 -> "Fury",
	10 -> "Terror",
	12 -> "Truth",
	14 -> "Spring",
	16 -> "Sanctuary",
	18 -> "Bone",
	20 -> "Specters",
	22 -> "Daybreak",
	24 -> "Doom",
	26 -> "Treachery",
	28 -> "Blood",
	30 -> "War",
	32 -> "Torment",
	34 -> "Iron",
	36 -> "Silence",
	38 -> "Mist",
	40 -> "Isolation",
	42 -> "Runes",
	44 -> "Rot",
	46 -> "Corruption",
	48 -> "Prophecy",
	50 -> "Fate",
	52 -> "Twilight",
	54 -> "Power",
	56 -> "Darkness",
	58 -> "Gloom",
	60 -> "Storms",
	62 -> "Hope",
	64 -> "Lament",
	66 -> "Frost",
	68 -> "Souls",
	70 -> "Winter",
	72 -> "Sadness",
	74 -> "Desolation",
	76 -> "Bane",
	78 -> "Lies",
	80 -> "Ash",
	82 -> "Banishment",
	84 -> "Shadow",
	86 -> "Madness",
	88 -> "Stone",
	90 -> "Secrets",
	92 -> "Despair",
	94 -> "Blades",
	96 -> "Dread",
	98 -> "Light",
	100 -> "Wrath"
|>;


(* ::Subsubsection::Closed:: *)
(*Delve Site: Name (Namesake)*)


oracles["Delve Site: Name (Namesake)"] = <|
	2 -> "Breckon",
	4 -> "Issara",
	6 -> "Milenna",
	8 -> "Thorval",
	10 -> "Khulan",
	12 -> "Aurvang",
	14 -> "Kalida",
	16 -> "Keeara",
	18 -> "Andor",
	20 -> "Zakaria",
	22 -> "Willa",
	24 -> "Etana",
	26 -> "Valgard",
	28 -> "Kenrick",
	30 -> "Wyland",
	32 -> "Sidura",
	34 -> "Svala",
	36 -> "Kajir",
	38 -> "Saiven",
	40 -> "Callwen",
	42 -> "Zhan",
	44 -> "Solana",
	46 -> "Ildar",
	48 -> "Keelan",
	50 -> "Thrain",
	52 -> "Kynan",
	54 -> "Jadina",
	56 -> "Radek",
	58 -> "Wulan",
	60 -> "Garion",
	62 -> "Eysa",
	64 -> "Kolor",
	66 -> "Katarra",
	68 -> "Dain",
	70 -> "Farina",
	72 -> "Yala",
	74 -> "Kodroth",
	76 -> "Morien",
	78 -> "Akida",
	80 -> "Haldorr",
	82 -> "Nyrad",
	84 -> "Edda",
	86 -> "Jorund",
	88 -> "Morraine",
	90 -> "Lindar",
	92 -> "Sithra",
	94 -> "Torgan",
	96 -> "Arnorr",
	98 -> "Thyri",
	100 -> "Erisia"
|>;


(* ::Subsubsection::Closed:: *)
(*Delve Site: Name (Place - Barrow)*)


oracles["Delve Site: Name (Place - Barrow)"] = <|
	10 -> "Barrow",
	20 -> "Boneyard",
	30 -> "Chambers",
	40 -> "Charnel",
	50 -> "Crypt",
	60 -> "Grave",
	70 -> "Mound",
	80 -> "Pit",
	90 -> "Sepulcher",
	100 -> "Tomb"
|>;


(* ::Subsubsection::Closed:: *)
(*Delve Site: Name (Place - Cavern)*)


oracles["Delve Site: Name (Place - Cavern)"] = <|
	10 -> "Abyss",
	20 -> "Cavern",
	30 -> "Caves",
	40 -> "Chasm",
	50 -> "Depths",
	60 -> "Hollow",
	70 -> "Lair",
	80 -> "Rift",
	90 -> "Tunnels",
	100 -> "Warren"
|>;


(* ::Subsubsection::Closed:: *)
(*Delve Site: Name (Place - Frozen Cavern)*)


oracles["Delve Site: Name (Place - Frozen Cavern)"] = <|
	10 -> "Break",
	20 -> "Brumal",
	30 -> "Cavern",
	40 -> "Chasm",
	50 -> "Crevasse",
	60 -> "Depths",
	70 -> "Fissure",
	80 -> "Lair",
	90 -> "Moulin",
	100 -> "Rimevault"
|>;


(* ::Subsubsection::Closed:: *)
(*Delve Site: Name (Place - Icereach)*)


oracles["Delve Site: Name (Place - Icereach)"] = <|
	10 -> "Drift",
	20 -> "Expanse",
	30 -> "Floe",
	40 -> "Icemark",
	50 -> "Icemere",
	60 -> "Reach",
	70 -> "Rimefield",
	80 -> "Thule",
	90 -> "Waste",
	100 -> "Wintertide"
|>;


(* ::Subsubsection::Closed:: *)
(*Delve Site: Name (Place - Mine)*)


oracles["Delve Site: Name (Place - Mine)"] = <|
	10 -> "Bore",
	20 -> "Cut",
	30 -> "Dig",
	40 -> "Forge",
	50 -> "Gouge",
	60 -> "Hoard",
	70 -> "Lode",
	80 -> "Mine",
	90 -> "Pit",
	100 -> "Works"
|>;


(* ::Subsubsection::Closed:: *)
(*Delve Site: Name (Place - Pass)*)


oracles["Delve Site: Name (Place - Pass)"] = <|
	10 -> "Cliffs",
	20 -> "Crag",
	30 -> "Cut",
	40 -> "Gap",
	50 -> "Gorge",
	60 -> "Heights",
	70 -> "Highlands",
	80 -> "Pass",
	90 -> "Reach",
	100 -> "Ridge"
|>;


(* ::Subsubsection::Closed:: *)
(*Delve Site: Name (Place - Ruin)*)


oracles["Delve Site: Name (Place - Ruin)"] = <|
	10 -> "Citadel",
	20 -> "Enclave",
	30 -> "Fortress",
	40 -> "Hall",
	50 -> "Keep",
	60 -> "Sanctuary",
	70 -> "Sanctum",
	80 -> "Spire",
	90 -> "Temple",
	100 -> "Tower"
|>;


(* ::Subsubsection::Closed:: *)
(*Delve Site: Name (Place - Sea Cave)*)


oracles["Delve Site: Name (Place - Sea Cave)"] = <|
	10 -> "Caves",
	20 -> "Channel",
	30 -> "Cove",
	40 -> "Depths",
	50 -> "Hollow",
	60 -> "Lair",
	70 -> "Pools",
	80 -> "Tides",
	90 -> "Trough",
	100 -> "Waters"
|>;


(* ::Subsubsection::Closed:: *)
(*Delve Site: Name (Place - Shadowfen)*)


oracles["Delve Site: Name (Place - Shadowfen)"] = <|
	10 -> "Bog",
	20 -> "Fen",
	30 -> "Floodlands",
	40 -> "Lowland",
	50 -> "Marsh",
	60 -> "Mire",
	70 -> "Morass",
	80 -> "Quagmire",
	90 -> "Slough",
	100 -> "Wetlands"
|>;


(* ::Subsubsection::Closed:: *)
(*Delve Site: Name (Place - Stronghold)*)


oracles["Delve Site: Name (Place - Stronghold)"] = <|
	10 -> "Bastion",
	20 -> "Citadel",
	30 -> "Fortress",
	40 -> "Garrison",
	50 -> "Haven",
	60 -> "Keep",
	70 -> "Outpost",
	80 -> "Refuge",
	90 -> "Sanctuary",
	100 -> "Watch"
|>;


(* ::Subsubsection::Closed:: *)
(*Delve Site: Name (Place - Tanglewood)*)


oracles["Delve Site: Name (Place - Tanglewood)"] = <|
	10 -> "Bramble",
	20 -> "Briar",
	30 -> "Forest",
	40 -> "Grove",
	50 -> "Silva",
	60 -> "Tangle",
	70 -> "Thicket",
	80 -> "Weald",
	90 -> "Wilds",
	100 -> "Wood"
|>;


(* ::Subsubsection::Closed:: *)
(*Delve Site: Name (Place - Underkeep)*)


oracles["Delve Site: Name (Place - Underkeep)"] = <|
	10 -> "Catacomb",
	20 -> "Chambers",
	30 -> "Den",
	40 -> "Hall",
	50 -> "Labyrinth",
	60 -> "Maze",
	70 -> "Pit",
	80 -> "Sanctum",
	90 -> "Underkeep",
	100 -> "Vault"
|>;


(* ::Subsubsection::Closed:: *)
(*Delve Site: Trap Event*)


oracles["Delve Site: Trap Event"] = <|
	4 -> "Block",
	8 -> "Create",
	12 -> "Break",
	16 -> "Puncture",
	20 -> "Entangle",
	24 -> "Enclose",
	28 -> "Ambush",
	32 -> "Snare",
	36 -> "Change",
	40 -> "Imitate",
	44 -> "Crush",
	48 -> "Drop",
	52 -> "Conceal",
	56 -> "Lure",
	60 -> "Release",
	64 -> "Obscure",
	68 -> "Cut",
	72 -> "Smother",
	76 -> "Collapse",
	80 -> "Summon",
	84 -> "Move",
	88 -> "Surprise",
	92 -> "Divert",
	96 -> "Attack",
	100 -> "Trigger"
|>;


(* ::Subsubsection::Closed:: *)
(*Delve Site: Trap Component*)


oracles["Delve Site: Trap Component"] = <|
	4 -> "Pit",
	8 -> "Water",
	12 -> "Fire",
	16 -> "Projectile",
	20 -> "Passage",
	24 -> "Fall",
	28 -> "Debris",
	32 -> "Fear",
	36 -> "Alarm",
	40 -> "Trigger",
	44 -> "Cold",
	48 -> "Weapon",
	52 -> "Darkness",
	56 -> "Decay",
	60 -> "Path",
	64 -> "Stone",
	68 -> "Terrain",
	72 -> "Poison",
	76 -> "Barrier",
	80 -> "Overhead",
	84 -> "Magic",
	88 -> "Toxin",
	92 -> "Earth",
	96 -> "Light",
	100 -> "Denizen"
|>;


(* ::Subsection::Closed:: *)
(*Monstrosity oracles*)


(* ::Subsubsection::Closed:: *)
(*Monstrosity: Size*)


oracles["Monstrosity: Size"] = <|
	5 -> "Tiny (rodent-sized)",
	30 -> "Small (hound-sized)",
	65 -> "Medium (person-sized)",
	94 -> "Large (giant-sized)",
	99 -> "Huge (whale-sized)",
	100 -> "Titanic (incomprehensible)"
|>;


(* ::Subsubsection::Closed:: *)
(*Monstrosity: Primary Form*)


oracles["Monstrosity: Primary Form"] = <|
	15 -> "Beast / mammal",
	25 -> "Humanoid",
	31 -> "Bird",
	37 -> "Spider",
	43 -> "Snake",
	49 -> "Worm / slug",
	55 -> "Lizard",
	61 -> "Insect",
	66 -> "Amorphous",
	69 -> "Crustacean",
	71 -> "Fish",
	73 -> "Octopoid",
	75 -> "Amphibian",
	77 -> "Plant",
	78 -> "Incorporeal",
	79 -> "Mineral",
	80 -> "Elemental",
	100 -> "Hybrid (roll twice)"
|>;


(* ::Subsubsection::Closed:: *)
(*Monstrosity: Characteristics*)


oracles["Monstrosity: Characteristics"] = <|
	5 -> "Extra limbs",
	10 -> "Fangs / rows of sharp teeth",
	15 -> "Claws / talons",
	20 -> "Strange color / markings",
	25 -> "Horns / tusks",
	30 -> "Oversized mouth",
	35 -> "Spikes / spines",
	40 -> "Tail",
	45 -> "Multi-segmented body",
	50 -> "Wings",
	54 -> "Stinger / barbs",
	58 -> "Many-eyed",
	62 -> "Distinctive sound",
	66 -> "Tentacles / tendrils",
	69 -> "Mandibles / pincers",
	72 -> "Luminescent",
	75 -> "Antennae / sensory organs",
	78 -> "Proboscis / inner jaw",
	81 -> "Exoskeleton / shell",
	84 -> "Bony protuberances",
	87 -> "Corrupted flesh",
	90 -> "Semi-transparent",
	93 -> "Scarred / injured",
	95 -> "Egg sac / carried offspring",
	97 -> "Rotting / skeletal",
	98 -> "Mummified / desiccated",
	99 -> "Multi-headed",
	100 -> "Etched with mystic runes"
|>;


(* ::Subsubsection::Closed:: *)
(*Monstrosity: Abilities*)


oracles["Monstrosity: Abilities"] = <|
	4 -> "Keen senses",
	8 -> "Intimidating vocalization",
	12 -> "Climber",
	16 -> "Intelligent",
	20 -> "Swift",
	24 -> "Powerful bite",
	28 -> "Stealthy / ambusher",
	32 -> "Horrid visage",
	36 -> "Strong",
	40 -> "Camouflaged",
	43 -> "Flier / glider",
	46 -> "Poisonous",
	49 -> "Semiaquatic / swimmer",
	52 -> "Grappler / entangler",
	55 -> "Leaper",
	58 -> "Crusher / constrictor",
	61 -> "Armored",
	64 -> "Burrower",
	67 -> "Noxious smell",
	69 -> "Trap-setter",
	71 -> "Parasitic",
	73 -> "Vibration sense",
	75 -> "Breath weapon / toxic spew",
	77 -> "Mimicry",
	79 -> "Shapeshifting",
	81 -> "Control lesser creatures",
	83 -> "Echolocation",
	85 -> "Electric shock",
	87 -> "Acidic",
	89 -> "Symbiotic",
	91 -> "Shoot projectiles",
	92 -> "Paralyzing",
	93 -> "Immune to iron",
	94 -> "Feels no pain",
	95 -> "Enact rituals",
	96 -> "Create illusions",
	97 -> "Mind control / telepathy",
	98 -> "Move between realities",
	99 -> "Wield weapons",
	100 -> "Control elements"
|>;


(* ::Subsection::Closed:: *)
(*Threat oracles*)


(* ::Subsubsection::Closed:: *)
(*Threat Action*)


oracles["Threat Action"] = <|
	30 -> "The threat readies its next step, or a new danger looms. If you are in a position to prevent this development, you may attempt to do so. If you succeed, Reach a Milestone. Otherwise, mark menace.",
	70 -> "The threat works subtly to advance toward its goal, or the danger escalates. Mark menace.",
	100 -> "The threat makes a dramatic and immediate move, or a major event reveals new complications. Mark menace twice."
|>;


(* ::Subsubsection::Closed:: *)
(*Threat: Category*)


oracles["Threat: Category"] = <|
	12 -> "Burgeoning Conflict",
	24 -> "Cursed Site",
	34 -> "Environmental Calamity",
	46 -> "Malignant Plague",
	60 -> "Rampaging Creature",
	72 -> "Ravaging Horde",
	84 -> "Scheming Leader",
	94 -> "Power-Hungry Mystic",
	99 -> "Zealous Cult",
	100 -> "Roll Twice"
|>;


(* ::Subsubsection::Closed:: *)
(*Threat: Burgeoning Conflict*)


oracles["Threat: Burgeoning Conflict"] = <|
	10 -> "Allow warmongers to gain influence",
	20 -> "Break a treaty",
	30 -> "Force a hasty decision",
	40 -> "Deepen suspicions",
	50 -> "Trigger a confrontation",
	60 -> "Subvert a potential accord",
	70 -> "Isolate the antagonists",
	80 -> "Draw new battle lines",
	90 -> "Reveal an unexpected aspect of the dispute",
	100 -> "Introduce a new person or faction to complicate the situation"
|>;


(* ::Subsubsection::Closed:: *)
(*Threat: Cursed Site*)


oracles["Threat: Cursed Site"] = <|
	10 -> "Unleash a creature or being",
	20 -> "Lure the unwary into its depths",
	30 -> "Offer promises of power",
	40 -> "Reveal a new aspect of its cursed history",
	50 -> "Expand its malignancy to surrounding lands",
	60 -> "Leave its mark on an inhabitant or visitor",
	70 -> "Reveal hidden depths",
	80 -> "Ensnare an important person or object",
	90 -> "Corrupt the environment",
	100 -> "Transform its nature"
|>;


(* ::Subsubsection::Closed:: *)
(*Threat: Environmental Calamity*)


oracles["Threat: Environmental Calamity"] = <|
	10 -> "Devastate a place",
	20 -> "Block a path",
	30 -> "Threaten a community with imminent destruction",
	40 -> "Manifest unexpected effects",
	50 -> "Expand in scope or intensity",
	60 -> "Allow someone to take advantage",
	70 -> "Deprive of resources",
	80 -> "Isolate an important person or community",
	90 -> "Force refugees into hostile lands",
	100 -> "Disrupt natural ecosystems"
|>;


(* ::Subsubsection::Closed:: *)
(*Threat: Malignant Plague*)


oracles["Threat: Malignant Plague"] = <|
	10 -> "Manifest new symptoms or effects",
	20 -> "Infect someone important",
	30 -> "Expand to new territory or communities",
	40 -> "Allow someone to take advantage",
	50 -> "Allow someone to take the blame",
	60 -> "Create panic or disorder",
	70 -> "Force a horrible decision",
	80 -> "Lure into complacency",
	90 -> "Reveal the root of the sickness",
	100 -> "Undermine a potential cure"
|>;


(* ::Subsubsection::Closed:: *)
(*Threat: Rampaging Creature*)


oracles["Threat: Rampaging Creature"] = <|
	10 -> "Reveal a new aspect of its nature or abilities",
	20 -> "Expand its territory",
	30 -> "Make a sudden and brutal attack",
	40 -> "Control or influence lesser creatures",
	50 -> "Create confusion or strife",
	60 -> "Leave foreboding signs",
	70 -> "Lure the unwary",
	80 -> "Imperil an event",
	90 -> "Assert control over a location",
	100 -> "Threaten resources"
|>;


(* ::Subsubsection::Closed:: *)
(*Threat: Ravaging Horde*)


oracles["Threat: Ravaging Horde"] = <|
	10 -> "Overrun defenses",
	20 -> "Gather resources",
	30 -> "Attack a location",
	40 -> "Expand forces",
	50 -> "Appoint or reveal a leader",
	60 -> "Send forth a champion",
	70 -> "Create a diversion",
	80 -> "Undermine an opposing force from within",
	90 -> "Cut off supplies or reinforcements",
	100 -> "Employ a new weapon"
|>;


(* ::Subsubsection::Closed:: *)
(*Threat: Scheming Leader*)


oracles["Threat: Scheming Leader"] = <|
	10 -> "Defeat an enemy",
	20 -> "Form a new alliance",
	30 -> "Usurp or undermine another leader",
	40 -> "Force the loyalty of a community or important person",
	50 -> "Enact a new law or tradition",
	60 -> "Rescind an old law or tradition",
	70 -> "Reveal a true intention",
	80 -> "Unravel an existing alliance",
	90 -> "Incite conflict",
	100 -> "Use an unexpected capability or asset"
|>;


(* ::Subsubsection::Closed:: *)
(*Threat: Power-Hungry Mystic*)


oracles["Threat: Power-Hungry Mystic"] = <|
	10 -> "Gain hidden knowledge",
	20 -> "Assault an enemy with magic",
	30 -> "Despoil a place through magic",
	40 -> "Forge a bond with ancient forces",
	50 -> "Create magical wards or protections",
	60 -> "Obtain a powerful artifact",
	70 -> "Tempt with power or secrets",
	80 -> "Recruit a follower or ally",
	90 -> "Sacrifice something in exchange for greater power",
	100 -> "Use magic to trick or deceive"
|>;


(* ::Subsubsection::Closed:: *)
(*Threat: Zealous Cult*)


oracles["Threat: Zealous Cult"] = <|
	10 -> "Overtake a faction or community",
	20 -> "Unlock secrets to greater power",
	30 -> "Establish false credibility",
	40 -> "Appoint or reveal a leader",
	50 -> "Lure new members or establish alliances",
	60 -> "Subvert opposition through devious schemes",
	70 -> "Attack opposition directly",
	80 -> "Spread the word of its doctrine",
	90 -> "Reveal a dire prophecy",
	100 -> "Reveal its true nature or goal"
|>;


(* ::Subsection::Closed:: *)
(*Story oracles*)


(* ::Subsubsection::Closed:: *)
(*Story: Region*)


oracles["Story: Region"] = <|
	12 -> "Barrier Islands",
	24 -> "Ragged Coast",
	34 -> "Deep Wilds",
	46 -> "Flooded Lands",
	60 -> "Havens",
	72 -> "Hinterlands",
	84 -> "Tempest Hills",
	94 -> "Veiled Mountains",
	99 -> "Shattered Wastes",
	100 -> "Elsewhere"
|>;


(* ::Subsubsection::Closed:: *)
(*Story: Plot Twist*)


oracles["Story: Plot Twist"] = <|
	5 -> "It was all a diversion",
	10 -> "A dark secret is revealed",
	15 -> "A trap is sprung",
	20 -> "An assumption is revealed to be false",
	25 -> "A secret alliance is revealed",
	30 -> "Your actions benefit an enemy",
	35 -> "Someone returns unexpectedly",
	40 -> "A more dangerous foe is revealed",
	45 -> "You and an enemy share a common goal",
	50 -> "A true identity is revealed",
	55 -> "You are betrayed by someone who was trusted",
	60 -> "You are too late",
	65 -> "The true enemy is revealed",
	70 -> "The enemy gains new allies",
	75 -> "A new danger appears",
	80 -> "Someone or something goes missing",
	85 -> "The truth of a relationship is revealed",
	90 -> "Two seemingly unrelated situations are shown to be connected",
	95 -> "Unexpected powers or abilities are revealed",
	100 -> "Roll twice; if they are the same result, make it worse"
|>;


(* ::Subsubsection::Closed:: *)
(*Story: Clue*)


oracles["Story: Clue"] = <|
	3 -> "Affirms a previously understood fact or clue",
	6 -> "Connects to a known rumor or scandal",
	9 -> "Connects to a previously unrelated mystery or quest",
	12 -> "Connects to your own expertise or interests",
	15 -> "Contradicts a previously understood fact or clue",
	18 -> "Evokes a personal memory",
	21 -> "Evokes a legend or prophecy",
	24 -> "Evokes a dream or vision",
	27 -> "Involves a hidden or mysterious community",
	30 -> "Involves a hidden or mysterious person",
	33 -> "Involves a nonhuman being or entity",
	36 -> "Involves a creature",
	39 -> "Involves an artifact or precious object",
	42 -> "Involves a personal item",
	45 -> "Involves a weapon",
	48 -> "Involves a valuable resource",
	51 -> "Involves a notable community or faction",
	54 -> "Involves a leader or notable person",
	57 -> "Involves a person or community from your background",
	60 -> "Involves an enemy or rival",
	63 -> "Involves someone you trust",
	65 -> "Involves a mystic power or ritual",
	68 -> "Involves an ailment or affliction",
	71 -> "Involves a religion or belief",
	74 -> "Involves a promise or debt",
	77 -> "Leads to a nearby or familiar place",
	80 -> "Leads to an ancient or ruined place",
	83 -> "Leads to a settled place",
	86 -> "Leads to a remote or wild place",
	89 -> "Leads to a notable landmark",
	91 -> "Leads to a mystical or unearthly place",
	94 -> "Suggests a history of similar incidents",
	97 -> "Suggests a looming event or deadline",
	100 -> "Suggests an imposter or deception"
|>;


(* ::Subsection::Closed:: *)
(*Combat oracles*)


(* ::Subsubsection::Closed:: *)
(*Combat: Battleground*)


oracles["Combat: Battleground"] = <|
	5 -> "Slippery surface: Mud, ice, rain-slick rocks",
	10 -> "Encumbering terrain: Water, muck, deep snow, webs",
	15 -> "Precipitous drop: Cliff, ravine, pit, stairs",
	20 -> "Obstructed path: Barricade, toppled ruin, fallen tree",
	25 -> "High ground: Mound, outcropping, climbable structure",
	30 -> "Cluttered terrain: Rubble, rocks, roots",
	35 -> "Low visibility: Darkness, smoke, mist, torrential rain",
	40 -> "Impassable border: Deep waterway, high wall, cliff face, locked door",
	45 -> "Scattered cover: Low walls, boulders, trees, crates",
	50 -> "Cramped spaces: Narrow tunnel, crowded room, dense woods",
	55 -> "Treacherous ground: Fire pit, boiling hot spring, quagmire",
	60 -> "Restricted approach: Bridge, corridor, river ford, narrow canyon",
	65 -> "Collapsing foundation: Crumbling ruins, thin ice, undermined earth",
	70 -> "Bounded space: Dueling circle, woodland clearing, standing stones",
	75 -> "Pitched ground: Steep hillside, rooftop, collapsed ruin, ship deck",
	80 -> "Hidden hazard: Trap, sinkhole, lurking creature, waiting ambushers",
	85 -> "Frenzied distractions: Noncombatants, panicked creatures, insect swarms",
	90 -> "Destructive chaos: Storm, fire, flooding, rampaging creature",
	95 -> "Unnatural forces: Mystic energies, runic symbols, sorcerous artifacts",
	100 -> "Cursed ground: Corpses, shambling undead, ghostly specters"
|>;


(* ::Subsubsection::Closed:: *)
(*Combat: Tactic*)


oracles["Combat: Tactic"] = <|
	3 -> "Compel a surrender",
	6 -> "Coordinate with allies",
	9 -> "Gather reinforcements",
	13 -> "Seize something or someone",
	17 -> "Provoke a reckless response",
	21 -> "Intimidate or frighten",
	25 -> "Reveal a surprising truth",
	29 -> "Shift focus to something else",
	33 -> "Destroy or damage something",
	39 -> "Take a decisive action",
	45 -> "Reinforce defenses",
	52 -> "Ready an action",
	60 -> "Use the terrain to gain advantage",
	68 -> "Take advantage of an opening",
	78 -> "Create an opportunity",
	89 -> "Attack with precision",
	99 -> "Attack with power",
	100 -> "Take an unexpected action"
|>;


(* ::Subsubsection::Closed:: *)
(*Combat: Event Method*)


oracles["Combat: Event Method"] = <|
	2 -> "Defy",
	4 -> "Break",
	6 -> "Trick",
	8 -> "Evade",
	10 -> "Protect",
	12 -> "Overwhelm",
	14 -> "Persevere",
	16 -> "Assist",
	18 -> "Await",
	20 -> "Abort",
	22 -> "Block",
	24 -> "Collide",
	26 -> "Focus",
	28 -> "Advance",
	30 -> "Breach",
	32 -> "Endure",
	34 -> "Assault",
	36 -> "Charge",
	38 -> "Escalate",
	40 -> "Sunder",
	42 -> "Shatter",
	44 -> "Aim",
	46 -> "Stagger",
	48 -> "Counter",
	50 -> "Seize",
	52 -> "Impact",
	54 -> "Entangle",
	56 -> "Hold",
	58 -> "Deflect",
	60 -> "Drop",
	62 -> "Lose",
	64 -> "Sweep",
	66 -> "Secure",
	68 -> "Cover",
	70 -> "Withdraw",
	72 -> "Clash",
	74 -> "Amplify",
	76 -> "Batter",
	78 -> "Feint",
	80 -> "Shove",
	82 -> "Embed",
	84 -> "Affect",
	86 -> "Probe",
	88 -> "Force",
	90 -> "Intensify",
	92 -> "Distract",
	94 -> "Challenge",
	96 -> "Brawl",
	98 -> "Coordinate",
	100 -> "Overrun"
|>;


(* ::Subsubsection::Closed:: *)
(*Combat: Event Target*)


oracles["Combat: Event Target"] = <|
	2 -> "Control",
	4 -> "Defense",
	6 -> "Limbs",
	8 -> "Focus",
	10 -> "Advantage",
	12 -> "Range",
	14 -> "Stress",
	16 -> "Sense",
	18 -> "Weakness",
	20 -> "Opening",
	22 -> "Fear",
	24 -> "Instinct",
	26 -> "Footing",
	28 -> "Maneuver",
	30 -> "Reach",
	32 -> "Harm",
	34 -> "Finesse",
	36 -> "Weapon",
	38 -> "Environment",
	40 -> "Technique",
	42 -> "Surprise",
	44 -> "Pride",
	46 -> "Wound",
	48 -> "Precision",
	50 -> "Ally",
	52 -> "Ground",
	54 -> "Courage",
	56 -> "Companion",
	58 -> "Object",
	60 -> "Momentum",
	62 -> "Speed",
	64 -> "Strength",
	66 -> "Supply",
	68 -> "Terrain",
	70 -> "Armor",
	72 -> "Skill",
	74 -> "Body",
	76 -> "Protection",
	78 -> "Resolve",
	80 -> "Ferocity",
	82 -> "Shield",
	84 -> "Ammo",
	86 -> "Anger",
	88 -> "Opportunity",
	90 -> "Balance",
	92 -> "Position",
	94 -> "Barrier",
	96 -> "Strategy",
	98 -> "Grasp",
	100 -> "Power"
|>;


(* ::Subsection::Closed:: *)
(*Magic oracles*)


(* ::Subsubsection::Closed:: *)
(*Magic: Ritual Backlash*)


oracles["Magic: Ritual Backlash"] = <|
	4 -> "Your ritual has the opposite effect",
	8 -> "You are sapped of strength",
	12 -> "Your friend, ally, or companion is adversely affected",
	16 -> "You destroy an important object",
	20 -> "You inadvertently summon a spirit or undead being",
	24 -> "You collapse, and drift into a troubled sleep",
	28 -> "You undergo a physical torment which leaves its mark upon you",
	32 -> "You hear ghostly voices whispering of dark portents",
	36 -> "You find yourself in another place without memory of how you got there",
	40 -> "You alert someone or something to your presence",
	44 -> "You are not yourself, and act against a friend, ally, or companion",
	48 -> "You affect your surroundings, causing a disturbance or potential harm",
	52 -> "You waste resources",
	56 -> "You suffer the loss of a sense for several hours",
	60 -> "You lose your connection to magic for a day or so",
	64 -> "Your ritual affects the target in an unexpected and problematic way",
	68 -> "Your ritual reveals a surprising and troubling truth",
	72 -> "You are tempted by dark powers",
	76 -> "You see a troubling vision of your future",
	80 -> "You can't perform this ritual again until you acquire a key component",
	84 -> "You develop a strange fear or compulsion",
	88 -> "Your ritual causes creatures to exhibit strange or aggressive behavior",
	92 -> "You are tormented by an apparition from your past",
	96 -> "You are wracked with sudden sickness",
	100 -> "Roll twice; if they are the same result, make it worse"
|>;


(* ::Subsubsection::Closed:: *)
(*Magic: Mystic Effect*)


oracles["Magic: Mystic Effect"] = <|
	2 -> "Alter the weather",
	4 -> "Nullify other powers",
	6 -> "Imbue an object with power",
	8 -> "Disintegrate or decay objects",
	10 -> "Awaken an ancient being",
	12 -> "Summon a monstrous creature",
	14 -> "Bind to a vow or task",
	16 -> "Give life to inanimate forms",
	18 -> "Unleash a plague",
	20 -> "Control elemental forces",
	22 -> "Erase or suppress memories",
	24 -> "Shroud in lasting darkness",
	26 -> "Alter surrounding environment",
	28 -> "Bind to a location",
	30 -> "Inflict cursed luck",
	32 -> "Incite negative emotions",
	34 -> "Awaken latent powers in another",
	36 -> "Inflict aging or wasting",
	38 -> "Bind to a restless spirit",
	40 -> "Grant horrifying knowledge",
	42 -> "Awaken or animate the dead",
	44 -> "Incite an obsession",
	46 -> "Manifest inner fears",
	48 -> "Banish to another time",
	50 -> "Manipulate plant growth",
	52 -> "Trigger a natural disaster",
	54 -> "Reveal past events",
	56 -> "Emit destructive energies",
	58 -> "Alter the flow of time",
	60 -> "Inflict a consuming need",
	62 -> "Create hallucinations or illusions",
	64 -> "Trigger a celestial event",
	66 -> "Summon a swarm of creatures",
	68 -> "Reveal distant places",
	70 -> "Absorb energy or essence",
	72 -> "Banish to another reality",
	74 -> "Banish to another location",
	76 -> "Inflict prophetic visions",
	78 -> "Inflict dreadful transformations",
	80 -> "Inflict sickness or weakness",
	82 -> "Absorb life",
	84 -> "Spread corruption or blight",
	86 -> "Brand with a cursed mark",
	88 -> "Destroy terrain or architecture",
	90 -> "Grant a lasting boon\[LongDash]at a cost",
	100 -> "Roll twice"
|>;


(* ::Subsection::Closed:: *)
(*Scale oracles*)


(* ::Subsubsection::Closed:: *)
(*Scale: Magnitude (Size)*)


oracles["Scale: Magnitude (Size)"] = <|
	15 -> "Undersized",
	35 -> "Small",
	65 -> "Medium",
	85 -> "Large",
	100 -> "Huge"
|>;


(* ::Subsubsection::Closed:: *)
(*Scale: Magnitude (Number)*)


oracles["Scale: Magnitude (Number)"] = <|
	15 -> "None / one",
	35 -> "Few",
	65 -> "Several",
	85 -> "Many",
	100 -> "Countless"
|>;


(* ::Subsubsection::Closed:: *)
(*Scale: Magnitude (Distance)*)


oracles["Scale: Magnitude (Distance)"] = <|
	15 -> "Very close",
	35 -> "Near",
	65 -> "Far",
	85 -> "Remote",
	100 -> "Inaccessible"
|>;


(* ::Subsubsection::Closed:: *)
(*Scale: Magnitude (Time)*)


oracles["Scale: Magnitude (Time)"] = <|
	15 -> "Fleeting",
	35 -> "Short",
	65 -> "Moderate",
	85 -> "Lengthy",
	100 -> "Eternal"
|>;


(* ::Subsubsection::Closed:: *)
(*Scale: Magnitude (Power)*)


oracles["Scale: Magnitude (Power)"] = <|
	15 -> "Weak",
	35 -> "Minor",
	65 -> "Capable",
	85 -> "Strong",
	100 -> "Overwhelming"
|>;


(* ::Subsubsection::Closed:: *)
(*Scale: Magnitude (Complexity)*)


oracles["Scale: Magnitude (Complexity)"] = <|
	15 -> "Simple",
	35 -> "Basic",
	65 -> "Manageable",
	85 -> "Complicated",
	100 -> "Bewildering"
|>;


(* ::Subsubsection::Closed:: *)
(*Scale: Magnitude (Value)*)


oracles["Scale: Magnitude (Value)"] = <|
	15 -> "Worthless",
	35 -> "Cheap",
	65 -> "Common",
	85 -> "Valuable",
	100 -> "Priceless"
|>;


(* ::Subsubsection::Closed:: *)
(*Scale: Magnitude (Influence)*)


oracles["Scale: Magnitude (Influence)"] = <|
	15 -> "Limited",
	35 -> "Isolated",
	65 -> "Localized",
	85 -> "Far-reaching",
	100 -> "Dominant"
|>;


(* ::Subsubsection::Closed:: *)
(*Scale: Magnitude (Disposition)*)


oracles["Scale: Magnitude (Disposition)"] = <|
	15 -> "Friendly",
	35 -> "Open",
	65 -> "Wary",
	85 -> "Threatening",
	100 -> "Hostile"
|>;


(* ::Subsubsection::Closed:: *)
(*Scale: Rank (Quest)*)


oracles["Scale: Rank (Quest)"] = <|
	15 -> "Troublesome: A challenging quest with a small number of obstacles",
	35 -> "Dangerous: An involved quest with several obstacles",
	65 -> "Formidable: A complex quest with many obstacles",
	85 -> "Extreme: An intimidating quest with scores of obstacles",
	100 -> "Epic: A life-defining quest of unknowable scope"
|>;


(* ::Subsubsection::Closed:: *)
(*Scale: Rank (Journey)*)


oracles["Scale: Rank (Journey)"] = <|
	15 -> "Troublesome: Traveling a moderate distance within a single region",
	35 -> "Dangerous: Traveling a long distance within a single region, or across rough terrain",
	65 -> "Formidable: Traveling from one region to another, or across especially challenging terrain",
	85 -> "Extreme: Traveling through multiple regions",
	100 -> "Epic: Traveling from one end of the Ironlands to another, or to a separate land"
|>;


(* ::Subsubsection::Closed:: *)
(*Scale: Rank (Foe)*)


oracles["Scale: Rank (Foe)"] = <|
	15 -> "Troublesome: Common enemies",
	35 -> "Dangerous: Capable fighters and deadly creatures",
	65 -> "Formidable: Exceptional fighters and mighty creatures",
	85 -> "Extreme: Foes of overwhelming skill or power",
	100 -> "Epic: Legendary foes of mythic power"
|>;


(* ::Subsection::Closed:: *)
(*Private context footer*)


End[];


(* ::Section::Closed:: *)
(*Package footer*)


EndPackage[];
