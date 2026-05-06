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


(* ::Subsection::Closed:: *)
(*Package bootstrap*)


(* ::Subsubsection::Closed:: *)
(*Library location*)


ironLibraryPath[] :=
	Which[
		ValueQ[IronLibrary`Private`$IronLibraryPath] &&
			StringQ[IronLibrary`Private`$IronLibraryPath],
			IronLibrary`Private`$IronLibraryPath,
		StringQ[$InputFileName] && $InputFileName =!= "",
			FileNameJoin[{DirectoryName[$InputFileName], "IronLibrary.wl"}],
		True,
			$Failed
	];

ironLibraryDirectory[] := Module[{path},
	path = ironLibraryPath[];
	If[path === $Failed, Return[$Failed]];
	DirectoryName[path]
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

normalizeStoryName[s_String] := Module[{name},
	name = normalizeName[s];
	If[name === "",
		Message[IronLibrary`beginStory::emptyname];
		Return[$Failed]
	];
	name
];

normalizeArcName[s_String] := Module[{name},
	name = normalizeName[s];
	If[name === "",
		Message[IronLibrary`beginChapter::emptyarc];
		Return[$Failed]
	];
	name
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
		Message[IronLibrary`currentNotebookDirectory::unsaved];
		Return[$Failed]
	];
	dir
];

IronLibrary`currentNotebookDirectory::unsaved =
"The current notebook must be saved before its directory can be determined.";

currentNotebookFile[] := Module[{file},
	file = NotebookFileName[];
	If[file === $Failed,
		Message[IronLibrary`currentNotebookFile::unsaved];
		Return[$Failed]
	];
	file
];

IronLibrary`currentNotebookFile::unsaved =
"The current notebook must be saved before its file name can be determined.";

currentNotebookBase[] := Module[{file},
	file = currentNotebookFile[];
	If[file === $Failed, Return[$Failed]];
	FileBaseName[file]
];

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
		Message[IronLibrary`parseNotebookBase::badname, name];
		Return[$Failed]
	];
	AssociationThread[
		{"Story", "ChapterNumber", "Arc", "ArcChapterNumber"},
		First[match]
	]
];

IronLibrary`parseNotebookBase::badname =
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

nextNotebookBaseFrom[data_Association, storyDir_String] := Module[
	{nextChapterNumber, override},
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

nextChapterPlan[] := Module[{data, storyDir, nextBase, chapterDir},
	data = parseNotebookBase[currentNotebookBase[]];
	If[data === $Failed, Return[$Failed]];

	storyDir = parentNotebookDirectory[];
	If[storyDir === $Failed, Return[$Failed]];

	nextBase = nextNotebookBaseFrom[data, storyDir];
	chapterDir = chapterDirectoryPath[storyDir, nextBase];
	Association[
		"StoryDirectory" -> storyDir,
		"ChapterDirectory" -> chapterDir,
		"Base" -> nextBase,
		"Seed" -> chapterSeedFromBase[nextBase],
		"StatePath" -> statePathInDirectory[chapterDir, nextBase],
		"NotebookPath" -> notebookPathInDirectory[chapterDir, nextBase]
	]
];

nextNotebookBase[] := Module[{plan},
	plan = nextChapterPlan[];
	If[plan === $Failed, Return[$Failed]];
	plan["Base"]
];

nextStatePath[] := Module[{plan},
	plan = nextChapterPlan[];
	If[plan === $Failed, Return[$Failed]];
	plan["StatePath"]
];

nextNotebookPath[] := Module[{plan},
	plan = nextChapterPlan[];
	If[plan === $Failed, Return[$Failed]];
	plan["NotebookPath"]
];


(* ::Subsubsection::Closed:: *)
(*State files*)


checkedCreateDirectory[path_String] := Module[{result},
	result =
		Quiet[
			Check[
				CreateDirectory[path, CreateIntermediateDirectories -> True],
				$Failed
			]
		];
	If[result === $Failed,
		Message[IronLibrary`fileOperation::mkdir, path]
	];
	result
];

checkedExport[path_String, expr_, format_String] := Module[{result},
	result = Quiet[Check[Export[path, expr, format], $Failed]];
	If[result === $Failed,
		Message[IronLibrary`fileOperation::export, path]
	];
	result
];

checkedImport[path_String, format_String] := Module[{data},
	data = Quiet[Check[Import[path, format], $Failed]];
	If[data === $Failed,
		Message[IronLibrary`fileOperation::import, path]
	];
	data
];

checkedNotebookSave[nb_] := Module[{result},
	result = Quiet[Check[NotebookSave[nb], $Failed]];
	If[result === $Failed,
		Message[IronLibrary`fileOperation::nbsave]
	];
	result
];

checkedNotebookSave[nb_, path_String] := Module[{result},
	result = Quiet[Check[NotebookSave[nb, path], $Failed]];
	If[result === $Failed,
		Message[IronLibrary`fileOperation::nbsaveas, path]
	];
	result
];

checkedDeleteFile[path_String] := Module[{result},
	result = Quiet[Check[DeleteFile[path], $Failed]];
	If[result === $Failed,
		Message[IronLibrary`fileOperation::delete, path]
	];
	result
];

checkedRenameFile[source_String, target_String] := Module[{result},
	result = Quiet[Check[RenameFile[source, target], $Failed]];
	If[result === $Failed,
		Message[IronLibrary`fileOperation::rename, source, target]
	];
	result
];

checkedRenameDirectory[source_String, target_String] := Module[{result},
	result = Quiet[Check[RenameDirectory[source, target], $Failed]];
	If[result === $Failed,
		Message[IronLibrary`fileOperation::rename, source, target]
	];
	result
];

IronLibrary`fileOperation::mkdir =
"Could not create directory `1`.";

IronLibrary`fileOperation::export =
"Could not write file `1`.";

IronLibrary`fileOperation::import =
"Could not read file `1`.";

IronLibrary`fileOperation::nbsave =
"Could not save the current notebook.";

IronLibrary`fileOperation::nbsaveas =
"Could not save the current notebook to `1`.";

IronLibrary`fileOperation::delete =
"Could not delete file `1`.";

IronLibrary`fileOperation::rename =
"Could not rename `1` to `2`.";

ensureDirectoryForPath[path_String] := Module[{dir},
	dir = DirectoryName[path];
	If[!DirectoryQ[dir],
		If[checkedCreateDirectory[dir] === $Failed,
			Return[$Failed]
		]
	];
	dir
];

saveExpressionToPath[path_String, expr_] := Module[{},
	If[ensureDirectoryForPath[path] === $Failed, Return[$Failed]];
	checkedExport[path, expr, "WXF"]
];

loadStateFromPath[path_String] := Module[{state},
	If[!FileExistsQ[path],
		Message[IronLibrary`loadStateFromPath::nofile, path];
		Return[$Failed]
	];
	state = checkedImport[path, "WXF"];
	If[state === $Failed, Return[$Failed]];
	If[!AssociationQ[state],
		Message[IronLibrary`loadStateFromPath::badstate, path];
		Return[$Failed]
	];
	state
];

IronLibrary`loadStateFromPath::nofile =
"No state file exists at `1`.";

IronLibrary`loadStateFromPath::badstate =
"State file `1` did not contain an association.";


(* ::Subsubsection::Closed:: *)
(*Chapter overrides*)


$chapterOverridesFile =
	".ironlibrary-chapter-overrides.wxf";

chapterOverridesPath[storyDir_String] :=
	FileNameJoin[{storyDir, $chapterOverridesFile}];

loadChapterOverrides[storyDir_String] := Module[{path, data},
	path = chapterOverridesPath[storyDir];
	If[!FileExistsQ[path], Return[Association[]]];
	data = checkedImport[path, "WXF"];
	If[data === $Failed, Return[Association[]]];
	If[AssociationQ[data],
		data,
		Message[IronLibrary`loadChapterOverrides::badfile, path];
		Association[]
	]
];

IronLibrary`loadChapterOverrides::badfile =
"Chapter override file `1` did not contain an association; ignoring it.";

saveChapterOverrides[storyDir_String, overrides_Association] :=
	saveExpressionToPath[chapterOverridesPath[storyDir], overrides];

registerChapterOverride[
	storyDir_String,
	chapterNumber_Integer,
	arc_String,
	arcChapterNumber_Integer,
	arcTitle_:Automatic
] := Module[{overrides, key, normalizedArc, displayTitle},
	normalizedArc = normalizeArcName[arc];
	If[normalizedArc === $Failed, Return[$Failed]];

	overrides = loadChapterOverrides[storyDir];
	key = ToString[chapterNumber];
	displayTitle = Replace[arcTitle, Automatic :> titleCaseName[normalizedArc]];

	overrides[key] =
		Association[
			"Arc" -> normalizedArc,
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
		Message[IronLibrary`seedChapter::noseed];
		Return[$Failed]
	];
	seed = state["seed"];
	SeedRandom[seed];
	seed
];

IronLibrary`seedChapter::noseed =
"The current state does not contain a seed.";

seedStoryState[base_String, state_:Automatic] := Module[{seed, storyState},
	seed = chapterSeedFromBase[base];
	storyState = If[AssociationQ[state], Association[state], Association[]];
	storyState["seed"] = seed;
	If[seedChapter[storyState] === $Failed, Return[$Failed]];
	storyState
];

nextChapterSeed[] := Module[{plan},
	plan = nextChapterPlan[];
	If[plan === $Failed, Return[$Failed]];
	plan["Seed"]
];

stateForNextChapter[state_Association, plan_Association] := Module[{next, seed},
	seed = Lookup[plan, "Seed", $Failed];
	If[seed === $Failed, Return[$Failed]];
	next = Association[state];
	next["seed"] = seed;
	next
];

stateForNextChapter[state_Association] := Module[{plan},
	plan = nextChapterPlan[];
	If[plan === $Failed, Return[$Failed]];
	stateForNextChapter[state, plan]
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
	With[{path = ironLibraryPath[]},
		If[
			StringQ[path] && path =!= $Failed,
			With[
				{libraryPath = path},
				Cell[
					BoxData[ToBoxes[Defer[Get[libraryPath];]]],
					"Input",
					CellTags -> $chapterCellTags["Get"]
				]
			],
			Cell[
				"Load IronLibrary here.",
				"Text",
				CellTags -> $chapterCellTags["Get"]
			]
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
	If[ensureDirectoryForPath[path] === $Failed, Return[$Failed]];
	If[checkedExport[path, Notebook[cells], "NB"] === $Failed,
		Return[$Failed]
	];
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
	path = currentNotebookFile[];
	If[path === $Failed, Return[$Failed]];

	data = parseNotebookBase[FileBaseName[path]];
	If[data === $Failed, Return[$Failed]];

	heading = chapterHeading[data, arcTitle];
	writeChapterHeading[nb, heading];
	If[checkedNotebookSave[nb] === $Failed, Return[$Failed]];
	heading
];

updateChapterNotebookHeading[path_String] := Module[{nb, heading},
	If[!FileExistsQ[path], Return[$Failed]];
	heading = chapterTitleSubtitleFromPath[path];
	If[heading === $Failed, Return[$Failed]];

	nb = NotebookOpen[path, Visible -> False];
	SetOptions[nb, Visible -> Inherited];
	writeChapterHeading[nb, heading];
	If[checkedNotebookSave[nb] === $Failed,
		NotebookClose[nb];
		Return[$Failed]
	];
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
	path = currentNotebookFile[];
	If[path === $Failed, Return[$Failed]];

	heading = chapterTitleSubtitleFromPath[path];
	If[heading === $Failed, Return[$Failed]];

	writeChapterHeading[nb, heading];
	ensureChapterSections[nb];
	ensureEndChapterCells[nb];
	If[checkedNotebookSave[nb] === $Failed, Return[$Failed]];
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
		checkedDeleteFile[source],
		True
	];

renameFileIfDifferent[source_String, target_String] :=
	If[FileExistsQ[source] && !samePathQ[source, target],
		checkedRenameFile[source, target],
		target
	];

retargetFile[source_String, target_String] :=
	If[FileExistsQ[source],
		If[
			FileExistsQ[target],
			checkedDeleteFile[source],
			checkedRenameFile[source, target]
		],
		target
	];

retargetChapterFiles[chapterDir_String, oldBase_String, newBase_String] := Module[
	{oldNotebook, newNotebook, oldState, newState, notebookResult, stateResult},
	oldNotebook = notebookPathInDirectory[chapterDir, oldBase];
	newNotebook = notebookPathInDirectory[chapterDir, newBase];
	oldState = statePathInDirectory[chapterDir, oldBase];
	newState = statePathInDirectory[chapterDir, newBase];

	notebookResult = retargetFile[oldNotebook, newNotebook];
	If[notebookResult === $Failed, Return[$Failed]];
	stateResult = retargetFile[oldState, newState];
	If[stateResult === $Failed, Return[$Failed]];

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
	data = Quiet[parseNotebookBase[oldBase], IronLibrary`parseNotebookBase::badname];
	If[data === $Failed, Return[$Failed]];
	If[data["Story"] =!= oldStory, Return[chapterDir]];

	newBase =
		makeNotebookBase[Join[data, Association["Story" -> newStory]]];
	If[newBase === oldBase, Return[chapterDir]];

	parent = DirectoryName[chapterDir];
	newDir = FileNameJoin[{parent, newBase}];
	If[DirectoryQ[newDir],
		Message[IronLibrary`beginStory::direxists, newDir];
		Return[$Failed]
	];

	If[checkedRenameDirectory[chapterDir, newDir] === $Failed,
		Return[$Failed]
	];
	paths = retargetChapterFiles[newDir, oldBase, newBase];
	If[paths === $Failed, Return[$Failed]];
	If[FileExistsQ[paths["NotebookPath"]],
		If[updateChapterNotebookHeading[paths["NotebookPath"]] === $Failed,
			Return[$Failed]
		]
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
	data = Quiet[parseNotebookBase[oldBase], IronLibrary`parseNotebookBase::badname];
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
		Message[IronLibrary`beginChapter::direxists, newDir];
		Return[$Failed]
	];

	If[checkedRenameDirectory[chapterDir, newDir] === $Failed,
		Return[$Failed]
	];
	paths = retargetChapterFiles[newDir, oldBase, newBase];
	If[paths === $Failed, Return[$Failed]];
	If[
		registerChapterOverride[
			storyDir,
			data["ChapterNumber"],
			newArc,
			newArcChapterNumber,
			arcTitle
		] === $Failed,
		Return[$Failed]
	];
	If[FileExistsQ[paths["NotebookPath"]],
		If[updateChapterNotebookHeading[paths["NotebookPath"]] === $Failed,
			Return[$Failed]
		]
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
		IronLibrary`parseNotebookBase::badname
	]
];


(* ::Subsubsection::Closed:: *)
(*Chapter arc rename*)


IronLibrary`beginChapter::notchapter =
"beginChapter[ArcName -> arc] can only rename a chapter notebook.";

IronLibrary`beginChapter::direxists =
"Cannot rename chapter because the target chapter directory already exists: `1`.";

IronLibrary`beginChapter::nostate =
"No state is loaded, and no current chapter state file exists to load.";

stateForChapterRename[state_, oldStatePath_String] := Module[{chapterState},
	chapterState = If[AssociationQ[state], Association[state], Automatic];
	If[AssociationQ[chapterState], Return[chapterState]];

	If[FileExistsQ[oldStatePath],
		chapterState = loadStateFromPath[oldStatePath];
		If[chapterState === $Failed, Return[$Failed]];
		Return[chapterState]
	];

	Message[IronLibrary`beginChapter::nostate];
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
		Message[IronLibrary`beginChapter::notchapter];
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
	normalizedArc = normalizeArcName[newArc];
	If[normalizedArc === $Failed, Return[$Failed]];
	newData =
		Join[
			data,
			Association["Arc" -> normalizedArc, "ArcChapterNumber" -> 1]
		];
	newBase = makeNotebookBase[newData];
	chapterState = If[AssociationQ[state], Association[state], Automatic];

	If[newBase === oldBase,
		If[
			registerChapterOverride[
				storyDir,
				data["ChapterNumber"],
				normalizedArc,
				1,
				newArc
			] === $Failed,
			Return[$Failed]
		];
		chapterState = seedStoryState[newBase, chapterState];
		If[chapterState === $Failed, Return[$Failed]];
		If[updateCurrentChapterHeading[newArc] === $Failed,
			Return[$Failed]
		];
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
		Message[IronLibrary`beginChapter::direxists, newDir];
		Return[$Failed]
	];

	oldNotebookFile = currentNotebookFile[];
	oldStatePath = currentStatePath[];
	If[oldNotebookFile === $Failed || oldStatePath === $Failed, Return[$Failed]];

	chapterState = stateForChapterRename[chapterState, oldStatePath];
	If[chapterState === $Failed, Return[$Failed]];

	If[checkedNotebookSave[currentNotebookObject[]] === $Failed,
		Return[$Failed]
	];
	If[checkedRenameDirectory[oldDir, newDir] === $Failed,
		Return[$Failed]
	];

	newNotebookPath = notebookPathInDirectory[newDir, newBase];
	newStatePath = statePathInDirectory[newDir, newBase];
	movedOldNotebookPath = movedPathForOriginal[newDir, oldNotebookFile];
	movedOldStatePath = movedPathForOriginal[newDir, oldStatePath];

	If[checkedNotebookSave[currentNotebookObject[], newNotebookPath] ===
		$Failed,
		Return[$Failed]
	];
	If[deleteFileIfDifferent[movedOldNotebookPath, newNotebookPath] ===
		$Failed,
		Return[$Failed]
	];

	chapterState = seedStoryState[newBase, chapterState];
	If[chapterState === $Failed, Return[$Failed]];
	If[saveExpressionToPath[newStatePath, chapterState] === $Failed,
		Return[$Failed]
	];
	If[deleteFileIfDifferent[movedOldStatePath, newStatePath] === $Failed,
		Return[$Failed]
	];

	If[
		registerChapterOverride[
			storyDir,
			data["ChapterNumber"],
			normalizedArc,
			1,
			newArc
		] === $Failed,
		Return[$Failed]
	];
	If[updateCurrentChapterHeading[newArc] === $Failed,
		Return[$Failed]
	];
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


IronLibrary`beginStory::notfirstchapter =
"beginStory[name] can only rename an already-started story from chapter 1.";

IronLibrary`beginStory::storydirexists =
"Cannot rename story because the target story directory already exists: `1`.";

renameCurrentStory[storyName_String, state_:Automatic] := Module[
	{
		oldBase, data, oldStoryDir, oldChapterDir, storyRoot, story, arc,
		newBase, newStoryDir, newChapterDir, plannedOldChapterDir,
		movedOldChapterDir, oldNotebookFile, oldStatePath,
		movedOldNotebookPath, movedOldStatePath, newNotebookPath,
		newStatePath, storyState
	},
	If[!chapterNotebookQ[], Return[$Failed]];

	oldBase = currentNotebookBase[];
	data = parseNotebookBase[oldBase];
	If[data === $Failed, Return[$Failed]];
	If[data["ChapterNumber"] =!= 1,
		Message[IronLibrary`beginStory::notfirstchapter];
		Return[$Failed]
	];

	oldStoryDir = parentNotebookDirectory[];
	oldChapterDir = currentNotebookDirectory[];
	If[oldStoryDir === $Failed || oldChapterDir === $Failed,
		Return[$Failed]
	];

	storyRoot = DirectoryName[oldStoryDir];
	story = normalizeStoryName[storyName];
	If[story === $Failed, Return[$Failed]];
	arc = data["Arc"];
	newBase =
		makeNotebookBase[
			Join[data, Association["Story" -> story, "Arc" -> arc]]
		];
	newStoryDir = FileNameJoin[{storyRoot, story}];
	newChapterDir = chapterDirectoryPath[newStoryDir, newBase];

	oldNotebookFile = currentNotebookFile[];
	If[oldNotebookFile === $Failed, Return[$Failed]];
	oldStatePath = currentStatePath[];
	storyState = If[AssociationQ[state], Association[state], Automatic];

	If[newBase === oldBase && samePathQ[newStoryDir, oldStoryDir],
		storyState = seedStoryState[newBase, storyState];
		If[storyState === $Failed, Return[$Failed]];
		If[ensureChapterOneBoilerplate[] === $Failed,
			Return[$Failed]
		];
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
		Message[IronLibrary`beginStory::storydirexists, newStoryDir];
		Return[$Failed]
	];

	plannedOldChapterDir =
		If[
			!samePathQ[newStoryDir, oldStoryDir],
			FileNameJoin[{newStoryDir, FileNameTake[oldChapterDir]}],
			oldChapterDir
		];

	If[!samePathQ[newChapterDir, plannedOldChapterDir] &&
		DirectoryQ[newChapterDir],
		Message[IronLibrary`beginStory::direxists, newChapterDir];
		Return[$Failed]
	];

	If[checkedNotebookSave[currentNotebookObject[]] === $Failed,
		Return[$Failed]
	];

	If[!samePathQ[newStoryDir, oldStoryDir],
		If[checkedRenameDirectory[oldStoryDir, newStoryDir] === $Failed,
			Return[$Failed]
		];
		movedOldChapterDir = plannedOldChapterDir,
		movedOldChapterDir = oldChapterDir
	];

	If[!samePathQ[newChapterDir, movedOldChapterDir],
		If[checkedRenameDirectory[movedOldChapterDir, newChapterDir] ===
			$Failed,
			Return[$Failed]
		]
	];

	newNotebookPath = notebookPathInDirectory[newChapterDir, newBase];
	movedOldNotebookPath = movedPathForOriginal[newChapterDir, oldNotebookFile];
	If[checkedNotebookSave[currentNotebookObject[], newNotebookPath] ===
		$Failed,
		Return[$Failed]
	];
	If[deleteFileIfDifferent[movedOldNotebookPath, newNotebookPath] === $Failed,
		Return[$Failed]
	];

	If[oldStatePath =!= $Failed,
		movedOldStatePath = movedPathForOriginal[newChapterDir, oldStatePath];
		newStatePath = statePathInDirectory[newChapterDir, newBase];
		If[renameFileIfDifferent[movedOldStatePath, newStatePath] === $Failed,
			Return[$Failed]
		]
	];

	storyState = seedStoryState[newBase, storyState];
	If[storyState === $Failed, Return[$Failed]];
	If[ensureChapterOneBoilerplate[] === $Failed,
		Return[$Failed]
	];

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
	Message[IronLibrary`beginStory::missing];
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

	story = normalizeStoryName[name];
	If[story === $Failed, Return[$Failed]];
	arc = normalizeArcName["Introduction"];
	If[arc === $Failed, Return[$Failed]];
	base =
		makeNotebookBase[
			Association[
				"Story" -> story,
				"ChapterNumber" -> 1,
				"Arc" -> arc,
				"ArcChapterNumber" -> 1
			]
		];
	storyDir = FileNameJoin[{root, story}];
	chapterDir = chapterDirectoryPath[storyDir, base];
	notebookPath = notebookPathInDirectory[chapterDir, base];

	oldNotebookFile = currentNotebookFile[];
	If[oldNotebookFile === $Failed, Return[$Failed]];

	If[DirectoryQ[chapterDir],
		Message[IronLibrary`beginStory::direxists, chapterDir];
		Return[$Failed]
	];

	storyState = seedStoryState[base, state];
	If[storyState === $Failed, Return[$Failed]];

	If[checkedCreateDirectory[chapterDir] === $Failed,
		Return[$Failed]
	];
	If[checkedNotebookSave[currentNotebookObject[], notebookPath] === $Failed,
		Return[$Failed]
	];
	If[deleteFileIfDifferent[oldNotebookFile, notebookPath] === $Failed,
		Return[$Failed]
	];
	If[ensureChapterOneBoilerplate[] === $Failed,
		Return[$Failed]
	];

	Association[
		"NotebookPath" -> notebookPath,
		"StoryDirectory" -> storyDir,
		"AlreadyBegun" -> False,
		"State" -> storyState
	]
];

beginStory[name_] := (
	Message[IronLibrary`beginStory::badname, name];
	$Failed
);

IronLibrary`beginStory::missing =
"beginStory requires an explicit story name: beginStory[name].";

IronLibrary`beginStory::badname =
"Story name `1` is not a string.";

IronLibrary`beginStory::emptyname =
"Story name must contain at least one non-separator character.";

IronLibrary`beginStory::direxists =
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
			Message[IronLibrary`beginChapter::badarc, arcName];
			Return[$Failed]
		];
		renamed = renameCurrentChapterArc[arcName, loaded];
		If[renamed === $Failed, Return[$Failed]];
		loaded = Lookup[renamed, "State", loaded]
	];

	loaded
];

IronLibrary`beginChapter::badarc =
"ArcName must be Automatic or a string, not `1`.";

IronLibrary`beginChapter::emptyarc =
"ArcName must contain at least one non-separator character.";

endChapter[state_Association] := Module[{plan, nextState, notebookResult},
	plan = nextChapterPlan[];
	If[plan === $Failed, Return[$Failed]];

	nextState = stateForNextChapter[state, plan];
	If[nextState === $Failed, Return[$Failed]];

	If[saveExpressionToPath[plan["StatePath"], nextState] === $Failed,
		Return[$Failed]
	];
	notebookResult = createChapterNotebook[plan["NotebookPath"]];
	If[notebookResult === $Failed, Return[$Failed]];
	Association[
		"StatePath" -> plan["StatePath"],
		"NotebookPath" -> plan["NotebookPath"]
	]
];


(* ::Subsection::Closed:: *)
(*Private context footer*)


End[];


(* ::Section::Closed:: *)
(*Package footer*)


EndPackage[];
