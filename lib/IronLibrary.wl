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
"beginStory[name] starts a new story using name as the story name. Call beginStory[name] before createCharacter to establish the reproducible seed for character creation draws.";

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
"createCharacter[name, {a1, a2, a3}, edge, heart, iron, shadow, wits, starterVow[...] | {vowName, Extreme | Epic}, {b1, b2, b3}] creates a character and sets it as the solo character. Starting assets may be asset name strings when the card has a printed default selected ability, or starterAsset[...] specs.";

characterSheet::usage =
"characterSheet[] displays a Lodestar-style character sheet for the solo character.
characterSheet[character] displays a Lodestar-style character sheet for the named character.";


(* ::Subsection::Closed:: *)
(*Vow management*)


starterVow::usage =
"starterVow[name, Extreme | Epic] creates a quiet starting vow spec.
starterVow[name, Extreme | Epic, Threat -> {threatName, threatGoal}] creates a quiet starting vow spec with one attached threat.";

addVow::usage =
"addVow[name, rank] adds a vow to the solo character.
addVow[name, rank, character] adds a vow to character.
addVow[..., Threat -> {threatName, threatGoal}] adds a vow with one attached threat.";

vow::usage =
"vow[name] displays the vow named name for the solo character.
vow[name, character] displays the vow named name for character.";

vows::usage =
"vows[] displays all vows for the solo character.
vows[character] displays all vows for character.";

removeVow::usage =
"removeVow[name] removes the named vow from the solo character.
removeVow[name, character] removes the named vow from character.";

setThreat::usage =
"setThreat[vowName, {threatName, threatGoal}] sets or replaces the threat attached to vowName for the solo character.
setThreat[vowName, {threatName, threatGoal}, character] sets or replaces the threat attached to vowName for character.";

removeThreat::usage =
"removeThreat[vowName] removes the threat attached to vowName for the solo character.
removeThreat[vowName, character] removes the threat attached to vowName for character.";

clearThreatProgress::usage =
"clearThreatProgress[vowName] clears the menace progress for the threat attached to vowName for the solo character.
clearThreatProgress[vowName, character] clears the menace progress for the threat attached to vowName for character.";


(* ::Subsection::Closed:: *)
(*Debility management*)


markWounded::usage =
"markWounded[] marks Wounded for the solo character.
markWounded[character] marks Wounded for character.";

clearWounded::usage =
"clearWounded[] clears Wounded for the solo character.
clearWounded[character] clears Wounded for character.";

markShaken::usage =
"markShaken[] marks Shaken for the solo character.
markShaken[character] marks Shaken for character.";

clearShaken::usage =
"clearShaken[] clears Shaken for the solo character.
clearShaken[character] clears Shaken for character.";

markUnprepared::usage =
"markUnprepared[] marks Unprepared for the solo character.
markUnprepared[character] marks Unprepared for character.";

clearUnprepared::usage =
"clearUnprepared[] clears Unprepared for the solo character.
clearUnprepared[character] clears Unprepared for character.";

markEncumbered::usage =
"markEncumbered[] marks Encumbered for the solo character.
markEncumbered[character] marks Encumbered for character.";

clearEncumbered::usage =
"clearEncumbered[] clears Encumbered for the solo character.
clearEncumbered[character] clears Encumbered for character.";

markMaimed::usage =
"markMaimed[] marks Maimed for the solo character.
markMaimed[character] marks Maimed for character.";

markCorrupted::usage =
"markCorrupted[] marks Corrupted for the solo character.
markCorrupted[character] marks Corrupted for character.";

markCursed::usage =
"markCursed[] marks Cursed for the solo character.
markCursed[character] marks Cursed for character.";

clearCursed::usage =
"clearCursed[] clears Cursed for the solo character.
clearCursed[character] clears Cursed for character.";

markTormented::usage =
"markTormented[] marks Tormented for the solo character.
markTormented[character] marks Tormented for character.";

clearTormented::usage =
"clearTormented[] clears Tormented for the solo character.
clearTormented[character] clears Tormented for character.";


(* ::Subsection::Closed:: *)
(*Asset management*)


starterAsset::usage =
"starterAsset[name] creates a quiet starting asset spec using the asset's printed default selected abilities.
starterAsset[name, ability] creates a quiet starting asset spec with the selected ability index.
starterAsset[name, {ability1, ability2, ...}] creates a quiet starting asset spec with multiple selected abilities.
starterAsset[name, abilityOrAbilities, fields] includes custom field values such as <|\"Name\" -> \"Asha\"|>.";

asset::usage =
"asset[name] displays the owned asset named name for the solo character.
asset[name, character] displays the owned asset named name for character.";

assets::usage =
"assets[] displays all owned assets for the solo character.
assets[character] displays all owned assets for character.";

drawAssets::usage =
"drawAssets[] displays three random reference asset cards and returns their canonical names.
drawAssets[n] displays n random reference asset cards.
drawAssets[n, category] draws from category, one of \"Path\", \"Companion\", \"Combat Talent\", or \"Ritual\".";

addAsset::usage =
"addAsset[assetSpec] spends 5 experience to add an asset to the solo character and displays the updated card.
addAsset[assetSpec, character] spends 5 experience to add an asset to character.
assetSpec may be an asset name string with printed default selected abilities, or a starterAsset[...] spec.
addAsset[..., Display -> False] suppresses display.";

upgradeAsset::usage =
"upgradeAsset[name, ability] spends 3 experience to mark ability on an owned asset for the solo character and displays the updated card.
upgradeAsset[name, ability, character] spends 3 experience to mark ability on an owned asset for character.
upgradeAsset[..., Display -> False] suppresses display.";

setAssetTrack::usage =
"setAssetTrack[assetName, trackName, value] sets an owned asset track for the solo character, clamped to the printed track range.
setAssetTrack[assetName, trackName, value, character] sets an owned asset track for character.";

adjustAssetTrack::usage =
"adjustAssetTrack[assetName, trackName, delta] adjusts an owned asset track for the solo character, clamped to the printed track range.
adjustAssetTrack[assetName, trackName, delta, character] adjusts an owned asset track for character.";

removeAsset::usage =
"removeAsset[name] removes an owned asset from the solo character without awarding experience.
removeAsset[name, character] removes an owned asset from character without awarding experience.
removeAsset[..., Display -> False] suppresses display.";

companion::usage =
"companion[name] displays the owned companion asset named name for the solo character.
companion[name, character] displays the owned companion asset named name for character.";

companions::usage =
"companions[] displays all owned companion assets for the solo character.
companions[character] displays all owned companion assets for character.";

setCompanionHealth::usage =
"setCompanionHealth[name, value] sets an owned companion's health track for the solo character.
setCompanionHealth[name, value, character] sets an owned companion's health track for character.";

adjustCompanionHealth::usage =
"adjustCompanionHealth[name, delta] adjusts an owned companion's health track for the solo character.
adjustCompanionHealth[name, delta, character] adjusts an owned companion's health track for character.";


(* ::Subsection::Closed:: *)
(*Action roll*)


actionRoll::usage =
"actionRoll[stat] makes an action roll using stat for the solo character.
actionRoll[stat, character] makes an action roll using stat for character.";


(* ::Subsection::Closed:: *)
(*Burn momentum*)


burnMomentum::usage =
"burnMomentum[roll] burns momentum for roll and returns the modified roll result.";

rarityDieSix::usage =
"rarityDieSix[roll] displays a Rarity Die conversion to a strong hit and returns a copy of the action roll with a strong hit result.";


(* ::Subsection::Closed:: *)
(*Progress roll*)


progressRoll::usage =
"progressRoll[track] makes a progress roll against track for the solo character.
progressRoll[track, character] makes a progress roll against track for character.";


(* ::Subsection::Closed:: *)
(*Reroll*)


reroll::usage =
"reroll[roll, die] rerolls die in roll and returns the modified roll.
reroll[roll, {die1, die2, ...}] rerolls the specified dice in roll and returns the modified roll.

Possible dice are ActionDie, ChallengeDice, LargerChallengeDie, and SmallerChallengeDie.

ActionDie may only be used with action rolls. Challenge dice may be rerolled in action rolls and progress rolls.

reroll[..., Display -> False] suppresses display.";


(* ::Subsection::Closed:: *)
(*Choice display*)


choose::usage =
"choose[moveOutput, n] displays the nth choice from a previous move header or outcome output.
choose[moveOutput, {n1, n2, ...}] displays multiple choices from a previous move header or outcome output.

Typical usage is moveFunction[]; choose[%, n].";


(* ::Subsection::Closed:: *)
(*Marking progress*)


markProgress::usage =
"markProgress[track] marks 1 progress unit on track for the solo character.
markProgress[track, n] marks n progress units on track for the solo character.
markProgress[track, n, character] marks n progress units on track for character.";

clearProgress::usage =
"clearProgress[track, n] clears n progress units from track for the solo character.
clearProgress[track, n, character] clears n progress units from track for character.";

resetProgress::usage =
"resetProgress[track] resets track progress to 0 for the solo character.
resetProgress[track, character] resets track progress to 0 for character.";

resetProgressToOne::usage =
"resetProgressToOne[track] resets track progress to 1 for the solo character.
resetProgressToOne[track, character] resets track progress to 1 for character.";

raiseProgressRank::usage =
"raiseProgressRank[track] raises track rank by one step for the solo character.
raiseProgressRank[track, character] raises track rank by one step for character.";

addJourney::usage =
"addJourney[name, rank] adds a journey progress track for the solo character.
addJourney[name, rank, character] adds a journey progress track for character.";

setCurrentJourney::usage =
"setCurrentJourney[name] sets the current journey for the solo character.
setCurrentJourney[name, character] sets the current journey for character.";

journey::usage =
"journey[] displays the current journey for the solo character.
journey[name] displays the named journey for the solo character.
journey[name, character] displays the named journey for character.";

journeys::usage =
"journeys[] displays all journeys for the solo character.
journeys[character] displays all journeys for character.";

removeJourney::usage =
"removeJourney[name] removes the named journey from the solo character.
removeJourney[name, character] removes the named journey from character.";

addFoe::usage =
"addFoe[name, rank] adds a foe progress track for the solo character.
addFoe[name, rank, character] adds a foe progress track for character.";

foe::usage =
"foe[name] displays the named foe for the solo character.
foe[name, character] displays the named foe for character.";

foes::usage =
"foes[] displays all foes for the solo character.
foes[character] displays all foes for character.";

removeFoe::usage =
"removeFoe[name] removes the named foe from the solo character.
removeFoe[name, character] removes the named foe from character.";

failures::usage =
"failures[] displays the failure progress track for the solo character.
failures[character] displays the failure progress track for character.";

bondProgress::usage =
"bondProgress[] displays the bonds progress track for the solo character.
bondProgress[character] displays the bonds progress track for character.";


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

recover::usage =
"recover[] applies the Take a Hiatus recovery package to the solo character without advancing threats.
recover[character] applies the Take a Hiatus recovery package to character without advancing threats.";


(* ::Subsection::Closed:: *)
(*Adding bonds*)


addBond::usage =
"addBond[bond] adds bond to the solo character and marks progress on the bonds track.
addBond[bond, character] adds bond to character and marks progress on the bonds track.";

bond::usage =
"bond[name] displays the named bond for the solo character.
bond[name, character] displays the named bond for character.";

bonds::usage =
"bonds[] displays all bonds for the solo character.
bonds[character] displays all bonds for character.";

removeBond::usage =
"removeBond[name] removes the named bond from the solo character and clears one tick on the bonds track.
removeBond[name, character] removes the named bond from character and clears one tick on the bonds track.";


(* ::Subsection::Closed:: *)
(*Mark experience*)


markExperience::usage =
"markExperience[n] adds n earned experience to the solo character.
markExperience[n, character] adds n earned experience to character.";


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

beginScene::usage =
"beginScene[name, rank] creates the active scene challenge for the solo character.
beginScene[name, rank, character] creates the active scene challenge for character.";

scene::usage =
"scene[] displays the active scene challenge for the solo character.
scene[character] displays the active scene challenge for character.";

removeScene::usage =
"removeScene[] removes the active scene challenge for the solo character.
removeScene[character] removes the active scene challenge for character.";

markSceneCountdown::usage =
"markSceneCountdown[] marks 1 segment on the solo character's active scene countdown.
markSceneCountdown[n] marks n segments on the solo character's active scene countdown.
markSceneCountdown[n, character] marks n segments on character's active scene countdown.";

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
askTheOracle[\"Yes/No\", yesOutcome, noOutcome] rolls on the Yes/No oracle with the specified yes and no outcomes and \"Likely\" yes-odds.
askTheOracle[\"Reveal a Danger\"] rolls on the current delve's Reveal a Danger oracle when a current delve is set; otherwise it rolls on the alternate Reveal a Danger oracle.
askTheOracle[\"Reveal a Danger\", theme, domain] rolls on the Reveal a Danger oracle for theme and domain.
askTheOracle[\"Delve Site Feature\"] rolls on the current delve's Delve Site Feature oracle.
askTheOracle[\"Delve Site Feature\", theme, domain] rolls on the Delve Site Feature oracle for theme and domain.
askTheOracle[\"Delve Site Name\"] composes a site name using the current delve's domain.
askTheOracle[\"Delve Site Name\", domain] composes a site name using domain.
askTheOracle[\"Monstrosity\"], askTheOracle[\"Trap\"], askTheOracle[\"Combat Event\"], and askTheOracle[\"Threat\"] roll composite Delve oracle results.
askTheOracle[\"Settlement: Name\"], askTheOracle[\"Settlement: Quick Name\"], askTheOracle[\"Core: Prompt\"], askTheOracle[\"Character\"], askTheOracle[\"Settlement\"], askTheOracle[\"Combat Scene\"], and askTheOracle[\"Journey Waypoint\"] roll composite oracle results.
askTheOracle[\"Threat\", category] rolls on a specific threat category.";


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

addDelve::usage =
"addDelve[name, rank, themeOrThemes, domainOrDomains] adds a delve site for the solo character.
addDelve[name, rank, themeOrThemes, domainOrDomains, denizens] adds a delve site with a 12-slot denizens matrix.
addDelve[..., character] adds a delve site for character.

themeOrThemes and domainOrDomains may be a string or a two-string list, but a delve cannot have both two themes and two domains.
addDelve[..., Objective -> objective] records an optional objective string.";

setCurrentDelve::usage =
"setCurrentDelve[name] sets the current delve for the solo character.
setCurrentDelve[name, character] sets the current delve for character.";

delve::usage =
"delve[] displays the current delve for the solo character.
delve[name] displays the named delve for the solo character.
delve[name, character] displays the named delve for character.";

delves::usage =
"delves[] displays all delves for the solo character.
delves[character] displays all delves for character.";

removeDelve::usage =
"removeDelve[name] removes the named delve for the solo character.
removeDelve[name, character] removes the named delve for character.";

setDelveTheme::usage =
"setDelveTheme[themeOrThemes] updates the current delve's theme cards.
setDelveTheme[delveName, themeOrThemes] updates the named delve's theme cards for the solo character.
setDelveTheme[delveName, themeOrThemes, character] updates the named delve's theme cards for character.";

setDelveDomain::usage =
"setDelveDomain[domainOrDomains] updates the current delve's domain cards.
setDelveDomain[delveName, domainOrDomains] updates the named delve's domain cards for the solo character.
setDelveDomain[delveName, domainOrDomains, character] updates the named delve's domain cards for character.";

returnToSite::usage =
"returnToSite[] rolls the return challenge dice for the current delve and returns the lower die value to clear manually.
returnToSite[delveName] rolls for the named delve for the solo character.
returnToSite[delveName, character] rolls for the named delve for character.";

riskZone::usage =
"riskZone[] displays the current delve's risk zone and returns its default rank.
riskZone[delveName] displays the named delve's risk zone and returns its default rank for the solo character.
riskZone[delveName, character] displays the named delve's risk zone and returns its default rank for character.";

denizens::usage =
"denizens[] displays the current delve's denizens matrix.
denizens[delveName] displays the named delve's denizens matrix for the solo character.
denizens[delveName, character] displays the named delve's denizens matrix for character.";

rollDenizen::usage =
"rollDenizen[] rolls on the current delve's denizens matrix.
rollDenizen[delveName] rolls on the named delve's denizens matrix for the solo character.
rollDenizen[delveName, character] rolls on the named delve's denizens matrix for character.";

setDenizen::usage =
"setDenizen[slot, name] sets slot in the current delve's denizens matrix.
setDenizen[delveName, slot, name] sets slot in the named delve's denizens matrix for the solo character.
setDenizen[delveName, slot, name, character] sets slot in the named delve's denizens matrix for character.";

clearDenizen::usage =
"clearDenizen[slot] clears slot in the current delve's denizens matrix.
clearDenizen[delveName, slot] clears slot in the named delve's denizens matrix for the solo character.
clearDenizen[delveName, slot, character] clears slot in the named delve's denizens matrix for character.";

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

addRarity::usage =
"addRarity[assetName, rarityName] spends experience to augment an eligible owned asset for the solo character.
addRarity[assetName, rarityName, character] spends experience to augment an eligible owned asset for character.
addRarity[..., Display -> False] suppresses display.";

removeRarity::usage =
"removeRarity[assetName] removes a rarity from an owned asset for the solo character and awards 1 experience.
removeRarity[assetName, character] removes a rarity from an owned asset for character and awards 1 experience.
removeRarity[..., Display -> False] suppresses display.";


(* ::Subsection::Closed:: *)
(*Stats*)


Health::usage =
"Health is a stat.";

Spirit::usage =
"Spirit is a stat.";

Supply::usage =
"Supply is a stat";


(* ::Subsection::Closed:: *)
(*Option names and public symbols*)


Name::usage =
"Name is a public symbol reserved by IronLibrary.";

Edge::usage =
"Edge is one of the five Ironsworn stats.";

Heart::usage =
"Heart is one of the five Ironsworn stats.";

Iron::usage =
"Iron is one of the five Ironsworn stats.";

Shadow::usage =
"Shadow is one of the five Ironsworn stats.";

Wits::usage =
"Wits is one of the five Ironsworn stats.";

Assets::usage =
"Assets is a public symbol reserved by IronLibrary.";

BackgroundVow::usage =
"BackgroundVow is a public symbol reserved by IronLibrary.";

Bonds::usage =
"Bonds is a public symbol reserved by IronLibrary.";

Adds::usage =
"Adds is an option for actionRoll that specifies an association of named bonuses.";

ArcName::usage =
"ArcName is an option for beginChapter that specifies the arc name to use for the current chapter.";

Initiative::usage =
"Initiative is a True/False option for endTheFight, which specifies whether the character has initiative.";

Display::usage =
"Display is an option that specifies whether a function should display its result.";

Threat::usage =
"Threat is an option for starterVow and addVow that specifies an attached threat as {threatName, threatGoal}.";

Objective::usage =
"Objective is an option for addDelve that specifies the site objective.";


(* ::Subsection::Closed:: *)
(*Debility symbols*)


Wounded::usage =
"Wounded is a debility.";

Shaken::usage =
"Shaken is a debility.";

Unprepared::usage =
"Unprepared is a debility.";

Encumbered::usage =
"Encumbered is a debility.";

Maimed::usage =
"Maimed is a permanent debility.";

Corrupted::usage =
"Corrupted is a permanent debility.";

Cursed::usage =
"Cursed is a debility.";

Tormented::usage =
"Tormented is a debility.";


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


(* ::Subsection::Closed:: *)
(*Reroll selection symbols*)


ActionDie::usage =
"ActionDie specifies the action die for reroll.";

ChallengeDice::usage =
"ChallengeDice specifies both challenge dice for reroll.";

LargerChallengeDie::usage =
"LargerChallengeDie specifies the larger challenge die for reroll. If the challenge dice are tied, the first challenge die is selected.";

SmallerChallengeDie::usage =
"SmallerChallengeDie specifies the smaller challenge die for reroll. If the challenge dice are tied, the first challenge die is selected.";


(* ::Section:: *)
(*Private implementation*)


(* ::Subsection::Closed:: *)
(*Private context header*)


Begin["`Private`"];


(* ::Subsection::Closed:: *)
(*Implementation imports*)


If[!ValueQ[$IronLibraryPath], $IronLibraryPath = If[StringQ[$InputFileName] && $InputFileName =!= "", $InputFileName, $Failed]];

$ironLibraryHelperDirectory = DirectoryName[$IronLibraryPath];

Quiet[
	Get[FileNameJoin[{$ironLibraryHelperDirectory, "MoveData.wl"}]];
	Get[FileNameJoin[{$ironLibraryHelperDirectory, "AssetData.wl"}]];
	Get[FileNameJoin[{$ironLibraryHelperDirectory, "OracleData.wl"}]];
	Get[FileNameJoin[{$ironLibraryHelperDirectory, "FileHelpers.wl"}]];
	Get[FileNameJoin[{$ironLibraryHelperDirectory, "MechanicsHelpers.wl"}]];
	Get[FileNameJoin[{$ironLibraryHelperDirectory, "DisplayHelpers.wl"}]],
	General::shdw
];

$ContextPath = DeleteCases[
	$ContextPath,
	"IronLibrary`FileHelpers`" | "IronLibrary`MechanicsHelpers`" | "IronLibrary`DisplayHelpers`"
];
$ContextPath = DeleteDuplicates[Prepend[$ContextPath, "IronLibrary`"]];


(* ::Subsection:: *)
(*Wrapper plumbing*)


installHelperWrapper[helperContext_String, name_String] := Module[{publicName, helperName},
	publicName = StringJoin["IronLibrary`", name];
	helperName = StringJoin[helperContext, name];
	ToExpression[StringJoin["Clear[", publicName, "]"]];
	ToExpression[StringJoin["Options[", publicName, "] = Options[", helperName, "]"]];
	ToExpression[StringJoin[publicName, "[args___] := ", helperName, "[args]"]]
];

installHelperWrappers[helperContext_String, names_List] :=
	Scan[installHelperWrapper[helperContext, #] &, names];

optionValueFromArgs[option_, default_, args___] := Module[{rules},
	rules = Cases[{args}, (_Rule | _RuleDelayed), {1}];
	option /. Join[rules, {option -> default}]
];

displayRequested[default_, args___] :=
	TrueQ[optionValueFromArgs[Display, default, args]];

stateForFileHelpers[] := Module[{state},
	state = IronLibrary`MechanicsHelpers`getIronState[];
	If[AssociationQ[state], state, Automatic]
];

installStateFromFileResult[result_] := Module[{state},
	If[!AssociationQ[result], Return[result]];
	state = Lookup[result, "State", $Failed];
	If[AssociationQ[state], IronLibrary`MechanicsHelpers`setIronState[state]];
	KeyDrop[result, "State"]
];

firstStringArg[args___] :=
	FirstCase[{args}, s_String :> s, Missing["NoString"], {1}];

companionForDisplay[name_String, args___] := Module[{character},
	character = firstStringArg[args];
	If[StringQ[character],
		IronLibrary`MechanicsHelpers`companion[name, character],
		IronLibrary`MechanicsHelpers`companion[name]
	]
];

displayDelveRiskZone[delveData_] := Module[{zone},
	If[!AssociationQ[delveData], Return[$Failed]];
	zone = IronLibrary`MechanicsHelpers`riskZoneData[delveData];
	If[!AssociationQ[zone], Return[$Failed]];
	IronLibrary`DisplayHelpers`displayRiskZoneCard[delveData, zone];
	zone["Rank"]
];

displayDenizensFromDelve[delveData_] := Module[{denizenList},
	If[!AssociationQ[delveData], Return[$Failed]];
	denizenList = Lookup[delveData, "Denizens", {}];
	IronLibrary`DisplayHelpers`displayDenizensMatrix[delveData["Name"], denizenList];
	denizenList
];


(* ::Subsection::Closed:: *)
(*Direct helper APIs*)


$mechanicsPassThroughAPI = {
	"setSoloCharacter",
	"createCharacter",
	"starterVow",
	"addVow",
	"removeVow",
	"setThreat",
	"removeThreat",
	"clearThreatProgress",
	"markWounded",
	"clearWounded",
	"markShaken",
	"clearShaken",
	"markUnprepared",
	"clearUnprepared",
	"markEncumbered",
	"clearEncumbered",
	"markMaimed",
	"markCorrupted",
	"markCursed",
	"clearCursed",
	"markTormented",
	"clearTormented",
	"starterAsset",
	"setAssetTrack",
	"adjustAssetTrack",
	"markProgress",
	"clearProgress",
	"resetProgress",
	"resetProgressToOne",
	"raiseProgressRank",
	"sufferMomentum",
	"takeMomentum",
	"sufferHealth",
	"takeHealth",
	"sufferSpirit",
	"takeSpirit",
	"sufferSupply",
	"takeSupply",
	"recover",
	"addJourney",
	"setCurrentJourney",
	"removeJourney",
	"addFoe",
	"removeFoe",
	"addBond",
	"removeBond",
	"markExperience",
	"removeScene",
	"addDelve",
	"setCurrentDelve",
	"removeDelve",
	"setDelveTheme",
	"setDelveDomain",
	"setDenizen",
	"clearDenizen"
};

installHelperWrappers["IronLibrary`MechanicsHelpers`", $mechanicsPassThroughAPI];


(* ::Subsection::Closed:: *)
(*Move wrappers*)


displayMoveForPublic[moveKey_String] :=
	IronLibrary`DisplayHelpers`displayMove[moveKey];

displayMoveForPublic[moveKey_String, roll_Association] :=
	IronLibrary`DisplayHelpers`displayMove[moveKey, roll];

installMoveHeaderWrapper[name_String, moveKey_String] :=
	ToExpression[
		StringJoin[
			"IronLibrary`", name, "[] := IronLibrary`Private`displayMoveForPublic[\"", moveKey, "\"]"
		]
	];

installMoveRollWrapper[name_String, moveKey_String] := (
	installMoveHeaderWrapper[name, moveKey];
	ToExpression[
		StringJoin[
			"IronLibrary`", name, "[roll_Association] := IronLibrary`Private`displayMoveForPublic[\"", moveKey, "\", roll]"
		]
	]
);

$moveHeaderAPI = {
	"beginTheScene",
	"reachAMilestone",
	"forsakeYourVow",
	"advance",
	"payThePrice",
	"aidYourAlly",
	"turnTheTide",
	"outOfSupply",
	"faceASetback",
	"discoverASite",
	"findAnOpportunity",
	"revealADanger",
	"markYourFailure",
	"advanceAThreat",
	"takeAHiatus",
	"gainARarity",
	"wieldARarity"
};

$moveRollAPI = {
	"faceDanger",
	"secureAnAdvantage",
	"gatherInformation",
	"makeCamp",
	"heal",
	"resupply",
	"checkYourGear",
	"undertakeAJourney",
	"reachYourDestination",
	"followAPath",
	"faceDangerScene",
	"secureAnAdvantageScene",
	"finishTheScene",
	"swearAnIronVow",
	"fulfillYourVow",
	"compel",
	"sojourn",
	"sojournFocus",
	"forgeABond",
	"testYourBond",
	"drawTheCircle",
	"writeYourEpilogue",
	"enterTheFray",
	"strike",
	"clash",
	"battle",
	"endureHarm",
	"faceDeath",
	"companionEndureHarm",
	"endureStress",
	"faceDesolation",
	"delveTheDepths",
	"locateYourObjective",
	"escapeTheDepths"
};

Scan[installMoveHeaderWrapper[#, #] &, $moveHeaderAPI];
Scan[installMoveRollWrapper[#, #] &, $moveRollAPI];

choose[output_, selection_] :=
	IronLibrary`DisplayHelpers`displayMoveChoice[output, selection];

endTheFightRoll[roll_Association, initiative_] := Module[
	{map, transformed},
	map = {"strongHit" -> "weakHit", "weakHit" -> "miss", "miss" -> "miss"};
	transformed = Association[roll];
	If[!TrueQ[initiative],
		transformed["result"] = Replace[transformed["result"], map]
	];
	transformed
];

Options[endTheFight] = {Initiative -> True};

endTheFight[] :=
	displayMoveForPublic["endTheFight"];

endTheFight[roll_Association, opts : OptionsPattern[]] :=
	displayMoveForPublic["endTheFight", endTheFightRoll[roll, OptionValue[Initiative]]];

learnFromYourFailures[] :=
	displayMoveForPublic["learnFromYourFailures"];

learnFromYourFailures[roll_Association] := Module[
	{trackName, progressScore},
	trackName = Lookup[roll, "trackName", None];
	progressScore = Lookup[roll, "progressScore", Missing["NoProgressScore"]];
	If[trackName =!= "Failures",
		Message[learnFromYourFailures::badroll, trackName];
		Return[$Failed]
	];
	If[!NumericQ[progressScore] || progressScore < 6,
		Message[learnFromYourFailures::threshold, progressScore];
		Return[$Failed]
	];
	displayMoveForPublic["learnFromYourFailures", roll]
];

learnFromYourFailures::badroll = "learnFromYourFailures[roll] requires a progress roll against Failures, not `1`.";
learnFromYourFailures::threshold = "learnFromYourFailures[roll] requires the Failures progress score to be at least 6, not `1`.";


(* ::Subsection::Closed:: *)
(*State and file lifecycle*)


resetIronSession[] :=
	IronLibrary`MechanicsHelpers`resetIronSession[];

beginStory[] :=
	IronLibrary`FileHelpers`beginStory[];

beginStory[name_String] :=
	installStateFromFileResult[
		IronLibrary`FileHelpers`beginStory[name, stateForFileHelpers[]]
	];

beginStory[name_] :=
	IronLibrary`FileHelpers`beginStory[name];

Options[beginChapter] = Options[IronLibrary`FileHelpers`beginChapter];

beginChapter[args___] := Module[{state},
	state = IronLibrary`FileHelpers`beginChapter[args];
	If[AssociationQ[state], IronLibrary`MechanicsHelpers`setIronState[state]];
	state
];

endChapter[] := Module[{state},
	state = IronLibrary`MechanicsHelpers`getIronState[];
	If[!AssociationQ[state],
		Message[endChapter::nostate];
		Return[$Failed]
	];
	IronLibrary`FileHelpers`endChapter[state]
];

endChapter::nostate = "No IronLibrary state is loaded.";


(* ::Subsection::Closed:: *)
(*Character display*)


characterSheet[] := Module[{character},
	character = IronLibrary`MechanicsHelpers`soloCharacter[];
	If[character === $Failed, Return[$Failed]];
	characterSheet[character]
];

characterSheet[character_String] := Module[{characterData},
	characterData = IronLibrary`MechanicsHelpers`normalizeCharacterForSheet[character];
	If[characterData === $Failed, Return[$Failed]];
	IronLibrary`DisplayHelpers`displayCharacterSheet[character, characterData]
];


(* ::Subsection::Closed:: *)
(*Displayed mechanical objects*)


vow[args___] := Module[{ownedVow},
	ownedVow = IronLibrary`MechanicsHelpers`vow[args];
	If[AssociationQ[ownedVow], Print[IronLibrary`DisplayHelpers`displayVowCard[ownedVow]]];
	ownedVow
];

vows[args___] := Module[{ownedVows},
	ownedVows = IronLibrary`MechanicsHelpers`vows[args];
	If[AssociationQ[ownedVows], IronLibrary`DisplayHelpers`displayVowCards[ownedVows]];
	ownedVows
];

asset[args___] := Module[{ownedAsset},
	ownedAsset = IronLibrary`MechanicsHelpers`asset[args];
	If[AssociationQ[ownedAsset], IronLibrary`DisplayHelpers`displayAssetCard[ownedAsset]];
	ownedAsset
];

assets[args___] := Module[{ownedAssets},
	ownedAssets = IronLibrary`MechanicsHelpers`assets[args];
	If[ListQ[ownedAssets], IronLibrary`DisplayHelpers`displayOwnedAssets[ownedAssets]];
	ownedAssets
];

drawAssets[args___] := Module[{names},
	names = IronLibrary`MechanicsHelpers`drawAssets[args];
	If[ListQ[names], IronLibrary`DisplayHelpers`displayAssetReferences[names]];
	names
];

companion[args___] := Module[{ownedCompanion},
	ownedCompanion = IronLibrary`MechanicsHelpers`companion[args];
	If[AssociationQ[ownedCompanion], IronLibrary`DisplayHelpers`displayAssetCard[ownedCompanion]];
	ownedCompanion
];

companions[args___] := Module[{ownedCompanions},
	ownedCompanions = IronLibrary`MechanicsHelpers`companions[args];
	If[ListQ[ownedCompanions], IronLibrary`DisplayHelpers`displayOwnedAssets[ownedCompanions]];
	ownedCompanions
];

journey[args___] := Module[{ownedJourney},
	ownedJourney = IronLibrary`MechanicsHelpers`journey[args];
	If[AssociationQ[ownedJourney], IronLibrary`DisplayHelpers`displayProgressObjectCard["Journey", ownedJourney]];
	ownedJourney
];

journeys[args___] := Module[{ownedJourneys},
	ownedJourneys = IronLibrary`MechanicsHelpers`journeys[args];
	If[AssociationQ[ownedJourneys], IronLibrary`DisplayHelpers`displayProgressObjectCards["Journey", ownedJourneys]];
	ownedJourneys
];

foe[args___] := Module[{ownedFoe},
	ownedFoe = IronLibrary`MechanicsHelpers`foe[args];
	If[AssociationQ[ownedFoe], IronLibrary`DisplayHelpers`displayProgressObjectCard["Foe", ownedFoe]];
	ownedFoe
];

foes[args___] := Module[{ownedFoes},
	ownedFoes = IronLibrary`MechanicsHelpers`foes[args];
	If[AssociationQ[ownedFoes], IronLibrary`DisplayHelpers`displayProgressObjectCards["Foe", ownedFoes]];
	ownedFoes
];

failures[args___] := Module[{track},
	track = IronLibrary`MechanicsHelpers`failures[args];
	If[AssociationQ[track], IronLibrary`DisplayHelpers`displayProgressObjectCard["Failures", track]];
	track
];

bondProgress[args___] := Module[{track},
	track = IronLibrary`MechanicsHelpers`bondProgress[args];
	If[AssociationQ[track], IronLibrary`DisplayHelpers`displayProgressObjectCard["Bonds", track]];
	track
];

bond[args___] := Module[{ownedBond},
	ownedBond = IronLibrary`MechanicsHelpers`bond[args];
	If[StringQ[ownedBond], IronLibrary`DisplayHelpers`displayBondCards[{ownedBond}]];
	ownedBond
];

bonds[args___] := Module[{ownedBonds},
	ownedBonds = IronLibrary`MechanicsHelpers`bonds[args];
	If[ListQ[ownedBonds], IronLibrary`DisplayHelpers`displayBondCards[ownedBonds]];
	ownedBonds
];

beginScene[args___] := Module[{sceneData},
	sceneData = IronLibrary`MechanicsHelpers`beginScene[args];
	If[AssociationQ[sceneData], IronLibrary`DisplayHelpers`displayScene[sceneData]];
	sceneData
];

scene[args___] := Module[{sceneData},
	sceneData = IronLibrary`MechanicsHelpers`scene[args];
	If[AssociationQ[sceneData], IronLibrary`DisplayHelpers`displayScene[sceneData]];
	sceneData
];

markSceneCountdown[] := Module[{result, sceneData},
	result = IronLibrary`MechanicsHelpers`markSceneCountdown[];
	If[result === $Failed, Return[$Failed]];
	sceneData = IronLibrary`MechanicsHelpers`scene[];
	If[AssociationQ[sceneData], IronLibrary`DisplayHelpers`displayScene[sceneData]];
	result
];

markSceneCountdown[n_Integer?NonNegative] := Module[{result, sceneData},
	result = IronLibrary`MechanicsHelpers`markSceneCountdown[n];
	If[result === $Failed, Return[$Failed]];
	sceneData = IronLibrary`MechanicsHelpers`scene[];
	If[AssociationQ[sceneData], IronLibrary`DisplayHelpers`displayScene[sceneData]];
	result
];

markSceneCountdown[n_Integer?NonNegative, character_] := Module[{result, sceneData},
	result = IronLibrary`MechanicsHelpers`markSceneCountdown[n, character];
	If[result === $Failed, Return[$Failed]];
	sceneData = IronLibrary`MechanicsHelpers`scene[character];
	If[AssociationQ[sceneData], IronLibrary`DisplayHelpers`displayScene[sceneData]];
	result
];

markSceneCountdown[args___] :=
	IronLibrary`MechanicsHelpers`markSceneCountdown[args];

delve[args___] := Module[{ownedDelve},
	ownedDelve = IronLibrary`MechanicsHelpers`delve[args];
	If[AssociationQ[ownedDelve], IronLibrary`DisplayHelpers`displayDelve[ownedDelve]];
	ownedDelve
];

delves[args___] := Module[{ownedDelves},
	ownedDelves = IronLibrary`MechanicsHelpers`delves[args];
	If[AssociationQ[ownedDelves], IronLibrary`DisplayHelpers`displayDelves[ownedDelves]];
	ownedDelves
];

riskZone[] :=
	displayDelveRiskZone[IronLibrary`MechanicsHelpers`currentDelveData[]];

riskZone[delveName_String] :=
	displayDelveRiskZone[IronLibrary`MechanicsHelpers`delve[delveName]];

riskZone[delveName_String, character_] :=
	displayDelveRiskZone[IronLibrary`MechanicsHelpers`delve[delveName, character]];

returnToSite[args___] := Module[{roll},
	roll = IronLibrary`MechanicsHelpers`returnToSite[args];
	If[AssociationQ[roll], IronLibrary`DisplayHelpers`displayReturnToSiteRoll[roll]];
	roll
];

denizens[] :=
	displayDenizensFromDelve[IronLibrary`MechanicsHelpers`currentDelveData[]];

denizens[delveName_String] :=
	displayDenizensFromDelve[IronLibrary`MechanicsHelpers`delve[delveName]];

denizens[delveName_String, character_] :=
	displayDenizensFromDelve[IronLibrary`MechanicsHelpers`delve[delveName, character]];

rollDenizen[args___] := Module[{roll},
	roll = IronLibrary`MechanicsHelpers`rollDenizen[args];
	If[AssociationQ[roll], IronLibrary`DisplayHelpers`displayDenizenRoll[roll["delveName"], roll]];
	roll
];


(* ::Subsection::Closed:: *)
(*Displayed mutations and rolls*)


Options[addAsset] = {Display -> True};

addAsset[args___] := Module[{ownedAsset},
	ownedAsset = IronLibrary`MechanicsHelpers`addAsset[args];
	If[AssociationQ[ownedAsset] && displayRequested[True, args], IronLibrary`DisplayHelpers`displayAssetCard[ownedAsset, "Added Asset"]];
	ownedAsset
];

Options[upgradeAsset] = {Display -> True};

upgradeAsset[args___] := Module[{ownedAsset},
	ownedAsset = IronLibrary`MechanicsHelpers`upgradeAsset[args];
	If[AssociationQ[ownedAsset] && displayRequested[True, args], IronLibrary`DisplayHelpers`displayAssetCard[ownedAsset, "Upgraded Asset"]];
	ownedAsset
];

Options[removeAsset] = {Display -> True};

removeAsset[args___] := Module[{ownedAsset},
	ownedAsset = IronLibrary`MechanicsHelpers`removeAsset[args];
	If[AssociationQ[ownedAsset] && displayRequested[True, args], IronLibrary`DisplayHelpers`displayAssetCard[ownedAsset, "Removed Asset"]];
	ownedAsset
];

Options[setCompanionHealth] = {Display -> True};

setCompanionHealth[name_String, value_Integer, args___] := Module[{result, ownedCompanion},
	result = IronLibrary`MechanicsHelpers`setCompanionHealth[name, value, args];
	If[result =!= $Failed && displayRequested[True, args],
		ownedCompanion = companionForDisplay[name, args];
		If[AssociationQ[ownedCompanion], IronLibrary`DisplayHelpers`displayAssetCard[ownedCompanion, "Companion Health"]]
	];
	result
];

Options[adjustCompanionHealth] = {Display -> True};

adjustCompanionHealth[name_String, delta_Integer, args___] := Module[{result, ownedCompanion},
	result = IronLibrary`MechanicsHelpers`adjustCompanionHealth[name, delta, args];
	If[result =!= $Failed && displayRequested[True, args],
		ownedCompanion = companionForDisplay[name, args];
		If[AssociationQ[ownedCompanion], IronLibrary`DisplayHelpers`displayAssetCard[ownedCompanion, "Companion Health"]]
	];
	result
];

Options[addRarity] = {Display -> True};

addRarity[args___] := Module[{ownedAsset},
	ownedAsset = IronLibrary`MechanicsHelpers`addRarity[args];
	If[AssociationQ[ownedAsset] && displayRequested[True, args], IronLibrary`DisplayHelpers`displayAssetCard[ownedAsset, "Added Rarity"]];
	ownedAsset
];

Options[removeRarity] = {Display -> True};

removeRarity[args___] := Module[{ownedAsset},
	ownedAsset = IronLibrary`MechanicsHelpers`removeRarity[args];
	If[AssociationQ[ownedAsset] && displayRequested[True, args], IronLibrary`DisplayHelpers`displayAssetCard[ownedAsset, "Removed Rarity"]];
	ownedAsset
];

Options[actionRoll] = {Adds -> Association[], Display -> True};

actionRoll[args___] := Module[{roll},
	roll = IronLibrary`MechanicsHelpers`actionRoll[args];
	If[AssociationQ[roll] && displayRequested[True, args], IronLibrary`DisplayHelpers`displayActionRoll[roll]];
	roll
];

Options[burnMomentum] = {Display -> True};

burnMomentum[args___] := Module[{burn},
	burn = IronLibrary`MechanicsHelpers`burnMomentum[args];
	If[AssociationQ[burn] && displayRequested[True, args], IronLibrary`DisplayHelpers`displayMomentumBurn[burn]];
	burn
];

Options[rarityDieSix] = {Display -> True};

rarityDieSix[args___] := Module[{roll},
	roll = IronLibrary`MechanicsHelpers`rarityDieSix[args];
	If[AssociationQ[roll] && displayRequested[True, args], IronLibrary`DisplayHelpers`displayRarityDieSix[roll]];
	roll
];

Options[progressRoll] = {Display -> True};

progressRoll[args___] := Module[{roll},
	roll = IronLibrary`MechanicsHelpers`progressRoll[args];
	If[AssociationQ[roll] && displayRequested[True, args], IronLibrary`DisplayHelpers`displayProgressRoll[roll]];
	roll
];

Options[reroll] = {Display -> True};

reroll[args___] := Module[{roll},
	roll = IronLibrary`MechanicsHelpers`reroll[args];
	If[AssociationQ[roll] && displayRequested[True, args], IronLibrary`DisplayHelpers`displayReroll[roll]];
	roll
];


(* ::Subsection::Closed:: *)
(*Oracle composition*)


askTheOracle["Reveal a Danger"] := Module[{ownedDelve},
	ownedDelve = IronLibrary`MechanicsHelpers`currentDelveDataQuiet[];
	If[AssociationQ[ownedDelve],
		IronLibrary`DisplayHelpers`displayOracleQuery["Reveal a Danger", ownedDelve],
		IronLibrary`DisplayHelpers`displayOracleQuery["Reveal a Danger"]
	]
];

askTheOracle["Delve Site Feature"] := Module[{ownedDelve},
	ownedDelve = IronLibrary`MechanicsHelpers`currentDelveData[];
	If[ownedDelve === $Failed, Return[$Failed]];
	IronLibrary`DisplayHelpers`displayOracleQuery["Delve Site Feature", ownedDelve]
];

askTheOracle["Delve Site Name"] := Module[{ownedDelve},
	ownedDelve = IronLibrary`MechanicsHelpers`currentDelveData[];
	If[ownedDelve === $Failed, Return[$Failed]];
	IronLibrary`DisplayHelpers`displayOracleQuery["Delve Site Name", ownedDelve]
];

askTheOracle[args___] :=
	IronLibrary`DisplayHelpers`displayOracleQuery[args];


(* ::Subsection::Closed:: *)
(*Private context footer*)


Clear[
	installHelperWrapper,
	installHelperWrappers,
	installMoveHeaderWrapper,
	installMoveRollWrapper,
	$mechanicsPassThroughAPI,
	$moveHeaderAPI,
	$moveRollAPI,
	$ironLibraryHelperDirectory
];

End[];


(* ::Section::Closed:: *)
(*Package footer*)


EndPackage[];
