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


(* ::Section:: *)
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


(* ::Subsection:: *)
(*Core oracles*)


(* ::Subsection:: *)
(*Location oracles*)


(* ::Subsection:: *)
(*Settlement oracles*)


(* ::Subsection:: *)
(*Character oracles*)


(* ::Subsection:: *)
(*Delve site oracles*)


(* ::Subsection:: *)
(*Monstrosity oracles*)


(* ::Subsection:: *)
(*Threat oracles*)


(* ::Subsection:: *)
(*Story oracles*)


(* ::Subsection:: *)
(*Combat oracles*)


(* ::Subsection:: *)
(*Magic oracles*)


(* ::Subsection:: *)
(*Scale oracles*)


(* ::Subsection::Closed:: *)
(*Private context footer*)


End[];


(* ::Section::Closed:: *)
(*Package footer*)


EndPackage[];
