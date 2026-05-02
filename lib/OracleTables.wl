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
YesNo::usage = "YesNo[yesOutcome, noOutcome] returns a Yes/No oracle table with those two outcomes.";


(* ::Section::Closed:: *)
(*Implementation details*)


(* ::Subsection::Closed:: *)
(*Private context header*)


Begin["`Private`"]; 


(* ::Subsection::Closed:: *)
(*Oracle association*)


oracles = <||>;


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
(*Core oracles*)


(* ::Subsubsection:: *)
(*Core: Action*)


(* ::Subsubsection:: *)
(*Core: Theme*)


(* ::Subsubsection:: *)
(*Core: Descriptor*)


(* ::Subsubsection:: *)
(*Core: Focus*)


(* ::Subsection::Closed:: *)
(*Location oracles*)


(* ::Subsubsection:: *)
(*Overland Landmark*)


(* ::Subsubsection:: *)
(*Overland Waypoint*)


(* ::Subsubsection:: *)
(*Overland Peril*)


(* ::Subsubsection:: *)
(*Overland Opportunity*)


(* ::Subsubsection:: *)
(*Coastal Waters Landmark*)


(* ::Subsubsection:: *)
(*Coastal Waters Waypoint*)


(* ::Subsubsection:: *)
(*Coastal Waters Peril*)


(* ::Subsubsection:: *)
(*Coastal Waters Opportunity*)


(* ::Subsection::Closed:: *)
(*Settlement oracles*)


(* ::Subsubsection:: *)
(*Settlement: Type*)


(* ::Subsubsection:: *)
(*Settlement: Condition*)


(* ::Subsubsection:: *)
(*Settlement: Disposition*)


(* ::Subsubsection:: *)
(*Settlement: First Look*)


(* ::Subsubsection:: *)
(*Settlement: Projects*)


(* ::Subsubsection:: *)
(*Settlement: Troubles*)


(* ::Subsubsection:: *)
(*Settlement: Cultural Touchstones*)


(* ::Subsubsection:: *)
(*Settlement Name: Category*)


(* ::Subsubsection:: *)
(*Settlement Name: Terrain Feature*)


(* ::Subsubsection:: *)
(*Settlement Name: Key Structure*)


(* ::Subsubsection:: *)
(*Settlement Name: Creature*)


(* ::Subsubsection:: *)
(*Settlement Name: Historical Event*)


(* ::Subsubsection:: *)
(*Settlement Name: Old Language*)


(* ::Subsubsection:: *)
(*Settlement Name: Environment*)


(* ::Subsubsection:: *)
(*Settlement Name: Something Else*)


(* ::Subsubsection:: *)
(*Settlement Quick Name: Prefix*)


(* ::Subsubsection:: *)
(*Settlement Quick Name: Suffix*)


(* ::Subsection::Closed:: *)
(*Character oracles*)


(* ::Subsubsection:: *)
(*Character: First Look*)


(* ::Subsubsection:: *)
(*Character: Activity*)


(* ::Subsubsection:: *)
(*Character: Disposition*)


(* ::Subsubsection:: *)
(*Character: Role*)


(* ::Subsubsection:: *)
(*Character: Goal*)


(* ::Subsubsection:: *)
(*Character: Revealed Details*)


(* ::Subsubsection:: *)
(*Character Name: Ironlander Set 1*)


(* ::Subsubsection:: *)
(*Character Name: Ironlander Set 2*)


(* ::Subsubsection:: *)
(*Character Name: Firstborn*)


(* ::Subsection::Closed:: *)
(*Delve site oracles*)


(* NEED TO SORT OUT DELVE DOMAIN/THEME CARDS. LIKE YES/NO *)


(* ::Subsubsection:: *)
(*Delve Site: Theme*)


(* ::Subsubsection:: *)
(*Delve Site: Domain*)


(* ::Subsubsection:: *)
(*Delve Site: Danger*)


(* ::Subsubsection:: *)
(*Delve Site Name: Template*)


(* ::Subsubsection:: *)
(*Delve Site Name: Description*)


(* ::Subsubsection:: *)
(*Delve Site Name: Detail*)


(* ::Subsubsection:: *)
(*Delve Site Name: Namesake*)


(* ::Subsubsection:: *)
(*Delve Site Name: Place*)


(* ::Subsubsection:: *)
(*Delve Site: Trap Event*)


(* ::Subsubsection:: *)
(*Delve Site: Trap Component*)


(* ::Subsection::Closed:: *)
(*Monstrosity oracles*)


(* ::Subsubsection:: *)
(*Monstrosity: Size*)


(* ::Subsubsection:: *)
(*Monstrosity: Primary Form*)


(* ::Subsubsection:: *)
(*Monstrosity: Characteristics*)


(* ::Subsubsection:: *)
(*Monstrosity: Abilities*)


(* ::Subsection::Closed:: *)
(*Threat oracles*)


(* ::Subsubsection:: *)
(*Threat: Category*)


(* ::Subsubsection:: *)
(*Threat: Action*)


(* ::Subsubsection:: *)
(*Threat: Burgeoning Conflict*)


(* ::Subsubsection:: *)
(*Threat: Cursed Site*)


(* ::Subsubsection:: *)
(*Threat: Environmental Calamity*)


(* ::Subsubsection:: *)
(*Threat: Malignant Plague*)


(* ::Subsubsection:: *)
(*Threat: Rampaging Creature*)


(* ::Subsubsection:: *)
(*Threat: Ravaging Horde*)


(* ::Subsubsection:: *)
(*Threat: Scheming Leader*)


(* ::Subsubsection:: *)
(*Threat: Power-Hungry Mystic*)


(* ::Subsubsection:: *)
(*Threat: Zealous Cult*)


(* ::Subsection::Closed:: *)
(*Story oracles*)


(* ::Subsubsection:: *)
(*Story: Region*)


(* ::Subsubsection:: *)
(*Story: Plot Twist*)


(* ::Subsubsection:: *)
(*Story: Clue*)


(* ::Subsection::Closed:: *)
(*Combat oracles*)


(* ::Subsubsection:: *)
(*Combat: Battleground*)


(* ::Subsubsection:: *)
(*Combat: Tactic*)


(* ::Subsubsection:: *)
(*Combat: Event Method*)


(* ::Subsubsection:: *)
(*Combat: Event Target*)


(* ::Subsection::Closed:: *)
(*Magic oracles*)


(* ::Subsubsection:: *)
(*Magic: Ritual Backlash*)


(* ::Subsubsection:: *)
(*Magic: Mystical Effect*)


(* ::Subsection::Closed:: *)
(*Scale oracles*)


(* ::Subsubsection:: *)
(*Scale: Size*)


(* ::Subsubsection:: *)
(*Scale: Number*)


(* ::Subsubsection:: *)
(*Scale: Distance*)


(* ::Subsubsection:: *)
(*Scale: Time*)


(* ::Subsubsection:: *)
(*Scale: Power*)


(* ::Subsubsection:: *)
(*Scale: Complexity*)


(* ::Subsubsection:: *)
(*Scale: Value*)


(* ::Subsubsection:: *)
(*Scale: Influence*)


(* ::Subsubsection:: *)
(*Scale: Disposition*)


(* ::Subsection::Closed:: *)
(*Private context footer*)


End[];


(* ::Section::Closed:: *)
(*Package footer*)


EndPackage[];
