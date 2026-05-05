(* ::Package:: *)

(* ::Title:: *)
(*Asset Data*)


(* ::Chapter:: *)
(*Code*)


(* ::Section::Closed:: *)
(*Package header*)


If[
	!MemberQ[$Packages, "IronLibrary`TextHelpers`"],
	With[
		{dir = If[StringQ[$InputFileName] && $InputFileName =!= "", DirectoryName[$InputFileName], Directory[]]},
		Get[FileNameJoin[{dir, "TextHelpers.wl"}]]
	]
];

BeginPackage["AssetData`", {"IronLibrary`TextHelpers`"}];


(* ::Section::Closed:: *)
(*Public symbols*)


assetData::usage = "Association of Ironsworn asset card data.";


(* ::Section:: *)
(*Implementation details*)


(* ::Subsection::Closed:: *)
(*Private context header*)


Begin["`Private`"];


(* ::Subsection::Closed:: *)
(*Asset constructors*)


assetField[key_String, label_String, type_String, extra_Association : <||>] :=
	Join[
		<|
			"Key" -> key,
			"Label" -> label,
			"Type" -> type
		|>,
		extra
	];

fieldSelector[field_String, options_List] := <|
	"Type" -> "FieldSelector",
	"Field" -> field,
	"Options" -> options
|>;

fieldSelectorOption[value_String, label_String] := <|
	"Value" -> value,
	"Label" -> label
|>;

fieldSelectorChoiceSection[pre_List, choices_List, field_String] :=
	Join[
		choiceSection[pre, choices, {}],
		<|
			"ChoiceDisplay" -> "FieldSelector",
			"ChoiceField" -> field
		|>
	];

assetTrack[key_String, label_String, min_Integer, max_Integer, default_Integer] := <|
	"Key" -> key,
	"Label" -> label,
	"Min" -> min,
	"Max" -> max,
	"Default" -> default
|>;

assetAbility[index_Integer, name_String, text_, defaultSelected_:False, fields_Association:<||>] := <|
	"Index" -> index,
	"Name" -> name,
	"Text" -> text,
	"DefaultSelected" -> defaultSelected,
	"Fields" -> fields
|>;

assetRecord[name_String, category_String, requirement_, fields_Association, abilities_List, defaultAbilities_List, tracks_Association, sourcePage_Integer] := <|
	"Name" -> name,
	"Category" -> category,
	"Requirement" -> requirement,
	"Fields" -> fields,
	"Abilities" -> abilities,
	"DefaultAbilities" -> defaultAbilities,
	"Tracks" -> tracks,
	"SourcePage" -> sourcePage
|>;


(* ::Subsection:: *)
(*Asset association*)


assetData = Association[];


(* ::Subsection::Closed:: *)
(*Companion assets*)


assetData["Cave Lion"] = assetRecord[
	"Cave Lion",
	"Companion",
	p["Your cat takes down its prey."],
	<|
		"Name" -> assetField["name", "Name", "text"]
	|>,
	{
		assetAbility[1, "Eager", p["When your cat chases down big game, you may ", i["Resupply"], " with +edge (instead of +wits). If you do, take +1 supply or +1 momentum on a strong hit."]],
		assetAbility[2, "Inescapable", p["When you ", i["Enter the Fray"], " or ", i["Strike"], " by sending your cat to attack, roll +edge. On a hit, take +2 momentum."]],
		assetAbility[3, "Protective", p["When you ", i["Make Camp"], ",", " your cat is alert to trouble. If you or an ally choose to relax, take +1 spirit. If you focus, take +1 momentum."]]
	},
	{},
	<|
		"health" -> assetTrack["health", "Health", 0, 4, 4]
	|>,
	2
];

assetData["Giant Spider"] = assetRecord[
	"Giant Spider",
	"Companion",
	p["Your spider uncovers secrets."],
	<|
		"Name" -> assetField["name", "Name", "text"]
	|>,
	{
		assetAbility[1, "Discreet", p["When you ", i["Secure an Advantage"], " by sending your spider to scout a place, add +1 and take +1 momentum on a hit."]],
		assetAbility[2, "Soul-Piercing", p["You may ", i["Face Danger"], " +shadow by sending your spider to secretly study someone. On a hit, the spider returns to reveal the target\[CloseCurlyQuote]s deepest fears through a reflection in its glassy eyes. Use this to ", i["Gather Information"], " and reroll any dice."]],
		assetAbility[3, "Ensnaring", p["When your spider sets a trap, add +1 as you ", i["Enter the Fray"], " +shadow. On a strong hit, also inflict 2 harm."]]
	},
	{},
	<|
		"health" -> assetTrack["health", "Health", 0, 4, 4]
	|>,
	2
];

assetData["Hawk"] = assetRecord[
	"Hawk",
	"Companion",
	p["Your hawk can aid you while it is aloft."],
	<|
		"Name" -> assetField["name", "Name", "text"]
	|>,
	{
		assetAbility[1, "Far-seeing", p["When you ", i["Undertake a Journey"], ",", " or when you ", i["Resupply"], " by hunting for small game, add +1."]],
		assetAbility[2, "Fierce", p["When you ", i["Secure an Advantage"], " +edge using your hawk to harass and distract your foes, add +1 and take +1 momentum on a hit."]],
		assetAbility[3, "Vigilant", p["When you ", i["Face Danger"], " +wits to detect an approaching threat, or when you ", i["Enter the Fray"], " +wits against an ambush, add +2."]]
	},
	{},
	<|
		"health" -> assetTrack["health", "Health", 0, 3, 3]
	|>,
	2
];

assetData["Horse"] = assetRecord[
	"Horse",
	"Companion",
	p["You and your horse ride as one."],
	<|
		"Name" -> assetField["name", "Name", "text"]
	|>,
	{
		assetAbility[1, "Swift", p["When you ", i["Face Danger"], " +edge using your horse\[CloseCurlyQuote]s speed and grace, or when you ", i["Undertake a Journey"], ",", " add +1."]],
		assetAbility[2, "Fearless", p["When you ", i["Enter the Fray"], " or ", i["Secure an Advantage"], " +heart by charging into combat, add +1 and take +1 momentum on a hit."]],
		assetAbility[3, "Mighty", p["When you ", i["Strike"], " or ", i["Clash"], " at close range while mounted, add +1 and inflict +1 harm on a hit."]]
	},
	{},
	<|
		"health" -> assetTrack["health", "Health", 0, 5, 5]
	|>,
	2
];

assetData["Hound"] = assetRecord[
	"Hound",
	"Companion",
	p["Your hound is your steadfast companion."],
	<|
		"Name" -> assetField["name", "Name", "text"]
	|>,
	{
		assetAbility[1, "Sharp", p["When you ", i["Gather Information"], " using your hound\[CloseCurlyQuote]s keen senses to track your quarry or investigate a scene, add +1 and take +1 momentum on a hit."]],
		assetAbility[2, "Ferocious", p["When you ", i["Strike"], " or ", i["Clash"], " alongside your hound and score a hit, inflict +1 harm or take +1 momentum."]],
		assetAbility[3, "Loyal", p["When you ", i["Endure Stress"], " in the company of your hound, add +1."]]
	},
	{},
	<|
		"health" -> assetTrack["health", "Health", 0, 4, 4]
	|>,
	2
];

assetData["Kindred"] = assetRecord[
	"Kindred",
	"Companion",
	p["Your friend stands by you."],
	<|
		"Name" -> assetField["name", "Name", "text"],
		"Expertise" -> assetField["expertise", "Expertise", "text"]
	|>,
	{
		assetAbility[
			1,
			"Skilled",
			p["When you make a move outside of combat aided by your companion\[CloseCurlyQuote]s expertise, add +1."],
			False,
			<|
			"Expertise" -> assetField["expertise", "Expertise", "text"]
		|>
		],
		assetAbility[2, "Shield-Kin", p["When you ", i["Clash"], " or ", i["Battle"], " alongside your companion, or when you ", i["Face Danger"], " against an attack by standing together, add +1."]],
		assetAbility[3, "Bonded", p["Once you mark a bond with your companion, add +1 when you ", i["Face Desolation"], " in their presence."]]
	},
	{},
	<|
		"health" -> assetTrack["health", "Health", 0, 4, 4]
	|>,
	2
];

assetData["Mammoth"] = assetRecord[
	"Mammoth",
	"Companion",
	p["Your mammoth walks a resolute path."],
	<|
		"Name" -> assetField["name", "Name", "text"]
	|>,
	{
		assetAbility[1, "Lumbering", p["When your mammoth travels with you as you ", i["Undertake a Journey"], ",", " you may add +2 but suffer -1 momentum (decide before rolling)."]],
		assetAbility[2, "Beast of burden", p["When you make a move which requires you to roll +supply, you may instead roll +your mammoth\[CloseCurlyQuote]s health."]],
		assetAbility[3, "Overpowering", p["When you ", i["Strike"], " or ", i["Clash"], " by riding your mammoth against a pack of foes, add +1 and inflict +1 harm on a hit."]]
	},
	{},
	<|
		"health" -> assetTrack["health", "Health", 0, 5, 5]
	|>,
	2
];

assetData["Owl"] = assetRecord[
	"Owl",
	"Companion",
	p["Your owl soars through the darkness."],
	<|
		"Name" -> assetField["name", "Name", "text"]
	|>,
	{
		assetAbility[1, "Nocturnal", p["If you ", i["Resupply"], " at night by sending your owl to hunt, take +2 momentum on a hit. When you ", i["Enter the Fray"], " +wits against an ambush in darkness, add +1 and take +1 momentum on a hit."]],
		assetAbility[2, "Sage", p["When you leverage your owl\[CloseCurlyQuote]s secret knowledge to perform a ritual, add +1 or take +1 momentum on a hit (decide before rolling)."]],
		assetAbility[3, "Embodying", p["When you ", i["Face Death"], ",", " take your owl\[CloseCurlyQuote]s health as +momentum before you roll."]]
	},
	{},
	<|
		"health" -> assetTrack["health", "Health", 0, 3, 3]
	|>,
	2
];

assetData["Raven"] = assetRecord[
	"Raven",
	"Companion",
	p["Your raven heeds your call."],
	<|
		"Name" -> assetField["name", "Name", "text"]
	|>,
	{
		assetAbility[1, "Sly", p["When you ", i["Secure an Advantage"], " or ", i["Face Danger"], " +shadow using your raven to perform trickery (such as creating a distraction or stealing a small object) add +1 and take +1 momentum on a hit."]],
		assetAbility[2, "Knowing", p["When you ", i["Face Death"], ",", " add +2 and take +1 momentum on a hit."]],
		assetAbility[3, "Diligent", p["When your raven carries messages for you, you may ", i["Secure an Advantage"], ",", " ", i["Gather Information"], ",", " or ", i["Compel"], " from a distance."]]
	},
	{},
	<|
		"health" -> assetTrack["health", "Health", 0, 2, 2]
	|>,
	2
];

assetData["Young Wyvern"] = assetRecord[
	"Young Wyvern",
	"Companion",
	p["Your wyvern won\[CloseCurlyQuote]t devour you. For now."],
	<|
		"Name" -> assetField["name", "Name", "text"]
	|>,
	{
		assetAbility[1, "Insatiable", p["When you ", i["Undertake a Journey"], " and score a hit, you may suffer -1 supply in exchange for +2 momentum."]],
		assetAbility[2, "Indomitable", p["When you make the ", i["Companion Endure Harm"], " move for your wyvern, add +2 and take +1 momentum on a hit."]],
		assetAbility[3, "Savage", p["When you ", i["Strike"], " by commanding your wyvern to attack, roll +heart. Your wyvern inflicts 3 harm on a hit."]]
	},
	{},
	<|
		"health" -> assetTrack["health", "Health", 0, 5, 5]
	|>,
	4
];



(* ::Subsection::Closed:: *)
(*Path assets*)


assetData["Alchemist"] = assetRecord[
	"Alchemist",
	"Path",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you create an elixir, choose an effect: Deftness (edge), audacity (heart), vigor (iron), slyness (shadow), or clarity (wits). Then, suffer -1 supply and roll +wits. On a strong hit, you create a single dose. The character who consumes the elixir must ", i["Face Danger"], " +iron and score a hit, after which they add +1 when making moves with the related stat until their health, spirit, or momentum fall below +1. On a weak hit, as above, but suffer an additional -1 supply to create it."],
			True
		],
		assetAbility[2, "", p["As above, and you may choose two effects for a single dose, or create two doses of the same effect."]],
		assetAbility[3, "", p["When you prepare an elixir, add +1 and take +1 momentum on a hit."]]
	},
	{
		1
	},
	<||>,
	4
];

assetData["Animal Kin"] = assetRecord[
	"Animal Kin",
	"Path",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you make a move to pacify, calm, control, aid, or fend off an animal (or an animal or beast companion), add +1 and take +1 momentum on a hit."],
			True
		],
		assetAbility[2, "", p["You may add or upgrade an animal or beast companion asset for 1 fewer experience. Once you mark all their abilities, you may ", i["Forge a Bond"], " with them and take an automatic strong hit. When you do, mark a bond twice and take 1 experience."]],
		assetAbility[3, "", p["Once per fight, when you leverage your animal or beast companion to make a move, reroll any dice. On a hit, take +1 momentum."]]
	},
	{
		1
	},
	<||>,
	4
];

assetData["Banner-sworn"] = assetRecord[
	"Banner-sworn",
	"Path",
	p["Once you mark a bond with a leader or faction..."],
	<|
		"Name" -> assetField["name", "Name", "text"]
	|>,
	{
		assetAbility[
			1,
			"",
			p["When you ", i["Swear an Iron Vow"], " to serve your leader or faction on a mission, you may reroll any dice. When you ", i["Fulfill Your Vow"], " and mark experience, take +1 experience."],
			True
		],
		assetAbility[2, "", p["When you ", i["Sojourn"], " or ", i["Make Camp"], " in the company of your banner-kin, add +1 and take +1 momentum on a hit."]],
		assetAbility[3, "", p["When you ", i["Enter the Fray"], " bearing your banner, add +1 and take +1 momentum on a hit. When you burn momentum while carrying your banner in combat, take +1 momentum after you reset."]]
	},
	{
		1
	},
	<||>,
	4
];

assetData["Battle-scarred"] = assetRecord[
	"Battle-scarred",
	"Path",
	p["Once you become maimed..."],
	<||>,
	{
		assetAbility[1, "", p["You focus your energies: Reduce your edge or iron by 1 and add +2 to wits or heart, or +1 to each (to a maximum of +4)."]],
		assetAbility[2, "", p["You overcome your limitations: Reduce your maximum health by 1. Maimed no longer counts as a debility, and does not reduce your maximum momentum or reset value. When you ", i["Endure Stress"], " +heart, take +1 momentum on a strong hit."]],
		assetAbility[3, "", p["You have stared down death before: When you are at 0 health and ", i["Endure Harm"], ",", " you may roll +wits or +heart (instead of +health or +iron). If you do, take +1 momentum on a hit."]]
	},
	{},
	<||>,
	4
];

assetData["Blade-bound"] = assetRecord[
	"Blade-bound",
	"Path",
	p["Once you mark a bond with a kin-blade, a sentient weapon imbued with the spirit of your ancestor..."],
	<|
		"Name" -> assetField["name", "Name", "text"]
	|>,
	{
		assetAbility[1, "", p["When you ", i["Enter the Fray"], " or ", i["Draw the Circle"], " while wielding your kin-blade, add +1 and take +1 momentum on a hit."]],
		assetAbility[2, "", p["When you ", i["Gather Information"], " by listening to the whispers of your kin-blade, add +1 and take +2 momentum on a hit. Then, ", i["Endure Stress"], " (2 stress)."]],
		assetAbility[3, "", p["When you ", i["Strike"], " with your kin-blade to inflict savage harm (decide before rolling), add +1 and inflict +2 harm on a hit. Then, ", i["Endure Stress"], " (2 stress)."]]
	},
	{},
	<||>,
	4
];

assetData["Bonded"] = assetRecord[
	"Bonded",
	"Path",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you make a move which gives you an add for sharing a bond, add +1 more."],
			True
		],
		assetAbility[2, "", p["When you completely fill a box on your bonds progress track, envision what your relationships have taught you. Then, take 1 experience and +2 momentum."]],
		assetAbility[3, "", p["When you make a move in a crucial moment and score a miss, you may cling to thoughts of your bond-kin for courage or encouragement. If you do, reroll any dice. On another miss, in addition to the outcome of the move, you must mark shaken or corrupted. If both debilities are already marked, ", i["Face Desolation"], "."]]
	},
	{
		1
	},
	<||>,
	4
];

assetData["Commander"] = assetRecord[
	"Commander",
	"Path",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["You lead a warband with +4 strength. Roll +strength when you command your warband to ", i["Face Danger"], ",", " ", i["Secure an Advantage"], ",", " ", i["Compel"], ",", " or ", i["Battle"], ".", " When you face the negative outcome of any move, you may suffer -1 strength as the cost. When you ", i["Make Camp"], " or ", i["Sojourn"], " and score a hit, take +1 strength. While at 0 strength, this asset counts as a debility."],
			True
		],
		assetAbility[2, "", p["You may dispatch scouts from your warband to ", i["Gather Information"], " or ", i["Resupply"], ";", " if you do, roll +strength."]],
		assetAbility[3, "", p["Once you ", i["Forge a Bond"], " with your warband, take +1 momentum on a hit when you leverage a warband ability."]]
	},
	{
		1
	},
	<|
		"strength" -> assetTrack["strength", "Strength", 0, 4, 4]
	|>,
	4
];

assetData["Dancer"] = assetRecord[
	"Dancer",
	"Path",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you ", i["Secure an Advantage"], " +edge by dancing for an audience, add +1 and take +2 momentum on a hit. On a strong hit, also add +2 (one time only) if you make a move to interact with someone in the audience."],
			True
		],
		assetAbility[2, "", p["When you ", i["Face Danger"], " +edge in a fight by nimbly avoiding your foe\[CloseCurlyQuote]s attacks, add +1 and take +1 momentum on a hit."]],
		assetAbility[3, "", p["When you or an ally make a progress move and score a hit, you may perform a dance to commemorate the event. If you do, roll +edge. On a strong hit, you and each of your allies take +2 momentum and +1 spirit. On a weak hit, you take +1 momentum or +1 spirit, but your allies are unmoved."]]
	},
	{
		1
	},
	<||>,
	4
];

assetData["Devotant"] = assetRecord[
	"Devotant",
	"Path",
	None,
	<|
		"God's Name" -> assetField["gods_name", "God's Name", "text"],
		"Stat" -> assetField["stat", "Stat", "select_value"]
	|>,
	{
		assetAbility[
			1,
			"",
			p["When you say your daily prayers, you may ", i["Secure an Advantage"], " by asking your god to grant a blessing. If you do, roll +your god\[CloseCurlyQuote]s stat. On a hit, take +2 momentum."],
			True
		],
		assetAbility[2, "", p["When you ", i["Swear an Iron Vow"], " to serve your god on a divine quest, you may roll +your god\[CloseCurlyQuote]s stat and reroll any dice. When you ", i["Fulfill Your Vow"], " and mark experience, take +1 experience."]],
		assetAbility[3, "", p["When you ", i["Sojourn"], " by sharing the word of your god, you may roll +your god\[CloseCurlyQuote]s stat. If you do, take +1 momentum on a hit."]]
	},
	{
		1
	},
	<||>,
	6
];

assetData["Empowered"] = assetRecord[
	"Empowered",
	"Path",
	None,
	<|
		"Title/Lineage" -> assetField["title_lineage", "Title/Lineage", "text"]
	|>,
	{
		assetAbility[
			1,
			"",
			p["When you ", i["Sojourn"], " and score a weak hit or miss, you may claim the rights of hospitality warranted by your title or lineage. If you do, roll all dice again and add +1. On a miss, you are refused, and your presumption causes significant new trouble."],
			True
		],
		assetAbility[2, "", p["When you exert your title or lineage to ", i["Compel"], ",", " add +1 and take +1 momentum on a hit."]],
		assetAbility[3, "", p["When you forgo your title or lineage and ", i["Forge a Bond"], " as an equal, or when you ", i["Swear an Iron Vow"], " to serve someone of a lower station, add +1 and take +1 momentum or +1 spirit on a hit."]]
	},
	{
		1
	},
	<||>,
	6
];

assetData["Fated"] = assetRecord[
	"Fated",
	"Path",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you ", i["Face Death"], " or ", i["Face Desolation"], " while your epic background vow is unfulfilled, it is not yet your time. Instead of rolling, you may take an automatic strong hit. If you do, this asset counts as a debility (and you no longer have this protection) until you next ", i["Reach a Milestone"], " on the background vow."],
			True
		],
		assetAbility[2, "", p["When you ", i["Reach a Milestone"], " on your background vow, take +2 momentum or +1 spirit."]],
		assetAbility[3, "", p["For every two boxes filled on your background vow progress track, take 1 experience. When you ", i["Fulfill Your Vow"], ",", " your fate is at hand. Envision your final sacrifice and reroll any dice."]]
	},
	{
		1
	},
	<||>,
	6
];

assetData["Fortune Hunter"] = assetRecord[
	"Fortune Hunter",
	"Path",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you ", i["Swear an Iron Vow"], " to someone under the promise of payment, add +1 and give the quest a special mark. When you successfully ", i["Fulfill Your Vow"], " to them, take +wealth equal to the rank of the quest. If you leverage wealth when making a move where resources are a factor, add +wealth and suffer -1 wealth."],
			True
		],
		assetAbility[2, "", p["When in a community or trading, you may suffer -1 wealth and take +2 supply."]],
		assetAbility[3, "", p["When you ", i["Resupply"], " by scavenging or looting, and score a strong hit with a match, you may envision finding an object of value. If you do, take +1 supply (instead of +2) and +1 wealth."]]
	},
	{
		1
	},
	<|
		"wealth" -> assetTrack["wealth", "Wealth", 0, 5, 0]
	|>,
	6
];

assetData["Herbalist"] = assetRecord[
	"Herbalist",
	"Path",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			choiceSection[
			{p["When you attempt to ", i["Heal"], " using herbal remedies, and you have at least +1 supply, choose one (decide before rolling)."]},
			{
				choice["add-2", p["Add +2."]],
				choice["on-a-hit-take-or-give-an-additional-1-health", p["On a hit, take or give an additional +1 health."]]
			},
			{}
		],
			True
		],
		assetAbility[2, "", p["When you ", i["Heal"], " a companion, ally, or other character, and score a hit, take +1 spirit or +1 momentum."]],
		assetAbility[3, "", p["When you ", i["Make Camp"], " and choose the option to partake, you can create a restorative meal. If you do, you and your companions take +1 health. Any allies who choose to partake also take +1 health, and do not suffer -supply."]]
	},
	{
		1
	},
	<||>,
	6
];

assetData["Honorbound"] = assetRecord[
	"Honorbound",
	"Path",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you ", i["Turn the Tide"], ",", " envision how your vows give you strength in this moment. Then, when you make your move, add +2 (instead of +1) and take +1 momentum on a hit."],
			True
		],
		assetAbility[2, "", p["When you ", i["Secure an Advantage"], " or ", i["Compel"], " by telling a hard truth, add +1 and take +1 momentum on a hit. On a weak hit or miss, envision how this truth complicates your current situation."]],
		assetAbility[3, "", p["When you ", i["Fulfill Your Vow"], " and score a miss, you may reroll one challenge die. If you score a miss again, reduce your maximum spirit by 1. You may recover this lost spirit when you next ", i["Fulfill Your Vow"], " and score a strong hit."]]
	},
	{
		1
	},
	<||>,
	6
];

assetData["Improviser"] = assetRecord[
	"Improviser",
	"Path",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you ", i["Check Your Gear"], ",", " you may roll +wits (instead of +supply). If you do, envision how you make do with a clever solution, and take +1 momentum on a hit."],
			True
		],
		assetAbility[2, "", p["When you ", i["Secure an Advantage"], " or ", i["Face Danger"], " by cobbling together an ad hoc tool or apparatus, add +1 and take +1 momentum on a hit. After rolling, you may also suffer -1 supply and add +1 more."]],
		assetAbility[3, "", p["When you throw caution to the wind and make an impulsive move in a risky situation, you may add +2. If you do, take +1 momentum on a strong hit, but count a weak hit as a miss."]]
	},
	{
		1
	},
	<||>,
	6
];

assetData["Infiltrator"] = assetRecord[
	"Infiltrator",
	"Path",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you make a move to breach, traverse, or hide within an area held by an enemy, add +1 and take +1 momentum on a hit."],
			True
		],
		assetAbility[2, "", p["When you ", i["Gather Information"], " within an enemy area to discover their positions, plans, or methods, or when you ", i["Secure an Advantage"], " within that area through observation, you may roll +shadow (instead of +wits). If you do, take +1 momentum on a hit."]],
		assetAbility[3, "", p["When you ", i["Resupply"], " within an enemy area by scavenging or looting, you may roll +shadow (instead of +wits). If you do, take +1 momentum or +1 supply on a hit."]]
	},
	{
		1
	},
	<||>,
	6
];

assetData["Lorekeeper"] = assetRecord[
	"Lorekeeper",
	"Path",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["You are the bearer of a mystical archive. When you ", i["Secure an Advantage"], " or ", i["Gather Information"], " using lore recalled from your studies, add +1. If you have a few hours to search the archive, add +2. On a hit, envision the obscure but helpful knowledge you put to use (", i["Ask the Oracle"], " if unsure), and take +1 momentum."],
			True
		],
		assetAbility[2, "", p["When you learn of a site or object holding lost knowledge, and ", i["Swear an Iron Vow"], " to recover it for the archive, reroll any dice. When you ", i["Fulfill Your Vow"], " and mark experience, take +1 experience."]],
		assetAbility[3, "", p["One time only, you may browse the archive\[CloseCurlyQuote]s forbidden depths. If you do, raise your wits by 1 and roll an action die. On 1-3, you must also mark corrupted or ", i["Face Desolation"], " (ignoring momentum)."]]
	},
	{
		1
	},
	<||>,
	6
];

assetData["Loyalist"] = assetRecord[
	"Loyalist",
	"Path",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you ", i["Aid Your Ally"], ",", " add +1 and take +1 momentum on a hit. This is in addition to the benefits taken by your ally."],
			True
		],
		assetAbility[2, "", p["When an ally makes the ", i["Endure Stress"], " move in your company, they add +1 and you take +1 momentum on a hit."]],
		assetAbility[3, "", p["When you stand with your ally as they make a progress move, envision how you support them. Then, roll one challenge die. On a 1-9, your ally may replace one of their challenge dice with yours. On a 10, envision how you inadvertently undermine their action; your ally must replace their lowest challenge die with yours."]]
	},
	{
		1
	},
	<||>,
	8
];

assetData["Masked"] = assetRecord[
	"Masked",
	"Path",
	p["Once you mark a bond with elves, and are gifted a mask of precious elderwood..."],
	<|
		"Material" -> assetField["material", "Material", "select_value"]
	|>,
	{
		assetAbility[
			1,
			"",
			choiceSection[
			{p["Choose your mask\[CloseCurlyQuote]s material."]},
			{
				choice["thunderwood", p["Thunderwood: Edge / Health"]],
				choice["bloodwood", p["Bloodwood: Iron / Health"]],
				choice["ghostwood", p["Ghostwood: Shadow / Spirit"]],
				choice["whisperwood", p["Whisperwood: Wits / Spirit"]]
			},
			{p["When you wear the mask and make a move which uses its stat, add +1. If you roll a 1 on your action die, suffer -1 to the associated track (in addition to any other outcome of the move)."]}
		],
			True
		],
		assetAbility[2, "", p["As above, and you may instead add +2 and suffer -2 (decide before rolling)."]],
		assetAbility[3, "", p["When you ", i["Face Death"], " or ", i["Face Desolation"], " while wearing the mask, you may roll +its stat (instead of +heart)."]]
	},
	{
		1
	},
	<||>,
	8
];

assetData["Oathbreaker"] = assetRecord[
	"Oathbreaker",
	"Path",
	p["Once you ", i["Forsake Your Vow"], "..."],
	<||>,
	{
		assetAbility[
			1,
			"",
			p[b["This asset counts as a debility"], ".", " One time only, when you ", i["Swear an Iron Vow"], " to redeem yourself (extreme or greater), give that vow a special mark. When you ", i["Reach a Milestone"], " on the marked vow, take +2 momentum."],
			True
		],
		assetAbility[2, "", p["When you ", i["Secure an Advantage"], " or ", i["Compel"], " by reaffirming your commitment to your marked vow, add +1 and take +1 momentum on a hit."]],
		assetAbility[3, "", p["When you ", i["Fulfill Your Vow"], " on your marked quest and score a hit, you find redemption and automatically activate this ability at no cost. You may then improve one of your stats by +1 and ", b["discard this asset"], "."]]
	},
	{
		1
	},
	<||>,
	8
];

assetData["Outcast"] = assetRecord[
	"Outcast",
	"Path",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When your supply is reduced to 0, suffer any remaining -supply as -momentum. Then, roll +wits. On a strong hit, you manage to scrape by and take +1 supply. On a weak hit, you may suffer -2 momentum in exchange for +1 supply. On a miss, you are ", i["Out of Supply"], "."],
			True
		],
		assetAbility[2, "", p["When you ", i["Sojourn"], ",", " you may reroll any dice. If you do (decide before your first roll), your needs are few, but your isolation sets you apart from others. A strong hit counts as a weak hit."]],
		assetAbility[3, "", p["When you ", i["Reach Your Destination"], " and score a strong hit, you recall or recognize something helpful about this place. Envision what it is, and take +2 momentum."]]
	},
	{
		1
	},
	<||>,
	8
];

assetData["Pretender"] = assetRecord[
	"Pretender",
	"Path",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you establish a false identity, roll +shadow. On a strong hit, you may add +2 when you make moves using this identity to deceive or influence others. If you roll a 1 on your action die when using your false identity, someone doubts you. Make appropriate moves to reassure them or prevent them from revealing the truth. On a weak hit, as above, but add +1 (instead of +2)."],
			True
		],
		assetAbility[2, "", p["As above, and you may roll +shadow (instead of +heart) when you ", i["Sojourn"], " under your false identity. If you do, take +1 momentum on a hit."]],
		assetAbility[3, "", p["When you ", i["Secure an Advantage"], " by revealing your true identity in a dramatic moment, reroll any dice."]]
	},
	{
		1
	},
	<||>,
	8
];

assetData["Revenant"] = assetRecord[
	"Revenant",
	"Path",
	p["Once you ", i["Face Death"], " and return to the world of the living..."],
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you are at 0 health, and ", i["Endure Harm"], " or ", i["Face Death"], ",", " add +1. If you then burn momentum to improve your result, envision what bond or vow binds you to this world, and take +2 momentum after you reset."],
			True
		],
		assetAbility[2, "", p["When you make a move to investigate, oppose, or interact with a horror, spirit, or other undead being, add +1."]],
		assetAbility[3, "", p["When you bring death to your foe to ", i["End the Fight"], ",", " you may burn momentum to cancel one (not both) of the challenge dice if your momentum is greater than the value of that die. If you do, ", i["Endure Stress"], " (2 stress)."]]
	},
	{
		1
	},
	<||>,
	8
];

assetData["Rider"] = assetRecord[
	"Rider",
	"Path",
	p["If you are with your horse companion..."],
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you ", i["Heal"], " your horse, or when you ", i["Face Danger"], " to calm or encourage it, add +1 and take +1 momentum on a hit."],
			True
		],
		assetAbility[2, "", p["When you ", i["Undertake a Journey"], ",", " you may push your horse harder and add +1 (after rolling). If you do, make the ", i["Companion Endure Harm"], " move (1 harm)."]],
		assetAbility[3, "", p["When you ", i["Secure an Advantage"], " +wits by sizing up a perilous situation from the saddle, you are one with your horse\[CloseCurlyQuote]s instincts. Add +1 and take +1 momentum on a hit."]]
	},
	{
		1
	},
	<||>,
	8
];

assetData["Ritualist"] = assetRecord[
	"Ritualist",
	"Path",
	p["Once you ", i["Fulfill Your Vow"], " (formidable or greater) in service to an elder mystic, and ", i["Forge a Bond"], " to train with them..."],
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you ", i["Secure an Advantage"], " to ready yourself for a ritual, envision how you prepare. Then, add +1 and take +1 momentum on a hit."],
			True
		],
		assetAbility[2, "", p["When you perform a ritual, you may suffer -1 supply and add +1 (decide before rolling)."]],
		assetAbility[3, "", p["When you tattoo the essence of a new ritual onto your skin, envision the mark you create. You may then purchase and upgrade that ritual asset for 1 fewer experience."]]
	},
	{
		1
	},
	<||>,
	8
];

assetData["Shadow-kin"] = assetRecord[
	"Shadow-kin",
	"Path",
	p["Once you become corrupted..."],
	<||>,
	{
		assetAbility[1, "", p["You harden your heart: Reduce your heart stat by 1 and add up to +2 to shadow (to a maximum of +4)."]],
		assetAbility[2, "", p["You are attuned to the realms of shadow: When you perform a ritual, add +1."]],
		assetAbility[3, "", p["You know the sly ways of death: When you ", i["Face Death"], ",", " you may roll +shadow (instead of +heart). On a weak hit, if you choose to undertake a deathbound quest, you may roll +shadow (instead of +heart) and reroll any dice as you ", i["Swear an Iron Vow"], ".", " When you ", i["Fulfill Your Vow"], " on that quest and and mark experience, take +2 experience."]]
	},
	{},
	<||>,
	8
];

assetData["Sighted"] = assetRecord[
	"Sighted",
	"Path",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you ", i["Face Danger"], " or ", i["Gather Information"], " to identify or detect mystic forces, add +1 and take +1 momentum on a hit."],
			True
		],
		assetAbility[2, "", p["When you ", i["Compel"], ",", " ", i["Forge a Bond"], ",", " or ", i["Test Your Bond"], " with a fellow mystic or mystical being, add +1 and take +1 momentum on a hit."]],
		assetAbility[3, "", p["When you ", i["Secure an Advantage"], " by studying someone or something in a charged situation, add +1 and take +1 momentum on a hit. When you also pierce the veil to explore deeper truths (decide before rolling), you may reroll any dice. If you do, count a weak hit as a miss."]]
	},
	{
		1
	},
	<||>,
	10
];

assetData["Slayer"] = assetRecord[
	"Slayer",
	"Path",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you ", i["Gather Information"], " by tracking a beast or horror, or when you ", i["Secure an Advantage"], " by readying yourself for a fight against them, add +1 and take +1 momentum on a hit."],
			True
		],
		assetAbility[2, "", p["When you ", i["Swear an Iron Vow"], " to slay a beast or horror, you may reroll any dice. When you ", i["Fulfill Your Vow"], " and mark experience, take +1 experience."]],
		assetAbility[3, "", choiceSection[
			{p["When you slay a beast or horror (at least formidable), you may take a trophy and choose one."]},
			{
				choice["power-a-ritual", p["Power a ritual: When you or an ally make a ritual move, reroll any dice (one time only)."]],
				choice["prove-your-worth", p["Prove your worth: When you ", i["Sojourn"], ",", " reroll any dice (one time only)."]]
			},
			{}
		]]
	},
	{
		1
	},
	<||>,
	10
];

assetData["Spirit-bound"] = assetRecord[
	"Spirit-bound",
	"Path",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["You are haunted by someone whose death you caused through your actions or failures. When you consult with their spirit to ", i["Secure an Advantage"], " or ", i["Gather Information"], ",", " add +1 and take +2 momentum on a hit. On a weak hit, also ", i["Endure Stress"], " (1 stress)."],
			True
		],
		assetAbility[2, "", p["When you ", i["Face Death"], " guided by the spirit, add +1. On a strong hit, envision what you learn and take 1 experience."]],
		assetAbility[3, "", choiceSection[
			{p["One time only, when you successfully ", i["Fulfill Your Vow"], " (formidable or greater) in service to the spirit, choose one."]},
			{
					choice["let-them-go", p["Let them go: Take 2 experience for each marked ability and discard this asset."]],
				choice["deepen-your-connection", p["Deepen your connection: Add +1 more when you leverage this asset."]]
			},
			{}
		]]
	},
	{
		1
	},
	<||>,
	10
];

assetData["Storyweaver"] = assetRecord[
	"Storyweaver",
	"Path",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you ", i["Secure an Advantage"], ",", " ", i["Compel"], ",", " or ", i["Forge a Bond"], " by sharing an inspiring or enlightening song, poem, or tale, envision the story you tell. Then, add +1 and take +1 momentum on a hit."],
			True
		],
		assetAbility[2, "", p["When you ", i["Make Camp"], " and choose the option to relax, you may share a story with your allies or compose a new story if alone. If you do, envision the story you tell and take +1 spirit or +1 momentum. Any allies who choose to relax in your company may also take +1 spirit or +1 momentum."]],
		assetAbility[3, "", p["When you ", i["Sojourn"], " within a community with which you share a bond, add +2 (instead of +1)."]]
	},
	{
		1
	},
	<||>,
	10
];

assetData["Trickster"] = assetRecord[
	"Trickster",
	"Path",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you ", i["Face Danger"], ",", " ", i["Secure an Advantage"], ",", " or ", i["Compel"], " by lying, bluffing, stealing, or cheating, add +1."],
			True
		],
		assetAbility[2, "", p["When you ", i["Gather Information"], " by investigating a devious scheme, you may roll +shadow (instead of +wits). If you do, take +2 momentum on a hit."]],
		assetAbility[3, "", choiceSection[
			{p["When you ", i["Forge a Bond"], " for a relationship founded on a lie, choose one."]},
			{
				choice["keep-your-secret", p["Keep your secret: Roll +shadow (instead of +heart)."]],
				choice["reveal-the-truth", p["Reveal the truth: Roll +heart. On a strong hit, mark a bond twice and take 1 experience. A weak hit counts as a miss."]]
			},
			{}
		]]
	},
	{
		1
	},
	<||>,
	10
];

assetData["Veteran"] = assetRecord[
	"Veteran",
	"Path",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you burn momentum to improve your result in combat, envision how your hard-won fighting experience gives you the upper hand. Then, take +1 momentum after you reset, and add +1 when you make your next move. Once per fight, you also take initiative when burning momentum to improve a miss to a weak hit."],
			True
		],
		assetAbility[2, "", p["When you ", i["Swear an Iron Vow"], " to someone who fought beside you, or ", i["Forge a Bond"], " with them, add +2 and take +2 momentum on a hit."]],
		assetAbility[3, "", p["When you ", i["Resupply"], " by looting the dead on a field of battle, add +1 and take +1 momentum on a hit."]]
	},
	{
		1
	},
	<||>,
	10
];

assetData["Waterborn"] = assetRecord[
	"Waterborn",
	"Path",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you ", i["Face Danger"], ",", " ", i["Gather Information"], ",", " or ", i["Secure an Advantage"], " related to your knowledge of watercraft, water travel, or aquatic environments or creatures, add +1 and take +1 momentum on a hit."],
			True
		],
		assetAbility[2, "", choiceSection[
			{p["When you ", i["Undertake a Journey"], " by boat or ship, add +1. On a strong hit, also choose one."]},
			{
				choice["the-wind-is-at-your-back", p["The wind is at your back: Mark progress twice."]],
				choice["find-safe-anchor", p["Find safe anchor: ", i["Make Camp"], " now and reroll any dice."]],
				choice["reap-the-bounty", p["Reap the bounty: ", i["Resupply"], " now and reroll any dice."]]
			},
			{}
		]],
		assetAbility[3, "", p["When you ", i["Enter the Fray"], " aboard a boat or ship, reroll any dice."]]
	},
	{
		1
	},
	<||>,
	10
];

assetData["Wayfinder"] = assetRecord[
	"Wayfinder",
	"Path",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you ", i["Undertake a Journey"], ",", " take +1 momentum on a strong hit. If you burn momentum to improve your result, also take +1 momentum after you reset."],
			True
		],
		assetAbility[2, "", p["When you ", i["Secure an Advantage"], " or ", i["Gather Information"], " by carefully surveying the landscape or scouting ahead, add +1 and take +1 momentum on a hit."]],
		assetAbility[3, "", p["When you ", i["Swear an Iron Vow"], " to safely guide someone on a perilous journey, you may reroll any dice. When you ", i["Fulfill Your Vow"], " and mark experience, take +1 experience."]]
	},
	{
		1
	},
	<||>,
	10
];

assetData["Weaponmaster"] = assetRecord[
	"Weaponmaster",
	"Path",
	p["Once you ", i["Fulfill Your Vow"], " (formidable or greater) in service to a seasoned warrior, and ", i["Forge a Bond"], " to train with them..."],
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you ", i["Secure an Advantage"], " by sizing up your foe in a fight, or in a charged situation which may lead to a fight, add +1 and take +1 momentum on a hit."],
			True
		],
		assetAbility[2, "", p["When you study or train in a new weapon or technique, you may obtain and upgrade that combat talent for 1 fewer experience."]],
		assetAbility[3, "", p["When you ", i["Turn the Tide"], " with a sudden change of weapon or technique, and your next move is a ", i["Strike"], ",", " add +1 and inflict +2 harm on a strong hit."]]
	},
	{
		1
	},
	<||>,
	10
];

assetData["Wildblood"] = assetRecord[
	"Wildblood",
	"Path",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you ", i["Face Danger"], ",", " ", i["Secure an Advantage"], ",", " or ", i["Gather Information"], " using your knowledge of tracking, woodcraft, or woodland creatures, add +1."],
			True
		],
		assetAbility[2, "", p["When you ", i["Face Danger"], " or ", i["Secure an Advantage"], " by hiding or sneaking in the woodlands, add +1 and take +1 momentum on a hit."]],
		assetAbility[3, "", p["When you ", i["Make Camp"], " in the woodlands, you may roll +wits (instead of +supply). If you do, you and your allies each choose 1 more option on a hit."]]
	},
	{
		1
	},
	<||>,
	12
];

assetData["Wright"] = assetRecord[
	"Wright",
	"Path",
	None,
	<|
		"Specialty" -> assetField["specialty", "Specialty", "text"]
	|>,
	{
		assetAbility[
			1,
			"",
			p["When you ", i["Secure an Advantage"], " by crafting a useful item using your specialty, or when you ", i["Face Danger"], " to create or repair an item in a perilous situation, add +1 and take +1 momentum on a hit."],
			True
		],
		assetAbility[2, "", p["As above, and you may suffer -1 supply (after rolling) to add an additional +1."]],
		assetAbility[3, "", p["When you give the item you create as a gift to commemorate an important event or relationship, you may (one time only) reroll any dice when you ", i["Compel"], ",", " ", i["Forge a Bond"], ",", " or ", i["Test Your Bond"], "."]]
	},
	{
		1
	},
	<||>,
	12
];



(* ::Subsection::Closed:: *)
(*Combat talent assets*)


assetData["Archer"] = assetRecord[
	"Archer",
	"Combat Talent",
	p["If you wield a bow..."],
	<||>,
	{
		assetAbility[
			1,
			"",
			choiceSection[
			{p["When you ", i["Secure an Advantage"], " by taking a moment to aim, choose your approach and add +1."]},
			{
				choice["trust-your-instincts", p["Trust your instincts: Roll +wits, and take +2 momentum on a strong hit."]],
				choice["line-up-your-shot", p["Line up your shot: Roll +edge, and take +1 momentum on a hit."]]
			},
			{}
		],
			True
		],
		assetAbility[2, "", p["Once per fight, when you ", i["Strike"], " or ", i["Clash"], ",", " you may take extra shots and suffer -1 supply (decide before rolling). When you do, reroll any dice. On a hit, inflict +2 harm and take +1 momentum."]],
		assetAbility[3, "", p["When you ", i["Resupply"], " by hunting, add +1 and take +1 momentum on a hit."]]
	},
	{
		1
	},
	<||>,
	12
];

assetData["Berserker"] = assetRecord[
	"Berserker",
	"Combat Talent",
	p["If you are clad only in animal pelts..."],
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you ", i["Secure an Advantage"], " or ", i["Compel"], " by embodying your wild nature, add +1 and take +1 momentum on a hit."],
			True
		],
		assetAbility[2, "", choiceSection[
			{p["When you ", i["Strike"], " or ", i["Clash"], " by unleashing your rage (decide before rolling), inflict +1 harm on a hit. Then, choose one."]},
			{
				choice["push-yourself", p["Push yourself: ", i["Endure Harm"], " (1 harm)."]],
				choice["lose-yourself", p["Lose yourself: ", i["Endure Stress"], " (1 stress)."]]
			},
			{}
		]],
		assetAbility[3, "", p["When you ", i["Endure Harm"], " in a fight, and your health is above 0, you may let the pain inflame your wildness (decide before rolling). If you then score a strong hit and choose to embrace the pain, take +momentum equal to your remaining health. A weak hit counts as a miss."]]
	},
	{
		1
	},
	<||>,
	12
];

assetData["Brawler"] = assetRecord[
	"Brawler",
	"Combat Talent",
	p["If you are unarmed or fighting with a non-deadly weapon..."],
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you ", i["Secure an Advantage"], " +iron by engaging in close-quarters brawling (such as punching, tripping, or grappling), add +1. If you score a hit, you may also inflict 1 harm."],
			True
		],
		assetAbility[2, "", p["When you use an unarmed attack or simple weapon to ", i["Strike"], " with deadly intent, add +2 and inflict 2 harm on a hit (instead of 1). On a weak hit or miss, suffer -1 momentum (in addition to any other outcome of the move)."]],
		assetAbility[3, "", p["When you ", i["Face Danger"], " or ", i["Clash"], " against a brawling attack, add +1 and take +1 momentum on a hit."]]
	},
	{
		1
	},
	<||>,
	12
];

assetData["Cutthroat"] = assetRecord[
	"Cutthroat",
	"Combat Talent",
	p["If you wield a dagger or knife..."],
	<||>,
	{
		assetAbility[
			1,
			"",
			choiceSection[
			{p["When you are in position to ", i["Strike"], " at an unsuspecting foe, choose one (before rolling)."]},
			{
				choice["add-2-and-take-1-momentum-on-a-hit", p["Add +2 and take +1 momentum on a hit."]],
				choice["inflict-2-harm-on-a-hit", p["Inflict +2 harm on a hit."]]
			},
			{}
		],
			True
		],
		assetAbility[2, "", p["When you ", i["Compel"], " someone at the point of your blade, or when you rely on your blade to ", i["Face Danger"], ",", " add +1."]],
		assetAbility[3, "", p["Once per fight, when you ", i["Secure an Advantage"], " +shadow by performing a feint or misdirection, reroll any dice and take +1 momentum on a hit."]]
	},
	{
		1
	},
	<||>,
	12
];

assetData["Duelist"] = assetRecord[
	"Duelist",
	"Combat Talent",
	p["If you wield a bladed weapon in each hand..."],
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you ", i["Strike"], " or ", i["Clash"], ",", " you may add +2. If you do (decide before rolling), inflict +1 harm on a strong hit and count a weak hit as a miss."],
			True
		],
		assetAbility[2, "", p["Once per fight, when you ", i["Secure an Advantage"], " +edge by making a bold display of your combat prowess, you may reroll any dice."]],
		assetAbility[3, "", choiceSection[
			{p["When you ", i["Draw the Circle"], ",", " choose one (before rolling)."]},
			{
				choice["add-2", p["Add +2."]],
				choice["take-2-momentum-on-a-hit", p["Take +2 momentum on a hit."]]
			},
			{}
		]]
	},
	{
		1
	},
	<||>,
	12
];

assetData["Fletcher"] = assetRecord[
	"Fletcher",
	"Combat Talent",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you ", i["Secure an Advantage"], " by crafting arrows of fine quality, add +1. Then, take +1 supply or +1 momentum on a hit."],
			True
		],
		assetAbility[2, "", p["When you ", i["Resupply"], " by recovering or gathering arrows after a battle, add +2."]],
		assetAbility[3, "", choiceSection[
			{p["When you craft a single arrow designated for a specific foe, envision the process and materials, and roll +wits. On a strong hit, take both. On a weak hit, choose one."]},
			{
				choice["seeker", p["Seeker: When a shooter uses the arrow to ", i["Strike"], " or ", i["Clash"], " against this foe, reroll any dice (one time only)."]],
				choice["ravager", p["Ravager: When a shooter uses the arrow to inflict harm against this foe, inflict +1d6 harm (one time only)."]]
			},
			{}
		]]
	},
	{
		1
	},
	<||>,
	12
];

assetData["Ironclad"] = assetRecord[
	"Ironclad",
	"Combat Talent",
	p["If you wear armor..."],
	<|
		"Equipped" -> assetField["equipped", "Equipped", "select_enhancement", <|"Display" -> False|>]
	|>,
	{
		assetAbility[
			1,
			"",
			fieldSelectorChoiceSection[
				{p["When you equip or adjust your armor, choose one."]},
				{
					choice["lightly-armored", p[b["Lightly armored: "], "When you ", i["Endure Harm"], " in a fight, add +1 and take +1 momentum on a hit."]],
					choice["geared-for-war", p[b["Geared for war: "], "Mark encumbered. When you ", i["Endure Harm"], " in a fight, add +2 and take +1 momentum on a hit."]]
				},
				"Equipped"
			],
			True
		],
		assetAbility[2, "", p["When you ", i["Clash"], " while you are geared for war, add +1."]],
		assetAbility[3, "", p["When you ", i["Compel"], " in a situation where strength of arms is a factor, add +2."]]
	},
	{
		1
	},
	<||>,
	12
];

assetData["Long-arm"] = assetRecord[
	"Long-arm",
	"Combat Talent",
	p["If you wield a staff..."],
	<||>,
	{
		assetAbility[
			1,
			"",
			p["In your hands, a humble staff is a deadly weapon (2 harm). When you instead use it as a simple weapon (1 harm), you may ", i["Strike"], " or ", i["Clash"], " +edge (instead of iron). If you do, add +1 and take +1 momentum on a hit."],
			True
		],
		assetAbility[2, "", p["When you ", i["Secure an Advantage"], " +edge using your staff to disarm, trip, shove, or stun your foe, add +1 and take +1 momentum on a hit."]],
		assetAbility[3, "", p["When you ", i["Undertake a Journey"], " and score a strong hit, or if you accompany an ally who scores a strong hit on that move, your staff provides support and comfort in your travels; take +1 momentum."]]
	},
	{
		1
	},
	<||>,
	14
];

assetData["Shield-bearer"] = assetRecord[
	"Shield-bearer",
	"Combat Talent",
	p["If you wield a shield..."],
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you ", i["Face Danger"], " using your shield as cover, add +1. When you ", i["Clash"], " in close quarters, take +1 momentum on a strong hit."],
			True
		],
		assetAbility[2, "", p["When you paint your shield with a meaningful symbol, envision what you create. Then, if you ", i["Endure Stress"], " as you face off against a fearsome foe, add +1 and take +1 momentum on a hit."]],
		assetAbility[3, "", p["When forced to ", i["Endure Harm"], " in a fight, you may instead sacrifice your shield and ignore all harm. If you do, the shield is destroyed. Once per fight, you also take initiative when you sacrifice your shield to avoid harm."]]
	},
	{
		1
	},
	<||>,
	14
];

assetData["Skirmisher"] = assetRecord[
	"Skirmisher",
	"Combat Talent",
	p["If you wield a spear..."],
	<||>,
	{
		assetAbility[
			1,
			"",
			choiceSection[
			{p["When you ", i["Face Danger"], " by holding a foe at bay using your spear\[CloseCurlyQuote]s reach, roll +iron or +edge. If you score a hit, you may..."]},
			{
				choice["iron", p["Iron: ", i["Strike"], " (if you have initiative) or ", i["Clash"], " now, and add +1."]],
				choice["edge", p["Edge: Take +1 momentum."]]
			},
			{}
		],
			True
		],
		assetAbility[2, "", p["When you ", i["Strike"], " in close combat, you may attempt to drive your spear home (decide before rolling). If you do, add +1 and inflict +2 harm on a hit. If you score a hit and the fight continues, ", i["Face Danger"], " +iron to recover your spear."]],
		assetAbility[3, "", p["When you ", i["Secure an Advantage"], " by bracing your spear against a charging foe, add +1 and take +1 momentum on a hit."]]
	},
	{
		1
	},
	<||>,
	14
];

assetData["Slinger"] = assetRecord[
	"Slinger",
	"Combat Talent",
	p["If you wield a sling..."],
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When launched from a sling, a simple stone inflicts deadly harm (2 harm). When you ", i["Enter the Fray"], " by barraging your foe with sling-bullets, inflict harm on a strong hit."],
			True
		],
		assetAbility[2, "", choiceSection[
			{p["When you ", i["Strike"], " by launching stones at an advancing foe, you may choose one (before rolling)."]},
			{
				choice["hold-them-back", p["Hold them back: Retain initiative on a weak hit, but inflict only 1 harm."]],
				choice["hit-them-hard", p["Hit them hard: Inflict +1 harm on a hit, but suffer -1 momentum."]]
			},
			{}
		]],
		assetAbility[3, "", p["When you ", i["Secure an Advantage"], " by preparing stones of a special quality or material, add +1. Then, take +1 momentum or +1 supply on a hit."]]
	},
	{
		1
	},
	<||>,
	14
];

assetData["Sunderer"] = assetRecord[
	"Sunderer",
	"Combat Talent",
	p["If you wield an axe..."],
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you ", i["Strike"], " or ", i["Clash"], " in close quarters, you may suffer -1 momentum and inflict +1 harm on a hit (decide before rolling)."],
			True
		],
		assetAbility[2, "", p["When you have your axe in hand, and use the promise of violence to ", i["Compel"], " or ", i["Secure an Advantage"], ",", " add +1 and take +1 momentum on a hit."]],
		assetAbility[3, "", p["When you make a tribute to a fallen foe (formidable or greater) by carving a rune in the haft of your axe, roll +heart. On a strong hit, inflict +1d6 harm (one time only) when you ", i["Strike"], " or ", i["Clash"], ".", " On a weak hit, as above, but this death weighs on you; ", i["Endure Stress"], " (2 stress)."]]
	},
	{
		1
	},
	<||>,
	14
];

assetData["Swordmaster"] = assetRecord[
	"Swordmaster",
	"Combat Talent",
	p["If you wield a sword..."],
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you ", i["Strike"], " or ", i["Clash"], " and burn momentum to improve your result, inflict +2 harm. If the fight continues, add +1 on your next move."],
			True
		],
		assetAbility[2, "", p["When you ", i["Clash"], " and score a strong hit, add +1 if you immediately follow with a ", i["Strike"], "."]],
		assetAbility[3, "", p["When you ", i["Swear an Iron Vow"], " by kneeling and grasping your sword\[CloseCurlyQuote]s blade, add +1 and take +1 momentum on a hit. If you let the edge draw blood from your hands, ", i["Endure Harm"], " (1 harm) in exchange for an additional +1 momentum on a hit."]]
	},
	{
		1
	},
	<||>,
	14
];

assetData["Thunder-bringer"] = assetRecord[
	"Thunder-bringer",
	"Combat Talent",
	p["If you wield a mighty hammer..."],
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you ", i["Face Danger"], ",", " ", i["Secure an Advantage"], ",", " or ", i["Compel"], " by hitting or breaking an inanimate object, add +1 and take +1 momentum on a hit."],
			True
		],
		assetAbility[2, "", p["When you ", i["Strike"], " a foe to knock them back, stun them, or put them off balance, inflict 1 harm (instead of 2) and take +2 momentum on a hit. On a strong hit, you also create an opening and add +1 on your next move."]],
		assetAbility[3, "", p["When you ", i["Turn the Tide"], ",", " you may ", i["Strike"], " with all the fury and power you can muster. If you do (decide before rolling), you may reroll any dice and inflict +2 harm on a strong hit, but count a weak hit as a miss."]]
	},
	{
		1
	},
	<||>,
	14
];



(* ::Subsection::Closed:: *)
(*Ritual assets*)


assetData["Augur"] = assetRecord[
	"Augur",
	"Ritual",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you summon a flock of crows and ask a single question, roll +wits. On a strong hit, you interpret their calls as a helpful omen. Envision the response (", i["Ask the Oracle"], " if unsure) and take +2 momentum. On a weak hit, the crows ignore your question and offer a clue to an unrelated problem or opportunity in this area. Envision what you learn (", i["Ask the Oracle"], " if unsure), and take +1 momentum."],
			True
		],
		assetAbility[2, "", p["As above, and the crows will also help guide you on the proper path. On a hit, add +1 on the next segment when you ", i["Undertake a Journey"], "."]],
		assetAbility[3, "", p["When you perform this ritual, add +1 and take +1 momentum on a hit."]]
	},
	{
		1
	},
	<||>,
	14
];

assetData["Awakening"] = assetRecord[
	"Awakening",
	"Ritual",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you create a simulacrum, roll +heart. On a strong hit, your creation is given unnatural life. If it aids you as you make a move to assault or overcome an obstacle through strength, add +2. It has 3 health and suffers harm as appropriate, but is not a companion and may not be healed. At 0 health, it is dead. On a weak hit, as above, but if you roll a 1 on your action die when aided by your creation, you must ", i["Face Danger"], " +heart to keep it from turning on you (as a formidable foe)."],
			True
		],
		assetAbility[2, "", p["Your simulacrum has 6 health."]],
		assetAbility[3, "", p["When you perform this ritual, add +1 and take +1 momentum on a hit."]]
	},
	{
		1
	},
	<|
		"health" -> assetTrack["health", "Health", 0, 3, 3]
	|>,
	14
];

assetData["Bind"] = assetRecord[
	"Bind",
	"Ritual",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you wear an animal pelt and dance in moonlight, roll +wits. On a strong hit, you or an ally may wear the pelt and add +1 when making moves with the related stat (wolf-edge; bear-iron; deer-heart; fox-shadow; boar-wits). If the wearer rolls a 1 on their action die while making a move using the pelt, the magic is spent. On a weak hit, as above, but the wilds call as you dance; ", i["Endure Stress"], " (2 stress)."],
			True
		],
		assetAbility[2, "", p["As above, and you may instead perform this ritual wearing the pelt of a beast. If you do, name the related stat and add +2 (instead of +1)."]],
		assetAbility[3, "", p["When you perform this ritual, add +1 and take +1 momentum on a hit."]]
	},
	{
		1
	},
	<||>,
	16
];

assetData["Communion"] = assetRecord[
	"Communion",
	"Ritual",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you surround the remains of a recently deceased intelligent creature with lit candles, and summon its spirit, roll +heart. Add +1 if you share a bond. On a strong hit, the spirit appears and you may converse for a few minutes. Make moves as appropriate (add +1). On a weak hit, as above, but the spirit also delivers troubling news unrelated to your purpose. Envision what it tells you (", i["Ask the Oracle"], " if unsure) and ", i["Endure Stress"], " (1 stress)."],
			True
		],
		assetAbility[2, "", p["As above, and you may also commune with the long-dead."]],
		assetAbility[3, "", p["When you perform this ritual, add +1 and take +1 momentum on a hit."]]
	},
	{
		1
	},
	<||>,
	16
];

assetData["Divination"] = assetRecord[
	"Divination",
	"Ritual",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you take a drop of blood from a willing subject (not yourself) and cast the rune-carved stones, roll +heart. On a strong hit, you may read the runes to gain insight about the subject and people close to them, including information you and the subject have no knowledge of. If you use the reading to ", i["Gather Information"], ",", " ", i["Compel"], ",", " or ", i["Forge a Bond"], ",", " add +1. On a weak hit, as above, but the runes reveal their secrets only with extra time and focus; suffer -2 momentum."],
			True
		],
		assetAbility[2, "", p["As above, and your divination can also reveal information about the subject\[CloseCurlyQuote]s future."]],
		assetAbility[3, "", p["When you perform this ritual, add +1 and take +1 momentum on a hit."]]
	},
	{
		1
	},
	<||>,
	16
];

assetData["Invoke"] = assetRecord[
	"Invoke",
	"Ritual",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you consume the mystical essence of your surroundings, roll +wits. On a strong hit, add the value of your action die to your essence track (max 6). You may then ", i["Secure an Advantage"], " or ", i["Face Danger"], " +essence to create minor mystical effects or illusions. If you do, suffer -1 essence and take +1 momentum on a hit. On a weak hit, as above, but capturing these energies is harrowing; ", i["Endure Stress"], " (2 stress)."],
			True
		],
		assetAbility[2, "", p["You may ", i["Compel"], " +essence (and suffer -1 essence) through a show of power."]],
		assetAbility[3, "", p["When you perform this ritual, add +1 and take +1 essence on a hit."]]
	},
	{
		1
	},
	<|
		"essence" -> assetTrack["essence", "Essence", 0, 6, 0]
	|>,
	16
];

assetData["Keen"] = assetRecord[
	"Keen",
	"Ritual",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you hold a weapon and sing a keen for those it has killed, roll +heart. On a strong hit, the wielder inflicts +1 harm when they ", i["Strike"], " or ", i["Clash"], ".", " If they roll a 1 on their action die when making a move to inflict harm, the magic is spent. On a weak hit, as above, but the voices of those who were slain join in your song; ", i["Endure Stress"], " (2 stress)."],
			True
		],
		assetAbility[2, "", p["As above, and the wielder may also (one time only) add +1 and take +2 momentum on a hit when they ", i["Draw the Circle"], ",", " ", i["Enter the Fray"], ",", " or ", i["Battle"], "."]],
		assetAbility[3, "", p["When you perform this ritual, add +1 and take +1 momentum on a hit."]]
	},
	{
		1
	},
	<||>,
	16
];

assetData["Leech"] = assetRecord[
	"Leech",
	"Ritual",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you mark your hands or weapon with an intricate blood rune, roll +iron. On a strong hit, the rune thirsts for fresh blood. One time only, when you make a move to inflict harm, reroll any dice and inflict +2 harm on a hit. Then, for each point of harm inflicted, take +1 and allocate it as +health or +momentum. On a weak hit, as above, but this asset counts as a debility until the rune\[CloseCurlyQuote]s thirst is quenched."],
			True
		],
		assetAbility[2, "", p["As above, and you may also touch an ally or companion and let them take any remaining points as +health or +momentum."]],
		assetAbility[3, "", p["When you perform this ritual, add +1 and take +1 momentum on a hit."]]
	},
	{
		1
	},
	<||>,
	16
];

assetData["Lightbearer"] = assetRecord[
	"Lightbearer",
	"Ritual",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you focus on a source of light and capture its essence, roll +wits. On a strong hit, set your light track to +6. On a weak hit, make it +3. Then, when you make a move to overcome or navigate darkness, you may add +2 and suffer -1 light."],
			True
		],
		assetAbility[2, "", p["You may use your light to ", i["Strike"], " or ", i["Clash"], " against a dark-dwelling foe. Choose the amount of light to unleash, and roll +light (instead of +iron or +edge). Suffer -light equal to that amount. On a hit, your harm is 1+your unleashed light."]],
		assetAbility[3, "", p["When you perform this ritual, add +1 and take +1 momentum on a hit."]]
	},
	{
		1
	},
	<|
		"light" -> assetTrack["light", "Light", 0, 6, 0]
	|>,
	16
];

assetData["Scry"] = assetRecord[
	"Scry",
	"Ritual",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			choiceSection[
			{p["When you look into flames to study a remote person or location, roll +shadow. You or someone with you must have knowledge of the target. On a strong hit, you may ", i["Gather Information"], " through observation using +shadow or +wits. On a weak hit, as above, but the flames are hungry; choose one to sacrifice."]},
			{
				choice["your-blood", p["Your blood: ", i["Endure Harm"], " (2 harm)."]],
				choice["something-precious", p["Something precious: ", i["Endure Stress"], " (2 stress)."]],
				choice["provisions", p["Provisions: Suffer -2 supply."]]
			},
			{}
		],
			True
		],
		assetAbility[2, "", p["As above, and you may instead study a past event."]],
		assetAbility[3, "", p["When you perform this ritual, add +1 and take +1 momentum on a hit."]]
	},
	{
		1
	},
	<||>,
	16
];

assetData["Shadow-walk"] = assetRecord[
	"Shadow-walk",
	"Ritual",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you cloak yourself with the gossamer veil of the shadow realms, roll +shadow. On a strong hit, take +1 momentum. Then, reroll any dice (one time only) when you make a move by ambushing, hiding, or sneaking. On a weak hit, as above, but the shadows try to lead you astray. You must first ", i["Face Danger"], " to find your way."],
			True
		],
		assetAbility[2, "", p["As above, and you may also travel along the hidden paths of the shadow realms to ", i["Undertake a Journey"], " using +shadow (instead of +wits). If you do, ", i["Endure Stress"], " (1 stress) and mark progress twice on a strong hit."]],
		assetAbility[3, "", p["When you perform this ritual, add +1 and take +1 momentum on a hit."]]
	},
	{
		1
	},
	<||>,
	16
];

assetData["Sway"] = assetRecord[
	"Sway",
	"Ritual",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you speak a person\[CloseCurlyQuote]s name three times to the wind, roll +wits. On a strong hit, the wind whispers of this person\[CloseCurlyQuote]s need. Envision what you hear (", i["Ask the Oracle"], " if unsure). If you use this information or fulfill this need when you ", i["Compel"], " them, you may reroll any dice (one time only). On a weak hit, as above, but this person\[CloseCurlyQuote]s need creates a troubling dilemma or complication; ", i["Endure Stress"], " (1 stress)."],
			True
		],
		assetAbility[2, "", p["As above, and if you score a strong hit when you ", i["Compel"], ",", " you may also reroll any dice (one time only) when you ", i["Gather Information"], " from this person."]],
		assetAbility[3, "", p["When you perform this ritual, add +1 and take +1 momentum on a hit."]]
	},
	{
		1
	},
	<||>,
	18
];

assetData["Talisman"] = assetRecord[
	"Talisman",
	"Ritual",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you fashion a charm, envision it and name the specific person or creature it protects against. Then roll +wits. On a strong hit, when the wearer opposes the target through a move, add +2. If a 1 is rolled on the action die while making a move using the charm, the magic is spent. On a weak hit, as above, but the wearer adds +1 when making a move (instead of +2)."],
			True
		],
		assetAbility[2, "", p["As above, and you may instead fashion a charm which aids the wearer against all supernatural threats, such as mystic rituals or horrors."]],
		assetAbility[3, "", p["When you perform this ritual, add +1 and take +1 momentum on a hit."]]
	},
	{
		1
	},
	<||>,
	18
];

assetData["Tether"] = assetRecord[
	"Tether",
	"Ritual",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you commune with the spirits of a place, roll +heart. If you share a bond with someone there, add +1. On a strong hit, you are tethered. When you ", i["Undertake a Journey"], " to return, you may roll +spirit or +heart (instead of +wits), and take +1 momentum on a hit. When you ", i["Reach Your Destination"], ",", " take +2 momentum on a strong hit. The tether is lost if you perform this ritual elsewhere, or when you ", i["Face Desolation"], ".", " On a weak hit, as above, but the spirits reveal a disturbing aspect of the place; ", i["Endure Stress"], " (2 stress)."],
			True
		],
		assetAbility[2, "", p["As above, and you may also reroll any dice when you ", i["Sojourn"], " in the tethered place."]],
		assetAbility[3, "", p["When you perform this ritual, add +1 and take +1 momentum on a hit."]]
	},
	{
		1
	},
	<||>,
	18
];

assetData["Totem"] = assetRecord[
	"Totem",
	"Ritual",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you hold a totem of your animal or beast companion and focus on it, roll +heart. On a strong hit, you are bound together. Add +1 and take +1 momentum on a hit when you use a companion ability. If you roll a 1 on your action die when using a companion ability, the magic is spent. On a weak hit, as above, but creating this connection is unsettling; ", i["Endure Stress"], " (1 stress)."],
			True
		],
		assetAbility[2, "", p["As above, and you may also perceive the world through your companion\[CloseCurlyQuote]s senses while you make moves aided by them (even when you are apart)."]],
		assetAbility[3, "", p["When you perform this ritual, add +1 and take +1 momentum on a hit."]]
	},
	{
		1
	},
	<||>,
	18
];

assetData["Visage"] = assetRecord[
	"Visage",
	"Ritual",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			p["When you paint yourself in blood and ash, roll +wits. On a strong hit, you may add +2 and take +1 momentum on a hit when you ", i["Secure an Advantage"], " or ", i["Compel"], " using fear or intimidation. If you roll a 1 on your action die when making a move aided by your visage, the magic is spent. On a weak hit, as above, but the blood must be your own; ", i["Endure Harm"], " (2 harm)."],
			True
		],
		assetAbility[2, "", p["As above, and you may also add +1 when you ", i["Strike"], ",", " ", i["Clash"], ",", " or ", i["Battle"], "."]],
		assetAbility[3, "", p["When you perform this ritual, add +1 and take +1 momentum on a hit."]]
	},
	{
		1
	},
	<||>,
	18
];

assetData["Ward"] = assetRecord[
	"Ward",
	"Ritual",
	None,
	<||>,
	{
		assetAbility[
			1,
			"",
			choiceSection[
			{p["When you walk a wide circle, sprinkling the ground with salt, roll +wits. On a strong hit, choose two. On a weak hit, choose one."]},
			{
				choice["when-a-foe-first-crosses-the-boundary-take-1-momentum", p["When a foe first crosses the boundary, take +1 momentum."]],
				choice["when-you-first-inflict-harm-against-a-foe-within-the-boundary-inflict-1-harm", p["When you first inflict harm against a foe within the boundary, inflict +1 harm."]],
				choice["your-ward-is-likely-ask-the-oracle-to-trap-a-foe-within-the-boundary", p["Your ward is \[OpenCurlyQuote]likely\[CloseCurlyQuote] (", i["Ask the Oracle"], ")", " to trap a foe within the boundary."]]
			},
			{}
		],
			True
		],
		assetAbility[2, "", p["As above, and improve the effect of your ward (+2 momentum, +2 harm, and \[OpenCurlyQuote]almost certain\[CloseCurlyQuote])."]],
		assetAbility[3, "", p["When you perform this ritual, add +1 and take +1 momentum on a hit."]]
	},
	{
		1
	},
	<||>,
	18
];


(* ::Subsection::Closed:: *)
(*Rarity costs*)


assetRarityCosts = <|
	"Alchemist" -> 5,
	"Animal Kin" -> 3,
	"Banner-sworn" -> 4,
	"Battle-scarred" -> 3,
	"Blade-bound" -> 4,
	"Bonded" -> 3,
	"Dancer" -> 3,
	"Devotant" -> 3,
	"Empowered" -> 3,
	"Fortune Hunter" -> 4,
	"Herbalist" -> 3,
	"Honorbound" -> 3,
	"Improviser" -> 4,
	"Infiltrator" -> 5,
	"Loyalist" -> 3,
	"Masked" -> 5,
	"Oathbreaker" -> 3,
	"Outcast" -> 3,
	"Pretender" -> 5,
	"Revenant" -> 3,
	"Rider" -> 4,
	"Ritualist" -> 3,
	"Shadow-kin" -> 3,
	"Sighted" -> 4,
	"Slayer" -> 3,
	"Spirit-bound" -> 3,
	"Storyweaver" -> 4,
	"Trickster" -> 4,
	"Veteran" -> 3,
	"Waterborn" -> 3,
	"Wayfinder" -> 4,
	"Weaponmaster" -> 3,
	"Wildblood" -> 4,
	"Wright" -> 3,
	"Archer" -> 4,
	"Berserker" -> 5,
	"Brawler" -> 5,
	"Cutthroat" -> 3,
	"Duelist" -> 3,
	"Fletcher" -> 4,
	"Ironclad" -> 5,
	"Long-arm" -> 5,
	"Shield-bearer" -> 4,
	"Skirmisher" -> 4,
	"Slinger" -> 4,
	"Sunderer" -> 4,
	"Swordmaster" -> 4,
	"Thunder-bringer" -> 4,
	"Augur" -> 3,
	"Awakening" -> 4,
	"Bind" -> 5,
	"Communion" -> 3,
	"Divination" -> 3,
	"Invoke" -> 5,
	"Keen" -> 5,
	"Leech" -> 3,
	"Lightbearer" -> 4,
	"Scry" -> 3,
	"Shadow-walk" -> 4,
	"Sway" -> 3,
	"Talisman" -> 4,
	"Tether" -> 4,
	"Totem" -> 4,
	"Visage" -> 4,
	"Ward" -> 3
|>;

KeyValueMap[
	If[KeyExistsQ[assetData, #1], assetData[#1] = Join[assetData[#1], <|"RarityCost" -> #2|>]] &,
	assetRarityCosts
];


(* ::Subsection::Closed:: *)
(*Private context footer*)


End[];


(* ::Section::Closed:: *)
(*Package footer*)


EndPackage[];
