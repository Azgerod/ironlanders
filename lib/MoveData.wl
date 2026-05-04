(* ::Package:: *)

(* ::Title:: *)
(*Move Data*)


(* ::Chapter:: *)
(*Introduction*)


(* ::Text:: *)
(*This file contains data used by the Iron Library for implementing moves.*)


(* ::Chapter:: *)
(*Code*)


(* ::Section::Closed:: *)
(*Package header*)


BeginPackage["MoveData`"];


(* ::Section::Closed:: *)
(*Public symbols*)


moves::usage = "Association of moves.";


(* ::Section:: *)
(*Implementation details*)


(* ::Subsection::Closed:: *)
(*Private context header*)


Begin["`Private`"]; 


(* ::Subsection::Closed:: *)
(*Move insertion helper*)


move[name_String, header_, strongHit_, weakHit_, miss_] := <|
	"name" -> name,
	"header" -> header,
	"strongHit" -> strongHit,
	"weakHit" -> weakHit,
	"miss" -> miss
|>;

b[text_] := Style[text, Bold];
i[text_] := Style[text, Italic];
bi[text_] := Style[text, Bold, Italic];

p[parts___] := Row[{parts}];

paras[items___] := Column[
	{items},
	Spacings -> 0.8,
	Alignment -> Left
];

choice[key_String, text_] := <|
	"Type" -> "Choice",
	"Key" -> key,
	"Text" -> text
|>;

choiceGroup[label_String, choices_List] := <|
	"Type" -> "ChoiceGroup",
	"Label" -> label,
	"Choices" -> choices
|>;

choiceGroupQ[item_] :=
	AssociationQ[item] && Lookup[item, "Type", None] === "ChoiceGroup";

numberedChoiceRow[index_Integer, text_] :=
	p[ToString[index], ". ", text];

choiceDisplayRows[choices_List] := Module[
	{index = 0, rows = {}, item, groupChoice},
	Do[
		If[choiceGroupQ[item],
			AppendTo[rows, p[b[item["Label"]]]];
			Do[
				index++;
				AppendTo[rows, numberedChoiceRow[index, groupChoice["Text"]]],
				{groupChoice, item["Choices"]}
			],
			index++;
			AppendTo[rows, numberedChoiceRow[index, item["Text"]]]
		],
		{item, choices}
	];
	rows
];

flattenChoices[choices_List] := Module[
	{flat = {}, item, groupLabel},
	Do[
		If[choiceGroupQ[item],
			groupLabel = item["Label"];
			flat = Join[flat, (Join[#, <|"Group" -> groupLabel|>] &) /@ item["Choices"]],
			AppendTo[flat, item]
		],
		{item, choices}
	];
	flat
];

choiceSection[pre_List, choices_List, post_List : {}] := <|
	"Text" -> Apply[paras, Join[pre, choiceDisplayRows[choices], post]],
	"Choices" -> flattenChoices[choices]
|>;


(* ::Subsection::Closed:: *)
(*Move association*)


moves = Association[];


(* ::Subsection::Closed:: *)
(*Adventure moves*)


(* ::Subsubsection::Closed:: *)
(*Face Danger*)


faceDangerWeakChoices = {
	choice["delay", p["You are delayed, lose advantage, or face a new danger: Suffer \[Dash]1 momentum."]],
	choice["harm", p["You are tired or hurt: ", i["Endure Harm"], " (1 harm)."]],
	choice["stress", p["You are dispirited or afraid: ", i["Endure Stress"], " (1 stress)."]],
	choice["supply", p["You sacrifice resources: Suffer \[Dash]1 supply."]]
};


moves["faceDanger"] = move[
	"Face Danger",
	paras[
		p[b["When you attempt something risky or react to an imminent threat,"], " envision your action and roll. If you act\[Ellipsis]"],
		p["\:2734 With speed, agility, or precision: Roll +edge."],
		p["\:2734 With charm, loyalty, or courage: Roll +heart."],
		p["\:2734 With aggressive action, forceful defense, strength, or endurance: Roll +iron."],
		p["\:2734 With deception, stealth, or trickery: Roll +shadow."],
		p["\:2734 With expertise, insight, or observation: Roll +wits."]
	],
	paras[
		p["You are successful. Take +1 momentum."]
	],
	choiceSection[
		{p["You succeed, but face a troublesome cost. Choose one."]},
		faceDangerWeakChoices
	],
	paras[
		p["You fail, or a momentary success is undermined by a dire turn of events. ", i["Pay the Price"], "."]
	]
];


(* ::Subsubsection::Closed:: *)
(*Secure an Advantage*)


secureAnAdvantageChoices = {
	choice["momentum", p["Take +2 momentum."]],
	choice["add", p["Add +1 on your next move (not a progress move)."]]
};


moves["secureAnAdvantage"] = move[
	"Secure an Advantage",
	paras[
		p[b["When you assess a situation, make preparations, or attempt to gain leverage,"], " envision your action and roll. If you act\[Ellipsis]"],
		p["\:2734 With speed, agility, or precision: Roll +edge."],
		p["\:2734 With charm, loyalty, or courage: Roll +heart."],
		p["\:2734 With aggressive action, forceful defense, strength, or endurance: Roll +iron."],
		p["\:2734 With deception, stealth, or trickery: Roll +shadow."],
		p["\:2734 With expertise, insight, or observation: Roll +wits."]
	],
	paras[
		p["Take both."],
		p["\:2734 Take +2 momentum."],
		p["\:2734 Add +1 on your next move (not a progress move)."]
	],
	choiceSection[
		{p["Choose one."]},
		secureAnAdvantageChoices
	],
	paras[
		p["You fail or your assumptions betray you. ", i["Pay the Price"], "."]
	]
];


(* ::Subsubsection::Closed:: *)
(*Gather Information*)


moves["gatherInformation"] = move[
	"Gather Information",
	paras[
		p[b["When you search an area, ask questions, conduct an investigation, or follow a track,"], " roll +wits. If you act within a community or ask questions of a person with whom you share a bond, add +1."]
	],
	paras[
		p["You discover something helpful and specific. The path you must follow or action you must take to make progress is made clear. Envision what you learn (", i["Ask the Oracle"], " if unsure), and take +2 momentum."]
	],
	paras[
		p["The information complicates your quest or introduces a new danger. Envision what you discover (", i["Ask the Oracle"], " if unsure), and take +1 momentum."]
	],
	paras[
		p["Your investigation unearths a dire threat or reveals an unwelcome truth that undermines your quest. ", i["Pay the Price"], "."]
	]
];


(* ::Subsubsection::Closed:: *)
(*Make Camp*)


makeCampChoices = {
	choice["recuperate", p["Recuperate: Take +1 health for you and any companions."]],
	choice["partake", p["Partake: Suffer \[Dash]1 supply and take +1 health for you and any companions."]],
	choice["relax", p["Relax: Take +1 spirit."]],
	choice["focus", p["Focus: Take +1 momentum."]],
	choice["prepare", p["Prepare: When you break camp, add +1 if you ", i["Undertake a Journey"], "."]]
};


moves["makeCamp"] = move[
	"Make Camp",
	paras[
		p[b["When you rest and recover for several hours in the wild,"], " roll +supply."]
	],
	choiceSection[
		{p["You and your allies may each choose two."]},
		makeCampChoices
	],
	choiceSection[
		{p["You and your allies may each choose one."]},
		makeCampChoices
	],
	paras[
		p["You take no comfort. ", i["Pay the Price"], "."]
	]
];


(* ::Subsubsection::Closed:: *)
(*Heal*)


moves["heal"] = move[
	"Heal",
	paras[
		p[b["When you treat an injury or ailment,"], " roll +wits. If you are mending your own wounds, roll +wits or +iron, whichever is lower."]
	],
	paras[
		p["Your care is helpful. If you (or the ally under your care) have the wounded condition, you may clear it. Then, take or give up to +2 health."]
	],
	paras[
		p["As above, but you must suffer \[Dash]1 supply or \[Dash]1 momentum (your choice)."]
	],
	paras[
		p["Your aid is ineffective. ", i["Pay the Price"], "."]
	]
];


(* ::Subsubsection::Closed:: *)
(*Resupply*)


moves["resupply"] = move[
	"Resupply",
	paras[
		p[b["When you hunt, forage, or scavenge,"], " roll +wits."]
	],
	paras[
		p["You bolster your resources. Take +2 supply."]
	],
	paras[
		p["Take up to +2 supply, but suffer \[Dash]1 momentum for each."]
	],
	paras[
		p["You find nothing helpful. ", i["Pay the Price"], "."]
	]
];


(* ::Subsubsection::Closed:: *)
(*Check Your Gear*)


moves["checkYourGear"] = move[
	"Check Your Gear",
	paras[
		p[b["When you check for a specific helpful item,"], " and you have at least 1 supply, roll +supply."]
	],
	paras[
		p["You have it. Take +1 momentum."]
	],
	paras[
		p["You have it, but your resources are diminished. Take +1 momentum and suffer \[Dash]1 supply."]
	],
	paras[
		p["You don\[CloseCurlyQuote]t have it and the situation worsens. ", i["Pay the Price"], "."]
	]
];


(* ::Subsection::Closed:: *)
(*Journey moves*)


(* ::Subsubsection::Closed:: *)
(*Undertake a Journey*)


journeyWaypointChoices = {
	choice["resources", p["You make good use of your resources: Mark progress."]],
	choice["speed", p["You move at speed: Mark progress and take +1 momentum, but suffer \[Dash]1 supply."]]
};


moves["undertakeAJourney"] = move[
	"Undertake a Journey",
	paras[
		p[b["When you travel across hazardous or unfamiliar lands,"], " set the rank of your journey."],
		p["\:2734 Troublesome journey: 3 progress per waypoint."],
		p["\:2734 Dangerous journey: 2 progress per waypoint."],
		p["\:2734 Formidable journey: 1 progress per waypoint."],
		p["\:2734 Extreme journey: 2 ticks per waypoint."],
		p["\:2734 Epic journey: 1 tick per waypoint."],
		p["Then, for each segment of your journey, roll +wits. If you are setting off from a community with which you share a bond, add +1 to your initial roll."]
	],
	choiceSection[
		{p["You reach a waypoint. If the waypoint is unknown to you, envision it (", i["Ask the Oracle"], " if unsure). Then, choose one."]},
		journeyWaypointChoices
	],
	paras[
		p["You reach a waypoint and mark progress, but suffer \[Dash]1 supply."]
	],
	paras[
		p["You are waylaid by a perilous event. ", i["Pay the Price"], "."]
	]
];


(* ::Subsubsection::Closed:: *)
(*Reach Your Destination*)


destinationFavorChoices = {
	choice["move", p["Make another move now (not a progress move), and add +1."]],
	choice["momentum", p["Take +1 momentum."]]
};


moves["reachYourDestination"] = move[
	"Reach Your Destination",
	paras[
		p[b["When your journey comes to an end,"], " roll the challenge dice and compare to your progress. Momentum is ignored on this roll."]
	],
	choiceSection[
		{p["The situation at your destination favors you. Choose one."]},
		destinationFavorChoices
	],
	paras[
		p["You arrive but face an unforeseen hazard or complication. Envision what you find (", i["Ask the Oracle"], " if unsure)."]
	],
	paras[
		p["You have gone hopelessly astray, your objective is lost to you, or you were misled about your destination. If your journey continues, clear all but one filled progress, and raise the journey\[CloseCurlyQuote]s rank by one (if not already epic)."]
	]
];


(* ::Subsubsection::Closed:: *)
(*Follow a Path*)


followAPathWeakChoices = {
	choice["longer", p["You took longer than expected."]],
	choice["harm", p["You pressed on through pain, sickness, or weariness: ", i["Endure Harm"], "."]],
	choice["stress", p["You suffered under the burden of foul weather, worries, or fearful locations: ", i["Endure Stress"], "."]],
	choice["resources", p["You wasted resources."]],
	choice["hazard", p["You face a complication or hazard at the destination. Envision what you find (", i["Ask the Oracle"], " if unsure)."]]
};


moves["followAPath"] = move[
	"Follow a Path",
	paras[
		p[b["When you journey along a known route,"], " and one day blends into the next, roll +supply."]
	],
	paras[
		p["You reach your destination and the situation favors you. Take +1 momentum."]
	],
	choiceSection[
		{p["You complete the journey, but face a cost or complication. Choose one or more."]},
		followAPathWeakChoices
	],
	paras[
		p["You are waylaid by a dire threat, and must ", i["Pay the Price"], ". If you overcome this obstacle, you may push on safely to your destination."]
	]
];


(* ::Subsection::Closed:: *)
(*Scene challenge moves*)


(* ::Subsubsection::Closed:: *)
(*Begin the Scene*)


beginSceneRankChoices = {
	choice["troublesome", p["You have a clear advantage: Troublesome."]],
	choice["dangerous", p["You are ready to act: Dangerous."]],
	choice["formidable", p["You are unprepared or outmatched: Formidable."]]
};


moves["beginTheScene"] = Association[];
moves["beginTheScene", "name"] = "Begin the Scene";
moves["beginTheScene", "header"] = choiceSection[
	{p[b["When you face an extended or complex challenge,"], " name your objective and choose a rank as appropriate to the situation."]},
	beginSceneRankChoices,
	{p["Then, activate a four\[Dash]segment countdown track and ", i["Face Danger"], " or ", i["Secure an Advantage"], " to take action."]}
];


(* ::Subsubsection::Closed:: *)
(*Face Danger (Scene)*)


moves["faceDangerScene"] = move[
	"Face Danger (Scene)",
	paras[
		p[b["When you attempt something risky or react to an imminent threat within a scene challenge,"], " envision your action and roll. If you act\[Ellipsis]"],
		p["\:2734 With speed, agility, or precision: Roll +edge."],
		p["\:2734 With charm, loyalty, or courage: Roll +heart."],
		p["\:2734 With aggressive action, forceful defense, strength, or endurance: Roll +iron."],
		p["\:2734 With deception, stealth, or trickery: Roll +shadow."],
		p["\:2734 With expertise, insight, or observation: Roll +wits."]
	],
	paras[
		p["You are successful and mark progress. ", b["On a match,"], " mark progress twice."]
	],
	paras[
		p["You are successful and mark progress, but also encounter a complication or setback. Envision what occurs and mark a countdown segment."]
	],
	paras[
		p["You fail, or a momentary success is undermined by a dramatic turn of events. Mark a countdown segment and ", i["Pay the Price"], ". ", b["On a match,"], " mark two segments and ", i["Pay the Price"], "."]
	]
];


(* ::Subsubsection::Closed:: *)
(*Secure an Advantage (Scene)*)


moves["secureAnAdvantageScene"] = move[
	"Secure an Advantage (Scene)",
	paras[
		p[b["When you assess a situation, make preparations, or attempt to gain leverage within a scene challenge,"], " envision your action and roll. If you act\[Ellipsis]"],
		p["\:2734 With speed, agility, or precision: Roll +edge."],
		p["\:2734 With charm, loyalty, or courage: Roll +heart."],
		p["\:2734 With aggressive action, forceful defense, strength, or endurance: Roll +iron."],
		p["\:2734 With deception, stealth, or trickery: Roll +shadow."],
		p["\:2734 With expertise, insight, or observation: Roll +wits."]
	],
	paras[
		p["Take both. ", b["On a match,"], " take both and mark progress."],
		p["\:2734 Take +2 momentum."],
		p["\:2734 Add +1 on your next move (not a progress move)."]
	],
	choiceSection[
		{p["Choose one."]},
		secureAnAdvantageChoices
	],
	paras[
		p["You fail or your assumptions betray you. Mark a countdown segment and ", i["Pay the Price"], ". ", b["On a match,"], " mark two segments and ", i["Pay the Price"], "."]
	]
];


(* ::Subsubsection::Closed:: *)
(*Finish the Scene*)


moves["finishTheScene"] = move[
	"Finish the Scene",
	paras[
		p[b["When the scene challenge countdown track or progress track is filled, or when events lead to the scene\[CloseCurlyQuote]s conclusion,"], " roll the challenge dice and compare to your progress."]
	],
	paras[
		p["You achieve your objective unconditionally."]
	],
	paras[
		p["You succeed, but not without cost. You must ", i["Pay the Price"], ". Make this a minor cost relative to the scope of the scene."]
	],
	paras[
		p["You fail or are undermined by a dire turn of events. ", i["Pay the Price"], "."]
	]
];


(* ::Subsection:: *)
(*Quest moves*)


(* ::Subsubsection::Closed:: *)
(*Swear an Iron Vow*)


vowObstacleChoices = {
	choice["pressOn", p["You press on: Suffer \[Dash]2 momentum, and do what you must to overcome this obstacle."]],
	choice["giveUp", p["You give up: ", i["Forsake Your Vow"], "."]]
};


moves["swearAnIronVow"] = move[
	"Swear an Iron Vow",
	paras[
		p[b["When you swear upon iron to complete a quest,"], " write your vow and give the quest a rank. Then, roll +heart. If you make this vow to a person or community with whom you share a bond, add +1."]
	],
	paras[
		p["You are emboldened and it is clear what you must do next (", i["Ask the Oracle"], " if unsure). Take +2 momentum."]
	],
	paras[
		p["You are determined but begin your quest with more questions than answers. Take +1 momentum, and envision what you do to find a path forward."]
	],
	choiceSection[
		{p["You face a significant obstacle before you can begin your quest. Envision what stands in your way (", i["Ask the Oracle"], " if unsure), and choose one."]},
		vowObstacleChoices
	]
];


(* ::Subsubsection::Closed:: *)
(*Reach a Milestone*)


moves["reachAMilestone"] = Association[];
moves["reachAMilestone", "name"] = "Reach a Milestone";
moves["reachAMilestone", "header"] = paras[
	p[b["When you make significant progress in your quest"], " by doing any of the following\[Ellipsis]"],
	p["\:2734 overcoming a critical obstacle"],
	p["\:2734 completing a perilous journey"],
	p["\:2734 solving a complex mystery"],
	p["\:2734 defeating a powerful threat"],
	p["\:2734 gaining vital support"],
	p["\:2734 acquiring a crucial item"],
	p["\[Ellipsis]you may mark progress per the rank of the vow."],
	p["\:2734 Troublesome quest: Mark 3 progress."],
	p["\:2734 Dangerous quest: Mark 2 progress."],
	p["\:2734 Formidable quest: Mark 1 progress."],
	p["\:2734 Extreme quest: Mark 2 ticks."],
	p["\:2734 Epic quest: Mark 1 tick."]
];


(* ::Subsubsection::Closed:: *)
(*Fulfill Your Vow*)


vowUndoneChoices = {
	choice["recommit", p["You recommit: Clear all but one filled progress, and raise the quest\[CloseCurlyQuote]s rank by one (if not already epic)."]],
	choice["giveUp", p["You give up: ", i["Forsake Your Vow"], "."]]
};


moves["fulfillYourVow"] = move[
	"Fulfill Your Vow",
	paras[
		p[b["When you achieve what you believe to be the fulfillment of your vow,"], " roll the challenge dice and compare to your progress. Momentum is ignored on this roll."]
	],
	paras[
		p["Your quest is complete. Mark experience (troublesome=1; dangerous=2; formidable=3; extreme=4; epic=5)."]
	],
	paras[
		p["There is more to be done or you realize the truth of your quest. Envision what you discover (", i["Ask the Oracle"], " if unsure). Then, mark experience (troublesome=0; dangerous=1; formidable=2; extreme=3; epic=4). You may ", i["Swear an Iron Vow"], " to set things right. If you do, add +1."]
	],
	choiceSection[
		{p["Your quest is undone. Envision what happens (", i["Ask the Oracle"], " if unsure), and choose one."]},
		vowUndoneChoices
	]
];


(* ::Subsubsection::Closed:: *)
(*Forsake Your Vow*)


moves["forsakeYourVow"] = Association[];
moves["forsakeYourVow", "name"] = "Forsake Your Vow";
moves["forsakeYourVow", "header"] = paras[
	p[b["When you renounce your quest, betray your promise, or the goal is lost to you,"], " clear the vow and ", i["Endure Stress"], ". You suffer \[Dash]spirit equal to the rank of your quest (troublesome=1; dangerous=2; formidable=3; extreme=4; epic=5)."],
	p["If the vow was made to a person or community with whom you share a bond, ", i["Test Your Bond"], " when you next meet."]
];


(* ::Subsubsection:: *)
(*Advance*)


moves["advance"] = Association[];
moves["advance", "name"] = "Advance";
moves["advance", "header"] = paras[
	p[b["When you focus on your skills, receive training, find inspiration, earn a reward, gain a companion, or take possession of an object of power,"], " you may spend 5 experience to add a new asset, 3 to upgrade an asset, or a varying amount to augment an eligible asset with a rarity."]
];


(* ::Subsection::Closed:: *)
(*Fate moves*)


(* ::Subsubsection::Closed:: *)
(*Pay the Price*)


payThePriceChoices = {
	choice["obvious", p["Make the most obvious negative outcome happen."]],
	choice["oracle", p["Envision two negative outcomes. Rate one as \[OpenCurlyQuote]likely\[CloseCurlyQuote], and ", i["Ask the Oracle"], " using the Yes/No table. On a \[OpenCurlyQuote]yes\[CloseCurlyQuote], make that outcome happen. Otherwise, make it the other."]],
	choice["table", p["Roll on the Pay the Price table. If you have difficulty interpreting the result to fit the current situation, roll again."]]
};


moves["payThePrice"] = Association[];
moves["payThePrice", "name"] = "Pay the Price";
moves["payThePrice", "header"] = choiceSection[
	{p[b["When you suffer the outcome of a move,"], " choose one."]},
	payThePriceChoices
];


(* ::Subsubsection::Closed:: *)
(*Ask the Oracle*)


askTheOracleChoices = {
	choice["conclusion", p["Draw a conclusion: Decide the answer based on the most interesting and obvious result."]],
	choice["yesNo", p["Ask a yes/no question: Decide the odds of a \[OpenCurlyQuote]yes\[CloseCurlyQuote], and roll on the Yes/No table to check the answer."]],
	choice["pickTwo", p["Pick two: Envision two options. Rate one as \[OpenCurlyQuote]likely\[CloseCurlyQuote], and roll on the Yes/No table to see if it is true. If not, it is the other."]],
	choice["prompt", p["Spark an idea: Brainstorm or use a random prompt."]]
};


moves["askTheOracle"] = Association[];
moves["askTheOracle", "name"] = "Ask the Oracle";
moves["askTheOracle", "header"] = choiceSection[
	{p[b["When you seek to resolve questions, discover details in the world, determine how other characters respond, or trigger encounters or events,"], " you may\[Ellipsis]"]},
	askTheOracleChoices,
	{p[b["On a match,"], " an extreme result or twist has occurred."]}
];


(* ::Subsection::Closed:: *)
(*Relationship moves*)


(* ::Subsubsection::Closed:: *)
(*Compel*)


moves["compel"] = move[
	"Compel",
	paras[
		p[b["When you attempt to persuade someone to do something,"], " envision your approach and roll. If you\[Ellipsis]"],
		p["\:2734 Charm, pacify, barter, or convince: Roll +heart (add +1 if you share a bond)."],
		p["\:2734 Threaten or incite: Roll +iron."],
		p["\:2734 Lie or swindle: Roll +shadow."]
	],
	paras[
		p["They\[CloseCurlyQuote]ll do what you want or share what they know. Take +1 momentum. If you use this exchange to ", i["Gather Information"], ", make that move now and add +1."]
	],
	paras[
		p["As above, but they ask something of you in return. Envision what they want (", i["Ask the Oracle"], " if unsure)."]
	],
	paras[
		p["They refuse or make a demand which costs you greatly. ", i["Pay the Price"], "."]
	]
];


(* ::Subsubsection::Closed:: *)
(*Aid Your Ally*)


moves["aidYourAlly"] = Association[];
moves["aidYourAlly", "name"] = "Aid Your Ally";
moves["aidYourAlly", "header"] = paras[
	p[b["When you ", i["Secure an Advantage"], " in direct support of an ally,"], " and score a hit, they (instead of you) can take the benefits of the move. If you are in combat and score a ", b["strong hit"], ", you and your ally have initiative."]
];


(* ::Subsubsection::Closed:: *)
(*Sojourn*)


sojournChoices = {
	choiceGroup["Clear a condition", {
		choice["mend", p["Mend: Clear a wounded debility and take +1 health."]],
		choice["hearten", p["Hearten: Clear a shaken debility and take +1 spirit."]],
		choice["equip", p["Equip: Clear an unprepared debility and take +1 supply."]]
	}],
	choiceGroup["Recover", {
		choice["recuperate", p["Recuperate: Take +2 health for yourself and any companions."]],
		choice["consort", p["Consort: Take +2 spirit."]],
		choice["provision", p["Provision: Take +2 supply."]],
		choice["plan", p["Plan: Take +2 momentum."]]
	}],
	choiceGroup["Provide Aid", {
		choice["quest", p["Take a quest: Envision what this community needs, or what trouble it is facing (", i["Ask the Oracle"], " if unsure). If you choose to help, ", i["Swear an Iron Vow"], " and add +1."]]
	}]
};


moves["sojourn"] = move[
	"Sojourn",
	paras[
		p[b["When you spend time in a community seeking assistance,"], " roll +heart. If you share a bond, add +1."]
	],
	choiceSection[
		{p["You and your allies may each choose two from within the categories below. If you share a bond, choose one more."]},
		sojournChoices
	],
	choiceSection[
		{p["You and your allies may each choose one from within the categories below. If you share a bond, choose one more."]},
		sojournChoices
	],
	paras[
		p["You find no help here. ", i["Pay the Price"], "."]
	]
];

moves["sojournFocus"] = move[
	"Sojourn: Focus",
	paras[
		p[b["On a hit on the "], bi["Sojourn"], b[" move,"], " you and your allies may each focus on one of your chosen recover actions and roll +heart again. If you share a bond, add +1."]
	],
	paras[
		p["Take +2 more for your focused action."]
	],
	paras[
		p["Take +1 more for your focused action."]
	],
	paras[
		p["It goes badly and you lose all benefits for your focused action."]
	]
];


(* ::Subsubsection::Closed:: *)
(*Forge a Bond*)


spiritMomentumChoices = {
	choice["spirit", p["Take +1 spirit."]],
	choice["momentum", p["Take +2 momentum."]]
};


moves["forgeABond"] = move[
	"Forge a Bond",
	paras[
		p[b["When you spend significant time with a person or community, stand together to face hardships, or make sacrifices for their cause,"], " you can attempt to create a bond. When you do, roll +heart. If you make this move after you successfully ", i["Fulfill Your Vow"], " to their benefit, you may reroll any dice."]
	],
	choiceSection[
		{p["Make note of the bond, mark a tick on your bond progress track, and choose one."]},
		spiritMomentumChoices
	],
	paras[
		p["They ask something more of you first. Envision what it is (", i["Ask the Oracle"], " if unsure), do it (or ", i["Swear an Iron Vow"], "), and mark the bond. If you refuse or fail, ", i["Pay the Price"], "."]
	],
	paras[
		p["They reject you. ", i["Pay the Price"], "."]
	]
];


(* ::Subsubsection::Closed:: *)
(*Test Your Bond*)


moves["testYourBond"] = move[
	"Test Your Bond",
	paras[
		p[b["When your bond is tested through conflict, betrayal, or circumstance,"], " roll +heart."]
	],
	choiceSection[
		{p["This test has strengthened your bond. Choose one."]},
		spiritMomentumChoices
	],
	paras[
		p["Your bond is fragile and you must prove your loyalty. Envision what they ask of you (", i["Ask the Oracle"], " if unsure), and do it (or ", i["Swear an Iron Vow"], "). If you refuse or fail, clear the bond and ", i["Pay the Price"], "."]
	],
	paras[
		p["Your bond is broken. Clear the bond and ", i["Pay the Price"], "."]
	]
];


(* ::Subsubsection::Closed:: *)
(*Draw the Circle*)


boastChoices = {
	choice["firstStrike", p["Grant first strike: Your foe has initiative."]],
	choice["bare", p["Bare yourself: Take no benefit of armor or shield; your foe\[CloseCurlyQuote]s harm is +1."]],
	choice["noIron", p["Hold no iron: Take no benefit of weapons; your harm is 1."]],
	choice["bloody", p["Bloody yourself: ", i["Endure Harm"], " (1 harm)."]],
	choice["death", p["To the death: One way or another, this fight must end with death."]]
};


moves["drawTheCircle"] = move[
	"Draw the Circle",
	paras[
		p[b["When you challenge someone to a formal duel, or accept a challenge,"], " roll +heart. If you share a bond with this community, add +1."]
	],
	choiceSection[
		{p["Take +1 momentum. You may also choose up to two boasts and take +1 momentum for each."]},
		boastChoices,
		{p["Then, make moves to resolve the fight. If you are the victor, you may make a lawful demand, and your opponent must comply or forfeit their honor and standing. If you refuse the challenge, surrender, or are defeated, they make a demand of you."]}
	],
	choiceSection[
		{p["You may choose one boast in exchange for +1 momentum."]},
		boastChoices,
		{p["Then, make moves to resolve the fight. If you are the victor, you may make a lawful demand, and your opponent must comply or forfeit their honor and standing. If you refuse the challenge, surrender, or are defeated, they make a demand of you."]}
	],
	paras[
		p["You begin the duel at a disadvantage. Your foe has initiative. ", i["Pay the Price"], "."],
		p["Then, make moves to resolve the fight. If you are the victor, you may make a lawful demand, and your opponent must comply or forfeit their honor and standing. If you refuse the challenge, surrender, or are defeated, they make a demand of you."]
	]
];


(* ::Subsubsection::Closed:: *)
(*Write Your Epilogue*)


moves["writeYourEpilogue"] = move[
	"Write Your Epilogue",
	paras[
		p[b["When you retire from your life as Ironsworn,"], " envision two things: What you hope for, and what you fear. Then, roll the challenge dice and compare to your bonds. Momentum is ignored on this roll."]
	],
	paras[
		p["Things come to pass as you hoped."]
	],
	paras[
		p["Your life takes an unexpected turn, but not necessarily for the worse. You find yourself spending your days with someone or in a place you did not foresee. Envision it (", i["Ask the Oracle"], " if unsure)."]
	],
	paras[
		p["Your fears are realized."]
	]
];


(* ::Subsection::Closed:: *)
(*Combat moves*)


(* ::Subsubsection::Closed:: *)
(*Enter the Fray*)


enterTheFrayWeakChoices = {
	choice["bolster", p["Bolster your position: Take +2 momentum."]],
	choice["initiative", p["Prepare to act: Take initiative."]]
};


moves["enterTheFray"] = move[
	"Enter the Fray",
	paras[
		p[b["When you enter into combat,"], " set the rank of each of your foes."],
		p["\:2734 Troublesome foe: 3 progress per harm; inflicts 1 harm."],
		p["\:2734 Dangerous foe: 2 progress per harm; inflicts 2 harm."],
		p["\:2734 Formidable foe: 1 progress per harm; inflicts 3 harm."],
		p["\:2734 Extreme foe: 2 ticks per harm; inflicts 4 harm."],
		p["\:2734 Epic foe: 1 tick per harm; inflicts 5 harm."],
		p["Then, roll to determine who is in control. If you are\[Ellipsis]"],
		p["\:2734 Facing off against your foe: Roll +heart."],
		p["\:2734 Moving into position against an unaware foe, or striking without warning: Roll +shadow."],
		p["\:2734 Ambushed: Roll +wits."]
	],
	paras[
		p["Take +2 momentum. You have initiative."]
	],
	choiceSection[
		{p["Choose one."]},
		enterTheFrayWeakChoices
	],
	paras[
		p["Combat begins with you at a disadvantage. ", i["Pay the Price"], ". Your foe has initiative."]
	]
];


(* ::Subsubsection::Closed:: *)
(*Strike*)


moves["strike"] = move[
	"Strike",
	paras[
		p[b["When you have initiative and attack in close quarters,"], " roll +iron. When you have initiative and attack at range, roll +edge."]
	],
	paras[
		p["Inflict +1 harm. You retain initiative."]
	],
	paras[
		p["Inflict your harm and lose initiative."]
	],
	paras[
		p["Your attack fails and you must ", i["Pay the Price"], ". Your foe has initiative."]
	]
];


(* ::Subsubsection::Closed:: *)
(*Clash*)


clashStrongChoices = {
	choice["bolster", p["You bolster your position: Take +1 momentum."]],
	choice["opening", p["You find an opening: Inflict +1 harm."]]
};


moves["clash"] = move[
	"Clash",
	paras[
		p[b["When your foe has initiative and you fight with them in close quarters,"], " roll +iron. When you exchange a volley at range, or shoot at an advancing foe, roll +edge."]
	],
	choiceSection[
		{p["Inflict your harm and choose one. You have the initiative."]},
		clashStrongChoices
	],
	paras[
		p["Inflict your harm, but then ", i["Pay the Price"], ". Your foe has initiative."]
	],
	paras[
		p["You are outmatched and must ", i["Pay the Price"], ". Your foe has initiative."]
	]
];


(* ::Subsubsection::Closed:: *)
(*Turn the Tide*)


moves["turnTheTide"] = Association[];
moves["turnTheTide", "name"] = "Turn the Tide";
moves["turnTheTide", "header"] = paras[
	p[b["Once per fight, when you risk it all,"], " you may steal initiative from your foe to make a move (not a progress move). When you do, add +1 and take +1 momentum on a hit."],
	p["If you fail to score a hit on that move, you must suffer a dire outcome. ", i["Pay the Price"], "."]
];


(* ::Subsubsection::Closed:: *)
(*Battle*)


moves["battle"] = move[
	"Battle",
	paras[
		p[b["When you fight a battle, and it happens in a blur,"], " envision your objective and roll. If you primarily\[Ellipsis]"],
		p["\:2734 Fight at range, or using your speed and the terrain to your advantage: Roll +edge."],
		p["\:2734 Fight depending on your courage, allies, or companions: Roll +heart."],
		p["\:2734 Fight in close to overpower your opponents: Roll +iron."],
		p["\:2734 Fight using trickery to befuddle your opponents: Roll +shadow."],
		p["\:2734 Fight using careful tactics to outsmart your opponents: Roll +wits."]
	],
	paras[
		p["You achieve your objective unconditionally. Take +2 momentum."]
	],
	paras[
		p["You achieve your objective, but not without cost. ", i["Pay the Price"], "."]
	],
	paras[
		p["You are defeated and the objective is lost to you. ", i["Pay the Price"], "."]
	]
];


(* ::Subsubsection::Closed:: *)
(*End the Fight*)


endTheFightWeakChoices = {
	choice["harm", p["It\[CloseCurlyQuote]s worse than you thought: ", i["Endure Harm"], "."]],
	choice["stress", p["You are overcome: ", i["Endure Stress"], "."]],
	choice["danger", p["Your victory is short\[Dash]lived: A new danger or foe appears, or an existing danger worsens."]],
	choice["collateral", p["You suffer collateral damage: Something of value is lost or broken, or someone important must pay the cost."]],
	choice["objective", p["You\[CloseCurlyQuote]ll pay for it: An objective falls out of reach."]],
	choice["vengeance", p["Others won\[CloseCurlyQuote]t forget: You are marked for vengeance."]]
};


moves["endTheFight"] = move[
	"End the Fight",
	paras[
		p[b["When you take decisive action to resolve the outcome of this fight,"], " roll the challenge dice and compare to your progress. Momentum is ignored on this roll."],
		p["If you do not have initiative, count a strong hit as a weak hit, and a weak hit as a miss."]
	],
	paras[
		p["This foe is no longer in the fight. They are killed, taken out of action, driven off, or forced to surrender as appropriate to the situation and your intent (", i["Ask the Oracle"], " if unsure)."]
	],
	choiceSection[
		{p["As above, but you must also choose one."]},
		endTheFightWeakChoices
	],
	paras[
		p["You have lost this fight. ", i["Pay the Price"], "."]
	]
];


(* ::Subsection::Closed:: *)
(*Suffer moves*)


(* ::Subsubsection::Closed:: *)
(*Endure Harm*)


endureHarmStrongChoices = {
	choice["shake", p["Shake it off: If your health is greater than 0, suffer \[Dash]1 momentum in exchange for +1 health."]],
	choice["embrace", p["Embrace the pain: Take +1 momentum."]]
};


moves["endureHarm"] = move[
	"Endure Harm",
	paras[
		p[b["When you face physical damage,"], " suffer \[Dash]health equal to your foe\[CloseCurlyQuote]s rank or as appropriate to the situation. If your health is 0, suffer \[Dash]momentum equal to any remaining \[Dash]health. Then, roll +health or +iron, whichever is higher."]
	],
	choiceSection[
		{p["Choose one."]},
		endureHarmStrongChoices
	],
	paras[
		p["You press on."]
	],
	paras[
		p["Also suffer \[Dash]1 momentum. If you are at 0 health, you must mark wounded or maimed (if currently unmarked) or roll on the Harm Outcome table."]
	]
];


(* ::Subsubsection::Closed:: *)
(*Face Death*)


faceDeathWeakChoices = {
	choice["sacrifice", p["You die, but not before making a noble sacrifice. Envision your final moments."]],
	choice["quest", p["Death desires something of you in exchange for your life. Envision what it wants (", i["Ask the Oracle"], " if unsure), and ", i["Swear an Iron Vow"], " (formidable or extreme) to complete that quest. If you fail to score a hit when you ", i["Swear an Iron Vow"], ", or refuse the quest, you are dead. Otherwise, you return to the mortal world and are now cursed. You may only clear the cursed debility by completing the quest."]]
};


moves["faceDeath"] = move[
	"Face Death",
	paras[
		p[b["When you are brought to the brink of death, and glimpse the world beyond,"], " roll +heart."]
	],
	paras[
		p["Death rejects you. You are cast back into the mortal world."]
	],
	choiceSection[
		{p["Choose one."]},
		faceDeathWeakChoices
	],
	paras[
		p["You are dead."]
	]
];


(* ::Subsubsection::Closed:: *)
(*Companion Endure Harm*)


moves["companionEndureHarm"] = move[
	"Companion Endure Harm",
	paras[
		p[b["When your companion faces physical damage,"], " they suffer \[Dash]health equal to the amount of harm inflicted. If your companion\[CloseCurlyQuote]s health is 0, exchange any leftover \[Dash]health for \[Dash]momentum."],
		p["Then, roll +heart or +your companion\[CloseCurlyQuote]s health, whichever is higher."]
	],
	paras[
		p["Your companion rallies. Give them +1 health."]
	],
	paras[
		p["Your companion is battered. If their health is 0, they cannot assist you until they gain at least +1 health."]
	],
	paras[
		p["Also suffer \[Dash]1 momentum. If your companion\[CloseCurlyQuote]s health is 0, they are gravely wounded and out of action. Without aid, they die in an hour or two."],
		p["If you roll a miss with a 1 on your action die, and your companion\[CloseCurlyQuote]s health is 0, they are now dead. Take 1 experience for each marked ability on your companion asset, and remove it."]
	]
];


(* ::Subsubsection::Closed:: *)
(*Endure Stress*)


endureStressStrongChoices = {
	choice["shake", p["Shake it off: If your spirit is greater than 0, suffer \[Dash]1 momentum in exchange for +1 spirit."]],
	choice["embrace", p["Embrace the darkness: Take +1 momentum."]]
};


moves["endureStress"] = move[
	"Endure Stress",
	paras[
		p[b["When you face mental shock or despair,"], " suffer \[Dash]spirit equal to your foe\[CloseCurlyQuote]s rank or as appropriate to the situation. If your spirit is 0, suffer \[Dash]momentum equal to any remaining \[Dash]spirit. Then, roll +spirit or +heart, whichever is higher."]
	],
	choiceSection[
		{p["Choose one."]},
		endureStressStrongChoices
	],
	paras[
		p["You press on."]
	],
	paras[
		p["Also suffer \[Dash]1 momentum. If you are at 0 spirit, you must mark shaken or corrupted (if currently unmarked) or roll on the Stress Outcome table."]
	]
];


(* ::Subsubsection::Closed:: *)
(*Face Desolation*)


faceDesolationWeakChoices = {
	choice["sacrifice", p["Your spirit or sanity breaks, but not before you make a noble sacrifice. Envision your final moments."]],
	choice["vision", p["You see a vision of a dreaded event coming to pass. Envision that dark future (", i["Ask the Oracle"], " if unsure), and ", i["Swear an Iron Vow"], " (formidable or extreme) to prevent it. If you fail to score a hit when you ", i["Swear an Iron Vow"], ", or refuse the quest, you are lost. Otherwise, you return to your senses and are now tormented. You may only clear the tormented debility by completing the quest."]]
};


moves["faceDesolation"] = move[
	"Face Desolation",
	paras[
		p[b["When you are brought to the brink of desolation,"], " roll +heart."]
	],
	paras[
		p["You resist and press on."]
	],
	choiceSection[
		{p["Choose one."]},
		faceDesolationWeakChoices
	],
	paras[
		p["You succumb to despair or horror and are lost."]
	]
];


(* ::Subsubsection::Closed:: *)
(*Out of Supply*)


moves["outOfSupply"] = Association[];
moves["outOfSupply", "name"] = "Out of Supply";
moves["outOfSupply", "header"] = paras[
	p[b["When your supply is exhausted (reduced to 0),"], " mark unprepared. If you suffer additional \[Dash]supply while unprepared, you must exchange each additional \[Dash]supply for any combination of \[Dash]health, \[Dash]spirit, or \[Dash]momentum as appropriate to the circumstances."]
];


(* ::Subsubsection::Closed:: *)
(*Face a Setback*)


faceSetbackChoices = {
	choice["exchange", p["Exchange each additional \[Dash]momentum for any combination of \[Dash]health, \[Dash]spirit, or \[Dash]supply as appropriate to the circumstances."]],
	choice["undermineProgress", p["Envision an event or discovery (", i["Ask the Oracle"], " if unsure) which undermines your progress in a current quest, journey, or fight. Then, for each additional \[Dash]momentum, clear 1 unit of progress on that track per its rank (troublesome=clear 3 progress; dangerous=clear 2 progress; formidable=clear 1 progress; extreme=clear 2 ticks; epic=clear 1 tick)."]]
};


moves["faceASetback"] = Association[];
moves["faceASetback", "name"] = "Face a Setback";
moves["faceASetback", "header"] = choiceSection[
	{p[b["When your momentum is at its minimum (\[Dash]6), and you suffer additional \[Dash]momentum,"], " choose one."]},
	faceSetbackChoices
];


(* ::Subsection::Closed:: *)
(*Delve moves*)


(* ::Subsubsection::Closed:: *)
(*Discover a Site*)


siteRankChoices = {
	choice["troublesome", p["Troublesome site: 3 progress per area."]],
	choice["dangerous", p["Dangerous site: 2 progress per area."]],
	choice["formidable", p["Formidable site: 1 progress per area."]],
	choice["extreme", p["Extreme site: 2 ticks per area."]],
	choice["epic", p["Epic site: 1 tick per area."]]
};


moves["discoverASite"] = Association[];
moves["discoverASite", "name"] = "Discover a Site";
moves["discoverASite", "header"] = choiceSection[
	{p[b["When you resolve to enter a perilous site in pursuit of an objective,"], " choose the theme and domain which best represent its nature, and give it a rank."]},
	siteRankChoices,
	{
		p["If you are returning to a previously explored site, roll both challenge dice, take the lowest value, and clear that number of progress boxes."],
		p["Then, ", i["Delve the Depths"], " to explore this place."]
	}
];


(* ::Subsubsection::Closed:: *)
(*Delve the Depths*)


moves["delveTheDepths"] = move[
	"Delve the Depths",
	paras[
		p[b["When you traverse an area within a perilous site,"], " envision your surroundings (", i["Ask the Oracle"], " if unsure). Then, consider your approach. If you navigate this area\[Ellipsis]"],
		p["\:2734 With haste: Roll +edge."],
		p["\:2734 With stealth or trickery: Roll +shadow."],
		p["\:2734 With observation, intuition, or expertise: Roll +wits."]
	],
	paras[
		p["You delve deeper. Mark progress and ", i["Find an Opportunity"], "."]
	],
	paras[
		p["Roll on the Delve the Depths Weak Hit table according to your stat."]
	],
	paras[
		p[i["Reveal a Danger"], "."]
	]
];


(* ::Subsubsection::Closed:: *)
(*Find an Opportunity*)


findOpportunityChoices = {
	choice["insight", p["Gain insight or prepare: Take +1 momentum."]],
	choice["action", p["Take action now: You and any allies may make a move (not a progress move) which directly leverages the opportunity. When you do, add +1 and take +1 momentum on a hit."]]
};


moves["findAnOpportunity"] = Association[];
moves["findAnOpportunity", "name"] = "Find an Opportunity";
moves["findAnOpportunity", "header"] = choiceSection[
	{
		p[b["When you encounter a helpful situation or feature within a site,"], " roll on the Find an Opportunity table."],
		p["If you are making this move as a result of a strong hit on ", i["Delve the Depths"], ", you may pick or envision an opportunity instead of rolling. Then, choose one."]
	},
	findOpportunityChoices
];


(* ::Subsubsection::Closed:: *)
(*Reveal a Danger*)


moves["revealADanger"] = Association[];
moves["revealADanger", "name"] = "Reveal a Danger";
moves["revealADanger", "header"] = paras[
	p[b["When you encounter a risky situation within a site,"], " envision the danger or roll on the Reveal a Danger table."]
];


(* ::Subsubsection::Closed:: *)
(*Locate Your Objective*)


moves["locateYourObjective"] = move[
	"Locate Your Objective",
	paras[
		p[b["When your exploration of a site comes to an end,"], " roll the challenge dice and compare to your progress. Momentum is ignored on this roll."]
	],
	choiceSection[
		{p["You locate your objective and the situation favors you. Choose one."]},
		destinationFavorChoices
	],
	paras[
		p["You locate your objective but face an unforeseen hazard or complication. Envision what you find (", i["Ask the Oracle"], " if unsure)."]
	],
	paras[
		p["Your objective falls out of reach, you have been misled about the nature of your objective, or you discover that this site holds unexpected depths. If you continue your exploration, clear all but one filled progress and raise the site\[CloseCurlyQuote]s rank by one (if not already epic)."]
	]
];


(* ::Subsubsection::Closed:: *)
(*Escape the Depths*)


escapeDepthsWeakChoices = {
	choice["harm", p["You are weary or wounded: ", i["Endure Harm"], "."]],
	choice["stress", p["The experience leaves you shaken: ", i["Endure Stress"], "."]],
	choice["delay", p["You are delayed, and it costs you."]],
	choice["leftBehind", p["You leave behind something important."]],
	choice["complication", p["You face a new complication as you emerge from the depths."]],
	choice["revenge", p["A denizen plots their revenge."]]
};


moves["escapeTheDepths"] = move[
	"Escape the Depths",
	paras[
		p[b["When you flee or withdraw from a site,"], " consider the situation and your approach. If you\[Ellipsis]"],
		p["\:2734 Find the fastest way out: Roll +edge."],
		p["\:2734 Steel yourself against the horrors of this place: Roll +heart."],
		p["\:2734 Fight your way out: Roll +iron."],
		p["\:2734 Retrace your steps or locate an alternate path: Roll +wits."],
		p["\:2734 Keep out of sight: Roll +shadow."]
	],
	paras[
		p["You make your way safely out of the site. Take +1 momentum."]
	],
	choiceSection[
		{p["You find your way out, but this place exacts its price. Choose one."]},
		escapeDepthsWeakChoices
	],
	paras[
		p["A dire threat or imposing obstacle stands in your way. ", i["Reveal a Danger"], ". If you survive, you may make your escape."]
	]
];


(* ::Subsection::Closed:: *)
(*Failure moves*)


(* ::Subsubsection::Closed:: *)
(*Mark Your Failure*)


moves["markYourFailure"] = Association[];
moves["markYourFailure", "name"] = "Mark Your Failure";
moves["markYourFailure", "header"] = paras[
	p[b["When you make a move and score a miss,"], " mark a tick on your failure track. ", b["When you score a miss when making a progress move,"], " mark two ticks."]
];


(* ::Subsubsection::Closed:: *)
(*Learn from Your Failures*)


learnFailuresStrongChoices = {
	choice["adjust", p["Adjust your approach: Discard a single asset, and take 2 experience for each marked ability."]],
	choice["oath", p["Make an oath: ", i["Swear an Iron Vow"], ", and reroll any dice."]],
	choice["ready", p["Ready your next steps: Take +3 momentum."]]
};


moves["learnFromYourFailures"] = move[
	"Learn from Your Failures",
	paras[
		p[b["When you spend time reflecting on your hardships and missteps,"], " and your failure track is 6 or greater, roll your challenge dice and compare to your progress. Momentum is ignored on this roll."]
	],
	choiceSection[
		{p["You commit to making a dramatic change. Take 3 experience and clear all progress. Then, choose one."]},
		learnFailuresStrongChoices
	],
	paras[
		p["You learn from your mistakes. Take 2 experience and clear all progress."]
	],
	paras[
		p["You learned the wrong lessons. Take 1 experience and clear all progress. Then, envision how you set off on an ill\[Dash]fated path."]
	]
];


(* ::Subsection::Closed:: *)
(*Threat moves*)


(* ::Subsubsection::Closed:: *)
(*Advance a Threat*)


moves["advanceAThreat"] = Association[];
moves["advanceAThreat", "name"] = "Advance a Threat";
moves["advanceAThreat", "header"] = paras[
	p[b["When you give ground to a threat through inaction, failure, or delay,"], " roll on the Threat Action table and envision how the change manifests in your world (", i["Ask the Oracle"], " if unsure)."],
	p[b["On a match,"], " this development also exposes a surprising aspect of the threat\[CloseCurlyQuote]s plan or nature."],
	p[b["If you mark the last box on the threat\[CloseCurlyQuote]s menace track,"], " the threat achieves its goal, or the final dire outcome occurs. You must ", i["Forsake Your Vow"], "."]
];


(* ::Subsubsection::Closed:: *)
(*Take a Hiatus*)


moves["takeAHiatus"] = Association[];
moves["takeAHiatus", "name"] = "Take a Hiatus";
moves["takeAHiatus", "header"] = paras[
	p[b["When you spend an extended time recovering in a safe place while a threat is active,"], " do any of the following."],
	p["\:2734 Clear any marked conditions."],
	p["\:2734 Set your health, spirit, supply, and companion health to their maximum values."],
	p["\:2734 Set your momentum to its reset value."],
	p["Then, for each active threat, ", i["Advance a Threat"], "."]
];


(* ::Subsection::Closed:: *)
(*Rarity moves*)


(* ::Subsubsection::Closed:: *)
(*Gain a Rarity*)


moves["gainARarity"] = Association[];
moves["gainARarity", "name"] = "Gain a Rarity";
moves["gainARarity", "header"] = paras[
	p[b["When you take possession of an object of power,"], " you may spend 3 experience to link the object to one of your assets (path, combat talent, or ritual). If you do, that asset and any marked abilities are augmented."],
	p["Give the augmented asset a special mark, and make note of the name and nature of the rarity."]
];


(* ::Subsubsection::Closed:: *)
(*Wield a Rarity*)


moves["wieldARarity"] = Association[];
moves["wieldARarity", "name"] = "Wield a Rarity";
moves["wieldARarity", "header"] = paras[
	p[b["When you make a move aided by an augmented asset," "check your action die."]],
	p[b["On any result with a 6,"], " the power of the rarity manifests in a dramatic and obvious way. You score an automatic strong hit and take +1 momentum."],
	p[b["On a hit with a 5,"], " the power of the rarity manifests in a subtle way. Take +1 momentum."],
	p[b["On a miss with a 1,"], " the rarity\[CloseCurlyQuote]s power fails or works against you."]
];


(* ::Subsection::Closed:: *)
(*Private context footer*)


End[];


(* ::Section::Closed:: *)
(*Package footer*)


EndPackage[];
