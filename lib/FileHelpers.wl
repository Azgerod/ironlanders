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
(*Library path variable*)


If[ !ValueQ[$IronLibraryPath], $IronLibraryPath = If[StringQ[$InputFileName] && $InputFileName =!= "", $InputFileName, $Failed]];


(* ::Subsubsection::Closed:: *)
(*Library directory variable*)


ironLibraryDirectory[] := DirectoryName[$IronLibraryPath];


(* ::Subsubsection:: *)
(*Imports*)


Get[FileNameJoin[{ironLibraryDirectory[], "MoveData.wl"}]];
Get[FileNameJoin[{ironLibraryDirectory[], "AssetData.wl"}]];
Get[FileNameJoin[{ironLibraryDirectory[], "OracleData.wl"}]];


(* ::Subsubsection::Closed:: *)
(*Name normalization*)


normalizeName[s_String] := Module[{name}, name = ToLowerCase[StringTrim[s]]; name = StringReplace[name, {WhitespaceCharacter.. -> "_", "-" -> "_"}]; name = StringReplace[name, "_".. -> "_"];
     StringTrim[name, "_"]];


(* ::Subsubsection::Closed:: *)
(*Display naming*)


titleCaseName[s_String] := StringRiffle[Capitalize /@ StringSplit[StringReplace[StringTrim[s], {"_" -> " ", "-" -> " "}], WhitespaceCharacter..], " "];




(* ::Subsection::Closed:: *)
(*Notebook and chapter lifecycle helpers*)


(* ::Subsubsection::Closed:: *)
(*Notebook/path helpers*)


currentNotebookObject[] := EvaluationNotebook[];
currentNotebookDirectory[] := Module[{dir = NotebookDirectory[]}, If[dir === $Failed, Message[currentNotebookDirectory::unsaved]; Return[$Failed]]; dir];
currentNotebookDirectory::unsaved = "The current notebook must be saved before its directory can be determined.";
currentNotebookBase[] := Module[{file = NotebookFileName[]}, If[file === $Failed, Message[currentNotebookBase::unsaved]; Return[$Failed]]; FileBaseName[file]];
currentNotebookBase::unsaved = "The current notebook must be saved before its file name can be determined.";
parentNotebookDirectory[] := Module[{dir = currentNotebookDirectory[]}, If[dir === $Failed, Return[$Failed]]; DirectoryName[dir]];
canonicalPath[p_String] := FileNameJoin[FileNameSplit[ExpandFileName[p]]];
samePathQ[a_String, b_String] := canonicalPath[a] === canonicalPath[b];


(* ::Subsubsection::Closed:: *)
(*Notebook-name parsing*)


parseNotebookBase[name_String] := Module[{match}, match = StringCases[name, RegularExpression["^(.+)-(\\d+)-(.+)-(\\d+)$"] :> {"$1", ToExpression["$2"], "$3", ToExpression["$4"]}];
     If[match === {}, Message[parseNotebookBase::badname, name]; Return[$Failed]]; AssociationThread[{"Story", "ChapterNumber", "Arc", "ArcChapterNumber"}, First[match]]];
parseNotebookBase::badname = "Notebook name `1` does not match the expected form story-chapter-arc-arcchapter.";
makeNotebookBase[data_Association] := StringRiffle[{data["Story"], ToString[data["ChapterNumber"]], data["Arc"], ToString[data["ArcChapterNumber"]]}, "-"];


(* ::Subsubsection::Closed:: *)
(*Story name derivation*)


storyRootDirectory[] := Module[{dir}, dir = currentNotebookDirectory[]; If[dir === $Failed, Return[$Failed]]; dir];
storyNameFromRoot[] := Module[{root}, root = storyRootDirectory[]; If[root === $Failed, Return[$Failed]]; Last[FileNameSplit[root]]];


(* ::Subsubsection::Closed:: *)
(*State paths*)


currentStatePath[] := Module[{dir, base}, dir = currentNotebookDirectory[];
     base = currentNotebookBase[]; If[dir === $Failed || base === $Failed, Return[$Failed]];
     FileNameJoin[{dir, StringJoin[base, "-state.wxf"]}]];
nextNotebookBase[] := Module[{data, storyDir, nextChapterNumber, override},
    data = parseNotebookBase[currentNotebookBase[]]; If[data === $Failed, Return[$Failed]];
     storyDir = parentNotebookDirectory[]; If[storyDir === $Failed, Return[$Failed]];
     nextChapterNumber = data["ChapterNumber"] + 1;
     override = chapterOverride[storyDir, nextChapterNumber]; If[AssociationQ[override],
      makeNotebookBase[Join[data, Association["ChapterNumber" -> nextChapterNumber,
         "Arc" -> override["Arc"], "ArcChapterNumber" -> override["ArcChapterNumber"]]]],
      makeNotebookBase[Join[data, Association["ChapterNumber" -> nextChapterNumber,
         "ArcChapterNumber" -> data["ArcChapterNumber"] + 1]]]]];
nextStatePath[] := Module[{parent, nextBase}, parent = parentNotebookDirectory[];
     nextBase = nextNotebookBase[]; If[parent === $Failed || nextBase === $Failed,
      Return[$Failed]]; FileNameJoin[{parent, nextBase, StringJoin[nextBase,
        "-state.wxf"]}]];
nextNotebookPath[] := Module[{parent, nextBase}, parent = parentNotebookDirectory[];
     nextBase = nextNotebookBase[]; If[parent === $Failed || nextBase === $Failed,
      Return[$Failed]]; FileNameJoin[{parent, nextBase, StringJoin[nextBase, ".nb"]}]];


(* ::Subsubsection::Closed:: *)
(*Low-level save/load*)


saveExpressionToPath[path_String, expr_] := Module[{dir}, dir = DirectoryName[path];
     If[ !DirectoryQ[dir], CreateDirectory[dir, CreateIntermediateDirectories -> True]];
     Export[path, expr, "WXF"]];
loadStateFromPath[path_String] :=
   Module[{}, If[ !FileExistsQ[path], Message[loadStateFromPath::nofile, path];
       Return[$Failed]]; Import[path, "WXF"]];
loadStateFromPath::nofile = "No state file exists at `1`.";
chapterOverridesPath[storyDir_String] := FileNameJoin[
    {storyDir, ".ironlibrary-chapter-overrides.wxf"}];
loadChapterOverrides[storyDir_String] := Module[{path, data},
    path = chapterOverridesPath[storyDir]; If[ !FileExistsQ[path], Return[Association[]]];
     data = Import[path, "WXF"]; If[AssociationQ[data], data, Association[]]];
saveChapterOverrides[storyDir_String, overrides_Association] :=
   saveExpressionToPath[chapterOverridesPath[storyDir], overrides];
registerChapterOverride[storyDir_String, chapterNumber_Integer, arc_String,
    arcChapterNumber_Integer, arcTitle_:Automatic] := Module[{overrides, key, displayTitle},
    overrides = loadChapterOverrides[storyDir]; key = ToString[chapterNumber];
     displayTitle = Replace[arcTitle, Automatic :> titleCaseName[arc]];
     overrides[key] = Association["Arc" -> normalizeName[arc], "ArcChapterNumber" ->
        arcChapterNumber, "ArcTitle" -> displayTitle]; saveChapterOverrides[storyDir,
      overrides]];
chapterOverride[storyDir_String, chapterNumber_Integer] :=
   Lookup[loadChapterOverrides[storyDir], ToString[chapterNumber], Missing["NoOverride"]];


(* ::Subsubsection::Closed:: *)
(*Chapter seeding*)


chapterSeedFromBase[base_String] := Abs[Hash[{"IronLibrary", "chapter-seed", base}]];
seedChapter[state_Association] := Module[{seed}, If[ !KeyExistsQ[state, "seed"], Message[seedChapter::noseed]; Return[$Failed]]; seed = state["seed"]; SeedRandom[seed]; seed];
seedChapter::noseed = "The current state does not contain a seed.";
seedStoryState[base_String, state_:Automatic] := Module[
	{seed, storyState},
	seed = chapterSeedFromBase[base];
	storyState = If[AssociationQ[state], Association[state], <||>];
	storyState["seed"] = seed;
	If[seedChapter[storyState] === $Failed, Return[$Failed]];
	storyState
];
nextChapterSeed[] := Module[{base}, base = nextNotebookBase[]; If[base === $Failed, Return[$Failed]]; chapterSeedFromBase[base]];
stateForNextChapter[state_Association] := Module[{next, seed}, seed = nextChapterSeed[]; If[seed === $Failed, Return[$Failed]]; next = Association[state]; next["seed"] = seed; next];


(* ::Subsubsection::Closed:: *)
(*Notebook creation*)


romanNumeral[(n_Integer)?Positive] := RomanNumeral[n];
chapterTitleSubtitleFromPath[path_String] := Module[{base, data, storyDir, override, arcTitle, title, subtitle}, base = FileBaseName[path]; data = parseNotebookBase[base];
     If[data === $Failed, Return[$Failed]]; storyDir = DirectoryName[DirectoryName[path]]; override = chapterOverride[storyDir, data["ChapterNumber"]];
     arcTitle = If[AssociationQ[override] && KeyExistsQ[override, "ArcTitle"], override["ArcTitle"], titleCaseName[data["Arc"]]];
     title = StringJoin[titleCaseName[data["Story"]], ": Chapter ", ToString[data["ChapterNumber"]]]; subtitle = StringJoin[arcTitle, ", part ", romanNumeral[data["ArcChapterNumber"]]];
     Association["Title" -> title, "Subtitle" -> subtitle]];
libraryGetCell[] := If[StringQ[$IronLibraryPath] && $IronLibraryPath =!= $Failed, With[{path = $IronLibraryPath}, Cell[BoxData[ToBoxes[Defer[Get[path]; ]]], "Input", CellTags -> "IronLibraryGet"]],
    Cell["Load IronLibrary here.", "Text", CellTags -> "IronLibraryGet"]];
beginChapterCell[] := Cell[BoxData[RowBox[{"beginChapter", "[", "]", ";"}]], "Input", CellTags -> "IronLibraryBeginChapter"];
endChapterInstructionCell[] := Cell[
	"When you're done writing, switch the following cell to code and execute the notebook from top to bottom.
If you later decide to come back and add cells interactively, switch it back to text until you're done.",
	"Text",
	CellTags -> "IronLibraryEndChapterInstruction"
];

endChapterTextCell[] := Cell[
	"endChapter[];",
	"Text",
	CellTags -> "IronLibraryEndChapter"
];
chapterNotebookCells[path_String] := Module[{heading},
	heading = chapterTitleSubtitleFromPath[path];
	If[heading === $Failed, Return[$Failed]];
	{
		Cell[heading["Title"], "Title", CellTags -> "IronLibraryTitle"],
		Cell[heading["Subtitle"], "Subtitle", CellTags -> "IronLibrarySubtitle"],
		Cell["Header", "Section", CellTags -> "IronLibraryHeader"],
		libraryGetCell[],
		beginChapterCell[],
		Cell["Body", "Section", CellTags -> "IronLibraryBody"],
		Cell["Footer", "Section", CellTags -> "IronLibraryFooter"],
		endChapterInstructionCell[],
		endChapterTextCell[]
	}
];
createChapterNotebook[path_String] := Module[{cells}, If[FileExistsQ[path], Return[path]]; cells = chapterNotebookCells[path]; If[cells === $Failed, Return[$Failed]]; Export[path, Notebook[cells], "NB"];
     path];


(* ::Subsubsection::Closed:: *)
(*Header and boilerplate updates*)


deleteTaggedCells[nb_, tag_String] := Module[{cells}, cells = Cells[nb, CellTags -> tag]; If[cells =!= {}, NotebookDelete /@ cells]; ];
updateCurrentChapterHeading[arcTitle_:Automatic] := Module[{nb, path, base, data, title, subtitle, displayArc}, nb = currentNotebookObject[]; path = NotebookFileName[];
     If[path === $Failed, Return[$Failed]]; base = FileBaseName[path]; data = parseNotebookBase[base]; If[data === $Failed, Return[$Failed]];
     displayArc = Replace[arcTitle, Automatic :> titleCaseName[data["Arc"]]]; title = StringJoin[titleCaseName[data["Story"]], ": Chapter ", ToString[data["ChapterNumber"]]];
     subtitle = StringJoin[displayArc, ", part ", romanNumeral[data["ArcChapterNumber"]]]; deleteTaggedCells[nb, "IronLibraryTitle"]; deleteTaggedCells[nb, "IronLibrarySubtitle"];
     SelectionMove[nb, Before, Notebook]; NotebookWrite[nb, {Cell[title, "Title", CellTags -> "IronLibraryTitle"], Cell[subtitle, "Subtitle", CellTags -> "IronLibrarySubtitle"]}]; NotebookSave[nb];
     Association["Title" -> title, "Subtitle" -> subtitle]];
updateChapterNotebookHeading[path_String] := Module[{nb, heading}, If[ !FileExistsQ[path], Return[$Failed]]; heading = chapterTitleSubtitleFromPath[path]; If[heading === $Failed, Return[$Failed]];
     nb = NotebookOpen[path, Visible -> False]; SetOptions[nb, Visible -> Inherited]; deleteTaggedCells[nb, "IronLibraryTitle"]; deleteTaggedCells[nb, "IronLibrarySubtitle"];
     SelectionMove[nb, Before, Notebook]; NotebookWrite[nb, {Cell[heading["Title"], "Title", CellTags -> "IronLibraryTitle"], Cell[heading["Subtitle"], "Subtitle", CellTags -> "IronLibrarySubtitle"]}];
     NotebookSave[nb]; NotebookClose[nb]; heading];
firstInputCellObject[nb_] := Module[{cells}, cells = Cells[nb, CellStyle -> "Input"]; If[cells === {}, Missing["NoInputCell"], First[cells]]];
taggedCellExistsQ[nb_, tag_String] := Cells[nb, CellTags -> tag] =!= {};
ensureChapterOneBoilerplate[] := Module[
	{nb, path, heading, firstInput, needsSections, needsEndInstruction, needsEndCell},

	nb = currentNotebookObject[];
	path = NotebookFileName[];
	If[path === $Failed, Return[$Failed]];

	heading = chapterTitleSubtitleFromPath[path];
	If[heading === $Failed, Return[$Failed]];

	deleteTaggedCells[nb, "IronLibraryTitle"];
	deleteTaggedCells[nb, "IronLibrarySubtitle"];

	SelectionMove[nb, Before, Notebook];
	NotebookWrite[
		nb,
		{
			Cell[heading["Title"], "Title", CellTags -> "IronLibraryTitle"],
			Cell[heading["Subtitle"], "Subtitle", CellTags -> "IronLibrarySubtitle"]
		}
	];

	needsSections =
		!taggedCellExistsQ[nb, "IronLibraryHeader"] ||
		!taggedCellExistsQ[nb, "IronLibraryBody"] ||
		!taggedCellExistsQ[nb, "IronLibraryFooter"];

	If[needsSections,
		deleteTaggedCells[nb, "IronLibraryHeader"];
		deleteTaggedCells[nb, "IronLibraryBody"];
		deleteTaggedCells[nb, "IronLibraryFooter"];

		firstInput = firstInputCellObject[nb];

		If[firstInput === Missing["NoInputCell"],
			SelectionMove[nb, After, Notebook];
			NotebookWrite[
				nb,
				{
					Cell["Header", "Section", CellTags -> "IronLibraryHeader"],
					Cell["Body", "Section", CellTags -> "IronLibraryBody"],
					Cell["Footer", "Section", CellTags -> "IronLibraryFooter"]
				}
			],
			SelectionMove[firstInput, Before, Cell];
			NotebookWrite[
				nb,
				Cell["Header", "Section", CellTags -> "IronLibraryHeader"]
			];

			SelectionMove[firstInput, After, Cell];
			NotebookWrite[
				nb,
				{
					Cell["Body", "Section", CellTags -> "IronLibraryBody"],
					Cell["Footer", "Section", CellTags -> "IronLibraryFooter"]
				}
			]
		]
	];

	needsEndInstruction =
		!taggedCellExistsQ[nb, "IronLibraryEndChapterInstruction"];

	needsEndCell =
		!taggedCellExistsQ[nb, "IronLibraryEndChapter"];

	If[needsEndInstruction || needsEndCell,
		SelectionMove[Last[Cells[nb, CellTags -> "IronLibraryFooter"]], After, Cell];

		If[needsEndInstruction,
			NotebookWrite[nb, endChapterInstructionCell[]]
		];

		If[needsEndCell,
			NotebookWrite[nb, endChapterTextCell[]]
		]
	];

	NotebookSave[nb];
		heading
];


(* ::Subsubsection::Closed:: *)
(*Story and chapter renaming*)


chapterNotebookQ[] := Module[{base}, base = currentNotebookBase[]; If[ !StringQ[base], Return[False]]; Quiet[parseNotebookBase[base] =!= $Failed, parseNotebookBase::badname]];
beginChapter::notchapter = "beginChapter[ArcName -> arc] can only rename a chapter notebook.";
beginChapter::direxists = "Cannot rename chapter because the target chapter directory already exists: `1`.";
beginChapter::nostate = "No state is loaded, and no current chapter state file exists to load.";
renameCurrentChapterArc[newArc_String, state_:Automatic] := Module[
	{
		oldBase, data, storyDir, oldDir, normalizedArc, newData, newBase, newDir,
		oldNotebookFile, newNotebookPath, oldStatePath, newStatePath,
		movedOldNotebookPath, movedOldStatePath, oldArc, oldArcStart, chapterState
	},
	If[!chapterNotebookQ[], Message[beginChapter::notchapter]; Return[$Failed]];
	oldBase = currentNotebookBase[];
	data = parseNotebookBase[oldBase];
	If[data === $Failed, Return[$Failed]];
	oldArc = data["Arc"];
	oldArcStart = data["ArcChapterNumber"];
	storyDir = parentNotebookDirectory[];
	oldDir = currentNotebookDirectory[];
	If[storyDir === $Failed || oldDir === $Failed, Return[$Failed]];
	normalizedArc = normalizeName[newArc];
	newData = Join[data, Association["Arc" -> normalizedArc, "ArcChapterNumber" -> 1]];
	newBase = makeNotebookBase[newData];
	chapterState = If[AssociationQ[state], Association[state], Automatic];
	If[newBase === oldBase,
		registerChapterOverride[storyDir, data["ChapterNumber"], normalizedArc, 1, newArc];
		chapterState = seedStoryState[newBase, chapterState];
		If[chapterState === $Failed, Return[$Failed]];
		updateCurrentChapterHeading[newArc];
		If[propagateArcRename[storyDir, oldArc, oldArcStart, normalizedArc, data["ChapterNumber"], newArc] === $Failed, Return[$Failed]];
		Return[Association["OldNotebookBase" -> oldBase, "NewNotebookBase" -> newBase, "AlreadyInArc" -> True, "State" -> chapterState]]
	];
	newDir = FileNameJoin[{storyDir, newBase}];
	If[DirectoryQ[newDir], Message[beginChapter::direxists, newDir]; Return[$Failed]];
	oldNotebookFile = NotebookFileName[];
	oldStatePath = currentStatePath[];
	If[oldNotebookFile === $Failed || oldStatePath === $Failed, Return[$Failed]];
	If[!AssociationQ[chapterState],
		If[
			FileExistsQ[oldStatePath],
			chapterState = loadStateFromPath[oldStatePath];
			If[chapterState === $Failed, Return[$Failed]],
			Message[beginChapter::nostate];
			Return[$Failed]
		]
	];
	NotebookSave[currentNotebookObject[]];
	RenameDirectory[oldDir, newDir];
	newNotebookPath = FileNameJoin[{newDir, StringJoin[newBase, ".nb"]}];
	newStatePath = FileNameJoin[{newDir, StringJoin[newBase, "-state.wxf"]}];
	movedOldNotebookPath = FileNameJoin[{newDir, FileNameTake[oldNotebookFile]}];
	movedOldStatePath = FileNameJoin[{newDir, FileNameTake[oldStatePath]}];
	NotebookSave[currentNotebookObject[], newNotebookPath];
	If[FileExistsQ[movedOldNotebookPath] && !samePathQ[movedOldNotebookPath, newNotebookPath], DeleteFile[movedOldNotebookPath]];
	chapterState = seedStoryState[newBase, chapterState];
	If[chapterState === $Failed, Return[$Failed]];
	If[saveExpressionToPath[newStatePath, chapterState] === $Failed, Return[$Failed]];
	If[FileExistsQ[movedOldStatePath] && !samePathQ[movedOldStatePath, newStatePath], DeleteFile[movedOldStatePath]];
	registerChapterOverride[storyDir, data["ChapterNumber"], normalizedArc, 1, newArc];
	updateCurrentChapterHeading[newArc];
	If[propagateArcRename[storyDir, oldArc, oldArcStart, normalizedArc, data["ChapterNumber"], newArc] === $Failed, Return[$Failed]];
	Association["OldNotebookBase" -> oldBase, "NewNotebookBase" -> newBase, "NotebookPath" -> newNotebookPath, "StatePath" -> newStatePath, "AlreadyInArc" -> False, "State" -> chapterState]
];
beginStory::notfirstchapter = "beginStory[name] can only rename an already-started story from chapter 1.";
beginStory::storydirexists = "Cannot rename story because the target story directory already exists: `1`.";
renameCurrentStory[storyName_String, state_:Automatic] := Module[
	{
		oldBase, data, oldStoryDir, storyRoot, oldChapterDir, story, arc, newBase,
		newStoryDir, movedOldChapterDir, newChapterDir, oldNotebookFile,
		movedOldNotebookPath, newNotebookPath, oldStatePath, movedOldStatePath,
		newStatePath, storyState
	},
	If[!chapterNotebookQ[], Return[$Failed]];
	oldBase = currentNotebookBase[];
	data = parseNotebookBase[oldBase];
	If[data === $Failed, Return[$Failed]];
	If[data["ChapterNumber"] =!= 1, Message[beginStory::notfirstchapter]; Return[$Failed]];
	oldStoryDir = parentNotebookDirectory[];
	oldChapterDir = currentNotebookDirectory[];
	If[oldStoryDir === $Failed || oldChapterDir === $Failed, Return[$Failed]];
	storyRoot = DirectoryName[oldStoryDir];
	story = normalizeName[storyName];
	arc = data["Arc"];
	newBase = makeNotebookBase[Join[data, Association["Story" -> story, "Arc" -> arc]]];
	newStoryDir = FileNameJoin[{storyRoot, story}];
	newChapterDir = FileNameJoin[{newStoryDir, newBase}];
	oldNotebookFile = NotebookFileName[];
	If[oldNotebookFile === $Failed, Return[$Failed]];
	oldStatePath = currentStatePath[];
	storyState = If[AssociationQ[state], Association[state], Automatic];
	If[newBase === oldBase && samePathQ[newStoryDir, oldStoryDir],
		storyState = seedStoryState[newBase, storyState];
		If[storyState === $Failed, Return[$Failed]];
		ensureChapterOneBoilerplate[];
		If[propagateStoryRename[oldStoryDir, data["Story"], story] === $Failed, Return[$Failed]];
		Return[Association["NotebookPath" -> oldNotebookFile, "StoryDirectory" -> oldStoryDir, "AlreadyBegun" -> True, "Renamed" -> False, "State" -> storyState]]
	];
	If[DirectoryQ[newStoryDir] && !samePathQ[newStoryDir, oldStoryDir], Message[beginStory::storydirexists, newStoryDir]; Return[$Failed]];
	NotebookSave[currentNotebookObject[]];
	If[
		!samePathQ[newStoryDir, oldStoryDir],
		RenameDirectory[oldStoryDir, newStoryDir];
		movedOldChapterDir = FileNameJoin[{newStoryDir, FileNameTake[oldChapterDir]}],
		movedOldChapterDir = oldChapterDir
	];
	If[
		!samePathQ[newChapterDir, movedOldChapterDir],
		If[DirectoryQ[newChapterDir], Message[beginStory::direxists, newChapterDir]; Return[$Failed]];
		RenameDirectory[movedOldChapterDir, newChapterDir];
	];
	newNotebookPath = FileNameJoin[{newChapterDir, StringJoin[newBase, ".nb"]}];
	movedOldNotebookPath = FileNameJoin[{newChapterDir, FileNameTake[oldNotebookFile]}];
	NotebookSave[currentNotebookObject[], newNotebookPath];
	If[FileExistsQ[movedOldNotebookPath] && !samePathQ[movedOldNotebookPath, newNotebookPath], DeleteFile[movedOldNotebookPath]];
	If[
		oldStatePath =!= $Failed,
		movedOldStatePath = FileNameJoin[{newChapterDir, FileNameTake[oldStatePath]}];
		newStatePath = FileNameJoin[{newChapterDir, StringJoin[newBase, "-state.wxf"]}];
		If[FileExistsQ[movedOldStatePath] && !samePathQ[movedOldStatePath, newStatePath], RenameFile[movedOldStatePath, newStatePath]];
	];
	storyState = seedStoryState[newBase, storyState];
	If[storyState === $Failed, Return[$Failed]];
	ensureChapterOneBoilerplate[];
	If[propagateStoryRename[newStoryDir, data["Story"], story] === $Failed, Return[$Failed]];
	Association["NotebookPath" -> newNotebookPath, "StoryDirectory" -> newStoryDir, "OldNotebookBase" -> oldBase, "NewNotebookBase" -> newBase, "AlreadyBegun" -> True, "Renamed" -> True, "State" -> storyState]
];
renameChapterDirectoryForStory[chapterDir_String, oldStory_String, newStory_String] := Module[{oldBase, data, newBase, parent, newDir, movedOldNotebookPath, newNotebookPath, movedOldStatePath,
     newStatePath}, oldBase = FileNameTake[chapterDir]; data = Quiet[parseNotebookBase[oldBase], parseNotebookBase::badname]; If[data === $Failed, Return[$Failed]];
     If[data["Story"] =!= oldStory, Return[chapterDir]]; newBase = makeNotebookBase[Join[data, Association["Story" -> newStory]]]; If[newBase === oldBase, Return[chapterDir]];
     parent = DirectoryName[chapterDir]; newDir = FileNameJoin[{parent, newBase}]; If[DirectoryQ[newDir], Message[beginStory::direxists, newDir]; Return[$Failed]]; RenameDirectory[chapterDir, newDir];
     movedOldNotebookPath = FileNameJoin[{newDir, StringJoin[oldBase, ".nb"]}]; newNotebookPath = FileNameJoin[{newDir, StringJoin[newBase, ".nb"]}];
     movedOldStatePath = FileNameJoin[{newDir, StringJoin[oldBase, "-state.wxf"]}]; newStatePath = FileNameJoin[{newDir, StringJoin[newBase, "-state.wxf"]}];
     If[FileExistsQ[movedOldNotebookPath], If[FileExistsQ[newNotebookPath], DeleteFile[movedOldNotebookPath], RenameFile[movedOldNotebookPath, newNotebookPath]]];
     If[FileExistsQ[movedOldStatePath], If[FileExistsQ[newStatePath], DeleteFile[movedOldStatePath], RenameFile[movedOldStatePath, newStatePath]]];
     If[FileExistsQ[newNotebookPath], updateChapterNotebookHeading[newNotebookPath]]; newDir];
propagateStoryRename[storyDir_String, oldStory_String, newStory_String] := Module[{chapterDirs, results}, chapterDirs = Select[FileNames["*", storyDir], DirectoryQ];
     results = (renameChapterDirectoryForStory[#1, oldStory, newStory] & ) /@ chapterDirs; If[MemberQ[results, $Failed], Return[$Failed]]; results];
renameChapterDirectoryForArc[chapterDir_String, oldArc_String, oldArcStart_Integer, newArc_String, currentChapterNumber_Integer, arcTitle_String] :=
   Module[{oldBase, data, newArcChapterNumber, newBase, parent, newDir, movedOldNotebookPath, newNotebookPath, movedOldStatePath, newStatePath, storyDir},
    oldBase = FileNameTake[chapterDir]; data = Quiet[parseNotebookBase[oldBase], parseNotebookBase::badname]; If[data === $Failed, Return[$Failed]];
     If[data["ChapterNumber"] <= currentChapterNumber, Return[chapterDir]]; If[data["Arc"] =!= oldArc, Return[chapterDir]]; If[data["ArcChapterNumber"] < oldArcStart, Return[chapterDir]];
     newArcChapterNumber = data["ArcChapterNumber"] - oldArcStart + 1; newBase = makeNotebookBase[Join[data, Association["Arc" -> newArc, "ArcChapterNumber" -> newArcChapterNumber]]];
     If[newBase === oldBase, Return[chapterDir]]; parent = DirectoryName[chapterDir]; storyDir = parent; newDir = FileNameJoin[{parent, newBase}];
     If[DirectoryQ[newDir], Message[beginChapter::direxists, newDir]; Return[$Failed]]; RenameDirectory[chapterDir, newDir]; movedOldNotebookPath = FileNameJoin[{newDir, StringJoin[oldBase, ".nb"]}];
     newNotebookPath = FileNameJoin[{newDir, StringJoin[newBase, ".nb"]}]; movedOldStatePath = FileNameJoin[{newDir, StringJoin[oldBase, "-state.wxf"]}];
     newStatePath = FileNameJoin[{newDir, StringJoin[newBase, "-state.wxf"]}]; If[FileExistsQ[movedOldNotebookPath], If[FileExistsQ[newNotebookPath], DeleteFile[movedOldNotebookPath],
       RenameFile[movedOldNotebookPath, newNotebookPath]]]; If[FileExistsQ[movedOldStatePath], If[FileExistsQ[newStatePath], DeleteFile[movedOldStatePath], RenameFile[movedOldStatePath, newStatePath]]];
     registerChapterOverride[storyDir, data["ChapterNumber"], newArc, newArcChapterNumber, arcTitle]; If[FileExistsQ[newNotebookPath], updateChapterNotebookHeading[newNotebookPath]]; newDir];
propagateArcRename[storyDir_String, oldArc_String, oldArcStart_Integer, newArc_String, currentChapterNumber_Integer, arcTitle_String] :=
   Module[{chapterDirs, results}, chapterDirs = Select[FileNames["*", storyDir], DirectoryQ];
     results = (renameChapterDirectoryForArc[#1, oldArc, oldArcStart, newArc, currentChapterNumber, arcTitle] & ) /@ chapterDirs; If[MemberQ[results, $Failed], Return[$Failed]]; results];




(* ::Subsection::Closed:: *)
(*Story and chapter lifecycle*)


beginStory[] := (Message[beginStory::missing]; $Failed);
beginStory[name_String, state_:Automatic] := Module[
	{root, story, arc, base, storyDir, chapterDir, notebookPath, oldNotebookFile, storyState},
	If[chapterNotebookQ[], Return[renameCurrentStory[name, state]]];
	root = storyRootDirectory[];
	If[root === $Failed, Return[$Failed]];
	story = normalizeName[name];
	arc = normalizeName["Introduction"];
	storyDir = FileNameJoin[{root, story}];
	If[!DirectoryQ[storyDir], CreateDirectory[storyDir, CreateIntermediateDirectories -> True]];
	base = makeNotebookBase[Association["Story" -> story, "ChapterNumber" -> 1, "Arc" -> arc, "ArcChapterNumber" -> 1]];
	chapterDir = FileNameJoin[{storyDir, base}];
	If[DirectoryQ[chapterDir], Message[beginStory::direxists, chapterDir]; Return[$Failed]];
	CreateDirectory[chapterDir, CreateIntermediateDirectories -> True];
	notebookPath = FileNameJoin[{chapterDir, StringJoin[base, ".nb"]}];
	oldNotebookFile = NotebookFileName[];
	If[oldNotebookFile === $Failed, Message[currentNotebookBase::unsaved]; Return[$Failed]];
	NotebookSave[currentNotebookObject[], notebookPath];
	If[FileExistsQ[oldNotebookFile] && oldNotebookFile =!= notebookPath, DeleteFile[oldNotebookFile]];
	storyState = seedStoryState[base, state];
	If[storyState === $Failed, Return[$Failed]];
	ensureChapterOneBoilerplate[];
	Association["NotebookPath" -> notebookPath, "StoryDirectory" -> storyDir, "AlreadyBegun" -> False, "State" -> storyState]
];
beginStory[name_] := (Message[beginStory::badname, name]; $Failed);
beginStory::missing = "beginStory requires an explicit story name: beginStory[name].";
beginStory::badname = "Story name `1` is not a string.";
beginStory::direxists = "Cannot begin story because the target chapter directory already exists: `1`.";
Options[beginChapter] = {ArcName -> Automatic};
beginChapter[OptionsPattern[]] := Module[{path, loaded, arcName, renamed},
	path = currentStatePath[];
	If[path === $Failed, Return[$Failed]];
	loaded = loadStateFromPath[path];
	If[loaded === $Failed, Return[$Failed]];
	If[seedChapter[loaded] === $Failed, Return[$Failed]];
	arcName = OptionValue[ArcName];
	If[
		arcName =!= Automatic,
		If[!StringQ[arcName], Message[beginChapter::badarc, arcName]; Return[$Failed]];
		renamed = renameCurrentChapterArc[arcName, loaded];
		If[renamed === $Failed, Return[$Failed]];
		loaded = Lookup[renamed, "State", loaded];
	];
	loaded
];
beginChapter::badarc = "ArcName must be Automatic or a string, not `1`.";
endChapter[state_Association] := Module[{statePath, notebookPath}, statePath = nextStatePath[]; notebookPath = nextNotebookPath[]; If[statePath === $Failed || notebookPath === $Failed, Return[$Failed]];
     If[saveExpressionToPath[statePath, stateForNextChapter[state]] === $Failed, Return[$Failed]]; createChapterNotebook[notebookPath]; Association["StatePath" -> statePath, "NotebookPath" -> notebookPath]];


(* ::Subsection::Closed:: *)
(*Private context footer*)


End[];


(* ::Section::Closed:: *)
(*Package footer*)


EndPackage[];
