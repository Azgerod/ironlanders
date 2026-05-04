(* ::Package:: *)

(* ::Title:: *)
(*Display Helpers*)


(* ::Text:: *)
(*Internal helpers and API implementations for rendering dice, rolls, moves, choices, assets, vows, progress cards, scenes, delves, bonds, and character sheets.*)
(*This package exposes a small display API for IronLibrary.wl and keeps its implementation in its own private context.*)


(* ::Section::Closed:: *)
(*Package header*)


BeginPackage["IronLibrary`DisplayHelpers`", {"MoveData`", "AssetData`"}];


(* ::Section::Closed:: *)
(*Public helper API*)


displayCharacterSheet::usage = "displayCharacterSheet is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayMove::usage = "displayMove is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayMoveChoice::usage = "displayMoveChoice is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayOracleQuery::usage = "displayOracleQuery is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayActionRoll::usage = "displayActionRoll is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayMomentumBurn::usage = "displayMomentumBurn is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayProgressRoll::usage = "displayProgressRoll is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayReroll::usage = "displayReroll is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayRarityDieSix::usage = "displayRarityDieSix is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayAssetCard::usage = "displayAssetCard is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayAssetCards::usage = "displayAssetCards is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayOwnedAssets::usage = "displayOwnedAssets is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayAssetReferences::usage = "displayAssetReferences is part of the internal DisplayHelpers API used by IronLibrary.wl.";
assetReferenceCard::usage = "assetReferenceCard is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayVowCard::usage = "displayVowCard is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayVowCards::usage = "displayVowCards is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayProgressObject::usage = "displayProgressObject is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayProgressObjectCard::usage = "displayProgressObjectCard is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayProgressObjectCards::usage = "displayProgressObjectCards is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayBondCard::usage = "displayBondCard is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayBondCards::usage = "displayBondCards is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displaySceneCard::usage = "displaySceneCard is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayScene::usage = "displayScene is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayDelveCard::usage = "displayDelveCard is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayDelve::usage = "displayDelve is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayDelves::usage = "displayDelves is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayDenizensMatrix::usage = "displayDenizensMatrix is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayRiskZoneCard::usage = "displayRiskZoneCard is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayDenizenRoll::usage = "displayDenizenRoll is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayReturnToSiteRoll::usage = "displayReturnToSiteRoll is part of the internal DisplayHelpers API used by IronLibrary.wl.";


(* ::Section::Closed:: *)
(*Private implementation*)


(* ::Subsection::Closed:: *)
(*Private context header*)


Begin["`Private`"];

If[
	!MemberQ[$Packages, "OracleTables`"],
	With[
		{dir = If[StringQ[$InputFileName] && $InputFileName =!= "", DirectoryName[$InputFileName], Directory[]]},
		Get[FileNameJoin[{dir, "OracleData.wl"}]]
	]
];

$ContextPath = DeleteDuplicates[Join[$ContextPath, {"OracleTables`", "IronLibrary`"}]];


(* ::Subsection::Closed:: *)
(*Local display data helpers*)


symString[symbol_] := ToLowerCase[SymbolName[symbol]];

ranks = {Troublesome, Dangerous, Formidable, Extreme, Epic};

debilityLabel[debility_] :=
	SymbolName[Unevaluated[debility]];

displayMomentumReset[characterData_Association] :=
	Max[0, 2 - Length[Lookup[characterData, "debilities", {}]]];

displayMomentumMax[characterData_Association] :=
	10 - Length[Lookup[characterData, "debilities", {}]];

makeProgressObject[name_String, rank_, progress_:0] :=
	Association[
		"Name" -> name,
		"Rank" -> rank,
		"Progress" -> Clip[progress, {0, 10}]
	];

assetDataAssociation[] := AssetData`assetData;

assetRecord[name_String] :=
	Lookup[assetDataAssociation[], name, Missing["UnknownAsset", name]];

assetFieldKeys[record_Association] :=
	Keys[Lookup[record, "Fields", <||>]];

defaultAssetAbilities[record_Association] :=
	Lookup[record, "DefaultAbilities", {}];

initialAssetTracks[record_Association] :=
	Association @ KeyValueMap[
		#1 -> Lookup[#2, "Default", Lookup[#2, "Max", 0]] &,
		Lookup[record, "Tracks", <||>]
	];

normalizeAssetFields[fields_Association, record_Association] := Module[
	{keys, blankFields},
	keys = assetFieldKeys[record];
	blankFields = AssociationThread[keys -> ConstantArray["", Length[keys]]];
	Join[blankFields, KeyTake[fields, keys]]
];

defaultDenizens[] :=
	ConstantArray[None, 12];

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

delveThemes = {"Ancient", "Corrupted", "Fortified", "Hallowed", "Haunted", "Infested", "Ravaged", "Wild"};
delveDomains = {"Barrow", "Cavern", "Frozen Cavern", "Icereach", "Mine", "Pass", "Ruin", "Sea Cave", "Shadowfen", "Stronghold", "Tanglewood", "Underkeep"};

normalizeDelveCards[cards_String, _] := {cards};
normalizeDelveCards[cards : {__String}, _] := cards;
normalizeDelveCards[_, _] := $Failed;

rollOracleDice[] := RandomInteger[{1, 10}, 2];

oracleRollValue[{tensDie_Integer, onesDie_Integer}] := Module[{tensValue, onesValue},
	tensValue = If[tensDie == 10, 0, tensDie*10];
	onesValue = If[onesDie == 10, 0, onesDie];
	If[tensDie == onesDie == 10, 100, tensValue + onesValue]
];

oracleRollOutcome[table_Association, value_Integer] := Module[{key},
	key = First[Select[Sort[Keys[table]], # >= value &]];
	table[key]
];

oracleRollData[table_Association] := Module[{oracleDice, od1, od2, value, outcome, match},
	oracleDice = {od1, od2} = rollOracleDice[];
	value = oracleRollValue[oracleDice];
	outcome = oracleRollOutcome[table, value];
	match = od1 == od2;
	<|"oracleDice" -> oracleDice, "value" -> value, "outcome" -> outcome, "match" -> match|>
];

oracleRoll[tableName_String, table_Association] := Module[{roll},
	roll = oracleRollData[table];
	displayOracleRoll[tableName, roll["oracleDice"], roll["match"], roll["outcome"]];
	roll
];



(* ::Subsection::Closed:: *)
(*Presentation helpers*)


(* ::Subsubsection::Closed:: *)
(*Scaling*)


$ironDisplayScale = 0.8;
scaled[n_?NumericQ] := $ironDisplayScale n;

scaledSize[n_?NumericQ] := Round[scaled[n]];


(* ::Subsubsection:: *)
(*Shared layout constants*)


rollHeaderBodyGap = scaled[3];
rollBodyResultGap = scaled[3];


(* ::Subsubsection::Closed:: *)
(*Text styles*)


dieStyle[n_] := Style[
	n,
	GrayLevel[0.255],
	FontSize -> 21,
	FontFamily -> "Futura",
	FontWeight -> Bold
];

mainStyle[n_] := Style[
	n,
	GrayLevel[0.255],
	FontSize -> scaledSize[42],
	FontFamily -> "Futura",
	FontWeight -> Bold
];

titleStyle[x_] := Style[
	x,
	FontFamily -> "Futura",
	FontSize -> scaledSize[32],
	FontWeight -> Bold,
	GrayLevel[0.255]
];

subtitleStyle[x_] := Style[
	x,
	FontFamily -> "Futura",
	FontSize -> scaledSize[26],
	GrayLevel[0.4]
];

moveTextStyle[x_String] := Style[
	x,
	FontFamily -> "Times New Roman",
	FontSize -> scaledSize[18]
];

moveTextStyle[x_] := Style[
	x,
	FontFamily -> "Times New Roman",
	FontSize -> scaledSize[18]
];


(* ::Subsubsection::Closed:: *)
(*Image assets and outcome styling*)


emptyD6Image = Image[CompressedData["\n1:eJztnU9v03YYx6Oxw459CewdcNzNsU1Iy7+EVqTtAWhRU0TLCmqQpgGCllO6\nSyqB4ETpYblVGlKvVOMdbL1X2k69bu/A8zeppTQLjhP/7Mfx832kD1KrisrP\nx88fx5V+399/PLv6TaFQaHzn/zO7/JO9ubn889\
yU/8XtjcbDBxv1lZmNp/UH\n9c0f7l/wv7nq88Ln28LkRskqXXKKzisyGLfoVipWZUraU5woW+WLuBa76Pzl\n45Gh/ONYTlXa26jh36v37KL7WwbyN5H4zp9IOxwW6Nd20W7hHpXOVx5wLbco\n7bQ/MG+6tez8IZ2f3GE5n6T9BoF7z6/ljzZrOVEkHZ/tXo9tw7vXnTt\
3VVCp\nVEfODXKetmc8J5jYveZr896j9Udes9n03r177x0eHqqg2dzx7vq+x8lZWjMc\n95WJ3QvXub217bV/bYvnPU0ODg68Z8+ej1XTafk2tXvhGhubDXWOwd7ent/D\nfgzNz2W35FVuVry5uTlv9tas5zqXU/VtavdaWal7rVZLPOcSROnZ5SvTHb+L\ni4vnqFZvJe\
7b1O6FWka/Rv+SznnatNvtoT0btXv16jWvVqv9z3MA6jwp3yZ2\nr+nyTGfv+vBhTzznErz3d82oPXthYeGrnpPybXL3wm6tsZYBejaeMcJyNDM9\n0/E3zLFp3z271+9x+7XW3QsEPRs9LaxnX792PbRnJ+X77DPsj3FrWfPuBaL2\nbOxaUXq2Sd+oZe5e8cF1J9WzTfn\
Gu9I4nrXvXgA9u9F4mmjPNuG727vH69va\ndy98LrK9/XpoLV8plTs927TjcXyPWtcady/ULmbxbmu3s3fVV1ZD6zgAz8wm\ne3Zc334fX4ozq8mA3Po9+8aNm4n07Li+bcvdlc5PnsAOFnfPTta380U6R3kB\nvVvCc1K+sVeuPVxXx9K95aG5wTsMSdcmfa+trXvHx8fe\
6empat68efvVHKW1\nkyXtG/e2dJ6zBJ6/+nOEZy1p16Z8f/58JJ7jrNHf37GLS7s25Vs6t1lkZ+eX\nczka9LcHk+gbc1s6t1nkbd8cz8Lspm/6pm/6pm/6pm/6JvStFfrWBX3rgr51\nQd+6oG9d0Lcu6FsX9K0L+tYFfeuCvnVB37qgb13Qty7oWxf0rQv61gV964K+\
\ndUHfuqBvXdC3LuhbF/StC/rWBX3rgr51Qd+6oG9d0Lcu6FsX9K0L+tYFfeuC\nvnVB37qgb13Qty7oWxdZ9Y1zZelbj2+cqUHfOnyH9XL6zpdvnH+FM2fpO/++\n4Rrnp4S5pu98+MbvHVbXAWWrfJG+J9M3zp2NUtO9FM6CvifDN/o2zkGKWs/n\nsJx9+p4M3zhzFud\
U4gzakT33zW76zq5v/J84e3ZcxwE4/7nQE/SdLd/jzOZB\nFC3nb991tdAX9C3vO9ZsHux5qWJVpvpd07esb8xmnLkcZzb37GRfBtUzfcv7\nxs9jB4vtuOt5v2SVLg3zTN/p+8ZsDnunEb1n2//alr0VfIYyStB3fN9h58Vi\nNuM9ZRqzOa7v2u158dxmkX7fmMFZmM1x\
fYOTkxPx/GYN9L3eHMFp0NMlZ7MJ\n3zjrWjq/WeLo6MiMy9DZ7O6OM5tN+AboX9J5zgJwjR6djOfObH4SZzab8h3M\n8lcvtzrutYEe19/DjdGdzUtJOh7HNzHueb/3PUaKvj+JX7sSkp7NUQIzQzoP\neSet2RwlcK9J5yO3pDybowY+mxPPTZ7wZ6TEbB4lMFfE8zTBd\
Gezsy85m0cN\n3JPc30b17PyZldnMYPTGf7vRtU8=\n"], "Byte", ColorSpace -> "RGB", Interleaving -> True];
Options[d6Image] = {Cancelled -> False};
d6Image[n_Integer /; 1 <= n <= 6, opts : OptionsPattern[]] := Module[{die},
	die = ImageCompose[
		emptyD6Image,
		Rasterize[dieStyle[n], Background -> None],
		Scaled[{0.36 - If[n == 4, 0.01, 0], 0.42}]
	];
	die = If[
		OptionValue[Cancelled],
		ImageCompose[
			die,
			Rasterize[
				Style["\[Times]", GrayLevel[0.255], FontSize -> scaledSize[110]],
				Background -> None
			],
			Scaled[{0.5, 0.81}]
		],
		die
	];
	ImageResize[die, Scaled[$ironDisplayScale]]
];
emptyD10Image = Image[CompressedData["\n1:eJztnctuFEcUhq0kiyx5BPIGWWbX7jHGmJuNHTu2FJQxwuGSQBwwCpFQ4mXI\nJkh4DVmSVRBrLFjFSzBbkGDFFt5gMv/YbY3L3VOnLt11qvr80kE2sj1V1V/V\nX13nTM8XF36a+/6TsbGxm5/3/5lb+SW/cWPl1\
/kj/W8Wrt+8cun66sXp6+ur\nl1ZvfHXh0/5/3uvHH/34bEwkEo3SVDZ1NB/P/8rHO8/68aEfL/rfP5zIJsZD\nt00UVp2s0+3z0BsRz2aymSOh2ylqXnmWb2jYKOKFMNIuEdYNYaSlsmBjn5HQ\nbRfVKwc29iJ/GLoPono0mU1+6caGMJKq9tj44IcPYSQl+WdjN/petR\
a6byI3\n7Z59+WdjiJFu6D6K7IT70XxwFloPG8JIvLJh49b6rd7Tp1u9+/c3e6dPnTZl\nZDZ0n0U02bLx/v37/QAnhuvIB+xzQvddpFc+PvGvybXFWvH69esDfCDu3v1T\nGElMuO803T88efLkEBsIMLO48I0wkohs2FB9RQ0Ln0G8lVwNL+XZxD3T61jl\nKx58BiH5P\
CayzalU+YonnxFGGMiWDZ2vePKZASOhx6itsmWD6iuefKYnuZrm\nRc3FTh47bu0rFJ+ZPnGy9DWEkXCi5tsWvl48dO1MfYXiMyvdFVlHmIjKxvLS\n8iB8+IrOZ8Dg6sVVEiOS861PVDbOzc711tZ+9uYrFJ/BWnX58hUqI93QY5ma\nqDmVM6fP9m7fvj3YF/j0FTXAmv\
ra1368JowEkAkbd+7c6Z3/9nwtvqIGmFN9\npuz1RzAiOV9HmbJRp6+U+YxaBwCf2djYOLT3qQjJ1Tgq333P48hxxrxdX18f\n8FG3r1B9RhipX5R8W8EGrkdTvkL1GbQJ64kw4l+mbJT5yqNH/9TOhs5nwAm8\nj8CI5HyJoubp19bW9q+B6itXr/7QCBsUnzFgRPJ5GlF\
zKriPxNhX+crOzk6j\nfOh8Rhhxlw0bZb7y4MGDxtmo8hmwW7QV5zK0XI3kfFXZsMHBVyg+A4aLNmO/\nJPk8M+E5PRQ2cL9YjDMnX9H5DBgufEYYMZNJvm2YDU6+YuozBSOUOdFmRmzZ\n4Ogrpj6DMMjVtC7na1LDMTymCLXegouvmPqMISPd0NesKZnmVA6uy7cO/RwX\
\nX7HxGWHkoFzYQKhnCNx8xcZnyvbaIxhJNufrykYsvmLjM5LPG+RitWzgvg/n\nSOrYxeQraoBhis+0mRHTfFvsvqIGWKb4TBtzvq5sxOoraoBpis+0KedLzcVW\nsRGzr6hh4jNtyOfhXIfCxnBOJTVfUcPEZ1JmxCbfpvMVRIy+ogbVZ1LN+fpg\no8xXNu9vBr+2PsL\
EZ1LL5+H8hsLGqPEo85XudyvBr6vPKPMZzImUGbHNt1F8\nZfu/7eDX1HeoPoM5MWpcYs75+mIjZV9Ro8xnMDdGjU+MOV+XXGzbfEUNU58x\nZKQbmo29nMpbXVurcipt9BU1TH0mFkZc8226+7hUfUUNG5+pmk8VjDSe8/XJ\nBgLPZGiTr6hh4zMIrvk8ChtVuVjxlfIo\
8xnK3OLGiGu+bTjwHjP1d9viK2rA\nZ9SxoOzpOTHikw3kHcrOfFI4Q7cNtZYIoTsTQHDI+fpk40rF/jv2/JtrYO0s\nGxfPjHjP5/nIxVL23XiuV+hrxJEPBPbwuv1ICEZ85NuKtqv3KWWxtbUV/DqF\nCt1zvLE+V9UDDI8zNefryogvNrBmENs8OAtoGyNv3rzp/f7bB\
ml8Cr8ZdW/Y\nRD6PykbVWQ44xnNB1fe6UQN7kdQ5ebXzavA8VdPPM6NwUicjLvk2tBf/T10v\ndIE1F88CwhwLfT19Bbgvu1exDfh28Tyauhlxec80sfbaKjDHMNcw50JfX9sA\n5zgbrmuMsFbj3nB4H0vN1eRZvlEHG2iPzkMmOsd6J0+e6s2cnenNz88PYnl5\nuc/T\
wuDr2dlzg+uPn6P0BXMvFu8Bz5sGn4k5fWL6wDgtLi7ufz13bm7wd45N\nTI78G1gzUINVeI+PfN5eTkXLBu6fkBug7DnRD/R1aWlpwAMlwMrU8ROk/nD2\nHvBL3XNiXpw5c3bAAnWcwAplnDCXsba7MELNt4EHioeg3Wg/ta9lgbUFaw6l\nT5hTmKMcvMfEQ45PTg3mQ\
xPjhHlNPBvpqefw8B7K7+kC7UR7XfqrBtYezC2q\n92DONu09WL9MPATjVHhsqHHSxNsDfBBqfKoCHoJ2mXiIbWCuYc5R2oU5XPcz\nULe3t2v1kCbGqbK92cT40J7U+Pd9rI22gbkX0nvAnZqPHzV/YhinQ7F3P0N9\nPlyda6NtYC425T2Fh1A/yxL3IZzGyeT+0IYP/G\
0u/S0LzFHdfV8RmPtU7zH1\nEFyHJjzEJrAHIPvO0HnIeJZ/pKzToftHCTCMuUudJ2AF525YG4YDZyzUtaLw\nkCb2YK4Bdil9Gq5bzbPO37qfD+WhLuNgvKYaBicPoQYY1vVrPOu8G87t4mvd\nGoKxCN032/Ew8R6Kh2APxtVDdIHzSpO1Y/hsXcdIbGuIGpjr1LPZMi5\
Mz4K5\nxcLCgn49zSbuVZ2xU/aqsTOCQB9M2MB6ETMXCNLetL/PqGKjEKXuw/XsnENQ\nGQEbodvKhQ0qI1ijsFaF7rdr4OxkVD+xZ5F1o72MYOxG7VtjuzexYaN/r/LS\nlI02MVKVUwM3odvmGrq9ONhwrVHWnY3EzgjWiLJ+xXIeWBW6vIsPNqiMxOzT\nVedF2JuEbl\
sMbFAZgc/FykhKfBDYeFfbeywTZSQVPvRs5B9rf4921nmeGiMp\n8KE7z2mCDWg3V9N5qWMk9Hi1iQ8ubJgwEtO5Y8x8cGMjRUZi5YOSIwj5mVOp\nMBIjH1XnNgob3VBsFJrKpo7q6gK4MxIbH5Q8PQc2ClFqRziPd0ztjY2NQjHX\nF8XCB5ENNs/WVhUrIzHwQav9Ms/\
TNy3K+624McKdj7pqOEKJUoPGiRHOfKTG\nRqGYake48pEqG4ViYYQjH0Q2noe+xq6KgRGOfFDqAmP73Moq4T0VnBnhxkeI\n+p7QotQphqoL4MRHG9koxLW+iAsfbWajEEdGOPDBofaLi/qMPObESGg+dO+Z\nbhMbELUGrSlGQvLBtb4ntDjVjoTiQ9gYLS6MhOCDUvtV\
PEOwzeLASNN84PkH\nOjY41nCEUugatCb5iLW+J7RC1qA19VrChptC1Rc1wYew4UchGKmbj1Rqv7io\n6Rq0OvnQPYNG2LBTkzVodfGRen1PaDVVO1IHH8JGM2qCEd98tKX2i4vqZsQ3\nH22q/eIi3WdcuTDikw+p4QinumrQfPEhbIRXHfVFPvgQNvjINyOufEjtFz/5\
\nZMSFD6n94imfNWi2fEh9D2/5qh2x4UPYiEM+GDHlg1L7JWzwkSsjJnxI7Vec\nonyGXhUjVD6khiNu2dagUX5O2EhDNvVFOj6EjbRkysgoPlw/81HEU1RGcP2r\n+JC6wLRFqUGrqv0DF8JG+qIwYhXCRjLyzkjWeRy6TyK/8sWI5OnTla4GTdgQ\n6eoChA2RKSPCRvt\
EZQRnKHi+QOj2ipqX7rmsWDeEjXYLz+jBWjJ81gouJJ8i\nEun1P17oOAA=\n"], "Byte", ColorSpace -> "RGB", Interleaving -> True];
Options[d10Image] = {Cancelled -> False};
d10Image[n_Integer /; 1 <= n <= 10, opts : OptionsPattern[]] := Module[{die},
	die = ImageCompose[
		emptyD10Image,
		Rasterize[dieStyle[If[n == 10, 0, n]], Background -> None],
		Scaled[{0.5 - If[n == 4, 0.01, 0], 0.66}]
	];
	die = If[
		OptionValue[Cancelled],
		ImageCompose[
			die,
			Rasterize[
				Style["\[Times]", GrayLevel[0.255], FontSize -> scaledSize[150]],
				Background -> None
			],
			Scaled[{0.5, 0.8}]
		],
		die
	];
	ImageResize[die, Scaled[$ironDisplayScale]]
];
$outcomeColors = Association["miss" -> RGBColor[0.72, 0.22, 0.22], "weakHit" -> RGBColor[0.78, 0.55, 0.15], "strongHit" -> RGBColor[0.3, 0.55, 0.3]];
$outcomeLabels = Association["miss" -> "Miss", "weakHit" -> "Weak Hit", "strongHit" -> "Strong Hit"];
actionRollResultDisplay[result_String, match_] := Module[{color, label}, color = Lookup[$outcomeColors, result, GrayLevel[0.4]]; label = ToUpperCase[Lookup[$outcomeLabels, result]];
    Style[StringJoin[label, If[match, " (MATCH)", ""]], FontFamily -> "Futura", FontWeight -> Bold, FontSize -> scaledSize[42], FontTracking -> "Wide", color]]


(* ::Subsubsection::Closed:: *)
(*Math column*)


scoreCircle[score_Integer /; 1 <= score <= 10] := Module[{circle},
	circle = ImageCompose[
		Graphics[
			{
				EdgeForm[{GrayLevel[0.255], AbsoluteThickness[6]}],
				FaceForm[GrayLevel[0.9]],
				Disk[{0, 0}, 1]
			},
			ImageSize -> 135,
			PlotRange -> {{-1.1, 1.1}, {-1.1, 1.1}}
		],
		Rasterize[
			dieStyle[score],
			Background -> None
		],
		Scaled[{0.5, 0.5}]
	];

	ImageResize[circle, Scaled[$ironDisplayScale]]
];
rollColumn[actionScore_, challengeDice_List, challengeDiceCancelled_:Automatic] := Module[{cancelled, dice, sortedDice},
    cancelled = Replace[challengeDiceCancelled, Automatic :> ConstantArray[False, Length[challengeDice]]];
     dice = Join[{{actionScore, 0, scoreCircle[actionScore]}}, MapThread[{#1, 1, d10Image[#1, Cancelled -> #2]} & , {challengeDice, cancelled}]];
     sortedDice = Last /@ ReverseSortBy[dice, {#1[[1]], #1[[2]]} & ]; Column[sortedDice]];
rollFrameStyle := Directive[
	GrayLevel[0.25],
	AbsoluteThickness[scaled[4]]
];

mathCoreWidth := scaled[200];
mathOperatorWidth := scaled[24];
mathValueWidth := scaled[60];
mathOpValueGap := scaled[6];
mathReasonGap := scaled[0];
mathDieAddGap := scaled[0];
mathReasonYOffset := scaled[-0.4];
mathDieXOffset := scaled[34];

mathOperator[x_] := mainStyle[x];
mathValue[x_] := mainStyle[x];
mathLabel[x_] := RawBoxes[AdjustmentBox[ToBoxes[Style[StringJoin["(", ToString[x], ")"], FontFamily -> "Futura", FontSize -> scaledSize[32], GrayLevel[0.35]]], BoxBaselineShift -> -mathReasonYOffset]];
mathCore[op_, value_] := Pane[Row[{Pane[mathOperator[op], {mathOperatorWidth, Automatic}, Alignment -> Center], Pane[mathValue[value], {mathValueWidth, Automatic}, Alignment -> Left]},
     Spacer[mathOpValueGap]], {mathCoreWidth, Automatic}, Alignment -> Center];
mathTermRow[op_, value_, source_] := {mathCore[op, value], mathLabel[source]};
mathResultRow[actionScore_] := {mathCore["=", actionScore], Spacer[0]};
offsetX[expr_, dx_] := Pane[expr, ImageMargins -> {{Max[dx, 0], Max[-dx, 0]}, {0, 0}}];
mathColumn[actionDie_Integer, statValue_Integer, adds_Association, actionScore_Integer, actionDieCancelled_, momentum_] := Module[{termRows, rows, dividerPosition, blankRow, dieGapRow},
    blankRow = {Spacer[{0, 4}], Spacer[{0, 4}]}; dieGapRow = {Spacer[{0, mathDieAddGap}], Spacer[{0, mathDieAddGap}]};
     termRows = Join[{mathTermRow["+", statValue, "Stat"]}, KeyValueMap[mathTermRow["+", #2, #1] & , adds]];
     rows = Join[{{Pane[offsetX[d6Image[actionDie, Cancelled -> actionDieCancelled], mathDieXOffset], {mathCoreWidth, Automatic}, Alignment -> Center],
         If[actionDieCancelled, mathLabel[StringJoin["Momentum ", ToString[momentum]]], Spacer[0]]}, dieGapRow}, termRows, {blankRow, blankRow, mathResultRow[actionScore]}];
     dividerPosition = 2 + Length[termRows] + 2; Grid[rows, Alignment -> {{Center, Left}}, Spacings -> {mathReasonGap, 0.6}, Dividers -> {False, {dividerPosition -> rollFrameStyle}}]];


(* ::Subsubsection::Closed:: *)
(*Headers*)


header[title_String] := titleStyle[title];
header[title_String, subtitle_String] := Column[{titleStyle[title], subtitleStyle[subtitle]}, Alignment -> Left, Spacings -> 0.5];


(* ::Subsubsection::Closed:: *)
(*Frames*)


ironFramed[x_] := Framed[
	x,
	FrameStyle -> rollFrameStyle,
	FrameMargins -> {{scaled[12], scaled[12]}, {scaled[12], scaled[12]}},
	RoundingRadius -> scaled[8],
	Background -> None
];

characterSheetFramed[x_] := Framed[
	x,
	FrameStyle -> rollFrameStyle,
	FrameMargins -> {{scaled[16], scaled[16]}, {scaled[16], scaled[16]}},
	RoundingRadius -> scaled[8],
	Background -> None
];


(* ::Subsubsection::Closed:: *)
(*Action roll display*)


displayActionRoll[roll_Association] := Print[ironFramed[Grid[{{Item[header["Action Roll", Capitalize[symString[roll["stat"]]]], Alignment -> Left], SpanFromLeft},
       {mathColumn[roll["actionDie"], roll["statValue"], roll["adds"], roll["actionScore"], roll["actionDieCancelled"], roll["momentum"]], rollColumn[roll["actionScore"], roll["challengeDice"]]},
       {Item[actionRollResultDisplay[roll["result"], roll["match"]], Alignment -> Center], SpanFromLeft}}, Dividers -> {None, {False, False, False, False}}, Alignment -> {{Left, Center, Center}, {Top, Top, Bottom}},
      Spacings -> {2, {Automatic, rollHeaderBodyGap, rollBodyResultGap}}, FrameStyle -> None]]];


(* ::Subsubsection::Closed:: *)
(*Momentum burn display*)


displayMomentumBurn[burn_Association] := Print[ironFramed[Column[{Item[header["Momentum Burn", StringJoin[ToString[burn["momentum"]], " \[Rule] ", ToString[burn["momentumReset"]]]], Alignment -> Left],
       Item[rollColumn[burn["actionScore"], burn["challengeDice"], burn["challengeDiceCancelled"]], Alignment -> Center],
       Item[actionRollResultDisplay[burn["result"], If[AllTrue[burn["challengeDiceCancelled"],  !#1 & ], burn["match"], False]], Alignment -> Center]},
      Spacings -> {2, {Automatic, rollHeaderBodyGap, rollBodyResultGap}}]]];


(* ::Subsubsection::Closed:: *)
(*Progress roll display*)


displayProgressRoll[roll_Association] := Print[ironFramed[Grid[{{Item[header["Progress Roll", roll["trackName"]], Alignment -> Left]},
       {rollColumn[roll["progressScore"], roll["challengeDice"], {False, False}]}, {Item[actionRollResultDisplay[roll["result"], roll["match"]], Alignment -> Center]}},
      Alignment -> {{Center}, {Center, Top, Center}}, Spacings -> {2, {Automatic, rollHeaderBodyGap, rollBodyResultGap}}]]];


(* ::Subsubsection::Closed:: *)
(*Oracle roll display*)


displayOracleRoll[table_String, {d1_, d2_}, match_, outcome_String] :=
   Print[ironFramed[Grid[{{Item[header["Oracle Roll", table], Alignment -> Left], SpanFromLeft}, {Item[Grid[{{Item[d10Image[d1], Alignment -> Right], Item[d10Image[d2], Alignment -> Left]}},
          Alignment -> {{Right, Left}, Center}, Spacings -> {0, 0}], Alignment -> Center], SpanFromLeft}, {Item[Rotate[mainStyle["\[Rule]"], -(Pi/2)], Alignment -> Center], SpanFromLeft},
       {Item[mainStyle[StringJoin[outcome, If[match, " (MATCH)", ""]]], Alignment -> Center], SpanFromLeft}}, Alignment -> {{Center}, {Center, Top, Center}},
      Spacings -> {0, {Automatic, rollHeaderBodyGap, 1, 2}}]]];

oracleDiceDisplay[{d1_, d2_}] :=
	Grid[
		{{Item[d10Image[d1], Alignment -> Right], Item[d10Image[d2], Alignment -> Left]}},
		Alignment -> {{Right, Left}, Center},
		Spacings -> {0, 0}
	];

oracleComponentRoll[label_String, table_Association] :=
	Join[<|"label" -> label|>, oracleRollData[table]];

displayCompositeOracleRoll[title_String, components_List, result_String] :=
	Print[
		ironFramed[
			Column[
				{
					header["Oracle Roll", title],
					Grid[
						({
							Style[#["label"], FontFamily -> "Futura", FontSize -> scaledSize[14], FontWeight -> Bold, GrayLevel[0.255]],
							oracleDiceDisplay[#["oracleDice"]],
							moveTextStyle[StringJoin[#["outcome"], If[#["match"], " (MATCH)", ""]]]
						} &) /@ components,
						Alignment -> {{Left, Center, Left}, Center},
						Spacings -> {1.2, 0.8}
					],
					mainStyle[result]
				},
				Spacings -> {1.0, 0.8},
				Alignment -> Left
			]
		]
	];

displayReturnToSiteRoll[roll_Association] :=
	Print[
		ironFramed[
			Grid[
				{
					{Item[header["Return to Site", roll["delveName"]], Alignment -> Left]},
					{Item[Column[d10Image /@ ReverseSort[roll["challengeDice"]], Spacings -> 0], Alignment -> Center]},
					{Item[mainStyle[StringJoin["Lower die: ", ToString[roll["lowerDie"]]]], Alignment -> Center]}
				},
				Alignment -> {{Center}, {Center, Top, Center}},
				Spacings -> {2, {Automatic, rollHeaderBodyGap, rollBodyResultGap}}
			]
		]
	];

displayRarityDieSix[roll_Association] :=
	Print[
		ironFramed[
			Column[
				{
					header["Rarity Die", "Rolled 6"],
					Item[d6Image[6], Alignment -> Center],
					Item[Rotate[mainStyle["\[Rule]"], -(Pi/2)], Alignment -> Center],
					Item[actionRollResultDisplay["strongHit", False], Alignment -> Center]
				},
				Spacings -> {Automatic, rollHeaderBodyGap, 0.8, rollBodyResultGap},
				Alignment -> Center
			]
		]
	];


(* ::Subsubsection::Closed:: *)
(*Reroll display*)


rerollDieLabel[ActionDie] := "Action die";
rerollDieLabel[ChallengeDice] := "Both challenge dice";
rerollDieLabel[LargerChallengeDie] := "Larger challenge die";
rerollDieLabel[SmallerChallengeDie] := "Smaller challenge die";
rerollDieLabel[other_] := ToString[Unevaluated[other]];

rerollSubtitle[selection_List] := Module[{labels},
	labels = rerollDieLabel /@ selection;
	If[
		Length[labels] == 1,
		First[labels],
		StringRiffle[Most[labels], ", "] <> " & " <> Last[labels]
	]
];

displayRerollActionRoll[roll_Association] :=
	Print[
		ironFramed[
			Grid[
				{
					{
						Item[
							header["Reroll", rerollSubtitle[roll["reroll", "selection"]]],
							Alignment -> Left
						],
						SpanFromLeft
					},
					{
						mathColumn[
							roll["actionDie"],
							roll["statValue"],
							roll["adds"],
							roll["actionScore"],
							roll["actionDieCancelled"],
							roll["momentum"]
						],
						rollColumn[
							roll["actionScore"],
							roll["challengeDice"]
						]
					},
					{
						Item[
							actionRollResultDisplay[roll["result"], roll["match"]],
							Alignment -> Center
						],
						SpanFromLeft
					}
				},
				Dividers -> {None, {False, False, False, False}},
				Alignment -> {{Left, Center, Center}, {Top, Top, Bottom}},
				Spacings -> {2, {Automatic, rollHeaderBodyGap, rollBodyResultGap}},
				FrameStyle -> None
			]
		]
	];

displayRerollProgressRoll[roll_Association] :=
	Print[
		ironFramed[
			Grid[
				{
					{
						Item[
							header["Reroll", rerollSubtitle[roll["reroll", "selection"]]],
							Alignment -> Left
						]
					},
					{
						rollColumn[
							roll["progressScore"],
							roll["challengeDice"],
							{False, False}
						]
					},
					{
						Item[
							actionRollResultDisplay[roll["result"], roll["match"]],
							Alignment -> Center
						]
					}
				},
				Alignment -> {{Center}, {Center, Top, Center}},
				Spacings -> {2, {Automatic, rollHeaderBodyGap, rollBodyResultGap}}
			]
		]
	];

displayReroll[roll_Association] :=
	If[
		KeyExistsQ[roll, "actionDie"],
		displayRerollActionRoll[roll],
		displayRerollProgressRoll[roll]
	];


(* ::Subsection::Closed:: *)
(*Move presentation helpers*)


(* ::Subsubsection::Closed:: *)
(*Move outcome*)


moveOutcome[move_String, result_String] := moves[move, result];


(* ::Subsubsection::Closed:: *)
(*Move section metadata*)


moveSectionText[section_Association] /; KeyExistsQ[section, "Text"] :=
	section["Text"];

moveSectionText[section_] :=
	section;

moveSectionChoices[section_Association] /; KeyExistsQ[section, "Choices"] :=
	section["Choices"];

moveSectionChoices[_] :=
	{};

moveOutputSubtitle[moveName_String, "header"] :=
	moveName;

moveOutputSubtitle[moveName_String, section_String] :=
	StringJoin[moveName, ": ", Lookup[$outcomeLabels, section, section]];

moveOutput[moveKey_String, sectionKey_String, section_] := Module[
	{moveName},
	moveName = moves[moveKey, "name"];
	MoveDisplayOutput[
		Association[
			"Move" -> moveKey,
			"Name" -> moveName,
			"Section" -> sectionKey,
			"Subtitle" -> moveOutputSubtitle[moveName, sectionKey],
			"Choices" -> moveSectionChoices[section]
		]
	]
];


(* ::Subsubsection::Closed:: *)
(*Move header presentation*)


displayMoveHeader[moveKey_String] := Module[
	{section},
	section = moves[moveKey, "header"];
	Print[
		Framed[
			Column[
				{titleStyle[moves[moveKey, "name"]], moveTextStyle[moveSectionText[section]]},
				Spacings -> 1
			],
			FrameStyle -> rollFrameStyle,
			FrameMargins -> {{12, 12}, {12, 12}},
			RoundingRadius -> 8,
			Background -> None
		]
	];
	moveOutput[moveKey, "header", section]
];


(* ::Subsubsection::Closed:: *)
(*Move outcome presentation*)


displayMoveOutcome[moveKey_String, result_String] := Module[
	{section},
	section = moves[moveKey, result];
	Print[
		Framed[
			Column[
				{
					header[moves[moveKey, "name"], Lookup[$outcomeLabels, result]],
					moveTextStyle[moveSectionText[section]]
				},
				Spacings -> 1
			],
			FrameStyle -> rollFrameStyle,
			FrameMargins -> {{12, 12}, {12, 12}},
			RoundingRadius -> 8,
			Background -> None
		]
	];
	moveOutput[moveKey, result, section]
];


(* ::Subsubsection::Closed:: *)
(*Combined move display*)


displayMove[moveKey_String]:=displayMoveHeader[moveKey];
displayMove[moveKey_String, roll_Association]:=displayMoveOutcome[moveKey, roll["result"]];


(* ::Subsubsection::Closed:: *)
(*Choice display*)


choiceSelectionIndices[n_Integer] :=
	{n};

choiceSelectionIndices[indices_List] /; VectorQ[indices, IntegerQ] && indices =!= {} :=
	indices;

choiceSelectionIndices[_] :=
	$Failed;

choiceDisplayBody[texts_List] :=
	If[
		Length[texts] == 1,
		First[texts],
		Column[texts, Spacings -> 0.8, Alignment -> Left]
	];

displayChoice[subtitle_String, texts_List] :=
	Print[
		ironFramed[
			Column[
				{
					header["Choice", subtitle],
					moveTextStyle[choiceDisplayBody[texts]]
				},
				Spacings -> 1
			]
		]
	];


(* ::Subsection::Closed:: *)
(*Character sheet display*)


characterSheetTab[title_String] :=
	Framed[
		Style[
			ToUpperCase[title],
			White,
			FontFamily -> "Futura",
			FontSize -> scaledSize[11],
			FontWeight -> Bold
		],
		Background -> GrayLevel[0.255],
		FrameStyle -> None,
		FrameMargins -> {{scaled[7], scaled[7]}, {scaled[2], scaled[2]}},
		RoundingRadius -> 0
	];

characterSheetSection[title_String, body_] :=
	Column[
		{
			characterSheetTab[title],
			body
		},
		Spacings -> 0.25,
		Alignment -> Left
	];

characterSheetLabel[text_String] :=
	Style[
		text,
		FontFamily -> "Futura",
		FontSize -> scaledSize[11],
		FontWeight -> Bold,
		GrayLevel[0.255]
	];

characterSheetSmallLabel[text_String] :=
	Style[
		text,
		FontFamily -> "Futura",
		FontSize -> scaledSize[10],
		FontWeight -> Bold,
		GrayLevel[0.4]
	];

characterSheetValue[value_] :=
	Style[
		value,
		FontFamily -> "Times New Roman",
		FontSize -> scaledSize[15],
		GrayLevel[0.255]
	];

characterSheetMetricValue[value_] :=
	Style[
		value,
		FontFamily -> "Futura",
		FontSize -> scaledSize[16],
		FontWeight -> Bold,
		GrayLevel[0.255]
	];

characterSheetInlineMetric[label_String, value_] :=
	Row[
		{
			characterSheetSmallLabel[StringJoin[label, ": "]],
			characterSheetMetricValue[value]
		}
	];

characterSheetInlineMetrics[pairs_List] :=
	Row[characterSheetInlineMetric @@@ pairs, Spacer[scaled[12]]];

characterSheetInfoLine[label_String, value_] :=
	Row[
		{
			characterSheetLabel[StringJoin[label, ": "]],
			characterSheetValue[value]
		}
	];

characterSheetStatsMetrics[characterData_Association] :=
	{
		{"Edge", characterData["edge"]},
		{"Heart", characterData["heart"]},
		{"Iron", characterData["iron"]},
		{"Shadow", characterData["shadow"]},
		{"Wits", characterData["wits"]}
	};

characterSheetResourcesMetrics[character_String, characterData_Association] :=
	{
		{"Health", characterData["health"]},
		{"Spirit", characterData["spirit"]},
		{"Supply", characterData["supply"]},
		{
			"Momentum",
			StringJoin[
				ToString[characterData["momentum"]],
				"/",
				ToString[displayMomentumMax[characterData]],
				" (reset ",
				ToString[displayMomentumReset[characterData]],
				")"
			]
		}
	};

characterSheetDebilityText[debilityList_List] :=
	If[
		debilityList === {},
		"None",
		StringRiffle[debilityLabel /@ debilityList, ", "]
	];

characterSheetExperienceValue[characterData_Association] := Module[
	{earned, spent},
	earned = Lookup[characterData, "earnedExperience", 0];
	spent = Lookup[characterData, "spentExperience", 0];
	StringJoin[ToString[spent], "/", ToString[earned]]
];

characterSheetStatusMetrics[characterData_Association] :=
	{
		{"Conditions", characterSheetDebilityText[Lookup[characterData, "debilities", {}]]},
		{"XP", characterSheetExperienceValue[characterData]}
	};

characterSheetOverviewSection[character_String, characterData_Association] :=
	characterSheetSection[
		"Overview",
		Grid[
			{
				{characterSheetLabel["Stats"], characterSheetInlineMetrics[characterSheetStatsMetrics[characterData]]},
				{characterSheetLabel["Resources"], characterSheetInlineMetrics[characterSheetResourcesMetrics[character, characterData]]},
				{characterSheetLabel["Status"], characterSheetInlineMetrics[characterSheetStatusMetrics[characterData]]}
			},
			Alignment -> {{Left, Left}, Center},
			Spacings -> {0.9, 0.25}
		]
	];

characterSheetAbilityMarks[record_Association, selectedAbilities_List] := Module[
	{indices},
	indices = assetAbilityIndices[record];
	If[indices === {},
		"\[LongDash]",
		Row[
			(
				Style[
					If[MemberQ[selectedAbilities, #], "\[FilledCircle]", "\[EmptyCircle]"],
					GrayLevel[0.255],
					FontSize -> scaledSize[13]
				] &
			) /@ indices,
			Spacer[scaled[3]]
		]
	]
];

characterSheetFieldDetails[record_Association, fields_Association] := Module[
	{fieldDefs, values},
	fieldDefs = Lookup[record, "Fields", <||>];
	values = KeyValueMap[
		Module[{value},
			value = Lookup[fields, #1, ""];
			If[StringQ[value] && StringLength[StringTrim[value]] == 0,
				Nothing,
				StringJoin[Lookup[#2, "Label", #1], ": ", ToString[value]]
			]
		] &,
		fieldDefs
	];
	values
];

characterSheetTrackDetails[record_Association, tracks_Association] := Module[
	{trackDefs, values},
	trackDefs = Lookup[record, "Tracks", <||>];
	values = Join[initialAssetTracks[record], tracks];
	KeyValueMap[
		StringJoin[
			Lookup[#2, "Label", #1],
			" ",
			ToString[Lookup[values, #1, Lookup[#2, "Default", 0]]],
			"/",
			ToString[Lookup[#2, "Max", Lookup[#2, "Default", 0]]]
		] &,
		trackDefs
	]
];

characterSheetAssetCategoryText[record_Association, rarity_] :=
	Column[
		DeleteCases[
			{
				characterSheetValue[Lookup[record, "Category", "Unknown"]],
				If[rarity === None,
					Nothing,
					characterSheetValue[StringJoin["Rarity: ", ToString[rarity]]]
				]
			},
			Nothing
		],
		Spacings -> 0.2,
		Alignment -> Left
	];

characterSheetAssetDetails[record_Association, owned_Association] := Module[
	{details},
	details = Join[
		characterSheetFieldDetails[record, Lookup[owned, "Fields", <||>]],
		characterSheetTrackDetails[record, Lookup[owned, "Tracks", <||>]]
	];
	If[
		details === {},
		characterSheetValue[""],
		characterSheetValue[StringRiffle[details, "   "]]
	]
];

characterSheetAssetRow[owned_Association] := Module[
	{record},
	record = assetRecord[owned["Name"]];
	If[!AssociationQ[record],
		Return[
			{
				characterSheetValue[owned["Name"]],
				characterSheetValue["Unknown"],
				characterSheetValue[""],
				characterSheetValue[""]
			}
		]
	];
	{
		characterSheetValue[owned["Name"]],
		characterSheetAssetCategoryText[record, Lookup[owned, "Rarity", None]],
		characterSheetAbilityMarks[record, Lookup[owned, "Abilities", {}]],
		characterSheetAssetDetails[record, owned]
	}
];

characterSheetGrid[headers_List, rows_List] :=
	Grid[
		Prepend[
			rows,
			characterSheetSmallLabel /@ headers
		],
		Alignment -> {{Left}, Top},
		Spacings -> {0.8, 0.25},
		Dividers -> {False, {2 -> GrayLevel[0.75]}}
	];

characterSheetAssetsSection[assets_List] :=
	characterSheetSection[
		"Assets",
		If[
			assets === {},
			characterSheetValue["None"],
			characterSheetGrid[
				{"Name", "Type", "Abilities", "Details"},
				characterSheetAssetRow /@ assets
			]
		]
	];

characterSheetProgressText[progress_] :=
	formatProgressValue[progress];

characterSheetVowRow[vowData_Association] :=
	Module[
		{threatData, threatCells},
		threatData = Lookup[vowData, "Threat", None];
		threatCells =
			If[
				AssociationQ[threatData],
				{
					Column[
						{
							characterSheetValue[threatData["Name"]],
							characterSheetValue[threatData["Goal"]]
						},
						Spacings -> 0.2,
						Alignment -> Left
					],
					characterSheetValue[ToString[threatData["Menace", "rank"]]],
					characterSheetValue[characterSheetProgressText[threatData["Menace", "progress"]]]
				},
				{characterSheetValue[""], characterSheetValue[""], characterSheetValue[""]}
			];
		Join[
			{
				characterSheetValue[vowData["Name"]],
				characterSheetValue[ToString[vowData["Rank"]]],
				characterSheetValue[characterSheetProgressText[vowData["Progress"]]]
			},
			threatCells
		]
	];

characterSheetBondText[bonds_List] :=
	If[
		bonds === {},
		"None",
		StringRiffle[bonds, ", "]
	];

characterSheetBondsSection[characterData_Association] := Module[
	{bonds, bondTrack},
	bonds = Lookup[characterData, "bonds", {}];
	bondTrack = Lookup[characterData, "bondProgress", makeProgressObject["Bonds", Epic]];
	characterSheetSection[
		"Bonds",
		Column[
			{
				characterSheetInfoLine["Progress", characterSheetProgressText[bondTrack["Progress"]]],
				characterSheetInfoLine["Bonds", characterSheetBondText[bonds]]
			},
			Spacings -> 0.35,
			Alignment -> Left
		]
	]
];

characterSheetVowsSection[characterData_Association] := Module[
	{vows},
	vows = Values[Lookup[characterData, "vows", <||>]];
	characterSheetSection[
		"Vows",
		If[
			vows === {},
			characterSheetValue["None"],
			characterSheetGrid[
				{"Name", "Rank", "Progress", "Threat", "Menace Rank", "Menace"},
				characterSheetVowRow /@ vows
			]
		]
	]
];

characterSheetFailuresSection[characterData_Association] := Module[
	{failures},
	failures = Lookup[characterData, "failures", makeProgressObject["Failures", Epic]];
	characterSheetSection[
		"Failures",
		characterSheetInfoLine["Progress", characterSheetProgressText[failures["Progress"]]]
	]
];

characterSheetOptionalSection[title_String, headers_List, rows_List] :=
	If[
		rows === {},
		Nothing,
		characterSheetSection[
			title,
			characterSheetGrid[headers, rows]
		]
	];

characterSheetCurrentSuffix[name_String, current_] :=
	If[name === current, StringJoin[name, " (current)"], name];

characterSheetRankedProgressRow[object_Association, current_:None] :=
	{
		characterSheetValue[characterSheetCurrentSuffix[object["Name"], current]],
		characterSheetValue[ToString[object["Rank"]]],
		characterSheetValue[characterSheetProgressText[object["Progress"]]],
		characterSheetValue[""]
	};

characterSheetDelveDetails[delveData_Association] := Module[
	{themeText, domainText, objective},
	themeText = StringRiffle[Lookup[delveData, "Themes", {delveData["Theme"]}], " / "];
	domainText = StringRiffle[Lookup[delveData, "Domains", {delveData["Domain"]}], " / "];
	objective = Lookup[delveData, "Objective", None];
	StringRiffle[
		DeleteCases[
			{
				StringJoin["Theme: ", themeText],
				StringJoin["Domain: ", domainText],
				If[objective === None, Nothing, StringJoin["Objective: ", objective]]
			},
			Nothing
		],
		"   "
	]
];

characterSheetDelveRow[delveData_Association, current_] :=
	{
		characterSheetValue[characterSheetCurrentSuffix[delveData["Name"], current]],
		characterSheetValue[ToString[delveData["Rank"]]],
		characterSheetValue[characterSheetProgressText[delveData["Progress"]]],
		characterSheetValue[characterSheetDelveDetails[delveData]]
	};

characterSheetSceneRow[sceneData_Association] :=
	{
		characterSheetValue[sceneData["Name"]],
		characterSheetValue[ToString[sceneData["Rank"]]],
		characterSheetValue[characterSheetProgressText[sceneData["Progress"]]],
		characterSheetValue[StringJoin["Countdown ", ToString[sceneData["Countdown"]], "/4"]]
	};

characterSheetJourneysSection[characterData_Association] :=
	characterSheetOptionalSection[
		"Journeys",
		{"Name", "Rank", "Progress", "Details"},
		characterSheetRankedProgressRow[#, Lookup[characterData, "currentJourney", None]] & /@
			Values[Lookup[characterData, "journeys", <||>]]
	];

characterSheetFoesSection[characterData_Association] :=
	characterSheetOptionalSection[
		"Foes",
		{"Name", "Rank", "Progress", "Details"},
		characterSheetRankedProgressRow /@ Values[Lookup[characterData, "foes", <||>]]
	];

characterSheetDelvesSection[characterData_Association] :=
	characterSheetOptionalSection[
		"Delves",
		{"Name", "Rank", "Progress", "Details"},
		characterSheetDelveRow[#, Lookup[characterData, "currentDelve", None]] & /@
			Values[Lookup[characterData, "delves", <||>]]
	];

characterSheetSceneSection[characterData_Association] := Module[
	{sceneData},
	sceneData = Lookup[characterData, "scene", None];
	If[
		AssociationQ[sceneData],
		characterSheetSection[
			"Scene",
			characterSheetGrid[
				{"Name", "Rank", "Progress", "Countdown"},
				{characterSheetSceneRow[sceneData]}
			]
		],
		Nothing
	]
];

characterSheetDisplay[character_String, characterData_Association] :=
	ironFramed[
		Column[
			DeleteCases[
				{
					Style[
						StringJoin["Character Sheet: ", character],
						FontFamily -> "Futura",
						FontSize -> scaledSize[22],
						FontWeight -> Bold,
						GrayLevel[0.255]
					],
					characterSheetOverviewSection[character, characterData],
					Grid[
						{{
							Column[
								{
									characterSheetAssetsSection[Lookup[characterData, "assets", {}]],
									characterSheetBondsSection[characterData],
									characterSheetFailuresSection[characterData]
								},
								Spacings -> 0.7,
								Alignment -> Left
							],
							Column[
								DeleteCases[
									{
										characterSheetVowsSection[characterData],
										characterSheetJourneysSection[characterData],
										characterSheetFoesSection[characterData],
										characterSheetDelvesSection[characterData],
										characterSheetSceneSection[characterData]
									},
									Nothing
								],
								Spacings -> 0.7,
								Alignment -> Left
							]
						}},
						Alignment -> {{Left, Left}, Top},
						Spacings -> {1.4, 0}
					]
				},
				Nothing
			],
			Spacings -> 0.8,
			Alignment -> Left
		]
	];

sheetInk := GrayLevel[0.16];
sheetDark := GrayLevel[0.18];
sheetAccentDark := GrayLevel[0.30];
sheetMid := GrayLevel[0.72];
sheetLight := GrayLevel[0.9];
sheetPale := GrayLevel[0.94];

sheetStyle[text_, size_, weight_:Plain, color_:sheetInk] :=
	Style[
		text,
		FontFamily -> "Futura",
		FontSize -> scaledSize[size],
		FontWeight -> weight,
		color
	];

sheetSerifStyle[text_, size_, weight_:Plain, color_:sheetInk] :=
	Style[
		text,
		FontFamily -> "Times New Roman",
		FontSize -> scaledSize[size],
		FontWeight -> weight,
		color
	];

sheetRect[{x_, y_}, {width_, height_}, fill_:White, stroke_:sheetInk, thickness_:1.1] :=
	{
		FaceForm[fill],
		EdgeForm[Directive[stroke, AbsoluteThickness[thickness]]],
		Rectangle[{x, y}, {x + width, y + height}]
	};

sheetValueIndicator[{x_, y_}, {width_, height_}, side_] := Module[
	{cy, pointerWidth, pointerHalfHeight},
	cy = y + height/2;
	pointerWidth = 15;
	pointerHalfHeight = 12;
	{
		FaceForm[sheetInk],
		EdgeForm[None],
		Switch[
			side,
			Right,
				Polygon[
					{
						{x + width + 1, cy},
						{x + width + 1 + pointerWidth, cy + pointerHalfHeight},
						{x + width + 1 + pointerWidth, cy - pointerHalfHeight}
					}
				],
			Left,
				Polygon[
					{
						{x - 1, cy},
						{x - 1 - pointerWidth, cy + pointerHalfHeight},
						{x - 1 - pointerWidth, cy - pointerHalfHeight}
					}
				],
			_,
				Nothing
		]
	}
];

sheetLabelBand[label_String, {x_, y_}, {width_, height_}] := Module[
	{size},
	size = Which[
		MemberQ[{"Health", "Spirit", "Supply", "Momentum"}, label], 14,
		width <= 90, 10,
		MemberQ[{"Stats", "Debilities", "Experience", "Bonds", "Background Vow", "Vows", "Failures"}, label], 14,
		MemberQ[{"Current Vow"}, label], 16,
		StringLength[label] > 12, 13,
		True, 16
	];
	{
		sheetRect[{x, y}, {width, height}, sheetDark, sheetDark],
		Text[sheetStyle[ToUpperCase[label], size, Bold, White], {x + width/2, y + height/2}]
	}
];

sheetLadderLabelBand[label_String, {x_, y_}, {width_, height_}] :=
	{
		sheetRect[{x, y}, {width, height}, sheetDark, sheetInk, 1.0],
		Text[sheetStyle[ToUpperCase[label], 14, Bold, White], {x + width/2, y + height/2}]
	};

sheetLabelBandLeft[label_String, {x_, y_}, {width_, height_}] := Module[
	{size, inset},
	size = Which[
		width <= 90, 10,
		MemberQ[{"Bonds", "Background Vow", "Current Vow", "Failure"}, label], 14,
		StringLength[label] > 22, 10,
		StringLength[label] > 16, 11,
		StringLength[label] > 12, 13,
		True, 16
	];
	inset = 14;
	{
		sheetRect[{x, y}, {width, height}, sheetAccentDark, sheetAccentDark],
		Text[sheetStyle[ToUpperCase[label], size, Bold, White], {x + inset, y + height/2}, {-1, 0}]
	}
];

sheetSmallLabelBand[label_String, {x_, y_}, {width_, height_}] :=
	{
		sheetRect[{x, y}, {width, height}, sheetAccentDark, sheetAccentDark, 1.0],
		Text[sheetStyle[ToUpperCase[label], 12, Bold, White], {x + width/2, y + height/2}]
	};

sheetValueBox[label_String, value_, {x_, y_}, {width_, height_}] :=
	{
		sheetRect[{x, y}, {width, height}, sheetPale, sheetInk, 1.4],
		Text[sheetStyle[ToUpperCase[label], 12, Bold], {x + width/2, y + height - 14}],
		Text[sheetStyle[ToString[value], 26, Bold], {x + width/2, y + height/2 - 8}]
	};

sheetNameField[character_String] :=
	{
		sheetRect[{22, 1098}, {776, 58}, sheetDark, sheetDark],
		Text[sheetStyle[character, 28, Bold, White], {50, 1127}, {-1, 0}]
	};

sheetMiddleX = 162;
sheetMiddleWidth = 496;
sheetMiddleTop = 1073;
sheetMiddleBottom = 24;

sheetMiddleBlocks[] := {
	"Stats" -> 98,
	"Debilities" -> 119,
	"Experience" -> 91,
	"BackgroundVow" -> 80,
	"Vows" -> 365,
	"Bonds" -> 62,
	"Failures" -> 62
};

sheetMiddleLayout[] := Module[
	{blocks, totalHeight, gap, y, layout},
	blocks = sheetMiddleBlocks[];
	totalHeight = Total[blocks[[All, 2]]];
	gap = (sheetMiddleTop - sheetMiddleBottom - totalHeight)/(Length[blocks] - 1);
	y = sheetMiddleTop;
	layout = <||>;
	Do[
		AssociateTo[layout, block[[1]] -> y];
		y = y - block[[2]] - gap,
		{block, blocks}
	];
	layout
];

sheetStats[characterData_Association, topY_:sheetMiddleTop] := Module[
	{statsData, startX, y, width, gap, sectionWidth},
	statsData = {
		{"Edge", characterData["edge"]},
		{"Heart", characterData["heart"]},
		{"Iron", characterData["iron"]},
		{"Shadow", characterData["shadow"]},
		{"Wits", characterData["wits"]}
	};
	startX = sheetMiddleX;
	y = topY - 98;
	width = 92;
	gap = 9;
	sectionWidth = Length[statsData] width + (Length[statsData] - 1) gap;
	Join[
		sheetLabelBand["Stats", {startX, topY - 24}, {sectionWidth, 24}],
		Flatten[
			MapIndexed[
				sheetValueBox[#1[[1]], #1[[2]], {startX + (First[#2] - 1) (width + gap), y}, {width, 68}] &,
				statsData
			],
			1
		]
	]
];

sheetVerticalResource[label_String, value_Integer, {x_, y_}, {width_, height_}, max_:5] := Module[
	{labelHeight, boxHeight, values},
	labelHeight = 24;
	boxHeight = (height - labelHeight)/(max + 1);
	values = Reverse[Range[0, max]];
	Join[
		sheetLadderLabelBand[label, {x, y + height - labelHeight}, {width, labelHeight}],
		Flatten[
			MapIndexed[
				Module[{slotY, fill, textColor},
					slotY = y + (Length[values] - First[#2]) boxHeight;
					fill = sheetLight;
					textColor = sheetInk;
					{
						sheetRect[{x, slotY}, {width, boxHeight}, fill, sheetInk, 1.0],
						Text[sheetStyle[ToString[#1], 20, Bold, textColor], {x + width/2, slotY + boxHeight/2}],
						If[
							#1 === value,
							sheetValueIndicator[{x, slotY}, {width, boxHeight}, Right],
							Nothing
						]
					}
				] &,
				values
			],
			1
		]
	]
];

sheetMomentumColumn[character_String, characterData_Association] := Module[
	{values, x, y, width, height, labelHeight, boxHeight, current, max, reset},
	values = Range[10, -6, -1];
	x = 22;
	y = 24;
	width = 124;
	height = 1049;
	labelHeight = 24;
	boxHeight = (height - labelHeight)/Length[values];
	current = characterData["momentum"];
	max = displayMomentumMax[characterData];
	reset = displayMomentumReset[characterData];
	Join[
		sheetLadderLabelBand["Momentum", {x, y + height - labelHeight}, {width, labelHeight}],
		Flatten[
			MapIndexed[
				Module[{slotY, fill, textColor, label},
					slotY = y + (Length[values] - First[#2]) boxHeight;
					fill = Which[
						#1 === reset, sheetDark,
						#1 > max, sheetDark,
						True, sheetLight
					];
					textColor = Which[
						#1 === reset, White,
						#1 > max, sheetInk,
						True, sheetInk
					];
					label = If[#1 > 0, StringJoin["+", ToString[#1]], ToString[#1]];
					{
						sheetRect[{x, slotY}, {width, boxHeight}, fill, sheetInk, 1.0],
						Text[sheetStyle[label, 17, Bold, textColor], {x + width/2, slotY + boxHeight/2}],
						If[
							#1 === current,
							sheetValueIndicator[{x, slotY}, {width, boxHeight}, Left],
							Nothing
						]
					}
				] &,
				values
			],
			1
		]
	]
];

sheetResourceColumns[characterData_Association] :=
	Module[{x, y, width, height, gap},
		x = 674;
		y = 24;
		width = 124;
		height = 1039/3;
		gap = 5;
		Join[
			sheetVerticalResource["Health", characterData["health"], {x, y + 2 (height + gap)}, {width, height}],
			sheetVerticalResource["Spirit", characterData["spirit"], {x, y + height + gap}, {width, height}],
			sheetVerticalResource["Supply", characterData["supply"], {x, y}, {width, height}]
		]
	];

sheetProgressInset[progress_, {x_, y_}, {width_, height_}, menace_:None] :=
	Inset[
		Graphics[
			progressTrackPrimitives[{0, 0}, progress, width, height, MenaceProgress -> menace],
			PlotRange -> {{0, width}, {0, height}},
			ImagePadding -> 0,
			Background -> None
		],
		{x, y},
		{Left, Bottom},
		{width, height}
	];

sheetRankDots[rank_, {x_, y_}, spacing_:86] :=
	Flatten[
		MapIndexed[
			Module[{cx},
				cx = x + (First[#2] - 1) spacing;
				{
					FaceForm[If[#1 === rank, sheetInk, White]],
					EdgeForm[Directive[sheetInk, AbsoluteThickness[1.2]]],
					Disk[{cx, y}, 5],
					Text[sheetStyle[ToUpperCase[ToString[#1]], 8, Bold], {cx + 8, y}, {-1, 0}]
				}
			] &,
			ranks
		],
		1
	];

sheetRankDots[rank_, {x_, y_}, offsets_List] :=
	Flatten[
		MapIndexed[
			Module[{cx},
				cx = x + offsets[[First[#2]]];
				{
					FaceForm[If[#1 === rank, sheetInk, White]],
					EdgeForm[Directive[sheetInk, AbsoluteThickness[1.2]]],
					Disk[{cx, y}, 5],
					Text[sheetStyle[ToUpperCase[ToString[#1]], 8, Bold], {cx + 8, y}, {-1, 0}]
				}
			] &,
			ranks
		],
		1
	];

sheetRankLabelWidth[rank_] :=
	Switch[
		ToString[rank],
		"Troublesome", 72,
		"Dangerous", 68,
		"Formidable", 72,
		"Extreme", 55,
		"Epic", 30,
		_, 50
	];

sheetRankDotsCentered[rank_, {x_, y_}, width_, rankOptions_:ranks] := Module[
	{gap, labelInset, radius, widths, cxs, rowLeft, rowRight, offset},
	gap = 30;
	labelInset = 12;
	radius = 5;
	widths = sheetRankLabelWidth /@ rankOptions;
	cxs = FoldList[#1 + labelInset + #2 + gap &, 0, Most[widths]];
	rowLeft = -radius;
	rowRight = Last[cxs] + labelInset + Last[widths];
	offset = x + (width - (rowRight - rowLeft))/2 - rowLeft;
	Flatten[
		MapThread[
			Function[{rankOption, cx},
				{
					FaceForm[If[rankOption === rank, sheetInk, White]],
					EdgeForm[Directive[sheetInk, AbsoluteThickness[1.2]]],
					Disk[{offset + cx, y}, radius],
					Text[sheetStyle[ToUpperCase[ToString[rankOption]], 8, Bold], {offset + cx + labelInset, y}, {-1, 0}]
				}
			],
			{rankOptions, cxs}
		],
		1
	]
];

sheetBondsPanel[characterData_Association, topY_:86] := Module[
	{bondTrack, x, headerY, trackY, width},
	bondTrack = Lookup[characterData, "bondProgress", makeProgressObject["Bonds", Epic]];
	x = sheetMiddleX;
	headerY = topY - 24;
	trackY = topY - 62;
	width = sheetMiddleWidth;
	{
		sheetLabelBand["Bonds", {x, headerY}, {width, 24}],
		sheetProgressInset[bondTrack["Progress"], {x, trackY}, {width, 30}]
	}
];

sheetVowRow[vowData_, label_String, {x_, y_}, {width_, height_}] := Module[
	{hasVow, progress, rank, menace, bannerText, labelWidth, rankOptions, rankY},
	hasVow = AssociationQ[vowData];
	progress = If[hasVow, vowData["Progress"], 0];
	rank = If[hasVow, vowData["Rank"], None];
	menace = If[hasVow && AssociationQ[Lookup[vowData, "Threat", None]], vowData["Threat", "Menace", "progress"], None];
	bannerText = If[hasVow, vowData["Name"], ""];
	labelWidth = 206;
	rankOptions = If[label === "Background Vow", {Extreme, Epic}, ranks];
	rankY = y + height - 44;
	{
		sheetLabelBandLeft[bannerText, {x, y + height - 30}, {labelWidth, 29}],
		sheetProgressInset[progress, {x + labelWidth, y + height - 30}, {width - labelWidth, 29}, menace],
		sheetRankDotsCentered[rank, {x, rankY}, width, rankOptions]
	}
];

sheetVowsPanel[characterData_Association, backgroundTopY_:704, vowsTopY_:574] := Module[
	{vows, backgroundVow, currentVows, x, width, rowHeight, backgroundRowY, currentStartY, currentPitch, overflow},
	vows = Values[Lookup[characterData, "vows", <||>]];
	backgroundVow = If[vows === {}, None, First[vows]];
	currentVows = PadRight[Take[Rest[vows], UpTo[4]], 4, None];
	x = sheetMiddleX;
	width = sheetMiddleWidth;
	rowHeight = 58;
	backgroundRowY = backgroundTopY - 89;
	currentStartY = vowsTopY - 89;
	currentPitch = 95;
	overflow = Max[0, Length[vows] - 5];
	Flatten[
		Join[
			{
				sheetLabelBand["Background Vow", {x, backgroundTopY - 24}, {width, 24}],
				sheetVowRow[backgroundVow, "Background Vow", {x, backgroundRowY}, {width, rowHeight}],
				sheetLabelBand["Vows", {x, vowsTopY - 24}, {width, 24}]
			},
			MapIndexed[
				sheetVowRow[#1, "Current Vow", {x, currentStartY - (First[#2] - 1) currentPitch}, {width, rowHeight}] &,
				currentVows
			],
			If[
				overflow > 0,
				{Text[sheetStyle[StringJoin["+", ToString[overflow], " more vows"], 12, Bold], {x + width - 8, currentStartY - Length[currentVows] currentPitch + 12}, {1, 0}]},
				{}
			]
		],
		1
	]
];

sheetFailurePanel[characterData_Association, topY_:86] := Module[
	{failures, x, headerY, trackY, width},
	failures = Lookup[characterData, "failures", makeProgressObject["Failures", Epic]];
	x = sheetMiddleX;
	headerY = topY - 24;
	trackY = topY - 62;
	width = sheetMiddleWidth;
	{
		sheetLabelBand["Failures", {x, headerY}, {width, 24}],
		sheetProgressInset[failures["Progress"], {x, trackY}, {width, 30}]
	}
];

sheetExperiencePanel[characterData_Association, topY_:821] := Module[
	{earned, spent, total, columns, rows, radius, x, y, width, rowGap, colGap},
	earned = Clip[Lookup[characterData, "earnedExperience", 0], {0, 60}];
	spent = Clip[Lookup[characterData, "spentExperience", 0], {0, 60}];
	total = 60;
	columns = 20;
	rows = 3;
	radius = 5;
	x = sheetMiddleX;
	y = topY - 86;
	width = sheetMiddleWidth;
	rowGap = 18;
	colGap = (width - 2 radius)/(columns - 1);
	Join[
		sheetLabelBand["Experience", {x, topY - 24}, {width, 24}],
		Flatten[
			Table[
				Module[{index, cx, cy, fill},
					index = (row - 1) columns + col;
					If[index > total, Nothing,
					cx = x + radius + (col - 1) colGap;
					cy = y + (rows - row) rowGap;
					fill = Which[
						index <= spent, sheetInk,
						index <= earned, sheetMid,
						True, White
					];
					{
						FaceForm[fill],
						EdgeForm[Directive[sheetInk, AbsoluteThickness[1.0]]],
						Disk[{cx, cy}, radius]
					}]
				],
				{row, rows},
				{col, columns}
			],
			2
		]
	]
];

sheetDebilityRows[title_String, debilityList_List, active_List, {x_, y_}] := Module[
	{rowGap},
	rowGap = 17;
	Join[
		sheetLabelBand[title, {x, y + Length[debilityList] rowGap + 4}, {128, 23}],
		Flatten[
			MapIndexed[
				Module[{cy, marked},
					cy = y + (Length[debilityList] - First[#2]) rowGap + 11;
					marked = MemberQ[active, #1];
					{
						FaceForm[If[marked, sheetInk, White]],
						EdgeForm[Directive[sheetInk, AbsoluteThickness[1.0]]],
						Disk[{x + 12, cy}, 5],
						Text[sheetStyle[ToUpperCase[debilityLabel[#1]], 10, Bold], {x + 24, cy}, {-1, 0}]
					}
				] &,
				debilityList
			],
			1
		]
	]
];

sheetDebilityItem[debility_, active_List, {x_, y_}] := Module[
	{marked},
	marked = MemberQ[active, debility];
	{
		FaceForm[If[marked, sheetInk, White]],
		EdgeForm[Directive[sheetInk, AbsoluteThickness[1.0]]],
		Disk[{x + 12, y}, 5],
		Text[sheetStyle[ToUpperCase[debilityLabel[debility]], 9, Bold], {x + 24, y}, {-1, 0}]
	}
];

sheetDebilityColumn[title_String, debilityList_List, active_List, {x_, y_}, width_] := Module[
	{rowGap},
	rowGap = 16;
	Join[
		sheetSmallLabelBand[title, {x, y}, {width, 20}],
		Flatten[
			MapIndexed[
				sheetDebilityItem[#1, active, {x + 6, y - 14 - (First[#2] - 1) rowGap}] &,
				debilityList
			],
			1
		]
	]
];

sheetDebilitiesPanel[characterData_Association, topY_:950] := Module[
	{active, x, width, gap, colWidth},
	active = Lookup[characterData, "debilities", {}];
	x = sheetMiddleX;
	width = sheetMiddleWidth;
	gap = 16;
	colWidth = (width - 2 gap)/3;
	Join[
		sheetLabelBand["Debilities", {x, topY - 24}, {width, 24}],
		sheetDebilityColumn["Conditions", {Wounded, Shaken, Unprepared, Encumbered}, active, {x, topY - 52}, colWidth],
		sheetDebilityColumn["Banes", {Maimed, Corrupted}, active, {x + colWidth + gap, topY - 52}, colWidth],
		sheetDebilityColumn["Burdens", {Cursed, Tormented}, active, {x + 2 (colWidth + gap), topY - 52}, colWidth]
	]
];

lodestarCharacterSheetGraphic[character_String, characterData_Association] := Module[
	{width, height, middleLayout},
	width = 820;
	height = 1192;
	middleLayout = sheetMiddleLayout[];
	Graphics[
		Flatten[
			{
				sheetNameField[character],
				sheetStats[characterData, middleLayout["Stats"]],
				sheetDebilitiesPanel[characterData, middleLayout["Debilities"]],
				sheetExperiencePanel[characterData, middleLayout["Experience"]],
				sheetVowsPanel[characterData, middleLayout["BackgroundVow"], middleLayout["Vows"]],
				sheetBondsPanel[characterData, middleLayout["Bonds"]],
				sheetFailurePanel[characterData, middleLayout["Failures"]],
				sheetMomentumColumn[character, characterData],
				sheetResourceColumns[characterData]
			},
			1
		],
		PlotRange -> {{4, width - 4}, {6, height - 18}},
		ImagePadding -> 0,
		ImageSize -> scaled[720],
		Background -> White
	]
];

characterSheetDisplay[character_String, characterData_Association] :=
	characterSheetFramed[lodestarCharacterSheetGraphic[character, characterData]];




assetFieldValueDisplay[value_] :=
	If[
		StringQ[value] && StringLength[StringTrim[value]] > 0,
		value,
		If[value === "" || MissingQ[value],
			"____________",
			ToString[value]
		]
	];

assetFieldRow[label_String, value_] :=
	assetContentPane[
		Row[
			{
				Style[
					StringJoin[label, ": "],
					FontFamily -> "Futura",
					FontSize -> scaledSize[16],
					FontWeight -> Bold,
					GrayLevel[0.255]
				],
				Style[
					assetFieldValueDisplay[value],
					FontFamily -> "Times New Roman",
					FontSize -> scaledSize[18],
					GrayLevel[0.255]
				]
			}
		]
	];

assetFieldRows[record_Association, fields_Association] :=
	KeyValueMap[
		assetFieldRow[Lookup[#2, "Label", #1], Lookup[fields, #1, ""]] &,
		Lookup[record, "Fields", <||>]
	];

assetCardWidth :=
	scaled[520];

assetCategoryPadding :=
	scaled[8];

assetBulletWidth :=
	scaled[26];

assetBodyWidth :=
	assetCardWidth - assetBulletWidth;

assetContentPane[x_] :=
	Pane[
		x,
		{assetCardWidth, Automatic},
		Alignment -> Left
	];

assetCategoryBand[category_String] :=
	Framed[
		Pane[
			Style[
				ToUpperCase[category],
				White,
				FontFamily -> "Futura",
				FontSize -> scaledSize[16],
				FontWeight -> Bold
			],
			{assetCardWidth - 2 assetCategoryPadding, Automatic},
			Alignment -> Left
		],
		Background -> GrayLevel[0.255],
		FrameStyle -> None,
		FrameMargins -> {{assetCategoryPadding, assetCategoryPadding}, {scaled[4], scaled[4]}},
		RoundingRadius -> 0
	];

assetAbilityTitle[name_String] /; StringLength[StringTrim[name]] > 0 :=
	Style[
		name,
		FontFamily -> "Futura",
		FontSize -> scaledSize[17],
		FontWeight -> Bold,
		GrayLevel[0.255]
	];

assetAbilityTitle[_] :=
	Nothing;

assetAbilityRow[ability_Association, selectedQ_] :=
	assetContentPane[
		Grid[
			{{
				Pane[
					Style[
						If[TrueQ[selectedQ], "\[FilledCircle]", "\[EmptyCircle]"],
						GrayLevel[0.255],
						FontSize -> scaledSize[16]
					],
					{assetBulletWidth, Automatic},
					Alignment -> Left,
					ImageMargins -> {{0, 0}, {0, scaled[-1]}}
				],
				Pane[
					Column[
						{
							assetAbilityTitle[Lookup[ability, "Name", ""]],
							Pane[
								moveTextStyle[Lookup[ability, "Text", ""]],
								{assetBodyWidth, Automatic},
								Alignment -> Left
							]
						},
						Spacings -> 0.2,
						Alignment -> Left
					],
					{assetBodyWidth, Automatic},
					Alignment -> Left
				]
			}},
			Alignment -> {Left, Top},
			Spacings -> {0, 0}
		]
	];

assetAbilityRows[record_Association, selectedAbilities_List] :=
	(assetAbilityRow[#, MemberQ[selectedAbilities, #["Index"]]] &) /@ Lookup[record, "Abilities", {}];

assetTrackCell[value_Integer, current_Integer] :=
	Framed[
		Style[
			ToString[value],
			If[value == current, White, GrayLevel[0.255]],
			FontFamily -> "Futura",
			FontSize -> scaledSize[14],
			FontWeight -> Bold
		],
		Background -> If[value == current, GrayLevel[0.255], None],
		FrameStyle -> GrayLevel[0.45],
		FrameMargins -> {{scaled[5], scaled[5]}, {scaled[2], scaled[2]}},
		RoundingRadius -> 0
	];

assetTrackRow[trackName_String, trackDef_Association, current_Integer] := Module[
	{label, values},
	label = Lookup[trackDef, "Label", trackName];
	values = Range[trackDef["Min"], trackDef["Max"]];
	assetContentPane[
		Column[
			{
				Style[
					label,
					FontFamily -> "Futura",
					FontSize -> scaledSize[16],
					FontWeight -> Bold,
					GrayLevel[0.255]
				],
				Grid[
					{assetTrackCell[#, current] & /@ values},
					Spacings -> {0, 0}
				]
			},
			Spacings -> 0.2,
			Alignment -> Left
		]
	]
];

assetTrackRows[record_Association, tracks_Association] := Module[
	{trackDefs, values},
	trackDefs = Lookup[record, "Tracks", <||>];
	values = Join[initialAssetTracks[record], tracks];
	KeyValueMap[
		assetTrackRow[#1, #2, Lookup[values, #1, Lookup[#2, "Default", 0]]] &,
		trackDefs
	]
];

assetRarityRows[None] :=
	{};

assetRarityRows[rarity_String] /; StringLength[StringTrim[rarity]] > 0 :=
	{
		assetContentPane[
			Row[
				{
					Style[
						"Rarity: ",
						FontFamily -> "Futura",
						FontSize -> scaledSize[16],
						FontWeight -> Bold,
						GrayLevel[0.255]
					],
					Style[
						rarity,
						FontFamily -> "Times New Roman",
						FontSize -> scaledSize[18],
						FontSlant -> Italic,
						GrayLevel[0.255]
					]
				}
			]
		]
	};

assetRarityRows[_] :=
	{};

assetCardExpression[record_Association, selectedAbilities_List, fields_Association, tracks_Association, rarity_:None, status_:None] := Module[
	{statusRows, rarityRows, fieldRows, requirementRows, abilityRows, trackRows},
	statusRows = If[status === None, {}, {assetContentPane[subtitleStyle[status]]}];
	rarityRows = assetRarityRows[rarity];
	fieldRows = assetFieldRows[record, fields];
	requirementRows = If[
		StringLength[StringTrim[Lookup[record, "Requirement", ""]]] == 0,
		{},
		{assetContentPane[moveTextStyle[record["Requirement"]]]}
	];
	abilityRows = assetAbilityRows[record, selectedAbilities];
	trackRows = assetTrackRows[record, tracks];
	ironFramed[
		Column[
			Join[
					statusRows,
						{
							assetCategoryBand[record["Category"]],
							assetContentPane[titleStyle[record["Name"]]]
						},
					rarityRows,
					fieldRows,
					requirementRows,
					abilityRows,
					trackRows
			],
			Spacings -> 0.8,
			Alignment -> Left
		]
	]
];

assetCardExpression[owned_Association, status_:None] := Module[
	{record},
	record = assetRecord[owned["Name"]];
	If[!AssociationQ[record],
		Message[asset::unknown, owned["Name"]];
		Return[$Failed]
	];
	assetCardExpression[
		record,
			Lookup[owned, "Abilities", {}],
			Lookup[owned, "Fields", <||>],
			Lookup[owned, "Tracks", <||>],
			Lookup[owned, "Rarity", None],
			status
		]
	];

assetReferenceCard[name_String] := Module[
	{record, fields},
	record = assetRecord[name];
	If[!AssociationQ[record],
		Message[asset::unknown, name];
		Return[$Failed]
	];
	fields = normalizeAssetFields[<||>, record];
	assetCardExpression[
			record,
			defaultAssetAbilities[record],
			fields,
			initialAssetTracks[record],
			None
		]
	];

displayAssetCard[owned_Association, status_:None] := Module[
	{card},
	card = assetCardExpression[owned, status];
	If[card === $Failed, Return[$Failed]];
	Print[card];
	owned
];

displayExpressionList[exprs_List] :=
	Print[Column[exprs, Spacings -> 1, Alignment -> Left]];

displayAssetCards[cards_List] :=
	displayExpressionList[cards];

displayOwnedAssets[ownedAssets_List] := Module[
	{cards},
	cards = assetCardExpression /@ ownedAssets;
	If[MemberQ[cards, $Failed], Return[$Failed]];
	displayAssetCards[cards];
	ownedAssets
];

displayAssetReferences[names_List] := Module[
	{cards},
	cards = assetReferenceCard /@ names;
	If[MemberQ[cards, $Failed], Return[$Failed]];
	displayAssetCards[cards];
	names
];




formatProgressValue[value_] :=
	ToString[NumberForm[N[value], {3, 2}, NumberPadding -> {"", "0"}]];

progressTickCount[progress_] :=
	Clip[Round[4 N[progress]], {0, 40}];

progressBoxTickCount[totalTicks_Integer, box_Integer] :=
	Clip[totalTicks - 4 (box - 1), {0, 4}];

progressTickPrimitive[x_, y_, width_, height_, tick_Integer, color_] := Module[
	{anchors, ax, ay, sx, sy},
	anchors = {
		{0.16, 0.16},
		{0.16, 0.56},
		{0.56, 0.16},
		{0.56, 0.56}
	};
	{ax, ay} = anchors[[tick]];
	sx = x + ax width;
	sy = y + ay height;
	{
		color,
		AbsoluteThickness[1.6],
		Line[
			{
				{sx, sy + 0.16 height},
				{sx + 0.08 width, sy + 0.04 height},
				{sx + 0.26 width, sy + 0.28 height}
			}
		]
	}
];

progressBoxPrimitives[x_, y_, width_, height_, tickCount_Integer, color_] :=
	Join[
		{
			FaceForm[White],
			EdgeForm[Directive[GrayLevel[0.255], AbsoluteThickness[1.2]]],
			Rectangle[{x, y}, {x + width, y + height}]
		},
		Flatten[
			Table[
				progressTickPrimitive[x, y, width, height, tick, color],
				{tick, tickCount}
			],
			1
		]
	];

menaceCornerPrimitives[x_, y_, width_, height_, tickCount_Integer, color_] := Module[
	{cornerSize, inset, cx, cy, fill},
	cornerSize = Min[0.28 width, 0.42 height];
	inset = 0.6;
	cx = x + width - cornerSize;
	cy = y + height - cornerSize;
	fill = Which[
		tickCount >= 4, color,
		tickCount > 0, GrayLevel[0.78],
		True, White
	];
	{
		FaceForm[fill],
		EdgeForm[Directive[GrayLevel[0.255], AbsoluteThickness[1.0]]],
		Rectangle[{cx + inset, cy + inset}, {x + width - inset, y + height - inset}]
	}
];

Options[progressTrackPrimitives] = {MenaceProgress -> None};

progressTrackPrimitives[{x_, y_}, progress_, width_, height_, opts : OptionsPattern[]] := Module[
	{boxWidth, totalTicks, menaceProgress, menaceTicks, color},
	boxWidth = width/10;
	totalTicks = progressTickCount[progress];
	menaceProgress = OptionValue[MenaceProgress];
	menaceTicks = If[menaceProgress === None, None, progressTickCount[menaceProgress]];
	color = GrayLevel[0.255];
	Flatten[
		Table[
			Join[
				progressBoxPrimitives[
					x + (box - 1) boxWidth,
					y,
					boxWidth,
					height,
					progressBoxTickCount[totalTicks, box],
					color
				],
				If[
					menaceTicks === None,
					{},
					menaceCornerPrimitives[
						x + (box - 1) boxWidth,
						y,
						boxWidth,
						height,
						progressBoxTickCount[menaceTicks, box],
						color
					]
				]
			],
			{box, 10}
		],
		1
	]
];

Options[progressTrackGraphic] = {
	MenaceProgress -> None,
	TrackWidth -> 280,
	TrackHeight -> 24,
	ImageScale -> 1
};

progressTrackGraphic[progress_, opts : OptionsPattern[]] := Module[
	{width, height, scale},
	width = OptionValue[TrackWidth];
	height = OptionValue[TrackHeight];
	scale = OptionValue[ImageScale];
	Graphics[
		progressTrackPrimitives[
			{0, 0},
			progress,
			width,
			height,
			MenaceProgress -> OptionValue[MenaceProgress]
		],
		PlotRange -> {{0, width}, {0, height}},
		ImagePadding -> 1,
		ImageSize -> {scaled[width scale], scaled[height scale]},
		Background -> None
	]
];

progressSummaryHeader[label_String, rank_, progress_] :=
	Row[
		{
			Style[
				StringJoin[label, ": "],
				FontFamily -> "Futura",
				FontSize -> scaledSize[16],
				FontWeight -> Bold,
				GrayLevel[0.255]
			],
			Style[
				StringJoin[ToString[rank], "  ", formatProgressValue[progress]],
				FontFamily -> "Futura",
				FontSize -> scaledSize[14],
				GrayLevel[0.4]
			]
		}
	];

progressSummary[label_String, rank_, progress_] :=
	Column[
		{
			progressSummaryHeader[label, rank, progress],
			progressTrackGraphic[progress]
		},
		Spacings -> 0.25,
		Alignment -> Left
	];

vowProgressSummary[vowData_Association] := Module[
	{ownedThreat, menaceProgress},
	ownedThreat = Lookup[vowData, "Threat", None];
	menaceProgress = If[AssociationQ[ownedThreat], ownedThreat["Menace", "progress"], None];
	progressTrackGraphic[vowData["Progress"], MenaceProgress -> menaceProgress]
];

displayVowCard[vowData_Association] := Module[
	{rows, ownedThreat},
	ownedThreat = Lookup[vowData, "Threat", None];
	rows = {
		header[
			"Vow",
			StringJoin[
				vowData["Name"],
				" (",
				ToLowerCase[ToString[vowData["Rank"]]],
				")"
			]
		],
		vowProgressSummary[vowData]
	};
	If[AssociationQ[ownedThreat],
		rows = Join[
			rows,
			{
				Row[
					{
						Style[
							"Threat: ",
							FontFamily -> "Times New Roman",
							FontSize -> scaledSize[18],
							FontWeight -> Bold
						],
						moveTextStyle[
							StringJoin[
								ownedThreat["Name"],
								" (",
								ToLowerCase[ToString[ownedThreat["Menace", "rank"]]],
								"): ",
								ownedThreat["Goal"]
							]
						]
					}
				]
			}
		]
	];
	ironFramed[Column[rows, Spacings -> 0.8, Alignment -> Left]]
];

displayVowCards[vowData_Association] :=
	displayVowCards[Values[vowData]];

displayVowCards[vowData_List] :=
	displayExpressionList[displayVowCard /@ vowData];

displayThreatFulfilled[vowName_String, threatData_Association] :=
	Print[
		ironFramed[
			Column[
				{
					header["Threat Fulfilled", threatData["Name"]],
					subtitleStyle[StringJoin["Vow: ", vowName]],
					moveTextStyle[threatData["Goal"]],
					moveTextStyle["Forsake Your Vow."]
				},
				Spacings -> 0.8,
				Alignment -> Left
			]
		]
	];


progressTypeTitle["Vow"] := "Vow";
progressTypeTitle["Threat"] := "Threat";
progressTypeTitle["Delve"] := "Delve";
progressTypeTitle["Scene"] := "Scene";
progressTypeTitle["Journey"] := "Journey";
progressTypeTitle["Foe"] := "Foe";
progressTypeTitle["Failures"] := "Failures";
progressTypeTitle["Bonds"] := "Bonds";
progressTypeTitle[other_] := ToString[other];

displayProgressTargetCard[target_Association] := Module[
	{rows, label},
	label = If[target["Type"] === "Threat", "Menace", "Progress"];
	rows = {
		header[progressTypeTitle[target["Type"]], target["Name"]]
	};
	If[target["Type"] === "Threat" && KeyExistsQ[target, "Vow"],
		rows = Append[rows, subtitleStyle[StringJoin["Vow: ", target["Vow"]]]]
	];
	rows = Append[rows, progressSummary[label, target["Rank"], target["Progress"]]];
	ironFramed[Column[rows, Spacings -> 0.8, Alignment -> Left]]
];


displayCharacterSheet[character_String, characterData_Association] := Module[{},
	Print[characterSheetDisplay[character, characterData]];
	characterData
];

displayCharacterSheet[args___] := (
	Message[displayCharacterSheet::badargs, HoldForm[displayCharacterSheet[args]]];
	$Failed
);

displayCharacterSheet::badargs = "displayCharacterSheet is a display helper API and expects displayCharacterSheet[character, characterData].";


displayProgressObject[type_String, object_Association] :=
	displayProgressTargetCard[
		Association[
			"Type" -> type,
			"Name" -> object["Name"],
			"Rank" -> object["Rank"],
			"Progress" -> object["Progress"]
		]
	];

displayProgressObjectCard[type_String, object_Association] :=
	Print[displayProgressObject[type, object]];

displayProgressObjectCards[type_String, objects_Association] :=
	displayProgressObjectCards[type, Values[objects]];

displayProgressObjectCards[type_String, objects_List] :=
	displayExpressionList[displayProgressObject[type, #] & /@ objects];



displayBondCard[name_String] :=
	ironFramed[
		Column[
			{header["Bond", name]},
			Spacings -> 0.8,
			Alignment -> Left
		]
	];

displayBondCards[names_List] :=
	displayExpressionList[displayBondCard /@ names];



sceneCountdownSummary[countdown_] :=
	Row[
		{
			Style[
				"Countdown: ",
				FontFamily -> "Futura",
				FontSize -> scaledSize[16],
				FontWeight -> Bold,
				GrayLevel[0.255]
			],
			moveTextStyle[StringJoin[ToString[countdown], "/4"]]
		}
	];

displaySceneCard[sceneData_Association] :=
	ironFramed[
		Column[
			{
				header["Scene", sceneData["Name"]],
				progressSummary["Progress", sceneData["Rank"], sceneData["Progress"]],
				sceneCountdownSummary[sceneData["Countdown"]]
			},
			Spacings -> 0.8,
			Alignment -> Left
		]
	];

displayScene[sceneData_Association] := (
	Print[displaySceneCard[sceneData]];
	sceneData
);



delveCardSummary[delveData_Association] := Module[
	{themeText, domainText},
	themeText = StringRiffle[Lookup[delveData, "Themes", {delveData["Theme"]}], " / "];
	domainText = StringRiffle[Lookup[delveData, "Domains", {delveData["Domain"]}], " / "];
	StringJoin["Theme: ", themeText, "   Domain: ", domainText]
];

denizenDisplayName[None] :=
	"\[LongDash]";

denizenDisplayName[name_String] :=
	name;

denizenRows[denizenList_List] :=
	MapThread[
		{
			Style[ToString[#1], FontFamily -> "Futura", FontSize -> scaledSize[12], FontWeight -> Bold, GrayLevel[0.255]],
			Style[#2, FontFamily -> "Futura", FontSize -> scaledSize[12], GrayLevel[0.255]],
			Style[#3, FontFamily -> "Futura", FontSize -> scaledSize[12], GrayLevel[0.255]],
			Style[denizenDisplayName[#4], FontFamily -> "Times New Roman", FontSize -> scaledSize[14], GrayLevel[0.255]]
		} &,
		{Range[12], denizenSlotLabels, denizenSlotRanges, denizenList}
	];

denizenMatrixGrid[denizenList_List] :=
	Grid[
		Prepend[
			denizenRows[denizenList],
			Style[#, FontFamily -> "Futura", FontSize -> scaledSize[12], FontWeight -> Bold, GrayLevel[0.255]] & /@
				{"Slot", "Frequency", "Roll", "Denizen"}
		],
		Alignment -> {{Left, Left, Left, Left}, Center},
		Spacings -> {1.1, 0.35},
		Dividers -> {False, {2 -> GrayLevel[0.75]}}
	];

displayDelveCard[delveData_Association] := Module[
	{rows, objective, denizenList},
	objective = Lookup[delveData, "Objective", None];
	denizenList = Lookup[delveData, "Denizens", defaultDenizens[]];
	rows = {
		header["Delve", delveData["Name"]],
		subtitleStyle[delveCardSummary[delveData]]
	};
	If[objective =!= None,
		rows = Join[rows, {subtitleStyle["Objective"], moveTextStyle[objective]}]
	];
	rows = Join[
		rows,
		{
			progressSummary["Progress", delveData["Rank"], delveData["Progress"]],
			subtitleStyle["Denizens"],
			denizenMatrixGrid[denizenList]
		}
	];
	ironFramed[
		Column[
			rows,
			Spacings -> 0.8,
			Alignment -> Left
		]
	]
];

displayDelve[delveData_Association] := (
	Print[displayDelveCard[delveData]];
	delveData
);

displayDelves[delves_Association] :=
	displayDelves[Values[delves]];

displayDelves[delves_List] :=
	displayExpressionList[displayDelveCard /@ delves];

displayDenizensMatrix[delveName_String, denizenList_List] :=
	Print[
		ironFramed[
			Column[
				{header["Denizens", delveName], denizenMatrixGrid[denizenList]},
				Spacings -> 0.8,
				Alignment -> Left
			]
		]
	];

displayRiskZoneCard[delveData_Association, zone_Association] :=
	Print[
		ironFramed[
			Column[
				{
					header["Risk Zone", delveData["Name"]],
					subtitleStyle[zone["Name"]],
					progressSummary["Progress", delveData["Rank"], delveData["Progress"]],
					moveTextStyle[StringJoin[
						"Suggested ranks: ",
						ToString[zone["Ranks"][[1]]],
						" or ",
						ToString[zone["Ranks"][[2]]],
						". Default: ",
						ToString[zone["Rank"]],
						"."
					]]
				},
				Spacings -> 0.8,
				Alignment -> Left
			]
		]
	];

displayDenizenRoll[delveName_String, roll_Association] :=
	Print[
		ironFramed[
			Column[
				{
					header["Denizen", delveName],
					oracleDiceDisplay[roll["oracleDice"]],
					moveTextStyle[StringJoin[
						"Slot ",
						ToString[roll["slot"]],
						" (",
						roll["frequency"],
						", ",
						roll["range"],
						"): ",
						If[roll["denizen"] === None, "Blank", roll["denizen"]]
					]]
				},
				Spacings -> 0.8,
				Alignment -> Center
			]
		]
	];


(* ::Subsection::Closed:: *)
(*Choice display*)


displayMoveChoice[MoveDisplayOutput[data_Association], selection_] := Module[
	{indices, choices, invalid, selected},

	indices = choiceSelectionIndices[selection];

	If[indices === $Failed,
		Message[displayMoveChoice::badselection, selection];
		Return[$Failed]
	];

	choices = Lookup[data, "Choices", {}];

	If[choices === {},
		Message[displayMoveChoice::nochoices, Lookup[data, "Subtitle", "the previous output"]];
		Return[$Failed]
	];

	invalid = Select[indices, # < 1 || # > Length[choices] &];

	If[invalid =!= {},
		Message[displayMoveChoice::badindex, First[invalid], Length[choices]];
		Return[$Failed]
	];

	selected = choices[[indices]];
	displayChoice[Lookup[data, "Subtitle", ""], Lookup[selected, "Text"]]
];

displayMoveChoice[output_, selection_] := (
	Message[displayMoveChoice::badoutput, output];
	$Failed
);

displayMoveChoice::badselection =
"`1` is not a valid choice selection. Use an integer or a non-empty list of integers.";

displayMoveChoice::nochoices =
"`1` does not expose any choices.";

displayMoveChoice::badindex =
"Choice `1` is not available. Valid choices are 1 through `2`.";

displayMoveChoice::badoutput =
"`1` is not a move header or outcome output. Use a value returned by a move display function.";


(* ::Subsection::Closed:: *)
(*Oracle display*)


oracleTableByName[tableName_String] := Module[
	{table},
	If[!KeyExistsQ[oracles, tableName],
		Message[oracle::unknown, tableName];
		Return[$Failed]
	];
	table = oracles[tableName];
	If[!AssociationQ[table],
		Message[oracle::unknown, tableName];
		Return[$Failed]
	];
	table
];

oracleRollByName[tableName_String] := Module[
	{table},
	table = oracleTableByName[tableName];
	If[table === $Failed, Return[$Failed]];
	oracleRoll[tableName, table]
];

chooseOddEvenCard[value_Integer, cards_List] :=
	If[Length[cards] == 2 && EvenQ[value], Last[cards], First[cards]];

featureCardsForValue[value_Integer, themes_List, domains_List] :=
	{
		If[value <= 20, chooseOddEvenCard[value, themes], First[themes]],
		If[value > 20, chooseOddEvenCard[value, domains], First[domains]]
	};

dangerCardsForValue[value_Integer, themes_List, domains_List] :=
	{
		If[value <= 30, chooseOddEvenCard[value, themes], First[themes]],
		If[30 < value <= 45, chooseOddEvenCard[value, domains], First[domains]]
	};

delveCompositeOracleRoll[title_String, delveData_Association, tableFunction_, cardFunction_] := Module[
	{dice, value, match, theme, domain, table, outcome},
	dice = rollOracleDice[];
	value = oracleRollValue[dice];
	match = SameQ @@ dice;
	{theme, domain} = cardFunction[value, delveData["Themes"], delveData["Domains"]];
	table = tableFunction[theme, domain];
	outcome = oracleRollOutcome[table, value];
	displayOracleRoll[StringJoin[title, " (", theme, ", ", domain, ")"], dice, match, outcome];
	Association[
		"oracleDice" -> dice,
		"value" -> value,
		"outcome" -> outcome,
		"match" -> match,
		"theme" -> theme,
		"domain" -> domain
	]
];

siteNamePossessive[name_String] :=
	If[StringEndsQ[name, "s"], name <> "'", name <> "'s"];

siteNameComponent[label_String, tableName_String] := Module[
	{table},
	table = oracleTableByName[tableName];
	If[table === $Failed, Return[$Failed]];
	oracleComponentRoll[label, table]
];

delveSiteNameOracle[domainSpec_] := Module[
	{domains, templateRoll, result, components, domain, placeRoll, descriptionRoll, detailRoll, namesakeRoll},
	domains = normalizeDelveCards[domainSpec, "Domain"];
	If[domains === $Failed, Return[$Failed]];
	templateRoll = siteNameComponent["Template", "Delve Site: Name (Template)"];
	If[templateRoll === $Failed, Return[$Failed]];
	result = templateRoll["outcome"];
	components = {templateRoll};
	domain = chooseOddEvenCard[templateRoll["value"], domains];
	placeRoll = siteNameComponent["Place (" <> domain <> ")", "Delve Site: Name (Place - " <> domain <> ")"];
	If[placeRoll === $Failed, Return[$Failed]];
	AppendTo[components, placeRoll];
	result = StringReplace[result, "[Place]" -> placeRoll["outcome"]];
	If[StringContainsQ[result, "[Description]"],
		descriptionRoll = siteNameComponent["Description", "Delve Site: Name (Description)"];
		If[descriptionRoll === $Failed, Return[$Failed]];
		AppendTo[components, descriptionRoll];
		result = StringReplace[result, "[Description]" -> descriptionRoll["outcome"]]
	];
	If[StringContainsQ[result, "[Detail]"],
		detailRoll = siteNameComponent["Detail", "Delve Site: Name (Detail)"];
		If[detailRoll === $Failed, Return[$Failed]];
		AppendTo[components, detailRoll];
		result = StringReplace[result, "[Detail]" -> detailRoll["outcome"]]
	];
	If[StringContainsQ[result, "[Namesake's]"],
		namesakeRoll = siteNameComponent["Namesake", "Delve Site: Name (Namesake)"];
		If[namesakeRoll === $Failed, Return[$Failed]];
		AppendTo[components, namesakeRoll];
		result = StringReplace[result, "[Namesake's]" -> siteNamePossessive[namesakeRoll["outcome"]]]
	];
	If[StringContainsQ[result, "[Namesake]"],
		namesakeRoll = siteNameComponent["Namesake", "Delve Site: Name (Namesake)"];
		If[namesakeRoll === $Failed, Return[$Failed]];
		AppendTo[components, namesakeRoll];
		result = StringReplace[result, "[Namesake]" -> namesakeRoll["outcome"]]
	];
	displayCompositeOracleRoll["Delve Site Name", components, result];
	Association[
		"components" -> components,
		"domain" -> domain,
		"outcome" -> result
	]
];

compositeOracleRoll[title_String, specs_List, resultFunction_] := Module[
	{components, result},
	components = siteNameComponent @@@ specs;
	If[MemberQ[components, $Failed], Return[$Failed]];
	result = resultFunction[components];
	displayCompositeOracleRoll[title, components, result];
	Association["components" -> components, "outcome" -> result]
];

labelOutcomeLines[components_List] :=
	StringRiffle[
		(StringJoin[#["label"], ": ", #["outcome"]] &) /@ components,
		"\n"
	];

settlementNameOracle[] := Module[
	{categoryRoll, category, nameRoll, components, result},
	categoryRoll = siteNameComponent["Category", "Settlement: Name (Category)"];
	If[categoryRoll === $Failed, Return[$Failed]];
	category = categoryRoll["outcome"];
	nameRoll = siteNameComponent[category, "Settlement: Name (" <> category <> ")"];
	If[nameRoll === $Failed, Return[$Failed]];
	components = {categoryRoll, nameRoll};
	result = nameRoll["outcome"];
	displayCompositeOracleRoll["Settlement: Name", components, result];
	Association[
		"components" -> components,
		"category" -> category,
		"outcome" -> result
	]
];

splitOracleOptions[text_String] :=
	StringTrim /@ StringSplit[text, " or "];

quickSettlementName[prefix_String, suffix_String] :=
	StringTrim[prefix, "-"] <> StringTrim[suffix, "-"];

settlementQuickNameOracle[] := Module[
	{prefixRoll, suffixRoll, prefixes, suffixes, names, components, result},
	prefixRoll = siteNameComponent["Prefix", "Settlement: Quick Name (Prefix)"];
	suffixRoll = siteNameComponent["Suffix", "Settlement: Quick Name (Suffix)"];
	If[prefixRoll === $Failed || suffixRoll === $Failed, Return[$Failed]];
	prefixes = splitOracleOptions[prefixRoll["outcome"]];
	suffixes = splitOracleOptions[suffixRoll["outcome"]];
	names = Flatten[Outer[quickSettlementName, prefixes, suffixes], 1];
	components = {prefixRoll, suffixRoll};
	result = StringRiffle[names, ", "];
	displayCompositeOracleRoll["Settlement: Quick Name", components, result];
	Association[
		"components" -> components,
		"names" -> names,
		"outcome" -> result
	]
];

coreComponentTableName["Action"] := "Core: Action";
coreComponentTableName["Descriptor"] := "Core: Descriptor";
coreComponentTableName["Focus"] := "Core: Focus";
coreComponentTableName["Theme"] := "Core: Theme";

corePromptOracle[] := Module[
	{promptRoll, parts, components, result},
	promptRoll = siteNameComponent["Prompt", "Core: Prompt"];
	If[promptRoll === $Failed, Return[$Failed]];
	parts = StringSplit[promptRoll["outcome"], " + "];
	components = siteNameComponent[#, coreComponentTableName[#]] & /@ parts;
	If[MemberQ[components, $Failed], Return[$Failed]];
	result = StringRiffle[Lookup[components, "outcome"], " "];
	displayCompositeOracleRoll["Core: Prompt", Prepend[components, promptRoll], result];
	Association[
		"components" -> Prepend[components, promptRoll],
		"prompt" -> promptRoll["outcome"],
		"outcome" -> result
	]
];

characterOracle[] :=
	compositeOracleRoll[
		"Character",
		{
			{"First Look", "Character: First Look"},
			{"Activity", "Character: Activity"},
			{"Disposition", "Character: Disposition"},
			{"Role", "Character: Role"},
			{"Goal", "Character: Goal"},
			{"Revealed Details", "Character: Revealed Details"}
		},
		labelOutcomeLines
	];

settlementLandType["Settled"] := "Settled Lands";
settlementLandType["Settled Lands"] := "Settled Lands";
settlementLandType["Boundary"] := "Boundary Lands";
settlementLandType["Boundary Lands"] := "Boundary Lands";
settlementLandType["Remote"] := "Remote Lands";
settlementLandType["Remote Lands"] := "Remote Lands";
settlementLandType[other_] := other;

settlementOracle[] :=
	settlementOracle[Automatic];

settlementOracle[landType_] := Module[
	{specs, normalizedLandType},
	specs = {
		{"Condition", "Settlement: Condition"},
		{"First Look", "Settlement: First Look"},
		{"Projects", "Settlement: Projects"},
		{"Troubles", "Settlement: Troubles"},
		{"Cultural Touchstones", "Settlement: Cultural Touchstones"}
	};
	If[landType =!= Automatic,
		normalizedLandType = settlementLandType[landType];
		specs = Prepend[specs, {"Type", "Settlement: Type (" <> normalizedLandType <> ")"}]
	];
	compositeOracleRoll["Settlement", specs, labelOutcomeLines]
];

combatSceneOracle[] :=
	compositeOracleRoll[
		"Combat Scene",
		{
			{"Battleground", "Combat: Battleground"},
			{"Tactic", "Combat: Tactic"},
			{"Event Method", "Combat: Event Method"},
			{"Event Target", "Combat: Event Target"}
		},
		Function[
			components,
			StringRiffle[
				{
					"Battleground: " <> components[[1, "outcome"]],
					"Tactic: " <> components[[2, "outcome"]],
					"Event: " <> components[[3, "outcome"]] <> " " <> components[[4, "outcome"]]
				},
				"\n"
			]
		]
	];

journeyWaypointOracle[] :=
	journeyWaypointOracle["Overland"];

journeyWaypointOracle[kind_String] := Module[
	{tableName, title},
	{tableName, title} = Switch[
		kind,
		"Coastal Waters",
			{"Location: Coastal Waters Waypoint", "Journey Waypoint (Coastal Waters)"},
		"Overland",
			{"Location: Overland Waypoint", "Journey Waypoint"},
		_,
			{"Location: " <> kind <> " Waypoint", "Journey Waypoint (" <> kind <> ")"}
	];
	compositeOracleRoll[
		title,
		{
			{"Waypoint", tableName},
			{"Descriptor", "Core: Descriptor"},
			{"Focus", "Core: Focus"}
		},
		labelOutcomeLines
	]
];

monstrosityOracle[] := Module[
	{components, characteristics, abilities, result},
	components = Join[
		{
			siteNameComponent["Size", "Monstrosity: Size"],
			siteNameComponent["Primary Form", "Monstrosity: Primary Form"]
		},
		Table[siteNameComponent["Characteristic " <> ToString[i], "Monstrosity: Characteristics"], {i, 3}],
		Table[siteNameComponent["Ability " <> ToString[i], "Monstrosity: Abilities"], {i, 3}]
	];
	If[MemberQ[components, $Failed], Return[$Failed]];
	characteristics = Lookup[components[[3 ;; 5]], "outcome"];
	abilities = Lookup[components[[6 ;; 8]], "outcome"];
	result = StringRiffle[
		{
			"Size: " <> components[[1, "outcome"]],
			"Form: " <> components[[2, "outcome"]],
			"Characteristics: " <> StringRiffle[characteristics, ", "],
			"Abilities: " <> StringRiffle[abilities, ", "]
		},
		"\n"
	];
	displayCompositeOracleRoll["Monstrosity", components, result];
	Association[
		"components" -> components,
		"size" -> components[[1, "outcome"]],
		"form" -> components[[2, "outcome"]],
		"characteristics" -> characteristics,
		"abilities" -> abilities,
		"outcome" -> result
	]
];

threatCategoryDetail[category_String] := Module[
	{tableName, detail},
	tableName = "Threat: " <> category;
	If[!KeyExistsQ[oracles, tableName], Return[$Failed]];
	detail = siteNameComponent[category, tableName];
	If[detail === $Failed, Return[$Failed]];
	detail
];

threatOracle[] := Module[
	{categoryRoll, components, detail, categoryRolls, results},
	categoryRoll = siteNameComponent["Category", "Threat: Category"];
	If[categoryRoll === $Failed, Return[$Failed]];
	components = {categoryRoll};
	results = {};
	If[categoryRoll["outcome"] === "Roll Twice",
		categoryRolls = Table[siteNameComponent["Category " <> ToString[i], "Threat: Category"], {i, 2}];
		If[MemberQ[categoryRolls, $Failed], Return[$Failed]];
		components = Join[components, categoryRolls];
		Do[
			If[category["outcome"] === "Roll Twice",
				AppendTo[results, "Roll Twice"],
				detail = threatCategoryDetail[category["outcome"]];
				If[detail === $Failed, Return[$Failed]];
				AppendTo[components, detail];
				AppendTo[results, category["outcome"] <> ": " <> detail["outcome"]]
			],
			{category, categoryRolls}
		],
		detail = threatCategoryDetail[categoryRoll["outcome"]];
		If[detail === $Failed, Return[$Failed]];
		AppendTo[components, detail];
		AppendTo[results, categoryRoll["outcome"] <> ": " <> detail["outcome"]]
	];
	displayCompositeOracleRoll["Threat", components, StringRiffle[results, "\n"]];
	Association["components" -> components, "outcome" -> StringRiffle[results, "\n"]]
];

displayOracleQuery[] := displayMove["askTheOracle"];

displayOracleQuery["Reveal a Danger"] :=
	oracleRoll["Reveal a Danger: Alternate", revealDangerAlternateTable];

displayOracleQuery["Reveal a Danger", ownedDelve_Association] :=
	delveCompositeOracleRoll["Reveal a Danger", ownedDelve, revealDangerCombinedTable, dangerCardsForValue];

displayOracleQuery["Reveal a Danger", theme_String, domain_String] := oracleRoll["Reveal a Danger ("<>theme<>", "<>domain<>")", revealDangerCombinedTable[theme, domain]];

displayOracleQuery["Delve Site Feature", ownedDelve_Association] :=
	delveCompositeOracleRoll["Delve Site Feature", ownedDelve, delveSiteFeatureTable, featureCardsForValue];

displayOracleQuery["Delve Site Feature", theme_String, domain_String] := oracleRoll["Delve Site Feature ("<>theme<>", "<>domain<>")", delveSiteFeatureTable[theme, domain]];

displayOracleQuery["Delve Site Name", ownedDelve_Association] :=
	delveSiteNameOracle[ownedDelve["Domains"]];

displayOracleQuery["Delve Site Name", domain_String] :=
	delveSiteNameOracle[domain];

displayOracleQuery["Settlement: Name"] :=
	settlementNameOracle[];

displayOracleQuery["Settlement: Quick Name"] :=
	settlementQuickNameOracle[];

displayOracleQuery["Core: Prompt"] :=
	corePromptOracle[];

displayOracleQuery["Character"] :=
	characterOracle[];

displayOracleQuery["Settlement"] :=
	settlementOracle[];

displayOracleQuery["Settlement", landType_String] :=
	settlementOracle[landType];

displayOracleQuery["Combat Scene"] :=
	combatSceneOracle[];

displayOracleQuery["Journey Waypoint"] :=
	journeyWaypointOracle[];

displayOracleQuery["Journey Waypoint", kind_String] :=
	journeyWaypointOracle[kind];

displayOracleQuery["Monstrosity"] :=
	monstrosityOracle[];

displayOracleQuery["Trap"] :=
	compositeOracleRoll[
		"Trap",
		{{"Event", "Delve Site: Trap Event"}, {"Component", "Delve Site: Trap Component"}},
		(StringRiffle[Lookup[#, "outcome"], " "] &)
	];

displayOracleQuery["Combat Event"] :=
	compositeOracleRoll[
		"Combat Event",
		{{"Method", "Combat: Event Method"}, {"Target", "Combat: Event Target"}},
		(StringRiffle[Lookup[#, "outcome"], " "] &)
	];

displayOracleQuery["Threat"] :=
	threatOracle[];

displayOracleQuery["Threat", category_String] := Module[
	{tableName},
	tableName = "Threat: " <> category;
	oracleRollByName[tableName]
];

displayOracleQuery[tableName_String] := oracleRollByName[tableName];
displayOracleQuery["Yes/No", odds_String] := oracleRollByName["Yes/No: " <> odds];
displayOracleQuery["Yes/No", yesOutcome_String, noOutcome_String] := oracleRoll["Yes/No", yesNo[yesOutcome, noOutcome]];

oracle::unknown = "Unknown oracle table `1`.";


(* ::Subsection::Closed:: *)
(*Private context footer*)


End[];


(* ::Section::Closed:: *)
(*Package footer*)


EndPackage[];
