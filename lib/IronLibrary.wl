(* ::Package:: *)

(* ::Title:: *)
(*The Iron Library*)


(* ::Subtitle:: *)
(*An implementation of Ironsworn mechanics*)


(* ::Chapter:: *)
(*License information*)


(* ::Text:: *)
(*This work is based on Ironsworn, Ironsworn: Delve, and Ironsworn: Starforged, created by Shawn Tomkin, and licensed for our use under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International license (CC BY-NC-SA 4.0).*)
(**)
(*SPDX-License-Identifier: CC-BY-NC-SA-4.0*)
(*SPDX-FileCopyrightText: 2026 Cuyler Brehaut*)


(* ::Chapter:: *)
(*Introduction*)


(* ::Text:: *)
(*This library implements Ironsworn mechanics in Wolfram Mathematica. Its primary purpose is to enable the user to write solo Ironsworn journals in Wolfram notebooks, in which code cells presenting reproducible mechanical outcomes alternate with text cells presenting their interpretations in prose. The reader of such a journal can then verify the mechanical outcomes by re-running the notebook and comparing the mechanical outputs to their prose interpretations. This supports a "hard" form of literature whose author is constrained to interpret and report outcomes beyond their control.*)
(*	The Iron Library accomplishes this by tracking the mechanical states of PCs and NPCs and by exposing to the user functions that implement moves, present their results in a pleasantly readable form, and update the game state accordingly.*)


(* ::Chapter:: *)
(*Code*)


(* ::Section:: *)
(*Package header*)


BeginPackage["IronLibrary`"];


(* ::Section:: *)
(*Public interface*)


(* ::Text:: *)
(*The following functions are exposed to the user.*)


(* ::Subsection:: *)
(*State management*)


resetIronSession::usage =
  "resetIronSession[] clears the current in-memory IronLibrary state and solo character.";
beginStory::usage = "beginStory[] starts a new story from the current notebook, using \
$soloCharacter as the story name. \nbeginStory[name] starts a new story using name as the \
story name. It creates a top-level story directory, creates the first chapter directory \
inside it, and renames/saves the current notebook as the first chapter notebook."; 
beginChapter::usage = "beginChapter[] loads the state file for the current chapter notebook \
into $state and seeds the random number generator.\nbeginChapter[ArcName -> arc] additionally \
renames the current chapter as the first chapter of arc."; 
endChapter::usage = "endChapter[] ends the current chapter by saving $state for the next \
chapter and generating the next chapter notebook. The next chapter keeps the same arc name \
and increments both the global chapter number and the chapter-within-arc number."; 


(* ::Subsection:: *)
(*Character management*)


setSoloCharacter::usage = "setSoloCharacter[name] sets $soloCharacter to the \
named\ncharacter, who must already exist in the state. Functions that take a \
character\nargument default to $soloCharacter when none is supplied."; 
createCharacter::usage = "createCharacter[Name -> name, Assets -> {a1, a2, a3}, Edge \
-> e, Heart -> h, Iron -> i, Shadow -> s, Wits -> w, BackgroundVow -> \
{vowName, vowDescription, vowRank}, Bonds -> {b1, ...}] adds a new character to \
$state with full starting values for resources (health, spirit, supply, momentum) and \
the given stats, assets, background vow, and bonds. Stats must be integers in 1-5; \
rank must be one of the defined ranks (Troublesome, Dangerous, Formidable, Extreme, \
Epic)."; 


(* ::Subsection:: *)
(*Action roll*)


actionRoll::usage="actionRoll[stat] performs an action roll for $soloCharacter using the given stat, which must be one of Edge, Heart, Iron, Shadow, or Wits. actionRoll[stat, character] performs the roll for the named character. Returns an Association with keys character, actionDie, stat, statValue, adds, actionScore, challengeDice, match, and result. Option Adds -> <|reason -> n, ...|> applies named adds to the action score.";


(* ::Subsection:: *)
(*Option names*)


Name::usage = "Name is an option for createCharacter specifying the character name."; 
Edge::usage = "Edge is one of the five Ironsworn stats and an option for createCharacter."; 
Heart::usage = "Heart is one of the five Ironsworn stats and an option for createCharacter."; 
Iron::usage = "Iron is one of the five Ironsworn stats and an option for createCharacter."; 
Shadow::usage = 
   "Shadow is one of the five Ironsworn stats and an option for createCharacter."; 
Wits::usage = "Wits is one of the five Ironsworn stats and an option for createCharacter."; 
Assets::usage = 
   "Assets is an option for createCharacter specifying a list of three asset names."; 
BackgroundVow::usage = "BackgroundVow is an option for createCharacter specifying {name, \
description, rank} for the character's starting background vow."; 
Bonds::usage = 
   "Bonds is an option for createCharacter specifying a list of starting bonds (max 3)."; 
Adds::usage = "Adds is an option for actionRoll specifying an Association of named bonuses, \
e.g. <|\"running\" -> 1, \"asset bonus\" -> 1|>."; 
ArcName::usage = "ArcName is an option for beginChapter. ArcName -> arc renames the current \
chapter as the first chapter of arc after loading its state. ArcName -> Automatic leaves the \
current chapter name unchanged."; 


(* ::Subsection:: *)
(*Rank symbols*)


Troublesome::usage = "Troublesome is a rank."; 
Dangerous::usage = "Dangerous is a rank."; 
Formidable::usage = "Formidable is a rank."; 
Extreme::usage = "Extreme is a rank."; 
Epic::usage = "Epic is a rank."; 


(* ::Section:: *)
(*Implementation details*)


(* ::Text:: *)
(*The following code implements the public interface above.*)


(* ::Subsection:: *)
(*Private context header*)


Begin["`Private`"]; 


(* ::Subsection:: *)
(*Constants*)


stats = {Edge, Heart, Iron, Shadow, Wits}; 
ranks = {Troublesome, Dangerous, Formidable, Extreme, Epic}; 


(* ::Subsection:: *)
(*Helper functions*)


(* ::Subsubsection:: *)
(*Library path variable*)


If[ !ValueQ[$IronLibraryPath], $IronLibraryPath = 
    If[StringQ[$InputFileName] && $InputFileName =!= "", $InputFileName, $Failed]]; 


(* ::Subsubsection:: *)
(*Rolling dice*)


rollChallengeDice[] := RandomInteger[{1, 10}, 2]; 
rollActionDie[] := RandomInteger[{1, 6}]; 
actionRollResult[challengeDice_, actionScore_] := 
   Replace[{0 -> "miss", 1 -> "weakHit", 2 -> "strongHit"}][
    Count[True][(Map[actionScore > #1 & ])[challengeDice]]]; 


(* ::Subsubsection:: *)
(*Argument tests*)


statQ[input_] := MemberQ[stats, input]; 
rankQ[input_] := MemberQ[ranks, input]; 
statValueQ[input_Integer] := 1 <= input <= 5; 


(* ::Subsubsection:: *)
(*Constructors*)


constructProgressTrack[description_String, (rank_)?rankQ] := 
   Association["rank" -> rank, "description" -> description, "progress" -> 0]; 


(* ::Subsubsection:: *)
(*Symbol to string conversion*)


symString[symbol_] := ToLowerCase[SymbolName[symbol]]; 


(* ::Subsubsection:: *)
(*Name normalization*)


normalizeName[s_String] := Module[{name}, name = ToLowerCase[StringTrim[s]]; 
     name = StringReplace[name, {WhitespaceCharacter.. -> "_", "-" -> "_"}]; 
     name = StringReplace[name, "_".. -> "_"]; StringTrim[name, "_"]]; 


(* ::Subsubsection:: *)
(*State initialization*)


newState[] := newState[Automatic]; 
newState[seed_] := $state = Association["journey" -> Association[], 
     "combats" -> Association[], "seed" -> Replace[seed, 
       Automatic :> RandomInteger[{1, 2^31 - 1}]]]; 
ensureStateInitialized[] := Module[{base, seed}, If[AssociationQ[$state], Return[$state]]; 
     base = currentNotebookBase[]; 
     seed = If[StringQ[base] && Quiet[parseNotebookBase[base] =!= $Failed, 
         parseNotebookBase::badname], chapterSeedFromBase[base], Automatic]; newState[seed]; 
     If[seed =!= Automatic, seedChapter[]]; $state]; 


(* ::Subsubsection:: *)
(*Notebook/path helpers*)


currentNotebookObject[] := EvaluationNotebook[]; 
currentNotebookDirectory[] := Module[{dir = NotebookDirectory[]}, 
    If[dir === $Failed, Message[currentNotebookDirectory::unsaved]; Return[$Failed]]; dir]; 
currentNotebookDirectory::unsaved = 
   "The current notebook must be saved before its directory can be determined."; 
currentNotebookBase[] := Module[{file = NotebookFileName[]}, 
    If[file === $Failed, Message[currentNotebookBase::unsaved]; Return[$Failed]]; 
     FileBaseName[file]]; 
currentNotebookBase::unsaved = 
   "The current notebook must be saved before its file name can be determined."; 
parentNotebookDirectory[] := Module[{dir = currentNotebookDirectory[]}, 
    If[dir === $Failed, Return[$Failed]]; DirectoryName[dir]]; 
canonicalPath[p_String] := FileNameJoin[FileNameSplit[ExpandFileName[p]]]; 
samePathQ[a_String, b_String] := canonicalPath[a] === canonicalPath[b]; 


(* ::Subsubsection:: *)
(*Notebook-name parsing*)


parseNotebookBase[name_String] := Module[{match}, 
    match = StringCases[name, RegularExpression["^(.+)-(\\d+)-(.+)-(\\d+)$"] :> 
        {"$1", ToExpression["$2"], "$3", ToExpression["$4"]}]; 
     If[match === {}, Message[parseNotebookBase::badname, name]; Return[$Failed]]; 
     AssociationThread[{"Story", "ChapterNumber", "Arc", "ArcChapterNumber"}, 
      First[match]]]; 
parseNotebookBase::badname = 
   "Notebook name `1` does not match the expected form story-chapter-arc-arcchapter."\
; 
makeNotebookBase[data_Association] := StringRiffle[
    {data["Story"], ToString[data["ChapterNumber"]], data["Arc"], 
     ToString[data["ArcChapterNumber"]]}, "-"]; 


(* ::Subsubsection:: *)
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


(* ::Subsubsection:: *)
(*Low-level save/load*)


saveExpressionToPath[path_String, expr_] := Module[{dir}, dir = DirectoryName[path]; 
     If[ !DirectoryQ[dir], CreateDirectory[dir, CreateIntermediateDirectories -> True]]; 
     Export[path, expr, "WXF"]]; 
loadStateFromPath[path_String] := 
   Module[{}, If[ !FileExistsQ[path], Message[loadStateFromPath::nofile, path]; 
       Return[$Failed]]; $state = Import[path, "WXF"]]; 
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


(* ::Subsubsection:: *)
(*Notebook creation*)


titleCaseName[s_String] := StringRiffle[Capitalize /@ 
     StringSplit[StringReplace[StringTrim[s], {"_" -> " ", "-" -> " "}], 
      WhitespaceCharacter..], " "]; 
romanNumeral[(n_Integer)?Positive] := RomanNumeral[n]; 
chapterTitleSubtitleFromPath[path_String] := 
   Module[{base, data, storyDir, override, arcTitle, title, subtitle}, 
    base = FileBaseName[path]; data = parseNotebookBase[base]; 
     If[data === $Failed, Return[$Failed]]; storyDir = DirectoryName[DirectoryName[path]]; 
     override = chapterOverride[storyDir, data["ChapterNumber"]]; 
     arcTitle = If[AssociationQ[override] && KeyExistsQ[override, "ArcTitle"], 
       override["ArcTitle"], titleCaseName[data["Arc"]]]; 
     title = StringJoin[titleCaseName[data["Story"]], ": Chapter ", 
       ToString[data["ChapterNumber"]]]; subtitle = StringJoin[arcTitle, ", part ", 
       romanNumeral[data["ArcChapterNumber"]]]; Association["Title" -> title, 
      "Subtitle" -> subtitle]]; 
libraryGetCell[] := If[StringQ[$IronLibraryPath] && $IronLibraryPath =!= $Failed, 
    With[{path = $IronLibraryPath}, Cell[BoxData[ToBoxes[Defer[Get[path]; ]]], "Input", 
      CellTags -> "IronLibraryGet"]], Cell["Load IronLibrary here.", "Text", 
     CellTags -> "IronLibraryGet"]]; 
beginChapterCell[] := Cell[BoxData[ToBoxes[Defer[beginChapter[]; ]]], "Input", 
    CellTags -> "IronLibraryBeginChapter"]; 
endChapterCell[] := Cell[BoxData[ToBoxes[Defer[endChapter[]; ]]], "Input", 
    CellTags -> "IronLibraryEndChapter"]; 
chapterNotebookCells[path_String] := Module[{heading}, 
    heading = chapterTitleSubtitleFromPath[path]; If[heading === $Failed, Return[$Failed]]; 
     {Cell[heading["Title"], "Title", CellTags -> "IronLibraryTitle"], 
      Cell[heading["Subtitle"], "Subtitle", CellTags -> "IronLibrarySubtitle"], 
      Cell["Header", "Section", CellTags -> "IronLibraryHeader"], libraryGetCell[], 
      beginChapterCell[], Cell["Body", "Section", CellTags -> "IronLibraryBody"], 
      Cell["Footer", "Section", CellTags -> "IronLibraryFooter"], endChapterCell[]}]; 
createChapterNotebook[path_String] := Module[{nb, cells}, 
    If[FileExistsQ[path], Return[path]]; cells = chapterNotebookCells[path]; 
     If[cells === $Failed, Return[$Failed]]; nb = CreateDocument[cells, Visible -> False]; 
     NotebookSave[nb, path]; NotebookClose[nb]; path]; 


(* ::Subsubsection:: *)
(*Header updates*)


deleteTaggedCells[nb_, tag_String] := Module[{cells}, cells = Cells[nb, CellTags -> tag]; 
     If[cells =!= {}, NotebookDelete /@ cells]; ]; 
updateCurrentChapterHeading[arcTitle_:Automatic] := 
   Module[{nb, path, base, data, title, subtitle, displayArc}, 
    nb = currentNotebookObject[]; path = NotebookFileName[]; 
     If[path === $Failed, Return[$Failed]]; base = FileBaseName[path]; 
     data = parseNotebookBase[base]; If[data === $Failed, Return[$Failed]]; 
     displayArc = Replace[arcTitle, Automatic :> titleCaseName[data["Arc"]]]; 
     title = StringJoin[titleCaseName[data["Story"]], ": Chapter ", 
       ToString[data["ChapterNumber"]]]; subtitle = StringJoin[displayArc, ", part ", 
       romanNumeral[data["ArcChapterNumber"]]]; deleteTaggedCells[nb, "IronLibraryTitle"]; 
     deleteTaggedCells[nb, "IronLibrarySubtitle"]; SelectionMove[nb, Before, Notebook]; 
     NotebookWrite[nb, {Cell[title, "Title", CellTags -> "IronLibraryTitle"], 
       Cell[subtitle, "Subtitle", CellTags -> "IronLibrarySubtitle"]}]; NotebookSave[nb]; 
     Association["Title" -> title, "Subtitle" -> subtitle]]; 
updateChapterNotebookHeading[path_String] := Module[{nb, heading}, 
    If[ !FileExistsQ[path], Return[$Failed]]; heading = chapterTitleSubtitleFromPath[path]; 
     If[heading === $Failed, Return[$Failed]]; nb = NotebookOpen[path, Visible -> False]; 
     deleteTaggedCells[nb, "IronLibraryTitle"]; deleteTaggedCells[nb, 
      "IronLibrarySubtitle"]; SelectionMove[nb, Before, Notebook]; 
     NotebookWrite[nb, {Cell[heading["Title"], "Title", CellTags -> "IronLibraryTitle"], 
       Cell[heading["Subtitle"], "Subtitle", CellTags -> "IronLibrarySubtitle"]}]; 
     NotebookSave[nb]; NotebookClose[nb]; heading]; 
firstInputCellObject[nb_] := Module[{cells}, cells = Cells[nb, CellStyle -> "Input"]; 
     If[cells === {}, Missing["NoInputCell"], First[cells]]]; 
taggedCellExistsQ[nb_, tag_String] := Cells[nb, CellTags -> tag] =!= {}; 
ensureChapterOneBoilerplate[] := Module[{nb, path, heading, firstInput, needsStructure}, 
    nb = currentNotebookObject[]; path = NotebookFileName[]; 
     If[path === $Failed, Return[$Failed]]; heading = chapterTitleSubtitleFromPath[path]; 
     If[heading === $Failed, Return[$Failed]]; deleteTaggedCells[nb, "IronLibraryTitle"]; 
     deleteTaggedCells[nb, "IronLibrarySubtitle"]; SelectionMove[nb, Before, Notebook]; 
     NotebookWrite[nb, {Cell[heading["Title"], "Title", CellTags -> "IronLibraryTitle"], 
       Cell[heading["Subtitle"], "Subtitle", CellTags -> "IronLibrarySubtitle"]}]; 
     needsStructure =  !taggedCellExistsQ[nb, "IronLibraryHeader"] || 
        !taggedCellExistsQ[nb, "IronLibraryBody"] || 
        !taggedCellExistsQ[nb, "IronLibraryFooter"] || 
        !taggedCellExistsQ[nb, "IronLibraryEndChapter"]; If[needsStructure, 
      deleteTaggedCells[nb, "IronLibraryHeader"]; deleteTaggedCells[nb, "IronLibraryBody"]; 
       deleteTaggedCells[nb, "IronLibraryFooter"]; deleteTaggedCells[nb, 
        "IronLibraryEndChapter"]; firstInput = firstInputCellObject[nb]; 
       If[firstInput === Missing["NoInputCell"], SelectionMove[nb, After, Notebook]; 
         NotebookWrite[nb, {Cell["Header", "Section", CellTags -> "IronLibraryHeader"], 
           Cell["Body", "Section", CellTags -> "IronLibraryBody"], Cell["Footer", "Section", 
            CellTags -> "IronLibraryFooter"], endChapterCell[]}], 
        SelectionMove[firstInput, Before, Cell]; NotebookWrite[nb, Cell["Header", "Section", 
           CellTags -> "IronLibraryHeader"]]; SelectionMove[firstInput, After, Cell]; 
         NotebookWrite[nb, {Cell["Body", "Section", CellTags -> "IronLibraryBody"], 
           Cell["Footer", "Section", CellTags -> "IronLibraryFooter"], 
           endChapterCell[]}]]; ]; NotebookSave[nb]; heading]; 


(* ::Subsubsection:: *)
(*Story name derivation*)


storyRootDirectory[] := Module[{dir}, dir = currentNotebookDirectory[]; 
     If[dir === $Failed, Return[$Failed]]; dir]; 
storyNameFromRoot[] := Module[{root}, root = storyRootDirectory[]; 
     If[root === $Failed, Return[$Failed]]; Last[FileNameSplit[root]]]; 
storyNameFromSoloCharacter[] := Module[{}, If[ValueQ[$soloCharacter] && 
      StringQ[$soloCharacter], $soloCharacter, Message[beginStory::noname]; $Failed]]; 
beginStory::noname = "No story name was supplied, and $soloCharacter has not been set. Either \
call beginStory[name] or create a character first."; 


(* ::Subsubsection:: *)
(*Chapter notebook helper*)


chapterNotebookQ[] := Module[{base}, base = currentNotebookBase[]; 
     If[ !StringQ[base], Return[False]]; Quiet[parseNotebookBase[base] =!= $Failed, 
      parseNotebookBase::badname]]; 
beginChapter::notchapter = 
   "beginChapter[ArcName -> arc] can only rename a chapter notebook."; 
beginChapter::direxists = 
   "Cannot rename chapter because the target chapter directory already exists: `1`."; 
beginChapter::nostate = 
   "No state is loaded, and no current chapter state file exists to load."; 
renameCurrentChapterArc[newArc_String] := Module[{oldBase, data, storyDir, oldDir, 
     normalizedArc, newData, newBase, newDir, oldNotebookFile, newNotebookPath, 
     oldStatePath, newStatePath, movedOldNotebookPath, movedOldStatePath, oldArc, 
     oldArcStart}, If[ !chapterNotebookQ[], Message[beginChapter::notchapter]; 
       Return[$Failed]]; oldBase = currentNotebookBase[]; data = parseNotebookBase[oldBase]; 
     oldArc = data["Arc"]; oldArcStart = data["ArcChapterNumber"]; 
     If[data === $Failed, Return[$Failed]]; storyDir = parentNotebookDirectory[]; 
     oldDir = currentNotebookDirectory[]; If[storyDir === $Failed || oldDir === $Failed, 
      Return[$Failed]]; normalizedArc = normalizeName[newArc]; 
     newData = Join[data, Association["Arc" -> normalizedArc, "ArcChapterNumber" -> 1]]; 
     newBase = makeNotebookBase[newData]; If[newBase === oldBase, 
      registerChapterOverride[storyDir, data["ChapterNumber"], normalizedArc, 1, newArc]; 
       $state["seed"] = chapterSeedFromBase[newBase]; seedChapter[]; 
       updateCurrentChapterHeading[newArc]; If[propagateArcRename[storyDir, oldArc, 
          oldArcStart, normalizedArc, data["ChapterNumber"], newArc] === $Failed, 
        Return[$Failed]]; Return[Association["OldNotebookBase" -> oldBase, 
         "NewNotebookBase" -> newBase, "AlreadyInArc" -> True]]]; 
     newDir = FileNameJoin[{storyDir, newBase}]; If[DirectoryQ[newDir], 
      Message[beginChapter::direxists, newDir]; Return[$Failed]]; 
     oldNotebookFile = NotebookFileName[]; oldStatePath = currentStatePath[]; 
     If[oldNotebookFile === $Failed || oldStatePath === $Failed, Return[$Failed]]; 
     If[ !AssociationQ[$state], If[FileExistsQ[oldStatePath], 
       If[loadStateFromPath[oldStatePath] === $Failed, Return[$Failed]], 
       Message[beginChapter::nostate]; Return[$Failed]]]; 
     NotebookSave[currentNotebookObject[]]; RenameDirectory[oldDir, newDir]; 
     newNotebookPath = FileNameJoin[{newDir, StringJoin[newBase, ".nb"]}]; 
     newStatePath = FileNameJoin[{newDir, StringJoin[newBase, "-state.wxf"]}]; 
     movedOldNotebookPath = FileNameJoin[{newDir, FileNameTake[oldNotebookFile]}]; 
     movedOldStatePath = FileNameJoin[{newDir, FileNameTake[oldStatePath]}]; 
     NotebookSave[currentNotebookObject[], newNotebookPath]; 
     If[FileExistsQ[movedOldNotebookPath] &&  !samePathQ[movedOldNotebookPath, 
         newNotebookPath], DeleteFile[movedOldNotebookPath]]; 
     $state["seed"] = chapterSeedFromBase[newBase]; seedChapter[]; 
     If[saveExpressionToPath[newStatePath, $state] === $Failed, Return[$Failed]]; 
     If[FileExistsQ[movedOldStatePath] &&  !samePathQ[movedOldStatePath, newStatePath], 
      DeleteFile[movedOldStatePath]]; registerChapterOverride[storyDir, 
      data["ChapterNumber"], normalizedArc, 1, newArc]; updateCurrentChapterHeading[newArc]; 
     If[propagateArcRename[storyDir, oldArc, oldArcStart, normalizedArc, 
        data["ChapterNumber"], newArc] === $Failed, Return[$Failed]]; 
     Association["OldNotebookBase" -> oldBase, "NewNotebookBase" -> newBase, 
      "NotebookPath" -> newNotebookPath, "StatePath" -> newStatePath, 
      "AlreadyInArc" -> False]]; 
beginStory::notfirstchapter = 
   "beginStory[name] can only rename an already-started story from chapter 1."; 
beginStory::storydirexists = 
   "Cannot rename story because the target story directory already exists: `1`."; 
renameCurrentStory[storyName_String] := Module[{oldBase, data, oldStoryDir, storyRoot, 
     oldChapterDir, story, arc, newBase, newStoryDir, movedOldChapterDir, newChapterDir, 
     oldNotebookFile, movedOldNotebookPath, newNotebookPath, oldStatePath, 
     movedOldStatePath, newStatePath}, If[ !chapterNotebookQ[], Return[$Failed]]; 
     oldBase = currentNotebookBase[]; data = parseNotebookBase[oldBase]; 
     If[data === $Failed, Return[$Failed]]; If[data["ChapterNumber"] =!= 1, 
      Message[beginStory::notfirstchapter]; Return[$Failed]]; 
     oldStoryDir = parentNotebookDirectory[]; oldChapterDir = currentNotebookDirectory[]; 
     If[oldStoryDir === $Failed || oldChapterDir === $Failed, Return[$Failed]]; 
     storyRoot = DirectoryName[oldStoryDir]; story = normalizeName[storyName]; 
     arc = data["Arc"]; newBase = makeNotebookBase[Join[data, Association["Story" -> story, 
         "Arc" -> arc]]]; newStoryDir = FileNameJoin[{storyRoot, story}]; 
     newChapterDir = FileNameJoin[{newStoryDir, newBase}]; 
     oldNotebookFile = NotebookFileName[]; If[oldNotebookFile === $Failed, Return[$Failed]]; 
     oldStatePath = currentStatePath[]; If[newBase === oldBase && 
       samePathQ[newStoryDir, oldStoryDir], 
      If[AssociationQ[$state] && KeyExistsQ[$state, "seed"], 
        $state["seed"] = chapterSeedFromBase[newBase]; seedChapter[]; ]; 
       ensureChapterOneBoilerplate[]; If[propagateStoryRename[oldStoryDir, data["Story"], 
          story] === $Failed, Return[$Failed]]; 
       Return[Association["NotebookPath" -> oldNotebookFile, "StoryDirectory" -> 
          oldStoryDir, "AlreadyBegun" -> True, "Renamed" -> False]]]; 
     If[DirectoryQ[newStoryDir] &&  !samePathQ[newStoryDir, oldStoryDir], 
      Message[beginStory::storydirexists, newStoryDir]; Return[$Failed]]; 
     NotebookSave[currentNotebookObject[]]; If[ !samePathQ[newStoryDir, oldStoryDir], 
      RenameDirectory[oldStoryDir, newStoryDir]; movedOldChapterDir = 
        FileNameJoin[{newStoryDir, FileNameTake[oldChapterDir]}], 
      movedOldChapterDir = oldChapterDir]; 
     If[ !samePathQ[newChapterDir, movedOldChapterDir], 
      If[DirectoryQ[newChapterDir], Message[beginStory::direxists, newChapterDir]; 
         Return[$Failed]]; RenameDirectory[movedOldChapterDir, newChapterDir]; ]; 
     newNotebookPath = FileNameJoin[{newChapterDir, StringJoin[newBase, ".nb"]}]; 
     movedOldNotebookPath = FileNameJoin[{newChapterDir, FileNameTake[oldNotebookFile]}]; 
     NotebookSave[currentNotebookObject[], newNotebookPath]; 
     If[FileExistsQ[movedOldNotebookPath] &&  !samePathQ[movedOldNotebookPath, 
         newNotebookPath], DeleteFile[movedOldNotebookPath]]; 
     If[oldStatePath =!= $Failed, movedOldStatePath = FileNameJoin[
         {newChapterDir, FileNameTake[oldStatePath]}]; newStatePath = 
        FileNameJoin[{newChapterDir, StringJoin[newBase, "-state.wxf"]}]; 
       If[FileExistsQ[movedOldStatePath] &&  !samePathQ[movedOldStatePath, newStatePath], 
        RenameFile[movedOldStatePath, newStatePath]]; ]; 
     If[AssociationQ[$state] && KeyExistsQ[$state, "seed"], 
      $state["seed"] = chapterSeedFromBase[newBase]; seedChapter[]; ]; 
     ensureChapterOneBoilerplate[]; If[propagateStoryRename[newStoryDir, data["Story"], 
        story] === $Failed, Return[$Failed]]; Association["NotebookPath" -> newNotebookPath, 
      "StoryDirectory" -> newStoryDir, "OldNotebookBase" -> oldBase, 
      "NewNotebookBase" -> newBase, "AlreadyBegun" -> True, "Renamed" -> True]]; 
renameChapterDirectoryForStory[chapterDir_String, oldStory_String, newStory_String] := 
   Module[{oldBase, data, newBase, parent, newDir, movedOldNotebookPath, newNotebookPath, 
     movedOldStatePath, newStatePath}, oldBase = FileNameTake[chapterDir]; 
     data = Quiet[parseNotebookBase[oldBase], parseNotebookBase::badname]; 
     If[data === $Failed, Return[$Failed]]; If[data["Story"] =!= oldStory, 
      Return[chapterDir]]; newBase = makeNotebookBase[
       Join[data, Association["Story" -> newStory]]]; If[newBase === oldBase, 
      Return[chapterDir]]; parent = DirectoryName[chapterDir]; 
     newDir = FileNameJoin[{parent, newBase}]; If[DirectoryQ[newDir], 
      Message[beginStory::direxists, newDir]; Return[$Failed]]; 
     RenameDirectory[chapterDir, newDir]; movedOldNotebookPath = 
      FileNameJoin[{newDir, StringJoin[oldBase, ".nb"]}]; 
     newNotebookPath = FileNameJoin[{newDir, StringJoin[newBase, ".nb"]}]; 
     movedOldStatePath = FileNameJoin[{newDir, StringJoin[oldBase, "-state.wxf"]}]; 
     newStatePath = FileNameJoin[{newDir, StringJoin[newBase, "-state.wxf"]}]; 
     If[FileExistsQ[movedOldNotebookPath], If[FileExistsQ[newNotebookPath], 
       DeleteFile[movedOldNotebookPath], RenameFile[movedOldNotebookPath, 
        newNotebookPath]]]; If[FileExistsQ[movedOldStatePath], If[FileExistsQ[newStatePath], 
       DeleteFile[movedOldStatePath], RenameFile[movedOldStatePath, newStatePath]]]; 
     If[FileExistsQ[newNotebookPath], updateChapterNotebookHeading[newNotebookPath]]; 
     newDir]; 
propagateStoryRename[storyDir_String, oldStory_String, newStory_String] := 
   Module[{chapterDirs, results}, chapterDirs = Select[FileNames["*", storyDir], 
       DirectoryQ]; results = (renameChapterDirectoryForStory[#1, oldStory, newStory] & ) /@ 
       chapterDirs; If[MemberQ[results, $Failed], Return[$Failed]]; results]; 
renameChapterDirectoryForArc[chapterDir_String, oldArc_String, oldArcStart_Integer, 
    newArc_String, currentChapterNumber_Integer, arcTitle_String] := 
   Module[{oldBase, data, newArcChapterNumber, newBase, parent, newDir, 
     movedOldNotebookPath, newNotebookPath, movedOldStatePath, newStatePath, storyDir}, 
    oldBase = FileNameTake[chapterDir]; data = Quiet[parseNotebookBase[oldBase], 
       parseNotebookBase::badname]; If[data === $Failed, Return[$Failed]]; 
     If[data["ChapterNumber"] <= currentChapterNumber, Return[chapterDir]]; 
     If[data["Arc"] =!= oldArc, Return[chapterDir]]; 
     If[data["ArcChapterNumber"] < oldArcStart, Return[chapterDir]]; 
     newArcChapterNumber = data["ArcChapterNumber"] - oldArcStart + 1; 
     newBase = makeNotebookBase[Join[data, Association["Arc" -> newArc, 
         "ArcChapterNumber" -> newArcChapterNumber]]]; If[newBase === oldBase, 
      Return[chapterDir]]; parent = DirectoryName[chapterDir]; storyDir = parent; 
     newDir = FileNameJoin[{parent, newBase}]; If[DirectoryQ[newDir], 
      Message[beginChapter::direxists, newDir]; Return[$Failed]]; 
     RenameDirectory[chapterDir, newDir]; movedOldNotebookPath = 
      FileNameJoin[{newDir, StringJoin[oldBase, ".nb"]}]; 
     newNotebookPath = FileNameJoin[{newDir, StringJoin[newBase, ".nb"]}]; 
     movedOldStatePath = FileNameJoin[{newDir, StringJoin[oldBase, "-state.wxf"]}]; 
     newStatePath = FileNameJoin[{newDir, StringJoin[newBase, "-state.wxf"]}]; 
     If[FileExistsQ[movedOldNotebookPath], If[FileExistsQ[newNotebookPath], 
       DeleteFile[movedOldNotebookPath], RenameFile[movedOldNotebookPath, 
        newNotebookPath]]]; If[FileExistsQ[movedOldStatePath], If[FileExistsQ[newStatePath], 
       DeleteFile[movedOldStatePath], RenameFile[movedOldStatePath, newStatePath]]]; 
     registerChapterOverride[storyDir, data["ChapterNumber"], newArc, newArcChapterNumber, 
      arcTitle]; If[FileExistsQ[newNotebookPath], updateChapterNotebookHeading[
       newNotebookPath]]; newDir]; 
propagateArcRename[storyDir_String, oldArc_String, oldArcStart_Integer, newArc_String, 
    currentChapterNumber_Integer, arcTitle_String] := Module[{chapterDirs, results}, 
    chapterDirs = Select[FileNames["*", storyDir], DirectoryQ]; 
     results = (renameChapterDirectoryForArc[#1, oldArc, oldArcStart, newArc, 
         currentChapterNumber, arcTitle] & ) /@ chapterDirs; If[MemberQ[results, $Failed], 
      Return[$Failed]]; results]; 


(* ::Subsubsection:: *)
(*Chapter seeding*)


chapterSeedFromBase[base_String] := Abs[Hash[{"IronLibrary", "chapter-seed", base}]]; 
seedChapter[] := Module[{seed}, If[ !AssociationQ[$state] ||  !KeyExistsQ[$state, "seed"], 
      Message[seedChapter::noseed]; Return[$Failed]]; seed = $state["seed"]; 
     SeedRandom[seed]; seed]; 
seedChapter::noseed = "The current state does not contain a seed."; 
nextChapterSeed[] := Module[{base}, base = nextNotebookBase[]; 
     If[base === $Failed, Return[$Failed]]; chapterSeedFromBase[base]];
stateForNextChapter[] := Module[{next, seed}, seed = nextChapterSeed[]; 
     If[seed === $Failed, Return[$Failed]]; next = Association[$state]; next["seed"] = seed; 
     next];


(* ::Subsection:: *)
(*Interface implementation*)


(* ::Subsubsection:: *)
(*Bookkeeping*)


resetIronSession[] := (Clear[$state, $soloCharacter]; ); 
beginStory[] := beginStory[Automatic]; 
beginStory[name_] := Module[{root, storyName, story, arc, base, storyDir, chapterDir, 
     notebookPath, oldNotebookFile}, 
    If[chapterNotebookQ[], storyName = Replace[name, Automatic :> storyNameFromSoloCharacter[
           ]]; If[storyName === $Failed, Return[$Failed]]; If[ !StringQ[storyName], 
        Message[beginStory::badname, storyName]; Return[$Failed]]; 
       Return[renameCurrentStory[storyName]]]; root = storyRootDirectory[]; 
     If[root === $Failed, Return[$Failed]]; storyName = 
      Replace[name, Automatic :> storyNameFromSoloCharacter[]]; 
     If[storyName === $Failed, Return[$Failed]]; If[ !StringQ[storyName], 
      Message[beginStory::badname, storyName]; Return[$Failed]]; 
     story = normalizeName[storyName]; arc = normalizeName["Introduction"]; 
     storyDir = FileNameJoin[{root, story}]; If[ !DirectoryQ[storyDir], 
      CreateDirectory[storyDir, CreateIntermediateDirectories -> True]]; 
     base = makeNotebookBase[Association["Story" -> story, "ChapterNumber" -> 1, 
        "Arc" -> arc, "ArcChapterNumber" -> 1]]; 
     chapterDir = FileNameJoin[{storyDir, base}]; If[DirectoryQ[chapterDir], 
      Message[beginStory::direxists, chapterDir]; Return[$Failed]]; 
     CreateDirectory[chapterDir, CreateIntermediateDirectories -> True]; 
     notebookPath = FileNameJoin[{chapterDir, StringJoin[base, ".nb"]}]; 
     oldNotebookFile = NotebookFileName[]; If[oldNotebookFile === $Failed, 
      Message[currentNotebookBase::unsaved]; Return[$Failed]]; 
     NotebookSave[currentNotebookObject[], notebookPath]; 
     If[FileExistsQ[oldNotebookFile] && oldNotebookFile =!= notebookPath, 
      DeleteFile[oldNotebookFile]]; If[AssociationQ[$state] && KeyExistsQ[$state, "seed"], 
      $state["seed"] = chapterSeedFromBase[base]; seedChapter[]; ]; 
     ensureChapterOneBoilerplate[]; Association["NotebookPath" -> notebookPath, 
      "StoryDirectory" -> storyDir, "AlreadyBegun" -> False]]; 
beginStory::badname = "Story name `1` is not a string."; 
beginStory::direxists = 
   "Cannot begin story because the target chapter directory already exists: `1`."; 
beginStory::direxists = 
   "Cannot begin story because the target chapter directory already exists: `1`."; 
Options[beginChapter] = {ArcName -> Automatic}; 
beginChapter[OptionsPattern[]] := Module[{path, loaded, arcName, renamed}, 
    Clear[$state, $soloCharacter]; path = currentStatePath[]; 
     If[path === $Failed, Return[$Failed]]; loaded = loadStateFromPath[path]; 
     If[loaded === $Failed, Return[$Failed]]; If[seedChapter[] === $Failed, 
      Return[$Failed]]; arcName = OptionValue[ArcName]; If[arcName =!= Automatic, 
      If[ !StringQ[arcName], Message[beginChapter::badarc, arcName]; Return[$Failed]]; 
       renamed = renameCurrentChapterArc[arcName]; If[renamed === $Failed, 
        Return[$Failed]]; ]; $state]; 
beginChapter::badarc = "ArcName must be Automatic or a string, not `1`."; 
endChapter[] := Module[{statePath, notebookPath}, statePath = nextStatePath[]; 
     notebookPath = nextNotebookPath[]; If[statePath === $Failed || 
       notebookPath === $Failed, Return[$Failed]]; 
     If[saveExpressionToPath[statePath, stateForNextChapter[]] === $Failed, 
      Return[$Failed]]; createChapterNotebook[notebookPath]; 
     Association["StatePath" -> statePath, "NotebookPath" -> notebookPath]]; 


(* ::Subsubsection:: *)
(*Character management*)


createCharacter[Name -> name_String, Assets -> assets:{_String, _String, _String}, 
    Edge -> (edge_)?statValueQ, Heart -> (heart_)?statValueQ, Iron -> (iron_)?statValueQ, 
    Shadow -> (shadow_)?statValueQ, Wits -> (wits_)?statValueQ, 
    BackgroundVow -> {vowName_String, vowDescription_String, (vowRank_)?rankQ}, 
    Bonds -> bonds:{___String} /; Length[bonds] <= 3] := (ensureStateInitialized[]; 
    $state[name] = Association["assets" -> assets, "edge" -> edge, "heart" -> heart, 
      "iron" -> iron, "shadow" -> shadow, "wits" -> wits, "health" -> 5, "spirit" -> 5, 
      "supply" -> 5, "momentum" -> 2, "debilities" -> {}, 
      "vows" -> Association[vowName -> constructProgressTrack[vowDescription, vowRank]], 
      "bonds" -> bonds, "earnedExperience" -> 0, "spentExperience" -> 0]; 
    $soloCharacter = name;
    $state[name])


(* ::Subsubsection:: *)
(*Action roll*)


Options[actionRoll] = {Adds -> Association[]}; 
actionRoll[(stat_)?statQ, character_:$soloCharacter, opts:OptionsPattern[]] := 
   Module[{actionDie, statValue, adds, actionScore, challengeDice, cd1, cd2}, 
    actionDie = rollActionDie[]; 
     statValue = $state[character, symString[stat]];
     adds = OptionValue[Adds]; 
     actionScore = Min[actionDie + Total[Values[adds]] + statValue, 10]; 
     challengeDice = {cd1, cd2} = rollChallengeDice[]; 
     Association["character" -> character, "actionDie" -> actionDie, "stat" -> stat, 
      "statValue" -> statValue, "adds" -> adds, "actionScore" -> actionScore, 
      "challengeDice" -> challengeDice, "match" -> cd1 == cd2, 
      "result" -> actionRollResult[challengeDice, actionScore]]]; 


(* ::Subsection:: *)
(*Private context footer*)


End[];


(* ::Section:: *)
(*Package footer*)


EndPackage[];
