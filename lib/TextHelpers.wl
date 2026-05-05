(* ::Package:: *)

(* ::Title:: *)
(*Text Helpers*)


(* ::Chapter:: *)
(*Code*)


(* ::Section::Closed:: *)
(*Package header*)


BeginPackage["IronLibrary`TextHelpers`"];


(* ::Section::Closed:: *)
(*Public symbols*)


b::usage = "b[text] styles text as bold in IronLibrary display text.";
i::usage = "i[text] styles text as italic in IronLibrary display text.";
bi::usage = "bi[text] styles text as bold italic in IronLibrary display text.";
p::usage = "p[parts...] creates one paragraph row for IronLibrary display text.";
paras::usage = "paras[items...] creates a paragraph column for IronLibrary display text.";
choice::usage = "choice[key, text] creates a choice association for choice-bearing display text.";
choiceGroup::usage = "choiceGroup[label, choices] creates a labeled group of choice associations.";
choiceGroupQ::usage = "choiceGroupQ[item] returns True for a choice group association.";
numberedChoiceRow::usage = "numberedChoiceRow[index, text] creates a numbered choice row.";
choiceDisplayRows::usage = "choiceDisplayRows[choices] creates numbered display rows for choices.";
flattenChoices::usage = "flattenChoices[choices] flattens grouped choices into a single choice list.";
choiceSection::usage = "choiceSection[pre, choices, post] creates a move-style text section with display text and choice metadata.";


(* ::Section:: *)
(*Private implementation*)


Begin["`Private`"];


b[text_] := Style[text, Bold];
i[text_] := Style[text, Italic];
bi[text_] := Style[text, Bold, Italic];

$attachedPunctuationStartChars = {",", ".", ";", ":", "!", "?", ")", "]", "}"};

attachedWhitespaceQ[char_String] :=
	StringMatchQ[char, WhitespaceCharacter];

attachedPunctuationQ[char_String] :=
	MemberQ[$attachedPunctuationStartChars, char];

attachedTextPrefix[text_String] := Module[
	{chars, leadingWhitespaceCount, punctuationCount, trailingWhitespaceCount},
	chars = Characters[text];
	If[chars === {}, Return[""]];
	If[attachedWhitespaceQ[First[chars]],
		leadingWhitespaceCount = Length[TakeWhile[chars, attachedWhitespaceQ]];
		punctuationCount = Length[TakeWhile[Drop[chars, leadingWhitespaceCount], attachedPunctuationQ]];
		trailingWhitespaceCount = Length[TakeWhile[Drop[chars, leadingWhitespaceCount + punctuationCount], attachedWhitespaceQ]];
		Return[StringJoin[Take[chars, leadingWhitespaceCount + punctuationCount + trailingWhitespaceCount]]]
	];
	If[!attachedPunctuationQ[First[chars]], Return[""]];
	punctuationCount = Length[TakeWhile[chars, attachedPunctuationQ]];
	trailingWhitespaceCount = Length[TakeWhile[Drop[chars, punctuationCount], attachedWhitespaceQ]];
	StringJoin[Take[chars, punctuationCount + trailingWhitespaceCount]]
];

attachPlainPrefixes[items_List] := Module[
	{result = {}, normalizedItems = items, i = 1, j, n = Length[items], item, prefix, rest},
	While[i <= n,
		item = normalizedItems[[i]];
		j = i + 1;
		While[j <= n && StringQ[normalizedItems[[j]]],
			prefix = attachedTextPrefix[normalizedItems[[j]]];
			If[prefix === "", Break[]];
			item = Row[{item, prefix}];
			rest = StringDrop[normalizedItems[[j]], StringLength[prefix]];
			If[rest === "",
				j++,
				normalizedItems[[j]] = rest;
				Break[]
			]
		];
		AppendTo[result, item];
		i = j
	];
	result
];

p[parts___] := Row[attachPlainPrefixes[{parts}]];

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
	"Choices" -> flattenChoices[choices],
	"PreText" -> pre,
	"ChoiceItems" -> choices,
	"PostText" -> post
|>;


End[];


(* ::Section::Closed:: *)
(*Package footer*)


EndPackage[];
