(* ::Package:: *)

(* ::Title:: *)
(*Mechanics Helpers*)


(* ::Text:: *)
(*Internal helpers and API implementations for game state, assets, vows, progress tracks, rolls, resources, journeys, scenes, delves, and other mechanical state changes.*)
(*This package exposes a small mechanics API for IronLibrary.wl and keeps its implementation in its own private context.*)


(* ::Section::Closed:: *)
(*Package header*)


BeginPackage["IronLibrary`MechanicsHelpers`"];


(* ::Section::Closed:: *)
(*Public helper API*)


resetIronSession::usage = "resetIronSession is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
getIronState::usage = "getIronState is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
setIronState::usage = "setIronState is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
soloCharacter::usage = "soloCharacter is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
normalizeCharacterForSheet::usage = "normalizeCharacterForSheet is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
currentDelveData::usage = "currentDelveData is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
currentDelveDataQuiet::usage = "currentDelveDataQuiet is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
riskZoneData::usage = "riskZoneData is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
setSoloCharacter::usage = "setSoloCharacter is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
createCharacter::usage = "createCharacter is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
starterVow::usage = "starterVow is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
addVow::usage = "addVow is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
vow::usage = "vow is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
vows::usage = "vows is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
removeVow::usage = "removeVow is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
setThreat::usage = "setThreat is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
removeThreat::usage = "removeThreat is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
clearThreatProgress::usage = "clearThreatProgress is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
markWounded::usage = "markWounded is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
clearWounded::usage = "clearWounded is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
markShaken::usage = "markShaken is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
clearShaken::usage = "clearShaken is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
markUnprepared::usage = "markUnprepared is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
clearUnprepared::usage = "clearUnprepared is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
markEncumbered::usage = "markEncumbered is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
clearEncumbered::usage = "clearEncumbered is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
markMaimed::usage = "markMaimed is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
markCorrupted::usage = "markCorrupted is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
markCursed::usage = "markCursed is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
clearCursed::usage = "clearCursed is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
markTormented::usage = "markTormented is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
clearTormented::usage = "clearTormented is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
starterAsset::usage = "starterAsset is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
asset::usage = "asset is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
assets::usage = "assets is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
drawAssets::usage = "drawAssets is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
addAsset::usage = "addAsset is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
upgradeAsset::usage = "upgradeAsset is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
setAssetTrack::usage = "setAssetTrack is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
adjustAssetTrack::usage = "adjustAssetTrack is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
removeAsset::usage = "removeAsset is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
companion::usage = "companion is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
companions::usage = "companions is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
setCompanionHealth::usage = "setCompanionHealth is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
adjustCompanionHealth::usage = "adjustCompanionHealth is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
addRarity::usage = "addRarity is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
removeRarity::usage = "removeRarity is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
actionRoll::usage = "actionRoll is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
burnMomentum::usage = "burnMomentum is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
rarityDieSix::usage = "rarityDieSix is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
progressRoll::usage = "progressRoll is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
reroll::usage = "reroll is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
markProgress::usage = "markProgress is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
clearProgress::usage = "clearProgress is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
resetProgress::usage = "resetProgress is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
resetProgressToOne::usage = "resetProgressToOne is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
raiseProgressRank::usage = "raiseProgressRank is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
sufferMomentum::usage = "sufferMomentum is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
takeMomentum::usage = "takeMomentum is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
sufferHealth::usage = "sufferHealth is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
takeHealth::usage = "takeHealth is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
sufferSpirit::usage = "sufferSpirit is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
takeSpirit::usage = "takeSpirit is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
sufferSupply::usage = "sufferSupply is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
takeSupply::usage = "takeSupply is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
recover::usage = "recover is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
addJourney::usage = "addJourney is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
setCurrentJourney::usage = "setCurrentJourney is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
journey::usage = "journey is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
journeys::usage = "journeys is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
removeJourney::usage = "removeJourney is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
addFoe::usage = "addFoe is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
foe::usage = "foe is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
foes::usage = "foes is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
removeFoe::usage = "removeFoe is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
failures::usage = "failures is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
bondProgress::usage = "bondProgress is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
addBond::usage = "addBond is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
bond::usage = "bond is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
bonds::usage = "bonds is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
removeBond::usage = "removeBond is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
markExperience::usage = "markExperience is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
beginScene::usage = "beginScene is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
scene::usage = "scene is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
removeScene::usage = "removeScene is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
markSceneCountdown::usage = "markSceneCountdown is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
addDelve::usage = "addDelve is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
setCurrentDelve::usage = "setCurrentDelve is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
delve::usage = "delve is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
delves::usage = "delves is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
removeDelve::usage = "removeDelve is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
setDelveTheme::usage = "setDelveTheme is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
setDelveDomain::usage = "setDelveDomain is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
returnToSite::usage = "returnToSite is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
riskZone::usage = "riskZone is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
denizens::usage = "denizens is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
rollDenizen::usage = "rollDenizen is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
setDenizen::usage = "setDenizen is part of the internal MechanicsHelpers API used by IronLibrary.wl.";
clearDenizen::usage = "clearDenizen is part of the internal MechanicsHelpers API used by IronLibrary.wl.";


(* ::Section::Closed:: *)
(*Private implementation*)


(* ::Subsection::Closed:: *)
(*Private context header*)


Begin["`Private`"];

$ContextPath = DeleteDuplicates[Join[$ContextPath, {"IronLibrary`"}]];


(* ::Subsection::Closed:: *)
(*Shared state, constants, and predicates*)


(* ::Subsubsection::Closed:: *)
(*State initialization*)


newState[] := newState[Automatic];
newState[seed_] := $state = Association["seed" -> Replace[seed, Automatic :> RandomInteger[{1, 2^31 - 1}]]];
ensureStateInitialized[] := If[AssociationQ[$state], $state, newState[]];

resetIronSession[] := (Clear[$state, $soloCharacter]; );
getIronState[] := If[AssociationQ[$state], $state, $Failed];
setIronState[state_Association] := ($state = state);
soloCharacter[] := If[ValueQ[$soloCharacter], $soloCharacter, $Failed];

characterExistsQ[character_] :=
	AssociationQ[$state] &&
	StringQ[character] &&
	KeyExistsQ[$state, character];


(* ::Subsubsection::Closed:: *)
(*Symbol to string conversion*)


symString[symbol_] := ToLowerCase[SymbolName[symbol]];


(* ::Subsubsection::Closed:: *)
(*Constants*)


stats = {Edge, Heart, Iron, Shadow, Wits, Health, Spirit, Supply};
ranks = {Troublesome, Dangerous, Formidable, Extreme, Epic};
debilities = {Wounded, Shaken, Unprepared, Encumbered, Maimed, Corrupted, Cursed, Tormented};
permanentDebilities = {Maimed, Corrupted};
recoverableConditions = {Wounded, Shaken, Unprepared, Encumbered};
delveThemes = {"Ancient", "Corrupted", "Fortified", "Hallowed", "Haunted", "Infested", "Ravaged", "Wild"};
delveDomains = {"Barrow", "Cavern", "Frozen Cavern", "Icereach", "Mine", "Pass", "Ruin", "Sea Cave", "Shadowfen", "Stronghold", "Tanglewood", "Underkeep"};
denizenSlotRanges = {
	"01-27", "28-41", "42-55", "56-69",
	"70-75", "76-81", "82-87", "88-93",
	"94-95", "96-97", "98-99", "00"
};
denizenSlotLabels = {
	"Very Common", "Common", "Common", "Common",
	"Uncommon", "Uncommon", "Uncommon", "Uncommon",
	"Rare", "Rare", "Rare", "Unforeseen"
};
denizenSlotThresholds = {27, 41, 55, 69, 75, 81, 87, 93, 95, 97, 99, 100};


(* ::Subsubsection::Closed:: *)
(*Argument tests*)


statQ[input_] := MemberQ[stats, input];
rankQ[input_] := MemberQ[ranks, input];
statValueQ[input_Integer] := 0 <= input <= 5;
debilityQ[input_] := MemberQ[debilities, input];
delveThemeQ[input_String] := MemberQ[delveThemes, input];
delveDomainQ[input_String] := MemberQ[delveDomains, input];


(* ::Subsubsection::Closed:: *)
(*Progress tracks*)


makeProgressTrack[(rank_)?rankQ, progress_:0] :=
   Association["rank" -> rank, "progress" -> progress];
progressRollResult = actionRollResult;


(* ::Subsubsection::Closed:: *)
(*Attribute getters*)


getAttr[attr_String, character_:$soloCharacter] := $state[character, attr];
getAttr[attr_, character_:$soloCharacter] := getAttr[symString[attr], character];

getEdge[character_:$soloCharacter] := getAttr["edge", character];
getHeart[character_:$soloCharacter] := getAttr["heart", character];
getIron[character_:$soloCharacter] := getAttr["iron", character];
getShadow[character_:$soloCharacter] := getAttr["shadow", character];
getWits[character_:$soloCharacter] := getAttr["wits", character];

getDebilities[character_:$soloCharacter] := getAttr["debilities", character];

getMomentum[character_:$soloCharacter] := getAttr["momentum", character];
getMomentumReset[character_:$soloCharacter] := Max[0, 2 - Length[getDebilities[character]]];
getMomentumMax[character_:$soloCharacter] := 10 - Length[getDebilities[character]];

getHealth[character_:$soloCharacter] := getAttr["health", character];
getSpirit[character_:$soloCharacter] := getAttr["spirit", character];
getSupply[character_:$soloCharacter] := getAttr["supply", character];


(* ::Subsubsection::Closed:: *)
(*State bounds and debility helpers*)


resourceLabel["health"] := "Health";
resourceLabel["spirit"] := "Spirit";
resourceLabel["supply"] := "Supply";
resourceLabel["momentum"] := "Momentum";

resourceBounds["health", _] := {0, 5};
resourceBounds["spirit", _] := {0, 5};
resourceBounds["supply", _] := {0, 5};
resourceBounds["momentum", character_] := {-6, getMomentumMax[character]};

recoveryBlockingDebility["health"] := Wounded;
recoveryBlockingDebility["spirit"] := Shaken;
recoveryBlockingDebility["supply"] := Unprepared;
recoveryBlockingDebility[_] := None;

debilityLabel[debility_] :=
	SymbolName[Unevaluated[debility]];

ensureCharacterState[character_] :=
	If[characterExistsQ[character],
		True,
		Message[state::nochar, character];
		False
	];

clampValue[value_, {min_, max_}] :=
	Min[Max[value, min], max];

setBoundedAttr[attr_String, value_Integer, character_] := Module[
	{bounds, clamped},
	If[!ensureCharacterState[character], Return[$Failed]];
	bounds = resourceBounds[attr, character];
	clamped = clampValue[value, bounds];
	If[value =!= clamped,
		Message[state::clamped, resourceLabel[attr], character, value, clamped]
	];
	$state[character, attr] = clamped
];

enforceMomentumBounds[character_] := Module[
	{current},
	If[!ensureCharacterState[character], Return[$Failed]];
	current = getMomentum[character];
	setBoundedAttr["momentum", current, character]
];

adjustBoundedAttr[attr_String, n_Integer, character_] := Module[
	{current, requested, clamped, block, bounds},
	If[!ensureCharacterState[character], Return[$Failed]];
	current = getAttr[attr, character];
	block = recoveryBlockingDebility[attr];
	If[n > 0 && block =!= None && MemberQ[getDebilities[character], block],
		Message[state::blocked, resourceLabel[attr], debilityLabel[block], character];
		Return[current]
	];
	requested = current + n;
	bounds = resourceBounds[attr, character];
	clamped = clampValue[requested, bounds];
	If[requested =!= clamped,
		Message[state::clamped, resourceLabel[attr], character, requested, clamped]
	];
	$state[character, attr] = clamped;
	If[attr === "supply" && current > 0 && clamped === 0,
		Message[state::supplyzero, character]
	];
	If[attr === "momentum" && clamped === -6 && (current > -6 || requested < -6),
		Message[state::momentummin, character]
	];
	clamped
];

state::nochar = "No character named `1` exists in the current state.";
state::blocked = "Cannot increase `1` while `2` is marked for character `3`.";
state::clamped = "`1` for character `2` was clamped from `3` to `4`.";
state::supplyzero = "Supply has reached zero for character `1`.";
state::momentummin = "Momentum has reached its minimum for character `1`.";


(* ::Subsubsection::Closed:: *)
(*Attribute adjusters and setters*)


resetMomentum[character_:$soloCharacter] :=
	$state[character, "momentum"] = getMomentumReset[character];

adjustMomentum[n_Integer, character_ : $soloCharacter] :=
	adjustBoundedAttr["momentum", n, character];

adjustHealth[n_Integer, character_ : $soloCharacter] :=
	adjustBoundedAttr["health", n, character];

adjustSpirit[n_Integer, character_ : $soloCharacter] :=
	adjustBoundedAttr["spirit", n, character];

adjustSupply[n_Integer, character_ : $soloCharacter] :=
	adjustBoundedAttr["supply", n, character];


(* ::Subsubsection::Closed:: *)
(*Progress track getters*)


getProgress[trackName_String, character_:$soloCharacter] := Module[
	{target},
	target = progressTargetData[trackName, character];
	If[target === $Failed, Return[$Failed]];
	target["Progress"]
];
getRank[trackName_String, character_:$soloCharacter] := Module[
	{target},
	target = progressTargetData[trackName, character];
	If[target === $Failed, Return[$Failed]];
	target["Rank"]
];




(* ::Subsection::Closed:: *)
(*Roll and oracle mechanics*)


(* ::Subsubsection::Closed:: *)
(*Rolling dice*)


rollChallengeDice[] := RandomInteger[{1, 10}, 2];
rollActionDie[] := RandomInteger[{1, 6}];
rollResultFromBeatCount[count_Integer] :=
	<|0 -> "miss", 1 -> "weakHit", 2 -> "strongHit"|>[count];

rollResultRank["miss"] := 0;
rollResultRank["weakHit"] := 1;
rollResultRank["strongHit"] := 2;
rollResultRank[_] := -1;

actionRollResult[challengeDice_List, actionScore_Integer] :=
	rollResultFromBeatCount[
		Count[challengeDice, die_ /; actionScore > die]
	];

actionDieAfterMomentumCancel[actionDie_Integer, momentum_Integer] :=
	If[momentum < 0 && Abs[momentum] == actionDie, {0, True}, {actionDie, False}];

actionScoreFromParts[actionValue_Integer, statValue_Integer, adds_Association] :=
	Min[actionValue + Total[Values[adds]] + statValue, 10];

rollOracleDice = rollChallengeDice;


(* ::Subsubsection::Closed:: *)
(*Oracle roll helpers*)


oracleRollValue[{tensDie_Integer, onesDie_Integer}]:=Module[{tensValue, onesValue},
	tensValue = If[tensDie==10, 0, tensDie*10];
	onesValue = If[onesDie==10, 0, onesDie];
	If[tensDie==onesDie==10, 100, tensValue+onesValue]
];
oracleRollOutcome[table_Association, value_Integer] := Module[{key},
	key = First[Select[Sort[Keys[table]], # >= value &]];
	table[key]
];

oracleRollData[table_Association] := Module[{oracleDice, od1, od2, value, outcome, match},
	oracleDice = {od1, od2} = rollOracleDice[];
	value = oracleRollValue[oracleDice];
	outcome = oracleRollOutcome[table, value];
	match = (od1==od2);
	<|"oracleDice" -> oracleDice, "value" -> value, "outcome" -> outcome, "match" -> match|>
];

oracleRoll[tableName_String, table_Association] := Module[{roll},
	roll = oracleRollData[table];
	Join[<|"tableName" -> tableName|>, roll]
];



(* ::Subsubsection::Closed:: *)
(*Roll type predicates and reroll support*)


actionRollQ[roll_Association] :=
	KeyExistsQ[roll, "actionDie"] &&
	KeyExistsQ[roll, "actionScore"] &&
	KeyExistsQ[roll, "challengeDice"];

progressRollQ[roll_Association] :=
	KeyExistsQ[roll, "progressScore"] &&
	KeyExistsQ[roll, "challengeDice"] &&
	!KeyExistsQ[roll, "actionDie"];

rollQ[roll_Association] :=
	actionRollQ[roll] || progressRollQ[roll];

rerollSelectionQ[ActionDie] := True;
rerollSelectionQ[ChallengeDice] := True;
rerollSelectionQ[LargerChallengeDie] := True;
rerollSelectionQ[SmallerChallengeDie] := True;
rerollSelectionQ[_] := False;

challengeDieIndex[LargerChallengeDie, challengeDice_List] :=
	First @ FirstPosition[challengeDice, Max[challengeDice]];

challengeDieIndex[SmallerChallengeDie, challengeDice_List] :=
	First @ FirstPosition[challengeDice, Min[challengeDice]];

normalizeRerollSelection[die_] :=
	normalizeRerollSelection[{die}];

normalizeRerollSelection[dice_List] :=
	DeleteDuplicates[dice];

rerollChallengeDieIndices[selection_List, challengeDice_List] := Module[{indices},
	indices = {};

	If[MemberQ[selection, ChallengeDice],
		indices = Join[indices, {1, 2}]
	];

	If[
		MemberQ[selection, LargerChallengeDie] &&
		MemberQ[selection, SmallerChallengeDie],
		indices = Join[indices, {1, 2}],
		If[MemberQ[selection, LargerChallengeDie],
			AppendTo[indices, challengeDieIndex[LargerChallengeDie, challengeDice]]
		];

		If[MemberQ[selection, SmallerChallengeDie],
			AppendTo[indices, challengeDieIndex[SmallerChallengeDie, challengeDice]]
		]
	];

	DeleteDuplicates[indices]
];

reroll::baddie =
"`1` is not a valid reroll selection. Use ActionDie, ChallengeDice, LargerChallengeDie, or SmallerChallengeDie.";

reroll::badroll =
"`1` is not an action roll or progress roll association.";

reroll::actiondie =
"ActionDie can only be rerolled in an action roll.";

reroll::empty =
"No dice were specified for reroll.";

reroll::badchallenge =
"Could not determine which challenge die to reroll from selection `1`.";




(* ::Subsection::Closed:: *)
(*Asset metadata and ownership helpers*)


assetDataAssociation[] := AssetData`assetData;

assetNames[] :=
	Keys[assetDataAssociation[]];

assetCategories[] :=
	DeleteDuplicates[Lookup[Values[assetDataAssociation[]], "Category"]];

assetRecord[name_String] :=
	Lookup[assetDataAssociation[], name, Missing["UnknownAsset", name]];

assetRecordQ[name_String] :=
	AssociationQ[assetRecord[name]];

assetAbilityIndices[record_Association] :=
	Lookup[Lookup[record, "Abilities", {}], "Index", {}];

defaultAssetAbilities[record_Association] :=
	Lookup[record, "DefaultAbilities", {}];

assetFieldKeys[record_Association] :=
	Keys[Lookup[record, "Fields", <||>]];

initialAssetTracks[record_Association] :=
	Association @ KeyValueMap[
		#1 -> Lookup[#2, "Default", Lookup[#2, "Max", 0]] &,
		Lookup[record, "Tracks", <||>]
	];

normalizeAbilitySelection[Automatic, record_Association] := Module[
	{defaults},
	defaults = defaultAssetAbilities[record];
	If[defaults === {},
		Message[asset::nodefault, record["Name"]];
		Return[$Failed]
	];
	defaults
];

normalizeAbilitySelection[ability_Integer, record_Association] :=
	normalizeAbilitySelection[{ability}, record];

normalizeAbilitySelection[abilities_List, record_Association] /; VectorQ[abilities, IntegerQ] && abilities =!= {} := Module[
	{valid, duplicates, invalid},
	valid = assetAbilityIndices[record];
	duplicates = DeleteDuplicates[Cases[Tally[abilities], {ability_, count_} /; count > 1 :> ability]];
	If[duplicates =!= {},
		Message[asset::dupeability, First[duplicates], record["Name"]];
		Return[$Failed]
	];
	invalid = Select[abilities, !MemberQ[valid, #] &];
	If[invalid =!= {},
		Message[asset::badability, First[invalid], record["Name"], Length[valid]];
		Return[$Failed]
	];
	Sort[abilities]
];

normalizeAbilitySelection[_, record_Association] := (
	Message[asset::badabilities, record["Name"]];
	$Failed
);

normalizeAssetFields[fields_Association, record_Association] := Module[
	{keys, invalid, blankFields},
	keys = assetFieldKeys[record];
	invalid = Complement[Keys[fields], keys];
	If[invalid =!= {},
		Message[asset::badfield, First[invalid], record["Name"]];
		Return[$Failed]
	];
	blankFields = AssociationThread[keys -> ConstantArray["", Length[keys]]];
	Join[blankFields, fields]
];

normalizeAssetFields[_, record_Association] := (
	Message[asset::badfields, record["Name"]];
	$Failed
);

makeOwnedAsset[name_String, abilitySpec_, fields_Association] := Module[
	{record, abilities, normalizedFields},
	record = assetRecord[name];
	If[!AssociationQ[record],
		Message[asset::unknown, name];
		Return[$Failed]
	];
	abilities = normalizeAbilitySelection[abilitySpec, record];
	If[abilities === $Failed, Return[$Failed]];
	normalizedFields = normalizeAssetFields[fields, record];
	If[normalizedFields === $Failed, Return[$Failed]];
		Association[
			"Name" -> record["Name"],
			"Abilities" -> abilities,
			"Fields" -> normalizedFields,
			"Tracks" -> initialAssetTracks[record],
			"Rarity" -> None
		]
	];

makeStarterAssetSpec[name_String, abilitySpec_, fields_Association] := Module[
	{owned},
	owned = makeOwnedAsset[name, abilitySpec, fields];
	If[owned === $Failed, Return[$Failed]];
	StarterAssetSpec[
		Association[
			"Name" -> owned["Name"],
			"Abilities" -> owned["Abilities"],
			"Fields" -> owned["Fields"]
		]
	]
];

ownedAssetFromSpec[$Failed] :=
	$Failed;

ownedAssetFromSpec[name_String] :=
	makeOwnedAsset[name, Automatic, <||>];

ownedAssetFromSpec[StarterAssetSpec[data_Association]] :=
	makeOwnedAsset[data["Name"], data["Abilities"], Lookup[data, "Fields", <||>]];

ownedAssetFromSpec[other_] := (
	Message[asset::badasset, other];
	$Failed
);

ownedAssetQ[owned_Association] :=
	KeyExistsQ[owned, "Name"] &&
	KeyExistsQ[owned, "Abilities"] &&
	KeyExistsQ[owned, "Fields"] &&
	KeyExistsQ[owned, "Tracks"];

normalizeCharacterAssets[character_] := Module[
	{rawAssets, normalizedAssets},
	If[!characterExistsQ[character],
		Message[asset::nochar, character];
		Return[$Failed]
	];
	rawAssets = Lookup[$state[character], "assets", {}];
	If[AllTrue[rawAssets, ownedAssetQ],
		$state[character, "assets"] = Association[#, "Rarity" -> Lookup[#, "Rarity", None]] & /@ rawAssets;
		Return[$state[character, "assets"]]
	];
	normalizedAssets = ownedAssetFromSpec /@ rawAssets;
	If[MemberQ[normalizedAssets, $Failed],
		Message[asset::badstoredassets, character];
		Return[$Failed]
	];
	$state[character, "assets"] = normalizedAssets
];

ownedAssetContext[assetName_String, character_] := Module[
	{record, ownedAssets, positions, index},
	record = assetRecord[assetName];
	If[!AssociationQ[record],
		Message[asset::unknown, assetName];
		Return[$Failed]
	];
	ownedAssets = normalizeCharacterAssets[character];
	If[ownedAssets === $Failed, Return[$Failed]];
	positions = Flatten @ Position[Lookup[ownedAssets, "Name", Missing["NoName"]], assetName];
	If[positions === {},
		Message[asset::notowned, assetName, character];
		Return[$Failed]
	];
	index = First[positions];
	Association[
		"Record" -> record,
		"Assets" -> ownedAssets,
		"Index" -> index,
		"Owned" -> ownedAssets[[index]]
	]
];

replaceOwnedAsset[character_, index_Integer, owned_Association] := Module[
	{updatedAssets},
	updatedAssets = $state[character, "assets"];
	updatedAssets[[index]] = owned;
	$state[character, "assets"] = updatedAssets;
	owned
];

ownedAssetTracks[record_Association, owned_Association] :=
	Join[initialAssetTracks[record], Lookup[owned, "Tracks", <||>]];

requireExperience[character_, cost_Integer] := Module[
	{available},
	available = availableExperience[character];
	If[available < cost,
		Message[asset::xp, character, cost, available];
		Return[False]
	];
	True
];

ownedCompanionContext[assetName_String, character_] := Module[
	{context},
	context = ownedAssetContext[assetName, character];
	If[context === $Failed, Return[$Failed]];
	If[Lookup[context["Record"], "Category", ""] =!= "Companion",
		Message[asset::notcompanion, assetName];
		Return[$Failed]
	];
	context
];

availableExperience[character_] :=
	Lookup[$state[character], "earnedExperience", 0] -
	Lookup[$state[character], "spentExperience", 0];

assetTrackDefinition[record_Association, trackName_String] :=
	Lookup[Lookup[record, "Tracks", <||>], trackName, Missing["UnknownTrack", trackName]];

clampAssetTrackValue[trackDef_Association, value_Integer] :=
	Clip[value, {trackDef["Min"], trackDef["Max"]}];


(* ::Subsection::Closed:: *)
(*Progress object and legacy state helpers*)


rankMarkValue[Troublesome] := 3;
rankMarkValue[Dangerous] := 2;
rankMarkValue[Formidable] := 1;
rankMarkValue[Extreme] := 0.5;
rankMarkValue[Epic] := 0.25;

makeProgressObject[name_String, rank_?rankQ, progress_:0] :=
	Association[
		"Name" -> name,
		"Rank" -> rank,
		"Progress" -> clampValue[progress, {0, 10}]
	];

normalizeProgressObject[name_String, data_, defaultRank_?rankQ, defaultProgress_:0] := Module[
	{objectName, rank, progress},
	If[!AssociationQ[data],
		Return[makeProgressObject[name, defaultRank, defaultProgress]]
	];
	objectName = Lookup[data, "Name", name];
	If[!StringQ[objectName], objectName = name];
	rank = Lookup[data, "Rank", Lookup[data, "rank", defaultRank]];
	If[!rankQ[rank], rank = defaultRank];
	progress = Lookup[data, "Progress", Lookup[data, "progress", defaultProgress]];
	If[!NumericQ[progress], progress = defaultProgress];
	makeProgressObject[objectName, rank, progress]
];

normalizeProgressObject[name_String, data_] :=
	normalizeProgressObject[name, data, Dangerous, 0];

legacyProgressTrack[character_, name_String] := Module[
	{legacy},
	legacy = Lookup[$state[character], "progressTracks", <||>];
	If[AssociationQ[legacy], Lookup[legacy, name, Missing["NoLegacyTrack"]], Missing["NoLegacyTrack"]]
];

ensureCharacterCoreProgress[character_] := Module[
	{legacyFailures, legacyBonds, legacyVows, bondDefault},
	If[!characterExistsQ[character],
		Message[state::nochar, character];
		Return[$Failed]
	];
	legacyFailures = legacyProgressTrack[character, "Failures"];
	If[!KeyExistsQ[$state[character], "failures"],
		$state[character, "failures"] = normalizeProgressObject[
			"Failures",
			If[MissingQ[legacyFailures], makeProgressTrack[Epic], legacyFailures],
			Epic
		],
		$state[character, "failures"] = normalizeProgressObject["Failures", $state[character, "failures"], Epic]
	];
	legacyBonds = legacyProgressTrack[character, "Bonds"];
	bondDefault = 0.25 Length[Lookup[$state[character], "bonds", {}]];
	If[!KeyExistsQ[$state[character], "bondProgress"],
		$state[character, "bondProgress"] = normalizeProgressObject[
			"Bonds",
			If[MissingQ[legacyBonds], makeProgressTrack[Epic, bondDefault], legacyBonds],
			Epic,
			bondDefault
		],
		$state[character, "bondProgress"] = normalizeProgressObject["Bonds", $state[character, "bondProgress"], Epic, bondDefault]
	];
	If[!KeyExistsQ[$state[character], "journeys"] || !AssociationQ[$state[character, "journeys"]],
		$state[character, "journeys"] = <||>
	];
	If[!KeyExistsQ[$state[character], "currentJourney"],
		$state[character, "currentJourney"] = None
	];
	If[!KeyExistsQ[$state[character], "foes"] || !AssociationQ[$state[character, "foes"]],
		$state[character, "foes"] = <||>
	];
	If[!KeyExistsQ[$state[character], "vows"] || !AssociationQ[$state[character, "vows"]],
		legacyVows = legacyProgressTrackVows[character];
		$state[character, "vows"] = legacyVows
	];
	If[KeyExistsQ[$state[character], "progressTracks"],
		$state[character] = KeyDrop[$state[character], "progressTracks"]
	];
	$state[character]
];

normalizeProgressObjectAssociation[character_, key_String] := Module[
	{raw, normalized},
	If[ensureCharacterCoreProgress[character] === $Failed, Return[$Failed]];
	raw = Lookup[$state[character], key, <||>];
	If[!AssociationQ[raw], raw = <||>];
	normalized = Association @ KeyValueMap[
		#1 -> normalizeProgressObject[#1, #2] &,
		raw
	];
	$state[character, key] = normalized;
	normalized
];

journeyExistsQ[name_String, character_] := Module[
	{ownedJourneys},
	ownedJourneys = normalizeCharacterJourneys[character];
	If[ownedJourneys === $Failed, Return[False]];
	KeyExistsQ[ownedJourneys, name]
];

journeyByName[name_String, character_] := Module[
	{ownedJourneys},
	ownedJourneys = normalizeCharacterJourneys[character];
	If[ownedJourneys === $Failed, Return[$Failed]];
	Lookup[ownedJourneys, name, Missing["UnknownJourney", name]]
];

currentJourneyName[character_] := Module[
	{ownedJourneys, current},
	ownedJourneys = normalizeCharacterJourneys[character];
	If[ownedJourneys === $Failed, Return[$Failed]];
	current = Lookup[$state[character], "currentJourney", None];
	If[current === None,
		Message[journey::nocurrent, character];
		Return[$Failed]
	];
	If[!KeyExistsQ[ownedJourneys, current],
		Message[journey::unknown, current, character];
		Return[$Failed]
	];
	current
];

currentJourneyData[character_] := Module[
	{current},
	current = currentJourneyName[character];
	If[current === $Failed, Return[$Failed]];
	journeyByName[current, character]
];

foeExistsQ[name_String, character_] := Module[
	{ownedFoes},
	ownedFoes = normalizeCharacterFoes[character];
	If[ownedFoes === $Failed, Return[False]];
	KeyExistsQ[ownedFoes, name]
];

foeByName[name_String, character_] := Module[
	{ownedFoes},
	ownedFoes = normalizeCharacterFoes[character];
	If[ownedFoes === $Failed, Return[$Failed]];
	Lookup[ownedFoes, name, Missing["UnknownFoe", name]]
];

failureProgressData[character_] := Module[{},
	If[ensureCharacterCoreProgress[character] === $Failed, Return[$Failed]];
	$state[character, "failures"]
];

bondProgressData[character_] := Module[{},
	If[ensureCharacterCoreProgress[character] === $Failed, Return[$Failed]];
	$state[character, "bondProgress"]
];


(* ::Subsection::Closed:: *)
(*Vow and threat helpers*)

normalizeThreatSpec[None] :=
	None;

normalizeThreatSpec[{name_String, goal_String}] :=
	Association[
		"Name" -> name,
		"Goal" -> goal,
		"Menace" -> makeProgressTrack[Formidable]
	];

normalizeThreatSpec[threatData_Association] /; threatAssociationQ[threatData] :=
	threatData;

normalizeThreatSpec[other_] := (
	Message[vow::badthreat, other];
	$Failed
);

makeVow[name_String, rank_?rankQ, threatSpec_] := Module[
	{normalizedThreat},
	normalizedThreat = normalizeThreatSpec[threatSpec];
	If[normalizedThreat === $Failed, Return[$Failed]];
	Association[
		"Name" -> name,
		"Rank" -> rank,
		"Progress" -> 0,
		"Threat" -> normalizedThreat
	]
];

backgroundVowRankQ[rank_] :=
	MemberQ[{Extreme, Epic}, rank];

makeStarterVowSpec[name_String, rank_?rankQ, threatSpec_] := Module[
	{normalizedVow},
	If[!backgroundVowRankQ[rank],
		Message[vow::badbackgroundrank, rank];
		Return[$Failed]
	];
	normalizedVow = makeVow[name, rank, threatSpec];
	If[normalizedVow === $Failed, Return[$Failed]];
	StarterVowSpec[normalizedVow]
];

ownedVowFromSpec[StarterVowSpec[data_Association]] /; ownedVowQ[data] :=
	data;

ownedVowFromSpec[{name_String, rank_?rankQ}] := Module[{},
	If[!backgroundVowRankQ[rank],
		Message[vow::badbackgroundrank, rank];
		Return[$Failed]
	];
	makeVow[name, rank, None]
];

ownedVowFromSpec[other_] := (
	Message[vow::badstarter, other];
	$Failed
);

ownedVowQ[vow_Association] :=
	KeyExistsQ[vow, "Name"] &&
	KeyExistsQ[vow, "Rank"] &&
	KeyExistsQ[vow, "Progress"] &&
	KeyExistsQ[vow, "Threat"];

progressVowQ[vow_Association] :=
	AnyTrue[{"Rank", "rank", "Progress", "progress"}, KeyExistsQ[vow, #] &];

normalizeOwnedVow[name_String, vow_Association] /; ownedVowQ[vow] := Module[
	{vowName, rank, progress, threat},
	vowName = Lookup[vow, "Name", name];
	If[!StringQ[vowName], vowName = name];
	rank = Lookup[vow, "Rank", Dangerous];
	If[!rankQ[rank], rank = Dangerous];
	progress = Lookup[vow, "Progress", 0];
	If[!NumericQ[progress], progress = 0];
	threat = normalizeThreatSpec[Lookup[vow, "Threat", None]];
	If[threat === $Failed, Return[$Failed]];
	Association[
		"Name" -> vowName,
		"Rank" -> rank,
		"Progress" -> clampValue[progress, {0, 10}],
		"Threat" -> threat
	]
];

normalizeOwnedVow[name_String, vow_Association] /; progressVowQ[vow] := Module[
	{progressTrack},
	progressTrack = normalizeProgressObject[name, vow];
	Association[
		"Name" -> progressTrack["Name"],
		"Rank" -> progressTrack["Rank"],
		"Progress" -> progressTrack["Progress"],
		"Threat" -> None
	]
];

normalizeOwnedVow[_, _] :=
	$Failed;

normalizeVowAssociation[rawVows_Association] := Module[
	{normalized},
	normalized = Association @ KeyValueMap[#1 -> normalizeOwnedVow[#1, #2] &, rawVows];
	If[MemberQ[Values[normalized], $Failed],
		$Failed,
		Association @ KeyValueMap[#2["Name"] -> #2 &, normalized]
	]
];

legacyProgressTrackVows[character_] := Module[
	{legacy, legacyVows},
	legacy = Lookup[$state[character], "progressTracks", <||>];
	If[!AssociationQ[legacy], Return[<||>]];
	legacyVows = KeyDrop[legacy, {"Bonds", "Failures"}];
	If[legacyVows === <||>,
		<||>,
		Replace[normalizeVowAssociation[legacyVows], $Failed -> <||>]
	]
];

normalizeCharacterVows[character_] := Module[
	{rawVows, normalized},
	If[!characterExistsQ[character],
		Message[vow::nochar, character];
		Return[$Failed]
	];
	rawVows = Lookup[$state[character], "vows", <||>];
	If[AssociationQ[rawVows],
		normalized = normalizeVowAssociation[rawVows];
		If[normalized =!= $Failed,
			$state[character, "vows"] = normalized;
			Return[normalized]
		]
	];
	normalized = legacyProgressTrackVows[character];
	$state[character, "vows"] = normalized;
	normalized
];

vowExistsQ[vowName_String, character_] := Module[
	{ownedVows},
	ownedVows = normalizeCharacterVows[character];
	If[ownedVows === $Failed, Return[False]];
	KeyExistsQ[ownedVows, vowName]
];

vowByName[vowName_String, character_] := Module[
	{ownedVows},
	ownedVows = normalizeCharacterVows[character];
	If[ownedVows === $Failed, Return[$Failed]];
	Lookup[ownedVows, vowName, Missing["UnknownVow", vowName]]
];

threatAssociationQ[threat_Association] :=
	KeyExistsQ[threat, "Name"] &&
	KeyExistsQ[threat, "Goal"] &&
	KeyExistsQ[threat, "Menace"];

threatByVowName[vowName_String, character_] := Module[
	{ownedVow, ownedThreat},
	ownedVow = vowByName[vowName, character];
	If[!AssociationQ[ownedVow],
		Message[vow::unknown, vowName, character];
		Return[$Failed]
	];
	ownedThreat = Lookup[ownedVow, "Threat", None];
	If[ownedThreat === None,
		Message[vow::nothreat, vowName];
		Return[$Failed]
	];
	ownedThreat
];

threatLocationByName[threatName_String, character_] := Module[
	{ownedVows, matches},
	ownedVows = normalizeCharacterVows[character];
	If[ownedVows === $Failed, Return[$Failed]];
	matches = Select[
		Keys[ownedVows],
		AssociationQ[ownedVows[#]["Threat"]] &&
			ownedVows[#]["Threat", "Name"] === threatName &
	];
	If[matches === {},
		Missing["UnknownThreat", threatName],
		First[matches]
	]
];


(* ::Subsection::Closed:: *)
(*Delve and scene normalization helpers*)

normalizeDelveCards[cards_String, kind_String] :=
	normalizeDelveCards[{cards}, kind];

normalizeDelveCards[cards : {__String}, "Theme"] /; 1 <= Length[cards] <= 2 := Module[
	{invalid},
	invalid = Select[cards, !delveThemeQ[#] &];
	If[invalid =!= {},
		Message[delve::badtheme, First[invalid], StringRiffle[delveThemes, ", "]];
		Return[$Failed]
	];
	cards
];

normalizeDelveCards[cards : {__String}, "Domain"] /; 1 <= Length[cards] <= 2 := Module[
	{invalid},
	invalid = Select[cards, !delveDomainQ[#] &];
	If[invalid =!= {},
		Message[delve::baddomain, First[invalid], StringRiffle[delveDomains, ", "]];
		Return[$Failed]
	];
	cards
];

normalizeDelveCards[_, kind_String] := (
	Message[delve::badcards, kind];
	$Failed
);

validateDelveCardPair[themes_List, domains_List] :=
	If[Length[themes] == 2 && Length[domains] == 2,
		Message[delve::toomanycards];
		$Failed,
		True
	];

defaultDenizens[] :=
	ConstantArray[None, 12];

normalizeDenizenSlot[None] :=
	None;

normalizeDenizenSlot[name_String] /; StringLength[StringTrim[name]] > 0 :=
	name;

normalizeDenizenSlot[_] :=
	$Failed;

normalizeDenizens[Automatic] :=
	defaultDenizens[];

normalizeDenizens[denizenSpec_List] /; Length[denizenSpec] == 12 := Module[
	{normalized},
	normalized = normalizeDenizenSlot /@ denizenSpec;
	If[MemberQ[normalized, $Failed],
		Message[delve::baddenizens];
		Return[$Failed]
	];
	normalized
];

normalizeDenizens[_] := (
	Message[delve::baddenizens];
	$Failed
);

makeDelve[name_String, rank_?rankQ, themeSpec_, domainSpec_, objective_, denizenSpec_:Automatic] := Module[
	{themes, domains, denizenList},
	themes = normalizeDelveCards[themeSpec, "Theme"];
	If[themes === $Failed, Return[$Failed]];
	domains = normalizeDelveCards[domainSpec, "Domain"];
	If[domains === $Failed, Return[$Failed]];
	If[validateDelveCardPair[themes, domains] === $Failed, Return[$Failed]];
	If[!(objective === None || StringQ[objective]),
		Message[delve::badobjective, objective];
		Return[$Failed]
	];
	denizenList = normalizeDenizens[denizenSpec];
	If[denizenList === $Failed, Return[$Failed]];
	Association[
		"Name" -> name,
		"Rank" -> rank,
		"Themes" -> themes,
		"Domains" -> domains,
		"Theme" -> First[themes],
		"Domain" -> First[domains],
		"Objective" -> objective,
		"Denizens" -> denizenList,
		"Progress" -> 0
	]
];

normalizeOwnedDelve[delve_Association] /;
	KeyExistsQ[delve, "Name"] &&
	KeyExistsQ[delve, "Rank"] &&
	KeyExistsQ[delve, "Progress"] := Module[
	{themes, domains, objective, denizenList, normalized},
	themes = Which[
		KeyExistsQ[delve, "Themes"], normalizeDelveCards[delve["Themes"], "Theme"],
		KeyExistsQ[delve, "Theme"], normalizeDelveCards[delve["Theme"], "Theme"],
		True, $Failed
	];
	If[themes === $Failed, Return[$Failed]];
	domains = Which[
		KeyExistsQ[delve, "Domains"], normalizeDelveCards[delve["Domains"], "Domain"],
		KeyExistsQ[delve, "Domain"], normalizeDelveCards[delve["Domain"], "Domain"],
		True, $Failed
	];
	If[domains === $Failed, Return[$Failed]];
	If[validateDelveCardPair[themes, domains] === $Failed, Return[$Failed]];
	objective = Lookup[delve, "Objective", None];
	If[!(objective === None || StringQ[objective]), objective = None];
	denizenList = normalizeDenizens[Lookup[delve, "Denizens", Automatic]];
	If[denizenList === $Failed, denizenList = defaultDenizens[]];
	normalized = Association[delve];
	normalized["Themes"] = themes;
	normalized["Domains"] = domains;
	normalized["Theme"] = First[themes];
	normalized["Domain"] = First[domains];
	normalized["Objective"] = objective;
	normalized["Denizens"] = denizenList;
	normalized
];

normalizeOwnedDelve[_] :=
	$Failed;

ownedDelveQ[delve_Association] :=
	AssociationQ[normalizeOwnedDelve[delve]];

normalizeCharacterDelves[character_] := Module[
	{rawDelves, normalized},
	If[!characterExistsQ[character],
		Message[delve::nochar, character];
		Return[$Failed]
	];
	rawDelves = Lookup[$state[character], "delves", <||>];
	If[AssociationQ[rawDelves],
		normalized = Association @ KeyValueMap[#1 -> normalizeOwnedDelve[#2] &, rawDelves];
		If[!MemberQ[Values[normalized], $Failed],
			$state[character, "delves"] = normalized;
			If[!KeyExistsQ[$state[character], "currentDelve"],
				$state[character, "currentDelve"] = None
			];
			Return[normalized]
		]
	];
	$state[character, "delves"] = <||>;
	$state[character, "currentDelve"] = None;
	<||>
];

delveExistsQ[name_String, character_] := Module[
	{ownedDelves},
	ownedDelves = normalizeCharacterDelves[character];
	If[ownedDelves === $Failed, Return[False]];
	KeyExistsQ[ownedDelves, name]
];

delveByName[name_String, character_] := Module[
	{ownedDelves},
	ownedDelves = normalizeCharacterDelves[character];
	If[ownedDelves === $Failed, Return[$Failed]];
	Lookup[ownedDelves, name, Missing["UnknownDelve", name]]
];

requireDelve[delveName_String, character_] := Module[
	{ownedDelve},
	ownedDelve = delveByName[delveName, character];
	If[!AssociationQ[ownedDelve],
		Message[delve::unknown, delveName, character];
		Return[$Failed]
	];
	ownedDelve
];

currentDelveName[character_] := Module[
	{ownedDelves, current},
	ownedDelves = normalizeCharacterDelves[character];
	If[ownedDelves === $Failed, Return[$Failed]];
	current = Lookup[$state[character], "currentDelve", None];
	If[current === None,
		Message[delve::nocurrent, character];
		Return[$Failed]
	];
	If[!KeyExistsQ[ownedDelves, current],
		Message[delve::unknown, current, character];
		Return[$Failed]
	];
	current
];

currentDelveData[] := currentDelveData[$soloCharacter];

currentDelveData[character_] := Module[
	{current},
	current = currentDelveName[character];
	If[current === $Failed, Return[$Failed]];
	delveByName[current, character]
];

currentDelveDataQuiet[] := currentDelveDataQuiet[$soloCharacter];

currentDelveDataQuiet[character_] := Module[
	{ownedDelves, current},
	If[!characterExistsQ[character], Return[None]];
	ownedDelves = normalizeCharacterDelves[character];
	If[ownedDelves === $Failed, Return[None]];
	current = Lookup[$state[character], "currentDelve", None];
	If[current === None || !KeyExistsQ[ownedDelves, current], Return[None]];
	ownedDelves[current]
];

withCurrentDelve[handler_] := Module[
	{current},
	current = currentDelveName[$soloCharacter];
	If[current === $Failed, Return[$Failed]];
	handler[current, $soloCharacter]
];

normalizeCharacterScene[character_] := Module[
	{rawScene, normalized},
	If[!characterExistsQ[character],
		Message[scene::nochar, character];
		Return[$Failed]
	];
	rawScene = Lookup[$state[character], "scene", None];
	If[rawScene === None,
		Return[None]
	];
	If[
		AssociationQ[rawScene] &&
		KeyExistsQ[rawScene, "Name"] &&
		KeyExistsQ[rawScene, "Rank"] &&
		KeyExistsQ[rawScene, "Progress"] &&
		KeyExistsQ[rawScene, "Countdown"],
		normalized = Association[rawScene];
		normalized["Progress"] = clampValue[normalized["Progress"], {0, 10}];
		normalized["Countdown"] = clampValue[normalized["Countdown"], {0, 4}];
		$state[character, "scene"] = normalized;
		Return[normalized]
	];
	$state[character, "scene"] = None;
	None
];

sceneExistsQ[name_String, character_] := Module[
	{ownedScene},
	ownedScene = normalizeCharacterScene[character];
	If[ownedScene === $Failed || ownedScene === None, Return[False]];
	ownedScene["Name"] === name
];

sceneByName[name_String, character_] := Module[
	{ownedScene},
	ownedScene = normalizeCharacterScene[character];
	If[ownedScene === $Failed || ownedScene === None,
		Return[Missing["UnknownScene", name]]
	];
	If[ownedScene["Name"] === name, ownedScene, Missing["UnknownScene", name]]
];


(* ::Subsection::Closed:: *)
(*Progress target engine*)

progressTargetData[trackName_String, character_] := Module[
	{ownedVow, threatVowName, ownedThreat, ownedDelve, ownedScene, ownedJourney, ownedFoe, ownedFailures, ownedBondProgress},
	If[ensureCharacterCoreProgress[character] === $Failed, Return[$Failed]];
	If[vowExistsQ[trackName, character],
		ownedVow = vowByName[trackName, character];
		Return[
			Association[
				"Type" -> "Vow",
				"Name" -> trackName,
				"Rank" -> ownedVow["Rank"],
				"Progress" -> ownedVow["Progress"]
			]
		]
	];
	threatVowName = threatLocationByName[trackName, character];
	If[StringQ[threatVowName],
		ownedThreat = $state[character, "vows", threatVowName, "Threat"];
		Return[
			Association[
				"Type" -> "Threat",
				"Name" -> trackName,
				"Vow" -> threatVowName,
				"Rank" -> ownedThreat["Menace", "rank"],
				"Progress" -> ownedThreat["Menace", "progress"]
			]
		]
	];
	If[delveExistsQ[trackName, character],
		ownedDelve = delveByName[trackName, character];
		Return[
			Association[
				"Type" -> "Delve",
				"Name" -> trackName,
				"Rank" -> ownedDelve["Rank"],
				"Progress" -> ownedDelve["Progress"]
			]
		]
	];
	If[sceneExistsQ[trackName, character],
		ownedScene = sceneByName[trackName, character];
		Return[
			Association[
				"Type" -> "Scene",
				"Name" -> trackName,
				"Rank" -> ownedScene["Rank"],
				"Progress" -> ownedScene["Progress"]
			]
		]
	];
	If[journeyExistsQ[trackName, character],
		ownedJourney = journeyByName[trackName, character];
		Return[
			Association[
				"Type" -> "Journey",
				"Name" -> trackName,
				"Rank" -> ownedJourney["Rank"],
				"Progress" -> ownedJourney["Progress"]
			]
		]
	];
	If[foeExistsQ[trackName, character],
		ownedFoe = foeByName[trackName, character];
		Return[
			Association[
				"Type" -> "Foe",
				"Name" -> trackName,
				"Rank" -> ownedFoe["Rank"],
				"Progress" -> ownedFoe["Progress"]
			]
		]
	];
	If[trackName === "Failures",
		ownedFailures = failureProgressData[character];
		If[ownedFailures === $Failed, Return[$Failed]];
		Return[
			Association[
				"Type" -> "Failures",
				"Name" -> "Failures",
				"Rank" -> ownedFailures["Rank"],
				"Progress" -> ownedFailures["Progress"]
			]
		]
	];
	If[trackName === "Bonds",
		ownedBondProgress = bondProgressData[character];
		If[ownedBondProgress === $Failed, Return[$Failed]];
		Return[
			Association[
				"Type" -> "Bonds",
				"Name" -> "Bonds",
				"Rank" -> ownedBondProgress["Rank"],
				"Progress" -> ownedBondProgress["Progress"]
			]
		]
	];
	Message[markProgress::notrack, trackName, character];
	$Failed
];



markVowProgress[vowName_String, n_Integer, character_] := Module[
	{target, markValue},
	target = progressTargetData[vowName, character];
	If[target === $Failed || target["Type"] =!= "Vow", Return[$Failed]];
	markValue = n rankMarkValue[target["Rank"]];
	adjustTargetProgress[target, markValue, character]
];

markThreatProgressByVow[vowName_String, n_Integer, character_] := Module[
	{target},
	target = threatProgressTargetByVow[vowName, character];
	If[target === $Failed, Return[$Failed]];
	adjustTargetProgress[target, progressMarkValue[target, n], character]
];

markThreatProgressByName[threatName_String, n_Integer, character_] := Module[
	{vowName},
	vowName = threatLocationByName[threatName, character];
	If[!StringQ[vowName], Return[$Failed]];
	markThreatProgressByVow[vowName, n, character]
];

threatProgressTargetByVow[vowName_String, character_] := Module[
	{ownedThreat},
	ownedThreat = threatByVowName[vowName, character];
	If[ownedThreat === $Failed, Return[$Failed]];
	Association[
		"Type" -> "Threat",
		"Name" -> ownedThreat["Name"],
		"Vow" -> vowName,
		"Rank" -> ownedThreat["Menace", "rank"],
		"Progress" -> ownedThreat["Menace", "progress"]
	]
];

resolveProgressTarget[ThreatTrack[vowName_String, handleCharacter_String], character_] :=
	threatProgressTargetByVow[
		vowName,
		Replace[character, Automatic :> handleCharacter]
	];

resolveProgressTarget[track_String, character_] :=
	progressTargetData[track, character];

progressTargetCharacter[ThreatTrack[_String, handleCharacter_String], character_] :=
	Replace[character, Automatic :> handleCharacter];

progressTargetCharacter[_String, character_] :=
	character;

progressMarkValue[target_Association, n_Integer] :=
	n rankMarkValue[target["Rank"]];

setTargetField[target_Association, "Progress", value_, character_] :=
	Switch[
		target["Type"],
		"Vow",
			$state[character, "vows", target["Name"], "Progress"] = value,
		"Threat",
			$state[character, "vows", target["Vow"], "Threat", "Menace", "progress"] = value,
		"Delve",
			$state[character, "delves", target["Name"], "Progress"] = value,
		"Scene",
			$state[character, "scene", "Progress"] = value,
		"Journey",
			$state[character, "journeys", target["Name"], "Progress"] = value,
		"Foe",
			$state[character, "foes", target["Name"], "Progress"] = value,
		"Failures",
			$state[character, "failures", "Progress"] = value,
		"Bonds",
			$state[character, "bondProgress", "Progress"] = value,
		_,
			$Failed
	];

setTargetField[target_Association, "Rank", value_, character_] :=
	Switch[
		target["Type"],
		"Vow",
			$state[character, "vows", target["Name"], "Rank"] = value,
		"Threat",
			$state[character, "vows", target["Vow"], "Threat", "Menace", "rank"] = value,
		"Delve",
			$state[character, "delves", target["Name"], "Rank"] = value,
		"Scene",
			$state[character, "scene", "Rank"] = value,
		"Journey",
			$state[character, "journeys", target["Name"], "Rank"] = value,
		"Foe",
			$state[character, "foes", target["Name"], "Rank"] = value,
		"Failures",
			$state[character, "failures", "Rank"] = value,
		"Bonds",
			$state[character, "bondProgress", "Rank"] = value,
		_,
			$Failed
	];

setTargetProgress[target_Association, value_, character_] := Module[
	{clamped},
	clamped = clampValue[value, {0, 10}];
	If[!TrueQ[value == clamped],
		Message[progress::clamped, target["Name"], character, value, clamped]
	];
	If[setTargetField[target, "Progress", clamped, character] === $Failed, Return[$Failed]];
	clamped
];

adjustTargetProgress[target_Association, delta_, character_] :=
	setTargetProgress[target, target["Progress"] + delta, character];

setTargetRank[target_Association, rank_?rankQ, character_] := Module[{},
	If[setTargetField[target, "Rank", rank, character] === $Failed, Return[$Failed]];
	rank
];

rankIndex[rank_?rankQ] :=
	First[FirstPosition[ranks, rank]];

nextRank[rank_?rankQ] := Module[
	{index},
	index = rankIndex[rank];
	If[index >= Length[ranks],
		Missing["NoHigherRank"],
		ranks[[index + 1]]
	]
];

raiseTargetRank[target_Association, character_] := Module[
	{rank},
	rank = nextRank[target["Rank"]];
	If[rank === Missing["NoHigherRank"],
		Message[progress::epic, target["Name"], character];
		Return[$Failed]
	];
	setTargetRank[target, rank, character]
];

(* ::Subsection::Closed:: *)
(*Character management*)


createCharacter[
	name_String,
	assetSpecs_List /; Length[assetSpecs] == 3,
	(edge_)?statValueQ,
	(heart_)?statValueQ,
	(iron_)?statValueQ,
	(shadow_)?statValueQ,
	(wits_)?statValueQ,
	vowSpec_,
	bonds : {___String} /; Length[bonds] <= 3
] := Module[
	{character, ownedAssets, startingVow},
	ensureStateInitialized[];
	ownedAssets = ownedAssetFromSpec /@ assetSpecs;
	If[MemberQ[ownedAssets, $Failed],
		Message[createCharacter::badassets];
		Return[$Failed]
	];
	startingVow = ownedVowFromSpec[vowSpec];
	If[startingVow === $Failed,
		Message[createCharacter::badvow];
		Return[$Failed]
	];
	character = Association[
		"assets" -> ownedAssets,
		"edge" -> edge,
		"heart" -> heart,
		"iron" -> iron,
		"shadow" -> shadow,
		"wits" -> wits,
		"health" -> 5,
		"spirit" -> 5,
		"supply" -> 5,
		"momentum" -> 2,
		"debilities" -> {},
		"vows" -> Association[startingVow["Name"] -> startingVow],
		"failures" -> makeProgressObject["Failures", Epic],
		"bondProgress" -> makeProgressObject["Bonds", Epic, 0.25 Length[bonds]],
		"bonds" -> bonds,
		"journeys" -> <||>,
		"currentJourney" -> None,
		"foes" -> <||>,
		"delves" -> <||>,
		"currentDelve" -> None,
		"scene" -> None,
		"earnedExperience" -> 0,
		"spentExperience" -> 0
	];
	AssociateTo[$state, name -> character];
	$soloCharacter = name;
	$state[name]
];
createCharacter::badassets = "Could not create the character because one or more starting assets are invalid.";
createCharacter::badvow = "Could not create the character because the starting vow is invalid. Use starterVow[name, Extreme | Epic] or {vowName, Extreme | Epic}.";

normalizeCharacterForSheet[character_String] := Module[
	{normalizers, normalized},
	If[!ensureCharacterState[character], Return[$Failed]];
	If[ensureCharacterCoreProgress[character] === $Failed, Return[$Failed]];
	normalizers = {
		normalizeCharacterAssets,
		normalizeCharacterVows,
		normalizeCharacterBonds,
		normalizeCharacterJourneys,
		normalizeCharacterFoes,
		normalizeCharacterDelves,
		normalizeCharacterScene
	};
	Do[
		normalized = normalizer[character];
		If[normalized === $Failed, Return[$Failed]],
		{normalizer, normalizers}
	];
	$state[character]
];



setSoloCharacter[character_String] := Module[{},
	If[!AssociationQ[$state] || !KeyExistsQ[$state, character],
		Message[setSoloCharacter::nochar, character];
		Return[$Failed]
	];
	$soloCharacter = character
];

setSoloCharacter::nochar = "No character named `1` exists in the current state.";


(* ::Subsection::Closed:: *)
(*Debility management*)


markDebilityState[debility_?debilityQ, character_ : $soloCharacter] := Module[
	{current},
	If[!ensureCharacterState[character], Return[$Failed]];
	current = getDebilities[character];
	If[MemberQ[current, debility],
		Message[debility::marked, debilityLabel[debility], character];
		Return[current]
	];
	$state[character, "debilities"] = Append[current, debility];
	enforceMomentumBounds[character];
	$state[character, "debilities"]
];

markDebilityState[debility_, character_ : $soloCharacter] := (
	Message[debility::invalid, debility];
	$Failed
);

clearDebilityState[debility_?debilityQ, character_ : $soloCharacter] := Module[
	{current},
	If[!ensureCharacterState[character], Return[$Failed]];
	If[MemberQ[permanentDebilities, debility],
		Message[debility::permanent, debilityLabel[debility]];
		Return[$Failed]
	];
	current = getDebilities[character];
	If[!MemberQ[current, debility],
		Message[debility::unmarked, debilityLabel[debility], character];
		Return[current]
	];
	$state[character, "debilities"] = DeleteCases[current, debility];
	enforceMomentumBounds[character];
	$state[character, "debilities"]
];

clearDebilityState[debility_, character_ : $soloCharacter] := (
	Message[debility::invalid, debility];
	$Failed
);

markWounded[character_ : $soloCharacter] :=
	markDebilityState[Wounded, character];

clearWounded[character_ : $soloCharacter] :=
	clearDebilityState[Wounded, character];

markShaken[character_ : $soloCharacter] :=
	markDebilityState[Shaken, character];

clearShaken[character_ : $soloCharacter] :=
	clearDebilityState[Shaken, character];

markUnprepared[character_ : $soloCharacter] :=
	markDebilityState[Unprepared, character];

clearUnprepared[character_ : $soloCharacter] :=
	clearDebilityState[Unprepared, character];

markEncumbered[character_ : $soloCharacter] :=
	markDebilityState[Encumbered, character];

clearEncumbered[character_ : $soloCharacter] :=
	clearDebilityState[Encumbered, character];

markMaimed[character_ : $soloCharacter] :=
	markDebilityState[Maimed, character];

markCorrupted[character_ : $soloCharacter] :=
	markDebilityState[Corrupted, character];

markCursed[character_ : $soloCharacter] :=
	markDebilityState[Cursed, character];

clearCursed[character_ : $soloCharacter] :=
	clearDebilityState[Cursed, character];

markTormented[character_ : $soloCharacter] :=
	markDebilityState[Tormented, character];

clearTormented[character_ : $soloCharacter] :=
	clearDebilityState[Tormented, character];

debility::invalid = "`1` is not an Ironsworn debility.";
debility::marked = "`1` is already marked for character `2`.";
debility::unmarked = "`1` is not marked for character `2`.";
debility::permanent = "`1` is permanent and cannot be cleared.";


(* ::Subsection::Closed:: *)
(*Vow management*)


Options[starterVow] = {Threat -> None};

starterVow[name_String, rank_?rankQ, opts : OptionsPattern[]] :=
	makeStarterVowSpec[name, rank, OptionValue[Threat]];

starterVow[args___] := (
	Message[vow::badstarter, HoldForm[starterVow[args]]];
	$Failed
);

Options[addVow] = {Threat -> None};

addVow[name_String, rank_?rankQ, opts : OptionsPattern[]] :=
	addVow[name, rank, $soloCharacter, opts];

addVow[name_String, rank_?rankQ, character_String, opts : OptionsPattern[]] := Module[
	{ownedVows, ownedVow},
	ownedVows = normalizeCharacterVows[character];
	If[ownedVows === $Failed, Return[$Failed]];
	If[KeyExistsQ[ownedVows, name],
		Message[vow::duplicate, name, character];
		Return[$Failed]
	];
	ownedVow = makeVow[name, rank, OptionValue[Threat]];
	If[ownedVow === $Failed, Return[$Failed]];
	$state[character, "vows"] = Association[ownedVows, name -> ownedVow];
	ownedVow
];

vow[name_String, character_ : $soloCharacter] := Module[
	{ownedVow},
	ownedVow = vowByName[name, character];
	If[!AssociationQ[ownedVow],
		Message[vow::unknown, name, character];
		Return[$Failed]
	];
	ownedVow
];

vows[] :=
	vows[$soloCharacter];

vows[character_] := Module[
	{ownedVows},
	ownedVows = normalizeCharacterVows[character];
	If[ownedVows === $Failed, Return[$Failed]];
	ownedVows
];

removeVow[name_String, character_ : $soloCharacter] := Module[
	{ownedVows, removed},
	ownedVows = normalizeCharacterVows[character];
	If[ownedVows === $Failed, Return[$Failed]];
	If[!KeyExistsQ[ownedVows, name],
		Message[vow::unknown, name, character];
		Return[$Failed]
	];
	removed = ownedVows[name];
	$state[character, "vows"] = KeyDrop[ownedVows, name];
	removed
];

setThreat[vowName_String, threatSpec_, character_ : $soloCharacter] := Module[
	{ownedVow, normalizedThreat},
	ownedVow = vowByName[vowName, character];
	If[!AssociationQ[ownedVow],
		Message[vow::unknown, vowName, character];
		Return[$Failed]
	];
	normalizedThreat = normalizeThreatSpec[threatSpec];
	If[normalizedThreat === $Failed, Return[$Failed]];
	$state[character, "vows", vowName, "Threat"] = normalizedThreat;
	$state[character, "vows", vowName]
];

removeThreat[vowName_String, character_ : $soloCharacter] := Module[
	{ownedThreat},
	ownedThreat = threatByVowName[vowName, character];
	If[ownedThreat === $Failed, Return[$Failed]];
	$state[character, "vows", vowName, "Threat"] = None;
	ownedThreat
];

clearThreatProgress[vowName_String, character_ : $soloCharacter] := Module[
	{ownedThreat},
	ownedThreat = threatByVowName[vowName, character];
	If[ownedThreat === $Failed, Return[$Failed]];
	$state[character, "vows", vowName, "Threat", "Menace", "progress"] = 0;
	$state[character, "vows", vowName, "Threat"]
];

vow::badstarter = "`1` is not a valid vow spec. Use starterVow[name, Extreme | Epic] or {vowName, Extreme | Epic}.";
vow::badbackgroundrank = "Background vow rank must be Extreme or Epic, not `1`.";
vow::badthreat = "`1` is not a valid threat spec. Use Threat -> {threatName, threatGoal}.";
vow::nochar = "No character named `1` exists in the current state.";
vow::unknown = "Character `2` does not have a vow named `1`.";
vow::duplicate = "Character `2` already has a vow named `1`.";
vow::nothreat = "Vow `1` does not have an attached threat.";


(* ::Subsection::Closed:: *)
(*Asset management*)


starterAsset[name_String] :=
	makeStarterAssetSpec[name, Automatic, <||>];

starterAsset[name_String, fields_Association] :=
	makeStarterAssetSpec[name, Automatic, fields];

starterAsset[name_String, abilitySpec : (_Integer | {__Integer})] :=
	makeStarterAssetSpec[name, abilitySpec, <||>];

starterAsset[name_String, abilitySpec : (_Integer | {__Integer}), fields_Association] :=
	makeStarterAssetSpec[name, abilitySpec, fields];

starterAsset[args___] := (
	Message[asset::badasset, HoldForm[starterAsset[args]]];
	$Failed
);

asset[name_String, character_ : $soloCharacter] := Module[
	{context},
	context = ownedAssetContext[name, character];
	If[context === $Failed, Return[$Failed]];
	context["Owned"]
];

assets[] :=
	assets[$soloCharacter];

assets[character_] := Module[
	{ownedAssets},
	ownedAssets = normalizeCharacterAssets[character];
	If[ownedAssets === $Failed, Return[$Failed]];
	ownedAssets
];

drawAssets[] :=
	drawAssets[3];

drawAssets[category_String] :=
	drawAssets[3, category];

drawAssets[n_Integer?Positive] :=
	drawAssets[n, All];

drawAssets[n_Integer?Positive, All] := Module[
	{names},
	If[n > Length[assetNames[]],
		Message[asset::drawcount, n, Length[assetNames[]]];
		Return[$Failed]
	];
	names = RandomSample[assetNames[], n];
	names
];

drawAssets[n_Integer?Positive, category_String] := Module[
	{pool, names},
	If[!MemberQ[assetCategories[], category],
		Message[asset::badcategory, category, StringRiffle[assetCategories[], ", "]];
		Return[$Failed]
	];
	pool = Select[assetNames[], assetRecord[#]["Category"] === category &];
	If[n > Length[pool],
		Message[asset::drawcount, n, Length[pool]];
		Return[$Failed]
	];
	names = RandomSample[pool, n];
	names
];

drawAssets[args___] := (
	Message[asset::baddraw, HoldForm[drawAssets[args]]];
	$Failed
);

Options[addAsset] = {Display -> False};

addAsset[assetSpec_, opts : OptionsPattern[]] :=
	addAsset[assetSpec, $soloCharacter, opts];

addAsset[assetSpec_, character_, opts : OptionsPattern[]] := Module[
	{ownedAssets, owned, name},
	If[!characterExistsQ[character],
		Message[asset::nochar, character];
		Return[$Failed]
	];
	ownedAssets = normalizeCharacterAssets[character];
	If[ownedAssets === $Failed, Return[$Failed]];
	owned = ownedAssetFromSpec[assetSpec];
	If[owned === $Failed, Return[$Failed]];
	name = owned["Name"];
	If[MemberQ[Lookup[ownedAssets, "Name", Missing["NoName"]], name],
		Message[asset::duplicate, name, character];
		Return[$Failed]
	];
	If[!requireExperience[character, 5], Return[$Failed]];
	AppendTo[$state[character, "assets"], owned];
	spendExperience[5, character];
	owned
];

Options[upgradeAsset] = {Display -> False};

upgradeAsset[name_String, ability_Integer, opts : OptionsPattern[]] :=
	upgradeAsset[name, ability, $soloCharacter, opts];

upgradeAsset[name_String, ability_Integer, character_, opts : OptionsPattern[]] := Module[
	{context, record, owned, valid, selected, updated},
	context = ownedAssetContext[name, character];
	If[context === $Failed, Return[$Failed]];
	record = context["Record"];
	owned = context["Owned"];
	valid = assetAbilityIndices[record];
	If[!MemberQ[valid, ability],
		Message[asset::badability, ability, name, Length[valid]];
		Return[$Failed]
	];
	selected = Lookup[owned, "Abilities", {}];
	If[MemberQ[selected, ability],
		Message[asset::selected, ability, name];
		Return[$Failed]
	];
	If[!requireExperience[character, 3], Return[$Failed]];
	updated = Association[owned];
	updated["Abilities"] = Sort[Append[selected, ability]];
	replaceOwnedAsset[character, context["Index"], updated];
	spendExperience[3, character];
	updated
];

setAssetTrack[assetName_String, trackName_String, value_Integer, character_ : $soloCharacter] := Module[
	{context, record, owned, trackDef, tracks, updated, clamped},
	context = ownedAssetContext[assetName, character];
	If[context === $Failed, Return[$Failed]];
	record = context["Record"];
	owned = context["Owned"];
	trackDef = assetTrackDefinition[record, trackName];
	If[!AssociationQ[trackDef],
		Message[asset::track, trackName, assetName];
		Return[$Failed]
	];
	tracks = ownedAssetTracks[record, owned];
	clamped = clampAssetTrackValue[trackDef, value];
	tracks[trackName] = clamped;
	updated = Association[owned];
	updated["Tracks"] = tracks;
	replaceOwnedAsset[character, context["Index"], updated];
	clamped
];

adjustAssetTrack[assetName_String, trackName_String, delta_Integer, character_ : $soloCharacter] := Module[
	{context, record, owned, trackDef, tracks, current},
	context = ownedAssetContext[assetName, character];
	If[context === $Failed, Return[$Failed]];
	record = context["Record"];
	owned = context["Owned"];
	trackDef = assetTrackDefinition[record, trackName];
	If[!AssociationQ[trackDef],
		Message[asset::track, trackName, assetName];
		Return[$Failed]
	];
	tracks = ownedAssetTracks[record, owned];
	current = Lookup[tracks, trackName, Lookup[trackDef, "Default", 0]];
	setAssetTrack[assetName, trackName, current + delta, character]
];

Options[removeAsset] = {Display -> False};

removeAsset[name_String, opts : OptionsPattern[]] :=
	removeAsset[name, $soloCharacter, opts];

removeAsset[name_String, character_, opts : OptionsPattern[]] := Module[
	{context, ownedAssets, removed},
	context = ownedAssetContext[name, character];
	If[context === $Failed, Return[$Failed]];
	ownedAssets = context["Assets"];
	removed = context["Owned"];
	$state[character, "assets"] = Delete[ownedAssets, context["Index"]];
	removed
];

companion[name_String, character_ : $soloCharacter] := Module[
	{context},
	context = ownedCompanionContext[name, character];
	If[context === $Failed, Return[$Failed]];
	context["Owned"]
];

companions[] :=
	companions[$soloCharacter];

companions[character_] := Module[
	{ownedAssets, companionAssets},
	ownedAssets = normalizeCharacterAssets[character];
	If[ownedAssets === $Failed, Return[$Failed]];
	companionAssets = Select[
		ownedAssets,
		AssociationQ[assetRecord[#["Name"]]] && Lookup[assetRecord[#["Name"]], "Category", ""] === "Companion" &
	];
	companionAssets
];

Options[setCompanionHealth] = {Display -> False};

setCompanionHealth[name_String, value_Integer, opts : OptionsPattern[]] :=
	setCompanionHealth[name, value, $soloCharacter, opts];

setCompanionHealth[name_String, value_Integer, character_, opts : OptionsPattern[]] := Module[
	{context, clamped},
	context = ownedCompanionContext[name, character];
	If[context === $Failed, Return[$Failed]];
	clamped = setAssetTrack[name, "health", value, character];
	If[clamped === $Failed, Return[$Failed]];
	clamped
];

Options[adjustCompanionHealth] = {Display -> False};

adjustCompanionHealth[name_String, delta_Integer, opts : OptionsPattern[]] :=
	adjustCompanionHealth[name, delta, $soloCharacter, opts];

adjustCompanionHealth[name_String, delta_Integer, character_, opts : OptionsPattern[]] := Module[
	{context, tracks, current},
	context = ownedCompanionContext[name, character];
	If[context === $Failed, Return[$Failed]];
	tracks = ownedAssetTracks[context["Record"], context["Owned"]];
	current = Lookup[tracks, "health", Lookup[assetTrackDefinition[context["Record"], "health"], "Default", 0]];
	setCompanionHealth[name, current + delta, character, opts]
];

normalizeRarityName[rarity_String] := Module[
	{trimmed},
	trimmed = StringTrim[rarity];
	If[StringLength[trimmed] == 0, $Failed, trimmed]
];

normalizeRarityName[_] :=
	$Failed;

assetRarityCost[record_Association] :=
	Lookup[record, "RarityCost", Missing["NoRarityCost"]];

Options[addRarity] = {Display -> False};

addRarity[assetName_String, rarityName_, opts : OptionsPattern[]] :=
	addRarity[assetName, rarityName, $soloCharacter, opts];

addRarity[assetName_String, rarityName_, character_, opts : OptionsPattern[]] := Module[
	{record, rarity, cost, context, owned, updated},
	record = assetRecord[assetName];
	If[!AssociationQ[record],
		Message[asset::unknown, assetName];
		Return[$Failed]
	];
	rarity = normalizeRarityName[rarityName];
	If[rarity === $Failed,
		Message[asset::badrarity, rarityName];
		Return[$Failed]
	];
	If[Lookup[record, "Category", ""] === "Companion",
		Message[asset::raritycompanion, assetName];
		Return[$Failed]
	];
	cost = assetRarityCost[record];
	If[!IntegerQ[cost],
		Message[asset::noraritycost, assetName];
		Return[$Failed]
	];
	context = ownedAssetContext[assetName, character];
	If[context === $Failed, Return[$Failed]];
	owned = context["Owned"];
	If[Lookup[owned, "Rarity", None] =!= None,
		Message[asset::rarityduplicate, assetName, Lookup[owned, "Rarity", None]];
		Return[$Failed]
	];
	If[!requireExperience[character, cost], Return[$Failed]];
	updated = Association[owned];
	updated["Rarity"] = rarity;
	replaceOwnedAsset[character, context["Index"], updated];
	spendExperience[cost, character];
	updated
];

Options[removeRarity] = {Display -> False};

removeRarity[assetName_String, opts : OptionsPattern[]] :=
	removeRarity[assetName, $soloCharacter, opts];

removeRarity[assetName_String, character_, opts : OptionsPattern[]] := Module[
	{context, owned, updated},
	context = ownedAssetContext[assetName, character];
	If[context === $Failed, Return[$Failed]];
	owned = context["Owned"];
	If[Lookup[owned, "Rarity", None] === None,
		Message[asset::norarity, assetName];
		Return[$Failed]
	];
	updated = Association[owned];
	updated["Rarity"] = None;
	replaceOwnedAsset[character, context["Index"], updated];
	markExperience[1, character];
	updated
];

asset::unknown = "Unknown asset `1`. Use the exact canonical asset name.";
asset::nodefault = "Asset `1` has no printed default selected ability. Use starterAsset[`1`, abilityIndex].";
asset::badability = "Ability `1` is not available for asset `2`. Valid ability indices are 1 through `3`.";
asset::badabilities = "Asset `1` requires a non-empty integer ability selection.";
asset::dupeability = "Ability `1` was selected more than once for asset `2`.";
asset::badfield = "Field `1` is not defined for asset `2`.";
asset::badfields = "Fields for asset `1` must be an association.";
asset::badasset = "`1` is not a valid asset spec. Use an asset name string or starterAsset[...].";
asset::badstoredassets = "The stored assets for character `1` could not be migrated to structured asset state.";
asset::nochar = "No character named `1` exists in the current state.";
asset::notowned = "Character `2` does not own asset `1`.";
asset::duplicate = "Character `2` already owns asset `1`.";
asset::xp = "Character `1` needs `2` available experience, but only has `3`.";
asset::selected = "Ability `1` is already selected for asset `2`.";
asset::track = "Track `1` is not defined for asset `2`.";
asset::badcategory = "Unknown asset category `1`. Use one of: `2`.";
asset::drawcount = "Cannot draw `1` distinct assets from a pool of `2`.";
asset::baddraw = "`1` is not a valid drawAssets call.";
asset::badrarity = "Rarity name must be a non-empty string, not `1`.";
asset::raritycompanion = "Companion asset `1` cannot be augmented with a rarity.";
asset::noraritycost = "Asset `1` is not eligible for rarity augmentation.";
asset::rarityduplicate = "Asset `1` already has rarity `2`.";
asset::norarity = "Asset `1` does not have a rarity to remove.";
asset::notcompanion = "Asset `1` is not a companion.";


(* ::Subsection::Closed:: *)
(*Action roll*)


Options[actionRoll] = {Adds -> Association[], Display -> False};

actionRoll[(stat_)?statQ, opts : OptionsPattern[]] :=
	actionRoll[stat, $soloCharacter, opts];

actionRoll[(stat_)?statQ, character_String, opts : OptionsPattern[]] := Module[
	{
		actionDie,
		momentum,
		actionValue,
		actionDieCancelled,
		statValue,
		adds,
		actionScore,
		challengeDice,
		cd1,
		cd2
	},
	actionDie = rollActionDie[];
	momentum = getMomentum[character];
	{actionValue, actionDieCancelled} = actionDieAfterMomentumCancel[actionDie, momentum];
	statValue = getAttr[stat, character];
	adds = OptionValue[Adds];
	actionScore = actionScoreFromParts[actionValue, statValue, adds];
	challengeDice = {cd1, cd2} = rollChallengeDice[];
	Association[
		"character" -> character,
		"actionDie" -> actionDie,
		"momentum" -> momentum,
		"actionValue" -> actionValue,
		"actionDieCancelled" -> actionDieCancelled,
		"stat" -> stat,
		"statValue" -> statValue,
		"adds" -> adds,
		"actionScore" -> actionScore,
		"challengeDice" -> challengeDice,
		"match" -> cd1 == cd2,
		"result" -> actionRollResult[challengeDice, actionScore]
	]
];


(* ::Subsection::Closed:: *)
(*Burn momentum*)


Options[burnMomentum] = {Display -> False};
burnMomentum[roll_Association, opts:OptionsPattern[]] := Module[
	{momentum, challengeDice, challengeDiceCancelled, beatCount, result, burn},
	If[
		!actionRollQ[roll] ||
		!AllTrue[{"character", "momentum", "result", "match"}, KeyExistsQ[roll, #] &],
		Message[burnMomentum::badroll];
		Return[$Failed]
	];
	momentum = roll["momentum"];
	If[momentum <= 0,
		Message[burnMomentum::momentum, momentum];
		Return[$Failed]
	];
	challengeDice = roll["challengeDice"];
	challengeDiceCancelled = # < momentum & /@ challengeDice;
	If[!AnyTrue[challengeDiceCancelled, TrueQ],
		Message[burnMomentum::nocancel, momentum];
		Return[$Failed]
	];
	beatCount = Total[
		MapThread[
			If[#2 || roll["actionScore"] > #1, 1, 0] &,
			{challengeDice, challengeDiceCancelled}
		]
	];
	result = rollResultFromBeatCount[beatCount];
	If[rollResultRank[result] <= rollResultRank[roll["result"]],
		Message[burnMomentum::nobenefit, roll["result"], result];
		Return[$Failed]
	];
	burn = Association[
		"momentum" -> momentum,
		"challengeDice" -> challengeDice,
		"momentumReset" -> getMomentumReset[roll["character"]],
		"actionScore" -> roll["actionScore"],
		"previousResult" -> roll["result"],
		"result" -> result,
		"challengeDiceCancelled" -> challengeDiceCancelled,
		"match" -> roll["match"]
	];
	resetMomentum[roll["character"]];
	burn
];

burnMomentum[roll_, opts:OptionsPattern[]] := (
	Message[burnMomentum::badroll];
	$Failed
);

burnMomentum::badroll = "burnMomentum can only be used on an action roll.";
burnMomentum::momentum = "Cannot burn momentum because roll momentum is not positive (`1`).";
burnMomentum::nocancel = "Cannot burn momentum because no challenge die is less than momentum `1`.";
burnMomentum::nobenefit = "Cannot burn momentum because the result would not improve (`1` -> `2`).";


(* ::Subsection::Closed:: *)
(*Rarity die conversion*)


Options[rarityDieSix] = {Display -> False};

rarityDieSix[roll_Association, opts : OptionsPattern[]] := Module[
	{newRoll},
	If[!actionRollQ[roll],
		Message[rarityDieSix::badroll];
		Return[$Failed]
	];
	newRoll = Association[roll];
	newRoll["result"] = "strongHit";
	newRoll["rarityDie"] = Association[
		"value" -> 6,
		"previousResult" -> Lookup[roll, "result", Missing["NoResult"]]
	];
	newRoll
];

rarityDieSix[roll_, opts : OptionsPattern[]] := (
	Message[rarityDieSix::badroll];
	$Failed
);

rarityDieSix::badroll = "rarityDieSix can only be used on an action roll.";


(* ::Subsection::Closed:: *)
(*Progress roll*)


Options[progressRoll] = {Display -> False};

progressRoll[track_String, opts : OptionsPattern[]] :=
	progressRoll[track, $soloCharacter, opts];

progressRoll[track_String, character_String, opts : OptionsPattern[]] := Module[
	{target, progressScore, challengeDice, die1, die2, roll},
	target = progressTargetData[track, character];
	If[target === $Failed, Return[$Failed]];
	progressScore = Floor[target["Progress"]];
	challengeDice = {die1, die2} = rollChallengeDice[];
	roll = Association[
		"character" -> character,
		"trackName" -> target["Name"],
		"progressScore" -> progressScore,
		"challengeDice" -> challengeDice,
		"match" -> die1 == die2,
		"result" -> progressRollResult[challengeDice, progressScore]
	];
	roll
];


(* ::Subsection::Closed:: *)
(*Reroll*)


Options[reroll] = {Display -> False};

reroll[roll_Association, die : Except[_List], opts : OptionsPattern[]] :=
	reroll[roll, {die}, opts];

reroll[roll_Association, dice_List, opts : OptionsPattern[]] := Module[
	{
		selection,
		invalid,
		newRoll,
		oldActionDie,
		oldChallengeDice,
		actionDie,
		momentum,
		actionValue,
		actionDieCancelled,
		actionScore,
		challengeDice,
		challengeIndices,
		cd1,
		cd2
	},

	If[!rollQ[roll],
		Message[reroll::badroll, roll];
		Return[$Failed]
	];

	selection = normalizeRerollSelection[dice];

	If[selection === {},
		Message[reroll::empty];
		Return[$Failed]
	];

	invalid = Select[selection, !rerollSelectionQ[#] &];

	If[invalid =!= {},
		Message[reroll::baddie, First[invalid]];
		Return[$Failed]
	];

	If[progressRollQ[roll] && MemberQ[selection, ActionDie],
		Message[reroll::actiondie];
		Return[$Failed]
	];

	oldChallengeDice = roll["challengeDice"];
	challengeDice = oldChallengeDice;

	challengeIndices = rerollChallengeDieIndices[selection, oldChallengeDice];

	If[!VectorQ[challengeIndices, MemberQ[{1, 2}, #] &],
		Message[reroll::badchallenge, selection];
		Return[$Failed]
	];

	Do[
		challengeDice[[i]] = RandomInteger[{1, 10}],
		{i, challengeIndices}
	];

	If[actionRollQ[roll],
		oldActionDie = roll["actionDie"];

		actionDie =
			If[
				MemberQ[selection, ActionDie],
				rollActionDie[],
				oldActionDie
			];

		momentum = roll["momentum"];

		{actionValue, actionDieCancelled} =
			actionDieAfterMomentumCancel[actionDie, momentum];

		actionScore =
			actionScoreFromParts[actionValue, roll["statValue"], roll["adds"]];

		{cd1, cd2} = challengeDice;

		newRoll = Association[roll];

		newRoll["actionDie"] = actionDie;
		newRoll["actionValue"] = actionValue;
		newRoll["actionDieCancelled"] = actionDieCancelled;
		newRoll["actionScore"] = actionScore;
		newRoll["challengeDice"] = challengeDice;
		newRoll["match"] = cd1 == cd2;
		newRoll["result"] = actionRollResult[challengeDice, actionScore];

		newRoll["reroll"] = Association[
			"selection" -> selection,
			"previousActionDie" -> oldActionDie,
			"previousChallengeDice" -> oldChallengeDice,
			"previousResult" -> roll["result"]
		];,

		{cd1, cd2} = challengeDice;

		newRoll = Association[roll];

		newRoll["challengeDice"] = challengeDice;
		newRoll["match"] = cd1 == cd2;
		newRoll["result"] = progressRollResult[challengeDice, roll["progressScore"]];

		newRoll["reroll"] = Association[
			"selection" -> selection,
			"previousChallengeDice" -> oldChallengeDice,
			"previousResult" -> roll["result"]
		];
	];

	newRoll
];


(* ::Subsection::Closed:: *)
(*Resource and momentum adjustment*)


sufferMomentum[n_Integer, character_ : $soloCharacter] :=
	adjustMomentum[n, character];

takeMomentum[n_Integer, character_ : $soloCharacter] :=
	adjustMomentum[n, character];

sufferHealth[n_Integer, character_ : $soloCharacter] :=
	adjustHealth[n, character];

takeHealth[n_Integer, character_ : $soloCharacter] :=
	adjustHealth[n, character];

sufferSpirit[n_Integer, character_ : $soloCharacter] :=
	adjustSpirit[n, character];

takeSpirit[n_Integer, character_ : $soloCharacter] :=
	adjustSpirit[n, character];

sufferSupply[n_Integer, character_ : $soloCharacter] :=
	adjustSupply[n, character];

takeSupply[n_Integer, character_ : $soloCharacter] :=
	adjustSupply[n, character];

recover[] :=
	recover[$soloCharacter];

recover[character_] := Module[
	{ownedAssets, updatedAssets},
	If[!ensureCharacterState[character], Return[$Failed]];
	ownedAssets = normalizeCharacterAssets[character];
	If[ownedAssets === $Failed, Return[$Failed]];
	$state[character, "debilities"] = Complement[getDebilities[character], recoverableConditions];
	$state[character, "health"] = 5;
	$state[character, "spirit"] = 5;
	$state[character, "supply"] = 5;
	$state[character, "momentum"] = getMomentumReset[character];
	updatedAssets = Map[
		Module[{record, trackDef, updated, tracks},
			record = assetRecord[#["Name"]];
			If[!AssociationQ[record] || Lookup[record, "Category", ""] =!= "Companion",
				#,
				trackDef = assetTrackDefinition[record, "health"];
				If[!AssociationQ[trackDef],
					#,
					updated = Association[#];
					tracks = ownedAssetTracks[record, updated];
					tracks["health"] = trackDef["Max"];
					updated["Tracks"] = tracks;
					updated
				]
			]
		] &,
		ownedAssets
	];
	$state[character, "assets"] = updatedAssets;
	$state[character]
];


(* ::Subsection::Closed:: *)
(*Progress mutation*)


withProgressTarget[targetSpec_, character_, handler_] := Module[
	{target, useCharacter},
	useCharacter = progressTargetCharacter[targetSpec, character];
	target = resolveProgressTarget[targetSpec, character];
	If[target === $Failed, Return[$Failed]];
	handler[target, useCharacter]
];

markProgress[ThreatTrack[vowName_String, handleCharacter_String], n_Integer?NonNegative, character_ : Automatic] :=
	withProgressTarget[
		ThreatTrack[vowName, handleCharacter],
		character,
		adjustTargetProgress[#1, progressMarkValue[#1, n], #2] &
	];

markProgress[track_String, n_Integer?NonNegative, character_ : $soloCharacter] :=
	withProgressTarget[
		track,
		character,
		Switch[
			#1["Type"],
			"Vow",
				markVowProgress[#1["Name"], n, #2],
			"Threat",
				markThreatProgressByVow[#1["Vow"], n, #2],
			"Delve" | "Scene" | "Journey" | "Foe" | "Failures" | "Bonds",
				adjustTargetProgress[#1, progressMarkValue[#1, n], #2],
			_,
				$Failed
		] &
	];

markProgress[track_String, character_String] :=
	markProgress[track, 1, character];

markProgress[track_String] :=
	markProgress[track, 1, $soloCharacter];

markProgress[ThreatTrack[vowName_String, handleCharacter_String], character_String] :=
	markProgress[ThreatTrack[vowName, handleCharacter], 1, character];

markProgress[ThreatTrack[vowName_String, handleCharacter_String]] :=
	markProgress[ThreatTrack[vowName, handleCharacter], 1, Automatic];

markProgress[_String | _ThreatTrack, n_Integer?Negative, character_ : $soloCharacter] := (
	Message[progress::badunits, n];
	$Failed
);

clearProgress[ThreatTrack[vowName_String, handleCharacter_String], n_Integer?NonNegative, character_ : Automatic] :=
	withProgressTarget[
		ThreatTrack[vowName, handleCharacter],
		character,
		adjustTargetProgress[#1, -progressMarkValue[#1, n], #2] &
	];

clearProgress[track_String, n_Integer?NonNegative, character_ : $soloCharacter] :=
	withProgressTarget[
		track,
		character,
		adjustTargetProgress[#1, -progressMarkValue[#1, n], #2] &
	];

clearProgress[_String | _ThreatTrack, n_Integer?Negative, character_ : $soloCharacter] := (
	Message[progress::badunits, n];
	$Failed
);

resetProgress[ThreatTrack[vowName_String, handleCharacter_String], character_ : Automatic] :=
	withProgressTarget[
		ThreatTrack[vowName, handleCharacter],
		character,
		setTargetProgress[#1, 0, #2] &
	];

resetProgress[track_String, character_ : $soloCharacter] :=
	withProgressTarget[
		track,
		character,
		setTargetProgress[#1, 0, #2] &
	];

resetProgressToOne[ThreatTrack[vowName_String, handleCharacter_String], character_ : Automatic] :=
	withProgressTarget[
		ThreatTrack[vowName, handleCharacter],
		character,
		setTargetProgress[#1, 1, #2] &
	];

resetProgressToOne[track_String, character_ : $soloCharacter] :=
	withProgressTarget[
		track,
		character,
		setTargetProgress[#1, 1, #2] &
	];

raiseProgressRank[ThreatTrack[vowName_String, handleCharacter_String], character_ : Automatic] :=
	withProgressTarget[
		ThreatTrack[vowName, handleCharacter],
		character,
		raiseTargetRank[#1, #2] &
	];

raiseProgressRank[track_String, character_ : $soloCharacter] :=
	withProgressTarget[
		track,
		character,
		raiseTargetRank[#1, #2] &
	];

markProgress::notrack = "No vow, threat, delve, scene, journey, foe, failures, or bonds track named `1` exists for character `2`.";
progress::badunits = "Progress units must be a non-negative integer, got `1`.";
progress::clamped = "Progress for `1` on character `2` was clamped from `3` to `4`.";
progress::epic = "Progress track `1` for character `2` is already Epic and cannot be raised.";
progress::badrank = "`1` is not a valid progress rank.";


(* ::Subsection::Closed:: *)
(*Journey and foe management*)


normalizeCharacterJourneys[character_] :=
	normalizeProgressObjectAssociation[character, "journeys"];

normalizeCharacterFoes[character_] :=
	normalizeProgressObjectAssociation[character, "foes"];


addProgressObjectToCollection[
	collectionKey_String,
	normalizer_,
	duplicateReporter_,
	name_String,
	rank_?rankQ,
	character_
] := Module[
	{collection, object},
	collection = normalizer[character];
	If[collection === $Failed, Return[$Failed]];
	If[KeyExistsQ[collection, name],
		duplicateReporter[name, character];
		Return[$Failed]
	];
	object = makeProgressObject[name, rank];
	$state[character, collectionKey, name] = object;
	object
];

removeProgressObjectFromCollection[
	collectionKey_String,
	normalizer_,
	unknownReporter_,
	name_String,
	character_,
	currentKey_ : None
] := Module[
	{collection},
	collection = normalizer[character];
	If[collection === $Failed, Return[$Failed]];
	If[!KeyExistsQ[collection, name],
		unknownReporter[name, character];
		Return[$Failed]
	];
	$state[character, collectionKey] = KeyDrop[collection, name];
	If[StringQ[currentKey] && Lookup[$state[character], currentKey, None] === name,
		$state[character, currentKey] = None
	];
	$state[character, collectionKey]
];

addJourney[name_String, rank_?rankQ, character_ : $soloCharacter] :=
	addProgressObjectToCollection[
		"journeys",
		normalizeCharacterJourneys,
		Function[{objectName, objectCharacter}, Message[journey::duplicate, objectName, objectCharacter]],
		name,
		rank,
		character
	];

addJourney[name_String, rank_, character_ : $soloCharacter] /; !rankQ[rank] := (
	Message[progress::badrank, rank];
	$Failed
);

setCurrentJourney[name_String, character_ : $soloCharacter] := Module[
	{ownedJourney},
	ownedJourney = journeyByName[name, character];
	If[!AssociationQ[ownedJourney],
		Message[journey::unknown, name, character];
		Return[$Failed]
	];
	$state[character, "currentJourney"] = name;
	ownedJourney
];

journey[] := Module[
	{ownedJourney},
	ownedJourney = currentJourneyData[$soloCharacter];
	If[ownedJourney === $Failed, Return[$Failed]];
	ownedJourney
];

journey[name_String] :=
	journey[name, $soloCharacter];

journey[name_String, character_] := Module[
	{ownedJourney},
	ownedJourney = journeyByName[name, character];
	If[!AssociationQ[ownedJourney],
		Message[journey::unknown, name, character];
		Return[$Failed]
	];
	ownedJourney
];

journeys[] :=
	journeys[$soloCharacter];

journeys[character_] := Module[
	{ownedJourneys},
	ownedJourneys = normalizeCharacterJourneys[character];
	If[ownedJourneys === $Failed, Return[$Failed]];
	ownedJourneys
];

removeJourney[name_String, character_ : $soloCharacter] :=
	removeProgressObjectFromCollection[
		"journeys",
		normalizeCharacterJourneys,
		Function[{objectName, objectCharacter}, Message[journey::unknown, objectName, objectCharacter]],
		name,
		character,
		"currentJourney"
	];

addFoe[name_String, rank_?rankQ, character_ : $soloCharacter] :=
	addProgressObjectToCollection[
		"foes",
		normalizeCharacterFoes,
		Function[{objectName, objectCharacter}, Message[foe::duplicate, objectName, objectCharacter]],
		name,
		rank,
		character
	];

addFoe[name_String, rank_, character_ : $soloCharacter] /; !rankQ[rank] := (
	Message[progress::badrank, rank];
	$Failed
);

foe[name_String, character_ : $soloCharacter] := Module[
	{ownedFoe},
	ownedFoe = foeByName[name, character];
	If[!AssociationQ[ownedFoe],
		Message[foe::unknown, name, character];
		Return[$Failed]
	];
	ownedFoe
];

foes[] :=
	foes[$soloCharacter];

foes[character_] := Module[
	{ownedFoes},
	ownedFoes = normalizeCharacterFoes[character];
	If[ownedFoes === $Failed, Return[$Failed]];
	ownedFoes
];

removeFoe[name_String, character_ : $soloCharacter] :=
	removeProgressObjectFromCollection[
		"foes",
		normalizeCharacterFoes,
		Function[{objectName, objectCharacter}, Message[foe::unknown, objectName, objectCharacter]],
		name,
		character
	];

failures[] :=
	failures[$soloCharacter];

failures[character_] := Module[
	{track},
	track = failureProgressData[character];
	If[track === $Failed, Return[$Failed]];
	track
];

bondProgress[] :=
	bondProgress[$soloCharacter];

bondProgress[character_] := Module[
	{track},
	track = bondProgressData[character];
	If[track === $Failed, Return[$Failed]];
	track
];

journey::duplicate = "Character `2` already has a journey named `1`.";
journey::unknown = "Character `2` does not have a journey named `1`.";
journey::nocurrent = "Character `1` does not have a current journey.";
foe::duplicate = "Character `2` already has a foe named `1`.";
foe::unknown = "Character `2` does not have a foe named `1`.";


(* ::Subsection::Closed:: *)
(*Bond management*)


normalizeCharacterBonds[character_] := Module[
	{ownedBonds},
	If[!characterExistsQ[character],
		Message[bond::nochar, character];
		Return[$Failed]
	];
	ownedBonds = Lookup[$state[character], "bonds", {}];
	If[ListQ[ownedBonds],
		Return[ownedBonds]
	];
	$state[character, "bonds"] = {};
	{}
];



addBond[name_String, character_ : $soloCharacter] := Module[
	{ownedBonds, progressResult, updated},
	ownedBonds = normalizeCharacterBonds[character];
	If[ownedBonds === $Failed, Return[$Failed]];
	If[MemberQ[ownedBonds, name],
		Message[bond::duplicate, name, character];
		Return[$Failed]
	];
	progressResult = markProgress["Bonds", 1, character];
	If[progressResult === $Failed, Return[$Failed]];
	updated = Append[ownedBonds, name];
	$state[character, "bonds"] = updated;
	updated
];

bond[name_String, character_ : $soloCharacter] := Module[
	{ownedBonds},
	ownedBonds = normalizeCharacterBonds[character];
	If[ownedBonds === $Failed, Return[$Failed]];
	If[!MemberQ[ownedBonds, name],
		Message[bond::unknown, name, character];
		Return[$Failed]
	];
	name
];

bonds[] :=
	bonds[$soloCharacter];

bonds[character_] := Module[
	{ownedBonds},
	ownedBonds = normalizeCharacterBonds[character];
	If[ownedBonds === $Failed, Return[$Failed]];
	ownedBonds
];

removeBond[name_String, character_ : $soloCharacter] := Module[
	{ownedBonds, position, updated},
	ownedBonds = normalizeCharacterBonds[character];
	If[ownedBonds === $Failed, Return[$Failed]];
	position = FirstPosition[ownedBonds, name, Missing["UnknownBond"]];
	If[!ListQ[position],
		Message[bond::unknown, name, character];
		Return[$Failed]
	];
	updated = Delete[ownedBonds, position];
	$state[character, "bonds"] = updated;
	clearProgress["Bonds", 1, character];
	updated
];

bond::nochar = "No character named `1` exists in the current state.";
bond::duplicate = "Character `2` already has a bond with `1`.";
bond::unknown = "Character `2` does not have a bond with `1`.";


(* ::Subsection::Closed:: *)
(*Scene management*)


beginScene[name_String, rank_?rankQ, character_ : $soloCharacter] := Module[
	{ownedScene, newScene},
	ownedScene = normalizeCharacterScene[character];
	If[ownedScene === $Failed, Return[$Failed]];
	If[AssociationQ[ownedScene],
		Message[scene::active, character, ownedScene["Name"]];
		Return[$Failed]
	];
	newScene = Association[
		"Name" -> name,
		"Rank" -> rank,
		"Progress" -> 0,
		"Countdown" -> 0
	];
	$state[character, "scene"] = newScene;
	newScene
];

beginScene[name_String, rank_, character_ : $soloCharacter] /; !rankQ[rank] := (
	Message[progress::badrank, rank];
	$Failed
);

scene[] :=
	scene[$soloCharacter];

scene[character_] := Module[
	{ownedScene},
	ownedScene = normalizeCharacterScene[character];
	If[ownedScene === $Failed, Return[$Failed]];
	If[ownedScene === None,
		Message[scene::none, character];
		Return[$Failed]
	];
	ownedScene
];

removeScene[] :=
	removeScene[$soloCharacter];

removeScene[character_] := Module[
	{ownedScene},
	ownedScene = normalizeCharacterScene[character];
	If[ownedScene === $Failed, Return[$Failed]];
	If[ownedScene === None,
		Message[scene::none, character];
		Return[$Failed]
	];
	$state[character, "scene"] = None;
	ownedScene
];

markSceneCountdown[] :=
	markSceneCountdown[1, $soloCharacter];

markSceneCountdown[n_Integer?NonNegative] :=
	markSceneCountdown[n, $soloCharacter];

markSceneCountdown[n_Integer?NonNegative, character_] := Module[
	{ownedScene, previous, requested, clamped},
	ownedScene = normalizeCharacterScene[character];
	If[ownedScene === $Failed, Return[$Failed]];
	If[ownedScene === None,
		Message[scene::none, character];
		Return[$Failed]
	];
	previous = ownedScene["Countdown"];
	requested = previous + n;
	clamped = clampValue[requested, {0, 4}];
	If[!TrueQ[requested == clamped],
		Message[scene::clamped, ownedScene["Name"], character, requested, clamped]
	];
	$state[character, "scene", "Countdown"] = clamped;
	ownedScene = $state[character, "scene"];
	If[previous < 4 && clamped >= 4,
		Message[scene::filled, ownedScene["Name"]]
	];
	clamped
];

markSceneCountdown[n_Integer?Negative, character_ : $soloCharacter] := (
	Message[scene::badcount, n];
	$Failed
);

scene::nochar = "No character named `1` exists in the current state.";
scene::active = "Character `1` already has an active scene named `2`.";
scene::none = "Character `1` does not have an active scene.";
scene::filled = "Scene countdown for `1` is filled.";
scene::clamped = "Scene countdown for `1` on character `2` was clamped from `3` to `4`.";
scene::badcount = "Scene countdown marks must be a non-negative integer, got `1`.";


(* ::Subsection::Closed:: *)
(*Delve management*)


Options[addDelve] = {Objective -> None};

addDelve[name_String, rank_?rankQ, themeSpec_, domainSpec_, opts : OptionsPattern[]] :=
	addDelve[name, rank, themeSpec, domainSpec, Automatic, $soloCharacter, opts];

addDelve[name_String, rank_?rankQ, themeSpec_, domainSpec_, character_String, opts : OptionsPattern[]] :=
	addDelve[name, rank, themeSpec, domainSpec, Automatic, character, opts];

addDelve[name_String, rank_?rankQ, themeSpec_, domainSpec_, denizenSpec_List, opts : OptionsPattern[]] :=
	addDelve[name, rank, themeSpec, domainSpec, denizenSpec, $soloCharacter, opts];

addDelve[name_String, rank_?rankQ, themeSpec_, domainSpec_, denizenSpec_, character_String, opts : OptionsPattern[]] := Module[
	{ownedDelves, ownedDelve},
	ownedDelves = normalizeCharacterDelves[character];
	If[ownedDelves === $Failed, Return[$Failed]];
	If[KeyExistsQ[ownedDelves, name],
		Message[delve::duplicate, name, character];
		Return[$Failed]
	];
	ownedDelve = makeDelve[name, rank, themeSpec, domainSpec, OptionValue[Objective], denizenSpec];
	If[ownedDelve === $Failed, Return[$Failed]];
	$state[character, "delves", name] = ownedDelve;
	ownedDelve
];

addDelve[name_String, rank_, ___] /; !rankQ[rank] := (
	Message[progress::badrank, rank];
	$Failed
);

setCurrentDelve[name_String, character_ : $soloCharacter] := Module[
	{ownedDelve},
	ownedDelve = requireDelve[name, character];
	If[ownedDelve === $Failed, Return[$Failed]];
	$state[character, "currentDelve"] = name;
	ownedDelve
];

delve[] := Module[
	{ownedDelve},
	ownedDelve = currentDelveData[$soloCharacter];
	If[ownedDelve === $Failed, Return[$Failed]];
	ownedDelve
];

delve[name_String] :=
	delve[name, $soloCharacter];

delve[name_String, character_] := Module[
	{ownedDelve},
	ownedDelve = requireDelve[name, character];
	If[ownedDelve === $Failed, Return[$Failed]];
	ownedDelve
];

delves[character_ : $soloCharacter] := Module[
	{ownedDelves},
	ownedDelves = normalizeCharacterDelves[character];
	If[ownedDelves === $Failed, Return[$Failed]];
	ownedDelves
];

removeDelve[name_String, character_ : $soloCharacter] := Module[
	{ownedDelves},
	ownedDelves = normalizeCharacterDelves[character];
	If[ownedDelves === $Failed, Return[$Failed]];
	If[!KeyExistsQ[ownedDelves, name],
		Message[delve::unknown, name, character];
		Return[$Failed]
	];
	$state[character, "delves"] = KeyDrop[ownedDelves, name];
	If[Lookup[$state[character], "currentDelve", None] === name,
		$state[character, "currentDelve"] = None
	];
	$state[character, "delves"]
];

setDelveTheme[themeSpec_] :=
	withCurrentDelve[setDelveTheme[#1, themeSpec, #2] &];

setDelveTheme[delveName_String, themeSpec_] :=
	setDelveTheme[delveName, themeSpec, $soloCharacter];

setDelveTheme[delveName_String, themeSpec_, character_] := Module[
	{ownedDelve, themes},
	ownedDelve = requireDelve[delveName, character];
	If[ownedDelve === $Failed, Return[$Failed]];
	themes = normalizeDelveCards[themeSpec, "Theme"];
	If[themes === $Failed, Return[$Failed]];
	If[validateDelveCardPair[themes, ownedDelve["Domains"]] === $Failed, Return[$Failed]];
	$state[character, "delves", delveName, "Themes"] = themes;
	$state[character, "delves", delveName, "Theme"] = First[themes];
	$state[character, "delves", delveName]
];

setDelveDomain[domainSpec_] :=
	withCurrentDelve[setDelveDomain[#1, domainSpec, #2] &];

setDelveDomain[delveName_String, domainSpec_] :=
	setDelveDomain[delveName, domainSpec, $soloCharacter];

setDelveDomain[delveName_String, domainSpec_, character_] := Module[
	{ownedDelve, domains},
	ownedDelve = requireDelve[delveName, character];
	If[ownedDelve === $Failed, Return[$Failed]];
	domains = normalizeDelveCards[domainSpec, "Domain"];
	If[domains === $Failed, Return[$Failed]];
	If[validateDelveCardPair[ownedDelve["Themes"], domains] === $Failed, Return[$Failed]];
	$state[character, "delves", delveName, "Domains"] = domains;
	$state[character, "delves", delveName, "Domain"] = First[domains];
	$state[character, "delves", delveName]
];

returnToSite[] :=
	withCurrentDelve[returnToSite[#1, #2] &];

returnToSite[delveName_String] :=
	returnToSite[delveName, $soloCharacter];

returnToSite[delveName_String, character_] := Module[
	{ownedDelve, dice, roll},
	ownedDelve = requireDelve[delveName, character];
	If[ownedDelve === $Failed, Return[$Failed]];
	dice = rollChallengeDice[];
	roll = Association[
		"character" -> character,
		"delveName" -> delveName,
		"challengeDice" -> dice,
		"lowerDie" -> Min[dice],
		"match" -> SameQ @@ dice
	];
	roll
];

riskZoneData[delveData_Association] := Module[
	{progress, ranks, name, rank},
	progress = delveData["Progress"];
	{name, ranks} = Which[
		progress < 4,
			{"Low Risk", {Troublesome, Dangerous}},
		progress < 8,
			{"Medium Risk", {Dangerous, Formidable}},
		True,
			{"High Risk", {Formidable, Extreme}}
	];
	rank = If[rankIndex[delveData["Rank"]] <= rankIndex[Dangerous], First[ranks], Last[ranks]];
	Association["Name" -> name, "Ranks" -> ranks, "Rank" -> rank]
];

riskZone[] :=
	withCurrentDelve[riskZone[#1, #2] &];

riskZone[delveName_String] :=
	riskZone[delveName, $soloCharacter];

riskZone[delveName_String, character_] := Module[
	{ownedDelve, zone},
	ownedDelve = requireDelve[delveName, character];
	If[ownedDelve === $Failed, Return[$Failed]];
	zone = riskZoneData[ownedDelve];
	zone
];

denizens[] :=
	withCurrentDelve[denizens[#1, #2] &];

denizens[delveName_String] :=
	denizens[delveName, $soloCharacter];

denizens[delveName_String, character_] := Module[
	{ownedDelve},
	ownedDelve = requireDelve[delveName, character];
	If[ownedDelve === $Failed, Return[$Failed]];
	ownedDelve["Denizens"]
];

denizenSlotFromValue[value_Integer] :=
	First @ FirstPosition[denizenSlotThresholds, threshold_ /; value <= threshold];

rollDenizen[] :=
	withCurrentDelve[rollDenizen[#1, #2] &];

rollDenizen[delveName_String] :=
	rollDenizen[delveName, $soloCharacter];

rollDenizen[delveName_String, character_] := Module[
	{ownedDelve, dice, value, slot, roll},
	ownedDelve = requireDelve[delveName, character];
	If[ownedDelve === $Failed, Return[$Failed]];
	dice = rollOracleDice[];
	value = oracleRollValue[dice];
	slot = denizenSlotFromValue[value];
	roll = Association[
		"character" -> character,
		"delveName" -> delveName,
		"oracleDice" -> dice,
		"value" -> value,
		"slot" -> slot,
		"frequency" -> denizenSlotLabels[[slot]],
		"range" -> denizenSlotRanges[[slot]],
		"denizen" -> ownedDelve["Denizens"][[slot]]
	];
	roll
];

setDenizen[slot_Integer, name_] :=
	withCurrentDelve[setDenizen[#1, slot, name, #2] &];

setDenizen[delveName_String, slot_Integer, name_] :=
	setDenizen[delveName, slot, name, $soloCharacter];

setDenizen[delveName_String, slot_Integer, name_, character_] := Module[
	{ownedDelve, normalized, denizenList},
	If[!Between[{1, 12}][slot],
		Message[delve::badslot, slot];
		Return[$Failed]
	];
	ownedDelve = requireDelve[delveName, character];
	If[ownedDelve === $Failed, Return[$Failed]];
	normalized = normalizeDenizenSlot[name];
	If[normalized === $Failed,
		Message[delve::baddenizen, name];
		Return[$Failed]
	];
	denizenList = ownedDelve["Denizens"];
	If[StringQ[normalized],
		denizenList = Replace[denizenList, normalized -> None, {1}]
	];
	denizenList[[slot]] = normalized;
	$state[character, "delves", delveName, "Denizens"] = denizenList;
	denizenList
];

clearDenizen[slot_Integer] :=
	withCurrentDelve[clearDenizen[#1, slot, #2] &];

clearDenizen[delveName_String, slot_Integer] :=
	clearDenizen[delveName, slot, $soloCharacter];

clearDenizen[delveName_String, slot_Integer, character_] :=
	setDenizen[delveName, slot, None, character];

delve::nochar = "No character named `1` exists in the current state.";
delve::nocurrent = "Character `1` does not have a current delve.";
delve::unknown = "Character `2` does not have a delve named `1`.";
delve::duplicate = "Character `2` already has a delve named `1`.";
delve::badtheme = "Unknown delve theme `1`. Use one of: `2`.";
delve::baddomain = "Unknown delve domain `1`. Use one of: `2`.";
delve::badcards = "Delve `1` cards must be a string or a one- or two-string list.";
delve::toomanycards = "A delve can have two themes or two domains, but not both.";
delve::badobjective = "Delve objective must be None or a string, not `1`.";
delve::baddenizens = "Denizens must be a 12-item list of strings or None.";
delve::baddenizen = "Denizen must be a non-empty string or None, not `1`.";
delve::badslot = "Denizen slot must be an integer from 1 to 12, not `1`.";


(* ::Subsection::Closed:: *)
(*Experience tracking*)


markExperience[n_Integer, character_ : $soloCharacter] :=
	$state[character, "earnedExperience"] += n;

spendExperience[n_Integer, character_ : $soloCharacter] :=
	$state[character, "spentExperience"] += n;


(* ::Subsection::Closed:: *)
(*Private context footer*)


End[];


(* ::Section::Closed:: *)
(*Package footer*)


EndPackage[];
