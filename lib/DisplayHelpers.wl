(* ::Package:: *)

(* ::Title:: *)
(*Display Helpers*)


(* ::Text:: *)
(*Internal helpers and API implementations for rendering dice, rolls, moves, choices, assets, vows, progress cards, scenes, delves, bonds, and character sheets.*)
(*This package exposes a small display API for IronLibrary.wl and keeps its implementation in its own private context.*)


(* ::Section::Closed:: *)
(*Package header*)


With[
	{dir = If[StringQ[$InputFileName] && $InputFileName =!= "", DirectoryName[$InputFileName], Directory[]]},
	If[!MemberQ[$Packages, "IronLibrary`TextHelpers`"], Get[FileNameJoin[{dir, "TextHelpers.wl"}]]];
	If[!MemberQ[$Packages, "MoveData`"], Get[FileNameJoin[{dir, "MoveData.wl"}]]];
	If[!MemberQ[$Packages, "AssetData`"], Get[FileNameJoin[{dir, "AssetData.wl"}]]]
];

BeginPackage["IronLibrary`DisplayHelpers`", {"MoveData`", "AssetData`", "IronLibrary`TextHelpers`"}];


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
displayAssetAbility::usage = "displayAssetAbility is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayAssetReference::usage = "displayAssetReference is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayAssetReferences::usage = "displayAssetReferences is part of the internal DisplayHelpers API used by IronLibrary.wl.";
assetReferenceCard::usage = "assetReferenceCard is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayVowCard::usage = "displayVowCard is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayVowCards::usage = "displayVowCards is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayProgressObject::usage = "displayProgressObject is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayProgressObjectCard::usage = "displayProgressObjectCard is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayProgressObjectCards::usage = "displayProgressObjectCards is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayBondList::usage = "displayBondList is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displaySceneCard::usage = "displaySceneCard is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayScene::usage = "displayScene is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayDelveCard::usage = "displayDelveCard is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayDelve::usage = "displayDelve is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayDelves::usage = "displayDelves is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayRiskZoneCard::usage = "displayRiskZoneCard is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayDenizenRoll::usage = "displayDenizenRoll is part of the internal DisplayHelpers API used by IronLibrary.wl.";
displayReturnToSiteRoll::usage = "displayReturnToSiteRoll is part of the internal DisplayHelpers API used by IronLibrary.wl.";


(* ::Section:: *)
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


(* ::Subsection:: *)
(*Domain data and normalization*)


symbolNameLower[symbol_] := ToLowerCase[SymbolName[symbol]];

progressRanks = {Troublesome, Dangerous, Formidable, Extreme, Epic};

debilityLabel[debility_String] :=
	debility;

debilityLabel[debility_Symbol] :=
	SymbolName[Unevaluated[debility]];

debilityLabel[debility_] :=
	ToString[Unevaluated[debility]];

momentumResetValue[characterData_Association] :=
	Max[0, 2 - Length[Lookup[characterData, "debilities", {}]]];

momentumMaxValue[characterData_Association] :=
	10 - Length[Lookup[characterData, "debilities", {}]];

fallbackProgressTrack[name_String, rank_, progress_:0] :=
	Association[
		"Name" -> name,
		"Rank" -> rank,
		"Progress" -> Clip[progress, {0, 10}]
	];

assetCatalog[] := AssetData`assetData;

assetDefinition[name_String] :=
	Lookup[assetCatalog[], name, Missing["UnknownAsset", name]];

assetFieldNames[record_Association] :=
	Keys[Lookup[record, "Fields", <||>]];

assetDefaultAbilities[record_Association] :=
	Lookup[record, "DefaultAbilities", {}];

assetDefaultTrackValues[record_Association] :=
	Association @ KeyValueMap[
		#1 -> Lookup[#2, "Default", Lookup[#2, "Max", 0]] &,
		Lookup[record, "Tracks", <||>]
	];

assetFieldsWithDefaults[fields_Association, record_Association] := Module[
	{keys, blankFields},
	keys = assetFieldNames[record];
	blankFields = AssociationThread[keys -> ConstantArray["", Length[keys]]];
	Join[blankFields, KeyTake[fields, keys]]
];

emptyDenizenSlots[] :=
	ConstantArray[None, 12];

$denizenSlotRanges = {
	"01-27", "28-41", "42-55", "56-69",
	"70-75", "76-81", "82-87", "88-93",
	"94-95", "96-97", "98-99", "00"
};

$denizenSlotLabels = {
	"Very Common", "Common", "Common", "Common",
	"Uncommon", "Uncommon", "Uncommon", "Uncommon",
	"Rare", "Rare", "Rare", "Unforeseen"
};

normalizeDelveCards[cards_String, _] := {cards};
normalizeDelveCards[cards : {__String}, _] := cards;
normalizeDelveCards[_, _] := $Failed;

rollOracleDice[] := RandomInteger[{1, 10}, 2];

oracleValueFromDice[{tensDie_Integer, onesDie_Integer}] := Module[{tensValue, onesValue},
	tensValue = If[tensDie == 10, 0, tensDie*10];
	onesValue = If[onesDie == 10, 0, onesDie];
	If[tensDie == onesDie == 10, 100, tensValue + onesValue]
];

oracleOutcomeForValue[table_Association, value_Integer] := Module[{key},
	key = First[Select[Sort[Keys[table]], # >= value &]];
	table[key]
];

oracleRollResult[table_Association] := Module[{oracleDice, od1, od2, value, outcome, match},
	oracleDice = {od1, od2} = rollOracleDice[];
	value = oracleValueFromDice[oracleDice];
	outcome = oracleOutcomeForValue[table, value];
	match = od1 == od2;
	<|"oracleDice" -> oracleDice, "value" -> value, "outcome" -> outcome, "match" -> match|>
];

oracleRoll[tableName_String, table_Association] := Module[{roll},
	roll = oracleRollResult[table];
	displayOracleRoll[tableName, roll["oracleDice"], roll["match"], roll["outcome"]];
	roll
];



(* ::Subsection:: *)
(*Shared display primitives*)


(* ::Subsubsection::Closed:: *)
(*Display configuration*)


$ironDisplayScale = 0.8;
$displayFrameContentWidth = 720;
$displayFrameMargin = 16;
$displayFrameRoundingRadius = 8;
$displayTrackWidth = 496;
$displayFrameTrackWidth = $displayFrameContentWidth - 2 $displayFrameMargin;
$displayFrameTrackHeight = Automatic;
$displayTrackBannerHeight = 42;
$displayFrameBannerTextSize = 22;
$displayHeaderBannerInset = 16;
$assetNameBoxHeight = 34;
$assetNameBoxInset = 16;
$assetTrackGap = 14;
$rollHeaderBodyGap = 1.8;
$rollBodyResultGap = 3;
$displaySansFont = "Futura";
$displaySerifFont = "Times New Roman";
$displayInk = GrayLevel[0.255];
$displayMutedInk = GrayLevel[0.4];


(* ::Subsubsection::Closed:: *)
(*Scaling*)


scaled[n_?NumericQ] := $ironDisplayScale n;

scaledSize[n_?NumericQ] := Round[scaled[n]];

baseSize[n_?NumericQ] := n;

baseFontSize[n_?NumericQ] := baseSize[n];

scaleFinalImage[image_Image] :=
	ImageResize[image, Scaled[$ironDisplayScale]];

scaleFinalGraphic[graphic_Graphics, background_:None] :=
	scaleFinalImage[Rasterize[graphic, Background -> background]];


(* ::Subsubsection::Closed:: *)
(*Shared layout constants*)


rollHeaderBodyGap := scaled[$rollHeaderBodyGap];
rollBodyResultGap := scaled[$rollBodyResultGap];
displayFrameContentWidth := scaled[$displayFrameContentWidth];
displayFrameBodyWidth := scaled[$displayFrameContentWidth - 2 $displayFrameMargin];
displayFrameInnerMargin := scaled[$displayFrameMargin];
displayFrameMargins := {{scaled[$displayFrameMargin], scaled[$displayFrameMargin]}, {scaled[$displayFrameMargin], scaled[$displayFrameMargin]}};
displayFrameRoundingRadius := scaled[$displayFrameRoundingRadius];


(* ::Subsubsection::Closed:: *)
(*Text styles*)


displayText[text_, family_String, size_?NumericQ, weight_:Plain, color_:$displayInk, opts___] :=
	Style[
		text,
		color,
		opts,
		FontFamily -> family,
		FontSize -> scaledSize[size],
		FontWeight -> weight
	];

displayLabelValue[label_String, value_, valueStyle_:moveTextStyle] :=
	Row[
		{
			displayText[StringJoin[label, ": "], $displaySansFont, 16, Bold],
			valueStyle[value]
		}
	];

dieStyle[n_] := Style[
	n,
	$displayInk,
	FontSize -> 21,
	FontFamily -> $displaySansFont,
	FontWeight -> Bold
];

mainStyle[n_] := displayText[n, $displaySansFont, 42, Bold];

titleStyle[x_] := displayText[x, $displaySansFont, 32, Bold];

subtitleStyle[x_] := displayText[x, $displaySansFont, 26, Plain, $displayMutedInk];

moveTextStyle[x_] := displayText[x, $displaySerifFont, 18];


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
$cancelledDieOpacity = 0.45;

dimCancelledDie[die_Image] :=
	SetAlphaChannel[die, ImageMultiply[AlphaChannel[die], $cancelledDieOpacity]];

dieCanvas[die_Image, 0] :=
	die;

dieCanvas[die_Image, padding_] :=
	ImagePad[die, padding, Transparent];

cancelledDieCanvas[die_Image] :=
	dimCancelledDie[die];

cancelledDieOverlay[die_Image, size_?NumericQ, position_List] :=
	ImageCompose[
		cancelledDieCanvas[die],
		Rasterize[
			Style["\[Times]", $displayInk, FontSize -> baseFontSize[size]],
			Background -> None
		],
		Scaled[position]
	];

numberedDieImage[base_Image, label_, labelPosition_List, cancelled_, cancelSize_?NumericQ, cancelPosition_List, canvasPadding_:0] := Module[
	{die, canvas},
	die = ImageCompose[
		base,
		Rasterize[dieStyle[label], Background -> None],
		Scaled[labelPosition]
	];
	canvas = dieCanvas[die, canvasPadding];
	If[cancelled, cancelledDieOverlay[canvas, cancelSize, cancelPosition], canvas]
];

Options[d6Image] = {Cancelled -> False};
d6Image[n_Integer /; 1 <= n <= 6, opts : OptionsPattern[]] := Module[{die},
	die = numberedDieImage[
		emptyD6Image,
		n,
		{0.36 - If[n == 4, 0.01, 0], 0.42},
		OptionValue[Cancelled],
		150,
		{0.5, 0.81},
		20
	];
	scaleFinalImage[die]
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
	die = numberedDieImage[
		emptyD10Image,
		If[n == 10, 0, n],
		{0.5 - If[n == 4, 0.01, 0], 0.66},
		OptionValue[Cancelled],
		150,
		{0.5, 0.8}
	];
	scaleFinalImage[die]
];
$outcomeColors = Association["miss" -> RGBColor[0.72, 0.22, 0.22], "weakHit" -> RGBColor[0.78, 0.55, 0.15], "strongHit" -> RGBColor[0.3, 0.55, 0.3]];
$outcomeLabels = Association["miss" -> "Miss", "weakHit" -> "Weak Hit", "strongHit" -> "Strong Hit"];

actionRollResultDisplay[result_String, match_] := Module[
	{color, label},
	color = Lookup[$outcomeColors, result, $displayMutedInk];
	label = actionRollResultLabel[result, match];
	displayText[
		label,
		$displaySansFont,
		34,
		Bold,
		color,
		FontTracking -> "Wide",
		TextAlignment -> Right
	]
];


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
	scaleFinalImage[circle]
];

rollColumnEntry[value_, sortGroup_, image_] :=
	{value, sortGroup, image};

rollColumn[actionScore_, challengeDice_List, challengeDiceCancelled_:Automatic, alignment_:Center] := Module[
	{cancelled, entries},
	cancelled = Replace[
		challengeDiceCancelled,
		Automatic :> ConstantArray[False, Length[challengeDice]]
	];
	entries = Join[
		{rollColumnEntry[actionScore, 0, compactRollImage[scoreCircle[actionScore]]]},
		MapThread[
			rollColumnEntry[#1, 1, compactRollImage[d10Image[#1, Cancelled -> #2]]] &,
			{challengeDice, cancelled}
		]
	];
	Column[
		Last /@ ReverseSortBy[entries, {#1[[1]], #1[[2]]} &],
		Alignment -> alignment
	]
];

rollFrameStyle := Directive[
	GrayLevel[0.25],
	AbsoluteThickness[scaled[4]]
];

mathCoreWidth := scaled[160];
mathOperatorWidth := scaled[24];
mathValueWidth := scaled[60];
mathOpValueGap := scaled[6];
mathReasonGap := scaled[0];
mathDieAddGap := scaled[0];
mathReasonYOffset := scaled[-0.4];
mathDieXOffset := 0;

mathOperator[x_] := mainStyle[x];
mathValue[x_] := mainStyle[x];

mathLabel[x_] :=
	RawBoxes[
		AdjustmentBox[
			ToBoxes[
				displayText[StringJoin["(", ToString[x], ")"], $displaySansFont, 32, Plain, GrayLevel[0.35]]
			],
			BoxBaselineShift -> -mathReasonYOffset
		]
	];

mathCore[op_, value_] :=
	Pane[
		Row[
			{
				Pane[mathOperator[op], {mathOperatorWidth, Automatic}, Alignment -> Left],
				Pane[mathValue[value], {mathValueWidth, Automatic}, Alignment -> Left]
			},
			Spacer[mathOpValueGap]
		],
		{mathCoreWidth, Automatic},
		Alignment -> Left
	];

mathTermRow[op_, value_, source_] := {mathCore[op, value], mathLabel[source]};
mathResultRow[actionScore_] := {mathCore["=", actionScore], Spacer[0]};
offsetX[expr_, dx_] := Pane[expr, ImageMargins -> {{Max[dx, 0], Max[-dx, 0]}, {0, 0}}];

mathDieRow[actionDie_Integer, actionDieCancelled_, momentum_] :=
	{
		Pane[
			offsetX[compactRollImage[d6Image[actionDie, Cancelled -> actionDieCancelled]], mathDieXOffset],
			{mathCoreWidth, Automatic},
			Alignment -> Left
		],
		If[actionDieCancelled, mathLabel[StringJoin["Momentum ", ToString[momentum]]], Spacer[0]]
	};

mathColumn[actionDie_Integer, statValue_Integer, adds_Association, actionScore_Integer, actionDieCancelled_, momentum_, statReason_] :=
	compactMathColumn[actionDie, statValue, adds, actionScore, actionDieCancelled, momentum, statReason];

compactRollImageScale = 0.66;

compactRollImage[image_Image] :=
	ImageResize[image, Scaled[compactRollImageScale]];

compactMathCoreWidth :=
	scaled[104];

compactMathOperatorWidth :=
	scaled[18];

compactMathValueWidth :=
	scaled[56];

compactMathOpValueGap :=
	scaled[3];

compactMathReasonGap :=
	scaled[0];

compactMathDieAddGap :=
	scaled[0];

compactMathDieXOffset :=
	scaled[0];

compactMathOperator[x_] :=
	displayText[x, $displaySansFont, 30, Bold];

compactMathValue[x_] :=
	displayText[x, $displaySansFont, 30, Bold];

compactMathLabel[x_] :=
	displayText[ToString[x], $displaySansFont, 20, Plain, GrayLevel[0.35]];

compactMathCore[op_, value_] :=
	Pane[
		Row[
			{
				Pane[compactMathOperator[op], {compactMathOperatorWidth, Automatic}, Alignment -> Left],
				Pane[compactMathValue[value], {compactMathValueWidth, Automatic}, Alignment -> Left]
			},
			Spacer[compactMathOpValueGap]
		],
		{compactMathCoreWidth, Automatic},
		Alignment -> Left
	];

compactMathLabelPane[x_] :=
	Row[{compactMathLabel[x]}];

compactMathTermRow[op_, value_, source_] :=
	{compactMathCore[op, value], compactMathLabelPane[source]};

compactMathResultRow[actionScore_] :=
	{compactMathCore["=", actionScore], Spacer[0]};

compactMathDieRow[actionDie_Integer, actionDieCancelled_, momentum_] :=
	{
		Pane[
			offsetX[
				compactRollImage[d6Image[actionDie, Cancelled -> actionDieCancelled]],
				compactMathDieXOffset
			],
			{compactMathCoreWidth, Automatic},
			Alignment -> Left
		],
		If[actionDieCancelled, compactMathLabelPane[StringJoin["Momentum ", ToString[momentum]]], Spacer[0]]
	};

compactMathColumn[actionDie_Integer, statValue_Integer, adds_Association, actionScore_Integer, actionDieCancelled_, momentum_, statReason_] := Module[
	{termRows, rows, dividerPosition, blankRow, dieGapRow},
	blankRow = {Spacer[{0, 2}], Spacer[{0, 2}]};
	dieGapRow = {Spacer[{0, compactMathDieAddGap}], Spacer[{0, compactMathDieAddGap}]};
	termRows = Join[
		{compactMathTermRow["+", statValue, statReason]},
		KeyValueMap[compactMathTermRow["+", #2, #1] &, adds]
	];
	rows = Join[
		{compactMathDieRow[actionDie, actionDieCancelled, momentum], dieGapRow},
		termRows,
		{blankRow, compactMathResultRow[actionScore]}
	];
	dividerPosition = 2 + Length[termRows] + 1;
	Grid[
		rows,
		Alignment -> {{Left, Left}},
		Spacings -> {compactMathReasonGap, 0.35},
		Dividers -> {False, {dividerPosition -> rollFrameStyle}}
	]
];


(* ::Subsubsection::Closed:: *)
(*Headers*)


header[title_String] :=
	displayHeaderBanner[title];

header[title_String, subtitle_String] :=
	displayHeaderBanner[title, subtitle];

oracleHeader[subtitle_String] :=
	displayHeaderBanner["Oracle Roll", subtitle, Automatic, Automatic, 0.3];


(* ::Subsubsection::Closed:: *)
(*Frames*)


displayFrameCanvas[x_] :=
	Pane[
		x,
		{displayFrameContentWidth - displayFrameInnerMargin, Automatic},
		Alignment -> Left,
		ImageMargins -> {{displayFrameInnerMargin, 0}, {displayFrameInnerMargin, displayFrameInnerMargin}}
	];

displayRawFrame[x_, margins_:displayFrameMargins] := Framed[
	Pane[
		x,
		{displayFrameContentWidth, Automatic},
		Alignment -> Left
	],
	FrameStyle -> rollFrameStyle,
	FrameMargins -> margins,
	RoundingRadius -> displayFrameRoundingRadius,
	Background -> None
];

displayFrame[x_, margins_:displayFrameMargins] :=
	displayRawFrame[displayFrameCanvas[x], margins];

ironFramed[x_] :=
	displayFrame[x];

displayColumn[rows_List, spacing_:0.8, alignment_:Left] :=
	ironFramed[
		Column[
			rows,
			Spacings -> spacing,
			Alignment -> alignment
		]
	];

displayGrid[rows_List, opts___] :=
	ironFramed[Grid[rows, opts]];

printAndReturn[expr_, return_] := (
	Print[expr];
	return
);

characterSheetFramed[x_] :=
	displayRawFrame[x];


(* ::Subsubsection:: *)
(*Action roll display*)


actionRollResultLabel[result_String, match_] := Module[
	{label},
	label = ToUpperCase[Lookup[$outcomeLabels, result]];
	StringJoin[label, If[match, " (MATCH)", ""]]
];

rollDisplayDiceColumnWidth :=
	Max[
		First[ImageDimensions[compactRollImage[scoreCircle[10]]]],
		First[ImageDimensions[compactRollImage[d10Image[10]]]]
	];

rollDisplaySideWidth :=
	Max[1, (displayFrameBodyWidth - rollDisplayDiceColumnWidth)/2];

rollDisplaySideSlot[content_, horizontalAlignment_] :=
	Pane[
		Pane[
			content,
			{rollDisplaySideWidth, Automatic},
			Alignment -> {Center, Center}
		],
		{displayFrameBodyWidth, Automatic},
		Alignment -> {horizontalAlignment, Center}
	];

rollDiceResultBody[score_, challengeDice_List, challengeDiceCancelled_, result_String, match_] :=
	Pane[
		Overlay[
			{
				Pane[
					rollColumn[score, challengeDice, challengeDiceCancelled, Center],
					{displayFrameBodyWidth, Automatic},
					Alignment -> {Center, Center}
				],
				rollDisplaySideSlot[
					actionRollResultDisplay[result, match],
					Right
				]
			},
			Alignment -> Center
		],
		{displayFrameBodyWidth, Automatic},
		Alignment -> Center
	];

actionRollBody[roll_Association] :=
	Pane[
		Grid[
			{
				{
					Item[
						Pane[
							compactMathColumn[
								roll["actionDie"],
								roll["statValue"],
								roll["adds"],
								roll["actionScore"],
								roll["actionDieCancelled"],
								roll["momentum"],
								Capitalize[symbolNameLower[roll["stat"]]]
							],
							{rollDisplaySideWidth, Automatic},
							Alignment -> {Center, Center}
						],
						Alignment -> {Center, Center}
					],
					Item[
						Pane[
							rollColumn[roll["actionScore"], roll["challengeDice"], Automatic, Center],
							{rollDisplayDiceColumnWidth, Automatic},
							Alignment -> {Center, Center}
						],
						Alignment -> {Center, Center}
					],
					Item[
						Pane[
							actionRollResultDisplay[roll["result"], roll["match"]],
							{rollDisplaySideWidth, Automatic},
							Alignment -> {Center, Center}
						],
						Alignment -> {Center, Center}
					]
				}
			},
			Alignment -> {{Center, Center, Center}, Center},
			Spacings -> {0, 0}
		],
		{displayFrameBodyWidth, Automatic},
		Alignment -> {Center, Top}
	];

actionRollCard[title_String, subtitle_String, roll_Association, titleFraction_:Automatic] :=
	displayColumn[
		{
			displayHeaderBanner[title, subtitle, Automatic, Automatic, titleFraction],
			Item[actionRollBody[roll], Alignment -> Center]
		},
		{Automatic, rollHeaderBodyGap},
		Center
	];

displayActionRoll[roll_Association] :=
	Print[actionRollCard["Action Roll", Capitalize[symbolNameLower[roll["stat"]]], roll]];


(* ::Subsubsection::Closed:: *)
(*Momentum burn display*)


momentumBurnMatch[burn_Association] :=
	If[AllTrue[burn["challengeDiceCancelled"], !# &], burn["match"], False];

momentumBurnBody[burn_Association] :=
	rollDiceResultBody[
		burn["actionScore"],
		burn["challengeDice"],
		burn["challengeDiceCancelled"],
		burn["result"],
		momentumBurnMatch[burn]
	];

displayMomentumBurn[burn_Association] :=
	Print[
		displayColumn[
			{
				header[
					"Momentum Burn",
					StringJoin[ToString[burn["momentum"]], " \[Rule] ", ToString[burn["momentumReset"]]]
				],
				Item[
					momentumBurnBody[burn],
					Alignment -> Center
				]
			},
			{Automatic, rollHeaderBodyGap},
			Center
		]
	];


(* ::Subsubsection::Closed:: *)
(*Progress roll display*)


progressRollCard[title_String, subtitle_String, score_, challengeDice_List, result_String, match_, titleFraction_:Automatic] :=
	displayColumn[
		{
			displayHeaderBanner[title, subtitle, Automatic, Automatic, titleFraction],
			Item[
				rollDiceResultBody[score, challengeDice, {False, False}, result, match],
				Alignment -> Center
			]
		},
		{Automatic, rollHeaderBodyGap},
		Center
	];

displayProgressRoll[roll_Association] :=
	Print[
		progressRollCard[
			"Progress Roll",
			roll["trackName"],
			roll["progressScore"],
			roll["challengeDice"],
			roll["result"],
			roll["match"]
		]
	];


(* ::Subsubsection:: *)
(*Oracle roll display*)


oracleTextWithMatch[text_, match_] :=
	If[TrueQ[match], IronLibrary`TextHelpers`p[text, " (MATCH)"], text];

oracleOutcomeText[outcome_, match_] :=
	moveTextStyle[oracleTextWithMatch[outcome, match]];

oracleOutcomePane[outcome_, match_] :=
	Pane[
		oracleOutcomeText[outcome, match],
		{displayFrameBodyWidth, Automatic},
		Alignment -> Center
	];

oracleRollCard[table_String, dice_List, match_, outcome_] :=
	ironFramed[
			Grid[
				{
					{Item[oracleHeader[table], Alignment -> Left], SpanFromLeft},
					{Item[oracleDiceDisplay[dice], Alignment -> Center], SpanFromLeft},
					{Item[displayLineHeaderGraphic["Result"], Alignment -> Center], SpanFromLeft},
					{Item[oracleOutcomePane[outcome, match], Alignment -> Center], SpanFromLeft}
			},
			Alignment -> {{Center}, {Center, Top, Center}},
				Spacings -> {0, {Automatic, rollHeaderBodyGap, 1.0, 1.0}}
		]
	];

displayOracleRoll[table_String, dice_List, match_, outcome_] :=
	Print[oracleRollCard[table, dice, match, outcome]];

oracleDiceDisplay[{d1_, d2_}] :=
	Grid[
		{{Item[compactRollImage[d10Image[d1]], Alignment -> Right], Item[compactRollImage[d10Image[d2]], Alignment -> Left]}},
		Alignment -> {{Right, Left}, Center},
		Spacings -> {0, 0}
	];

oracleComponentRoll[label_String, table_Association] :=
	Join[<|"label" -> label|>, oracleRollResult[table]];

oracleComponentRow[component_Association] :=
	{
		displayText[component["label"], $displaySansFont, 14, Bold],
		oracleDiceDisplay[component["oracleDice"]],
		moveTextStyle[oracleTextWithMatch[component["outcome"], component["match"]]]
	};

displayCompositeOracleRoll[title_String, components_List, result_] :=
	Print[
		displayColumn[
			{
				oracleHeader[title],
				Grid[
					oracleComponentRow /@ components,
					Alignment -> {{Left, Center, Left}, Center},
					Spacings -> {1.2, 0.8}
				],
				displayLineHeaderGraphic["Result"],
				moveTextStyle[result]
			},
			{1.0, 0.8}
		]
	];

displayReturnToSiteRoll[roll_Association] :=
	Print[
		displayGrid[
			{
				{Item[header["Return to Site", roll["delveName"]], Alignment -> Left]},
				{Item[Column[compactRollImage /@ (d10Image /@ ReverseSort[roll["challengeDice"]]), Spacings -> 0], Alignment -> Center]}
			},
			Alignment -> {{Center}, {Center, Top, Center}},
			Spacings -> {2, {Automatic, rollHeaderBodyGap}}
		]
	];

displayRarityDieSix[roll_Association] :=
	Print[
		displayColumn[
			{
				header["Rarity Die", "Rolled 6"],
				Item[
					Grid[
						{{
							Item[compactRollImage[d6Image[6]], Alignment -> Center],
							Item[mainStyle["\[Rule]"], Alignment -> Center],
							Item[actionRollResultDisplay["strongHit", False], Alignment -> Center]
						}},
						Alignment -> {{Center, Center, Center}, {Center}},
						Spacings -> {1.2, 0}
					],
					Alignment -> Center
				]
			},
			{Automatic, rollHeaderBodyGap},
			Center
		]
	];


(* ::Subsubsection::Closed:: *)
(*Reroll display*)


rerollTitleFraction = 0.38;

rerollDieLabel[AllDice] := "All dice";
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
	Print[actionRollCard["Action Reroll", rerollSubtitle[roll["reroll", "selection"]], roll, rerollTitleFraction]];

displayRerollProgressRoll[roll_Association] :=
	Print[
		progressRollCard[
			"Progress Reroll",
			rerollSubtitle[roll["reroll", "selection"]],
			roll["progressScore"],
			roll["challengeDice"],
			roll["result"],
			roll["match"],
			rerollTitleFraction
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

moveCard[heading_, body_] :=
	displayColumn[
		{heading, moveTextStyle[body]},
		1
	];


(* ::Subsubsection::Closed:: *)
(*Move header presentation*)


displayMoveHeader[moveKey_String] := Module[
	{section},
	section = moves[moveKey, "header"];
	Print[moveCard[header[moves[moveKey, "name"]], moveSectionText[section]]];
	moveOutput[moveKey, "header", section]
];


(* ::Subsubsection::Closed:: *)
(*Move outcome presentation*)


displayMoveOutcome[moveKey_String, result_String] := Module[
	{section},
	section = moves[moveKey, result];
	Print[moveCard[header[moves[moveKey, "name"], Lookup[$outcomeLabels, result]], moveSectionText[section]]];
	moveOutput[moveKey, result, section]
];


(* ::Subsubsection::Closed:: *)
(*Combined move display*)


displayMove[moveKey_String] :=
	displayMoveHeader[moveKey];

displayMove[moveKey_String, roll_Association] :=
	displayMoveOutcome[moveKey, roll["result"]];


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
		displayColumn[
			{
				header["Choice", subtitle],
				moveTextStyle[choiceDisplayBody[texts]]
			},
			1
		]
	];


(* ::Subsection:: *)
(*Lodestar character sheet display*)


sheetInk := GrayLevel[0.16];
sheetDark := GrayLevel[0.18];
sheetAccentDark := GrayLevel[0.30];
sheetMid := GrayLevel[0.72];
sheetLight := GrayLevel[0.9];
sheetPale := GrayLevel[0.94];
sheetHintInk := GrayLevel[0.62];

sheetStyle[text_, size_, weight_:Plain, color_:sheetInk] :=
	Style[
		text,
		FontFamily -> "Futura",
		FontSize -> baseFontSize[size],
		FontWeight -> weight,
		color
	];

sheetRect[{x_, y_}, {width_, height_}, fill_:White, stroke_:sheetInk, thickness_:1.1] :=
	{
		FaceForm[fill],
		EdgeForm[Directive[stroke, AbsoluteThickness[thickness]]],
		Rectangle[{x, y}, {x + width, y + height}]
	};

sheetTrackFrameThickness = 1.2;
displayTrackFrameThickness :=
	sheetTrackFrameThickness/$ironDisplayScale;

sheetFrameLineWidth[frameThickness_] :=
	1.5 frameThickness/$ironDisplayScale;

sheetFilledRect[{left_, bottom_}, {right_, top_}, fill_] :=
	{
		FaceForm[fill],
		EdgeForm[None],
		Rectangle[{left, bottom}, {right, top}]
	};

sheetTrackCell[{x_, y_}, {width_, height_}, fill_, stroke_:sheetInk] :=
	sheetRect[{x, y}, {width, height}, fill, stroke, sheetTrackFrameThickness];

sheetValueIndicatorWidth = 15;
sheetValueIndicatorGap = 1;
sheetValueIndicatorHalfHeight = 12;

sheetValueIndicatorOutset[Right | Left, scale_:1] :=
	scale (sheetValueIndicatorGap + sheetValueIndicatorWidth);

sheetValueIndicatorOutset[_, scale_:1] :=
	0;

sheetValueIndicator[{x_, y_}, {width_, height_}, side_, scale_:1] := Module[
	{cy, gap, pointerWidth, pointerHalfHeight},
	cy = y + height/2;
	gap = scale sheetValueIndicatorGap;
	pointerWidth = scale sheetValueIndicatorWidth;
	pointerHalfHeight = scale sheetValueIndicatorHalfHeight;
	{
		FaceForm[sheetInk],
		EdgeForm[None],
		Switch[
			side,
			Right,
				Polygon[
					{
						{x + width + gap, cy},
						{x + width + gap + pointerWidth, cy + pointerHalfHeight},
						{x + width + gap + pointerWidth, cy - pointerHalfHeight}
					}
				],
			Left,
				Polygon[
					{
						{x - gap, cy},
						{x - gap - pointerWidth, cy + pointerHalfHeight},
						{x - gap - pointerWidth, cy - pointerHalfHeight}
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
		MemberQ[{"Stats", "Debilities", "Experience", "Bonds", "Background Vow", "Vows", "Journey", "Delve", "Failures"}, label], 14,
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
		sheetRect[{x, y}, {width, height}, sheetDark, sheetInk, sheetTrackFrameThickness],
		Text[sheetStyle[ToUpperCase[label], 14, Bold, White], {x + width/2, y + height/2}]
	};

sheetLeftLabelSize[label_String, width_] := Which[
	width <= 90, 10,
	MemberQ[{"Bonds", "Background Vow", "Current Vow", "Failure"}, label], 14,
	StringLength[label] > 22, 10,
	StringLength[label] > 16, 11,
	StringLength[label] > 12, 13,
	True, 16
];

sheetTextMeasurementWidth = 100;

sheetGraphicsPixelScale[] :=
	sheetGraphicsPixelScale[] = First[
		ImageDimensions[
			Rasterize[
				Graphics[
					{White, Rectangle[{0, 0}, {sheetTextMeasurementWidth, 1}]},
					PlotRange -> {{0, sheetTextMeasurementWidth}, {0, 1}},
					PlotRangePadding -> None,
					ImagePadding -> 0,
					ImageSize -> baseSize[sheetTextMeasurementWidth],
					Background -> White
				]
			]
		]
	]/sheetTextMeasurementWidth;

sheetTextWidth[text_String, size_?NumericQ, weight_:Bold] :=
	sheetTextWidth[text, size, weight] = First[
		ImageDimensions[
			Rasterize[
				Style[
					text,
					FontFamily -> "Futura",
					FontSize -> baseFontSize[size],
					FontWeight -> weight
				],
				Background -> None
			]
		]
	]/sheetGraphicsPixelScale[];

sheetFittedTextSize[text_String, width_?NumericQ, weight_:Bold, {minSize_, maxSize_}] := Module[
	{lo, hi, mid},
	lo = N[minSize];
	hi = N[maxSize];
	If[sheetTextWidth[text, hi, weight] <= width, Return[hi]];
	If[sheetTextWidth[text, lo, weight] >= width, Return[lo]];
	Do[
		mid = (lo + hi)/2;
		If[
			sheetTextWidth[text, mid, weight] <= width,
			lo = mid,
			hi = mid
		],
		{10}
	];
	Floor[lo, 0.1]
];

sheetLabelBandLeft[label_String, {x_, y_}, {width_, height_}, textOptions_:<||>] := Module[
	{size, inset, transform, text, textColor, textWeight},
	size = Lookup[textOptions, "Size", sheetLeftLabelSize[label, width]];
	inset = 14;
	transform = Lookup[textOptions, "Transform", ToUpperCase];
	text = If[transform === None, label, transform[label]];
	textColor = Lookup[textOptions, "Color", sheetInk];
	textWeight = Lookup[textOptions, "Weight", Bold];
	{
		sheetTrackCell[{x, y}, {width, height}, White],
		Text[sheetStyle[text, size, textWeight, textColor], {x + inset, y + height/2}, {-1, 0}]
	}
];

sheetVowNameMargin[height_] :=
	sheetVowNameBaseHorizontalMargin height/sheetVowTrackHeight[sheetMiddleWidth];

sheetVowNameGlyphPadding[height_] :=
	sheetVowNameBaseGlyphPadding height/sheetVowTrackHeight[sheetMiddleWidth];

sheetVowNameContentMargin[height_] :=
	sheetVowNameMargin[height] + sheetVowNameGlyphPadding[height];

sheetVowNameTextScale[height_] :=
	height/sheetVowTrackHeight[sheetMiddleWidth];

sheetVowNameMinTextSize[height_] :=
	Max[1, sheetVowNameBaseMinTextSize sheetVowNameTextScale[height]];

sheetVowNameMaxTextSize[height_] :=
	Max[1, sheetVowNameBaseMaxTextSize sheetVowNameTextScale[height]];

sheetVowNameSize[text_String, width_, height_, weight_, fitScale_:1] := Module[
	{margin, availableWidth},
	margin = sheetVowNameContentMargin[height];
	availableWidth = Max[1, fitScale (width - 2 margin)];
	sheetFittedTextSize[
		text,
		availableWidth,
		weight,
		fitScale {sheetVowNameMinTextSize[height], sheetVowNameMaxTextSize[height]}
	]
];

sheetVowNameText[text_, {x_, y_}, {width_, height_}, size_, weight_, color_] := Module[
	{margin},
	margin = sheetVowNameContentMargin[height];
	Text[sheetStyle[text, size, weight, color], {x + margin, y + height/2}, {-1, 0}]
];

sheetJoinedLeftLabelBand[label_String, {x_, y_}, {width_, height_}, textOptions_:<||>] := Module[
	{size, fitScale, transform, text, textColor, textWeight, frameWidth, left, right, bottom, top},
	transform = Lookup[textOptions, "Transform", ToUpperCase];
	text = If[transform === None, label, transform[label]];
	textColor = Lookup[textOptions, "Color", sheetInk];
	textWeight = Lookup[textOptions, "Weight", Bold];
	fitScale = Lookup[textOptions, "FitScale", 1];
	size = Lookup[textOptions, "Size", sheetVowNameSize[text, width, height, textWeight, fitScale]];
	frameWidth = sheetFrameLineWidth[sheetTrackFrameThickness];
	left = x - frameWidth/2;
	right = x + width + frameWidth/2;
	bottom = y - frameWidth/2;
	top = y + height + frameWidth/2;
	{
		sheetFilledRect[{left, bottom}, {right, top}, White],
		sheetFilledRect[{left, bottom}, {x + frameWidth/2, top}, sheetInk],
		sheetFilledRect[{left, bottom}, {right, y + frameWidth/2}, sheetInk],
		sheetFilledRect[{left, y + height - frameWidth/2}, {right, top}, sheetInk],
		sheetVowNameText[text, {x, y}, {width, height}, size, textWeight, textColor]
	}
];

sheetSmallLabelBand[label_String, {x_, y_}, {width_, height_}] :=
	{
		sheetTrackCell[{x, y}, {width, height}, White],
		Text[sheetStyle[ToUpperCase[label], 12, Bold, sheetInk], {x + width/2, y + height/2}]
	};

sheetValueBox[label_String, value_, {x_, y_}, {width_, height_}] :=
	{
		sheetTrackCell[{x, y}, {width, height}, sheetPale],
		Text[sheetStyle[ToUpperCase[label], 12, Bold], {x + width/2, y + height - 14}],
		Text[sheetStyle[ToString[value], 26, Bold], {x + width/2, y + height/2 - 8}]
	};

sheetSignedNumberText[value_Integer, {x_, y_}, size_, weight_:Bold, color_:sheetInk] := Module[
	{sign, digits, signX},
	sign = Which[
		value > 0, "+",
		value < 0, "-",
		True, None
	];
	digits = ToString[Abs[value]];
	signX = x - Max[12, size (0.45 StringLength[digits] + 0.35)];
	DeleteCases[
		{
			If[sign === None, Nothing, Text[sheetStyle[sign, size, weight, color], {signX, y}]],
			Text[sheetStyle[digits, size, weight, color], {x, y}]
		},
		Nothing
	]
];

sheetNameField[character_String] := Module[
	{x, y, width, height},
	x = 22;
	y = sheetCanvasHeight - 94;
	width = 776;
	height = 58;
	{
		sheetRect[{x, y}, {width, height}, sheetDark, sheetDark],
		Text[sheetStyle[ToUpperCase[character], 28, Bold, White], {x + width/2, y + height/2}]
	}
];

sheetCanvasWidth = 820;
sheetCanvasHeight = 1252;
sheetPlotHorizontalInset = 4;
sheetPlotBottomInset = 6;
sheetPlotTopInset = 18;
sheetMiddleX = 162;
sheetMiddleWidth = $displayTrackWidth;
sheetMiddleTop := sheetCanvasHeight - 119;
sheetMiddleBottom = 24;
sheetSectionBannerHeight = 24;
sheetBannerContentGap = 10;
sheetStatBoxHeight = 68;
sheetDebilitySubheaderHeight = 20;
sheetDebilitySubheaderItemGap = 14;
sheetDebilityRowGap = 16;
sheetDebilityItemRadius = 5;
sheetExperienceColumns = 20;
sheetExperienceRows = 3;
sheetExperienceDotRadius = 5;
sheetExperienceRowGap = 18;
sheetVowLabelBaseWidth = 206;
sheetVowNameBaseHorizontalMargin = 14;
sheetVowNameBaseGlyphPadding = 2;
sheetVowNameBaseMinTextSize = 5;
sheetVowNameBaseMaxTextSize = 16;
sheetVowRankCenterGap = 14;
sheetRankDotRadius = 5;
sheetVowRowGap = 14;
sheetCurrentVowSlots = 3;

sheetCharacterTextFitScale[] :=
	$displayFrameContentWidth/(sheetCanvasWidth - 2 sheetPlotHorizontalInset);

sheetDebilityGroups[] := {
	"Conditions" -> {"Wounded", "Shaken", "Unprepared", "Encumbered"},
	"Burdens" -> {"Cursed", "Tormented", "Oathbreaker"},
	"Banes" -> {"Maimed", "Corrupted"}
};

sheetDebilityRowCount[] :=
	Max[Length /@ sheetDebilityGroups[][[All, 2]]];

sheetSectionHeight[contentHeight_] :=
	sheetSectionBannerHeight + sheetBannerContentGap + contentHeight;

sheetSectionHeaderY[topY_] :=
	topY - sheetSectionBannerHeight;

sheetSectionContentTopY[topY_] :=
	sheetSectionHeaderY[topY] - sheetBannerContentGap;

sheetSectionContentBottomY[topY_, contentHeight_] :=
	sheetSectionContentTopY[topY] - contentHeight;

sheetProgressTrackHeight[width_] :=
	width/10;

sheetStatsContentHeight[] :=
	sheetStatBoxHeight;

sheetDebilitiesContentHeight[] :=
	sheetDebilitySubheaderHeight + sheetDebilitySubheaderItemGap + (sheetDebilityRowCount[] - 1) sheetDebilityRowGap + sheetDebilityItemRadius;

sheetExperienceGridHeight[] :=
	2 sheetExperienceDotRadius + (sheetExperienceRows - 1) sheetExperienceRowGap;

sheetVowLabelWidth[width_] :=
	width sheetVowLabelBaseWidth/sheetMiddleWidth;

sheetVowTrackWidth[width_] :=
	width - sheetVowLabelWidth[width];

sheetVowTrackHeight[width_] :=
	sheetProgressTrackHeight[sheetVowTrackWidth[width]];

sheetVowRowHeight[width_] :=
	sheetVowTrackHeight[width] + sheetVowRankCenterGap + sheetRankDotRadius;

sheetVowsPanelHeight[width_:sheetMiddleWidth] :=
	sheetSectionHeight[sheetVowRowsHeight[sheetCurrentVowSlots, width]];

sheetVowRowsHeight[rowCount_Integer, width_] :=
	Max[0, rowCount] sheetVowRowHeight[width] + Max[0, rowCount - 1] sheetVowRowGap;

sheetFullWidthProgressPanelHeight[width_] :=
	sheetSectionHeight[sheetProgressTrackHeight[width]];

sheetMiddleBlocks[] := {
	"Stats" -> sheetSectionHeight[sheetStatsContentHeight[]],
	"Debilities" -> sheetSectionHeight[sheetDebilitiesContentHeight[]],
	"Experience" -> sheetSectionHeight[sheetExperienceGridHeight[]],
	"BackgroundVow" -> sheetSectionHeight[sheetVowRowHeight[sheetMiddleWidth]],
	"Vows" -> sheetVowsPanelHeight[sheetMiddleWidth],
	"Journey" -> sheetSectionHeight[sheetVowRowHeight[sheetMiddleWidth]],
	"Delve" -> sheetSectionHeight[sheetVowRowHeight[sheetMiddleWidth]],
	"Bonds" -> sheetFullWidthProgressPanelHeight[sheetMiddleWidth],
	"Failures" -> sheetFullWidthProgressPanelHeight[sheetMiddleWidth]
};

sheetMiddleInterSectionGap[] := Module[
	{blocks, totalHeight},
	blocks = sheetMiddleBlocks[];
	totalHeight = Total[blocks[[All, 2]]];
	(sheetMiddleTop - sheetMiddleBottom - totalHeight)/(Length[blocks] - 1)
];

sheetMiddleLayout[] := Module[
	{blocks, gap, y, layout},
	blocks = sheetMiddleBlocks[];
	gap = sheetMiddleInterSectionGap[];
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
	y = sheetSectionContentBottomY[topY, sheetStatsContentHeight[]];
	width = 92;
	gap = 9;
	sectionWidth = Length[statsData] width + (Length[statsData] - 1) gap;
	Join[
		sheetLabelBand["Stats", {startX, sheetSectionHeaderY[topY]}, {sectionWidth, sheetSectionBannerHeight}],
		Flatten[
			MapIndexed[
				sheetValueBox[#1[[1]], #1[[2]], {startX + (First[#2] - 1) (width + gap), y}, {width, sheetStatBoxHeight}] &,
				statsData
			],
			1
		]
	]
];

sheetVerticalResourceLabelHeight = 24;
sheetResourceColumnWidth = 124;
sheetResourceColumnGap = 5;
sheetResourceMaxValue = 5;
sheetResourceValueTextSize = 22;

sheetResourceColumnHeight :=
	(sheetMiddleTop - sheetMiddleBottom - 2 sheetResourceColumnGap)/3;

sheetVerticalResourceValues[max_Integer] :=
	Reverse[Range[0, max]];

sheetVerticalResourceBoxHeight[height_, max_Integer] :=
	(height - sheetVerticalResourceLabelHeight)/(max + 1);

sheetVerticalResourceSlotY[y_, index_Integer, count_Integer, boxHeight_] :=
	y + (count - index) boxHeight;

sheetVerticalResourceCell[value_Integer, selected_Integer, {x_, y_}, {width_, height_}, indicatorSide_:Right, indicatorScale_:1] := Module[
	{fill, textColor},
	fill = sheetLight;
	textColor = sheetInk;
	Join[
		sheetTrackCell[{x, y}, {width, height}, fill],
		sheetSignedNumberText[value, {x + width/2, y + height/2}, sheetResourceValueTextSize, Bold, textColor],
		{If[
			value === selected,
			sheetValueIndicator[{x, y}, {width, height}, indicatorSide, indicatorScale],
			Nothing
		]}
	]
];

sheetVerticalResourceCells[selected_Integer, {x_, y_}, {width_, height_}, max_Integer, indicatorSide_:Right, indicatorScale_:1] := Module[
	{boxHeight, values},
	boxHeight = sheetVerticalResourceBoxHeight[height, max];
	values = sheetVerticalResourceValues[max];
	Flatten[
		MapIndexed[
			sheetVerticalResourceCell[
				#1,
				selected,
				{x, sheetVerticalResourceSlotY[y, First[#2], Length[values], boxHeight]},
				{width, boxHeight},
				indicatorSide,
				indicatorScale
			] &,
			values
		],
		1
	]
];

sheetVerticalResource[label_String, value_Integer, {x_, y_}, {width_, height_}, max_:5, indicatorSide_:Right, indicatorScale_:1] :=
	Join[
		sheetLadderLabelBand[label, {x, y + height - sheetVerticalResourceLabelHeight}, {width, sheetVerticalResourceLabelHeight}],
		sheetVerticalResourceCells[value, {x, y}, {width, height}, max, indicatorSide, indicatorScale]
	];

sheetMomentumColumn[character_String, characterData_Association] := Module[
	{values, x, y, width, height, labelHeight, boxHeight, current, max, reset},
	values = Range[10, -6, -1];
	x = 22;
	y = sheetMiddleBottom;
	width = 124;
	height = sheetMiddleTop - sheetMiddleBottom;
	labelHeight = 24;
	boxHeight = (height - labelHeight)/Length[values];
	current = characterData["momentum"];
	max = momentumMaxValue[characterData];
	reset = momentumResetValue[characterData];
	Join[
		sheetLadderLabelBand["Momentum", {x, y + height - labelHeight}, {width, labelHeight}],
		Flatten[
			MapIndexed[
				Module[{slotY, fill, textColor},
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
					Join[
						sheetTrackCell[{x, slotY}, {width, boxHeight}, fill],
						sheetSignedNumberText[#1, {x + width/2, slotY + boxHeight/2}, sheetResourceValueTextSize, Bold, textColor],
						{If[
							#1 === current,
							sheetValueIndicator[{x, slotY}, {width, boxHeight}, Left],
							Nothing
						]}
					]
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
		y = sheetMiddleBottom;
		width = sheetResourceColumnWidth;
		height = sheetResourceColumnHeight;
		gap = sheetResourceColumnGap;
		Join[
			sheetVerticalResource["Health", characterData["health"], {x, y + 2 (height + gap)}, {width, height}],
			sheetVerticalResource["Spirit", characterData["spirit"], {x, y + height + gap}, {width, height}],
			sheetVerticalResource["Supply", characterData["supply"], {x, y}, {width, height}]
		]
	];

Options[sheetProgressInset] = {JoinedLeftFrame -> False};

sheetProgressInset[progress_, {x_, y_}, {width_, height_}, menace_:None, opts : OptionsPattern[]] :=
	progressTrackPrimitives[
		{x, y},
		progress,
		width,
		height,
		MenaceProgress -> menace,
		TrackFrameThickness -> sheetTrackFrameThickness,
		JoinedLeftFrame -> OptionValue[JoinedLeftFrame]
	];

sheetFullWidthProgressPanel[label_String, progress_, topY_] := Module[
	{x, width, trackHeight, headerY, trackY},
	x = sheetMiddleX;
	width = sheetMiddleWidth;
	trackHeight = sheetProgressTrackHeight[width];
	headerY = sheetSectionHeaderY[topY];
	trackY = sheetSectionContentBottomY[topY, trackHeight];
	{
		sheetLabelBand[label, {x, headerY}, {width, sheetSectionBannerHeight}],
		sheetProgressInset[progress, {x, trackY}, {width, trackHeight}]
	}
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

sheetRankDotsCentered[rank_, {x_, y_}, width_, rankOptions_:progressRanks] := Module[
	{gap, labelInset, radius, widths, cxs, rowLeft, rowRight, offset},
	gap = 30;
	labelInset = 12;
	radius = sheetRankDotRadius;
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
	{bondTrack},
	bondTrack = Lookup[characterData, "bondProgress", fallbackProgressTrack["Bonds", Epic]];
	sheetFullWidthProgressPanel["Bonds", bondTrack["Progress"], topY]
];

sheetVowRow[vowData_, label_String, {x_, y_}, {width_, height_}, rowOptions_:<||>] := Module[
	{
		hasVow, vowName, hasVowName, progress, rank, menace, bannerText, bannerOptions,
		rowBannerOptions, labelWidth, trackWidth, trackHeight, trackY, rankOptions, rankY
	},
	hasVow = AssociationQ[vowData];
	vowName = If[hasVow, Lookup[vowData, "Name", ""], ""];
	hasVowName = StringQ[vowName] && StringTrim[vowName] =!= "";
	progress = If[hasVow, vowData["Progress"], 0];
	rank = If[hasVow, vowData["Rank"], None];
	menace = If[hasVow && AssociationQ[Lookup[vowData, "Threat", None]], vowData["Threat", "Menace", "progress"], None];
	bannerText = If[hasVowName, vowName, "Empty"];
	rowBannerOptions = Lookup[rowOptions, "BannerOptions", <||>];
	bannerOptions = Join[
		rowBannerOptions,
		If[
			hasVowName,
			<||>,
			<|"Color" -> sheetHintInk|>
		]
	];
	labelWidth = sheetVowLabelWidth[width];
	trackWidth = sheetVowTrackWidth[width];
	trackHeight = sheetVowTrackHeight[width];
	trackY = y + height - trackHeight;
	rankOptions = If[label === "Background Vow", {Extreme, Epic}, progressRanks];
	rankY = trackY - sheetVowRankCenterGap;
	{
		sheetJoinedLeftLabelBand[bannerText, {x, trackY}, {labelWidth, trackHeight}, bannerOptions],
		sheetProgressInset[progress, {x + labelWidth, trackY}, {trackWidth, trackHeight}, menace, JoinedLeftFrame -> True],
		sheetRankDotsCentered[rank, {x, rankY}, width, rankOptions]
	}
];

sheetVowRows[vows_List, label_String, {x_, firstRowY_}, width_, rowOptions_:<||>] := Module[
	{rowHeight, pitch},
	rowHeight = sheetVowRowHeight[width];
	pitch = rowHeight + sheetVowRowGap;
	Flatten[
		MapIndexed[
			sheetVowRow[#1, label, {x, firstRowY - (First[#2] - 1) pitch}, {width, rowHeight}, rowOptions] &,
			vows
		],
		1
	]
];

sheetVowSectionFirstRowY[topY_, width_] :=
	sheetSectionContentBottomY[topY, sheetVowRowHeight[width]];

sheetVowSectionPrimitives[title_String, vows_List, rowLabel_String, {x_, topY_}, width_, rowOptions_:<||>] := Module[
	{firstRowY},
	firstRowY = sheetVowSectionFirstRowY[topY, width];
	Join[
		{sheetLabelBand[title, {x, sheetSectionHeaderY[topY]}, {width, sheetSectionBannerHeight}]},
		sheetVowRows[vows, rowLabel, {x, firstRowY}, width, rowOptions]
	]
];

sheetVowsPanel[characterData_Association, backgroundTopY_:704, vowsTopY_:574] := Module[
	{vows, backgroundVow, currentVows, x, width, rowOptions, currentStartY, currentPitch, overflow},
	vows = Values[Lookup[characterData, "vows", <||>]];
	backgroundVow = If[vows === {}, None, First[vows]];
	currentVows = PadRight[Take[If[Length[vows] > 1, Rest[vows], {}], UpTo[sheetCurrentVowSlots]], sheetCurrentVowSlots, None];
	x = sheetMiddleX;
	width = sheetMiddleWidth;
	rowOptions = <|"BannerOptions" -> <|"FitScale" -> sheetCharacterTextFitScale[]|>|>;
	currentStartY = sheetVowSectionFirstRowY[vowsTopY, width];
	currentPitch = sheetVowRowHeight[width] + sheetVowRowGap;
	overflow = Max[0, Length[vows] - 1 - sheetCurrentVowSlots];
	Flatten[
		Join[
			sheetVowSectionPrimitives["Background Vow", {backgroundVow}, "Background Vow", {x, backgroundTopY}, width, rowOptions],
			sheetVowSectionPrimitives["Vows", currentVows, "Current Vow", {x, vowsTopY}, width, rowOptions],
			If[
				overflow > 0,
				{Text[sheetStyle[StringJoin["+", ToString[overflow], " more vows"], 12, Bold], {x + width - 8, currentStartY - Length[currentVows] currentPitch + 12}, {1, 0}]},
				{}
			]
		],
		1
	]
];

sheetJourneyPanel[characterData_Association, topY_] := Module[
	{journey, x, width, rowOptions},
	journey = Lookup[characterData, "journey", None];
	x = sheetMiddleX;
	width = sheetMiddleWidth;
	rowOptions = <|"BannerOptions" -> <|"FitScale" -> sheetCharacterTextFitScale[]|>|>;
	sheetVowSectionPrimitives["Journey", {journey}, "Journey", {x, topY}, width, rowOptions]
];

sheetCurrentDelveData[characterData_Association] := Module[
	{current, delves},
	current = Lookup[characterData, "currentDelve", None];
	delves = Lookup[characterData, "delves", <||>];
	If[StringQ[current] && AssociationQ[delves] && KeyExistsQ[delves, current],
		delves[current],
		None
	]
];

sheetDelvePanel[characterData_Association, topY_] := Module[
	{delve, x, width, rowOptions},
	delve = sheetCurrentDelveData[characterData];
	x = sheetMiddleX;
	width = sheetMiddleWidth;
	rowOptions = <|"BannerOptions" -> <|"FitScale" -> sheetCharacterTextFitScale[]|>|>;
	sheetVowSectionPrimitives["Delve", {delve}, "Delve", {x, topY}, width, rowOptions]
];

sheetFailurePanel[characterData_Association, topY_:86] := Module[
	{failures},
	failures = Lookup[characterData, "failures", fallbackProgressTrack["Failures", Epic]];
	sheetFullWidthProgressPanel["Failures", failures["Progress"], topY]
];

sheetExperiencePanel[characterData_Association, topY_:821] := Module[
	{earned, spent, total, columns, rows, radius, x, y, width, rowGap, colGap},
	earned = Clip[Lookup[characterData, "earnedExperience", 0], {0, 60}];
	spent = Clip[Lookup[characterData, "spentExperience", 0], {0, 60}];
	total = 60;
	columns = sheetExperienceColumns;
	rows = sheetExperienceRows;
	radius = sheetExperienceDotRadius;
	x = sheetMiddleX;
	width = sheetMiddleWidth;
	rowGap = sheetExperienceRowGap;
	y = sheetSectionContentTopY[topY] - radius - (rows - 1) rowGap;
	colGap = (width - 2 radius)/(columns - 1);
	Join[
		sheetLabelBand["Experience", {x, sheetSectionHeaderY[topY]}, {width, sheetSectionBannerHeight}],
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

sheetDebilityItem[debility_, active_List, {x_, y_}] := Module[
	{marked},
	marked = MemberQ[active, debility];
	{
		FaceForm[If[marked, sheetInk, White]],
		EdgeForm[Directive[sheetInk, AbsoluteThickness[sheetTrackFrameThickness]]],
		Disk[{x + 12, y}, sheetDebilityItemRadius],
		Text[sheetStyle[ToUpperCase[debilityLabel[debility]], 9, Bold], {x + 24, y}, {-1, 0}]
	}
];

sheetDebilityColumn[title_String, debilityList_List, active_List, {x_, y_}, width_] := Module[
	{rowGap},
	rowGap = sheetDebilityRowGap;
	Join[
		sheetSmallLabelBand[title, {x, y}, {width, sheetDebilitySubheaderHeight}],
		Flatten[
			MapIndexed[
				sheetDebilityItem[#1, active, {x + 6, y - sheetDebilitySubheaderItemGap - (First[#2] - 1) rowGap}] &,
				debilityList
			],
			1
		]
	]
];

sheetDebilitiesPanel[characterData_Association, topY_:950] := Module[
	{active, x, width, gap, groups, colWidth, columnY},
	active = debilityLabel /@ Lookup[characterData, "debilities", {}];
	x = sheetMiddleX;
	width = sheetMiddleWidth;
	gap = 16;
	groups = sheetDebilityGroups[];
	colWidth = (width - (Length[groups] - 1) gap)/Length[groups];
	columnY = sheetSectionContentTopY[topY] - sheetDebilitySubheaderHeight;
	Join[
		sheetLabelBand["Debilities", {x, sheetSectionHeaderY[topY]}, {width, sheetSectionBannerHeight}],
		Flatten[
			MapIndexed[
				sheetDebilityColumn[
					#1[[1]],
					#1[[2]],
					active,
					{x + (First[#2] - 1) (colWidth + gap), columnY},
					colWidth
				] &,
				groups
			],
			1
		]
	]
];

lodestarCharacterSheetGraphic[character_String, characterData_Association] := Module[
	{width, height, middleLayout},
	width = sheetCanvasWidth;
	height = sheetCanvasHeight;
	middleLayout = sheetMiddleLayout[];
	Graphics[
		Flatten[
			{
				sheetNameField[character],
				sheetStats[characterData, middleLayout["Stats"]],
				sheetDebilitiesPanel[characterData, middleLayout["Debilities"]],
				sheetExperiencePanel[characterData, middleLayout["Experience"]],
				sheetVowsPanel[characterData, middleLayout["BackgroundVow"], middleLayout["Vows"]],
				sheetJourneyPanel[characterData, middleLayout["Journey"]],
				sheetDelvePanel[characterData, middleLayout["Delve"]],
				sheetBondsPanel[characterData, middleLayout["Bonds"]],
				sheetFailurePanel[characterData, middleLayout["Failures"]],
				sheetMomentumColumn[character, characterData],
				sheetResourceColumns[characterData]
			},
			1
		],
		PlotRange -> {
			{sheetPlotHorizontalInset, width - sheetPlotHorizontalInset},
			{sheetPlotBottomInset, height - sheetPlotTopInset}
		},
		ImagePadding -> 0,
		ImageSize -> baseSize[$displayFrameContentWidth],
		Background -> White
	]
];

characterSheetDisplay[character_String, characterData_Association] :=
	characterSheetFramed[scaleFinalGraphic[lodestarCharacterSheetGraphic[character, characterData], White]];

displayCharacterSheet[character_String, characterData_Association] := Module[{},
	printAndReturn[characterSheetDisplay[character, characterData], characterData]
];

displayCharacterSheet[args___] := (
	Message[IronLibrary`displayCharacterSheet::badargs, HoldForm[displayCharacterSheet[args]]];
	$Failed
);

IronLibrary`displayCharacterSheet::badargs = "displayCharacterSheet is a display helper API and expects displayCharacterSheet[character, characterData].";

IronLibrary`displayAssetCard::badtext =
"Asset ability text must use p, paras, or choiceSection. Raw string ability text is not accepted: `1`.";

IronLibrary`displayAssetCard::badchoice =
"Asset choices must use choice[key, text] or choiceGroup[label, choices]. Raw choice item is not accepted: `1`.";

IronLibrary`displayAssetAbility::badability =
"Ability `1` is not available for asset `2`. Valid ability indices are 1 through `3`.";


(* ::Subsection:: *)
(*Asset card display*)


assetCardWidth :=
	displayFrameBodyWidth;

assetBulletWidth :=
	scaled[26];

assetAbilityIndent :=
	scaled[14];

assetBodyWidth[contentWidth_:assetCardWidth] :=
	Max[1, contentWidth - assetAbilityIndent - assetBulletWidth];

assetContentPane[x_, width_:assetCardWidth] :=
	Pane[
		x,
		{width, Automatic},
		Alignment -> Left
	];

assetBlankValueQ[value_] :=
	MissingQ[value] || (StringQ[value] && StringLength[StringTrim[value]] == 0);

assetFieldValueDisplay[value_] :=
	If[
		StringQ[value] && StringLength[StringTrim[value]] > 0,
		value,
		If[assetBlankValueQ[value],
			"____________",
			ToString[value]
		]
	];

assetNameFieldQ[fieldDef_Association] :=
	ToLowerCase[ToString[Lookup[fieldDef, "Key", ""]]] === "name" ||
		ToLowerCase[ToString[Lookup[fieldDef, "Label", ""]]] === "name";

assetMarkerFieldQ[fieldDef_Association] :=
	ToLowerCase[ToString[Lookup[fieldDef, "Type", ""]]] === "select_enhancement" ||
		ToLowerCase[ToString[Lookup[fieldDef, "Key", ""]]] === "equipped" ||
		ToLowerCase[ToString[Lookup[fieldDef, "Label", ""]]] === "equipped";

assetMarkerSelectedQ[value_] :=
	!assetBlankValueQ[value] &&
		value =!= False &&
		value =!= None &&
		value =!= 0;

assetFieldDisplayedQ[fieldDef_Association] :=
	Lookup[fieldDef, "Display", True] =!= False;

assetCircleSize :=
	scaled[12];

assetCircleLineHeight :=
	scaled[20];

assetCircleGraphic[selectedQ_] :=
	Graphics[
		If[
			TrueQ[selectedQ],
			{FaceForm[sheetInk], EdgeForm[None], Disk[{0, 0}, 1]},
			{FaceForm[White], EdgeForm[{sheetInk, AbsoluteThickness[scaled[1.25]]}], Disk[{0, 0}, 1]}
		],
		Background -> None,
		BaselinePosition -> Center,
		ImagePadding -> 0,
		ImageSize -> {assetCircleSize, assetCircleSize},
		PlotRange -> {{-1.15, 1.15}, {-1.15, 1.15}}
	];

assetCirclePane[selectedQ_, width_, horizontalAlignment_:Left] :=
	Pane[
		assetCircleGraphic[selectedQ],
		{width, assetCircleLineHeight},
		Alignment -> {horizontalAlignment, Center}
	];

assetMarkerFieldRow[label_String, value_, contentWidth_:assetCardWidth] :=
	assetContentPane[
		Row[
			{
				assetCirclePane[assetMarkerSelectedQ[value], assetCircleLineHeight, Center],
				Spacer[scaled[8]],
				displayText[ToUpperCase[label], $displaySansFont, 12, Bold, sheetInk]
			}
		],
		contentWidth
	];

assetNameBoxGraphic[value_, placeholder_:"Name", boxWidth_:assetCardWidth] := Module[
	{text, textColor, inset, height, frameThickness, contentWidth, contentHeight},
	text = If[assetBlankValueQ[value], placeholder, ToString[value]];
	textColor = If[assetBlankValueQ[value], sheetHintInk, sheetInk];
	inset = scaled[$assetNameBoxInset];
	height = scaled[$assetNameBoxHeight];
	frameThickness = displayTrackFrameThickness;
	contentWidth = Max[1, boxWidth - 2 inset - 2 frameThickness];
	contentHeight = Max[1, height - 2 frameThickness];
	Framed[
		Pane[
			displayText[text, $displaySansFont, 16, Bold, textColor],
			{contentWidth, contentHeight},
			Alignment -> {Left, Center}
		],
		FrameStyle -> Directive[sheetInk, AbsoluteThickness[frameThickness]],
		FrameMargins -> {{inset, inset}, {0, 0}},
		RoundingRadius -> 0,
		Background -> White
	]
];

assetNameFieldKey[record_Association] :=
	FirstCase[
		Normal[Lookup[record, "Fields", <||>]],
		Rule[key_, fieldDef_Association] /; assetFieldDisplayedQ[fieldDef] && assetNameFieldQ[fieldDef] :> key,
		None
	];

assetTitleRow[record_Association, fields_Association, contentWidth_:assetCardWidth] := Module[
	{nameKey},
	nameKey = assetNameFieldKey[record];
	If[nameKey === None,
		Return[Nothing]
	];
	assetContentPane[assetNameBoxGraphic[Lookup[fields, nameKey, ""], "Name", contentWidth], contentWidth]
];

assetFieldRow[label_String, value_, contentWidth_:assetCardWidth] :=
	assetContentPane[
		displayLabelValue[label, assetFieldValueDisplay[value]],
		contentWidth
	];

assetFieldRow[fieldKey_String, fieldDef_Association, fields_Association, contentWidth_:assetCardWidth] :=
	Which[
		!assetFieldDisplayedQ[fieldDef],
			Nothing,
		assetNameFieldQ[fieldDef],
			assetNameBoxGraphic[Lookup[fields, fieldKey, ""], "Name"],
		assetMarkerFieldQ[fieldDef],
			assetMarkerFieldRow[Lookup[fieldDef, "Label", fieldKey], Lookup[fields, fieldKey, ""], contentWidth],
		True,
			assetFieldRow[Lookup[fieldDef, "Label", fieldKey], Lookup[fields, fieldKey, ""], contentWidth]
	];

assetFieldRows[record_Association, fields_Association, contentWidth_:assetCardWidth] :=
	KeyValueMap[
		If[assetNameFieldQ[#2], Nothing, assetFieldRow[#1, #2, fields, contentWidth]] &,
		Lookup[record, "Fields", <||>]
	];

assetAbilityTitle[name_String] /; StringLength[StringTrim[name]] > 0 :=
	displayText[name, $displaySansFont, 17, Bold];

assetAbilityTitle[_] :=
	Nothing;

assetTextEmptyQ[text_] :=
	MissingQ[text] || text === None || text === Null ||
		(StringQ[text] && StringLength[StringTrim[text]] == 0);

assetFieldSelectorQ[item_] :=
	AssociationQ[item] && Lookup[item, "Type", None] === "FieldSelector";

assetFieldSelectorComparable[value_] :=
	StringTrim[
		StringReplace[
			ToLowerCase[ToString[value]],
			RegularExpression["[^a-z0-9]+"] -> "-"
		],
		"-"
	];

assetFieldSelectorSelectedQ[current_, option_Association] :=
	MemberQ[
		assetFieldSelectorComparable /@ {
			Lookup[option, "Value", ""],
			Lookup[option, "Label", ""]
		},
		assetFieldSelectorComparable[current]
	];

assetFieldSelectorOptionDisplay[current_, option_Association] :=
	Grid[
		{{
			assetCirclePane[assetFieldSelectorSelectedQ[current, option], assetCircleLineHeight, Center],
			displayText[
				ToUpperCase[Lookup[option, "Label", Lookup[option, "Value", ""]]],
				$displaySansFont,
				12,
				Bold,
				sheetInk
			]
		}},
		Alignment -> {{Center, Left}, Center},
		Spacings -> {0.4, 0}
	];

assetFieldSelectorDisplay[selector_Association, fields_Association] := Module[
	{field, current, options},
	field = Lookup[selector, "Field", ""];
	current = Lookup[fields, field, ""];
	options = Select[Lookup[selector, "Options", {}], AssociationQ];
	If[options === {}, Return[""]];
	Grid[
		{assetFieldSelectorOptionDisplay[current, #] & /@ options},
		Alignment -> {Left, Center},
		Spacings -> {1.2, 0}
	]
];

assetDisplayText[text_String, fields_Association:<||>] :=
	StringReplace[StringTrim[text], WhitespaceCharacter.. -> " "];

assetDisplayText[text_Association, fields_Association:<||>] /; assetFieldSelectorQ[text] :=
	assetFieldSelectorDisplay[text, fields];

assetDisplayText[text_, fields_Association:<||>] :=
	text;

assetParagraphBlock[items_List, fields_Association:<||>] := Module[
	{content},
	content = DeleteCases[assetDisplayText[#, fields] & /@ items, _?assetTextEmptyQ];
	Which[
		content === {}, "",
		Length[content] == 1, First[content],
		True, Apply[IronLibrary`TextHelpers`paras, content]
	]
];

assetChoiceKey[text_, index_Integer] := Module[
	{source, label, key},
	source = If[StringQ[text], text, ToString[text, InputForm]];
	label = First[StringSplit[source, ":"], source];
	key = StringTrim[StringReplace[ToLowerCase[label], RegularExpression["[^a-z0-9]+"] -> "-"], "-"];
	If[StringLength[key] > 0, key, StringJoin["choice-", ToString[index]]]
];

assetNormalizeChoice[choice_Association, index_Integer] /; KeyExistsQ[choice, "Text"] := Module[
	{text},
	text = Lookup[choice, "Text", ""];
	Association[
		choice,
		"Type" -> Lookup[choice, "Type", "Choice"],
		"Key" -> Lookup[choice, "Key", assetChoiceKey[text, index]],
		"Text" -> assetDisplayText[text]
	]
];

assetNormalizeChoice[choice_, _] := (
	Message[IronLibrary`displayAssetCard::badchoice, HoldForm[choice]];
	$Failed
);

assetNormalizeChoices[choices_List] :=
	DeleteCases[MapIndexed[assetNormalizeChoice[#1, First[#2]] &, choices], $Failed];

assetNormalizeChoiceItems[choices_List] :=
	assetNormalizeChoices[IronLibrary`TextHelpers`flattenChoices[choices]];

assetChoiceNumberWidth :=
	scaled[18];

assetChoiceNumberGap :=
	scaled[4];

assetChoiceTextWidth[bodyWidth_] :=
	Max[scaled[40], bodyWidth - assetChoiceNumberWidth - assetChoiceNumberGap];

	assetAbilitySectionsFromChoiceSection[section_Association, fields_Association:<||>] :=
		<|
			"PreText" -> assetParagraphBlock[Lookup[section, "PreText", {}], fields],
			"Choices" -> assetNormalizeChoiceItems[Lookup[section, "ChoiceItems", {}]],
			"PostText" -> assetParagraphBlock[Lookup[section, "PostText", {}], fields],
			"DisplayChoices" -> True,
			"ChoiceDisplay" -> Lookup[section, "ChoiceDisplay", "Numbered"],
			"ChoiceField" -> Lookup[section, "ChoiceField", None]
		|>;

assetAbilitySectionsFromMoveSection[section_Association, fields_Association:<||>] :=
	<|
		"PreText" -> assetDisplayText[Lookup[section, "Text", ""]],
		"Choices" -> assetNormalizeChoices[Lookup[section, "Choices", {}]],
		"PostText" -> "",
		"DisplayChoices" -> False
	|>;

assetAbilitySections[text_String, fields_Association:<||>] := (
	Message[IronLibrary`displayAssetCard::badtext, text];
	$Failed
);

assetAbilitySections[text_, fields_Association:<||>] :=
	<|"PreText" -> assetDisplayText[text], "Choices" -> {}, "PostText" -> "", "DisplayChoices" -> True|>;

assetAbilitySections[ability_Association, fields_Association:<||>] := Module[
	{text, sections, explicitChoices},
	text = Lookup[ability, "Text", ""];
	sections = Which[
		AssociationQ[text] && KeyExistsQ[text, "ChoiceItems"], assetAbilitySectionsFromChoiceSection[text, fields],
		AssociationQ[text] && KeyExistsQ[text, "Text"], assetAbilitySectionsFromMoveSection[text, fields],
		True, assetAbilitySections[text, fields]
	];
	If[sections === $Failed, Return[$Failed]];
	explicitChoices = Lookup[ability, "Choices", Automatic];
	If[ListQ[explicitChoices],
		sections["Choices"] = assetNormalizeChoiceItems[explicitChoices];
		sections["DisplayChoices"] = True
	];
	sections
];

	assetNumberedChoiceRow[index_Integer, choice_Association, bodyWidth_] :=
		Grid[
			{{
				Pane[
				StringJoin[ToString[index], "."],
				{assetChoiceNumberWidth, Automatic},
				Alignment -> Right
			],
			Pane[
				assetDisplayText[Lookup[choice, "Text", ""]],
				{assetChoiceTextWidth[bodyWidth], Automatic},
				Alignment -> Left
			]
		}},
		Alignment -> {Left, Top},
			Spacings -> {0.35, 0}
		];

assetFieldSelectorChoiceSelectedQ[current_, choice_Association] :=
	Module[
		{currentKey, optionKeys},
		currentKey = assetFieldSelectorComparable[current];
		If[currentKey === "", Return[False]];
		optionKeys = DeleteCases[
			assetFieldSelectorComparable /@ {
				Lookup[choice, "Value", ""],
				Lookup[choice, "Key", ""]
			},
			""
		];
		MemberQ[optionKeys, currentKey]
	];

	assetFieldSelectorChoiceRow[choice_Association, field_String, fields_Association, bodyWidth_] := Module[
		{current},
		current = Lookup[fields, field, ""];
		Grid[
			{{
				assetCirclePane[assetFieldSelectorChoiceSelectedQ[current, choice], assetChoiceNumberWidth, Right],
				Pane[
					assetDisplayText[Lookup[choice, "Text", ""]],
					{assetChoiceTextWidth[bodyWidth], Automatic},
					Alignment -> Left
				]
			}},
			Alignment -> {Left, Top},
			Spacings -> {0.35, 0}
		]
	];

	assetChoiceRows[choices_List, sections_Association, choiceOffset_Integer, bodyWidth_, fields_Association] := Module[
		{choiceDisplay, choiceField},
		choiceDisplay = Lookup[sections, "ChoiceDisplay", "Numbered"];
		choiceField = Lookup[sections, "ChoiceField", None];
		If[choiceDisplay === "FieldSelector" && StringQ[choiceField],
			assetFieldSelectorChoiceRow[#, choiceField, fields, bodyWidth] & /@ choices,
			MapIndexed[assetNumberedChoiceRow[choiceOffset + First[#2], #1, bodyWidth] &, choices]
		]
	];

	assetAbilityBodyRows[ability_Association, choiceOffset_Integer, bodyWidth_:assetBodyWidth[], fields_Association:<||>] := Module[
		{sections, rows, choices, displayChoices},
		sections = assetAbilitySections[ability, fields];
	If[sections === $Failed, Return[$Failed]];
	choices = Lookup[sections, "Choices", {}];
	displayChoices = Lookup[sections, "DisplayChoices", True];
	Join[
			If[Lookup[sections, "PreText", ""] === "", {}, {sections["PreText"]}],
			If[TrueQ[displayChoices], assetChoiceRows[choices, sections, choiceOffset, bodyWidth, fields], {}],
			If[Lookup[sections, "PostText", ""] === "", {}, {sections["PostText"]}]
	]
];

assetAbilityContinuationDisplay[rows_List] :=
	Which[
		rows === {},
			None,
		Length[rows] == 1,
			First[rows],
		True,
			Column[rows, Spacings -> 0.35, Alignment -> Left]
	];

assetAbilityFirstLineGap[hasTitle_] :=
	If[TrueQ[hasTitle], 0.2, 0.35];

assetAbilityChoices[ability_Association] := Module[
	{sections},
	sections = assetAbilitySections[ability];
	If[AssociationQ[sections], Lookup[sections, "Choices", {}], {}]
];

assetAbilityRow[ability_Association, selectedQ_, contentWidth_:assetCardWidth, choiceOffset_:0, fields_Association:<||>] := Module[
	{bodyRows, bodyDisplays, name, hasTitle, firstLine, continuation},
	bodyRows = assetAbilityBodyRows[ability, choiceOffset, assetBodyWidth[contentWidth], fields];
	If[bodyRows === $Failed, Return[$Failed]];
	bodyDisplays = moveTextStyle /@ bodyRows;
	name = Lookup[ability, "Name", ""];
	hasTitle = StringQ[name] && StringLength[StringTrim[name]] > 0;
	firstLine = If[hasTitle, assetAbilityTitle[name], First[bodyDisplays, ""]];
	continuation = If[
		hasTitle,
		assetAbilityContinuationDisplay[bodyDisplays],
		assetAbilityContinuationDisplay[Rest[bodyDisplays]]
	];
	assetContentPane[
		Grid[
			DeleteCases[
				{
					{
						Spacer[{assetAbilityIndent, 0}],
						assetCirclePane[selectedQ, assetBulletWidth, Left],
						Pane[
							firstLine,
							{assetBodyWidth[contentWidth], Automatic},
							Alignment -> Left
						]
					},
					If[
						continuation === None,
						Nothing,
						{
							Spacer[{assetAbilityIndent, 0}],
							Spacer[{assetBulletWidth, 0}],
							Pane[
								continuation,
								{assetBodyWidth[contentWidth], Automatic},
								Alignment -> Left
							]
						}
					]
				},
				Nothing
			],
			Alignment -> {{Left, Left, Left}, {Top}},
			Spacings -> {0, assetAbilityFirstLineGap[hasTitle]}
		],
		contentWidth
	]
];

assetAbilityRows[record_Association, selectedAbilities_List, contentWidth_?NumericQ] :=
	assetAbilityRows[record, selectedAbilities, <||>, contentWidth];

assetAbilityRows[record_Association, selectedAbilities_List] :=
	assetAbilityRows[record, selectedAbilities, <||>, assetCardWidth];

assetAbilityRows[record_Association, selectedAbilities_List, fields_Association, contentWidth_:assetCardWidth] := Module[
	{offset = 0},
	Map[
		Module[{row, choiceCount},
			row = assetAbilityRow[#, MemberQ[selectedAbilities, #["Index"]], contentWidth, offset, fields];
			choiceCount = Length[assetAbilityChoices[#]];
			offset += choiceCount;
			row
		] &,
		Lookup[record, "Abilities", {}]
	]
];

assetCardChoices[record_Association] :=
	Flatten[assetAbilityChoices /@ Lookup[record, "Abilities", {}]];

	assetAbilityDefinition[record_Association, ability_Integer] :=
		FirstCase[
			Lookup[record, "Abilities", {}],
			abilityDef_Association /; Lookup[abilityDef, "Index", None] === ability :> abilityDef,
			Missing["UnknownAbility", ability]
		];

assetAbilityDisplayStatus[ability_Integer, Automatic] :=
	StringJoin["Ability ", ToString[ability]];

assetAbilityDisplayStatus[_, status_] :=
	status;

assetTrackValues[record_Association, tracks_Association] :=
	Join[assetDefaultTrackValues[record], tracks];

assetTrackDefinitionForDisplay[record_Association, trackName_String, trackDef_Association, selectedAbilities_List] :=
	If[
		Lookup[record, "Name", ""] === "Awakening" &&
			trackName === "health" &&
			MemberQ[selectedAbilities, 2],
		Association[trackDef, "Max" -> 6],
		trackDef
	];

assetTrackEntriesForDisplay[record_Association, tracks_Association, selectedAbilities_:{}] := Module[
	{trackDefs, values},
	trackDefs = Lookup[record, "Tracks", <||>];
	values = assetTrackValues[record, tracks];
	KeyValueMap[
		Module[{trackDef = assetTrackDefinitionForDisplay[record, #1, #2, selectedAbilities]},
			<|
				"Name" -> #1,
				"Definition" -> trackDef,
				"Label" -> Lookup[trackDef, "Label", #1],
				"Current" -> Lookup[values, #1, Lookup[trackDef, "Default", 0]],
				"Min" -> Lookup[trackDef, "Min", 0],
				"Max" -> Lookup[trackDef, "Max", 5]
			|>
		] &,
		trackDefs
	]
];

assetTrackEntryForDisplay[record_Association, tracks_Association, selectedAbilities_:{}] := Module[
	{entries},
	entries = assetTrackEntriesForDisplay[record, tracks, selectedAbilities];
	If[Length[entries] == 0, None, First[entries]]
];

assetTrackRenderScale[] :=
	sheetCharacterTextFitScale[];

assetTrackBaseWidth[] :=
	sheetResourceColumnWidth;

assetTrackBaseHeight[max_Integer] :=
	sheetVerticalResourceLabelHeight +
		(max + 1) sheetVerticalResourceBoxHeight[sheetResourceColumnHeight, sheetResourceMaxValue];

assetTrackIndicatorScale[] :=
	1;

assetTrackIndicatorOutset[] :=
	sheetValueIndicatorOutset[Right, assetTrackIndicatorScale[]];

assetTrackIndicatorDisplayOutset[] :=
	scaled[assetTrackRenderScale[] assetTrackIndicatorOutset[]];

assetTrackBasePlotWidth[] :=
	assetTrackBaseWidth[] + assetTrackIndicatorOutset[];

assetTrackDisplayWidth[] :=
	scaled[assetTrackRenderScale[] assetTrackBaseWidth[]];

assetTrackDisplayHeight[max_Integer] :=
	scaled[assetTrackRenderScale[] assetTrackBaseHeight[max]];

assetTrackGraphic[track_Association] := Module[
	{height, image},
	height = assetTrackBaseHeight[track["Max"]];
	image = scaleFinalGraphic[
		Graphics[
			sheetVerticalResource[
				track["Label"],
				track["Current"],
				{0, 0},
				{assetTrackBaseWidth[], height},
				track["Max"],
				Right,
				assetTrackIndicatorScale[]
			],
			PlotRange -> {{0, assetTrackBasePlotWidth[]}, {0, height}},
			PlotRangePadding -> None,
			ImagePadding -> 1,
			ImageSize -> {
				baseSize[assetTrackRenderScale[] assetTrackBasePlotWidth[]],
				baseSize[assetTrackRenderScale[] height]
			},
			Background -> White
		],
		White
	];
	Show[
		image,
		ImageSize -> {assetTrackDisplayWidth[] + assetTrackIndicatorDisplayOutset[], Automatic}
	]
];

assetTrackColumn[record_Association, tracks_Association, selectedAbilities_:{}] := Module[
	{entry},
	entry = assetTrackEntryForDisplay[record, tracks, selectedAbilities];
	If[
		entry === None,
		None,
		<|
			"Graphic" -> assetTrackGraphic[entry],
			"Width" -> assetTrackDisplayWidth[],
			"Height" -> assetTrackDisplayHeight[entry["Max"]],
			"Outset" -> assetTrackIndicatorDisplayOutset[]
		|>
	]
];

assetTextWidthWithSideTrack[sideTrack_Association] :=
	assetCardWidth - sideTrack["Width"] - scaled[$assetTrackGap];

assetSideTrackPane[sideTrack_Association] :=
	Pane[
		sideTrack["Graphic"],
		{sideTrack["Width"] + Lookup[sideTrack, "Outset", 0], sideTrack["Height"]},
		Alignment -> {Left, Top}
	];

assetTextAndTrackColumns[textRows_List, sideTrack_Association, textWidth_] :=
	assetContentPane[
		Grid[
			{{
				Pane[Column[textRows, Spacings -> 0.8, Alignment -> Left], {textWidth, Automatic}, Alignment -> Left],
				Spacer[{scaled[$assetTrackGap], 0}],
				Item[assetSideTrackPane[sideTrack], Alignment -> {Left, Top}]
			}},
			Alignment -> {{Left, Left, Left}, {Top}},
			Spacings -> {0, 0}
		],
		assetCardWidth + Lookup[sideTrack, "Outset", 0]
	];

assetRowsWithSideTrack[textRows_List, None, _] :=
	textRows;

assetRowsWithSideTrack[textRows_List, sideTrack_Association, textWidth_] :=
	{assetTextAndTrackColumns[textRows, sideTrack, textWidth]};

assetRarityRows[None, contentWidth_:assetCardWidth] :=
	{};

assetRarityNameStyle[rarity_] :=
	displayText[rarity, $displaySerifFont, 18, Plain, $displayInk, FontSlant -> Italic];

assetRarityRows[rarity_String, contentWidth_:assetCardWidth] /; StringLength[StringTrim[rarity]] > 0 :=
	{
		displayLineHeaderBlock["Rarity", rarity, assetRarityNameStyle]
	};

assetRarityRows[_, contentWidth_:assetCardWidth] :=
	{};

assetCardStatusTitleOverride[status_String] := Module[
	{normalized},
	normalized = ToLowerCase[StringTrim[status]];
	Switch[
		normalized,
		"added rarity", "Gained Rarity",
		"removed rarity", "Lost Rarity",
		"ironclad armor", "Ironclad Armor",
		_, None
	]
];

assetCardStatusTitleOverride[_] :=
	None;

assetCardHeaderTitle[record_Association, status_:None] := Module[
	{category, override},
	category = Lookup[record, "Category", "Asset"];
	override = assetCardStatusTitleOverride[status];
	If[StringQ[override],
		override,
		displayContextualTitle["Asset", category, status]
	]
];

assetCardHeaderSubtitle[record_Association] :=
	Lookup[record, "Name", "Asset"];

assetCardHeader[record_Association, status_] := Module[
	{title, subtitle},
	title = assetCardHeaderTitle[record, status];
	subtitle = assetCardHeaderSubtitle[record];
	If[assetBlankValueQ[subtitle],
		header[title],
		header[title, subtitle]
	]
];

assetAbilityCardHeader[record_Association, status_] := Module[
	{title, subtitle},
	title = assetCardHeaderSubtitle[record];
	subtitle = If[assetBlankValueQ[status], "Ability", status];
	header[title, subtitle]
];

assetOutputSubtitle[record_Association] :=
	Lookup[record, "Name", ""];

assetCardExpression[record_Association, selectedAbilities_List, fields_Association, tracks_Association, rarity_:None, status_:None] := Module[
	{sideTrack, textWidth, rarityRows, fieldRows, requirementRows, abilityRows, bodyRows},
	sideTrack = assetTrackColumn[record, tracks, selectedAbilities];
	textWidth = If[AssociationQ[sideTrack], assetTextWidthWithSideTrack[sideTrack], assetCardWidth];
	rarityRows = assetRarityRows[rarity];
	fieldRows = assetFieldRows[record, fields];
	requirementRows = If[
		assetTextEmptyQ[Lookup[record, "Requirement", None]],
		{},
		{assetContentPane[moveTextStyle[Lookup[record, "Requirement", None]], textWidth]}
	];
	abilityRows = assetAbilityRows[record, selectedAbilities, fields, textWidth];
	bodyRows = assetRowsWithSideTrack[Join[requirementRows, abilityRows], sideTrack, textWidth];
	ironFramed[
		Column[
			Join[
				{
					assetCardHeader[record, status],
					assetTitleRow[record, fields]
				},
				fieldRows,
				bodyRows,
				rarityRows
			],
			Spacings -> 0.8,
			Alignment -> Left
		]
	]
];

assetCardExpression[owned_Association, status_:None] := Module[
	{record},
	record = assetDefinition[owned["Name"]];
	If[!AssociationQ[record],
		Message[IronLibrary`asset::unknown, owned["Name"]];
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

assetAbilityCardExpression[owned_Association, ability_Integer, status_:Automatic] := Module[
	{record, abilityDef, selectedAbilities, fields, row, statusText},
	record = assetDefinition[owned["Name"]];
	If[!AssociationQ[record],
		Message[IronLibrary`asset::unknown, owned["Name"]];
		Return[$Failed]
	];
	abilityDef = assetAbilityDefinition[record, ability];
	If[!AssociationQ[abilityDef],
		Message[IronLibrary`displayAssetAbility::badability, ability, record["Name"], Length[Lookup[record, "Abilities", {}]]];
		Return[$Failed]
	];
	selectedAbilities = Lookup[owned, "Abilities", {}];
	fields = Lookup[owned, "Fields", <||>];
	row = assetAbilityRow[abilityDef, MemberQ[selectedAbilities, ability], assetCardWidth, 0, fields];
	If[row === $Failed, Return[$Failed]];
	statusText = assetAbilityDisplayStatus[ability, status];
	ironFramed[
		Column[
			{
				assetAbilityCardHeader[record, statusText],
				assetTitleRow[record, fields],
				row
			},
			Spacings -> 0.8,
			Alignment -> Left
		]
	]
];

assetRecordOutput[record_Association, status_:None] :=
	AssetDisplayOutput[
		<|
			"Asset" -> Lookup[record, "Name", ""],
			"Name" -> Lookup[record, "Name", ""],
			"Subtitle" -> assetOutputSubtitle[record],
			"Choices" -> assetCardChoices[record]
		|>
	];

assetOwnedOutput[owned_Association, status_:None] := Module[
	{record},
	record = assetDefinition[owned["Name"]];
	If[!AssociationQ[record], Return[$Failed]];
	assetRecordOutput[record, status]
];

assetAbilityOutput[owned_Association, ability_Integer, status_:Automatic] := Module[
	{record, abilityDef, statusText},
	record = assetDefinition[owned["Name"]];
	If[!AssociationQ[record], Return[$Failed]];
	abilityDef = assetAbilityDefinition[record, ability];
	If[!AssociationQ[abilityDef], Return[$Failed]];
	statusText = assetAbilityDisplayStatus[ability, status];
	AssetDisplayOutput[
		<|
			"Asset" -> Lookup[record, "Name", ""],
			"Name" -> Lookup[record, "Name", ""],
			"Ability" -> ability,
			"Subtitle" -> Lookup[record, "Name", ""],
			"Choices" -> assetAbilityChoices[abilityDef]
		|>
	]
];

assetReferenceCard[name_String] := Module[
	{record, fields},
	record = assetDefinition[name];
	If[!AssociationQ[record],
		Message[IronLibrary`asset::unknown, name];
		Return[$Failed]
	];
	fields = assetFieldsWithDefaults[<||>, record];
	assetCardExpression[
		record,
		assetDefaultAbilities[record],
		fields,
		assetDefaultTrackValues[record],
		None
	]
];

displayAssetCard[owned_Association, status_:None] := Module[
	{card, output},
	card = assetCardExpression[owned, status];
	If[card === $Failed, Return[$Failed]];
	output = assetOwnedOutput[owned, status];
	printAndReturn[card, output]
];

displayAssetAbility[owned_Association, ability_Integer, status_:Automatic] := Module[
	{card, output},
	card = assetAbilityCardExpression[owned, ability, status];
	If[card === $Failed, Return[$Failed]];
	output = assetAbilityOutput[owned, ability, status];
	printAndReturn[card, output]
];

displayAssetReference[name_String] := Module[
	{record, card},
	record = assetDefinition[name];
	If[!AssociationQ[record],
		Message[IronLibrary`asset::unknown, name];
		Return[$Failed]
	];
	card = assetReferenceCard[name];
	If[card === $Failed, Return[$Failed]];
	printAndReturn[card, assetRecordOutput[record]]
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


(* ::Subsection:: *)
(*Progress track primitives*)


formatProgressValue[value_] :=
	ToString[NumberForm[N[value], {3, 2}, NumberPadding -> {"", "0"}]];

progressTickCount[progress_] :=
	Clip[Round[4 N[progress]], {0, 40}];

progressBoxTickCount[totalTicks_Integer, box_Integer] :=
	Clip[totalTicks - 4 (box - 1), {0, 4}];

progressTickStarEndpoints[{centerX_, centerY_}, side_?NumericQ, tick_Integer] := Module[
	{half},
	half = side/2;
	Switch[
		tick,
		1, {{centerX - half, centerY - half}, {centerX + half, centerY + half}},
		2, {{centerX - half, centerY + half}, {centerX + half, centerY - half}},
		3, {{centerX, centerY - half}, {centerX, centerY + half}},
		4, {{centerX - half, centerY}, {centerX + half, centerY}},
		_, {}
	]
];

progressTickPrimitive[center_List, side_?NumericQ, tick_Integer, color_] := Module[
	{endpoints},
	endpoints = progressTickStarEndpoints[center, side, tick];
	If[endpoints === {}, Return[{}]];
	{
		color,
		AbsoluteThickness[1.8],
		CapForm["Butt"],
		Line[endpoints]
	}
];

progressTickStarPrimitives[center_List, side_?NumericQ, tickCount_Integer, color_] :=
	Flatten[
		Table[
			progressTickPrimitive[center, side, tick, color],
			{tick, tickCount}
		],
		1
	];

progressTrackLineWidth[frameThickness_] :=
	sheetFrameLineWidth[frameThickness];

progressFilledRect[{left_, bottom_}, {right_, top_}, fill_] :=
	sheetFilledRect[{left, bottom}, {right, top}, fill];

displayCardSectionGap = 0.8;
displayLineHeaderHeight = 30;
displayLineHeaderRuleGap = 10;
displayLineHeaderHorizontalInset = 0;
displayTrackLineHeaderGap = displayCardSectionGap;
displayLineHeaderContentGap = displayCardSectionGap;

displayLineHeaderTextWidth[label_String] :=
	Max[42, 8 StringLength[StringTrim[label]] + 12];

displayLineHeaderPrimitives[label_String, width_, y_, textWidth_, gap_, horizontalInset_] := Module[
	{centerX, lineY, thickness},
	centerX = width/2;
	lineY = y;
	thickness = progressTrackLineWidth[displayTrackFrameThickness];
	{
		progressFilledRect[
			{horizontalInset, lineY - thickness/2},
			{centerX - textWidth/2 - gap, lineY + thickness/2},
			sheetInk
		],
		progressFilledRect[
			{centerX + textWidth/2 + gap, lineY - thickness/2},
			{width - horizontalInset, lineY + thickness/2},
			sheetInk
		],
		Text[
			displayText[ToUpperCase[label], $displaySansFont, 14, Bold, sheetInk],
			{centerX, y},
			{0, 0}
		]
	}
];

displayLineHeaderGraphic[label_String, width_:Automatic, height_:Automatic, textWidth_:Automatic] := Module[
	{baseWidth, baseHeight, baseTextWidth},
	baseWidth = Replace[width, Automatic :> $displayFrameTrackWidth];
	baseHeight = Replace[height, Automatic :> displayLineHeaderHeight];
	baseTextWidth = Replace[textWidth, Automatic :> displayLineHeaderTextWidth[label]];
	Graphics[
		displayLineHeaderPrimitives[
			label,
			baseWidth,
			baseHeight/2,
			baseTextWidth,
			displayLineHeaderRuleGap,
			displayLineHeaderHorizontalInset
		],
		PlotRange -> {{0, baseWidth}, {0, baseHeight}},
		PlotRangePadding -> None,
		ImagePadding -> 0,
		ImageSize -> {scaled[baseWidth], scaled[baseHeight]},
		Background -> White
	]
];

centeredMoveTextPane[text_, textStyle_:moveTextStyle] :=
	Pane[
		Style[textStyle[text], TextAlignment -> Center],
		{displayFrameBodyWidth, Automatic},
		Alignment -> {Center, Center}
	];

displayLineHeaderBlock[label_String, text_, textStyle_:moveTextStyle] :=
	Column[
		{
			displayLineHeaderGraphic[label],
			centeredMoveTextPane[text, textStyle]
		},
		Spacings -> displayLineHeaderContentGap,
		Alignment -> Center
	];

displayLineHeaderFollowupColumn[followups_List, spacing_:displayLineHeaderContentGap] :=
	Column[
		followups,
		Spacings -> spacing,
		Alignment -> Left
	];

displayTrackLineHeaderStack[trackRows_List, followups_List, followupSpacing_:displayLineHeaderContentGap] := Module[
	{tracks, details, trackContent},
	tracks = DeleteCases[trackRows, Nothing];
	details = DeleteCases[followups, Nothing];
	Which[
		tracks === {} && details === {}, Nothing,
		tracks === {}, displayLineHeaderFollowupColumn[details, followupSpacing],
		details === {}, If[Length[tracks] == 1, First[tracks], Column[tracks, Spacings -> displayCardSectionGap, Alignment -> Left]],
		True,
			trackContent = If[Length[tracks] == 1, First[tracks], Column[tracks, Spacings -> displayCardSectionGap, Alignment -> Left]];
			Column[
				{
					trackContent,
					displayLineHeaderFollowupColumn[details, followupSpacing]
				},
				Spacings -> displayTrackLineHeaderGap,
				Alignment -> Left
			]
	]
];

progressTrackBoundary[x_, width_, boxCount_Integer, index_Integer] :=
	x + index width/boxCount;

progressBoxBounds[{x_, y_}, width_, height_, box_Integer, boxCount_Integer] :=
	{
		{progressTrackBoundary[x, width, boxCount, box - 1], y},
		{progressTrackBoundary[x, width, boxCount, box], y + height}
	};

progressBoxTickCenter[{{left_, bottom_}, {right_, top_}}] :=
	{
		(left + right)/2,
		(bottom + top)/2
	};

progressBoxTickSide[{{left_, bottom_}, {right_, top_}}] :=
	Min[right - left, top - bottom];

progressBoxTickPrimitives[bounds : {{left_, bottom_}, {right_, top_}}, tickCount_Integer, color_] :=
	progressTickStarPrimitives[
		progressBoxTickCenter[bounds],
		progressBoxTickSide[bounds],
		tickCount,
		color
	];

progressTrackFrameVerticalBand[{x_, y_}, width_, height_, thickness_, color_, index_Integer, boxCount_Integer, joinedLeftFrame_:False] := Module[
	{center, band},
	center = progressTrackBoundary[x, width, boxCount, index];
	band = {center - thickness/2, center + thickness/2};
	progressFilledRect[{band[[1]], y}, {band[[2]], y + height}, color]
];

progressTrackFramePrimitives[{x_, y_}, width_, height_, frameThickness_, color_, joinedLeftFrame_:False, boxCount_:10] := Module[
	{thickness, horizontalLeft, horizontalRight, horizontalBottom, horizontalTop, verticals},
	thickness = progressTrackLineWidth[frameThickness];
	horizontalLeft = x - thickness/2;
	horizontalRight = x + width + thickness/2;
	horizontalBottom = {y - thickness/2, y + thickness/2};
	horizontalTop = {y + height - thickness/2, y + height + thickness/2};
	verticals = Table[
		progressTrackFrameVerticalBand[
			{x, y},
			width,
			height,
			thickness,
			color,
			index,
			boxCount,
			joinedLeftFrame
		],
		{index, 0, boxCount}
	];
	Join[
		progressFilledRect[{horizontalLeft, horizontalBottom[[1]]}, {horizontalRight, horizontalBottom[[2]]}, color],
		progressFilledRect[{horizontalLeft, horizontalTop[[1]]}, {horizontalRight, horizontalTop[[2]]}, color],
		Flatten[verticals, 1]
	]
];

menaceCornerPrimitives[x_, y_, width_, height_, tickCount_Integer, color_, frameThickness_] := Module[
	{cornerSize, thickness, cx, cy, fill},
	cornerSize = Min[0.28 width, 0.42 height];
	cx = x + width - cornerSize;
	cy = y + height - cornerSize;
	thickness = progressTrackLineWidth[frameThickness];
	fill = Which[
		tickCount >= 4, color,
		tickCount > 0, GrayLevel[0.78],
		True, White
	];
	{
		progressFilledRect[{cx, cy}, {x + width, y + height}, fill],
		progressFilledRect[{cx, cy}, {cx + thickness, y + height}, GrayLevel[0.255]],
		progressFilledRect[{cx, cy}, {x + width, cy + thickness}, GrayLevel[0.255]]
	}
];

countdownCornerBoxIndices[] :=
	{1, 4, 7, 10};

countdownCornerTickCount[countdown_, box_Integer] := Module[
	{boxes, markedBoxes},
	boxes = countdownCornerBoxIndices[];
	If[!MemberQ[boxes, box], Return[None]];
	markedBoxes = Take[boxes, UpTo[Clip[Round[N[countdown]], {0, Length[boxes]}]]];
	If[MemberQ[markedBoxes, box], 4, 0]
];

Options[progressTrackPrimitives] = {
	MenaceProgress -> None,
	CountdownProgress -> None,
	TrackFrameThickness -> Automatic,
	JoinedLeftFrame -> False
};

progressTrackPrimitives[{x_, y_}, progress_, width_, height_, opts : OptionsPattern[]] := Module[
	{boxCount, totalTicks, menaceProgress, menaceTicks, countdownProgress, color, frameThickness, joinedLeftFrame, menacePrimitives, framePrimitives, tickPrimitives, boxBounds},
	boxCount = 10;
	totalTicks = progressTickCount[progress];
	menaceProgress = OptionValue[MenaceProgress];
	menaceTicks = If[menaceProgress === None, None, progressTickCount[menaceProgress]];
	countdownProgress = OptionValue[CountdownProgress];
	color = GrayLevel[0.255];
	frameThickness = Replace[OptionValue[TrackFrameThickness], Automatic :> sheetTrackFrameThickness];
	joinedLeftFrame = TrueQ[OptionValue[JoinedLeftFrame]];
	boxBounds[box_Integer] :=
		progressBoxBounds[{x, y}, width, height, box, boxCount];
	menacePrimitives = Flatten[
		Table[
			Join[
				If[
					menaceTicks === None,
					{},
					With[{bounds = boxBounds[box]},
						menaceCornerPrimitives[
							bounds[[1, 1]],
							bounds[[1, 2]],
							bounds[[2, 1]] - bounds[[1, 1]],
							bounds[[2, 2]] - bounds[[1, 2]],
							progressBoxTickCount[menaceTicks, box],
							color,
							frameThickness
						]
					]
				],
				With[{countdownTicks = If[countdownProgress === None, None, countdownCornerTickCount[countdownProgress, box]]},
					If[
						countdownTicks === None,
						{},
						With[{bounds = boxBounds[box]},
							menaceCornerPrimitives[
								bounds[[1, 1]],
								bounds[[1, 2]],
								bounds[[2, 1]] - bounds[[1, 1]],
								bounds[[2, 2]] - bounds[[1, 2]],
								countdownTicks,
								color,
								frameThickness
							]
						]
					]
				]
			],
			{box, boxCount}
		],
		1
	];
	tickPrimitives = Flatten[
		Table[
			progressBoxTickPrimitives[
				boxBounds[box],
				progressBoxTickCount[totalTicks, box],
				color
			],
			{box, boxCount}
		],
		1
	];
	framePrimitives = progressTrackFramePrimitives[{x, y}, width, height, frameThickness, color, joinedLeftFrame, boxCount];
	Join[tickPrimitives, menacePrimitives, framePrimitives]
];

Options[progressTrackGraphic] = {
	MenaceProgress -> None,
	CountdownProgress -> None,
	TrackWidth -> Automatic,
	TrackHeight -> Automatic,
	TrackFrameThickness -> Automatic,
	ImageScale -> 1
};

progressTrackDimensions[widthOption_, heightOption_] := Module[
	{width, height},
	width = Replace[widthOption, Automatic :> $displayFrameTrackWidth];
	height = Replace[heightOption, Automatic :> Replace[$displayFrameTrackHeight, Automatic :> width/10]];
	{width, height}
];

progressTrackGraphic[progress_, opts : OptionsPattern[]] := Module[
	{width, height, scale, frameThickness, frameOutset},
	{width, height} = progressTrackDimensions[OptionValue[TrackWidth], OptionValue[TrackHeight]];
	scale = OptionValue[ImageScale];
	frameThickness = Replace[OptionValue[TrackFrameThickness], Automatic :> displayTrackFrameThickness];
	frameOutset = progressTrackLineWidth[frameThickness]/2;
	Graphics[
		progressTrackPrimitives[
			{0, 0},
			progress,
			width,
			height,
			MenaceProgress -> OptionValue[MenaceProgress],
			CountdownProgress -> OptionValue[CountdownProgress],
			TrackFrameThickness -> frameThickness
		],
		PlotRange -> {{-frameOutset, width + frameOutset}, {-frameOutset, height + frameOutset}},
		PlotRangePadding -> None,
		ImagePadding -> 0,
		ImageSize -> {scaled[(width + 2 frameOutset) scale], scaled[(height + 2 frameOutset) scale]},
		Background -> None
	]
];

displayBannerGraphic[label_String, width_:Automatic, height_:Automatic] := Module[
	{baseWidth, baseHeight},
	baseWidth = Replace[width, Automatic :> $displayFrameTrackWidth];
	baseHeight = Replace[height, Automatic :> $displayTrackBannerHeight];
	Framed[
		Pane[
			displayText[
				ToUpperCase[label],
				$displaySansFont,
				$displayFrameBannerTextSize,
				Bold,
				White
			],
			{scaled[baseWidth], scaled[baseHeight]},
			Alignment -> Center
		],
		Background -> sheetDark,
		FrameStyle -> sheetDark,
		FrameMargins -> 0,
		RoundingRadius -> 0
	]
];

displayHeaderText[text_String, size_?NumericQ, width_:Automatic] := Module[
	{textSize},
	textSize = If[
		NumericQ[width],
		sheetFittedTextSize[text, Max[1, width], Bold, {Max[5.5, 0.25 size], size}],
		size
	];
	Style[
		text,
		White,
		LineBreakWithin -> False,
		FontFamily -> $displaySansFont,
		FontSize -> scaled[textSize],
		FontWeight -> Bold
	]
];

displayHeaderBanner[title_String, subtitle_:None, width_:Automatic, height_:Automatic, titleFraction_:Automatic] := Module[
	{baseWidth, baseHeight, inset, contentWidth, titlePaneWidth, subtitlePaneWidth, titleText, subtitleText, content},
	baseWidth = Replace[width, Automatic :> $displayFrameTrackWidth];
	baseHeight = Replace[height, Automatic :> $displayTrackBannerHeight];
	inset = $displayHeaderBannerInset;
	contentWidth = baseWidth - 2 inset;
	titlePaneWidth = Which[
		subtitle === None, contentWidth,
		NumericQ[titleFraction], contentWidth titleFraction,
		True, contentWidth 0.68
	];
	subtitlePaneWidth = contentWidth - titlePaneWidth;
	titleText = displayHeaderText[ToUpperCase[title], $displayFrameBannerTextSize, titlePaneWidth];
	content = If[
		subtitle === None,
		Pane[
			titleText,
			{scaled[contentWidth], scaled[baseHeight]},
			Alignment -> {Left, Center}
		],
		subtitleText = displayHeaderText[ToUpperCase[subtitle], $displayFrameBannerTextSize, subtitlePaneWidth];
		Row[
			{
				Pane[
					titleText,
					{scaled[titlePaneWidth], scaled[baseHeight]},
					Alignment -> {Left, Center}
				],
				Pane[
					subtitleText,
					{scaled[subtitlePaneWidth], scaled[baseHeight]},
					Alignment -> {Right, Center}
				]
			}
		]
	];
	Framed[
		Pane[
			content,
			{scaled[baseWidth], scaled[baseHeight]},
			Alignment -> Center
		],
		Background -> sheetDark,
		FrameStyle -> sheetDark,
		FrameMargins -> 0,
		RoundingRadius -> 0
	]
];

displayStatusActionKey[status_String] := Module[{words},
	words = StringSplit[StringTrim[status]];
	If[words === {}, None, ToLowerCase[First[words]]]
];

displayStatusActionKey[_] :=
	None;

displayGenericStatusVerb[action_String] :=
	Switch[
		action,
		"added", "Added",
		"removed", "Removed",
		"upgraded", "Upgraded",
		"began", "Began",
		"ended", "Ended",
		_, None
	];

displayGenericStatusVerb[_] :=
	None;

displayMutationAction[status_] :=
	displayGenericStatusVerb[displayStatusActionKey[status]];

displayContextVerb[type_, status_:None] := Module[
	{action, kind},
	action = displayStatusActionKey[status];
	kind = ToLowerCase[ToString[type]];
	Switch[
		{kind, action},
		{"asset", "added"}, "Added",
		{"asset", "removed"}, "Removed",
		{"asset", "upgraded"}, "Upgraded",
		{"foe", "added"}, "Encountered",
		{"foe", "removed"}, "Survived",
		{"vow", "added"}, "Swore",
		{"vow", "removed"}, "Resolved",
		{"delve", "added"}, "Discovered",
		{"delve", "began"}, "Entered",
		{"delve", "ended"}, "Escaped",
		_, displayGenericStatusVerb[action]
	]
];

displayContextualTitle[type_, title_String, status_:None] := Module[
	{verb},
	verb = displayContextVerb[type, status];
	If[verb === None, title, StringJoin[verb, " ", title]]
];

displayStatusTitle[title_String, status_:None] :=
	displayContextualTitle[title, title, status];

displayRankedObjectTitle[type_String, rank_, status_:None] :=
	displayContextualTitle[
		type,
		rankedProgressSubtitle[rank, progressTypeTitle[type]],
		status
	];

displayNamedObjectHeader[type_String, name_String, rank_, status_:None] :=
	header[displayRankedObjectTitle[type, rank, status], name];

displayNamedObjectHeader[type_String, name_, rank_, status_:None] :=
	displayNamedObjectHeader[type, ToString[name], rank, status];

progressSummaryHeader[label_String, rank_, progress_] :=
	displayLabelValue[
		label,
		StringJoin[ToString[rank], "  ", formatProgressValue[progress]],
		Function[value, displayText[value, $displaySansFont, 14, Plain, $displayMutedInk]]
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


(* ::Subsection::Closed:: *)
(*Vows, progress objects, and bonds*)


vowProgressSummary[vowData_Association] := Module[
	{ownedThreat, menaceProgress},
	ownedThreat = Lookup[vowData, "Threat", None];
	menaceProgress = If[AssociationQ[ownedThreat], ownedThreat["Menace", "progress"], None];
	progressTrackGraphic[vowData["Progress"], MenaceProgress -> menaceProgress]
];

rankedProgressSubtitle[rank_, type_String] :=
	StringJoin[
		ToString[rank],
		" ",
		type
	];

vowHeaderTitle[vowData_Association, status_:None] :=
	displayRankedObjectTitle["Vow", vowData["Rank"], status];

vowHeaderSubtitle[vowData_Association] :=
	vowData["Name"];

vowThreatText[threat_Association] :=
	StringJoin[threat["Name"], " (", threat["Goal"], ")"];

vowThreatBlock[threat_Association] :=
	displayLineHeaderBlock["Threat", vowThreatText[threat]];

displayVowCard[vowData_Association, status_:None] := Module[
	{rows, ownedThreat},
	ownedThreat = Lookup[vowData, "Threat", None];
	rows = {
		header[vowHeaderTitle[vowData, status], vowHeaderSubtitle[vowData]],
		displayTrackLineHeaderStack[
			{vowProgressSummary[vowData]},
			If[AssociationQ[ownedThreat], {vowThreatBlock[ownedThreat]}, {}]
		]
	};
	ironFramed[Column[rows, Spacings -> displayCardSectionGap, Alignment -> Left]]
];

displayVowCards[vowData_Association] :=
	displayVowCards[Values[vowData]];

displayVowRows[vowData_List] :=
	If[vowData === {}, {None}, vowData];

displayVowListGraphic[vowData_List] := Module[
	{rows, width, height, topY},
	rows = displayVowRows[vowData];
	width = $displayFrameTrackWidth;
	height = sheetSectionHeight[sheetVowRowsHeight[Length[rows], width]];
	topY = height;
	Graphics[
		sheetVowSectionPrimitives["Vows", rows, "Current Vow", {0, topY}, width],
		PlotRange -> {{0, width}, {0, height}},
		ImagePadding -> 0,
		ImageSize -> baseSize[width],
		Background -> White
	]
];

displayVowListPanel[vowData_List] :=
	ironFramed[scaleFinalGraphic[displayVowListGraphic[vowData], White]];

displayVowCards[vowData_List] :=
	Print[displayVowListPanel[vowData]];


displayFoeListGraphic[foeData_List] := Module[
	{width, height, topY},
	width = $displayFrameTrackWidth;
	height = sheetSectionHeight[sheetVowRowsHeight[Length[foeData], width]];
	topY = height;
	Graphics[
		sheetVowSectionPrimitives["Foes", foeData, "Foe", {0, topY}, width],
		PlotRange -> {{0, width}, {0, height}},
		ImagePadding -> 0,
		ImageSize -> baseSize[width],
		Background -> White
	]
];

displayFoeListPanel[foeData_List] :=
	ironFramed[scaleFinalGraphic[displayFoeListGraphic[foeData], White]];

displayFoeCards[foeData_Association] :=
	displayFoeCards[Values[foeData]];

displayFoeCards[foeData_List] :=
	Print[displayFoeListPanel[foeData]];


progressTypeTitle["Vow"] := "Vow";
progressTypeTitle["Threat"] := "Threat";
progressTypeTitle["Delve"] := "Delve";
progressTypeTitle["Scene"] := "Scene";
progressTypeTitle["Journey"] := "Journey";
progressTypeTitle["Foe"] := "Foe";
progressTypeTitle["Failures"] := "Failures";
progressTypeTitle["Bonds"] := "Bonds";
progressTypeTitle[other_] := ToString[other];

progressTargetHeaderTitle[target_Association, status_:None] :=
	displayRankedObjectTitle[target["Type"], target["Rank"], status];

progressTargetHeaderSubtitle[target_Association] :=
	target["Name"];

displayNamedProgressTargetCard[target_Association, status_:None] :=
	ironFramed[
		Column[
			{
				header[progressTargetHeaderTitle[target, status], progressTargetHeaderSubtitle[target]],
				progressTrackGraphic[target["Progress"]]
			},
			Spacings -> 0.8,
			Alignment -> Left
		]
	];

displayProgressTargetCard[target_Association, status_:None] := Module[
	{rows, label, centeredTrackTypes},
	If[MemberQ[{"Foe", "Journey"}, target["Type"]], Return[displayNamedProgressTargetCard[target, status]]];
	label = If[target["Type"] === "Threat", "Menace", "Progress"];
	centeredTrackTypes = {"Bonds", "Failures"};
	rows = {
		If[
			MemberQ[centeredTrackTypes, target["Type"]],
			displayBannerGraphic[displayStatusTitle[progressTypeTitle[target["Type"]], status]],
			header[progressTargetHeaderTitle[target, status], progressTargetHeaderSubtitle[target]]
		]
	};
	If[target["Type"] === "Threat" && KeyExistsQ[target, "Vow"],
		rows = Append[rows, subtitleStyle[StringJoin["Vow: ", target["Vow"]]]]
	];
	rows = Append[
		rows,
		If[
			MemberQ[centeredTrackTypes, target["Type"]],
			progressTrackGraphic[target["Progress"]],
			progressSummary[label, target["Rank"], target["Progress"]]
		]
	];
	ironFramed[Column[rows, Spacings -> 0.8, Alignment -> Left]]
];


displayProgressObject[type_String, object_Association, status_:None] :=
	displayProgressTargetCard[
		Association[
			"Type" -> type,
			"Name" -> object["Name"],
			"Rank" -> object["Rank"],
			"Progress" -> object["Progress"]
		],
		status
	];

displayProgressObjectCard[type_String, object_Association, status_:None] :=
	Print[displayProgressObject[type, object, status]];

displayProgressObjectCards["Foe", objects_Association] :=
	displayFoeCards[objects];

displayProgressObjectCards["Foe", objects_List] :=
	displayFoeCards[objects];

displayProgressObjectCards[type_String, objects_Association] :=
	displayProgressObjectCards[type, Values[objects]];

displayProgressObjectCards[type_String, objects_List] :=
	displayExpressionList[displayProgressObject[type, #] & /@ objects];



bondListText[names_List] :=
	If[names === {}, "None", StringRiffle[names, ", "]];

bondProgressGraphic[track_Association] :=
	progressTrackGraphic[Lookup[track, "Progress", 0]];

bondProgressGraphic[_] :=
	Nothing;

bondListHeader[status_] :=
	displayStatusTitle["Bonds", status];

displayBondList[names_List, track_:None, status_:None] :=
	Print[
		ironFramed[
			Column[
				{
					displayBannerGraphic[bondListHeader[status]],
					displayTrackLineHeaderStack[
						{bondProgressGraphic[track]},
						{
							displayLineHeaderBlock["List", bondListText[names]]
						}
					]
				},
				Spacings -> displayCardSectionGap,
				Alignment -> Left
			]
		]
	];


(* ::Subsection:: *)
(*Scenes and delves*)


sceneCountdownSummary[countdown_] :=
	displayLabelValue["Countdown", StringJoin[ToString[countdown], "/4"]];

displaySceneCard[sceneData_Association, status_:None] :=
	ironFramed[
		Column[
			{
				displayNamedObjectHeader["Scene", sceneData["Name"], sceneData["Rank"], status],
				progressTrackGraphic[sceneData["Progress"], CountdownProgress -> sceneData["Countdown"]]
			},
			Spacings -> 0.8,
			Alignment -> Left
		]
	];

displayScene[sceneData_Association, status_:None] :=
	printAndReturn[displaySceneCard[sceneData, status], sceneData];



delveTypeTitle[delveData_Association] := Module[
	{themeText, domainText},
	themeText = StringRiffle[Lookup[delveData, "Themes", {delveData["Theme"]}], " / "];
	domainText = StringRiffle[Lookup[delveData, "Domains", {delveData["Domain"]}], " / "];
	StringRiffle[
		DeleteCases[
			{
				ToString[delveData["Rank"]],
				themeText,
				domainText
			},
			""
		],
		" "
	]
];

delveCardTitle[delveData_Association, status_:None] :=
	displayContextualTitle["Delve", delveTypeTitle[delveData], status];

delveCardSubtitle[delveData_Association] :=
	Lookup[delveData, "Name", ""];

denizenDisplayName[None] :=
	"";

denizenDisplayName[name_String] :=
	name;

denizenDisplayName[value_] :=
	ToString[value];

denizenMatrixColumns = 4;
denizenMatrixRows = 3;
denizenMatrixHorizontalInset = 0;
denizenMatrixVerticalInset = 6;
denizenMatrixRowHeight = 40;
denizenMatrixRowGap = 6;
denizenMatrixColumnGap = 6;
denizenMatrixSlotHeaderHeight = 12;
denizenMatrixSlotTextInset = 2;

denizenMatrixWidth[] :=
	$displayFrameTrackWidth;

denizenMatrixHeight[] :=
	2 denizenMatrixVerticalInset +
		denizenMatrixRows denizenMatrixRowHeight +
		(denizenMatrixRows - 1) denizenMatrixRowGap;

denizenMatrixMetaText[text_] := Module[
	{label},
	label = ToUpperCase[text];
	displayText[label, $displaySansFont, 10, Bold, GrayLevel[0.5], LineBreakWithin -> False]
];

denizenMatrixNameText[text_, width_] := Module[
	{size},
	size = If[
		StringLength[StringTrim[text]] == 0,
		14,
		sheetFittedTextSize[text, Max[1, width], Plain, {9, 14}]
	];
	displayText[text, $displaySerifFont, size, Plain, sheetInk, LineBreakWithin -> False]
];

denizenMatrixSlot[index_Integer, denizen_] := Module[
	{width, gridWidth, slotWidth, row, column, x, y, headerHeight, bodyHeight, metaY, boxY, textInset, frequency, range, denizenName},
	width = denizenMatrixWidth[];
	gridWidth = width - 2 denizenMatrixHorizontalInset;
	slotWidth = (gridWidth - (denizenMatrixColumns - 1) denizenMatrixColumnGap)/denizenMatrixColumns;
	row = Ceiling[index/denizenMatrixColumns];
	column = Mod[index - 1, denizenMatrixColumns] + 1;
	x = denizenMatrixHorizontalInset + (column - 1) (slotWidth + denizenMatrixColumnGap);
	y = denizenMatrixVerticalInset + (denizenMatrixRows - row) (denizenMatrixRowHeight + denizenMatrixRowGap);
	headerHeight = denizenMatrixSlotHeaderHeight;
	bodyHeight = denizenMatrixRowHeight - headerHeight;
	metaY = y + bodyHeight + headerHeight/2;
	boxY = y;
	textInset = denizenMatrixSlotTextInset;
	frequency = $denizenSlotLabels[[index]];
	range = $denizenSlotRanges[[index]];
	denizenName = denizenDisplayName[denizen];
	{
		sheetFilledRect[{x, boxY}, {x + slotWidth, boxY + bodyHeight}, sheetLight],
		Text[
			denizenMatrixMetaText[frequency],
			{x + textInset, metaY},
			{-1, 0}
		],
		Text[
			denizenMatrixMetaText[range],
			{x + slotWidth - textInset, metaY},
			{1, 0}
		],
		Text[
			denizenMatrixNameText[denizenName, slotWidth - 2 textInset],
			{x + slotWidth/2, boxY + bodyHeight/2},
			{0, 0}
		]
	}
];

denizenMatrixGrid[denizenList_List] := Module[
	{width, height, slots},
	width = denizenMatrixWidth[];
	height = denizenMatrixHeight[];
	slots = PadRight[Take[denizenList, UpTo[12]], 12, None];
	Column[
		{
			displayLineHeaderGraphic["Denizens"],
			Graphics[
				Flatten[
					MapIndexed[denizenMatrixSlot[First[#2], #1] &, slots],
					1
				],
				PlotRange -> {{0, width}, {0, height}},
				PlotRangePadding -> None,
				ImagePadding -> 0,
				ImageSize -> {scaled[width], scaled[height]},
				Background -> White
			]
		},
		Spacings -> displayLineHeaderContentGap,
		Alignment -> Left
	]
];

delveObjectiveRows[None] :=
	{};

delveObjectiveRows[objective_String] /; StringLength[StringTrim[objective]] == 0 :=
	{};

delveObjectiveRows[objective_] :=
	{displayLineHeaderBlock["Objective", objective]};

displayDelveCard[delveData_Association, status_:None] := Module[
	{rows, objective, denizenList},
	objective = Lookup[delveData, "Objective", None];
	denizenList = Lookup[delveData, "Denizens", emptyDenizenSlots[]];
	rows = {
		header[delveCardTitle[delveData, status], delveCardSubtitle[delveData]]
	};
	rows = Join[
		rows,
		{
			displayTrackLineHeaderStack[
				{progressTrackGraphic[delveData["Progress"]]},
				Join[
					delveObjectiveRows[objective],
					{denizenMatrixGrid[denizenList]}
				]
			]
		}
	];
	ironFramed[
		Column[
			rows,
			Spacings -> displayCardSectionGap,
			Alignment -> Left
		]
	]
];

displayDelve[delveData_Association, status_:None] :=
	printAndReturn[displayDelveCard[delveData, status], delveData];

displayDelves[delves_Association] :=
	displayDelves[Values[delves]];

displayDelves[delves_List] :=
	displayExpressionList[displayDelveCard /@ delves];

riskZoneTitle[zone_Association] :=
	StringJoin[zone["Name"], " Zone"];

riskZoneRankName[rank_] :=
	ToString[rank];

riskZoneDefaultRankQ[rank_, defaultRank_] :=
	rank === defaultRank || riskZoneRankName[rank] === riskZoneRankName[defaultRank];

riskZoneSuggestedRankText[rank_, defaultRank_] :=
	If[
		riskZoneDefaultRankQ[rank, defaultRank],
		StringJoin[riskZoneRankName[rank], " (default)"],
		riskZoneRankName[rank]
	];

riskZoneSuggestedRanksText[zone_Association] := Module[
	{ranks, defaultRank},
	ranks = zone["Ranks"];
	defaultRank = zone["Rank"];
	StringJoin[
		riskZoneSuggestedRankText[ranks[[1]], defaultRank],
		" or ",
		riskZoneSuggestedRankText[ranks[[2]], defaultRank],
		"."
	]
];

displayRiskZoneCard[delveData_Association, zone_Association] :=
	Print[
		ironFramed[
			Column[
				{
					header[riskZoneTitle[zone], delveData["Name"]],
					displayTrackLineHeaderStack[
						{progressTrackGraphic[delveData["Progress"]]},
						{displayLineHeaderBlock["Suggested Ranks", riskZoneSuggestedRanksText[zone]]}
					]
				},
				Spacings -> displayCardSectionGap,
				Alignment -> Left
			]
		]
	];

denizenRollFrequencySlotNumber[slot_Integer, frequency_String] := Module[
	{matchingSlots, position},
	matchingSlots = Flatten[Position[$denizenSlotLabels, frequency]];
	If[Length[matchingSlots] <= 1, Return[None]];
	position = FirstPosition[matchingSlots, slot, Missing["NotFound"]];
	If[MissingQ[position], None, First[position]]
];

denizenRollOrdinalText[1] := "first";
denizenRollOrdinalText[2] := "second";
denizenRollOrdinalText[3] := "third";
denizenRollOrdinalText[4] := "fourth";
denizenRollOrdinalText[n_Integer] := ToString[n];

denizenRollBlankResultText[roll_Association] := Module[
	{frequency, frequencyText, slotNumber},
	frequency = roll["frequency"];
	frequencyText = ToLowerCase[frequency];
	slotNumber = denizenRollFrequencySlotNumber[roll["slot"], frequency];
	If[
		slotNumber === None,
		StringJoin["You encounter a new denizen. Add it to the ", frequencyText, " slot."],
		StringJoin["You encounter a new denizen. Add it to the ", denizenRollOrdinalText[slotNumber], " ", frequencyText, " slot."]
	]
];

blankDenizenRollResultQ[None] :=
	True;

blankDenizenRollResultQ[text_String] :=
	StringLength[StringTrim[text]] == 0;

blankDenizenRollResultQ[_] :=
	False;

denizenRollResultText[roll_Association] :=
	If[
		blankDenizenRollResultQ[roll["denizen"]],
		denizenRollBlankResultText[roll],
		roll["denizen"]
	];

displayDenizenRoll[delveName_String, roll_Association] :=
	Print[
		ironFramed[
			Column[
				{
					header["Denizen", delveName],
					oracleDiceDisplay[roll["oracleDice"]],
					displayLineHeaderGraphic["Result"],
					oracleOutcomePane[denizenRollResultText[roll], False]
				},
				Spacings -> displayCardSectionGap,
				Alignment -> Center
			]
		]
	];


(* ::Subsection::Closed:: *)
(*Move choice API*)


displayIndexedChoice[data_Association, selection_] := Module[
	{indices, choices, invalid, selected},

	indices = choiceSelectionIndices[selection];

	If[indices === $Failed,
		Message[IronLibrary`displayMoveChoice::badselection, selection];
		Return[$Failed]
	];

	choices = Lookup[data, "Choices", {}];

	If[choices === {},
		Message[IronLibrary`displayMoveChoice::nochoices, Lookup[data, "Subtitle", "the previous output"]];
		Return[$Failed]
	];

	invalid = Select[indices, # < 1 || # > Length[choices] &];

	If[invalid =!= {},
		Message[IronLibrary`displayMoveChoice::badindex, First[invalid], Length[choices]];
		Return[$Failed]
	];

	selected = choices[[indices]];
	displayChoice[Lookup[data, "Subtitle", ""], Lookup[selected, "Text"]]
];

displayMoveChoice[MoveDisplayOutput[data_Association], selection_] :=
	displayIndexedChoice[data, selection];

displayMoveChoice[AssetDisplayOutput[data_Association], selection_] :=
	displayIndexedChoice[data, selection];

displayMoveChoice[output_, selection_] := (
	Message[IronLibrary`displayMoveChoice::badoutput, output];
	$Failed
);

IronLibrary`displayMoveChoice::badselection =
"`1` is not a valid choice selection. Use an integer or a non-empty list of integers.";

IronLibrary`displayMoveChoice::nochoices =
"`1` does not expose any choices.";

IronLibrary`displayMoveChoice::badindex =
"Choice `1` is not available. Valid choices are 1 through `2`.";

IronLibrary`displayMoveChoice::badoutput =
"`1` is not a choice-bearing display output. Use a value returned by a move or asset display function.";


(* ::Subsection::Closed:: *)
(*Oracle display*)


oracleTableByName[tableName_String] := Module[
	{table},
	If[!KeyExistsQ[oracles, tableName],
		Message[IronLibrary`oracle::unknown, tableName];
		Return[$Failed]
	];
	table = oracles[tableName];
	If[!AssociationQ[table],
		Message[IronLibrary`oracle::unknown, tableName];
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

delveOracleTitle[title_String, theme_String, domain_String] :=
	StringJoin[title, " (", StringRiffle[{theme, domain}, " "], ")"];

delveCompositeOracleRoll[title_String, delveData_Association, tableFunction_, cardFunction_] := Module[
	{dice, value, match, theme, domain, table, outcome},
	dice = rollOracleDice[];
	value = oracleValueFromDice[dice];
	match = SameQ @@ dice;
	{theme, domain} = cardFunction[value, delveData["Themes"], delveData["Domains"]];
	table = tableFunction[theme, domain];
	outcome = oracleOutcomeForValue[table, value];
	displayOracleRoll[delveOracleTitle[title, theme, domain], dice, match, outcome];
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

trapOracle[] :=
	compositeOracleRoll[
		"Trap",
		{{"Event", "Delve Site: Trap Event"}, {"Component", "Delve Site: Trap Component"}},
		(StringRiffle[Lookup[#, "outcome"], " "] &)
	];

combatEventOracle[] :=
	compositeOracleRoll[
		"Combat Event",
		{{"Method", "Combat: Event Method"}, {"Target", "Combat: Event Target"}},
		(StringRiffle[Lookup[#, "outcome"], " "] &)
	];

oracleQueryHandlers[] :=
	Association[
		"Settlement: Name" -> settlementNameOracle,
		"Settlement: Quick Name" -> settlementQuickNameOracle,
		"Core: Prompt" -> corePromptOracle,
		"Character" -> characterOracle,
		"Settlement" -> settlementOracle,
		"Combat Scene" -> combatSceneOracle,
		"Journey Waypoint" -> journeyWaypointOracle,
		"Monstrosity" -> monstrosityOracle,
		"Trap" -> trapOracle,
		"Combat Event" -> combatEventOracle,
		"Threat" -> threatOracle
	];

displayNamedOracleQuery[tableName_String] := Module[
	{handler},
	handler = Lookup[oracleQueryHandlers[], tableName, None];
	If[handler === None, oracleRollByName[tableName], handler[]]
];

displayOracleQuery[] := displayMove["askTheOracle"];

displayOracleQuery["Reveal a Danger"] :=
	oracleRoll["Reveal a Danger: Alternate", revealDangerAlternateTable];

displayOracleQuery["Reveal a Danger", ownedDelve_Association] :=
	delveCompositeOracleRoll["Reveal a Danger", ownedDelve, revealDangerCombinedTable, dangerCardsForValue];

displayOracleQuery["Reveal a Danger", theme_String, domain_String] := oracleRoll[delveOracleTitle["Reveal a Danger", theme, domain], revealDangerCombinedTable[theme, domain]];

displayOracleQuery["Delve Site Feature", ownedDelve_Association] :=
	delveCompositeOracleRoll["Delve Site Feature", ownedDelve, delveSiteFeatureTable, featureCardsForValue];

displayOracleQuery["Delve Site Feature", theme_String, domain_String] := oracleRoll[delveOracleTitle["Delve Site Feature", theme, domain], delveSiteFeatureTable[theme, domain]];

displayOracleQuery["Delve Site Name", ownedDelve_Association] :=
	delveSiteNameOracle[ownedDelve["Domains"]];

displayOracleQuery["Delve Site Name", domain_String] :=
	delveSiteNameOracle[domain];

displayOracleQuery["Settlement", landType_String] :=
	settlementOracle[landType];

displayOracleQuery["Journey Waypoint", kind_String] :=
	journeyWaypointOracle[kind];

displayOracleQuery["Threat", category_String] := Module[
	{tableName},
	tableName = "Threat: " <> category;
	oracleRollByName[tableName]
];

displayOracleQuery[tableName_String] := displayNamedOracleQuery[tableName];
displayOracleQuery["Yes/No", odds_String] := oracleRollByName["Yes/No: " <> odds];
displayOracleQuery["Yes/No", yesOutcome_String, noOutcome_String] := oracleRoll["Yes/No", yesNo[yesOutcome, noOutcome]];

IronLibrary`oracle::unknown = "Unknown oracle table `1`.";


(* ::Subsection::Closed:: *)
(*Private context footer*)


End[];


(* ::Section::Closed:: *)
(*Package footer*)


EndPackage[];
