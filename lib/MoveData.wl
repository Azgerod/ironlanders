(* ::Package:: *)

(* ::Section:: *)
(*Public symbols*)


moves::usage = "Association of moves.";


(* ::Section:: *)
(*Helpers*)


move[name_String, header_String, strongHit_String, weakHit_String, miss_String] := <|
  "name" -> name,
  "header" -> header,
  "strongHit" -> strongHit,
  "weakHit" -> weakHit,
  "miss" -> miss
|>;


(* ::Section:: *)
(*Move association*)


moves = Association[];


(* ::Section:: *)
(*Adventure moves*)


(* ::Subsection:: *)
(*Face Danger*)


moves["faceDanger"] = move[
	"Face Danger",
	"When you attempt something risky or react to an imminent threat, envision your action and roll. If you act\[Ellipsis]
\:2734 With speed, agility, or precision: Roll +edge.
\:2734 With charm, loyalty, or courage: Roll +heart.
\:2734 With aggressive action, forceful defense, strength, or endurance: Roll +iron.
\:2734 With deception, stealth, or trickery: Roll +shadow.
\:2734 With expertise, insight, or observation: Roll +wits.",
	"You are successful. Take +1 momentum.",
	"You succeed, but face a troublesome cost. Choose one.
\:2734 You are delayed, lose advantage, or face a new danger: Suffer \[Dash]1 momentum.
\:2734 You are tired or hurt: Endure Harm (1 harm).
\:2734 You are dispirited or afraid: Endure Stress (1 stress).
\:2734 You sacrifice resources: Suffer \[Dash]1 supply.",
	"You fail, or a momentary success is undermined by a dire turn of events. Pay the Price."
];


(* ::Section:: *)
(*Journey moves*)


(* ::Subsection:: *)
(*Undertake a Journey*)


moves["undertakeAJourney"] = move[
	"Undertake a Journey",
	"When you travel across hazardous or unfamiliar lands, set the rank of your journey.
\:2734 Troublesome journey: 3 progress per waypoint.
\:2734 Dangerous journey: 2 progress per waypoint.
\:2734 Formidable journey: 1 progress per waypoint.
\:2734 Extreme journey: 2 ticks per waypoint.
\:2734 Epic journey: 1 tick per waypoint.
Then, for each segment of your journey, roll +wits. If you are setting off from a community with which you share a bond, add +1 to your initial roll.",
	"You reach a waypoint. If the waypoint is unknown to you, envision it (Ask the Oracle if unsure). Then, choose one.
\:2734 You make good use of your resources: Mark progress.
\:2734 You move at speed: Mark progress and take +1 momentum, but suffer \[Dash]1 supply.",
	"You reach a waypoint and mark progress, but suffer \[Dash]1 supply.",
	"You are waylaid by a perilous event. Pay the Price."
];


(* ::Section:: *)
(*Scene challenge moves*)


(* ::Section:: *)
(*Quest moves*)


(* ::Subsection:: *)
(*Fulfill Your Vow*)


moves["fulfillYourVow"] = move[
	"Fulfill Your Vow",
	"When you achieve what you believe to be the fulfillment of your vow, roll the challenge dice and compare to your progress. Momentum is ignored on this roll.",
	"Your quest is complete. Mark experience (troublesome=1; dangerous=2; formidable=3; extreme=4; epic=5).",
	"There is more to be done or you realize the truth of your quest. Envision what you discover (Ask the Oracle if unsure). Then, mark experience (troublesome=0; dangerous=1; formidable=2; extreme=3; epic=4). You may Swear an Iron Vow to set things right. If you do, add +1.",
	"Your quest is undone. Envision what happens (Ask the Oracle if unsure), and choose one.
\:2734 You recommit: Clear all but one filled progress, and raise the quest\[CloseCurlyQuote]s rank by one (if not already epic).
\:2734 You give up: Forsake Your Vow."
];


(* ::Section:: *)
(*Fate moves*)


(* ::Subsection:: *)
(*Ask the Oracle*)


moves["askTheOracle"]=Association[];
moves["askTheOracle", "name"] = "Ask the Oracle";
moves["askTheOracle", "header"] = "When you seek to resolve questions, discover details in the world, determine how other characters respond, or trigger encounters or events, you may...
\:2734 Draw a conclusion: Decide the answer based on the most interesting and obvious result.
\:2734 Ask a yes/no question: Decide the odds of a 'yes', and roll on the Yes/No table to check the answer.
\:2734 Pick two: envision two options. Rate one as 'likely', and roll on the Yes/No table to see if it is true. If not, it is the other.
\:2734 Spark an idea: Brainstorm or use a random prompt.";


(* ::Section:: *)
(*Relationship moves*)


(* ::Section:: *)
(*Combat moves*)


(* ::Section:: *)
(*Suffer moves*)


(* ::Section:: *)
(*Delve moves*)


(* ::Section:: *)
(*Failure moves*)


(* ::Section:: *)
(*Threat moves*)


(* ::Section:: *)
(*Rarity moves*)
