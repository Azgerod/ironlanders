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


(* ::Section::Closed:: *)
(*Package header*)


BeginPackage["IronLibrary`"];


(* ::Section::Closed:: *)
(*Public interface*)


(* ::Text:: *)
(*The following functions are exposed to the user.*)


(* ::Subsection::Closed:: *)
(*State management*)


resetIronSession::usage = 
"resetIronSession[] clears the current in-memory IronLibrary state and solo character.";

beginStory::usage = 
"beginStory[] starts a new story using the solo character as the story name.
beginStory[name] starts a new story using name as the story name.";

beginChapter::usage =
"beginChapter[] loads the state for the current chapter and seeds the random number generator.
beginChapter[ArcName -> arc] renames the current chapter as the first chapter of arc after loading its state.";

endChapter::usage =
"endChapter[] saves the state for the next chapter and creates the next chapter notebook.";


(* ::Subsection::Closed:: *)
(*Character management*)


setSoloCharacter::usage =
"setSoloCharacter[character] sets the solo character to character.";

createCharacter::usage =
"createCharacter[Name -> name, Assets -> {a1, a2, a3}, Edge -> edge, Heart -> heart, Iron -> iron, Shadow -> shadow, Wits -> wits, BackgroundVow -> {vowName, vowRank}, Bonds -> {b1, b2, b3}] creates a character and sets it as the solo character.";


(* ::Subsection::Closed:: *)
(*Action roll*)


actionRoll::usage =
"actionRoll[stat] makes an action roll using stat for the solo character.
actionRoll[stat, character] makes an action roll using stat for character.";


(* ::Subsection::Closed:: *)
(*Burn momentum*)


burnMomentum::usage =
"burnMomentum[roll] burns momentum for roll and returns the modified roll result.";


(* ::Subsection::Closed:: *)
(*Progress roll*)


progressRoll::usage =
"progressRoll[track] makes a progress roll against track for the solo character.
progressRoll[track, character] makes a progress roll against track for character.";


(* ::Subsection::Closed:: *)
(*Marking progress*)


markProgress::usage =
"markProgress[track, n] marks n progress units on track for the solo character.
markProgress[track, n, character] marks n progress units on track for character.";


(* ::Subsection::Closed:: *)
(*Suffering and taking*)


sufferMomentum::usage =
"sufferMomentum[n] adjusts the solo character's momentum by n.
sufferMomentum[n, character] adjusts character's momentum by n.";

takeMomentum::usage =
"takeMomentum[n] adjusts the solo character's momentum by n.
takeMomentum[n, character] adjusts character's momentum by n.";

sufferHealth::usage =
"sufferHealth[n] adjusts the solo character's health by n.
sufferHealth[n, character] adjusts character's health by n.";

takeHealth::usage =
"takeHealth[n] adjusts the solo character's health by n.
takeHealth[n, character] adjusts character's health by n.";

sufferSpirit::usage =
"sufferSpirit[n] adjusts the solo character's spirit by n.
sufferSpirit[n, character] adjusts character's spirit by n.";

takeSpirit::usage =
"takeSpirit[n] adjusts the solo character's spirit by n.
takeSpirit[n, character] adjusts character's spirit by n.";

sufferSupply::usage =
"sufferSupply[n] adjusts the solo character's supply by n.
sufferSupply[n, character] adjusts character's supply by n.";

takeSupply::usage =
"takeSupply[n] adjusts the solo character's supply by n.
takeSupply[n, character] adjusts character's supply by n.";


(* ::Subsection::Closed:: *)
(*Adding bonds*)


addBond::usage =
"addBond[bond] adds bond to the solo character and marks progress on the bonds track.
addBond[bond, character] adds bond to character and marks progress on the bonds track.";


(* ::Subsection::Closed:: *)
(*Adding/removing progress tracks*)


addProgressTrack::usage =
"addProgressTrack[track, rank] adds a progress track with name track and the given rank to the solo character.
addProgressTrack[track, rank, character] adds a progress track with name track and the given rank to the given character.";

removeProgressTrack::usage = 
"removeProgressTrack[track] removes the given progress track from the solo character.
removeProgressTrack[track, character] removes the given progress track from the given character.";


(* ::Subsection::Closed:: *)
(*Mark/spend experience*)


markExperience::usage =
"markExperience[n] adds n earned experience to the solo character.
markExperience[n, character] adds n earned experience to character.";

spendExperience::usage =
"spendExperience[n] adds n spent experience to the solo character.
spendExperience[n, character] adds n spent experience to character.";


(* ::Subsection::Closed:: *)
(*Moves*)


(* ::Subsubsection::Closed:: *)
(*Adventure moves*)


faceDanger::usage =
"faceDanger[] displays the Face Danger move header.
faceDanger[actionRoll] displays the Face Danger outcome corresponding to actionRoll.";

secureAnAdvantage::usage =
"secureAnAdvantage[] displays the Secure an Advantage move header.
secureAnAdvantage[actionRoll] displays the Secure an Advantage outcome corresponding to actionRoll.";

gatherInformation::usage =
"gatherInformation[] displays the Gather Information move header.
gatherInformation[actionRoll] displays the Gather Information outcome corresponding to actionRoll.";

makeCamp::usage =
"makeCamp[] displays the Make Camp move header.
makeCamp[actionRoll] displays the Make Camp outcome corresponding to actionRoll.";

heal::usage =
"heal[] displays the Heal move header.
heal[actionRoll] displays the Heal outcome corresponding to actionRoll.";

resupply::usage =
"resupply[] displays the Resupply move header.
resupply[actionRoll] displays the Resupply outcome corresponding to actionRoll.";

checkYourGear::usage =
"checkYourGear[] displays the Check Your Gear move header.
checkYourGear[actionRoll] displays the Check Your Gear outcome corresponding to actionRoll.";


(* ::Subsubsection::Closed:: *)
(*Journey moves*)


undertakeAJourney::usage =
"undertakeAJourney[] displays the Undertake a Journey move header.
undertakeAJourney[actionRoll] displays the Undertake a Journey outcome corresponding to actionRoll.";

reachYourDestination::usage =
"reachYourDestination[] displays the Reach Your Destination move header.
reachYourDestination[progressRoll] displays the Reach Your Destination outcome corresponding to progressRoll.";

followAPath::usage =
"followAPath[] displays the Follow a Path move header.
followAPath[actionRoll] displays the Follow a Path outcome corresponding to actionRoll.";


(* ::Subsubsection::Closed:: *)
(*Scene challenge moves*)


beginTheScene::usage =
"beginTheScene[] displays the Begin the Scene move header.";

faceDangerScene::usage =
"faceDangerScene[] displays the scene challenge version of the Face Danger move header.
faceDangerScene[actionRoll] displays the scene challenge Face Danger outcome corresponding to actionRoll.";

secureAnAdvantageScene::usage =
"secureAnAdvantageScene[] displays the scene challenge version of the Secure an Advantage move header.
secureAnAdvantageScene[actionRoll] displays the scene challenge Secure an Advantage outcome corresponding to actionRoll.";

finishTheScene::usage =
"finishTheScene[] displays the Finish the Scene move header.
finishTheScene[progressRoll] displays the Finish the Scene outcome corresponding to progressRoll.";


(* ::Subsubsection::Closed:: *)
(*Quest moves*)


swearAnIronVow::usage =
"swearAnIronVow[] displays the Swear an Iron Vow move header.
swearAnIronVow[actionRoll] displays the Swear an Iron Vow outcome corresponding to actionRoll.";

reachAMilestone::usage =
"reachAMilestone[] displays the Reach a Milestone move header.";

fulfillYourVow::usage =
"fulfillYourVow[] displays the Fulfill Your Vow move header.
fulfillYourVow[progressRoll] displays the Fulfill Your Vow outcome corresponding to progressRoll.";

forsakeYourVow::usage =
"forsakeYourVow[] displays the Forsake Your Vow move header.";

advance::usage =
"advance[] displays the Advance move header.";


(* ::Subsubsection::Closed:: *)
(*Fate moves*)


payThePrice::usage =
"payThePrice[] displays the Pay the Price move header.";

askTheOracle::usage =
"askTheOracle[] displays the Ask the Oracle move header.
askTheOracle[table] rolls on the oracle table table.
askTheOracle[\"Yes/No\", odds] rolls on the Yes/No oracle using odds.
askTheOracle[\"Yes/No\", yesOutcome, noOutcome] rolls on a 50/50 Yes/No oracle with the specified yes and no outcomes.
askTheOracle[\"Reveal a Danger\"] rolls on the alternate Reveal a Danger oracle.
askTheOracle[\"Reveal a Danger\", theme, domain] rolls on the Reveal a Danger oracle for theme and domain.
askTheOracle[\"Delve Site Feature\", theme, domain] rolls on the Delve Site Feature oracle for theme and domain.";


(* ::Subsubsection::Closed:: *)
(*Relationship moves*)


compel::usage =
"compel[] displays the Compel move header.
compel[actionRoll] displays the Compel outcome corresponding to actionRoll.";

aidYourAlly::usage =
"aidYourAlly[] displays the Aid Your Ally move header.";

sojourn::usage = 
"sojourn[] displays the Sojourn move header.
sojourn[actionRoll] displays the Sojourn outcome corresponding to actionRoll.";

sojournFocus::usage = 
"sojournFocus[] displays the Sojourn Focus move header.
sojournFocus[actionRoll] displays the Sojourn Focus outcome corresponding to actionRoll.";

forgeABond::usage =
"forgeABond[] displays the Forge a Bond move header.
forgeABond[actionRoll] displays the Forge a Bond outcome corresponding to actionRoll.";

testYourBond::usage =
"testYourBond[] displays the Test Your Bond move header.
testYourBond[actionRoll] displays the Test Your Bond outcome corresponding to actionRoll.";

drawTheCircle::usage =
"drawTheCircle[] displays the Draw the Circle move header.
drawTheCircle[actionRoll] displays the Draw the Circle outcome corresponding to actionRoll.";

writeYourEpilogue::usage =
"writeYourEpilogue[] displays the Write Your Epilogue move header.
writeYourEpilogue[progressRoll] displays the Write Your Epilogue outcome corresponding to progressRoll.";


(* ::Subsubsection::Closed:: *)
(*Combat moves*)


enterTheFray::usage =
"enterTheFray[] displays the Enter the Fray move header.
enterTheFray[actionRoll] displays the Enter the Fray outcome corresponding to actionRoll.";

strike::usage =
"strike[] displays the Strike move header.
strike[actionRoll] displays the Strike outcome corresponding to actionRoll.";

clash::usage =
"clash[] displays the Clash move header.
clash[actionRoll] displays the Clash outcome corresponding to actionRoll.";

turnTheTide::usage =
"turnTheTide[] displays the Turn the Tide move header.";

battle::usage =
"battle[] displays the Battle move header.
battle[actionRoll] displays the Battle outcome corresponding to actionRoll.";

endTheFight::usage =
"endTheFight[] displays the End the Fight move header.
endTheFight[progressRoll] displays the End the Fight outcome corresponding to progressRoll.
endTheFight[progressRoll, Initiative -> initiative] displays the End the Fight outcome with a worse outcome if initiative is False.";


(* ::Subsubsection::Closed:: *)
(*Suffer moves*)


endureHarm::usage =
"endureHarm[] displays the Endure Harm move header.
endureHarm[actionRoll] displays the Endure Harm outcome corresponding to actionRoll.";

faceDeath::usage =
"faceDeath[] displays the Face Death move header.
faceDeath[actionRoll] displays the Face Death outcome corresponding to actionRoll.";

companionEndureHarm::usage =
"companionEndureHarm[] displays the Companion Endure Harm move header.
companionEndureHarm[actionRoll] displays the Companion Endure Harm outcome corresponding to actionRoll.";

endureStress::usage =
"endureStress[] displays the Endure Stress move header.
endureStress[actionRoll] displays the Endure Stress outcome corresponding to actionRoll.";

faceDesolation::usage =
"faceDesolation[] displays the Face Desolation move header.
faceDesolation[actionRoll] displays the Face Desolation outcome corresponding to actionRoll.";

outOfSupply::usage =
"outOfSupply[] displays the Out of Supply move header.";

faceASetback::usage =
"faceASetback[] displays the Face a Setback move header.";


(* ::Subsubsection::Closed:: *)
(*Delve moves*)


discoverASite::usage =
"discoverASite[] displays the Discover a Site move header.";

delveTheDepths::usage =
"delveTheDepths[] displays the Delve the Depths move header.
delveTheDepths[actionRoll] displays the Delve the Depths outcome corresponding to actionRoll.";

findAnOpportunity::usage =
"findAnOpportunity[] displays the Find an Opportunity move header.";

revealADanger::usage =
"revealADanger[] displays the Reveal a Danger move header.";

locateYourObjective::usage =
"locateYourObjective[] displays the Locate Your Objective move header.
locateYourObjective[progressRoll] displays the Locate Your Objective outcome corresponding to progressRoll.";

escapeTheDepths::usage =
"escapeTheDepths[] displays the Escape the Depths move header.
escapeTheDepths[actionRoll] displays the Escape the Depths outcome corresponding to actionRoll.";


(* ::Subsubsection::Closed:: *)
(*Failure moves*)


markYourFailure::usage =
"markYourFailure[] displays the Mark Your Failure move header.";

learnFromYourFailures::usage =
"learnFromYourFailures[] displays the Learn from Your Failures move header.
learnFromYourFailures[progressRoll] displays the Learn from Your Failures outcome corresponding to progressRoll.";


(* ::Subsubsection::Closed:: *)
(*Threat moves*)


advanceAThreat::usage =
"advanceAThreat[] displays the Advance a Threat move header.";

takeAHiatus::usage =
"takeAHiatus[] displays the Take a Hiatus move header.";


(* ::Subsubsection::Closed:: *)
(*Rarity moves*)


gainARarity::usage =
"gainARarity[] displays the Gain a Rarity move header.";

wieldARarity::usage =
"wieldARarity[] displays the Wield a Rarity move header.";


(* ::Subsection::Closed:: *)
(*Stats*)


Health::usage =
"Health is a stat.";

Spirit::usage =
"Spirit is a stat.";

Supply::usage =
"Supply is a stat";


(* ::Subsection::Closed:: *)
(*Option names*)


Name::usage =
"Name is an option for createCharacter that specifies the character name.";

Edge::usage =
"Edge is one of the five Ironsworn stats and an option for createCharacter.";

Heart::usage =
"Heart is one of the five Ironsworn stats and an option for createCharacter.";

Iron::usage =
"Iron is one of the five Ironsworn stats and an option for createCharacter.";

Shadow::usage =
"Shadow is one of the five Ironsworn stats and an option for createCharacter.";

Wits::usage =
"Wits is one of the five Ironsworn stats and an option for createCharacter.";

Assets::usage =
"Assets is an option for createCharacter that specifies a list of three asset names.";

BackgroundVow::usage =
"BackgroundVow is an option for createCharacter that specifies the character's background vow.";

Bonds::usage =
"Bonds is an option for createCharacter that specifies the character's starting bonds.";

Adds::usage =
"Adds is an option for actionRoll that specifies an association of named bonuses.";

ArcName::usage =
"ArcName is an option for beginChapter that specifies the arc name to use for the current chapter.";

Initiative::usage =
"Initiative is a True/False option for endTheFight, which specifies whether the character has initiative.";


(* ::Subsection::Closed:: *)
(*Rank symbols*)


Troublesome::usage =
"Troublesome is a rank.";

Dangerous::usage =
"Dangerous is a rank.";

Formidable::usage =
"Formidable is a rank.";

Extreme::usage =
"Extreme is a rank.";

Epic::usage =
"Epic is a rank.";


(* ::Section::Closed:: *)
(*Private context header*)


Begin["`Private`"]; 


(* ::Section::Closed:: *)
(*Private helpers*)


(* ::Text:: *)
(*The following code implements the public interface above.*)


(* ::Subsection::Closed:: *)
(*Bookkeeping helpers*)


(* ::Subsubsection::Closed:: *)
(*Library path variable*)


If[ !ValueQ[$IronLibraryPath], $IronLibraryPath = If[StringQ[$InputFileName] && $InputFileName =!= "", $InputFileName, $Failed]]; 


(* ::Subsubsection::Closed:: *)
(*Library directory variable*)


ironLibraryDirectory[] := DirectoryName[$IronLibraryPath];


(* ::Subsubsection::Closed:: *)
(*Imports*)


Get[FileNameJoin[{ironLibraryDirectory[], "MoveData.wl"}]];
Get[FileNameJoin[{ironLibraryDirectory[], "OracleTables.wl"}]];


(* ::Subsubsection::Closed:: *)
(*Name normalization*)


normalizeName[s_String] := Module[{name}, name = ToLowerCase[StringTrim[s]]; name = StringReplace[name, {WhitespaceCharacter.. -> "_", "-" -> "_"}]; name = StringReplace[name, "_".. -> "_"]; 
     StringTrim[name, "_"]]; 


(* ::Subsubsection::Closed:: *)
(*State initialization*)


newState[] := newState[Automatic]; 
newState[seed_] := $state = Association["journey" -> Association[], "combats" -> Association[], "seed" -> Replace[seed, Automatic :> RandomInteger[{1, 2^31 - 1}]]]; 
ensureStateInitialized[] := Module[{base, seed}, If[AssociationQ[$state], Return[$state]]; base = currentNotebookBase[]; 
     seed = If[StringQ[base] && Quiet[parseNotebookBase[base] =!= $Failed, parseNotebookBase::badname], chapterSeedFromBase[base], Automatic]; newState[seed]; If[seed =!= Automatic, seedChapter[]]; 
     $state]; 


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


(* ::Subsubsection::Closed:: *)
(*Notebook creation*)


titleCaseName[s_String] := StringRiffle[Capitalize /@ StringSplit[StringReplace[StringTrim[s], {"_" -> " ", "-" -> " "}], WhitespaceCharacter..], " "]; 
romanNumeral[(n_Integer)?Positive] := RomanNumeral[n]; 
chapterTitleSubtitleFromPath[path_String] := Module[{base, data, storyDir, override, arcTitle, title, subtitle}, base = FileBaseName[path]; data = parseNotebookBase[base]; 
     If[data === $Failed, Return[$Failed]]; storyDir = DirectoryName[DirectoryName[path]]; override = chapterOverride[storyDir, data["ChapterNumber"]]; 
     arcTitle = If[AssociationQ[override] && KeyExistsQ[override, "ArcTitle"], override["ArcTitle"], titleCaseName[data["Arc"]]]; 
     title = StringJoin[titleCaseName[data["Story"]], ": Chapter ", ToString[data["ChapterNumber"]]]; subtitle = StringJoin[arcTitle, ", part ", romanNumeral[data["ArcChapterNumber"]]]; 
     Association["Title" -> title, "Subtitle" -> subtitle]]; 
libraryGetCell[] := If[StringQ[$IronLibraryPath] && $IronLibraryPath =!= $Failed, With[{path = $IronLibraryPath}, Cell[BoxData[ToBoxes[Defer[Get[path]; ]]], "Input", CellTags -> "IronLibraryGet"]], 
    Cell["Load IronLibrary here.", "Text", CellTags -> "IronLibraryGet"]]; 
beginChapterCell[] := Cell[BoxData[ToBoxes[Defer[beginChapter[]; ]]], "Input", CellTags -> "IronLibraryBeginChapter"];
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
(*Header updates*)


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
(*Story name derivation*)


storyRootDirectory[] := Module[{dir}, dir = currentNotebookDirectory[]; If[dir === $Failed, Return[$Failed]]; dir]; 
storyNameFromRoot[] := Module[{root}, root = storyRootDirectory[]; If[root === $Failed, Return[$Failed]]; Last[FileNameSplit[root]]]; 
storyNameFromSoloCharacter[] := Module[{}, If[ValueQ[$soloCharacter] && StringQ[$soloCharacter], $soloCharacter, Message[beginStory::noname]; $Failed]]; 
beginStory::noname = "No story name was supplied, and $soloCharacter has not been set. Either call beginStory[name] or create a character first."; 


(* ::Subsubsection::Closed:: *)
(*Chapter notebook helper*)


chapterNotebookQ[] := Module[{base}, base = currentNotebookBase[]; If[ !StringQ[base], Return[False]]; Quiet[parseNotebookBase[base] =!= $Failed, parseNotebookBase::badname]]; 
beginChapter::notchapter = "beginChapter[ArcName -> arc] can only rename a chapter notebook."; 
beginChapter::direxists = "Cannot rename chapter because the target chapter directory already exists: `1`."; 
beginChapter::nostate = "No state is loaded, and no current chapter state file exists to load."; 
renameCurrentChapterArc[newArc_String] := Module[{oldBase, data, storyDir, oldDir, normalizedArc, newData, newBase, newDir, oldNotebookFile, newNotebookPath, oldStatePath, newStatePath, 
     movedOldNotebookPath, movedOldStatePath, oldArc, oldArcStart}, If[ !chapterNotebookQ[], Message[beginChapter::notchapter]; Return[$Failed]]; oldBase = currentNotebookBase[]; 
     data = parseNotebookBase[oldBase]; If[data === $Failed, Return[$Failed]]; oldArc = data["Arc"]; oldArcStart = data["ArcChapterNumber"]; storyDir = parentNotebookDirectory[]; 
     oldDir = currentNotebookDirectory[]; If[storyDir === $Failed || oldDir === $Failed, Return[$Failed]]; normalizedArc = normalizeName[newArc]; 
     newData = Join[data, Association["Arc" -> normalizedArc, "ArcChapterNumber" -> 1]]; newBase = makeNotebookBase[newData]; 
     If[newBase === oldBase, registerChapterOverride[storyDir, data["ChapterNumber"], normalizedArc, 1, newArc]; $state["seed"] = chapterSeedFromBase[newBase]; seedChapter[]; 
       updateCurrentChapterHeading[newArc]; If[propagateArcRename[storyDir, oldArc, oldArcStart, normalizedArc, data["ChapterNumber"], newArc] === $Failed, Return[$Failed]]; 
       Return[Association["OldNotebookBase" -> oldBase, "NewNotebookBase" -> newBase, "AlreadyInArc" -> True]]]; newDir = FileNameJoin[{storyDir, newBase}]; 
     If[DirectoryQ[newDir], Message[beginChapter::direxists, newDir]; Return[$Failed]]; oldNotebookFile = NotebookFileName[]; oldStatePath = currentStatePath[]; 
     If[oldNotebookFile === $Failed || oldStatePath === $Failed, Return[$Failed]]; If[ !AssociationQ[$state], If[FileExistsQ[oldStatePath], 
       If[loadStateFromPath[oldStatePath] === $Failed, Return[$Failed]], Message[beginChapter::nostate]; Return[$Failed]]]; NotebookSave[currentNotebookObject[]]; RenameDirectory[oldDir, newDir]; 
     newNotebookPath = FileNameJoin[{newDir, StringJoin[newBase, ".nb"]}]; newStatePath = FileNameJoin[{newDir, StringJoin[newBase, "-state.wxf"]}]; 
     movedOldNotebookPath = FileNameJoin[{newDir, FileNameTake[oldNotebookFile]}]; movedOldStatePath = FileNameJoin[{newDir, FileNameTake[oldStatePath]}]; 
     NotebookSave[currentNotebookObject[], newNotebookPath]; If[FileExistsQ[movedOldNotebookPath] &&  !samePathQ[movedOldNotebookPath, newNotebookPath], DeleteFile[movedOldNotebookPath]]; 
     $state["seed"] = chapterSeedFromBase[newBase]; seedChapter[]; If[saveExpressionToPath[newStatePath, $state] === $Failed, Return[$Failed]]; 
     If[FileExistsQ[movedOldStatePath] &&  !samePathQ[movedOldStatePath, newStatePath], DeleteFile[movedOldStatePath]]; registerChapterOverride[storyDir, data["ChapterNumber"], normalizedArc, 1, newArc]; 
     updateCurrentChapterHeading[newArc]; If[propagateArcRename[storyDir, oldArc, oldArcStart, normalizedArc, data["ChapterNumber"], newArc] === $Failed, Return[$Failed]]; 
     Association["OldNotebookBase" -> oldBase, "NewNotebookBase" -> newBase, "NotebookPath" -> newNotebookPath, "StatePath" -> newStatePath, "AlreadyInArc" -> False]]; 
beginStory::notfirstchapter = "beginStory[name] can only rename an already-started story from chapter 1."; 
beginStory::storydirexists = "Cannot rename story because the target story directory already exists: `1`."; 
renameCurrentStory[storyName_String] := Module[{oldBase, data, oldStoryDir, storyRoot, oldChapterDir, story, arc, newBase, newStoryDir, movedOldChapterDir, newChapterDir, oldNotebookFile, 
     movedOldNotebookPath, newNotebookPath, oldStatePath, movedOldStatePath, newStatePath}, If[ !chapterNotebookQ[], Return[$Failed]]; oldBase = currentNotebookBase[]; data = parseNotebookBase[oldBase]; 
     If[data === $Failed, Return[$Failed]]; If[data["ChapterNumber"] =!= 1, Message[beginStory::notfirstchapter]; Return[$Failed]]; oldStoryDir = parentNotebookDirectory[]; 
     oldChapterDir = currentNotebookDirectory[]; If[oldStoryDir === $Failed || oldChapterDir === $Failed, Return[$Failed]]; storyRoot = DirectoryName[oldStoryDir]; story = normalizeName[storyName]; 
     arc = data["Arc"]; newBase = makeNotebookBase[Join[data, Association["Story" -> story, "Arc" -> arc]]]; newStoryDir = FileNameJoin[{storyRoot, story}]; 
     newChapterDir = FileNameJoin[{newStoryDir, newBase}]; oldNotebookFile = NotebookFileName[]; If[oldNotebookFile === $Failed, Return[$Failed]]; oldStatePath = currentStatePath[]; 
     If[newBase === oldBase && samePathQ[newStoryDir, oldStoryDir], If[AssociationQ[$state] && KeyExistsQ[$state, "seed"], $state["seed"] = chapterSeedFromBase[newBase]; seedChapter[]; ]; 
       ensureChapterOneBoilerplate[]; If[propagateStoryRename[oldStoryDir, data["Story"], story] === $Failed, Return[$Failed]]; 
       Return[Association["NotebookPath" -> oldNotebookFile, "StoryDirectory" -> oldStoryDir, "AlreadyBegun" -> True, "Renamed" -> False]]]; 
     If[DirectoryQ[newStoryDir] &&  !samePathQ[newStoryDir, oldStoryDir], Message[beginStory::storydirexists, newStoryDir]; Return[$Failed]]; NotebookSave[currentNotebookObject[]]; 
     If[ !samePathQ[newStoryDir, oldStoryDir], RenameDirectory[oldStoryDir, newStoryDir]; movedOldChapterDir = FileNameJoin[{newStoryDir, FileNameTake[oldChapterDir]}], 
      movedOldChapterDir = oldChapterDir]; If[ !samePathQ[newChapterDir, movedOldChapterDir], If[DirectoryQ[newChapterDir], Message[beginStory::direxists, newChapterDir]; Return[$Failed]]; 
       RenameDirectory[movedOldChapterDir, newChapterDir]; ]; newNotebookPath = FileNameJoin[{newChapterDir, StringJoin[newBase, ".nb"]}]; 
     movedOldNotebookPath = FileNameJoin[{newChapterDir, FileNameTake[oldNotebookFile]}]; NotebookSave[currentNotebookObject[], newNotebookPath]; 
     If[FileExistsQ[movedOldNotebookPath] &&  !samePathQ[movedOldNotebookPath, newNotebookPath], DeleteFile[movedOldNotebookPath]]; 
     If[oldStatePath =!= $Failed, movedOldStatePath = FileNameJoin[{newChapterDir, FileNameTake[oldStatePath]}]; newStatePath = FileNameJoin[{newChapterDir, StringJoin[newBase, "-state.wxf"]}]; 
       If[FileExistsQ[movedOldStatePath] &&  !samePathQ[movedOldStatePath, newStatePath], RenameFile[movedOldStatePath, newStatePath]]; ]; 
     If[AssociationQ[$state] && KeyExistsQ[$state, "seed"], $state["seed"] = chapterSeedFromBase[newBase]; seedChapter[]; ]; ensureChapterOneBoilerplate[]; 
     If[propagateStoryRename[newStoryDir, data["Story"], story] === $Failed, Return[$Failed]]; Association["NotebookPath" -> newNotebookPath, "StoryDirectory" -> newStoryDir, 
      "OldNotebookBase" -> oldBase, "NewNotebookBase" -> newBase, "AlreadyBegun" -> True, "Renamed" -> True]]; 
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


(* ::Subsubsection::Closed:: *)
(*Chapter seeding*)


chapterSeedFromBase[base_String] := Abs[Hash[{"IronLibrary", "chapter-seed", base}]]; 
seedChapter[] := Module[{seed}, If[ !AssociationQ[$state] ||  !KeyExistsQ[$state, "seed"], Message[seedChapter::noseed]; Return[$Failed]]; seed = $state["seed"]; SeedRandom[seed]; seed]; 
seedChapter::noseed = "The current state does not contain a seed."; 
nextChapterSeed[] := Module[{base}, base = nextNotebookBase[]; If[base === $Failed, Return[$Failed]]; chapterSeedFromBase[base]]; 
stateForNextChapter[] := Module[{next, seed}, seed = nextChapterSeed[]; If[seed === $Failed, Return[$Failed]]; next = Association[$state]; next["seed"] = seed; next]; 


(* ::Subsection::Closed:: *)
(*General mechanics helpers*)


(* ::Subsubsection::Closed:: *)
(*Rolling dice*)


rollChallengeDice[] := RandomInteger[{1, 10}, 2]; 
rollActionDie[] := RandomInteger[{1, 6}]; 
actionRollResult[challengeDice_List, actionScore_Integer] :=
	<|0 -> "miss", 1 -> "weakHit", 2 -> "strongHit"|>[
		Count[challengeDice, die_ /; actionScore > die]
	];
rollOracleDice = rollChallengeDice;
oracleRollValue[{tensDie_Integer, onesDie_Integer}]:=Module[{tensValue, onesValue},
	tensValue = If[tensDie==10, 0, tensDie*10];
	onesValue = If[onesDie==10, 0, onesDie];
	If[tensDie==onesDie==10, 100, tensValue+onesValue]
];
oracleRollOutcome[table_Association, value_Integer] := Module[{key},
	key = First[Select[Sort[Keys[table]], # >= value &]];
	table[key]
];



(* ::Subsubsection::Closed:: *)
(*Argument tests*)


statQ[input_] := MemberQ[stats, input]; 
rankQ[input_] := MemberQ[ranks, input]; 
statValueQ[input_Integer] := 1 <= input <= 5; 


(* ::Subsubsection::Closed:: *)
(*Progress tracks*)


progressTrack[(rank_)?rankQ, progress_:0] := 
   Association["rank" -> rank, "progress" -> progress];
progressRollResult = actionRollResult;


(* ::Subsubsection::Closed:: *)
(*Symbol to string conversion*)


symString[symbol_] := ToLowerCase[SymbolName[symbol]]; 


(* ::Subsubsection::Closed:: *)
(*Attribute Getters*)


getAttr[attr_String, character_:$soloCharacter] := $state[character, attr];
getAttr[attr_, character_:$soloCharacter] := getAttr[symString[attr], character];

getEdge[character_:$soloCharacter] := getAttr["edge", character];
getHeart[character_:$soloCharacter] := getAttr["heart", character];
getIron[character_:$soloCharacter] := getAttr["iron", character];
getShadow[character_:$soloCharacter] := getAttr["shadow", character];
getWits[character_:$soloCharacter] := getAttr["wits", character];

getDebilities[character_:$soloCharacter] := getAttr["debilities", character];

getMomentum[character_:$soloCharacter] := getAttr["momentum", character];
getMomentumReset[character_:$soloCharacter] := Max[0, 2 - Length[getDebilities[character]]];
getMomentumMax[character_:$soloCharacter] := 10 - Length[getDebilities[character]];

getHealth[character_:$soloCharacter] := getAttr["health", character];
getSpirit[character_:$soloCharacter] := getAttr["spirit", character];
getSupply[character_:$soloCharacter] := getAttr["supply", character];


(* ::Subsubsection::Closed:: *)
(*Attribute adjusters and setters*)


resetMomentum[character_:$soloCharacter] :=
	$state[character, "momentum"] = getMomentumReset[character];

adjustMomentum[n_Integer, character_ : $soloCharacter] :=
	$state[character, "momentum"] += n;

adjustHealth[n_Integer, character_ : $soloCharacter] :=
	$state[character, "health"] += n;

adjustSpirit[n_Integer, character_ : $soloCharacter] :=
	$state[character, "spirit"] += n;

adjustSupply[n_Integer, character_ : $soloCharacter] :=
	$state[character, "supply"] += n;


(* ::Subsubsection::Closed:: *)
(*Progress track getters*)


getProgress[trackName_String, character_:$soloCharacter] := $state[character, "progressTracks", trackName, "progress"];
getRank[trackName_String, character_:$soloCharacter] := $state[character, "progressTracks", trackName, "rank"];


(* ::Subsection::Closed:: *)
(*General presentation helpers*)


(* ::Subsubsection::Closed:: *)
(*Shared presentation constants*)


rollHeaderBodyGap = scaled[3];
rollBodyResultGap = scaled[3];
$ironDisplayScale = 0.8;


(* ::Subsubsection::Closed:: *)
(*Scaling*)


scaled[n_?NumericQ] := $ironDisplayScale n;

scaledSize[n_?NumericQ] := Round[scaled[n]];


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
(*Presentation preparation*)


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


(* ::Subsubsection::Closed:: *)
(*Display action roll*)


displayActionRoll[roll_Association] := Print[ironFramed[Grid[{{Item[header["Action Roll", Capitalize[symString[roll["stat"]]]], Alignment -> Left], SpanFromLeft}, 
       {mathColumn[roll["actionDie"], roll["statValue"], roll["adds"], roll["actionScore"], roll["actionDieCancelled"], roll["momentum"]], rollColumn[roll["actionScore"], roll["challengeDice"]]}, 
       {Item[actionRollResultDisplay[roll["result"], roll["match"]], Alignment -> Center], SpanFromLeft}}, Dividers -> {None, {False, False, False, False}}, Alignment -> {{Left, Center, Center}, {Top, Top, Bottom}}, 
      Spacings -> {2, {Automatic, rollHeaderBodyGap, rollBodyResultGap}}, FrameStyle -> None]]]; 


(* ::Subsubsection::Closed:: *)
(*Display momentum burn*)


displayMomentumBurn[burn_Association] := Print[ironFramed[Column[{Item[header["Momentum Burn", StringJoin[ToString[burn["momentum"]], " \[Rule] ", ToString[burn["momentumReset"]]]], Alignment -> Left], 
       Item[rollColumn[burn["actionScore"], burn["challengeDice"], burn["challengeDiceCancelled"]], Alignment -> Center], 
       Item[actionRollResultDisplay[burn["result"], If[AllTrue[burn["challengeDiceCancelled"],  !#1 & ], burn["match"], False]], Alignment -> Center]}, 
      Spacings -> {2, {Automatic, rollHeaderBodyGap, rollBodyResultGap}}]]]; 


(* ::Subsubsection::Closed:: *)
(*Display progress roll*)


displayProgressRoll[roll_Association] := Print[ironFramed[Grid[{{Item[header["Progress Roll", roll["trackName"]], Alignment -> Left]}, 
       {rollColumn[roll["progressScore"], roll["challengeDice"], {False, False}]}, {Item[actionRollResultDisplay[roll["result"], roll["match"]], Alignment -> Center]}}, 
      Alignment -> {{Center}, {Center, Top, Center}}, Spacings -> {2, {Automatic, rollHeaderBodyGap, rollBodyResultGap}}]]]; 


(* ::Subsubsection::Closed:: *)
(*Display oracle roll*)


displayOracleRoll[table_String, {d1_, d2_}, match_, outcome_String] := 
   Print[ironFramed[Grid[{{Item[header["Oracle Roll", table], Alignment -> Left], SpanFromLeft}, {Item[Grid[{{Item[d10Image[d1], Alignment -> Right], Item[d10Image[d2], Alignment -> Left]}}, 
          Alignment -> {{Right, Left}, Center}, Spacings -> {0, 0}], Alignment -> Center], SpanFromLeft}, {Item[Rotate[mainStyle["\[Rule]"], -(Pi/2)], Alignment -> Center], SpanFromLeft}, 
       {Item[mainStyle[StringJoin[outcome, If[match, " (MATCH)", ""]]], Alignment -> Center], SpanFromLeft}}, Alignment -> {{Center}, {Center, Top, Center}}, 
      Spacings -> {0, {Automatic, rollHeaderBodyGap, 1, 2}}]]]; 


(* ::Subsubsection::Closed:: *)
(*Oracle roll*)


oracleRoll[tableName_String, table_Association] := Module[{oracleDice, od1, od2, value, outcome, match},
	oracleDice = {od1, od2} = rollOracleDice[];
	value = oracleRollValue[oracleDice];
	outcome = oracleRollOutcome[table, value];
	match = (od1==od2);
	displayOracleRoll[tableName, oracleDice, match, outcome];
	<|"oracleDice" -> oracleDice, "value" -> value, "outcome" -> outcome, "match" -> match|>
];


(* ::Subsection::Closed:: *)
(*Move helpers*)


(* ::Subsubsection::Closed:: *)
(*Move outcome*)


moveOutcome[move_String, result_String] := moves[move, result];


(* ::Subsubsection::Closed:: *)
(*Move header presentation*)


displayMoveHeader[moveKey_String] :=
  Print[
    Framed[
      Column[{titleStyle[moves[moveKey, "name"]], moveTextStyle[moves[moveKey, "header"]]}, Spacings->1],
      FrameStyle -> rollFrameStyle,
      FrameMargins -> {{12, 12}, {12, 12}},
      RoundingRadius -> 8,
      Background -> None
    ]
  ];


(* ::Subsubsection::Closed:: *)
(*Move outcome presentation*)


displayMoveOutcome[moveKey_String, result_String] :=
  Print[
    Framed[
      Column[{header[moves[moveKey, "name"], Lookup[$outcomeLabels, result]], moveTextStyle[moves[moveKey, result]]}, Spacings->1],
      FrameStyle -> rollFrameStyle,
      FrameMargins -> {{12, 12}, {12, 12}},
      RoundingRadius -> 8,
      Background -> None
    ]
  ];


(* ::Subsubsection::Closed:: *)
(*Combined move display*)


displayMove[moveKey_String]:=displayMoveHeader[moveKey];
displayMove[moveKey_String, roll_Association]:=displayMoveOutcome[moveKey, roll["result"]];


(* ::Subsubsection::Closed:: *)
(*End the Fight transformer*)


endTheFightTransformer[roll_Association, initiative_] := Module[
  {map, transformed},
  map = {"strongHit" -> "weakHit", "weakHit" -> "miss", "miss" -> "miss"};
  transformed = Association[roll];
  If[! TrueQ[initiative],
    transformed["result"] = Replace[transformed["result"], map]
  ];
  transformed
];


(* ::Subsection::Closed:: *)
(*Constants*)


stats = {Edge, Heart, Iron, Shadow, Wits, Health, Spirit, Supply}; 
ranks = {Troublesome, Dangerous, Formidable, Extreme, Epic};


(* ::Section::Closed:: *)
(*General interface implementation*)


(* ::Subsection::Closed:: *)
(*Bookkeeping*)


resetIronSession[] := (Clear[$state, $soloCharacter]; ); 
beginStory[] := beginStory[Automatic]; 
beginStory[name_] := Module[{root, storyName, story, arc, base, storyDir, chapterDir, notebookPath, oldNotebookFile}, 
    If[chapterNotebookQ[], storyName = Replace[name, Automatic :> storyNameFromSoloCharacter[]]; If[storyName === $Failed, Return[$Failed]]; 
       If[ !StringQ[storyName], Message[beginStory::badname, storyName]; Return[$Failed]]; Return[renameCurrentStory[storyName]]]; root = storyRootDirectory[]; If[root === $Failed, Return[$Failed]]; 
     storyName = Replace[name, Automatic :> storyNameFromSoloCharacter[]]; If[storyName === $Failed, Return[$Failed]]; If[ !StringQ[storyName], Message[beginStory::badname, storyName]; Return[$Failed]]; 
     story = normalizeName[storyName]; arc = normalizeName["Introduction"]; storyDir = FileNameJoin[{root, story}]; 
     If[ !DirectoryQ[storyDir], CreateDirectory[storyDir, CreateIntermediateDirectories -> True]]; 
     base = makeNotebookBase[Association["Story" -> story, "ChapterNumber" -> 1, "Arc" -> arc, "ArcChapterNumber" -> 1]]; chapterDir = FileNameJoin[{storyDir, base}]; 
     If[DirectoryQ[chapterDir], Message[beginStory::direxists, chapterDir]; Return[$Failed]]; CreateDirectory[chapterDir, CreateIntermediateDirectories -> True]; 
     notebookPath = FileNameJoin[{chapterDir, StringJoin[base, ".nb"]}]; oldNotebookFile = NotebookFileName[]; If[oldNotebookFile === $Failed, Message[currentNotebookBase::unsaved]; Return[$Failed]]; 
     NotebookSave[currentNotebookObject[], notebookPath]; If[FileExistsQ[oldNotebookFile] && oldNotebookFile =!= notebookPath, DeleteFile[oldNotebookFile]]; 
     If[AssociationQ[$state] && KeyExistsQ[$state, "seed"], $state["seed"] = chapterSeedFromBase[base]; seedChapter[]; ]; ensureChapterOneBoilerplate[]; 
     Association["NotebookPath" -> notebookPath, "StoryDirectory" -> storyDir, "AlreadyBegun" -> False]]; 
beginStory::badname = "Story name `1` is not a string."; 
beginStory::direxists = "Cannot begin story because the target chapter directory already exists: `1`."; 
beginStory::direxists = "Cannot begin story because the target chapter directory already exists: `1`."; 
Options[beginChapter] = {ArcName -> Automatic}; 
beginChapter[OptionsPattern[]] := Module[{path, loaded, arcName, renamed}, Clear[$state, $soloCharacter]; path = currentStatePath[]; If[path === $Failed, Return[$Failed]]; 
     loaded = loadStateFromPath[path]; If[loaded === $Failed, Return[$Failed]]; If[seedChapter[] === $Failed, Return[$Failed]]; arcName = OptionValue[ArcName]; 
     If[arcName =!= Automatic, If[ !StringQ[arcName], Message[beginChapter::badarc, arcName]; Return[$Failed]]; renamed = renameCurrentChapterArc[arcName]; If[renamed === $Failed, Return[$Failed]]; ]; 
     $state]; 
beginChapter::badarc = "ArcName must be Automatic or a string, not `1`."; 
endChapter[] := Module[{statePath, notebookPath}, statePath = nextStatePath[]; notebookPath = nextNotebookPath[]; If[statePath === $Failed || notebookPath === $Failed, Return[$Failed]]; 
     If[saveExpressionToPath[statePath, stateForNextChapter[]] === $Failed, Return[$Failed]]; createChapterNotebook[notebookPath]; Association["StatePath" -> statePath, "NotebookPath" -> notebookPath]]; 


(* ::Subsection::Closed:: *)
(*Character management*)


createCharacter[Name -> name_String, Assets -> assets:{_String, _String, _String}, Edge -> (edge_)?statValueQ, Heart -> (heart_)?statValueQ, Iron -> (iron_)?statValueQ, Shadow -> (shadow_)?statValueQ, 
    Wits -> (wits_)?statValueQ, BackgroundVow -> {vowName_String, (vowRank_)?rankQ}, Bonds -> bonds:{___String} /; Length[bonds] <= 3] := 
   Module[{character}, ensureStateInitialized[]; character = Association["assets" -> assets, "edge" -> edge, "heart" -> heart, "iron" -> iron, "shadow" -> shadow, "wits" -> wits, "health" -> 5, 
       "spirit" -> 5, "supply" -> 5, "momentum" -> 2, "debilities" -> {}, "progressTracks" -> Association[vowName -> progressTrack[vowRank], "Bonds" -> progressTrack[Epic, 0.25*Length[bonds]], "Failures"->progressTrack[Epic]], 
       "bonds" -> bonds, "earnedExperience" -> 0, "spentExperience" -> 0]; AssociateTo[$state, name -> character]; $soloCharacter = name; $state[name]]; 
       
setSoloCharacter[character_String] := Module[{},
	If[!AssociationQ[$state] || !KeyExistsQ[$state, character],
		Message[setSoloCharacter::nochar, character];
		Return[$Failed]
	];
	$soloCharacter = character
];

setSoloCharacter::nochar = "No character named `1` exists in the current state.";


(* ::Subsection::Closed:: *)
(*Action roll*)


Options[actionRoll] = {Adds -> Association[], Display -> True}; 
actionRoll[(stat_)?statQ, opts:OptionsPattern[]] := actionRoll[stat, $soloCharacter, opts]; 
actionRoll[(stat_)?statQ, character_String, opts:OptionsPattern[]] := Module[{actionDie, momentum, actionValue, actionDieCancelled, statValue, adds, actionScore, challengeDice, cd1, cd2, roll}, 
    actionDie = rollActionDie[]; momentum = getMomentum[character]; {actionValue, actionDieCancelled} = If[momentum < 0 && Abs[momentum] == actionDie, {0, True}, {actionDie, False}]; 
     statValue = getAttr[stat, character]; adds = OptionValue[Adds]; actionScore = Min[actionValue + Total[Values[adds]] + statValue, 10]; challengeDice = {cd1, cd2} = rollChallengeDice[]; 
     roll = Association["character" -> character, "actionDie" -> actionDie, "momentum" -> momentum, "actionValue" -> actionValue, "actionDieCancelled" -> actionDieCancelled, "stat" -> stat, 
       "statValue" -> statValue, "adds" -> adds, "actionScore" -> actionScore, "challengeDice" -> challengeDice, "match" -> cd1 == cd2, "result" -> actionRollResult[challengeDice, actionScore]]; 
     If[OptionValue[Display], displayActionRoll[roll]]; roll]; 


(* ::Subsection::Closed:: *)
(*Burn momentum*)


Options[burnMomentum] = {Display -> True}; 
burnMomentum[roll_Association, opts:OptionsPattern[]] := Module[{momentum, challengeDice, challengeDiceCancelled, burn}, momentum = roll["momentum"]; challengeDice = roll["challengeDice"]; 
     challengeDiceCancelled = (Map[#1 < momentum & ])[challengeDice]; burn = Association["momentum" -> momentum, "challengeDice" -> challengeDice, "momentumReset" -> getMomentumReset[roll["character"]], 
       "actionScore" -> roll["actionScore"], "result" -> actionRollResult[challengeDice, momentum], "challengeDiceCancelled" -> challengeDiceCancelled, "match" -> roll["match"]]; 
     resetMomentum[roll["character"]]; If[OptionValue[Display], displayMomentumBurn[burn]]; burn]; 


(* ::Subsection::Closed:: *)
(*Progress roll*)


Options[progressRoll] = {Display -> True};

progressRoll[track_String, opts : OptionsPattern[]] :=
	progressRoll[track, $soloCharacter, opts];

progressRoll[track_String, character_String, opts : OptionsPattern[]] := Module[
	{progressScore, challengeDice, die1, die2, roll},
	progressScore = Floor[getProgress[track, character]];
	challengeDice = {die1, die2} = rollChallengeDice[];
	roll = Association[
		"character" -> character,
		"trackName" -> track,
		"progressScore" -> progressScore,
		"challengeDice" -> challengeDice,
		"match" -> die1 == die2,
		"result" -> progressRollResult[challengeDice, progressScore]
	];
	If[OptionValue[Display], displayProgressRoll[roll]];
	roll
];


(* ::Subsection::Closed:: *)
(*Suffer and take*)


sufferMomentum[n_Integer, character_ : $soloCharacter] :=
	adjustMomentum[n, character];

takeMomentum[n_Integer, character_ : $soloCharacter] :=
	adjustMomentum[n, character];

sufferHealth[n_Integer, character_ : $soloCharacter] :=
	adjustHealth[n, character];

takeHealth[n_Integer, character_ : $soloCharacter] :=
	adjustHealth[n, character];

sufferSpirit[n_Integer, character_ : $soloCharacter] :=
	adjustSpirit[n, character];

takeSpirit[n_Integer, character_ : $soloCharacter] :=
	adjustSpirit[n, character];

sufferSupply[n_Integer, character_ : $soloCharacter] :=
	adjustSupply[n, character];

takeSupply[n_Integer, character_ : $soloCharacter] :=
	adjustSupply[n, character];


(* ::Subsection::Closed:: *)
(*Mark progress*)


markProgress[track_String, n_Integer, character_ : $soloCharacter] := Module[
	{rank, markValue},
	rank = getRank[track, character];
	markValue = Replace[
		rank,
		{
			Troublesome -> 3,
			Dangerous -> 2,
			Formidable -> 1,
			Extreme -> 0.5,
			Epic -> 0.25
		}
	];
	$state[character, "progressTracks", track, "progress"] += n markValue
];


(* ::Subsection::Closed:: *)
(*Add a bond*)


addBond[bond_String, character_ : $soloCharacter] := Module[{},
	AppendTo[$state[character, "bonds"], bond];
	markProgress["bonds", 1, character]
];


(* ::Subsection::Closed:: *)
(*Add/remove a progress track*)


addProgressTrack[track_String, rank_?rankQ, character_:$soloCharacter] := character["progressTracks", track] = progressTrack[rank];
removeProgressTrack[track_String, character_:$soloCharacter] := character["progressTracks"] = KeyDrop[character["progressTracks"], {track}];


(* ::Subsection::Closed:: *)
(*Mark/spend experience*)


markExperience[n_Integer, character_ : $soloCharacter] :=
	$state[character, "earnedExperience"] += n;

spendExperience[n_Integer, character_ : $soloCharacter] :=
	$state[character, "spentExperience"] += n;


(* ::Section::Closed:: *)
(*Move interface implementation*)


(* ::Subsection::Closed:: *)
(*Adventure moves*)


(* ::Subsubsection:: *)
(*Face Danger*)


faceDanger[] := displayMove["faceDanger"];
faceDanger[actionRoll_Association] := displayMove["faceDanger", actionRoll];


(* ::Subsubsection:: *)
(*Secure an Advantage*)


secureAnAdvantage[] := displayMove["secureAnAdvantage"];
secureAnAdvantage[actionRoll_Association] := displayMove["secureAnAdvantage", actionRoll];


(* ::Subsubsection:: *)
(*Gather Information*)


gatherInformation[] := displayMove["gatherInformation"];
gatherInformation[actionRoll_Association] := displayMove["gatherInformation", actionRoll];


(* ::Subsubsection:: *)
(*Make Camp*)


makeCamp[] := displayMove["makeCamp"];
makeCamp[actionRoll_Association] := displayMove["makeCamp", actionRoll];


(* ::Subsubsection:: *)
(*Heal*)


heal[] := displayMove["heal"];
heal[actionRoll_Association] := displayMove["heal", actionRoll];


(* ::Subsubsection:: *)
(*Resupply*)


resupply[] := displayMove["resupply"];
resupply[actionRoll_Association] := displayMove["resupply", actionRoll];


(* ::Subsubsection:: *)
(*Check Your Gear*)


checkYourGear[] := displayMove["checkYourGear"];
checkYourGear[actionRoll_Association] := displayMove["checkYourGear", actionRoll];


(* ::Subsection::Closed:: *)
(*Journey moves*)


(* ::Subsubsection:: *)
(*Undertake a Journey*)


undertakeAJourney[] := displayMove["undertakeAJourney"];
undertakeAJourney[actionRoll_Association] := displayMove["undertakeAJourney", actionRoll];


(* ::Subsubsection:: *)
(*Reach Your Destination*)


reachYourDestination[] := displayMove["reachYourDestination"];
reachYourDestination[progressRoll_Association] := displayMove["reachYourDestination", progressRoll];


(* ::Subsubsection:: *)
(*Follow a Path*)


followAPath[] := displayMove["followAPath"];
followAPath[actionRoll_Association] := displayMove["followAPath", actionRoll];


(* ::Subsection::Closed:: *)
(*Scene challenge moves*)


(* ::Subsubsection:: *)
(*Begin the Scene*)


beginTheScene[] := displayMove["beginTheScene"];


(* ::Subsubsection:: *)
(*Face Danger (Scene)*)


faceDangerScene[] := displayMove["faceDangerScene"];
faceDangerScene[actionRoll_Association] := displayMove["faceDangerScene", actionRoll];


(* ::Subsubsection:: *)
(*Secure an Advantage (Scene)*)


secureAnAdvantageScene[] := displayMove["secureAnAdvantageScene"];
secureAnAdvantageScene[actionRoll_Association] := displayMove["secureAnAdvantageScene", actionRoll];


(* ::Subsubsection:: *)
(*Finish the Scene*)


finishTheScene[] := displayMove["finishTheScene"];
finishTheScene[progressRoll_Association] := displayMove["finishTheScene", progressRoll];


(* ::Subsection::Closed:: *)
(*Quest moves*)


(* ::Subsubsection:: *)
(*Swear an Iron Vow*)


swearAnIronVow[] := displayMove["swearAnIronVow"];
swearAnIronVow[actionRoll_Association] := displayMove["swearAnIronVow", actionRoll];


(* ::Subsubsection:: *)
(*Reach a Milestone*)


reachAMilestone[] := displayMove["reachAMilestone"];


(* ::Subsubsection:: *)
(*Fulfill Your Vow*)


fulfillYourVow[] := displayMove["fulfillYourVow"];
fulfillYourVow[progressRoll_Association] := displayMove["fulfillYourVow", progressRoll];


(* ::Subsubsection:: *)
(*Forsake Your Vow*)


forsakeYourVow[] := displayMove["forsakeYourVow"];


(* ::Subsubsection:: *)
(*Advance*)


advance[] := displayMove["advance"];


(* ::Subsection::Closed:: *)
(*Fate moves*)


(* ::Subsubsection::Closed:: *)
(*Pay the Price*)


payThePrice[] := displayMove["payThePrice"];


(* ::Subsubsection::Closed:: *)
(*Ask the Oracle*)


askTheOracle[] := displayMove["askTheOracle"];
askTheOracle[tableName_String] := oracleRoll[tableName, oracles[tableName]];
askTheOracle["Yes/No", odds_String] := oracleRoll["Yes/No: " <> odds, oracles["Yes/No: " <> odds]];
askTheOracle["Yes/No", yesOutcome_String, noOutcome_String] := oracleRoll["Yes/No", yesNo[yesOutcome, noOutcome]];
askTheOracle["Reveal a Danger"] := oracleRoll["Reveal a Danger: Alternate", revealDangerAlternateTable];
askTheOracle["Reveal a Danger", theme_String, domain_String] := oracleRoll["Reveal a Danger ("<>theme<>", "<>domain<>")", revealDangerCombinedTable[theme, domain]];
askTheOracle["Delve Site Feature", theme_String, domain_String] := oracleRoll["Delve Site Feature ("<>theme<>", "<>domain<>")", delveSiteFeatureTable[theme, domain]];


(* ::Subsection::Closed:: *)
(*Relationship moves*)


(* ::Subsubsection:: *)
(*Compel*)


compel[] := displayMove["compel"];
compel[actionRoll_Association] := displayMove["compel", actionRoll];


(* ::Subsubsection:: *)
(*Aid Your Ally*)


aidYourAlly[] := displayMove["aidYourAlly"];


(* ::Subsubsection:: *)
(*Sojourn*)


sojourn[] := displayMove["sojourn"];
sojourn[actionRoll_Association] := displayMove["sojourn", actionRoll];

sojournFocus[] := displayMove["sojournFocus"];
sojournFocus[actionRoll_Association] := displayMove["sojournFocus", actionRoll];


(* ::Subsubsection:: *)
(*Forge a Bond*)


forgeABond[] := displayMove["forgeABond"];
forgeABond[actionRoll_Association] := displayMove["forgeABond", actionRoll];


(* ::Subsubsection:: *)
(*Test Your Bond*)


testYourBond[] := displayMove["testYourBond"];
testYourBond[actionRoll_Association] := displayMove["testYourBond", actionRoll];


(* ::Subsubsection:: *)
(*Draw the Circle*)


drawTheCircle[] := displayMove["drawTheCircle"];
drawTheCircle[actionRoll_Association] := displayMove["drawTheCircle", actionRoll];


(* ::Subsubsection::Closed:: *)
(*Write Your Epilogue*)


writeYourEpilogue[] := displayMove["writeYourEpilogue"];
writeYourEpilogue[progressRoll_Association] := displayMove["writeYourEpilogue", progressRoll];


(* ::Subsection::Closed:: *)
(*Combat moves*)


(* ::Subsubsection::Closed:: *)
(*Enter the Fray*)


enterTheFray[] := displayMove["enterTheFray"];
enterTheFray[actionRoll_Association] := displayMove["enterTheFray", actionRoll];


(* ::Subsubsection::Closed:: *)
(*Strike*)


strike[] := displayMove["strike"];
strike[actionRoll_Association] := displayMove["strike", actionRoll];


(* ::Subsubsection::Closed:: *)
(*Clash*)


clash[] := displayMove["clash"];
clash[actionRoll_Association] := displayMove["clash", actionRoll];


(* ::Subsubsection::Closed:: *)
(*Turn the Tide*)


turnTheTide[] := displayMove["turnTheTide"];


(* ::Subsubsection::Closed:: *)
(*Battle*)


battle[] := displayMove["battle"];
battle[actionRoll_Association] := displayMove["battle", actionRoll];


(* ::Subsubsection::Closed:: *)
(*End the Fight*)


Options[endTheFight] = {Initiative -> True};
endTheFight[] := displayMove["endTheFight"];
endTheFight[actionRoll_Association, opts:OptionsPattern[]] := displayMove["endTheFight", endTheFightTransformer[actionRoll, OptionValue[Initiative]]];


(* ::Subsection::Closed:: *)
(*Suffer moves*)


(* ::Subsubsection:: *)
(*Endure Harm*)


endureHarm[] := displayMove["endureHarm"];
endureHarm[actionRoll_Association] := displayMove["endureHarm", actionRoll];


(* ::Subsubsection:: *)
(*Face Death*)


faceDeath[] := displayMove["faceDeath"];
faceDeath[actionRoll_Association] := displayMove["faceDeath", actionRoll];


(* ::Subsubsection:: *)
(*Companion Endure Harm*)


companionEndureHarm[] := displayMove["companionEndureHarm"];
companionEndureHarm[actionRoll_Association] := displayMove["companionEndureHarm", actionRoll];


(* ::Subsubsection:: *)
(*Endure Stress*)


endureStress[] := displayMove["endureStress"];
endureStress[actionRoll_Association] := displayMove["endureStress", actionRoll];


(* ::Subsubsection:: *)
(*Face Desolation*)


faceDesolation[] := displayMove["faceDesolation"];
faceDesolation[actionRoll_Association] := displayMove["faceDesolation", actionRoll];


(* ::Subsubsection:: *)
(*Out of Supply*)


outOfSupply[] := displayMove["outOfSupply"];


(* ::Subsubsection:: *)
(*Face a Setback*)


faceASetback[] := displayMove["faceASetback"];


(* ::Subsection::Closed:: *)
(*Delve moves*)


(* ::Subsubsection::Closed:: *)
(*Discover a Site*)


discoverASite[] := displayMove["discoverASite"];


(* ::Subsubsection::Closed:: *)
(*Delve the Depths*)


delveTheDepths[] := displayMove["delveTheDepths"];
delveTheDepths[actionRoll_Association] := displayMove["delveTheDepths", actionRoll];


(* ::Subsubsection::Closed:: *)
(*Find an Opportunity*)


findAnOpportunity[] := displayMove["findAnOpportunity"];


(* ::Subsubsection::Closed:: *)
(*Reveal a Danger*)


revealADanger[] := displayMove["revealADanger"];


(* ::Subsubsection::Closed:: *)
(*Locate Your Objective*)


locateYourObjective[] := displayMove["locateYourObjective"];
locateYourObjective[progressRoll_Association] := displayMove["locateYourObjective", progressRoll];


(* ::Subsubsection::Closed:: *)
(*Escape the Depths*)


escapeTheDepths[] := displayMove["escapeTheDepths"];
escapeTheDepths[actionRoll_Association] := displayMove["escapeTheDepths", actionRoll];


(* ::Subsection::Closed:: *)
(*Failure moves*)


(* ::Subsubsection::Closed:: *)
(*Mark Your Failure*)


markYourFailure[] := displayMove["markYourFailure"];


(* ::Subsubsection::Closed:: *)
(*Learn from Your Failures*)


learnFromYourFailures[] := displayMove["learnFromYourFailures"];
learnFromYourFailures[progressRoll_Association] := displayMove["learnFromYourFailures", progressRoll];


(* ::Subsection::Closed:: *)
(*Threat moves*)


(* ::Subsubsection:: *)
(*Advance a Threat*)


advanceAThreat[] := displayMove["advanceAThreat"];


(* ::Subsubsection:: *)
(*Take a Hiatus*)


takeAHiatus[] := displayMove["takeAHiatus"];


(* ::Subsection::Closed:: *)
(*Rarity moves*)


(* ::Subsubsection:: *)
(*Gain a Rarity*)


gainARarity[] := displayMove["gainARarity"];


(* ::Subsubsection:: *)
(*Wield a Rarity*)


wieldARarity[] := displayMove["wieldARarity"];


(* ::Section::Closed:: *)
(*Private context footer*)


End[];


(* ::Section:: *)
(*Package footer*)


EndPackage[];
