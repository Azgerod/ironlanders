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
"createCharacter[name, {a1, a2, a3}, edge, heart, iron, shadow, wits, starterVow[...], {b1, b2, b3}] creates a character and sets it as the solo character. Starting assets may be asset name strings when the card has a printed default selected ability, or starterAsset[...] specs.";


(* ::Subsection::Closed:: *)
(*Vow management*)


starterVow::usage =
"starterVow[name, rank] creates a quiet starting vow spec.
starterVow[name, rank, Threat -> {threatName, threatGoal}] creates a quiet starting vow spec with one attached threat.";

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

threat::usage =
"threat[vowName] displays the threat attached to vowName for the solo character and returns a threat progress handle.
threat[vowName, character] displays the threat attached to vowName for character and returns a threat progress handle.";


(* ::Subsection::Closed:: *)
(*Debility management*)


markDebility::usage =
"markDebility[debility] marks debility for the solo character.
markDebility[debility, character] marks debility for character.";

clearDebility::usage =
"clearDebility[debility] clears debility for the solo character.
clearDebility[debility, character] clears debility for character. Maimed and Corrupted cannot be cleared.";


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


(* ::Section::Closed:: *)
(*Private context header*)


Begin["`Private`"]; 


(* ::Section:: *)
(*Private helpers*)


(* ::Text:: *)
(*The following code implements the public interface above.*)


(* ::Subsection::Closed:: *)
(*Package bootstrap*)


(* ::Subsubsection::Closed:: *)
(*Library path variable*)


If[ !ValueQ[$IronLibraryPath], $IronLibraryPath = If[StringQ[$InputFileName] && $InputFileName =!= "", $InputFileName, $Failed]]; 


(* ::Subsubsection::Closed:: *)
(*Library directory variable*)


ironLibraryDirectory[] := DirectoryName[$IronLibraryPath];


(* ::Subsubsection::Closed:: *)
(*Imports*)


Get[FileNameJoin[{ironLibraryDirectory[], "MoveData.wl"}]];
Get[FileNameJoin[{ironLibraryDirectory[], "AssetData.wl"}]];
Get[FileNameJoin[{ironLibraryDirectory[], "OracleTables.wl"}]];


(* ::Subsubsection::Closed:: *)
(*Name normalization*)


normalizeName[s_String] := Module[{name}, name = ToLowerCase[StringTrim[s]]; name = StringReplace[name, {WhitespaceCharacter.. -> "_", "-" -> "_"}]; name = StringReplace[name, "_".. -> "_"]; 
     StringTrim[name, "_"]]; 


(* ::Subsubsection::Closed:: *)
(*Display naming*)


titleCaseName[s_String] := StringRiffle[Capitalize /@ StringSplit[StringReplace[StringTrim[s], {"_" -> " ", "-" -> " "}], WhitespaceCharacter..], " "]; 


(* ::Subsection::Closed:: *)
(*Core naming and state model helpers*)


(* ::Subsubsection::Closed:: *)
(*State initialization*)


newState[] := newState[Automatic]; 
newState[seed_] := $state = Association["seed" -> Replace[seed, Automatic :> RandomInteger[{1, 2^31 - 1}]]];
ensureStateInitialized[] := Module[{base, seed}, If[AssociationQ[$state], Return[$state]]; base = currentNotebookBase[]; 
     seed = If[StringQ[base] && Quiet[parseNotebookBase[base] =!= $Failed, parseNotebookBase::badname], chapterSeedFromBase[base], Automatic]; newState[seed]; If[seed =!= Automatic, seedChapter[]]; 
     $state]; 


(* ::Subsubsection::Closed:: *)
(*Symbol to string conversion*)


symString[symbol_] := ToLowerCase[SymbolName[symbol]]; 


(* ::Subsubsection::Closed:: *)
(*Constants*)


stats = {Edge, Heart, Iron, Shadow, Wits, Health, Spirit, Supply}; 
ranks = {Troublesome, Dangerous, Formidable, Extreme, Epic};
debilities = {Wounded, Shaken, Unprepared, Encumbered, Maimed, Corrupted, Cursed, Tormented};
permanentDebilities = {Maimed, Corrupted};
delveThemes = {"Ancient", "Corrupted", "Fortified", "Hallowed", "Haunted", "Infested", "Ravaged", "Wild"};
delveDomains = {"Barrow", "Cavern", "Frozen Cavern", "Icereach", "Mine", "Pass", "Ruin", "Sea Cave", "Shadowfen", "Stronghold", "Tanglewood", "Underkeep"};
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
denizenSlotThresholds = {27, 41, 55, 69, 75, 81, 87, 93, 95, 97, 99, 100};


(* ::Subsubsection::Closed:: *)
(*Argument tests*)


statQ[input_] := MemberQ[stats, input]; 
rankQ[input_] := MemberQ[ranks, input]; 
statValueQ[input_Integer] := 1 <= input <= 5; 
debilityQ[input_] := MemberQ[debilities, input];
delveThemeQ[input_String] := MemberQ[delveThemes, input];
delveDomainQ[input_String] := MemberQ[delveDomains, input];


(* ::Subsubsection::Closed:: *)
(*Progress tracks*)


makeProgressTrack[(rank_)?rankQ, progress_:0] := 
   Association["rank" -> rank, "progress" -> progress];
progressRollResult = actionRollResult;


(* ::Subsubsection::Closed:: *)
(*Attribute getters*)


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
(*State bounds and debility helpers*)


resourceLabel["health"] := "Health";
resourceLabel["spirit"] := "Spirit";
resourceLabel["supply"] := "Supply";
resourceLabel["momentum"] := "Momentum";

resourceBounds["health", _] := {0, 5};
resourceBounds["spirit", _] := {0, 5};
resourceBounds["supply", _] := {0, 5};
resourceBounds["momentum", character_] := {-6, getMomentumMax[character]};

recoveryBlockingDebility["health"] := Wounded;
recoveryBlockingDebility["spirit"] := Shaken;
recoveryBlockingDebility["supply"] := Unprepared;
recoveryBlockingDebility[_] := None;

debilityLabel[debility_] :=
	SymbolName[Unevaluated[debility]];

ensureCharacterState[character_] :=
	If[characterExistsQ[character],
		True,
		Message[state::nochar, character];
		False
	];

clampValue[value_, {min_, max_}] :=
	Min[Max[value, min], max];

setBoundedAttr[attr_String, value_Integer, character_] := Module[
	{bounds, clamped},
	If[!ensureCharacterState[character], Return[$Failed]];
	bounds = resourceBounds[attr, character];
	clamped = clampValue[value, bounds];
	If[value =!= clamped,
		Message[state::clamped, resourceLabel[attr], character, value, clamped]
	];
	$state[character, attr] = clamped
];

enforceMomentumBounds[character_] := Module[
	{current},
	If[!ensureCharacterState[character], Return[$Failed]];
	current = getMomentum[character];
	setBoundedAttr["momentum", current, character]
];

adjustBoundedAttr[attr_String, n_Integer, character_] := Module[
	{current, requested, clamped, block, bounds},
	If[!ensureCharacterState[character], Return[$Failed]];
	current = getAttr[attr, character];
	block = recoveryBlockingDebility[attr];
	If[n > 0 && block =!= None && MemberQ[getDebilities[character], block],
		Message[state::blocked, resourceLabel[attr], debilityLabel[block], character];
		Return[current]
	];
	requested = current + n;
	bounds = resourceBounds[attr, character];
	clamped = clampValue[requested, bounds];
	If[requested =!= clamped,
		Message[state::clamped, resourceLabel[attr], character, requested, clamped]
	];
	$state[character, attr] = clamped;
	If[attr === "supply" && current > 0 && clamped === 0,
		Message[state::supplyzero, character]
	];
	If[attr === "momentum" && clamped === -6 && (current > -6 || requested < -6),
		Message[state::momentummin, character]
	];
	clamped
];

state::nochar = "No character named `1` exists in the current state.";
state::blocked = "Cannot increase `1` while `2` is marked for character `3`.";
state::clamped = "`1` for character `2` was clamped from `3` to `4`.";
state::supplyzero = "Supply has reached zero for character `1`.";
state::momentummin = "Momentum has reached its minimum for character `1`.";


(* ::Subsubsection::Closed:: *)
(*Attribute adjusters and setters*)


resetMomentum[character_:$soloCharacter] :=
	$state[character, "momentum"] = getMomentumReset[character];

adjustMomentum[n_Integer, character_ : $soloCharacter] :=
	adjustBoundedAttr["momentum", n, character];

adjustHealth[n_Integer, character_ : $soloCharacter] :=
	adjustBoundedAttr["health", n, character];

adjustSpirit[n_Integer, character_ : $soloCharacter] :=
	adjustBoundedAttr["spirit", n, character];

adjustSupply[n_Integer, character_ : $soloCharacter] :=
	adjustBoundedAttr["supply", n, character];


(* ::Subsubsection::Closed:: *)
(*Progress track getters*)


getProgress[trackName_String, character_:$soloCharacter] := Module[
	{target},
	target = progressTargetData[trackName, character];
	If[target === $Failed, Return[$Failed]];
	target["Progress"]
];
getRank[trackName_String, character_:$soloCharacter] := Module[
	{target},
	target = progressTargetData[trackName, character];
	If[target === $Failed, Return[$Failed]];
	target["Rank"]
];


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
(*Chapter seeding*)


chapterSeedFromBase[base_String] := Abs[Hash[{"IronLibrary", "chapter-seed", base}]]; 
seedChapter[] := Module[{seed}, If[ !AssociationQ[$state] ||  !KeyExistsQ[$state, "seed"], Message[seedChapter::noseed]; Return[$Failed]]; seed = $state["seed"]; SeedRandom[seed]; seed]; 
seedChapter::noseed = "The current state does not contain a seed."; 
seedStoryState[base_String] := Module[
	{seed},
	seed = chapterSeedFromBase[base];
	If[
		AssociationQ[$state],
		$state["seed"] = seed,
		newState[seed]
	];
	seedChapter[]
];
nextChapterSeed[] := Module[{base}, base = nextNotebookBase[]; If[base === $Failed, Return[$Failed]]; chapterSeedFromBase[base]]; 
stateForNextChapter[] := Module[{next, seed}, seed = nextChapterSeed[]; If[seed === $Failed, Return[$Failed]]; next = Association[$state]; next["seed"] = seed; next]; 


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
     If[newBase === oldBase && samePathQ[newStoryDir, oldStoryDir], seedStoryState[newBase]; 
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
     seedStoryState[newBase]; ensureChapterOneBoilerplate[]; 
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


(* ::Subsection::Closed:: *)
(*Roll and oracle mechanics*)


(* ::Subsubsection::Closed:: *)
(*Rolling dice*)


rollChallengeDice[] := RandomInteger[{1, 10}, 2]; 
rollActionDie[] := RandomInteger[{1, 6}]; 
rollResultFromBeatCount[count_Integer] :=
	<|0 -> "miss", 1 -> "weakHit", 2 -> "strongHit"|>[count];

actionRollResult[challengeDice_List, actionScore_Integer] :=
	rollResultFromBeatCount[
		Count[challengeDice, die_ /; actionScore > die]
	];
rollOracleDice = rollChallengeDice;


(* ::Subsubsection::Closed:: *)
(*Oracle roll helpers*)


oracleRollValue[{tensDie_Integer, onesDie_Integer}]:=Module[{tensValue, onesValue},
	tensValue = If[tensDie==10, 0, tensDie*10];
	onesValue = If[onesDie==10, 0, onesDie];
	If[tensDie==onesDie==10, 100, tensValue+onesValue]
];
oracleRollOutcome[table_Association, value_Integer] := Module[{key},
	key = First[Select[Sort[Keys[table]], # >= value &]];
	table[key]
];

oracleRollData[table_Association] := Module[{oracleDice, od1, od2, value, outcome, match},
	oracleDice = {od1, od2} = rollOracleDice[];
	value = oracleRollValue[oracleDice];
	outcome = oracleRollOutcome[table, value];
	match = (od1==od2);
	<|"oracleDice" -> oracleDice, "value" -> value, "outcome" -> outcome, "match" -> match|>
];

oracleRoll[tableName_String, table_Association] := Module[{roll},
	roll = oracleRollData[table];
	displayOracleRoll[tableName, roll["oracleDice"], roll["match"], roll["outcome"]];
	roll
];



(* ::Subsubsection::Closed:: *)
(*Roll type predicates and reroll support*)


actionRollQ[roll_Association] :=
	KeyExistsQ[roll, "actionDie"] &&
	KeyExistsQ[roll, "actionScore"] &&
	KeyExistsQ[roll, "challengeDice"];

progressRollQ[roll_Association] :=
	KeyExistsQ[roll, "progressScore"] &&
	KeyExistsQ[roll, "challengeDice"] &&
	!KeyExistsQ[roll, "actionDie"];

rollQ[roll_Association] :=
	actionRollQ[roll] || progressRollQ[roll];

rerollSelectionQ[ActionDie] := True;
rerollSelectionQ[ChallengeDice] := True;
rerollSelectionQ[LargerChallengeDie] := True;
rerollSelectionQ[SmallerChallengeDie] := True;
rerollSelectionQ[_] := False;

challengeDieIndex[LargerChallengeDie, challengeDice_List] :=
	First @ FirstPosition[challengeDice, Max[challengeDice]];

challengeDieIndex[SmallerChallengeDie, challengeDice_List] :=
	First @ FirstPosition[challengeDice, Min[challengeDice]];

normalizeRerollSelection[die_] :=
	normalizeRerollSelection[{die}];

normalizeRerollSelection[dice_List] :=
	DeleteDuplicates[dice];

rerollChallengeDieIndices[selection_List, challengeDice_List] := Module[{indices},
	indices = {};

	If[MemberQ[selection, ChallengeDice],
		indices = Join[indices, {1, 2}]
	];

	If[
		MemberQ[selection, LargerChallengeDie] &&
		MemberQ[selection, SmallerChallengeDie],
		indices = Join[indices, {1, 2}],
		If[MemberQ[selection, LargerChallengeDie],
			AppendTo[indices, challengeDieIndex[LargerChallengeDie, challengeDice]]
		];

		If[MemberQ[selection, SmallerChallengeDie],
			AppendTo[indices, challengeDieIndex[SmallerChallengeDie, challengeDice]]
		]
	];

	DeleteDuplicates[indices]
];

reroll::baddie =
"`1` is not a valid reroll selection. Use ActionDie, ChallengeDice, LargerChallengeDie, or SmallerChallengeDie.";

reroll::badroll =
"`1` is not an action roll or progress roll association.";

reroll::actiondie =
"ActionDie can only be rerolled in an action roll.";

reroll::empty =
"No dice were specified for reroll.";

reroll::badchallenge =
"Could not determine which challenge die to reroll from selection `1`.";


(* ::Subsection:: *)
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


(* ::Subsection:: *)
(*Asset helpers*)


assetDataAssociation[] := AssetData`assetData;

assetNames[] :=
	Keys[assetDataAssociation[]];

assetCategories[] :=
	DeleteDuplicates[Lookup[Values[assetDataAssociation[]], "Category"]];

assetRecord[name_String] :=
	Lookup[assetDataAssociation[], name, Missing["UnknownAsset", name]];

assetRecordQ[name_String] :=
	AssociationQ[assetRecord[name]];

assetAbilityIndices[record_Association] :=
	Lookup[Lookup[record, "Abilities", {}], "Index", {}];

defaultAssetAbilities[record_Association] :=
	Lookup[record, "DefaultAbilities", {}];

assetFieldKeys[record_Association] :=
	Keys[Lookup[record, "Fields", <||>]];

initialAssetTracks[record_Association] :=
	Association @ KeyValueMap[
		#1 -> Lookup[#2, "Default", Lookup[#2, "Max", 0]] &,
		Lookup[record, "Tracks", <||>]
	];

normalizeAbilitySelection[Automatic, record_Association] := Module[
	{defaults},
	defaults = defaultAssetAbilities[record];
	If[defaults === {},
		Message[asset::nodefault, record["Name"]];
		Return[$Failed]
	];
	defaults
];

normalizeAbilitySelection[ability_Integer, record_Association] :=
	normalizeAbilitySelection[{ability}, record];

normalizeAbilitySelection[abilities_List, record_Association] /; VectorQ[abilities, IntegerQ] && abilities =!= {} := Module[
	{valid, duplicates, invalid},
	valid = assetAbilityIndices[record];
	duplicates = DeleteDuplicates[Cases[Tally[abilities], {ability_, count_} /; count > 1 :> ability]];
	If[duplicates =!= {},
		Message[asset::dupeability, First[duplicates], record["Name"]];
		Return[$Failed]
	];
	invalid = Select[abilities, !MemberQ[valid, #] &];
	If[invalid =!= {},
		Message[asset::badability, First[invalid], record["Name"], Length[valid]];
		Return[$Failed]
	];
	Sort[abilities]
];

normalizeAbilitySelection[_, record_Association] := (
	Message[asset::badabilities, record["Name"]];
	$Failed
);

normalizeAssetFields[fields_Association, record_Association] := Module[
	{keys, invalid, blankFields},
	keys = assetFieldKeys[record];
	invalid = Complement[Keys[fields], keys];
	If[invalid =!= {},
		Message[asset::badfield, First[invalid], record["Name"]];
		Return[$Failed]
	];
	blankFields = AssociationThread[keys -> ConstantArray["", Length[keys]]];
	Join[blankFields, fields]
];

normalizeAssetFields[_, record_Association] := (
	Message[asset::badfields, record["Name"]];
	$Failed
);

makeOwnedAsset[name_String, abilitySpec_, fields_Association] := Module[
	{record, abilities, normalizedFields},
	record = assetRecord[name];
	If[!AssociationQ[record],
		Message[asset::unknown, name];
		Return[$Failed]
	];
	abilities = normalizeAbilitySelection[abilitySpec, record];
	If[abilities === $Failed, Return[$Failed]];
	normalizedFields = normalizeAssetFields[fields, record];
	If[normalizedFields === $Failed, Return[$Failed]];
		Association[
			"Name" -> record["Name"],
			"Abilities" -> abilities,
			"Fields" -> normalizedFields,
			"Tracks" -> initialAssetTracks[record],
			"Rarity" -> None
		]
	];

makeStarterAssetSpec[name_String, abilitySpec_, fields_Association] := Module[
	{owned},
	owned = makeOwnedAsset[name, abilitySpec, fields];
	If[owned === $Failed, Return[$Failed]];
	StarterAssetSpec[
		Association[
			"Name" -> owned["Name"],
			"Abilities" -> owned["Abilities"],
			"Fields" -> owned["Fields"]
		]
	]
];

ownedAssetFromSpec[$Failed] :=
	$Failed;

ownedAssetFromSpec[name_String] :=
	makeOwnedAsset[name, Automatic, <||>];

ownedAssetFromSpec[StarterAssetSpec[data_Association]] :=
	makeOwnedAsset[data["Name"], data["Abilities"], Lookup[data, "Fields", <||>]];

ownedAssetFromSpec[other_] := (
	Message[asset::badasset, other];
	$Failed
);

ownedAssetQ[owned_Association] :=
	KeyExistsQ[owned, "Name"] &&
	KeyExistsQ[owned, "Abilities"] &&
	KeyExistsQ[owned, "Fields"] &&
	KeyExistsQ[owned, "Tracks"];

characterExistsQ[character_] :=
	AssociationQ[$state] &&
	StringQ[character] &&
	KeyExistsQ[$state, character];

normalizeCharacterAssets[character_] := Module[
	{rawAssets, normalizedAssets},
	If[!characterExistsQ[character],
		Message[asset::nochar, character];
		Return[$Failed]
	];
	rawAssets = Lookup[$state[character], "assets", {}];
	If[AllTrue[rawAssets, ownedAssetQ],
		$state[character, "assets"] = Association[#, "Rarity" -> Lookup[#, "Rarity", None]] & /@ rawAssets;
		Return[$state[character, "assets"]]
	];
	normalizedAssets = ownedAssetFromSpec /@ rawAssets;
	If[MemberQ[normalizedAssets, $Failed],
		Message[asset::badstoredassets, character];
		Return[$Failed]
	];
	$state[character, "assets"] = normalizedAssets
];

ownedAssetIndex[assetName_String, character_] := Module[
	{ownedAssets, positions},
	ownedAssets = normalizeCharacterAssets[character];
	If[ownedAssets === $Failed, Return[$Failed]];
	positions = Flatten @ Position[Lookup[ownedAssets, "Name", Missing["NoName"]], assetName];
	If[positions === {},
		Missing["NotOwned", assetName],
		First[positions]
	]
];

availableExperience[character_] :=
	Lookup[$state[character], "earnedExperience", 0] -
	Lookup[$state[character], "spentExperience", 0];

assetTrackDefinition[record_Association, trackName_String] :=
	Lookup[Lookup[record, "Tracks", <||>], trackName, Missing["UnknownTrack", trackName]];

clampAssetTrackValue[trackDef_Association, value_Integer] :=
	Clip[value, {trackDef["Min"], trackDef["Max"]}];

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

displayAssetCards[cards_List] :=
	Print[Column[cards, Spacings -> 1, Alignment -> Left]];


(* ::Subsection::Closed:: *)
(*Vow helpers*)


rankMarkValue[Troublesome] := 3;
rankMarkValue[Dangerous] := 2;
rankMarkValue[Formidable] := 1;
rankMarkValue[Extreme] := 0.5;
rankMarkValue[Epic] := 0.25;

makeProgressObject[name_String, rank_?rankQ, progress_:0] :=
	Association[
		"Name" -> name,
		"Rank" -> rank,
		"Progress" -> clampValue[progress, {0, 10}]
	];

normalizeProgressObject[name_String, data_, defaultRank_?rankQ, defaultProgress_:0] := Module[
	{objectName, rank, progress},
	If[!AssociationQ[data],
		Return[makeProgressObject[name, defaultRank, defaultProgress]]
	];
	objectName = Lookup[data, "Name", name];
	If[!StringQ[objectName], objectName = name];
	rank = Lookup[data, "Rank", Lookup[data, "rank", defaultRank]];
	If[!rankQ[rank], rank = defaultRank];
	progress = Lookup[data, "Progress", Lookup[data, "progress", defaultProgress]];
	If[!NumericQ[progress], progress = defaultProgress];
	makeProgressObject[objectName, rank, progress]
];

normalizeProgressObject[name_String, data_] :=
	normalizeProgressObject[name, data, Dangerous, 0];

legacyProgressTrack[character_, name_String] := Module[
	{legacy},
	legacy = Lookup[$state[character], "progressTracks", <||>];
	If[AssociationQ[legacy], Lookup[legacy, name, Missing["NoLegacyTrack"]], Missing["NoLegacyTrack"]]
];

ensureCharacterCoreProgress[character_] := Module[
	{legacyFailures, legacyBonds, bondDefault},
	If[!characterExistsQ[character],
		Message[state::nochar, character];
		Return[$Failed]
	];
	legacyFailures = legacyProgressTrack[character, "Failures"];
	If[!KeyExistsQ[$state[character], "failures"],
		$state[character, "failures"] = normalizeProgressObject[
			"Failures",
			If[MissingQ[legacyFailures], makeProgressTrack[Epic], legacyFailures],
			Epic
		],
		$state[character, "failures"] = normalizeProgressObject["Failures", $state[character, "failures"], Epic]
	];
	legacyBonds = legacyProgressTrack[character, "Bonds"];
	bondDefault = 0.25 Length[Lookup[$state[character], "bonds", {}]];
	If[!KeyExistsQ[$state[character], "bondProgress"],
		$state[character, "bondProgress"] = normalizeProgressObject[
			"Bonds",
			If[MissingQ[legacyBonds], makeProgressTrack[Epic, bondDefault], legacyBonds],
			Epic,
			bondDefault
		],
		$state[character, "bondProgress"] = normalizeProgressObject["Bonds", $state[character, "bondProgress"], Epic, bondDefault]
	];
	If[!KeyExistsQ[$state[character], "journeys"] || !AssociationQ[$state[character, "journeys"]],
		$state[character, "journeys"] = <||>
	];
	If[!KeyExistsQ[$state[character], "currentJourney"],
		$state[character, "currentJourney"] = None
	];
	If[!KeyExistsQ[$state[character], "foes"] || !AssociationQ[$state[character, "foes"]],
		$state[character, "foes"] = <||>
	];
	If[KeyExistsQ[$state[character], "progressTracks"],
		$state[character] = KeyDrop[$state[character], "progressTracks"]
	];
	$state[character]
];

normalizeProgressObjectAssociation[character_, key_String] := Module[
	{raw, normalized},
	If[ensureCharacterCoreProgress[character] === $Failed, Return[$Failed]];
	raw = Lookup[$state[character], key, <||>];
	If[!AssociationQ[raw], raw = <||>];
	normalized = Association @ KeyValueMap[
		#1 -> normalizeProgressObject[#1, #2] &,
		raw
	];
	$state[character, key] = normalized;
	normalized
];

journeyExistsQ[name_String, character_] := Module[
	{ownedJourneys},
	ownedJourneys = normalizeCharacterJourneys[character];
	If[ownedJourneys === $Failed, Return[False]];
	KeyExistsQ[ownedJourneys, name]
];

journeyByName[name_String, character_] := Module[
	{ownedJourneys},
	ownedJourneys = normalizeCharacterJourneys[character];
	If[ownedJourneys === $Failed, Return[$Failed]];
	Lookup[ownedJourneys, name, Missing["UnknownJourney", name]]
];

currentJourneyName[character_] := Module[
	{ownedJourneys, current},
	ownedJourneys = normalizeCharacterJourneys[character];
	If[ownedJourneys === $Failed, Return[$Failed]];
	current = Lookup[$state[character], "currentJourney", None];
	If[current === None,
		Message[journey::nocurrent, character];
		Return[$Failed]
	];
	If[!KeyExistsQ[ownedJourneys, current],
		Message[journey::unknown, current, character];
		Return[$Failed]
	];
	current
];

currentJourneyData[character_] := Module[
	{current},
	current = currentJourneyName[character];
	If[current === $Failed, Return[$Failed]];
	journeyByName[current, character]
];

foeExistsQ[name_String, character_] := Module[
	{ownedFoes},
	ownedFoes = normalizeCharacterFoes[character];
	If[ownedFoes === $Failed, Return[False]];
	KeyExistsQ[ownedFoes, name]
];

foeByName[name_String, character_] := Module[
	{ownedFoes},
	ownedFoes = normalizeCharacterFoes[character];
	If[ownedFoes === $Failed, Return[$Failed]];
	Lookup[ownedFoes, name, Missing["UnknownFoe", name]]
];

failureProgressData[character_] := Module[{},
	If[ensureCharacterCoreProgress[character] === $Failed, Return[$Failed]];
	$state[character, "failures"]
];

bondProgressData[character_] := Module[{},
	If[ensureCharacterCoreProgress[character] === $Failed, Return[$Failed]];
	$state[character, "bondProgress"]
];

normalizeThreatSpec[None] :=
	None;

normalizeThreatSpec[{name_String, goal_String}] :=
	Association[
		"Name" -> name,
		"Goal" -> goal,
		"Menace" -> makeProgressTrack[Formidable]
	];

normalizeThreatSpec[threatData_Association] /; threatAssociationQ[threatData] :=
	threatData;

normalizeThreatSpec[other_] := (
	Message[vow::badthreat, other];
	$Failed
);

makeVow[name_String, rank_?rankQ, threatSpec_] := Module[
	{normalizedThreat},
	normalizedThreat = normalizeThreatSpec[threatSpec];
	If[normalizedThreat === $Failed, Return[$Failed]];
	Association[
		"Name" -> name,
		"Rank" -> rank,
		"Progress" -> 0,
		"Threat" -> normalizedThreat
	]
];

makeStarterVowSpec[name_String, rank_?rankQ, threatSpec_] := Module[
	{normalizedVow},
	normalizedVow = makeVow[name, rank, threatSpec];
	If[normalizedVow === $Failed, Return[$Failed]];
	StarterVowSpec[normalizedVow]
];

ownedVowFromSpec[StarterVowSpec[data_Association]] /; ownedVowQ[data] :=
	data;

ownedVowFromSpec[other_] := (
	Message[vow::badstarter, other];
	$Failed
);

ownedVowQ[vow_Association] :=
	KeyExistsQ[vow, "Name"] &&
	KeyExistsQ[vow, "Rank"] &&
	KeyExistsQ[vow, "Progress"] &&
	KeyExistsQ[vow, "Threat"];

normalizeCharacterVows[character_] := Module[
	{rawVows},
	If[!characterExistsQ[character],
		Message[vow::nochar, character];
		Return[$Failed]
	];
	rawVows = Lookup[$state[character], "vows", <||>];
	If[AssociationQ[rawVows] && AllTrue[Values[rawVows], ownedVowQ],
		Return[rawVows]
	];
	$state[character, "vows"] = <||>
];

vowExistsQ[vowName_String, character_] := Module[
	{ownedVows},
	ownedVows = normalizeCharacterVows[character];
	If[ownedVows === $Failed, Return[False]];
	KeyExistsQ[ownedVows, vowName]
];

vowByName[vowName_String, character_] := Module[
	{ownedVows},
	ownedVows = normalizeCharacterVows[character];
	If[ownedVows === $Failed, Return[$Failed]];
	Lookup[ownedVows, vowName, Missing["UnknownVow", vowName]]
];

threatAssociationQ[threat_Association] :=
	KeyExistsQ[threat, "Name"] &&
	KeyExistsQ[threat, "Goal"] &&
	KeyExistsQ[threat, "Menace"];

threatByVowName[vowName_String, character_] := Module[
	{ownedVow, ownedThreat},
	ownedVow = vowByName[vowName, character];
	If[!AssociationQ[ownedVow],
		Message[vow::unknown, vowName, character];
		Return[$Failed]
	];
	ownedThreat = Lookup[ownedVow, "Threat", None];
	If[ownedThreat === None,
		Message[threat::none, vowName];
		Return[$Failed]
	];
	ownedThreat
];

threatLocationByName[threatName_String, character_] := Module[
	{ownedVows, matches},
	ownedVows = normalizeCharacterVows[character];
	If[ownedVows === $Failed, Return[$Failed]];
	matches = Select[
		Keys[ownedVows],
		AssociationQ[ownedVows[#]["Threat"]] &&
			ownedVows[#]["Threat", "Name"] === threatName &
	];
	If[matches === {},
		Missing["UnknownThreat", threatName],
		First[matches]
	]
];

normalizeDelveCards[cards_String, kind_String] :=
	normalizeDelveCards[{cards}, kind];

normalizeDelveCards[cards : {__String}, "Theme"] /; 1 <= Length[cards] <= 2 := Module[
	{invalid},
	invalid = Select[cards, !delveThemeQ[#] &];
	If[invalid =!= {},
		Message[delve::badtheme, First[invalid], StringRiffle[delveThemes, ", "]];
		Return[$Failed]
	];
	cards
];

normalizeDelveCards[cards : {__String}, "Domain"] /; 1 <= Length[cards] <= 2 := Module[
	{invalid},
	invalid = Select[cards, !delveDomainQ[#] &];
	If[invalid =!= {},
		Message[delve::baddomain, First[invalid], StringRiffle[delveDomains, ", "]];
		Return[$Failed]
	];
	cards
];

normalizeDelveCards[_, kind_String] := (
	Message[delve::badcards, kind];
	$Failed
);

validateDelveCardPair[themes_List, domains_List] :=
	If[Length[themes] == 2 && Length[domains] == 2,
		Message[delve::toomanycards];
		$Failed,
		True
	];

defaultDenizens[] :=
	ConstantArray[None, 12];

normalizeDenizenSlot[None] :=
	None;

normalizeDenizenSlot[name_String] /; StringLength[StringTrim[name]] > 0 :=
	name;

normalizeDenizenSlot[_] :=
	$Failed;

normalizeDenizens[Automatic] :=
	defaultDenizens[];

normalizeDenizens[denizenSpec_List] /; Length[denizenSpec] == 12 := Module[
	{normalized},
	normalized = normalizeDenizenSlot /@ denizenSpec;
	If[MemberQ[normalized, $Failed],
		Message[delve::baddenizens];
		Return[$Failed]
	];
	normalized
];

normalizeDenizens[_] := (
	Message[delve::baddenizens];
	$Failed
);

makeDelve[name_String, rank_?rankQ, themeSpec_, domainSpec_, objective_, denizenSpec_:Automatic] := Module[
	{themes, domains, denizenList},
	themes = normalizeDelveCards[themeSpec, "Theme"];
	If[themes === $Failed, Return[$Failed]];
	domains = normalizeDelveCards[domainSpec, "Domain"];
	If[domains === $Failed, Return[$Failed]];
	If[validateDelveCardPair[themes, domains] === $Failed, Return[$Failed]];
	If[!(objective === None || StringQ[objective]),
		Message[delve::badobjective, objective];
		Return[$Failed]
	];
	denizenList = normalizeDenizens[denizenSpec];
	If[denizenList === $Failed, Return[$Failed]];
	Association[
		"Name" -> name,
		"Rank" -> rank,
		"Themes" -> themes,
		"Domains" -> domains,
		"Theme" -> First[themes],
		"Domain" -> First[domains],
		"Objective" -> objective,
		"Denizens" -> denizenList,
		"Progress" -> 0
	]
];

normalizeOwnedDelve[delve_Association] /;
	KeyExistsQ[delve, "Name"] &&
	KeyExistsQ[delve, "Rank"] &&
	KeyExistsQ[delve, "Progress"] := Module[
	{themes, domains, objective, denizenList, normalized},
	themes = Which[
		KeyExistsQ[delve, "Themes"], normalizeDelveCards[delve["Themes"], "Theme"],
		KeyExistsQ[delve, "Theme"], normalizeDelveCards[delve["Theme"], "Theme"],
		True, $Failed
	];
	If[themes === $Failed, Return[$Failed]];
	domains = Which[
		KeyExistsQ[delve, "Domains"], normalizeDelveCards[delve["Domains"], "Domain"],
		KeyExistsQ[delve, "Domain"], normalizeDelveCards[delve["Domain"], "Domain"],
		True, $Failed
	];
	If[domains === $Failed, Return[$Failed]];
	If[validateDelveCardPair[themes, domains] === $Failed, Return[$Failed]];
	objective = Lookup[delve, "Objective", None];
	If[!(objective === None || StringQ[objective]), objective = None];
	denizenList = normalizeDenizens[Lookup[delve, "Denizens", Automatic]];
	If[denizenList === $Failed, denizenList = defaultDenizens[]];
	normalized = Association[delve];
	normalized["Themes"] = themes;
	normalized["Domains"] = domains;
	normalized["Theme"] = First[themes];
	normalized["Domain"] = First[domains];
	normalized["Objective"] = objective;
	normalized["Denizens"] = denizenList;
	normalized
];

normalizeOwnedDelve[_] :=
	$Failed;

ownedDelveQ[delve_Association] :=
	AssociationQ[normalizeOwnedDelve[delve]];

normalizeCharacterDelves[character_] := Module[
	{rawDelves, normalized},
	If[!characterExistsQ[character],
		Message[delve::nochar, character];
		Return[$Failed]
	];
	rawDelves = Lookup[$state[character], "delves", <||>];
	If[AssociationQ[rawDelves],
		normalized = Association @ KeyValueMap[#1 -> normalizeOwnedDelve[#2] &, rawDelves];
		If[!MemberQ[Values[normalized], $Failed],
			$state[character, "delves"] = normalized;
			If[!KeyExistsQ[$state[character], "currentDelve"],
				$state[character, "currentDelve"] = None
			];
			Return[normalized]
		]
	];
	$state[character, "delves"] = <||>;
	$state[character, "currentDelve"] = None;
	<||>
];

delveExistsQ[name_String, character_] := Module[
	{ownedDelves},
	ownedDelves = normalizeCharacterDelves[character];
	If[ownedDelves === $Failed, Return[False]];
	KeyExistsQ[ownedDelves, name]
];

delveByName[name_String, character_] := Module[
	{ownedDelves},
	ownedDelves = normalizeCharacterDelves[character];
	If[ownedDelves === $Failed, Return[$Failed]];
	Lookup[ownedDelves, name, Missing["UnknownDelve", name]]
];

currentDelveName[character_] := Module[
	{ownedDelves, current},
	ownedDelves = normalizeCharacterDelves[character];
	If[ownedDelves === $Failed, Return[$Failed]];
	current = Lookup[$state[character], "currentDelve", None];
	If[current === None,
		Message[delve::nocurrent, character];
		Return[$Failed]
	];
	If[!KeyExistsQ[ownedDelves, current],
		Message[delve::unknown, current, character];
		Return[$Failed]
	];
	current
];

currentDelveData[character_] := Module[
	{current},
	current = currentDelveName[character];
	If[current === $Failed, Return[$Failed]];
	delveByName[current, character]
];

currentDelveDataQuiet[character_] := Module[
	{ownedDelves, current},
	If[!characterExistsQ[character], Return[None]];
	ownedDelves = normalizeCharacterDelves[character];
	If[ownedDelves === $Failed, Return[None]];
	current = Lookup[$state[character], "currentDelve", None];
	If[current === None || !KeyExistsQ[ownedDelves, current], Return[None]];
	ownedDelves[current]
];

normalizeCharacterScene[character_] := Module[
	{rawScene, normalized},
	If[!characterExistsQ[character],
		Message[scene::nochar, character];
		Return[$Failed]
	];
	rawScene = Lookup[$state[character], "scene", None];
	If[rawScene === None,
		Return[None]
	];
	If[
		AssociationQ[rawScene] &&
		KeyExistsQ[rawScene, "Name"] &&
		KeyExistsQ[rawScene, "Rank"] &&
		KeyExistsQ[rawScene, "Progress"] &&
		KeyExistsQ[rawScene, "Countdown"],
		normalized = Association[rawScene];
		normalized["Progress"] = clampValue[normalized["Progress"], {0, 10}];
		normalized["Countdown"] = clampValue[normalized["Countdown"], {0, 4}];
		$state[character, "scene"] = normalized;
		Return[normalized]
	];
	$state[character, "scene"] = None;
	None
];

sceneExistsQ[name_String, character_] := Module[
	{ownedScene},
	ownedScene = normalizeCharacterScene[character];
	If[ownedScene === $Failed || ownedScene === None, Return[False]];
	ownedScene["Name"] === name
];

sceneByName[name_String, character_] := Module[
	{ownedScene},
	ownedScene = normalizeCharacterScene[character];
	If[ownedScene === $Failed || ownedScene === None,
		Return[Missing["UnknownScene", name]]
	];
	If[ownedScene["Name"] === name, ownedScene, Missing["UnknownScene", name]]
];

progressTargetData[trackName_String, character_] := Module[
	{ownedVow, threatVowName, ownedThreat, ownedDelve, ownedScene, ownedJourney, ownedFoe, ownedFailures, ownedBondProgress},
	If[ensureCharacterCoreProgress[character] === $Failed, Return[$Failed]];
	If[vowExistsQ[trackName, character],
		ownedVow = vowByName[trackName, character];
		Return[
			Association[
				"Type" -> "Vow",
				"Name" -> trackName,
				"Rank" -> ownedVow["Rank"],
				"Progress" -> ownedVow["Progress"]
			]
		]
	];
	threatVowName = threatLocationByName[trackName, character];
	If[StringQ[threatVowName],
		ownedThreat = $state[character, "vows", threatVowName, "Threat"];
		Return[
			Association[
				"Type" -> "Threat",
				"Name" -> trackName,
				"Vow" -> threatVowName,
				"Rank" -> ownedThreat["Menace", "rank"],
				"Progress" -> ownedThreat["Menace", "progress"]
			]
		]
	];
	If[delveExistsQ[trackName, character],
		ownedDelve = delveByName[trackName, character];
		Return[
			Association[
				"Type" -> "Delve",
				"Name" -> trackName,
				"Rank" -> ownedDelve["Rank"],
				"Progress" -> ownedDelve["Progress"]
			]
		]
	];
	If[sceneExistsQ[trackName, character],
		ownedScene = sceneByName[trackName, character];
		Return[
			Association[
				"Type" -> "Scene",
				"Name" -> trackName,
				"Rank" -> ownedScene["Rank"],
				"Progress" -> ownedScene["Progress"]
			]
		]
	];
	If[journeyExistsQ[trackName, character],
		ownedJourney = journeyByName[trackName, character];
		Return[
			Association[
				"Type" -> "Journey",
				"Name" -> trackName,
				"Rank" -> ownedJourney["Rank"],
				"Progress" -> ownedJourney["Progress"]
			]
		]
	];
	If[foeExistsQ[trackName, character],
		ownedFoe = foeByName[trackName, character];
		Return[
			Association[
				"Type" -> "Foe",
				"Name" -> trackName,
				"Rank" -> ownedFoe["Rank"],
				"Progress" -> ownedFoe["Progress"]
			]
		]
	];
	If[trackName === "Failures",
		ownedFailures = failureProgressData[character];
		If[ownedFailures === $Failed, Return[$Failed]];
		Return[
			Association[
				"Type" -> "Failures",
				"Name" -> "Failures",
				"Rank" -> ownedFailures["Rank"],
				"Progress" -> ownedFailures["Progress"]
			]
		]
	];
	If[trackName === "Bonds",
		ownedBondProgress = bondProgressData[character];
		If[ownedBondProgress === $Failed, Return[$Failed]];
		Return[
			Association[
				"Type" -> "Bonds",
				"Name" -> "Bonds",
				"Rank" -> ownedBondProgress["Rank"],
				"Progress" -> ownedBondProgress["Progress"]
			]
		]
	];
	Message[markProgress::notrack, trackName, character];
	$Failed
];

formatProgressValue[value_] :=
	ToString[NumberForm[N[value], {3, 2}, NumberPadding -> {"", "0"}]];

progressSummary[label_String, rank_, progress_] :=
	Row[
		{
			Style[
				StringJoin[label, ": "],
				FontFamily -> "Futura",
				FontSize -> scaledSize[16],
				FontWeight -> Bold,
				GrayLevel[0.255]
			],
			moveTextStyle[
				StringJoin[ToString[rank], " - ", formatProgressValue[progress], "/10"]
			]
		}
	];

displayVowCard[vowData_Association] := Module[
	{rows, ownedThreat},
	ownedThreat = Lookup[vowData, "Threat", None];
	rows = {
		header["Vow", vowData["Name"]],
		progressSummary["Progress", vowData["Rank"], vowData["Progress"]]
	};
	If[AssociationQ[ownedThreat],
		rows = Join[
			rows,
			{
				subtitleStyle["Threat"],
				moveTextStyle[StringJoin[ownedThreat["Name"], ": ", ownedThreat["Goal"]]],
				progressSummary[
					"Menace",
					ownedThreat["Menace", "rank"],
					ownedThreat["Menace", "progress"]
				]
			}
		]
	];
	ironFramed[Column[rows, Spacings -> 0.8, Alignment -> Left]]
];

displayThreatCard[vowName_String, threatData_Association] :=
	ironFramed[
		Column[
			{
				header["Threat", threatData["Name"]],
				subtitleStyle[StringJoin["Vow: ", vowName]],
				moveTextStyle[threatData["Goal"]],
				progressSummary[
					"Menace",
					threatData["Menace", "rank"],
					threatData["Menace", "progress"]
				]
			},
			Spacings -> 0.8,
			Alignment -> Left
		]
	];

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

markVowProgress[vowName_String, n_Integer, character_] := Module[
	{target, markValue},
	target = progressTargetData[vowName, character];
	If[target === $Failed || target["Type"] =!= "Vow", Return[$Failed]];
	markValue = n rankMarkValue[target["Rank"]];
	adjustTargetProgress[target, markValue, character]
];

markThreatProgressByVow[vowName_String, n_Integer, character_] := Module[
	{ownedThreat, target, previous, markValue, updated},
	ownedThreat = threatByVowName[vowName, character];
	If[ownedThreat === $Failed, Return[$Failed]];
	previous = ownedThreat["Menace", "progress"];
	target = Association[
		"Type" -> "Threat",
		"Name" -> ownedThreat["Name"],
		"Vow" -> vowName,
		"Rank" -> ownedThreat["Menace", "rank"],
		"Progress" -> previous
	];
	markValue = n rankMarkValue[ownedThreat["Menace", "rank"]];
	updated = adjustTargetProgress[target, markValue, character];
	If[previous < 10 && updated >= 10,
		displayThreatFulfilled[vowName, $state[character, "vows", vowName, "Threat"]]
	];
	updated
];

markThreatProgressByName[threatName_String, n_Integer, character_] := Module[
	{vowName},
	vowName = threatLocationByName[threatName, character];
	If[!StringQ[vowName], Return[$Failed]];
	markThreatProgressByVow[vowName, n, character]
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

setTargetProgress[target_Association, value_, character_] := Module[
	{clamped},
	clamped = clampValue[value, {0, 10}];
	If[!TrueQ[value == clamped],
		Message[progress::clamped, target["Name"], character, value, clamped]
	];
	Switch[
		target["Type"],
		"Vow",
			$state[character, "vows", target["Name"], "Progress"] = clamped,
		"Threat",
			$state[character, "vows", target["Vow"], "Threat", "Menace", "progress"] = clamped,
		"Delve",
			$state[character, "delves", target["Name"], "Progress"] = clamped,
		"Scene",
			$state[character, "scene", "Progress"] = clamped,
		"Journey",
			$state[character, "journeys", target["Name"], "Progress"] = clamped,
		"Foe",
			$state[character, "foes", target["Name"], "Progress"] = clamped,
		"Failures",
			$state[character, "failures", "Progress"] = clamped,
		"Bonds",
			$state[character, "bondProgress", "Progress"] = clamped,
		_,
			Return[$Failed]
	];
	clamped
];

adjustTargetProgress[target_Association, delta_, character_] :=
	setTargetProgress[target, target["Progress"] + delta, character];

setTargetRank[target_Association, rank_?rankQ, character_] := Module[{},
	Switch[
		target["Type"],
		"Vow",
			$state[character, "vows", target["Name"], "Rank"] = rank,
		"Threat",
			$state[character, "vows", target["Vow"], "Threat", "Menace", "rank"] = rank,
		"Delve",
			$state[character, "delves", target["Name"], "Rank"] = rank,
		"Scene",
			$state[character, "scene", "Rank"] = rank,
		"Journey",
			$state[character, "journeys", target["Name"], "Rank"] = rank,
		"Foe",
			$state[character, "foes", target["Name"], "Rank"] = rank,
		"Failures",
			$state[character, "failures", "Rank"] = rank,
		"Bonds",
			$state[character, "bondProgress", "Rank"] = rank,
		_,
			Return[$Failed]
	];
	rank
];

rankIndex[rank_?rankQ] :=
	First[FirstPosition[ranks, rank]];

nextRank[rank_?rankQ] := Module[
	{index},
	index = rankIndex[rank];
	If[index >= Length[ranks],
		Missing["NoHigherRank"],
		ranks[[index + 1]]
	]
];

raiseTargetRank[target_Association, character_] := Module[
	{rank},
	rank = nextRank[target["Rank"]];
	If[rank === Missing["NoHigherRank"],
		Message[progress::epic, target["Name"], character];
		Return[$Failed]
	];
	setTargetRank[target, rank, character]
];


(* ::Section:: *)
(*Core API implementation*)


(* ::Subsection::Closed:: *)
(*Story and chapter lifecycle*)


resetIronSession[] := (Clear[$state, $soloCharacter]; ); 
beginStory[] := (Message[beginStory::missing]; $Failed); 
beginStory[name_String] := Module[{root, story, arc, base, storyDir, chapterDir, notebookPath, oldNotebookFile}, 
    If[chapterNotebookQ[], Return[renameCurrentStory[name]]]; root = storyRootDirectory[]; If[root === $Failed, Return[$Failed]]; 
     story = normalizeName[name]; arc = normalizeName["Introduction"]; storyDir = FileNameJoin[{root, story}]; 
     If[ !DirectoryQ[storyDir], CreateDirectory[storyDir, CreateIntermediateDirectories -> True]]; 
     base = makeNotebookBase[Association["Story" -> story, "ChapterNumber" -> 1, "Arc" -> arc, "ArcChapterNumber" -> 1]]; chapterDir = FileNameJoin[{storyDir, base}]; 
     If[DirectoryQ[chapterDir], Message[beginStory::direxists, chapterDir]; Return[$Failed]]; CreateDirectory[chapterDir, CreateIntermediateDirectories -> True]; 
     notebookPath = FileNameJoin[{chapterDir, StringJoin[base, ".nb"]}]; oldNotebookFile = NotebookFileName[]; If[oldNotebookFile === $Failed, Message[currentNotebookBase::unsaved]; Return[$Failed]]; 
     NotebookSave[currentNotebookObject[], notebookPath]; If[FileExistsQ[oldNotebookFile] && oldNotebookFile =!= notebookPath, DeleteFile[oldNotebookFile]]; 
     seedStoryState[base]; ensureChapterOneBoilerplate[]; 
     Association["NotebookPath" -> notebookPath, "StoryDirectory" -> storyDir, "AlreadyBegun" -> False]]; 
beginStory[name_] := (Message[beginStory::badname, name]; $Failed); 
beginStory::missing = "beginStory requires an explicit story name: beginStory[name]."; 
beginStory::badname = "Story name `1` is not a string."; 
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


createCharacter[name_String, assetSpecs_List /; Length[assetSpecs] == 3, (edge_)?statValueQ, (heart_)?statValueQ, (iron_)?statValueQ, (shadow_)?statValueQ, 
    (wits_)?statValueQ, vowSpec_, bonds:{___String} /; Length[bonds] <= 3] := 
   Module[{character, ownedAssets, startingVow}, ensureStateInitialized[]; ownedAssets = ownedAssetFromSpec /@ assetSpecs; If[MemberQ[ownedAssets, $Failed], Message[createCharacter::badassets]; Return[$Failed]]; 
     startingVow = ownedVowFromSpec[vowSpec]; If[startingVow === $Failed, Message[createCharacter::badvow]; Return[$Failed]];
     character = Association["assets" -> ownedAssets, "edge" -> edge, "heart" -> heart, "iron" -> iron, "shadow" -> shadow, "wits" -> wits, "health" -> 5, 
       "spirit" -> 5, "supply" -> 5, "momentum" -> 2, "debilities" -> {}, "vows" -> Association[startingVow["Name"] -> startingVow], 
       "failures" -> makeProgressObject["Failures", Epic], "bondProgress" -> makeProgressObject["Bonds", Epic, 0.25*Length[bonds]],
       "bonds" -> bonds, "journeys" -> <||>, "currentJourney" -> None, "foes" -> <||>, "delves" -> <||>, "currentDelve" -> None, "scene" -> None, "earnedExperience" -> 0, "spentExperience" -> 0]; AssociateTo[$state, name -> character]; $soloCharacter = name; $state[name]];
createCharacter::badassets = "Could not create the character because one or more starting assets are invalid.";
createCharacter::badvow = "Could not create the character because the starting vow is invalid. Use starterVow[name, rank].";
       
setSoloCharacter[character_String] := Module[{},
	If[!AssociationQ[$state] || !KeyExistsQ[$state, character],
		Message[setSoloCharacter::nochar, character];
		Return[$Failed]
	];
	$soloCharacter = character
];

setSoloCharacter::nochar = "No character named `1` exists in the current state.";


(* ::Subsection::Closed:: *)
(*Debility management*)


markDebility[debility_?debilityQ, character_ : $soloCharacter] := Module[
	{current},
	If[!ensureCharacterState[character], Return[$Failed]];
	current = getDebilities[character];
	If[MemberQ[current, debility],
		Message[markDebility::marked, debilityLabel[debility], character];
		Return[current]
	];
	$state[character, "debilities"] = Append[current, debility];
	enforceMomentumBounds[character];
	$state[character, "debilities"]
];

markDebility[debility_, character_ : $soloCharacter] := (
	Message[markDebility::invalid, debility];
	$Failed
);

clearDebility[debility_?debilityQ, character_ : $soloCharacter] := Module[
	{current},
	If[!ensureCharacterState[character], Return[$Failed]];
	If[MemberQ[permanentDebilities, debility],
		Message[clearDebility::permanent, debilityLabel[debility]];
		Return[$Failed]
	];
	current = getDebilities[character];
	If[!MemberQ[current, debility],
		Message[clearDebility::unmarked, debilityLabel[debility], character];
		Return[current]
	];
	$state[character, "debilities"] = DeleteCases[current, debility];
	enforceMomentumBounds[character];
	$state[character, "debilities"]
];

clearDebility[debility_, character_ : $soloCharacter] := (
	Message[clearDebility::invalid, debility];
	$Failed
);

markDebility::invalid = "`1` is not an Ironsworn debility.";
markDebility::marked = "`1` is already marked for character `2`.";
clearDebility::invalid = "`1` is not an Ironsworn debility.";
clearDebility::unmarked = "`1` is not marked for character `2`.";
clearDebility::permanent = "`1` is permanent and cannot be cleared.";


(* ::Subsection::Closed:: *)
(*Vow management*)


Options[starterVow] = {Threat -> None};

starterVow[name_String, rank_?rankQ, opts : OptionsPattern[]] :=
	makeStarterVowSpec[name, rank, OptionValue[Threat]];

starterVow[args___] := (
	Message[vow::badstarter, HoldForm[starterVow[args]]];
	$Failed
);

Options[addVow] = {Threat -> None};

addVow[name_String, rank_?rankQ, opts : OptionsPattern[]] :=
	addVow[name, rank, $soloCharacter, opts];

addVow[name_String, rank_?rankQ, character_String, opts : OptionsPattern[]] := Module[
	{ownedVows, ownedVow},
	ownedVows = normalizeCharacterVows[character];
	If[ownedVows === $Failed, Return[$Failed]];
	If[KeyExistsQ[ownedVows, name],
		Message[vow::duplicate, name, character];
		Return[$Failed]
	];
	ownedVow = makeVow[name, rank, OptionValue[Threat]];
	If[ownedVow === $Failed, Return[$Failed]];
	$state[character, "vows", name] = ownedVow;
	ownedVow
];

vow[name_String, character_ : $soloCharacter] := Module[
	{ownedVow, card},
	ownedVow = vowByName[name, character];
	If[!AssociationQ[ownedVow],
		Message[vow::unknown, name, character];
		Return[$Failed]
	];
	card = displayVowCard[ownedVow];
	Print[card];
	ownedVow
];

vows[] :=
	vows[$soloCharacter];

vows[character_] := Module[
	{ownedVows, cards},
	ownedVows = normalizeCharacterVows[character];
	If[ownedVows === $Failed, Return[$Failed]];
	cards = displayVowCard /@ Values[ownedVows];
	Print[Column[cards, Spacings -> 1, Alignment -> Left]];
	ownedVows
];

Options[threat] = {Display -> True};

threat[vowName_String, opts : OptionsPattern[]] :=
	threat[vowName, $soloCharacter, opts];

threat[vowName_String, character_String, opts : OptionsPattern[]] := Module[
	{ownedThreat},
	ownedThreat = threatByVowName[vowName, character];
	If[ownedThreat === $Failed, Return[$Failed]];
	If[OptionValue[Display], Print[displayThreatCard[vowName, ownedThreat]]];
	ThreatTrack[vowName, character]
];

vow::badstarter = "`1` is not a valid vow spec. Use starterVow[name, rank].";
vow::badthreat = "`1` is not a valid threat spec. Use Threat -> {threatName, threatGoal}.";
vow::nochar = "No character named `1` exists in the current state.";
vow::unknown = "Character `2` does not have a vow named `1`.";
vow::duplicate = "Character `2` already has a vow named `1`.";
threat::none = "Vow `1` does not have an attached threat.";


(* ::Subsection::Closed:: *)
(*Asset management*)


starterAsset[name_String] :=
	makeStarterAssetSpec[name, Automatic, <||>];

starterAsset[name_String, fields_Association] :=
	makeStarterAssetSpec[name, Automatic, fields];

starterAsset[name_String, abilitySpec : (_Integer | {__Integer})] :=
	makeStarterAssetSpec[name, abilitySpec, <||>];

starterAsset[name_String, abilitySpec : (_Integer | {__Integer}), fields_Association] :=
	makeStarterAssetSpec[name, abilitySpec, fields];

starterAsset[args___] := (
	Message[asset::badasset, HoldForm[starterAsset[args]]];
	$Failed
);

asset[name_String, character_ : $soloCharacter] := Module[
	{record, ownedAssets, positions, owned},
	record = assetRecord[name];
	If[!AssociationQ[record],
		Message[asset::unknown, name];
		Return[$Failed]
	];
	ownedAssets = normalizeCharacterAssets[character];
	If[ownedAssets === $Failed, Return[$Failed]];
	positions = Flatten @ Position[Lookup[ownedAssets, "Name", Missing["NoName"]], name];
	If[positions === {},
		Message[asset::notowned, name, character];
		Return[$Failed]
	];
	owned = ownedAssets[[First[positions]]];
	displayAssetCard[owned]
];

assets[] :=
	assets[$soloCharacter];

assets[character_] := Module[
	{ownedAssets, cards},
	ownedAssets = normalizeCharacterAssets[character];
	If[ownedAssets === $Failed, Return[$Failed]];
	cards = assetCardExpression /@ ownedAssets;
	If[MemberQ[cards, $Failed], Return[$Failed]];
	displayAssetCards[cards];
	ownedAssets
];

drawAssets[] :=
	drawAssets[3];

drawAssets[category_String] :=
	drawAssets[3, category];

drawAssets[n_Integer?Positive] :=
	drawAssets[n, All];

drawAssets[n_Integer?Positive, All] := Module[
	{names, cards},
	If[n > Length[assetNames[]],
		Message[asset::drawcount, n, Length[assetNames[]]];
		Return[$Failed]
	];
	names = RandomSample[assetNames[], n];
	cards = assetReferenceCard /@ names;
	If[MemberQ[cards, $Failed], Return[$Failed]];
	displayAssetCards[cards];
	names
];

drawAssets[n_Integer?Positive, category_String] := Module[
	{pool, names, cards},
	If[!MemberQ[assetCategories[], category],
		Message[asset::badcategory, category, StringRiffle[assetCategories[], ", "]];
		Return[$Failed]
	];
	pool = Select[assetNames[], assetRecord[#]["Category"] === category &];
	If[n > Length[pool],
		Message[asset::drawcount, n, Length[pool]];
		Return[$Failed]
	];
	names = RandomSample[pool, n];
	cards = assetReferenceCard /@ names;
	If[MemberQ[cards, $Failed], Return[$Failed]];
	displayAssetCards[cards];
	names
];

drawAssets[args___] := (
	Message[asset::baddraw, HoldForm[drawAssets[args]]];
	$Failed
);

Options[addAsset] = {Display -> True};

addAsset[assetSpec_, opts : OptionsPattern[]] :=
	addAsset[assetSpec, $soloCharacter, opts];

addAsset[assetSpec_, character_, opts : OptionsPattern[]] := Module[
	{ownedAssets, owned, name},
	If[!characterExistsQ[character],
		Message[asset::nochar, character];
		Return[$Failed]
	];
	ownedAssets = normalizeCharacterAssets[character];
	If[ownedAssets === $Failed, Return[$Failed]];
	owned = ownedAssetFromSpec[assetSpec];
	If[owned === $Failed, Return[$Failed]];
	name = owned["Name"];
	If[MemberQ[Lookup[ownedAssets, "Name", Missing["NoName"]], name],
		Message[asset::duplicate, name, character];
		Return[$Failed]
	];
	If[availableExperience[character] < 5,
		Message[asset::xp, character, 5, availableExperience[character]];
		Return[$Failed]
	];
	AppendTo[$state[character, "assets"], owned];
	spendExperience[5, character];
	If[OptionValue[Display], displayAssetCard[owned, "Added Asset"]];
	owned
];

Options[upgradeAsset] = {Display -> True};

upgradeAsset[name_String, ability_Integer, opts : OptionsPattern[]] :=
	upgradeAsset[name, ability, $soloCharacter, opts];

upgradeAsset[name_String, ability_Integer, character_, opts : OptionsPattern[]] := Module[
	{record, ownedAssets, positions, index, owned, valid, selected, updated, updatedAssets},
	record = assetRecord[name];
	If[!AssociationQ[record],
		Message[asset::unknown, name];
		Return[$Failed]
	];
	ownedAssets = normalizeCharacterAssets[character];
	If[ownedAssets === $Failed, Return[$Failed]];
	positions = Flatten @ Position[Lookup[ownedAssets, "Name", Missing["NoName"]], name];
	If[positions === {},
		Message[asset::notowned, name, character];
		Return[$Failed]
	];
	valid = assetAbilityIndices[record];
	If[!MemberQ[valid, ability],
		Message[asset::badability, ability, name, Length[valid]];
		Return[$Failed]
	];
	index = First[positions];
	owned = ownedAssets[[index]];
	selected = Lookup[owned, "Abilities", {}];
	If[MemberQ[selected, ability],
		Message[asset::selected, ability, name];
		Return[$Failed]
	];
	If[availableExperience[character] < 3,
		Message[asset::xp, character, 3, availableExperience[character]];
		Return[$Failed]
	];
	updated = Association[owned];
	updated["Abilities"] = Sort[Append[selected, ability]];
	updatedAssets = ownedAssets;
	updatedAssets[[index]] = updated;
	$state[character, "assets"] = updatedAssets;
	spendExperience[3, character];
	If[OptionValue[Display], displayAssetCard[updated, "Upgraded Asset"]];
	updated
];

setAssetTrack[assetName_String, trackName_String, value_Integer, character_ : $soloCharacter] := Module[
	{record, ownedAssets, positions, index, owned, trackDef, tracks, updated, updatedAssets, clamped},
	record = assetRecord[assetName];
	If[!AssociationQ[record],
		Message[asset::unknown, assetName];
		Return[$Failed]
	];
	ownedAssets = normalizeCharacterAssets[character];
	If[ownedAssets === $Failed, Return[$Failed]];
	positions = Flatten @ Position[Lookup[ownedAssets, "Name", Missing["NoName"]], assetName];
	If[positions === {},
		Message[asset::notowned, assetName, character];
		Return[$Failed]
	];
	trackDef = assetTrackDefinition[record, trackName];
	If[!AssociationQ[trackDef],
		Message[asset::track, trackName, assetName];
		Return[$Failed]
	];
	index = First[positions];
	owned = ownedAssets[[index]];
	tracks = Join[initialAssetTracks[record], Lookup[owned, "Tracks", <||>]];
	clamped = clampAssetTrackValue[trackDef, value];
	tracks[trackName] = clamped;
	updated = Association[owned];
	updated["Tracks"] = tracks;
	updatedAssets = ownedAssets;
	updatedAssets[[index]] = updated;
	$state[character, "assets"] = updatedAssets;
	clamped
];

adjustAssetTrack[assetName_String, trackName_String, delta_Integer, character_ : $soloCharacter] := Module[
	{record, ownedAssets, positions, owned, trackDef, tracks, current},
	record = assetRecord[assetName];
	If[!AssociationQ[record],
		Message[asset::unknown, assetName];
		Return[$Failed]
	];
	ownedAssets = normalizeCharacterAssets[character];
	If[ownedAssets === $Failed, Return[$Failed]];
	positions = Flatten @ Position[Lookup[ownedAssets, "Name", Missing["NoName"]], assetName];
	If[positions === {},
		Message[asset::notowned, assetName, character];
		Return[$Failed]
	];
	trackDef = assetTrackDefinition[record, trackName];
	If[!AssociationQ[trackDef],
		Message[asset::track, trackName, assetName];
		Return[$Failed]
	];
	owned = ownedAssets[[First[positions]]];
	tracks = Join[initialAssetTracks[record], Lookup[owned, "Tracks", <||>]];
	current = Lookup[tracks, trackName, Lookup[trackDef, "Default", 0]];
	setAssetTrack[assetName, trackName, current + delta, character]
];

normalizeRarityName[rarity_String] := Module[
	{trimmed},
	trimmed = StringTrim[rarity];
	If[StringLength[trimmed] == 0, $Failed, trimmed]
];

normalizeRarityName[_] :=
	$Failed;

assetRarityCost[record_Association] :=
	Lookup[record, "RarityCost", Missing["NoRarityCost"]];

Options[addRarity] = {Display -> True};

addRarity[assetName_String, rarityName_, opts : OptionsPattern[]] :=
	addRarity[assetName, rarityName, $soloCharacter, opts];

addRarity[assetName_String, rarityName_, character_, opts : OptionsPattern[]] := Module[
	{record, rarity, cost, ownedAssets, positions, index, owned, updated, updatedAssets},
	record = assetRecord[assetName];
	If[!AssociationQ[record],
		Message[asset::unknown, assetName];
		Return[$Failed]
	];
	rarity = normalizeRarityName[rarityName];
	If[rarity === $Failed,
		Message[asset::badrarity, rarityName];
		Return[$Failed]
	];
	If[Lookup[record, "Category", ""] === "Companion",
		Message[asset::raritycompanion, assetName];
		Return[$Failed]
	];
	cost = assetRarityCost[record];
	If[!IntegerQ[cost],
		Message[asset::noraritycost, assetName];
		Return[$Failed]
	];
	ownedAssets = normalizeCharacterAssets[character];
	If[ownedAssets === $Failed, Return[$Failed]];
	positions = Flatten @ Position[Lookup[ownedAssets, "Name", Missing["NoName"]], assetName];
	If[positions === {},
		Message[asset::notowned, assetName, character];
		Return[$Failed]
	];
	index = First[positions];
	owned = ownedAssets[[index]];
	If[Lookup[owned, "Rarity", None] =!= None,
		Message[asset::rarityduplicate, assetName, Lookup[owned, "Rarity", None]];
		Return[$Failed]
	];
	If[availableExperience[character] < cost,
		Message[asset::xp, character, cost, availableExperience[character]];
		Return[$Failed]
	];
	updated = Association[owned];
	updated["Rarity"] = rarity;
	updatedAssets = ownedAssets;
	updatedAssets[[index]] = updated;
	$state[character, "assets"] = updatedAssets;
	spendExperience[cost, character];
	If[OptionValue[Display], displayAssetCard[updated, "Added Rarity"]];
	updated
];

Options[removeRarity] = {Display -> True};

removeRarity[assetName_String, opts : OptionsPattern[]] :=
	removeRarity[assetName, $soloCharacter, opts];

removeRarity[assetName_String, character_, opts : OptionsPattern[]] := Module[
	{record, ownedAssets, positions, index, owned, updated, updatedAssets},
	record = assetRecord[assetName];
	If[!AssociationQ[record],
		Message[asset::unknown, assetName];
		Return[$Failed]
	];
	ownedAssets = normalizeCharacterAssets[character];
	If[ownedAssets === $Failed, Return[$Failed]];
	positions = Flatten @ Position[Lookup[ownedAssets, "Name", Missing["NoName"]], assetName];
	If[positions === {},
		Message[asset::notowned, assetName, character];
		Return[$Failed]
	];
	index = First[positions];
	owned = ownedAssets[[index]];
	If[Lookup[owned, "Rarity", None] === None,
		Message[asset::norarity, assetName];
		Return[$Failed]
	];
	updated = Association[owned];
	updated["Rarity"] = None;
	updatedAssets = ownedAssets;
	updatedAssets[[index]] = updated;
	$state[character, "assets"] = updatedAssets;
	markExperience[1, character];
	If[OptionValue[Display], displayAssetCard[updated, "Removed Rarity"]];
	updated
];

asset::unknown = "Unknown asset `1`. Use the exact canonical asset name.";
asset::nodefault = "Asset `1` has no printed default selected ability. Use starterAsset[`1`, abilityIndex].";
asset::badability = "Ability `1` is not available for asset `2`. Valid ability indices are 1 through `3`.";
asset::badabilities = "Asset `1` requires a non-empty integer ability selection.";
asset::dupeability = "Ability `1` was selected more than once for asset `2`.";
asset::badfield = "Field `1` is not defined for asset `2`.";
asset::badfields = "Fields for asset `1` must be an association.";
asset::badasset = "`1` is not a valid asset spec. Use an asset name string or starterAsset[...].";
asset::badstoredassets = "The stored assets for character `1` could not be migrated to structured asset state.";
asset::nochar = "No character named `1` exists in the current state.";
asset::notowned = "Character `2` does not own asset `1`.";
asset::duplicate = "Character `2` already owns asset `1`.";
asset::xp = "Character `1` needs `2` available experience, but only has `3`.";
asset::selected = "Ability `1` is already selected for asset `2`.";
asset::track = "Track `1` is not defined for asset `2`.";
asset::badcategory = "Unknown asset category `1`. Use one of: `2`.";
asset::drawcount = "Cannot draw `1` distinct assets from a pool of `2`.";
asset::baddraw = "`1` is not a valid drawAssets call.";
asset::badrarity = "Rarity name must be a non-empty string, not `1`.";
asset::raritycompanion = "Companion asset `1` cannot be augmented with a rarity.";
asset::noraritycost = "Asset `1` is not eligible for rarity augmentation.";
asset::rarityduplicate = "Asset `1` already has rarity `2`.";
asset::norarity = "Asset `1` does not have a rarity to remove.";


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
burnMomentum[roll_Association, opts:OptionsPattern[]] := Module[
	{momentum, challengeDice, challengeDiceCancelled, beatCount, burn},
	If[
		!actionRollQ[roll] ||
		!AllTrue[{"character", "momentum", "result", "match"}, KeyExistsQ[roll, #] &],
		Message[burnMomentum::badroll];
		Return[$Failed]
	];
	momentum = roll["momentum"];
	If[momentum <= 0,
		Message[burnMomentum::momentum, momentum];
		Return[$Failed]
	];
	challengeDice = roll["challengeDice"];
	challengeDiceCancelled = # < momentum & /@ challengeDice;
	If[!AnyTrue[challengeDiceCancelled, TrueQ],
		Message[burnMomentum::nocancel, momentum];
		Return[$Failed]
	];
	beatCount = Total[
		MapThread[
			If[#2 || roll["actionScore"] > #1, 1, 0] &,
			{challengeDice, challengeDiceCancelled}
		]
	];
	burn = Association[
		"momentum" -> momentum,
		"challengeDice" -> challengeDice,
		"momentumReset" -> getMomentumReset[roll["character"]],
		"actionScore" -> roll["actionScore"],
		"previousResult" -> roll["result"],
		"result" -> rollResultFromBeatCount[beatCount],
		"challengeDiceCancelled" -> challengeDiceCancelled,
		"match" -> roll["match"]
	];
	resetMomentum[roll["character"]];
	If[OptionValue[Display], displayMomentumBurn[burn]];
	burn
];

burnMomentum[roll_, opts:OptionsPattern[]] := (
	Message[burnMomentum::badroll];
	$Failed
);

burnMomentum::badroll = "burnMomentum can only be used on an action roll.";
burnMomentum::momentum = "Cannot burn momentum because roll momentum is not positive (`1`).";
burnMomentum::nocancel = "Cannot burn momentum because no challenge die is less than momentum `1`.";


(* ::Subsection::Closed:: *)
(*Progress roll*)


Options[progressRoll] = {Display -> True};

progressRoll[track_String, opts : OptionsPattern[]] :=
	progressRoll[track, $soloCharacter, opts];

progressRoll[track_String, character_String, opts : OptionsPattern[]] := Module[
	{target, progressScore, challengeDice, die1, die2, roll},
	target = progressTargetData[track, character];
	If[target === $Failed, Return[$Failed]];
	progressScore = Floor[target["Progress"]];
	challengeDice = {die1, die2} = rollChallengeDice[];
	roll = Association[
		"character" -> character,
		"trackName" -> target["Name"],
		"progressScore" -> progressScore,
		"challengeDice" -> challengeDice,
		"match" -> die1 == die2,
		"result" -> progressRollResult[challengeDice, progressScore]
	];
	If[OptionValue[Display], displayProgressRoll[roll]];
	roll
];


(* ::Subsection::Closed:: *)
(*Resource and momentum adjustment*)


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
(*Progress mutation*)


markProgress[ThreatTrack[vowName_String, handleCharacter_String], n_Integer?NonNegative, character_ : Automatic] :=
	markThreatProgressByVow[
		vowName,
		n,
		Replace[character, Automatic :> handleCharacter]
	];

markProgress[track_String, n_Integer?NonNegative, character_ : $soloCharacter] := Module[
	{target, markValue},
	target = progressTargetData[track, character];
	If[target === $Failed, Return[$Failed]];
	Switch[
		target["Type"],
			"Vow",
				markVowProgress[target["Name"], n, character],
			"Threat",
				markThreatProgressByVow[target["Vow"], n, character],
			"Delve" | "Scene" | "Journey" | "Foe" | "Failures" | "Bonds",
				markValue = n rankMarkValue[target["Rank"]];
				adjustTargetProgress[target, markValue, character],
			_,
				$Failed
		]
	];

markProgress[track_String, character_String] :=
	markProgress[track, 1, character];

markProgress[track_String] :=
	markProgress[track, 1, $soloCharacter];

markProgress[ThreatTrack[vowName_String, handleCharacter_String], character_String] :=
	markProgress[ThreatTrack[vowName, handleCharacter], 1, character];

markProgress[ThreatTrack[vowName_String, handleCharacter_String]] :=
	markProgress[ThreatTrack[vowName, handleCharacter], 1, Automatic];

markProgress[_String | _ThreatTrack, n_Integer?Negative, character_ : $soloCharacter] := (
	Message[progress::badunits, n];
	$Failed
);

clearProgress[ThreatTrack[vowName_String, handleCharacter_String], n_Integer?NonNegative, character_ : Automatic] := Module[
	{ownedThreat, target, markValue, useCharacter},
	useCharacter = Replace[character, Automatic :> handleCharacter];
	ownedThreat = threatByVowName[vowName, useCharacter];
	If[ownedThreat === $Failed, Return[$Failed]];
	target = Association[
		"Type" -> "Threat",
		"Name" -> ownedThreat["Name"],
		"Vow" -> vowName,
		"Rank" -> ownedThreat["Menace", "rank"],
		"Progress" -> ownedThreat["Menace", "progress"]
	];
	markValue = n rankMarkValue[target["Rank"]];
	adjustTargetProgress[target, -markValue, useCharacter]
];

clearProgress[track_String, n_Integer?NonNegative, character_ : $soloCharacter] := Module[
	{target, markValue},
	target = progressTargetData[track, character];
	If[target === $Failed, Return[$Failed]];
	markValue = n rankMarkValue[target["Rank"]];
	adjustTargetProgress[target, -markValue, character]
];

clearProgress[_String | _ThreatTrack, n_Integer?Negative, character_ : $soloCharacter] := (
	Message[progress::badunits, n];
	$Failed
);

resetProgress[ThreatTrack[vowName_String, handleCharacter_String], character_ : Automatic] := Module[
	{ownedThreat, target, useCharacter},
	useCharacter = Replace[character, Automatic :> handleCharacter];
	ownedThreat = threatByVowName[vowName, useCharacter];
	If[ownedThreat === $Failed, Return[$Failed]];
	target = Association[
		"Type" -> "Threat",
		"Name" -> ownedThreat["Name"],
		"Vow" -> vowName,
		"Rank" -> ownedThreat["Menace", "rank"],
		"Progress" -> ownedThreat["Menace", "progress"]
	];
	setTargetProgress[target, 0, useCharacter]
];

resetProgress[track_String, character_ : $soloCharacter] := Module[
	{target},
	target = progressTargetData[track, character];
	If[target === $Failed, Return[$Failed]];
	setTargetProgress[target, 0, character]
];

resetProgressToOne[ThreatTrack[vowName_String, handleCharacter_String], character_ : Automatic] := Module[
	{ownedThreat, target, useCharacter},
	useCharacter = Replace[character, Automatic :> handleCharacter];
	ownedThreat = threatByVowName[vowName, useCharacter];
	If[ownedThreat === $Failed, Return[$Failed]];
	target = Association[
		"Type" -> "Threat",
		"Name" -> ownedThreat["Name"],
		"Vow" -> vowName,
		"Rank" -> ownedThreat["Menace", "rank"],
		"Progress" -> ownedThreat["Menace", "progress"]
	];
	setTargetProgress[target, 1, useCharacter]
];

resetProgressToOne[track_String, character_ : $soloCharacter] := Module[
	{target},
	target = progressTargetData[track, character];
	If[target === $Failed, Return[$Failed]];
	setTargetProgress[target, 1, character]
];

raiseProgressRank[ThreatTrack[vowName_String, handleCharacter_String], character_ : Automatic] := Module[
	{ownedThreat, target, useCharacter},
	useCharacter = Replace[character, Automatic :> handleCharacter];
	ownedThreat = threatByVowName[vowName, useCharacter];
	If[ownedThreat === $Failed, Return[$Failed]];
	target = Association[
		"Type" -> "Threat",
		"Name" -> ownedThreat["Name"],
		"Vow" -> vowName,
		"Rank" -> ownedThreat["Menace", "rank"],
		"Progress" -> ownedThreat["Menace", "progress"]
	];
	raiseTargetRank[target, useCharacter]
];

raiseProgressRank[track_String, character_ : $soloCharacter] := Module[
	{target},
	target = progressTargetData[track, character];
	If[target === $Failed, Return[$Failed]];
	raiseTargetRank[target, character]
];

markProgress::notrack = "No vow, threat, delve, scene, journey, foe, failures, or bonds track named `1` exists for character `2`.";
progress::badunits = "Progress units must be a non-negative integer, got `1`.";
progress::clamped = "Progress for `1` on character `2` was clamped from `3` to `4`.";
progress::epic = "Progress track `1` for character `2` is already Epic and cannot be raised.";
progress::badrank = "`1` is not a valid progress rank.";


(* ::Subsection::Closed:: *)
(*Journey and foe management*)


normalizeCharacterJourneys[character_] :=
	normalizeProgressObjectAssociation[character, "journeys"];

normalizeCharacterFoes[character_] :=
	normalizeProgressObjectAssociation[character, "foes"];

displayProgressObject[type_String, object_Association] :=
	displayProgressTargetCard[
		Association[
			"Type" -> type,
			"Name" -> object["Name"],
			"Rank" -> object["Rank"],
			"Progress" -> object["Progress"]
		]
	];

addJourney[name_String, rank_?rankQ, character_ : $soloCharacter] := Module[
	{ownedJourneys, ownedJourney},
	ownedJourneys = normalizeCharacterJourneys[character];
	If[ownedJourneys === $Failed, Return[$Failed]];
	If[KeyExistsQ[ownedJourneys, name],
		Message[journey::duplicate, name, character];
		Return[$Failed]
	];
	ownedJourney = makeProgressObject[name, rank];
	$state[character, "journeys", name] = ownedJourney;
	ownedJourney
];

addJourney[name_String, rank_, character_ : $soloCharacter] /; !rankQ[rank] := (
	Message[progress::badrank, rank];
	$Failed
);

setCurrentJourney[name_String, character_ : $soloCharacter] := Module[
	{ownedJourney},
	ownedJourney = journeyByName[name, character];
	If[!AssociationQ[ownedJourney],
		Message[journey::unknown, name, character];
		Return[$Failed]
	];
	$state[character, "currentJourney"] = name;
	ownedJourney
];

journey[] := Module[
	{ownedJourney},
	ownedJourney = currentJourneyData[$soloCharacter];
	If[ownedJourney === $Failed, Return[$Failed]];
	Print[displayProgressObject["Journey", ownedJourney]];
	ownedJourney
];

journey[name_String] :=
	journey[name, $soloCharacter];

journey[name_String, character_] := Module[
	{ownedJourney},
	ownedJourney = journeyByName[name, character];
	If[!AssociationQ[ownedJourney],
		Message[journey::unknown, name, character];
		Return[$Failed]
	];
	Print[displayProgressObject["Journey", ownedJourney]];
	ownedJourney
];

journeys[] :=
	journeys[$soloCharacter];

journeys[character_] := Module[
	{ownedJourneys, cards},
	ownedJourneys = normalizeCharacterJourneys[character];
	If[ownedJourneys === $Failed, Return[$Failed]];
	cards = displayProgressObject["Journey", #] & /@ Values[ownedJourneys];
	Print[Column[cards, Spacings -> 1, Alignment -> Left]];
	ownedJourneys
];

removeJourney[name_String, character_ : $soloCharacter] := Module[
	{ownedJourneys},
	ownedJourneys = normalizeCharacterJourneys[character];
	If[ownedJourneys === $Failed, Return[$Failed]];
	If[!KeyExistsQ[ownedJourneys, name],
		Message[journey::unknown, name, character];
		Return[$Failed]
	];
	$state[character, "journeys"] = KeyDrop[ownedJourneys, name];
	If[Lookup[$state[character], "currentJourney", None] === name,
		$state[character, "currentJourney"] = None
	];
	$state[character, "journeys"]
];

addFoe[name_String, rank_?rankQ, character_ : $soloCharacter] := Module[
	{ownedFoes, ownedFoe},
	ownedFoes = normalizeCharacterFoes[character];
	If[ownedFoes === $Failed, Return[$Failed]];
	If[KeyExistsQ[ownedFoes, name],
		Message[foe::duplicate, name, character];
		Return[$Failed]
	];
	ownedFoe = makeProgressObject[name, rank];
	$state[character, "foes", name] = ownedFoe;
	ownedFoe
];

addFoe[name_String, rank_, character_ : $soloCharacter] /; !rankQ[rank] := (
	Message[progress::badrank, rank];
	$Failed
);

foe[name_String, character_ : $soloCharacter] := Module[
	{ownedFoe},
	ownedFoe = foeByName[name, character];
	If[!AssociationQ[ownedFoe],
		Message[foe::unknown, name, character];
		Return[$Failed]
	];
	Print[displayProgressObject["Foe", ownedFoe]];
	ownedFoe
];

foes[] :=
	foes[$soloCharacter];

foes[character_] := Module[
	{ownedFoes, cards},
	ownedFoes = normalizeCharacterFoes[character];
	If[ownedFoes === $Failed, Return[$Failed]];
	cards = displayProgressObject["Foe", #] & /@ Values[ownedFoes];
	Print[Column[cards, Spacings -> 1, Alignment -> Left]];
	ownedFoes
];

removeFoe[name_String, character_ : $soloCharacter] := Module[
	{ownedFoes},
	ownedFoes = normalizeCharacterFoes[character];
	If[ownedFoes === $Failed, Return[$Failed]];
	If[!KeyExistsQ[ownedFoes, name],
		Message[foe::unknown, name, character];
		Return[$Failed]
	];
	$state[character, "foes"] = KeyDrop[ownedFoes, name]
];

failures[] :=
	failures[$soloCharacter];

failures[character_] := Module[
	{track},
	track = failureProgressData[character];
	If[track === $Failed, Return[$Failed]];
	Print[displayProgressObject["Failures", track]];
	track
];

bondProgress[] :=
	bondProgress[$soloCharacter];

bondProgress[character_] := Module[
	{track},
	track = bondProgressData[character];
	If[track === $Failed, Return[$Failed]];
	Print[displayProgressObject["Bonds", track]];
	track
];

journey::duplicate = "Character `2` already has a journey named `1`.";
journey::unknown = "Character `2` does not have a journey named `1`.";
journey::nocurrent = "Character `1` does not have a current journey.";
foe::duplicate = "Character `2` already has a foe named `1`.";
foe::unknown = "Character `2` does not have a foe named `1`.";


(* ::Subsection::Closed:: *)
(*Bond management*)


normalizeCharacterBonds[character_] := Module[
	{ownedBonds},
	If[!characterExistsQ[character],
		Message[bond::nochar, character];
		Return[$Failed]
	];
	ownedBonds = Lookup[$state[character], "bonds", {}];
	If[ListQ[ownedBonds],
		Return[ownedBonds]
	];
	$state[character, "bonds"] = {};
	{}
];

displayBondCard[name_String] :=
	ironFramed[
		Column[
			{header["Bond", name]},
			Spacings -> 0.8,
			Alignment -> Left
		]
	];

addBond[name_String, character_ : $soloCharacter] := Module[
	{ownedBonds, progressResult, updated},
	ownedBonds = normalizeCharacterBonds[character];
	If[ownedBonds === $Failed, Return[$Failed]];
	If[MemberQ[ownedBonds, name],
		Message[bond::duplicate, name, character];
		Return[$Failed]
	];
	progressResult = markProgress["Bonds", 1, character];
	If[progressResult === $Failed, Return[$Failed]];
	updated = Append[ownedBonds, name];
	$state[character, "bonds"] = updated;
	updated
];

bond[name_String, character_ : $soloCharacter] := Module[
	{ownedBonds},
	ownedBonds = normalizeCharacterBonds[character];
	If[ownedBonds === $Failed, Return[$Failed]];
	If[!MemberQ[ownedBonds, name],
		Message[bond::unknown, name, character];
		Return[$Failed]
	];
	Print[displayBondCard[name]];
	name
];

bonds[] :=
	bonds[$soloCharacter];

bonds[character_] := Module[
	{ownedBonds, cards},
	ownedBonds = normalizeCharacterBonds[character];
	If[ownedBonds === $Failed, Return[$Failed]];
	cards = displayBondCard /@ ownedBonds;
	Print[Column[cards, Spacings -> 1, Alignment -> Left]];
	ownedBonds
];

removeBond[name_String, character_ : $soloCharacter] := Module[
	{ownedBonds, position, updated},
	ownedBonds = normalizeCharacterBonds[character];
	If[ownedBonds === $Failed, Return[$Failed]];
	position = FirstPosition[ownedBonds, name, Missing["UnknownBond"]];
	If[!ListQ[position],
		Message[bond::unknown, name, character];
		Return[$Failed]
	];
	updated = Delete[ownedBonds, position];
	$state[character, "bonds"] = updated;
	clearProgress["Bonds", 1, character];
	updated
];

bond::nochar = "No character named `1` exists in the current state.";
bond::duplicate = "Character `2` already has a bond with `1`.";
bond::unknown = "Character `2` does not have a bond with `1`.";


(* ::Subsection::Closed:: *)
(*Scene management*)


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

beginScene[name_String, rank_?rankQ, character_ : $soloCharacter] := Module[
	{ownedScene, newScene},
	ownedScene = normalizeCharacterScene[character];
	If[ownedScene === $Failed, Return[$Failed]];
	If[AssociationQ[ownedScene],
		Message[scene::active, character, ownedScene["Name"]];
		Return[$Failed]
	];
	newScene = Association[
		"Name" -> name,
		"Rank" -> rank,
		"Progress" -> 0,
		"Countdown" -> 0
	];
	$state[character, "scene"] = newScene;
	Print[displaySceneCard[newScene]];
	newScene
];

beginScene[name_String, rank_, character_ : $soloCharacter] /; !rankQ[rank] := (
	Message[progress::badrank, rank];
	$Failed
);

scene[] :=
	scene[$soloCharacter];

scene[character_] := Module[
	{ownedScene},
	ownedScene = normalizeCharacterScene[character];
	If[ownedScene === $Failed, Return[$Failed]];
	If[ownedScene === None,
		Message[scene::none, character];
		Return[$Failed]
	];
	Print[displaySceneCard[ownedScene]];
	ownedScene
];

removeScene[] :=
	removeScene[$soloCharacter];

removeScene[character_] := Module[
	{ownedScene},
	ownedScene = normalizeCharacterScene[character];
	If[ownedScene === $Failed, Return[$Failed]];
	If[ownedScene === None,
		Message[scene::none, character];
		Return[$Failed]
	];
	$state[character, "scene"] = None;
	ownedScene
];

markSceneCountdown[] :=
	markSceneCountdown[1, $soloCharacter];

markSceneCountdown[n_Integer?NonNegative] :=
	markSceneCountdown[n, $soloCharacter];

markSceneCountdown[n_Integer?NonNegative, character_] := Module[
	{ownedScene, previous, requested, clamped},
	ownedScene = normalizeCharacterScene[character];
	If[ownedScene === $Failed, Return[$Failed]];
	If[ownedScene === None,
		Message[scene::none, character];
		Return[$Failed]
	];
	previous = ownedScene["Countdown"];
	requested = previous + n;
	clamped = clampValue[requested, {0, 4}];
	If[!TrueQ[requested == clamped],
		Message[scene::clamped, ownedScene["Name"], character, requested, clamped]
	];
	$state[character, "scene", "Countdown"] = clamped;
	ownedScene = $state[character, "scene"];
	If[previous < 4 && clamped >= 4,
		Message[scene::filled, ownedScene["Name"]]
	];
	Print[displaySceneCard[ownedScene]];
	clamped
];

markSceneCountdown[n_Integer?Negative, character_ : $soloCharacter] := (
	Message[scene::badcount, n];
	$Failed
);

scene::nochar = "No character named `1` exists in the current state.";
scene::active = "Character `1` already has an active scene named `2`.";
scene::none = "Character `1` does not have an active scene.";
scene::filled = "Scene countdown for `1` is filled.";
scene::clamped = "Scene countdown for `1` on character `2` was clamped from `3` to `4`.";
scene::badcount = "Scene countdown marks must be a non-negative integer, got `1`.";


(* ::Subsection::Closed:: *)
(*Delve management*)


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

Options[addDelve] = {Objective -> None};

addDelve[name_String, rank_?rankQ, themeSpec_, domainSpec_, opts : OptionsPattern[]] :=
	addDelve[name, rank, themeSpec, domainSpec, Automatic, $soloCharacter, opts];

addDelve[name_String, rank_?rankQ, themeSpec_, domainSpec_, character_String, opts : OptionsPattern[]] :=
	addDelve[name, rank, themeSpec, domainSpec, Automatic, character, opts];

addDelve[name_String, rank_?rankQ, themeSpec_, domainSpec_, denizenSpec_List, opts : OptionsPattern[]] :=
	addDelve[name, rank, themeSpec, domainSpec, denizenSpec, $soloCharacter, opts];

addDelve[name_String, rank_?rankQ, themeSpec_, domainSpec_, denizenSpec_, character_String, opts : OptionsPattern[]] := Module[
	{ownedDelves, ownedDelve},
	ownedDelves = normalizeCharacterDelves[character];
	If[ownedDelves === $Failed, Return[$Failed]];
	If[KeyExistsQ[ownedDelves, name],
		Message[delve::duplicate, name, character];
		Return[$Failed]
	];
	ownedDelve = makeDelve[name, rank, themeSpec, domainSpec, OptionValue[Objective], denizenSpec];
	If[ownedDelve === $Failed, Return[$Failed]];
	$state[character, "delves", name] = ownedDelve;
	ownedDelve
];

addDelve[name_String, rank_, ___] /; !rankQ[rank] := (
	Message[progress::badrank, rank];
	$Failed
);

setCurrentDelve[name_String, character_ : $soloCharacter] := Module[
	{ownedDelve},
	ownedDelve = delveByName[name, character];
	If[!AssociationQ[ownedDelve],
		Message[delve::unknown, name, character];
		Return[$Failed]
	];
	$state[character, "currentDelve"] = name;
	ownedDelve
];

delve[] := Module[
	{ownedDelve},
	ownedDelve = currentDelveData[$soloCharacter];
	If[ownedDelve === $Failed, Return[$Failed]];
	Print[displayDelveCard[ownedDelve]];
	ownedDelve
];

delve[name_String] :=
	delve[name, $soloCharacter];

delve[name_String, character_] := Module[
	{ownedDelve},
	ownedDelve = delveByName[name, character];
	If[!AssociationQ[ownedDelve],
		Message[delve::unknown, name, character];
		Return[$Failed]
	];
	Print[displayDelveCard[ownedDelve]];
	ownedDelve
];

delves[character_ : $soloCharacter] := Module[
	{ownedDelves, cards},
	ownedDelves = normalizeCharacterDelves[character];
	If[ownedDelves === $Failed, Return[$Failed]];
	cards = displayDelveCard /@ Values[ownedDelves];
	Print[Column[cards, Spacings -> 1, Alignment -> Left]];
	ownedDelves
];

removeDelve[name_String, character_ : $soloCharacter] := Module[
	{ownedDelves},
	ownedDelves = normalizeCharacterDelves[character];
	If[ownedDelves === $Failed, Return[$Failed]];
	If[!KeyExistsQ[ownedDelves, name],
		Message[delve::unknown, name, character];
		Return[$Failed]
	];
	$state[character, "delves"] = KeyDrop[ownedDelves, name];
	If[Lookup[$state[character], "currentDelve", None] === name,
		$state[character, "currentDelve"] = None
	];
	$state[character, "delves"]
];

setDelveTheme[themeSpec_] := Module[
	{current},
	current = currentDelveName[$soloCharacter];
	If[current === $Failed, Return[$Failed]];
	setDelveTheme[current, themeSpec, $soloCharacter]
];

setDelveTheme[delveName_String, themeSpec_] :=
	setDelveTheme[delveName, themeSpec, $soloCharacter];

setDelveTheme[delveName_String, themeSpec_, character_] := Module[
	{ownedDelve, themes},
	ownedDelve = delveByName[delveName, character];
	If[!AssociationQ[ownedDelve],
		Message[delve::unknown, delveName, character];
		Return[$Failed]
	];
	themes = normalizeDelveCards[themeSpec, "Theme"];
	If[themes === $Failed, Return[$Failed]];
	If[validateDelveCardPair[themes, ownedDelve["Domains"]] === $Failed, Return[$Failed]];
	$state[character, "delves", delveName, "Themes"] = themes;
	$state[character, "delves", delveName, "Theme"] = First[themes];
	$state[character, "delves", delveName]
];

setDelveDomain[domainSpec_] := Module[
	{current},
	current = currentDelveName[$soloCharacter];
	If[current === $Failed, Return[$Failed]];
	setDelveDomain[current, domainSpec, $soloCharacter]
];

setDelveDomain[delveName_String, domainSpec_] :=
	setDelveDomain[delveName, domainSpec, $soloCharacter];

setDelveDomain[delveName_String, domainSpec_, character_] := Module[
	{ownedDelve, domains},
	ownedDelve = delveByName[delveName, character];
	If[!AssociationQ[ownedDelve],
		Message[delve::unknown, delveName, character];
		Return[$Failed]
	];
	domains = normalizeDelveCards[domainSpec, "Domain"];
	If[domains === $Failed, Return[$Failed]];
	If[validateDelveCardPair[ownedDelve["Themes"], domains] === $Failed, Return[$Failed]];
	$state[character, "delves", delveName, "Domains"] = domains;
	$state[character, "delves", delveName, "Domain"] = First[domains];
	$state[character, "delves", delveName]
];

returnToSite[] := Module[
	{current},
	current = currentDelveName[$soloCharacter];
	If[current === $Failed, Return[$Failed]];
	returnToSite[current, $soloCharacter]
];

returnToSite[delveName_String] :=
	returnToSite[delveName, $soloCharacter];

returnToSite[delveName_String, character_] := Module[
	{ownedDelve, dice, roll},
	ownedDelve = delveByName[delveName, character];
	If[!AssociationQ[ownedDelve],
		Message[delve::unknown, delveName, character];
		Return[$Failed]
	];
	dice = rollChallengeDice[];
	roll = Association[
		"character" -> character,
		"delveName" -> delveName,
		"challengeDice" -> dice,
		"lowerDie" -> Min[dice],
		"match" -> SameQ @@ dice
	];
	displayReturnToSiteRoll[roll];
	roll
];

riskZoneData[delveData_Association] := Module[
	{progress, ranks, name, rank},
	progress = delveData["Progress"];
	{name, ranks} = Which[
		progress < 4,
			{"Low Risk", {Troublesome, Dangerous}},
		progress < 8,
			{"Medium Risk", {Dangerous, Formidable}},
		True,
			{"High Risk", {Formidable, Extreme}}
	];
	rank = If[rankIndex[delveData["Rank"]] <= rankIndex[Dangerous], First[ranks], Last[ranks]];
	Association["Name" -> name, "Ranks" -> ranks, "Rank" -> rank]
];

riskZone[] := Module[
	{current},
	current = currentDelveName[$soloCharacter];
	If[current === $Failed, Return[$Failed]];
	riskZone[current, $soloCharacter]
];

riskZone[delveName_String] :=
	riskZone[delveName, $soloCharacter];

riskZone[delveName_String, character_] := Module[
	{ownedDelve, zone},
	ownedDelve = delveByName[delveName, character];
	If[!AssociationQ[ownedDelve],
		Message[delve::unknown, delveName, character];
		Return[$Failed]
	];
	zone = riskZoneData[ownedDelve];
	displayRiskZoneCard[ownedDelve, zone];
	zone["Rank"]
];

denizens[] := Module[
	{current},
	current = currentDelveName[$soloCharacter];
	If[current === $Failed, Return[$Failed]];
	denizens[current, $soloCharacter]
];

denizens[delveName_String] :=
	denizens[delveName, $soloCharacter];

denizens[delveName_String, character_] := Module[
	{ownedDelve},
	ownedDelve = delveByName[delveName, character];
	If[!AssociationQ[ownedDelve],
		Message[delve::unknown, delveName, character];
		Return[$Failed]
	];
	Print[
		ironFramed[
			Column[
				{header["Denizens", delveName], denizenMatrixGrid[ownedDelve["Denizens"]]},
				Spacings -> 0.8,
				Alignment -> Left
			]
		]
	];
	ownedDelve["Denizens"]
];

denizenSlotFromValue[value_Integer] :=
	First @ FirstPosition[denizenSlotThresholds, threshold_ /; value <= threshold];

rollDenizen[] := Module[
	{current},
	current = currentDelveName[$soloCharacter];
	If[current === $Failed, Return[$Failed]];
	rollDenizen[current, $soloCharacter]
];

rollDenizen[delveName_String] :=
	rollDenizen[delveName, $soloCharacter];

rollDenizen[delveName_String, character_] := Module[
	{ownedDelve, dice, value, slot, roll},
	ownedDelve = delveByName[delveName, character];
	If[!AssociationQ[ownedDelve],
		Message[delve::unknown, delveName, character];
		Return[$Failed]
	];
	dice = rollOracleDice[];
	value = oracleRollValue[dice];
	slot = denizenSlotFromValue[value];
	roll = Association[
		"character" -> character,
		"delveName" -> delveName,
		"oracleDice" -> dice,
		"value" -> value,
		"slot" -> slot,
		"frequency" -> denizenSlotLabels[[slot]],
		"range" -> denizenSlotRanges[[slot]],
		"denizen" -> ownedDelve["Denizens"][[slot]]
	];
	displayDenizenRoll[delveName, roll];
	roll
];

setDenizen[slot_Integer, name_] := Module[
	{current},
	current = currentDelveName[$soloCharacter];
	If[current === $Failed, Return[$Failed]];
	setDenizen[current, slot, name, $soloCharacter]
];

setDenizen[delveName_String, slot_Integer, name_] :=
	setDenizen[delveName, slot, name, $soloCharacter];

setDenizen[delveName_String, slot_Integer, name_, character_] := Module[
	{ownedDelve, normalized, denizenList},
	If[!Between[{1, 12}][slot],
		Message[delve::badslot, slot];
		Return[$Failed]
	];
	ownedDelve = delveByName[delveName, character];
	If[!AssociationQ[ownedDelve],
		Message[delve::unknown, delveName, character];
		Return[$Failed]
	];
	normalized = normalizeDenizenSlot[name];
	If[normalized === $Failed,
		Message[delve::baddenizen, name];
		Return[$Failed]
	];
	denizenList = ownedDelve["Denizens"];
	If[StringQ[normalized],
		denizenList = Replace[denizenList, normalized -> None, {1}]
	];
	denizenList[[slot]] = normalized;
	$state[character, "delves", delveName, "Denizens"] = denizenList;
	denizenList
];

clearDenizen[slot_Integer] := Module[
	{current},
	current = currentDelveName[$soloCharacter];
	If[current === $Failed, Return[$Failed]];
	clearDenizen[current, slot, $soloCharacter]
];

clearDenizen[delveName_String, slot_Integer] :=
	clearDenizen[delveName, slot, $soloCharacter];

clearDenizen[delveName_String, slot_Integer, character_] :=
	setDenizen[delveName, slot, None, character];

delve::nochar = "No character named `1` exists in the current state.";
delve::nocurrent = "Character `1` does not have a current delve.";
delve::unknown = "Character `2` does not have a delve named `1`.";
delve::duplicate = "Character `2` already has a delve named `1`.";
delve::badtheme = "Unknown delve theme `1`. Use one of: `2`.";
delve::baddomain = "Unknown delve domain `1`. Use one of: `2`.";
delve::badcards = "Delve `1` cards must be a string or a one- or two-string list.";
delve::toomanycards = "A delve can have two themes or two domains, but not both.";
delve::badobjective = "Delve objective must be None or a string, not `1`.";
delve::baddenizens = "Denizens must be a 12-item list of strings or None.";
delve::baddenizen = "Denizen must be a non-empty string or None, not `1`.";
delve::badslot = "Denizen slot must be an integer from 1 to 12, not `1`.";


(* ::Subsection::Closed:: *)
(*Experience tracking*)


markExperience[n_Integer, character_ : $soloCharacter] :=
	$state[character, "earnedExperience"] += n;

spendExperience[n_Integer, character_ : $soloCharacter] :=
	$state[character, "spentExperience"] += n;


(* ::Subsection::Closed:: *)
(*Reroll*)


Options[reroll] = {Display -> True};

reroll[roll_Association, die : Except[_List], opts : OptionsPattern[]] :=
	reroll[roll, {die}, opts];

reroll[roll_Association, dice_List, opts : OptionsPattern[]] := Module[
	{
		selection,
		invalid,
		newRoll,
		oldActionDie,
		oldChallengeDice,
		actionDie,
		momentum,
		actionValue,
		actionDieCancelled,
		actionScore,
		challengeDice,
		challengeIndices,
		cd1,
		cd2
	},

	If[!rollQ[roll],
		Message[reroll::badroll, roll];
		Return[$Failed]
	];

	selection = normalizeRerollSelection[dice];

	If[selection === {},
		Message[reroll::empty];
		Return[$Failed]
	];

	invalid = Select[selection, !rerollSelectionQ[#] &];

	If[invalid =!= {},
		Message[reroll::baddie, First[invalid]];
		Return[$Failed]
	];

	If[progressRollQ[roll] && MemberQ[selection, ActionDie],
		Message[reroll::actiondie];
		Return[$Failed]
	];

	oldChallengeDice = roll["challengeDice"];
	challengeDice = oldChallengeDice;

	challengeIndices = rerollChallengeDieIndices[selection, oldChallengeDice];

	If[!VectorQ[challengeIndices, MemberQ[{1, 2}, #] &],
		Message[reroll::badchallenge, selection];
		Return[$Failed]
	];

	Do[
		challengeDice[[i]] = RandomInteger[{1, 10}],
		{i, challengeIndices}
	];

	If[actionRollQ[roll],
		oldActionDie = roll["actionDie"];

		actionDie =
			If[
				MemberQ[selection, ActionDie],
				rollActionDie[],
				oldActionDie
			];

		momentum = roll["momentum"];

		{actionValue, actionDieCancelled} =
			If[
				momentum < 0 && Abs[momentum] == actionDie,
				{0, True},
				{actionDie, False}
			];

		actionScore =
			Min[
				actionValue + Total[Values[roll["adds"]]] + roll["statValue"],
				10
			];

		{cd1, cd2} = challengeDice;

		newRoll = Association[roll];

		newRoll["actionDie"] = actionDie;
		newRoll["actionValue"] = actionValue;
		newRoll["actionDieCancelled"] = actionDieCancelled;
		newRoll["actionScore"] = actionScore;
		newRoll["challengeDice"] = challengeDice;
		newRoll["match"] = cd1 == cd2;
		newRoll["result"] = actionRollResult[challengeDice, actionScore];

		newRoll["reroll"] = Association[
			"selection" -> selection,
			"previousActionDie" -> oldActionDie,
			"previousChallengeDice" -> oldChallengeDice,
			"previousResult" -> roll["result"]
		];,

		{cd1, cd2} = challengeDice;

		newRoll = Association[roll];

		newRoll["challengeDice"] = challengeDice;
		newRoll["match"] = cd1 == cd2;
		newRoll["result"] = progressRollResult[challengeDice, roll["progressScore"]];

		newRoll["reroll"] = Association[
			"selection" -> selection,
			"previousChallengeDice" -> oldChallengeDice,
			"previousResult" -> roll["result"]
		];
	];

	If[OptionValue[Display], displayReroll[newRoll]];

	newRoll
];


(* ::Subsection::Closed:: *)
(*Choice display*)


choose[MoveDisplayOutput[data_Association], selection_] := Module[
	{indices, choices, invalid, selected},

	indices = choiceSelectionIndices[selection];

	If[indices === $Failed,
		Message[choose::badselection, selection];
		Return[$Failed]
	];

	choices = Lookup[data, "Choices", {}];

	If[choices === {},
		Message[choose::nochoices, Lookup[data, "Subtitle", "the previous output"]];
		Return[$Failed]
	];

	invalid = Select[indices, # < 1 || # > Length[choices] &];

	If[invalid =!= {},
		Message[choose::badindex, First[invalid], Length[choices]];
		Return[$Failed]
	];

	selected = choices[[indices]];
	displayChoice[Lookup[data, "Subtitle", ""], Lookup[selected, "Text"]]
];

choose[output_, selection_] := (
	Message[choose::badoutput, output];
	$Failed
);

choose::badselection =
"`1` is not a valid choice selection. Use an integer or a non-empty list of integers.";

choose::nochoices =
"`1` does not expose any choices.";

choose::badindex =
"Choice `1` is not available. Valid choices are 1 through `2`.";

choose::badoutput =
"`1` is not a move header or outcome output. Use a value returned by a move display function.";


(* ::Section::Closed:: *)
(*Move wrapper implementation*)


(* ::Subsection::Closed:: *)
(*Adventure moves*)


(* ::Subsubsection::Closed:: *)
(*Face Danger*)


faceDanger[] := displayMove["faceDanger"];
faceDanger[actionRoll_Association] := displayMove["faceDanger", actionRoll];


(* ::Subsubsection::Closed:: *)
(*Secure an Advantage*)


secureAnAdvantage[] := displayMove["secureAnAdvantage"];
secureAnAdvantage[actionRoll_Association] := displayMove["secureAnAdvantage", actionRoll];


(* ::Subsubsection::Closed:: *)
(*Gather Information*)


gatherInformation[] := displayMove["gatherInformation"];
gatherInformation[actionRoll_Association] := displayMove["gatherInformation", actionRoll];


(* ::Subsubsection::Closed:: *)
(*Make Camp*)


makeCamp[] := displayMove["makeCamp"];
makeCamp[actionRoll_Association] := displayMove["makeCamp", actionRoll];


(* ::Subsubsection::Closed:: *)
(*Heal*)


heal[] := displayMove["heal"];
heal[actionRoll_Association] := displayMove["heal", actionRoll];


(* ::Subsubsection::Closed:: *)
(*Resupply*)


resupply[] := displayMove["resupply"];
resupply[actionRoll_Association] := displayMove["resupply", actionRoll];


(* ::Subsubsection::Closed:: *)
(*Check Your Gear*)


checkYourGear[] := displayMove["checkYourGear"];
checkYourGear[actionRoll_Association] := displayMove["checkYourGear", actionRoll];


(* ::Subsection::Closed:: *)
(*Journey moves*)


(* ::Subsubsection::Closed:: *)
(*Undertake a Journey*)


undertakeAJourney[] := displayMove["undertakeAJourney"];
undertakeAJourney[actionRoll_Association] := displayMove["undertakeAJourney", actionRoll];


(* ::Subsubsection::Closed:: *)
(*Reach Your Destination*)


reachYourDestination[] := displayMove["reachYourDestination"];
reachYourDestination[progressRoll_Association] := displayMove["reachYourDestination", progressRoll];


(* ::Subsubsection::Closed:: *)
(*Follow a Path*)


followAPath[] := displayMove["followAPath"];
followAPath[actionRoll_Association] := displayMove["followAPath", actionRoll];


(* ::Subsection::Closed:: *)
(*Scene challenge moves*)


(* ::Subsubsection::Closed:: *)
(*Begin the Scene*)


beginTheScene[] := displayMove["beginTheScene"];


(* ::Subsubsection::Closed:: *)
(*Face Danger (Scene)*)


faceDangerScene[] := displayMove["faceDangerScene"];
faceDangerScene[actionRoll_Association] := displayMove["faceDangerScene", actionRoll];


(* ::Subsubsection::Closed:: *)
(*Secure an Advantage (Scene)*)


secureAnAdvantageScene[] := displayMove["secureAnAdvantageScene"];
secureAnAdvantageScene[actionRoll_Association] := displayMove["secureAnAdvantageScene", actionRoll];


(* ::Subsubsection::Closed:: *)
(*Finish the Scene*)


finishTheScene[] := displayMove["finishTheScene"];
finishTheScene[progressRoll_Association] := displayMove["finishTheScene", progressRoll];


(* ::Subsection::Closed:: *)
(*Quest moves*)


(* ::Subsubsection::Closed:: *)
(*Swear an Iron Vow*)


swearAnIronVow[] := displayMove["swearAnIronVow"];
swearAnIronVow[actionRoll_Association] := displayMove["swearAnIronVow", actionRoll];


(* ::Subsubsection::Closed:: *)
(*Reach a Milestone*)


reachAMilestone[] := displayMove["reachAMilestone"];


(* ::Subsubsection::Closed:: *)
(*Fulfill Your Vow*)


fulfillYourVow[] := displayMove["fulfillYourVow"];
fulfillYourVow[progressRoll_Association] := displayMove["fulfillYourVow", progressRoll];


(* ::Subsubsection::Closed:: *)
(*Forsake Your Vow*)


forsakeYourVow[] := displayMove["forsakeYourVow"];


(* ::Subsubsection::Closed:: *)
(*Advance*)


advance[] := displayMove["advance"];


(* ::Subsection::Closed:: *)
(*Fate moves*)


(* ::Subsubsection::Closed:: *)
(*Pay the Price*)


payThePrice[] := displayMove["payThePrice"];


(* ::Subsubsection::Closed:: *)
(*Ask the Oracle*)


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

monstrosityOracle[] := Module[
	{components, characteristics, abilities, result},
	components = Join[
		{
			siteNameComponent["Size", "Monstrosity: Size"],
			siteNameComponent["Primary Form", "Monstrosity: Primary Form"]
		},
		Table[siteNameComponent["Characteristic " <> ToString[i], "Monstrosity: Characteristics"], {i, 4}],
		Table[siteNameComponent["Ability " <> ToString[i], "Monstrosity: Abilities"], {i, 4}]
	];
	If[MemberQ[components, $Failed], Return[$Failed]];
	characteristics = Lookup[components[[3 ;; 6]], "outcome"];
	abilities = Lookup[components[[7 ;; 10]], "outcome"];
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

askTheOracle[] := displayMove["askTheOracle"];

askTheOracle["Reveal a Danger"] := Module[
	{ownedDelve},
	ownedDelve = currentDelveDataQuiet[$soloCharacter];
	If[AssociationQ[ownedDelve],
		delveCompositeOracleRoll["Reveal a Danger", ownedDelve, revealDangerCombinedTable, dangerCardsForValue],
		oracleRoll["Reveal a Danger: Alternate", revealDangerAlternateTable]
	]
];

askTheOracle["Reveal a Danger", theme_String, domain_String] := oracleRoll["Reveal a Danger ("<>theme<>", "<>domain<>")", revealDangerCombinedTable[theme, domain]];

askTheOracle["Delve Site Feature"] := Module[
	{ownedDelve},
	ownedDelve = currentDelveData[$soloCharacter];
	If[ownedDelve === $Failed, Return[$Failed]];
	delveCompositeOracleRoll["Delve Site Feature", ownedDelve, delveSiteFeatureTable, featureCardsForValue]
];

askTheOracle["Delve Site Feature", theme_String, domain_String] := oracleRoll["Delve Site Feature ("<>theme<>", "<>domain<>")", delveSiteFeatureTable[theme, domain]];

askTheOracle["Delve Site Name"] := Module[
	{ownedDelve},
	ownedDelve = currentDelveData[$soloCharacter];
	If[ownedDelve === $Failed, Return[$Failed]];
	delveSiteNameOracle[ownedDelve["Domains"]]
];

askTheOracle["Delve Site Name", domain_String] :=
	delveSiteNameOracle[domain];

askTheOracle["Monstrosity"] :=
	monstrosityOracle[];

askTheOracle["Trap"] :=
	compositeOracleRoll[
		"Trap",
		{{"Event", "Delve Site: Trap Event"}, {"Component", "Delve Site: Trap Component"}},
		(StringRiffle[Lookup[#, "outcome"], " "] &)
	];

askTheOracle["Combat Event"] :=
	compositeOracleRoll[
		"Combat Event",
		{{"Method", "Combat: Event Method"}, {"Target", "Combat: Event Target"}},
		(StringRiffle[Lookup[#, "outcome"], " "] &)
	];

askTheOracle["Threat"] :=
	threatOracle[];

askTheOracle["Threat", category_String] := Module[
	{tableName},
	tableName = "Threat: " <> category;
	oracleRollByName[tableName]
];

askTheOracle[tableName_String] := oracleRollByName[tableName];
askTheOracle["Yes/No", odds_String] := oracleRollByName["Yes/No: " <> odds];
askTheOracle["Yes/No", yesOutcome_String, noOutcome_String] := oracleRoll["Yes/No", yesNo[yesOutcome, noOutcome]];

oracle::unknown = "Unknown oracle table `1`.";


(* ::Subsection::Closed:: *)
(*Relationship moves*)


(* ::Subsubsection::Closed:: *)
(*Compel*)


compel[] := displayMove["compel"];
compel[actionRoll_Association] := displayMove["compel", actionRoll];


(* ::Subsubsection::Closed:: *)
(*Aid Your Ally*)


aidYourAlly[] := displayMove["aidYourAlly"];


(* ::Subsubsection::Closed:: *)
(*Sojourn*)


sojourn[] := displayMove["sojourn"];
sojourn[actionRoll_Association] := displayMove["sojourn", actionRoll];

sojournFocus[] := displayMove["sojournFocus"];
sojournFocus[actionRoll_Association] := displayMove["sojournFocus", actionRoll];


(* ::Subsubsection::Closed:: *)
(*Forge a Bond*)


forgeABond[] := displayMove["forgeABond"];
forgeABond[actionRoll_Association] := displayMove["forgeABond", actionRoll];


(* ::Subsubsection::Closed:: *)
(*Test Your Bond*)


testYourBond[] := displayMove["testYourBond"];
testYourBond[actionRoll_Association] := displayMove["testYourBond", actionRoll];


(* ::Subsubsection::Closed:: *)
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


endTheFightTransformer[roll_Association, initiative_] := Module[
  {map, transformed},
  map = {"strongHit" -> "weakHit", "weakHit" -> "miss", "miss" -> "miss"};
  transformed = Association[roll];
  If[! TrueQ[initiative],
    transformed["result"] = Replace[transformed["result"], map]
  ];
  transformed
];

Options[endTheFight] = {Initiative -> True};
endTheFight[] := displayMove["endTheFight"];
endTheFight[actionRoll_Association, opts:OptionsPattern[]] := displayMove["endTheFight", endTheFightTransformer[actionRoll, OptionValue[Initiative]]];


(* ::Subsection::Closed:: *)
(*Suffer moves*)


(* ::Subsubsection::Closed:: *)
(*Endure Harm*)


endureHarm[] := displayMove["endureHarm"];
endureHarm[actionRoll_Association] := displayMove["endureHarm", actionRoll];


(* ::Subsubsection::Closed:: *)
(*Face Death*)


faceDeath[] := displayMove["faceDeath"];
faceDeath[actionRoll_Association] := displayMove["faceDeath", actionRoll];


(* ::Subsubsection::Closed:: *)
(*Companion Endure Harm*)


companionEndureHarm[] := displayMove["companionEndureHarm"];
companionEndureHarm[actionRoll_Association] := displayMove["companionEndureHarm", actionRoll];


(* ::Subsubsection::Closed:: *)
(*Endure Stress*)


endureStress[] := displayMove["endureStress"];
endureStress[actionRoll_Association] := displayMove["endureStress", actionRoll];


(* ::Subsubsection::Closed:: *)
(*Face Desolation*)


faceDesolation[] := displayMove["faceDesolation"];
faceDesolation[actionRoll_Association] := displayMove["faceDesolation", actionRoll];


(* ::Subsubsection::Closed:: *)
(*Out of Supply*)


outOfSupply[] := displayMove["outOfSupply"];


(* ::Subsubsection::Closed:: *)
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
learnFromYourFailures[progressRoll_Association] := Module[
	{trackName, progressScore},
	trackName = Lookup[progressRoll, "trackName", None];
	progressScore = Lookup[progressRoll, "progressScore", Missing["NoProgressScore"]];
	If[trackName =!= "Failures",
		Message[learnFromYourFailures::badroll, trackName];
		Return[$Failed]
	];
	If[!NumericQ[progressScore] || progressScore < 6,
		Message[learnFromYourFailures::threshold, progressScore];
		Return[$Failed]
	];
	displayMove["learnFromYourFailures", progressRoll]
];

learnFromYourFailures::badroll = "learnFromYourFailures[roll] requires a progress roll against Failures, not `1`.";
learnFromYourFailures::threshold = "learnFromYourFailures[roll] requires the Failures progress score to be at least 6, not `1`.";


(* ::Subsection::Closed:: *)
(*Threat moves*)


(* ::Subsubsection::Closed:: *)
(*Advance a Threat*)


advanceAThreat[] := displayMove["advanceAThreat"];


(* ::Subsubsection::Closed:: *)
(*Take a Hiatus*)


takeAHiatus[] := displayMove["takeAHiatus"];


(* ::Subsection::Closed:: *)
(*Rarity moves*)


(* ::Subsubsection::Closed:: *)
(*Gain a Rarity*)


gainARarity[] := displayMove["gainARarity"];


(* ::Subsubsection::Closed:: *)
(*Wield a Rarity*)


wieldARarity[] := displayMove["wieldARarity"];


(* ::Section::Closed:: *)
(*Private context footer*)


End[];


(* ::Section:: *)
(*Package footer*)


EndPackage[];
