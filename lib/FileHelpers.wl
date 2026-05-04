(* ::Package:: *)

(* ::Title:: *)
(*File Helpers*)


(* ::Text:: *)
(*Internal helpers for loading data files, normalizing file names, notebook paths, story directories, chapter state, and chapter notebook lifecycle.*)
(*This package exposes a small file-management API for IronLibrary.wl and keeps its implementation in its own private context.*)


(* ::Section::Closed:: *)
(*Package header*)


BeginPackage["IronLibrary`FileHelpers`"];


(* ::Section::Closed:: *)
(*Public helper API*)


beginStory::usage = "beginStory is part of the internal FileHelpers API used by IronLibrary.wl.";
beginChapter::usage = "beginChapter is part of the internal FileHelpers API used by IronLibrary.wl.";
endChapter::usage = "endChapter is part of the internal FileHelpers API used by IronLibrary.wl.";


(* ::Section::Closed:: *)
(*Private implementation*)


(* ::Subsection::Closed:: *)
(*Private context header*)


Begin["`Private`"];

$ContextPath = DeleteDuplicates[Join[$ContextPath, {"IronLibrary`"}]];


(* ::Subsection::Closed:: *)
(*Package bootstrap*)


(* ::Subsubsection::Closed:: *)
(*Library location*)


If[
	!ValueQ[$IronLibraryPath],
	$IronLibraryPath =
		If[StringQ[$InputFileName] && $InputFileName =!= "", $InputFileName, $Failed]
];

ironLibraryDirectory[] :=
	DirectoryName[$IronLibraryPath];


(* ::Subsubsection::Closed:: *)
(*Data imports*)


Scan[
	Get[FileNameJoin[{ironLibraryDirectory[], #}]] &,
	{"MoveData.wl", "AssetData.wl", "OracleData.wl"}
];


(* ::Subsection::Closed:: *)
(*Naming and notebook identity*)


(* ::Subsubsection::Closed:: *)
(*Name normalization*)


normalizeName[s_String] := Module[{name},
	name = ToLowerCase[StringTrim[s]];
	name = StringReplace[name, {WhitespaceCharacter.. -> "_", "-" -> "_"}];
	name = StringReplace[name, "_".. -> "_"];
	StringTrim[name, "_"]
];

titleCaseName[s_String] :=
	StringRiffle[
		Capitalize /@ StringSplit[
			StringReplace[StringTrim[s], {"_" -> " ", "-" -> " "}],
			WhitespaceCharacter..
		],
		" "
	];


(* ::Subsubsection::Closed:: *)
(*Current notebook*)


currentNotebookObject[] :=
	EvaluationNotebook[];

currentNotebookDirectory[] := Module[{dir},
	dir = NotebookDirectory[];
	If[dir === $Failed,
		Message[currentNotebookDirectory::unsaved];
		Return[$Failed]
	];
	dir
];

currentNotebookDirectory::unsaved =
"The current notebook must be saved before its directory can be determined.";

currentNotebookFile[] := Module[{file},
	file = NotebookFileName[];
	If[file === $Failed,
		Message[currentNotebookBase::unsaved];
		Return[$Failed]
	];
	file
];

currentNotebookBase[] := Module[{file},
	file = currentNotebookFile[];
	If[file === $Failed, Return[$Failed]];
	FileBaseName[file]
];

currentNotebookBase::unsaved =
"The current notebook must be saved before its file name can be determined.";

parentNotebookDirectory[] := Module[{dir},
	dir = currentNotebookDirectory[];
	If[dir === $Failed, Return[$Failed]];
	DirectoryName[dir]
];

storyRootDirectory[] :=
	currentNotebookDirectory[];

storyNameFromRoot[] := Module[{root},
	root = storyRootDirectory[];
	If[root === $Failed, Return[$Failed]];
	Last[FileNameSplit[root]]
];

canonicalPath[p_String] :=
	FileNameJoin[FileNameSplit[ExpandFileName[p]]];

samePathQ[a_String, b_String] :=
	canonicalPath[a] === canonicalPath[b];


(* ::Subsubsection::Closed:: *)
(*Notebook base names*)


$notebookBasePattern =
	RegularExpression["^(.+)-(\\d+)-(.+)-(\\d+)$"];

parseNotebookBase[name_String] := Module[{match},
	match =
		StringCases[
			name,
			$notebookBasePattern :>
				{"$1", ToExpression["$2"], "$3", ToExpression["$4"]}
		];
	If[match === {},
		Message[parseNotebookBase::badname, name];
		Return[$Failed]
	];
	AssociationThread[
		{"Story", "ChapterNumber", "Arc", "ArcChapterNumber"},
		First[match]
	]
];

parseNotebookBase::badname =
"Notebook name `1` does not match the expected form story-chapter-arc-arcchapter.";

makeNotebookBase[data_Association] :=
	StringRiffle[
		{
			data["Story"],
			ToString[data["ChapterNumber"]],
			data["Arc"],
			ToString[data["ArcChapterNumber"]]
		},
		"-"
	];


(* ::Subsection::Closed:: *)
(*Chapter paths and persisted state*)


(* ::Subsubsection::Closed:: *)
(*Path construction*)


notebookFileName[base_String] :=
	StringJoin[base, ".nb"];

stateFileName[base_String] :=
	StringJoin[base, "-state.wxf"];

notebookPathInDirectory[chapterDir_String, base_String] :=
	FileNameJoin[{chapterDir, notebookFileName[base]}];

statePathInDirectory[chapterDir_String, base_String] :=
	FileNameJoin[{chapterDir, stateFileName[base]}];

chapterDirectoryPath[storyDir_String, base_String] :=
	FileNameJoin[{storyDir, base}];

chapterNotebookPath[storyDir_String, base_String] :=
	notebookPathInDirectory[chapterDirectoryPath[storyDir, base], base];

chapterStatePath[storyDir_String, base_String] :=
	statePathInDirectory[chapterDirectoryPath[storyDir, base], base];

currentStatePath[] := Module[{dir, base},
	dir = currentNotebookDirectory[];
	base = currentNotebookBase[];
	If[dir === $Failed || base === $Failed, Return[$Failed]];
	statePathInDirectory[dir, base]
];

nextNotebookBase[] := Module[{data, storyDir, nextChapterNumber, override},
	data = parseNotebookBase[currentNotebookBase[]];
	If[data === $Failed, Return[$Failed]];

	storyDir = parentNotebookDirectory[];
	If[storyDir === $Failed, Return[$Failed]];

	nextChapterNumber = data["ChapterNumber"] + 1;
	override = chapterOverride[storyDir, nextChapterNumber];

	If[AssociationQ[override],
		makeNotebookBase[
			Join[
				data,
				Association[
					"ChapterNumber" -> nextChapterNumber,
					"Arc" -> override["Arc"],
					"ArcChapterNumber" -> override["ArcChapterNumber"]
				]
			]
		],
		makeNotebookBase[
			Join[
				data,
				Association[
					"ChapterNumber" -> nextChapterNumber,
					"ArcChapterNumber" -> data["ArcChapterNumber"] + 1
				]
			]
		]
	]
];

nextStatePath[] := Module[{storyDir, nextBase},
	storyDir = parentNotebookDirectory[];
	nextBase = nextNotebookBase[];
	If[storyDir === $Failed || nextBase === $Failed, Return[$Failed]];
	chapterStatePath[storyDir, nextBase]
];

nextNotebookPath[] := Module[{storyDir, nextBase},
	storyDir = parentNotebookDirectory[];
	nextBase = nextNotebookBase[];
	If[storyDir === $Failed || nextBase === $Failed, Return[$Failed]];
	chapterNotebookPath[storyDir, nextBase]
];


(* ::Subsubsection::Closed:: *)
(*State files*)


ensureDirectoryForPath[path_String] := Module[{dir},
	dir = DirectoryName[path];
	If[!DirectoryQ[dir],
		CreateDirectory[dir, CreateIntermediateDirectories -> True]
	];
	dir
];

saveExpressionToPath[path_String, expr_] := (
	ensureDirectoryForPath[path];
	Export[path, expr, "WXF"]
);

loadStateFromPath[path_String] := Module[{},
	If[!FileExistsQ[path],
		Message[loadStateFromPath::nofile, path];
		Return[$Failed]
	];
	Import[path, "WXF"]
];

loadStateFromPath::nofile =
"No state file exists at `1`.";


(* ::Subsubsection::Closed:: *)
(*Chapter overrides*)


$chapterOverridesFile =
	".ironlibrary-chapter-overrides.wxf";

chapterOverridesPath[storyDir_String] :=
	FileNameJoin[{storyDir, $chapterOverridesFile}];

loadChapterOverrides[storyDir_String] := Module[{path, data},
	path = chapterOverridesPath[storyDir];
	If[!FileExistsQ[path], Return[Association[]]];
	data = Import[path, "WXF"];
	If[AssociationQ[data], data, Association[]]
];

saveChapterOverrides[storyDir_String, overrides_Association] :=
	saveExpressionToPath[chapterOverridesPath[storyDir], overrides];

registerChapterOverride[
	storyDir_String,
	chapterNumber_Integer,
	arc_String,
	arcChapterNumber_Integer,
	arcTitle_:Automatic
] := Module[{overrides, key, displayTitle},
	overrides = loadChapterOverrides[storyDir];
	key = ToString[chapterNumber];
	displayTitle = Replace[arcTitle, Automatic :> titleCaseName[arc]];

	overrides[key] =
		Association[
			"Arc" -> normalizeName[arc],
			"ArcChapterNumber" -> arcChapterNumber,
			"ArcTitle" -> displayTitle
		];

	saveChapterOverrides[storyDir, overrides]
];

chapterOverride[storyDir_String, chapterNumber_Integer] :=
	Lookup[
		loadChapterOverrides[storyDir],
		ToString[chapterNumber],
		Missing["NoOverride"]
	];


(* ::Subsubsection::Closed:: *)
(*Chapter seeding*)


chapterSeedFromBase[base_String] :=
	Abs[Hash[{"IronLibrary", "chapter-seed", base}]];

seedChapter[state_Association] := Module[{seed},
	If[!KeyExistsQ[state, "seed"],
		Message[seedChapter::noseed];
		Return[$Failed]
	];
	seed = state["seed"];
	SeedRandom[seed];
	seed
];

seedChapter::noseed =
"The current state does not contain a seed.";

seedStoryState[base_String, state_:Automatic] := Module[{seed, storyState},
	seed = chapterSeedFromBase[base];
	storyState = If[AssociationQ[state], Association[state], Association[]];
	storyState["seed"] = seed;
	If[seedChapter[storyState] === $Failed, Return[$Failed]];
	storyState
];

nextChapterSeed[] := Module[{base},
	base = nextNotebookBase[];
	If[base === $Failed, Return[$Failed]];
	chapterSeedFromBase[base]
];

stateForNextChapter[state_Association] := Module[{next, seed},
	seed = nextChapterSeed[];
	If[seed === $Failed, Return[$Failed]];
	next = Association[state];
	next["seed"] = seed;
	next
];


(* ::Subsection::Closed:: *)
(*Notebook scaffold and headings*)


(* ::Subsubsection::Closed:: *)
(*Chapter titles*)


romanNumeral[(n_Integer)?Positive] :=
	RomanNumeral[n];

chapterHeading[data_Association, arcTitle_:Automatic] := Module[
	{displayArc, title, subtitle},
	displayArc = Replace[arcTitle, Automatic :> titleCaseName[data["Arc"]]];
	title =
		StringJoin[
			titleCaseName[data["Story"]],
			": Chapter ",
			ToString[data["ChapterNumber"]]
		];
	subtitle =
		StringJoin[
			displayArc,
			", part ",
			romanNumeral[data["ArcChapterNumber"]]
		];
	Association["Title" -> title, "Subtitle" -> subtitle]
];

chapterTitleSubtitleFromPath[path_String] := Module[
	{base, data, storyDir, override, arcTitle},
	base = FileBaseName[path];
	data = parseNotebookBase[base];
	If[data === $Failed, Return[$Failed]];

	storyDir = DirectoryName[DirectoryName[path]];
	override = chapterOverride[storyDir, data["ChapterNumber"]];
	arcTitle =
		If[
			AssociationQ[override] && KeyExistsQ[override, "ArcTitle"],
			override["ArcTitle"],
			Automatic
		];

	chapterHeading[data, arcTitle]
];


(* ::Subsubsection::Closed:: *)
(*Generated cells*)


$chapterCellTags =
	Association[
		"Title" -> "IronLibraryTitle",
		"Subtitle" -> "IronLibrarySubtitle",
		"Header" -> "IronLibraryHeader",
		"Body" -> "IronLibraryBody",
		"Footer" -> "IronLibraryFooter",
		"Get" -> "IronLibraryGet",
		"BeginChapter" -> "IronLibraryBeginChapter",
		"EndChapterInstruction" -> "IronLibraryEndChapterInstruction",
		"EndChapter" -> "IronLibraryEndChapter"
	];

headingCells[heading_Association] :=
	{
		Cell[heading["Title"], "Title", CellTags -> $chapterCellTags["Title"]],
		Cell[heading["Subtitle"], "Subtitle", CellTags -> $chapterCellTags["Subtitle"]]
	};

chapterSectionCells[] :=
	{
		Cell["Header", "Section", CellTags -> $chapterCellTags["Header"]],
		Cell["Body", "Section", CellTags -> $chapterCellTags["Body"]],
		Cell["Footer", "Section", CellTags -> $chapterCellTags["Footer"]]
	};

libraryGetCell[] :=
	If[
		StringQ[$IronLibraryPath] && $IronLibraryPath =!= $Failed,
		With[
			{path = $IronLibraryPath},
			Cell[
				BoxData[ToBoxes[Defer[Get[path];]]],
				"Input",
				CellTags -> $chapterCellTags["Get"]
			]
		],
		Cell[
			"Load IronLibrary here.",
			"Text",
			CellTags -> $chapterCellTags["Get"]
		]
	];

beginChapterCell[] :=
	Cell[
		BoxData[RowBox[{"beginChapter", "[", "]", ";"}]],
		"Input",
		CellTags -> $chapterCellTags["BeginChapter"]
	];

endChapterInstructionCell[] :=
	Cell[
		"When you're done writing, switch the following cell to code and execute the notebook from top to bottom.
If you later decide to come back and add cells interactively, switch it back to text until you're done.",
		"Text",
		CellTags -> $chapterCellTags["EndChapterInstruction"]
	];

endChapterTextCell[] :=
	Cell[
		"endChapter[];",
		"Text",
		CellTags -> $chapterCellTags["EndChapter"]
	];

chapterNotebookCells[path_String] := Module[{heading, sections},
	heading = chapterTitleSubtitleFromPath[path];
	If[heading === $Failed, Return[$Failed]];

	sections = chapterSectionCells[];
	Join[
		headingCells[heading],
		{
			sections[[1]],
			libraryGetCell[],
			beginChapterCell[],
			sections[[2]],
			sections[[3]],
			endChapterInstructionCell[],
			endChapterTextCell[]
		}
	]
];

createChapterNotebook[path_String] := Module[{cells},
	If[FileExistsQ[path], Return[path]];
	cells = chapterNotebookCells[path];
	If[cells === $Failed, Return[$Failed]];
	Export[path, Notebook[cells], "NB"];
	path
];


(* ::Subsubsection::Closed:: *)
(*Heading updates*)


deleteTaggedCells[nb_, tag_String] := Module[{cells},
	cells = Cells[nb, CellTags -> tag];
	If[cells =!= {}, NotebookDelete /@ cells];
];

deleteHeadingCells[nb_] := (
	deleteTaggedCells[nb, $chapterCellTags["Title"]];
	deleteTaggedCells[nb, $chapterCellTags["Subtitle"]];
);

writeChapterHeading[nb_, heading_Association] := (
	deleteHeadingCells[nb];
	SelectionMove[nb, Before, Notebook];
	NotebookWrite[nb, headingCells[heading]];
	heading
);

updateCurrentChapterHeading[arcTitle_:Automatic] := Module[
	{nb, path, data, heading},
	nb = currentNotebookObject[];
	path = NotebookFileName[];
	If[path === $Failed, Return[$Failed]];

	data = parseNotebookBase[FileBaseName[path]];
	If[data === $Failed, Return[$Failed]];

	heading = chapterHeading[data, arcTitle];
	writeChapterHeading[nb, heading];
	NotebookSave[nb];
	heading
];

updateChapterNotebookHeading[path_String] := Module[{nb, heading},
	If[!FileExistsQ[path], Return[$Failed]];
	heading = chapterTitleSubtitleFromPath[path];
	If[heading === $Failed, Return[$Failed]];

	nb = NotebookOpen[path, Visible -> False];
	SetOptions[nb, Visible -> Inherited];
	writeChapterHeading[nb, heading];
	NotebookSave[nb];
	NotebookClose[nb];
	heading
];


(* ::Subsubsection::Closed:: *)
(*Chapter-one boilerplate*)


taggedCellExistsQ[nb_, tag_String] :=
	Cells[nb, CellTags -> tag] =!= {};

allTaggedCellsExistQ[nb_, tags_List] :=
	And @@ (taggedCellExistsQ[nb, #] & /@ tags);

firstInputCellObject[nb_] := Module[{cells},
	cells = Cells[nb, CellStyle -> "Input"];
	If[cells === {}, Missing["NoInputCell"], First[cells]]
];

chapterSectionTags[] :=
	$chapterCellTags /@ {"Header", "Body", "Footer"};

deleteChapterSectionCells[nb_] :=
	Scan[deleteTaggedCells[nb, #] &, chapterSectionTags[]];

insertChapterSections[nb_] := Module[{firstInput, sections},
	firstInput = firstInputCellObject[nb];
	sections = chapterSectionCells[];

	If[firstInput === Missing["NoInputCell"],
		SelectionMove[nb, After, Notebook];
		NotebookWrite[nb, sections],
		SelectionMove[firstInput, Before, Cell];
		NotebookWrite[nb, First[sections]];

		SelectionMove[firstInput, After, Cell];
		NotebookWrite[nb, Rest[sections]]
	]
];

ensureChapterSections[nb_] :=
	If[!allTaggedCellsExistQ[nb, chapterSectionTags[]],
		deleteChapterSectionCells[nb];
		insertChapterSections[nb]
	];

ensureEndChapterCells[nb_] := Module[
	{needsInstruction, needsEndCell, footerCells},
	needsInstruction =
		!taggedCellExistsQ[nb, $chapterCellTags["EndChapterInstruction"]];
	needsEndCell =
		!taggedCellExistsQ[nb, $chapterCellTags["EndChapter"]];

	If[needsInstruction || needsEndCell,
		footerCells = Cells[nb, CellTags -> $chapterCellTags["Footer"]];
		SelectionMove[Last[footerCells], After, Cell];

		If[needsInstruction,
			NotebookWrite[nb, endChapterInstructionCell[]]
		];

		If[needsEndCell,
			NotebookWrite[nb, endChapterTextCell[]]
		]
	]
];

ensureChapterOneBoilerplate[] := Module[{nb, path, heading},
	nb = currentNotebookObject[];
	path = NotebookFileName[];
	If[path === $Failed, Return[$Failed]];

	heading = chapterTitleSubtitleFromPath[path];
	If[heading === $Failed, Return[$Failed]];

	writeChapterHeading[nb, heading];
	ensureChapterSections[nb];
	ensureEndChapterCells[nb];
	NotebookSave[nb];
	heading
];


(* ::Subsection::Closed:: *)
(*Chapter file retargeting*)


(* ::Subsubsection::Closed:: *)
(*File moves*)


movedPathForOriginal[newDir_String, originalPath_String] :=
	FileNameJoin[{newDir, FileNameTake[originalPath]}];

deleteFileIfDifferent[source_String, target_String] :=
	If[FileExistsQ[source] && !samePathQ[source, target],
		DeleteFile[source]
	];

renameFileIfDifferent[source_String, target_String] :=
	If[FileExistsQ[source] && !samePathQ[source, target],
		RenameFile[source, target]
	];

retargetFile[source_String, target_String] :=
	If[FileExistsQ[source],
		If[
			FileExistsQ[target],
			DeleteFile[source],
			RenameFile[source, target]
		]
	];

retargetChapterFiles[chapterDir_String, oldBase_String, newBase_String] := Module[
	{oldNotebook, newNotebook, oldState, newState},
	oldNotebook = notebookPathInDirectory[chapterDir, oldBase];
	newNotebook = notebookPathInDirectory[chapterDir, newBase];
	oldState = statePathInDirectory[chapterDir, oldBase];
	newState = statePathInDirectory[chapterDir, newBase];

	retargetFile[oldNotebook, newNotebook];
	retargetFile[oldState, newState];

	Association["NotebookPath" -> newNotebook, "StatePath" -> newState]
];


(* ::Subsubsection::Closed:: *)
(*Chapter-directory propagation*)


renameChapterDirectoryForStory[
	chapterDir_String,
	oldStory_String,
	newStory_String
] := Module[{oldBase, data, newBase, parent, newDir, paths},
	oldBase = FileNameTake[chapterDir];
	data = Quiet[parseNotebookBase[oldBase], parseNotebookBase::badname];
	If[data === $Failed, Return[$Failed]];
	If[data["Story"] =!= oldStory, Return[chapterDir]];

	newBase =
		makeNotebookBase[Join[data, Association["Story" -> newStory]]];
	If[newBase === oldBase, Return[chapterDir]];

	parent = DirectoryName[chapterDir];
	newDir = FileNameJoin[{parent, newBase}];
	If[DirectoryQ[newDir],
		Message[beginStory::direxists, newDir];
		Return[$Failed]
	];

	RenameDirectory[chapterDir, newDir];
	paths = retargetChapterFiles[newDir, oldBase, newBase];
	If[FileExistsQ[paths["NotebookPath"]],
		updateChapterNotebookHeading[paths["NotebookPath"]]
	];
	newDir
];

propagateStoryRename[storyDir_String, oldStory_String, newStory_String] := Module[
	{chapterDirs, results},
	chapterDirs = Select[FileNames["*", storyDir], DirectoryQ];
	results =
		(renameChapterDirectoryForStory[#, oldStory, newStory] &) /@
			chapterDirs;
	If[MemberQ[results, $Failed], Return[$Failed]];
	results
];

renameChapterDirectoryForArc[
	chapterDir_String,
	oldArc_String,
	oldArcStart_Integer,
	newArc_String,
	currentChapterNumber_Integer,
	arcTitle_String
] := Module[
	{
		oldBase, data, newArcChapterNumber, newBase, storyDir, newDir,
		paths
	},
	oldBase = FileNameTake[chapterDir];
	data = Quiet[parseNotebookBase[oldBase], parseNotebookBase::badname];
	If[data === $Failed, Return[$Failed]];

	If[data["ChapterNumber"] <= currentChapterNumber, Return[chapterDir]];
	If[data["Arc"] =!= oldArc, Return[chapterDir]];
	If[data["ArcChapterNumber"] < oldArcStart, Return[chapterDir]];

	newArcChapterNumber = data["ArcChapterNumber"] - oldArcStart + 1;
	newBase =
		makeNotebookBase[
			Join[
				data,
				Association[
					"Arc" -> newArc,
					"ArcChapterNumber" -> newArcChapterNumber
				]
			]
		];
	If[newBase === oldBase, Return[chapterDir]];

	storyDir = DirectoryName[chapterDir];
	newDir = FileNameJoin[{storyDir, newBase}];
	If[DirectoryQ[newDir],
		Message[beginChapter::direxists, newDir];
		Return[$Failed]
	];

	RenameDirectory[chapterDir, newDir];
	paths = retargetChapterFiles[newDir, oldBase, newBase];
	registerChapterOverride[
		storyDir,
		data["ChapterNumber"],
		newArc,
		newArcChapterNumber,
		arcTitle
	];
	If[FileExistsQ[paths["NotebookPath"]],
		updateChapterNotebookHeading[paths["NotebookPath"]]
	];
	newDir
];

propagateArcRename[
	storyDir_String,
	oldArc_String,
	oldArcStart_Integer,
	newArc_String,
	currentChapterNumber_Integer,
	arcTitle_String
] := Module[{chapterDirs, results},
	chapterDirs = Select[FileNames["*", storyDir], DirectoryQ];
	results =
		(renameChapterDirectoryForArc[
			#,
			oldArc,
			oldArcStart,
			newArc,
			currentChapterNumber,
			arcTitle
		] &) /@ chapterDirs;
	If[MemberQ[results, $Failed], Return[$Failed]];
	results
];


(* ::Subsection::Closed:: *)
(*Story and chapter renaming*)


(* ::Subsubsection::Closed:: *)
(*Notebook classification*)


chapterNotebookQ[] := Module[{base},
	base = currentNotebookBase[];
	If[!StringQ[base], Return[False]];
	Quiet[
		parseNotebookBase[base] =!= $Failed,
		parseNotebookBase::badname
	]
];


(* ::Subsubsection::Closed:: *)
(*Chapter arc rename*)


beginChapter::notchapter =
"beginChapter[ArcName -> arc] can only rename a chapter notebook.";

beginChapter::direxists =
"Cannot rename chapter because the target chapter directory already exists: `1`.";

beginChapter::nostate =
"No state is loaded, and no current chapter state file exists to load.";

stateForChapterRename[state_, oldStatePath_String] := Module[{chapterState},
	chapterState = If[AssociationQ[state], Association[state], Automatic];
	If[AssociationQ[chapterState], Return[chapterState]];

	If[FileExistsQ[oldStatePath],
		chapterState = loadStateFromPath[oldStatePath];
		If[chapterState === $Failed, Return[$Failed]];
		Return[chapterState]
	];

	Message[beginChapter::nostate];
	$Failed
];

renameCurrentChapterArc[newArc_String, state_:Automatic] := Module[
	{
		oldBase, data, storyDir, oldDir, oldArc, oldArcStart,
		normalizedArc, newData, newBase, newDir, oldNotebookFile,
		oldStatePath, movedOldNotebookPath, movedOldStatePath,
		newNotebookPath, newStatePath, chapterState
	},
	If[!chapterNotebookQ[],
		Message[beginChapter::notchapter];
		Return[$Failed]
	];

	oldBase = currentNotebookBase[];
	data = parseNotebookBase[oldBase];
	If[data === $Failed, Return[$Failed]];

	storyDir = parentNotebookDirectory[];
	oldDir = currentNotebookDirectory[];
	If[storyDir === $Failed || oldDir === $Failed, Return[$Failed]];

	oldArc = data["Arc"];
	oldArcStart = data["ArcChapterNumber"];
	normalizedArc = normalizeName[newArc];
	newData =
		Join[
			data,
			Association["Arc" -> normalizedArc, "ArcChapterNumber" -> 1]
		];
	newBase = makeNotebookBase[newData];
	chapterState = If[AssociationQ[state], Association[state], Automatic];

	If[newBase === oldBase,
		registerChapterOverride[
			storyDir,
			data["ChapterNumber"],
			normalizedArc,
			1,
			newArc
		];
		chapterState = seedStoryState[newBase, chapterState];
		If[chapterState === $Failed, Return[$Failed]];
		updateCurrentChapterHeading[newArc];
		If[
			propagateArcRename[
				storyDir,
				oldArc,
				oldArcStart,
				normalizedArc,
				data["ChapterNumber"],
				newArc
			] === $Failed,
			Return[$Failed]
		];
		Return[
			Association[
				"OldNotebookBase" -> oldBase,
				"NewNotebookBase" -> newBase,
				"AlreadyInArc" -> True,
				"State" -> chapterState
			]
		]
	];

	newDir = chapterDirectoryPath[storyDir, newBase];
	If[DirectoryQ[newDir],
		Message[beginChapter::direxists, newDir];
		Return[$Failed]
	];

	oldNotebookFile = NotebookFileName[];
	oldStatePath = currentStatePath[];
	If[oldNotebookFile === $Failed || oldStatePath === $Failed, Return[$Failed]];

	chapterState = stateForChapterRename[chapterState, oldStatePath];
	If[chapterState === $Failed, Return[$Failed]];

	NotebookSave[currentNotebookObject[]];
	RenameDirectory[oldDir, newDir];

	newNotebookPath = notebookPathInDirectory[newDir, newBase];
	newStatePath = statePathInDirectory[newDir, newBase];
	movedOldNotebookPath = movedPathForOriginal[newDir, oldNotebookFile];
	movedOldStatePath = movedPathForOriginal[newDir, oldStatePath];

	NotebookSave[currentNotebookObject[], newNotebookPath];
	deleteFileIfDifferent[movedOldNotebookPath, newNotebookPath];

	chapterState = seedStoryState[newBase, chapterState];
	If[chapterState === $Failed, Return[$Failed]];
	If[saveExpressionToPath[newStatePath, chapterState] === $Failed,
		Return[$Failed]
	];
	deleteFileIfDifferent[movedOldStatePath, newStatePath];

	registerChapterOverride[
		storyDir,
		data["ChapterNumber"],
		normalizedArc,
		1,
		newArc
	];
	updateCurrentChapterHeading[newArc];
	If[
		propagateArcRename[
			storyDir,
			oldArc,
			oldArcStart,
			normalizedArc,
			data["ChapterNumber"],
			newArc
		] === $Failed,
		Return[$Failed]
	];

	Association[
		"OldNotebookBase" -> oldBase,
		"NewNotebookBase" -> newBase,
		"NotebookPath" -> newNotebookPath,
		"StatePath" -> newStatePath,
		"AlreadyInArc" -> False,
		"State" -> chapterState
	]
];


(* ::Subsubsection::Closed:: *)
(*Story rename*)


beginStory::notfirstchapter =
"beginStory[name] can only rename an already-started story from chapter 1.";

beginStory::storydirexists =
"Cannot rename story because the target story directory already exists: `1`.";

renameCurrentStory[storyName_String, state_:Automatic] := Module[
	{
		oldBase, data, oldStoryDir, oldChapterDir, storyRoot, story, arc,
		newBase, newStoryDir, newChapterDir, movedOldChapterDir,
		oldNotebookFile, oldStatePath, movedOldNotebookPath,
		movedOldStatePath, newNotebookPath, newStatePath, storyState
	},
	If[!chapterNotebookQ[], Return[$Failed]];

	oldBase = currentNotebookBase[];
	data = parseNotebookBase[oldBase];
	If[data === $Failed, Return[$Failed]];
	If[data["ChapterNumber"] =!= 1,
		Message[beginStory::notfirstchapter];
		Return[$Failed]
	];

	oldStoryDir = parentNotebookDirectory[];
	oldChapterDir = currentNotebookDirectory[];
	If[oldStoryDir === $Failed || oldChapterDir === $Failed,
		Return[$Failed]
	];

	storyRoot = DirectoryName[oldStoryDir];
	story = normalizeName[storyName];
	arc = data["Arc"];
	newBase =
		makeNotebookBase[
			Join[data, Association["Story" -> story, "Arc" -> arc]]
		];
	newStoryDir = FileNameJoin[{storyRoot, story}];
	newChapterDir = chapterDirectoryPath[newStoryDir, newBase];

	oldNotebookFile = NotebookFileName[];
	If[oldNotebookFile === $Failed, Return[$Failed]];
	oldStatePath = currentStatePath[];
	storyState = If[AssociationQ[state], Association[state], Automatic];

	If[newBase === oldBase && samePathQ[newStoryDir, oldStoryDir],
		storyState = seedStoryState[newBase, storyState];
		If[storyState === $Failed, Return[$Failed]];
		ensureChapterOneBoilerplate[];
		If[
			propagateStoryRename[oldStoryDir, data["Story"], story] ===
				$Failed,
			Return[$Failed]
		];
		Return[
			Association[
				"NotebookPath" -> oldNotebookFile,
				"StoryDirectory" -> oldStoryDir,
				"AlreadyBegun" -> True,
				"Renamed" -> False,
				"State" -> storyState
			]
		]
	];

	If[DirectoryQ[newStoryDir] && !samePathQ[newStoryDir, oldStoryDir],
		Message[beginStory::storydirexists, newStoryDir];
		Return[$Failed]
	];

	NotebookSave[currentNotebookObject[]];

	If[!samePathQ[newStoryDir, oldStoryDir],
		RenameDirectory[oldStoryDir, newStoryDir];
		movedOldChapterDir =
			FileNameJoin[{newStoryDir, FileNameTake[oldChapterDir]}],
		movedOldChapterDir = oldChapterDir
	];

	If[!samePathQ[newChapterDir, movedOldChapterDir],
		If[DirectoryQ[newChapterDir],
			Message[beginStory::direxists, newChapterDir];
			Return[$Failed]
		];
		RenameDirectory[movedOldChapterDir, newChapterDir]
	];

	newNotebookPath = notebookPathInDirectory[newChapterDir, newBase];
	movedOldNotebookPath = movedPathForOriginal[newChapterDir, oldNotebookFile];
	NotebookSave[currentNotebookObject[], newNotebookPath];
	deleteFileIfDifferent[movedOldNotebookPath, newNotebookPath];

	If[oldStatePath =!= $Failed,
		movedOldStatePath = movedPathForOriginal[newChapterDir, oldStatePath];
		newStatePath = statePathInDirectory[newChapterDir, newBase];
		renameFileIfDifferent[movedOldStatePath, newStatePath]
	];

	storyState = seedStoryState[newBase, storyState];
	If[storyState === $Failed, Return[$Failed]];
	ensureChapterOneBoilerplate[];

	If[
		propagateStoryRename[newStoryDir, data["Story"], story] === $Failed,
		Return[$Failed]
	];

	Association[
		"NotebookPath" -> newNotebookPath,
		"StoryDirectory" -> newStoryDir,
		"OldNotebookBase" -> oldBase,
		"NewNotebookBase" -> newBase,
		"AlreadyBegun" -> True,
		"Renamed" -> True,
		"State" -> storyState
	]
];


(* ::Subsection::Closed:: *)
(*Story and chapter lifecycle*)


beginStory[] := (
	Message[beginStory::missing];
	$Failed
);

beginStory[name_String, state_:Automatic] := Module[
	{
		root, story, arc, base, storyDir, chapterDir, notebookPath,
		oldNotebookFile, storyState
	},
	If[chapterNotebookQ[], Return[renameCurrentStory[name, state]]];

	root = storyRootDirectory[];
	If[root === $Failed, Return[$Failed]];

	story = normalizeName[name];
	arc = normalizeName["Introduction"];
	storyDir = FileNameJoin[{root, story}];
	If[!DirectoryQ[storyDir],
		CreateDirectory[storyDir, CreateIntermediateDirectories -> True]
	];

	base =
		makeNotebookBase[
			Association[
				"Story" -> story,
				"ChapterNumber" -> 1,
				"Arc" -> arc,
				"ArcChapterNumber" -> 1
			]
		];
	chapterDir = chapterDirectoryPath[storyDir, base];
	If[DirectoryQ[chapterDir],
		Message[beginStory::direxists, chapterDir];
		Return[$Failed]
	];

	CreateDirectory[chapterDir, CreateIntermediateDirectories -> True];
	notebookPath = notebookPathInDirectory[chapterDir, base];

	oldNotebookFile = NotebookFileName[];
	If[oldNotebookFile === $Failed,
		Message[currentNotebookBase::unsaved];
		Return[$Failed]
	];

	NotebookSave[currentNotebookObject[], notebookPath];
	If[FileExistsQ[oldNotebookFile] && !samePathQ[oldNotebookFile, notebookPath],
		DeleteFile[oldNotebookFile]
	];

	storyState = seedStoryState[base, state];
	If[storyState === $Failed, Return[$Failed]];
	ensureChapterOneBoilerplate[];

	Association[
		"NotebookPath" -> notebookPath,
		"StoryDirectory" -> storyDir,
		"AlreadyBegun" -> False,
		"State" -> storyState
	]
];

beginStory[name_] := (
	Message[beginStory::badname, name];
	$Failed
);

beginStory::missing =
"beginStory requires an explicit story name: beginStory[name].";

beginStory::badname =
"Story name `1` is not a string.";

beginStory::direxists =
"Cannot begin story because the target chapter directory already exists: `1`.";

Options[beginChapter] =
	{IronLibrary`ArcName -> Automatic};

beginChapter[OptionsPattern[]] := Module[{path, loaded, arcName, renamed},
	path = currentStatePath[];
	If[path === $Failed, Return[$Failed]];

	loaded = loadStateFromPath[path];
	If[loaded === $Failed, Return[$Failed]];
	If[seedChapter[loaded] === $Failed, Return[$Failed]];

	arcName = OptionValue[IronLibrary`ArcName];
	If[arcName =!= Automatic,
		If[!StringQ[arcName],
			Message[beginChapter::badarc, arcName];
			Return[$Failed]
		];
		renamed = renameCurrentChapterArc[arcName, loaded];
		If[renamed === $Failed, Return[$Failed]];
		loaded = Lookup[renamed, "State", loaded]
	];

	loaded
];

beginChapter::badarc =
"ArcName must be Automatic or a string, not `1`.";

endChapter[state_Association] := Module[{statePath, notebookPath},
	statePath = nextStatePath[];
	notebookPath = nextNotebookPath[];
	If[statePath === $Failed || notebookPath === $Failed, Return[$Failed]];

	If[saveExpressionToPath[statePath, stateForNextChapter[state]] === $Failed,
		Return[$Failed]
	];
	createChapterNotebook[notebookPath];
	Association["StatePath" -> statePath, "NotebookPath" -> notebookPath]
];


(* ::Subsection::Closed:: *)
(*Private context footer*)


End[];


(* ::Section::Closed:: *)
(*Package footer*)


EndPackage[];
