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


(* ::Section:: *)
(*Public interface*)


(* ::Text:: *)
(*The following functions are exposed to the user.*)


(* ::Subsection::Closed:: *)
(*Stories and chapters*)


beginStory::usage =
"beginStory[name] starts a new story using name as the story name. Call beginStory[name] before createCharacter to establish the reproducible seed for character creation draws.";

beginChapter::usage =
"beginChapter[] loads the state for the current chapter, seeds the random number generator, and displays the solo character sheet, owned assets, and current delve if any.
beginChapter[Display -> False] suppresses those displays.
beginChapter[ArcName -> arc] renames the current chapter as the first chapter of arc after loading its state.";

endChapter::usage =
"endChapter[] saves the state for the next chapter, creates the next chapter notebook, and displays the solo character sheet, owned assets, and current delve if any.
endChapter[Display -> False] suppresses those displays.";


(* ::Subsection::Closed:: *)
(*Characters*)


setSoloCharacter::usage =
"setSoloCharacter[character] sets the solo character to character.";

createCharacter::usage =
"createCharacter[name, {a1, a2, a3}, edge, heart, iron, shadow, wits, vow[...] | {vowName, Extreme | Epic}, {b1, b2, b3}] creates a character, sets it as the solo character, and displays the character sheet, starting assets, and current delve if any. Starting assets may be asset name strings when the card has a printed default selected ability, or asset[...] specs.
createCharacter[..., Display -> False] suppresses those displays.";

characterSheet::usage =
"characterSheet[] displays a Lodestar-style character sheet for the solo character.
characterSheet[character] displays a Lodestar-style character sheet for the named character.";


(* ::Subsection::Closed:: *)
(*Action rolls*)


actionRoll::usage =
"actionRoll[stat] makes an action roll using stat for the solo character.
actionRoll[stat, character] makes an action roll using stat for character.";


(* ::Subsection::Closed:: *)
(*Momentum burns*)


burnMomentum::usage =
"burnMomentum[roll] burns momentum for roll and returns the modified roll result.";


(* ::Subsection::Closed:: *)
(*Progress rolls*)


progressRoll::usage =
"progressRoll[track] makes a progress roll against track for the solo character.
progressRoll[track, character] makes a progress roll against track for character.
progressRoll[CompanionHealth[assetName]] rolls against an owned companion's health.
progressRoll[WarbandStrength | Wealth | SimulacrumHealth | Essence | Light] rolls against the matching owned asset track.";


(* ::Subsection::Closed:: *)
(*Rerolls*)


reroll::usage =
"reroll[roll, die] rerolls die in roll and returns the modified roll.
reroll[roll, {die1, die2, ...}] rerolls the specified dice in roll and returns the modified roll.

Possible dice are AllDice, ActionDie, ChallengeDice, LargerChallengeDie, and SmallerChallengeDie.

AllDice rerolls every die in an action roll, or both challenge dice in a progress roll. ActionDie may only be used with action rolls. Challenge dice may be rerolled in action rolls and progress rolls.

reroll[..., Display -> False] suppresses display.";


(* ::Subsection::Closed:: *)
(*Choices*)


choose::usage =
"choose[displayOutput, n] displays the nth choice from a previous move, outcome, or asset display output.
choose[displayOutput, {n1, n2, ...}] displays multiple choices from a previous move, outcome, or asset display output.

Typical usage is moveFunction[]; choose[%, n], or getAsset[name]; choose[%, n].";


(* ::Subsection::Closed:: *)
(*Resources*)


sufferMomentum::usage =
"sufferMomentum[n] adjusts the solo character's momentum by negative integer n.
sufferMomentum[n, character] adjusts character's momentum by negative integer n.";

takeMomentum::usage =
"takeMomentum[n] adjusts the solo character's momentum by positive integer n.
takeMomentum[n, character] adjusts character's momentum by positive integer n.";

sufferHealth::usage =
"sufferHealth[n] adjusts the solo character's health by negative integer n.
sufferHealth[n, character] adjusts character's health by negative integer n.";

takeHealth::usage =
"takeHealth[n] adjusts the solo character's health by positive integer n.
takeHealth[n, character] adjusts character's health by positive integer n.";

sufferSpirit::usage =
"sufferSpirit[n] adjusts the solo character's spirit by negative integer n.
sufferSpirit[n, character] adjusts character's spirit by negative integer n.";

takeSpirit::usage =
"takeSpirit[n] adjusts the solo character's spirit by positive integer n.
takeSpirit[n, character] adjusts character's spirit by positive integer n.";

sufferSupply::usage =
"sufferSupply[n] adjusts the solo character's supply by negative integer n.
sufferSupply[n, character] adjusts character's supply by negative integer n.";

takeSupply::usage =
"takeSupply[n] adjusts the solo character's supply by positive integer n.
takeSupply[n, character] adjusts character's supply by positive integer n.";

recover::usage =
"recover[] applies the Take a Hiatus recovery package to the solo character without advancing threats.
recover[character] applies the Take a Hiatus recovery package to character without advancing threats.";


(* ::Subsection::Closed:: *)
(*Debilities*)


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

markOathbreaker::usage =
"markOathbreaker[] marks Oathbreaker for the solo character.
markOathbreaker[character] marks Oathbreaker for character.";

clearOathbreaker::usage =
"clearOathbreaker[] clears Oathbreaker for the solo character.
clearOathbreaker[character] clears Oathbreaker for character.";


(* ::Subsection::Closed:: *)
(*Experience*)


markExperience::usage =
"markExperience[n] adds n earned experience to the solo character.
markExperience[n, character] adds n earned experience to character.";


(* ::Subsection::Closed:: *)
(*Assets*)


asset::usage =
"asset[name] creates a quiet starting asset spec using the asset's printed default selected abilities.
asset[name, ability] creates a quiet starting asset spec with the selected ability index, only when the asset has no printed default selected ability.
asset[name, {ability1, ability2, ...}] creates a quiet starting asset spec with multiple selected abilities, only when the asset has no printed default selected ability.
asset[name, field -> value, ...] creates a quiet starting asset spec with custom field values such as Name -> \"Asha\".
asset[name, abilityOrAbilities, field -> value, ...] includes custom field values with selected abilities when starting ability selection is allowed.";

getAsset::usage =
"getAsset[name] displays the owned asset named name for the solo character, or the default reference card if the solo character does not own it.
getAsset[name, character] displays the owned asset named name for character.";

getAssetAbility::usage =
"getAssetAbility[name, ability] displays one selected ability from an owned asset for the solo character.
getAssetAbility[name, ability, character] displays one selected ability from an owned asset for character.";

getAssets::usage =
"getAssets[] displays all owned assets for the solo character.
getAssets[character] displays all owned assets for character.";

drawAssets::usage =
"drawAssets[] displays three random reference asset cards and returns their canonical names.
drawAssets[n] displays n random reference asset cards.
drawAssets[n, category] draws from category, one of Companion, PathAsset, CombatTalent, or Ritual. The Wolfram Path symbol is also accepted for path assets.";

addAsset::usage =
"addAsset[name] spends 5 experience to add an asset to the solo character using the asset's printed default selected abilities and displays the updated card.
addAsset[name, ability] spends 5 experience to add an asset with the selected ability index, only when the asset has no printed default selected ability.
addAsset[name, {ability1, ability2, ...}] spends 5 experience to add an asset with multiple selected abilities, only when the asset has no printed default selected ability.
addAsset[name, field -> value, ...] spends 5 experience to add an asset with custom field values such as Name -> \"Asha\".
addAsset[name, abilityOrAbilities, field -> value, ...] includes custom field values with selected abilities when starting ability selection is allowed.
Any addAsset form may include character before options.
addAsset[..., Display -> False] suppresses display.";

upgradeAsset::usage =
"upgradeAsset[name, ability] spends 3 experience to mark ability on an owned asset for the solo character and displays the updated card.
upgradeAsset[name, ability, character] spends 3 experience to mark ability on an owned asset for character.
upgradeAsset[..., Display -> False] suppresses display.";

sufferCompanionHealth::usage =
"sufferCompanionHealth[assetName, n] adjusts an owned companion's health by negative integer n for the solo character.
sufferCompanionHealth[assetName, n, character] adjusts an owned companion's health by negative integer n for character.";

takeCompanionHealth::usage =
"takeCompanionHealth[assetName, n] adjusts an owned companion's health by positive integer n for the solo character.
takeCompanionHealth[assetName, n, character] adjusts an owned companion's health by positive integer n for character.";

sufferWarbandStrength::usage =
"sufferWarbandStrength[] subtracts 1 from the solo character's Commander warband strength.
sufferWarbandStrength[character] subtracts 1 from character's Commander warband strength.";

takeWarbandStrength::usage =
"takeWarbandStrength[] adds 1 to the solo character's Commander warband strength.
takeWarbandStrength[character] adds 1 to character's Commander warband strength.";

sufferWealth::usage =
"sufferWealth[] subtracts 1 from the solo character's Fortune Hunter wealth.
sufferWealth[character] subtracts 1 from character's Fortune Hunter wealth.";

takeWealth::usage =
"takeWealth[n] adjusts the solo character's Fortune Hunter wealth by positive integer n.
takeWealth[n, character] adjusts character's Fortune Hunter wealth by positive integer n.";

sufferSimulacrumHealth::usage =
"sufferSimulacrumHealth[n] adjusts the solo character's Awakening simulacrum health by negative integer n.
sufferSimulacrumHealth[n, character] adjusts character's Awakening simulacrum health by negative integer n.";

resetSimulacrumHealth::usage =
"resetSimulacrumHealth[] resets the solo character's Awakening simulacrum health to 3, or 6 if ability 2 is marked.
resetSimulacrumHealth[character] resets character's Awakening simulacrum health.";

sufferEssence::usage =
"sufferEssence[] subtracts 1 from the solo character's Invoke essence.
sufferEssence[character] subtracts 1 from character's Invoke essence.";

takeEssence::usage =
"takeEssence[roll] adds roll's action die value to the solo character's Invoke essence on a hit.
takeEssence[roll, character] adds roll's action die value to character's Invoke essence on a hit.";

sufferLight::usage =
"sufferLight[n] adjusts the solo character's Lightbearer light by negative integer n.
sufferLight[n, character] adjusts character's Lightbearer light by negative integer n.";

resetLight::usage =
"resetLight[roll] resets the solo character's Lightbearer light to 3 on a weak hit or 6 on a strong hit.
resetLight[roll, character] resets character's Lightbearer light from roll.";

setIroncladArmor::usage =
"setIroncladArmor[choice] chooses Unequipped, Lightly armored, or Geared for war for the solo character's Ironclad asset and displays the updated card.
setIroncladArmor[choice, character] chooses an Ironclad armor mode for character.
choice may be \"Unequipped\", \"unequipped\", \"Lightly armored\", \"lightly-armored\", \"Geared for war\", or \"geared-for-war\".
setIroncladArmor[..., Display -> False] suppresses display.";

removeAsset::usage =
"removeAsset[name] removes an owned asset from the solo character without awarding experience.
removeAsset[name, character] removes an owned asset from character without awarding experience.
removeAsset[..., Display -> False] suppresses display.";



(* ::Subsection::Closed:: *)
(*Progress tracks*)


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


(* ::Subsection::Closed:: *)
(*Vows*)


vow::usage =
"vow[name, Extreme | Epic] creates a quiet starting vow spec.
vow[name, Extreme | Epic, Threat -> {threatName, threatGoal}] creates a quiet starting vow spec with one attached threat.";

addVow::usage =
"addVow[name, rank] adds a vow to the solo character.
addVow[name, rank, character] adds a vow to character.
addVow[..., Threat -> {threatName, threatGoal}] adds a vow with one attached threat.";

getVow::usage =
"getVow[name] displays the vow named name for the solo character.
getVow[name, character] displays the vow named name for character.";

getVows::usage =
"getVows[] displays all vows for the solo character.
getVows[character] displays all vows for character.";

removeVow::usage =
"removeVow[name] removes the named vow from the solo character.
removeVow[name, character] removes the named vow from character.";

setThreat::usage =
"setThreat[vowName, {threatName, threatGoal}] sets or replaces the threat attached to vowName for the solo character.
setThreat[vowName, {threatName, threatGoal}, character] sets or replaces the threat attached to vowName for character.";

removeThreat::usage =
"removeThreat[vowName] removes the threat attached to vowName for the solo character.
removeThreat[vowName, character] removes the threat attached to vowName for character.";



(* ::Subsection::Closed:: *)
(*Journeys*)


beginJourney::usage =
"beginJourney[name, rank] begins the journey progress track for the solo character.
beginJourney[name, rank, character] begins the journey progress track for character.";

getJourney::usage =
"getJourney[] displays the journey for the solo character.
getJourney[character] displays the journey for character.";

endJourney::usage =
"endJourney[] ends the journey for the solo character.
endJourney[character] ends the journey for character.";


(* ::Subsection::Closed:: *)
(*Foes*)


addFoe::usage =
"addFoe[name, rank] adds a foe progress track for the solo character.
addFoe[name, rank, character] adds a foe progress track for character.";

getFoe::usage =
"getFoe[name] displays the named foe for the solo character.
getFoe[name, character] displays the named foe for character.";

getFoes::usage =
"getFoes[] displays all foes for the solo character.
getFoes[character] displays all foes for character.";

removeFoe::usage =
"removeFoe[name] removes the named foe from the solo character.
removeFoe[name, character] removes the named foe from character.";


(* ::Subsection::Closed:: *)
(*Scenes*)


beginScene::usage =
"beginScene[name, rank] creates the active scene challenge for the solo character.
beginScene[name, rank, character] creates the active scene challenge for character.";

getScene::usage =
"getScene[] displays the active scene challenge for the solo character.
getScene[character] displays the active scene challenge for character.";

endScene::usage =
"endScene[] ends the active scene challenge for the solo character.
endScene[character] ends the active scene challenge for character.";

markSceneCountdown::usage =
"markSceneCountdown[] marks 1 segment on the solo character's active scene countdown.
markSceneCountdown[n] marks n segments on the solo character's active scene countdown.
markSceneCountdown[n, character] marks n segments on character's active scene countdown.";


(* ::Subsection::Closed:: *)
(*Delves*)


addDelve::usage =
"addDelve[name, rank, themeOrThemes, domainOrDomains] adds a delve site for the solo character.
addDelve[name, rank, themeOrThemes, domainOrDomains, denizens] adds a delve site with a 12-slot denizens matrix.
addDelve[..., character] adds a delve site for character.

themeOrThemes and domainOrDomains must be a delve theme/domain symbol or a two-symbol list, but a delve cannot have both two themes and two domains.
addDelve[..., Objective -> objective] records an optional objective string.";

beginDelve::usage =
"beginDelve[name] sets the current delve for the solo character to an existing delve.
beginDelve[name, character] sets the current delve for character to an existing delve.
beginDelve[name, rank, themeOrThemes, domainOrDomains] creates a delve site for the solo character and sets it as current.
beginDelve[name, rank, themeOrThemes, domainOrDomains, denizens] creates a delve site with a 12-slot denizens matrix and sets it as current.
beginDelve[..., character] creates a delve site for character and sets it as current.

themeOrThemes and domainOrDomains must be a delve theme/domain symbol or a two-symbol list, but a delve cannot have both two themes and two domains.
beginDelve[..., Objective -> objective] records an optional objective string.";

endDelve::usage =
"endDelve[] clears the current delve for the solo character without removing the delve.
endDelve[character] clears the current delve for character without removing the delve.";

getDelve::usage =
"getDelve[] displays the current delve for the solo character.
getDelve[name] displays the named delve for the solo character.
getDelve[name, character] displays the named delve for character.";

getDelves::usage =
"getDelves[] displays all delves for the solo character.
getDelves[character] displays all delves for character.";

setDelveTheme::usage =
"setDelveTheme[themeOrThemes] updates the current delve's theme cards.
setDelveTheme[delveName, themeOrThemes] updates the named delve's theme cards for the solo character.
setDelveTheme[delveName, themeOrThemes, character] updates the named delve's theme cards for character.
themeOrThemes must be a delve theme symbol or a two-symbol list.";

setDelveDomain::usage =
"setDelveDomain[domainOrDomains] updates the current delve's domain cards.
setDelveDomain[delveName, domainOrDomains] updates the named delve's domain cards for the solo character.
setDelveDomain[delveName, domainOrDomains, character] updates the named delve's domain cards for character.
domainOrDomains must be a delve domain symbol or a two-symbol list.";

returnToSite::usage =
"returnToSite[] rolls the return challenge dice for the current delve and returns the lower die value to clear manually.
returnToSite[delveName] rolls for the named delve for the solo character.
returnToSite[delveName, character] rolls for the named delve for character.";

rollDenizen::usage =
"rollDenizen[] rolls on the current delve's denizens matrix.
rollDenizen[delveName] rolls on the named delve's denizens matrix for the solo character.
rollDenizen[delveName, character] rolls on the named delve's denizens matrix for character.";

setDenizen::usage =
"setDenizen[slotSymbol, name] sets slotSymbol in the current delve's denizens matrix.
setDenizen[delveName, slot, name] sets slot in the named delve's denizens matrix for the solo character.
setDenizen[delveName, slot, name, character] sets slot in the named delve's denizens matrix for character.
slot must be a denizen slot symbol, such as VeryCommon, Common1, Uncommon3, Rare2, or Unforeseen.";

clearDenizen::usage =
"clearDenizen[slotSymbol] clears slotSymbol in the current delve's denizens matrix.
clearDenizen[delveName, slot] clears slot in the named delve's denizens matrix for the solo character.
clearDenizen[delveName, slot, character] clears slot in the named delve's denizens matrix for character.
slot must be a denizen slot symbol, such as VeryCommon, Common1, Uncommon3, Rare2, or Unforeseen.";


(* ::Subsection::Closed:: *)
(*Rarities*)


rarityDieSix::usage =
"rarityDieSix[roll] displays a Rarity Die conversion to a strong hit and returns a copy of the action roll with a strong hit result. The action die must be 6.";

addRarity::usage =
"addRarity[assetName, rarityName] spends experience to augment an eligible owned asset for the solo character.
addRarity[assetName, rarityName, character] spends experience to augment an eligible owned asset for character.
addRarity[..., Display -> False] suppresses display.";

removeRarity::usage =
"removeRarity[assetName] removes a rarity from an owned asset for the solo character and awards 1 experience.
removeRarity[assetName, character] removes a rarity from an owned asset for character and awards 1 experience.
removeRarity[..., Display -> False] suppresses display.";


(* ::Subsection::Closed:: *)
(*Bonds*)


addBond::usage =
"addBond[bond] adds bond to the solo character and marks progress on the bonds track.
addBond[bond, character] adds bond to character and marks progress on the bonds track.";

getBonds::usage =
"getBonds[] displays all bonds and the bonds progress track for the solo character.
getBonds[character] displays all bonds and the bonds progress track for character.";

removeBond::usage =
"removeBond[name] removes the named bond from the solo character and clears one tick on the bonds track.
removeBond[name, character] removes the named bond from character and clears one tick on the bonds track.";


(* ::Subsection::Closed:: *)
(*Failures*)


getFailures::usage =
"getFailures[] displays the failure progress track for the solo character.
getFailures[character] displays the failure progress track for character.";



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
(*Stat symbols*)


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


(* ::Subsection::Closed:: *)
(*Resource symbols*)


Health::usage =
"Health is a stat.";

Spirit::usage =
"Spirit is a stat.";

Supply::usage =
"Supply is a stat";


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
(*Delve theme symbols*)


Ancient::usage =
"Ancient is a delve theme symbol.";

Corrupted::usage =
"Corrupted is a delve theme symbol.";

Fortified::usage =
"Fortified is a delve theme symbol.";

Hallowed::usage =
"Hallowed is a delve theme symbol.";

Haunted::usage =
"Haunted is a delve theme symbol.";

Infested::usage =
"Infested is a delve theme symbol.";

Ravaged::usage =
"Ravaged is a delve theme symbol.";

Wild::usage =
"Wild is a delve theme symbol.";


(* ::Subsection::Closed:: *)
(*Delve domain symbols*)


Barrow::usage =
"Barrow is a delve domain symbol.";

Cavern::usage =
"Cavern is a delve domain symbol.";

FrozenCavern::usage =
"FrozenCavern is the delve domain symbol for Frozen Cavern.";

Icereach::usage =
"Icereach is a delve domain symbol.";

Mine::usage =
"Mine is a delve domain symbol.";

Pass::usage =
"Pass is a delve domain symbol.";

Ruin::usage =
"Ruin is a delve domain symbol.";

SeaCave::usage =
"SeaCave is the delve domain symbol for Sea Cave.";

Shadowfen::usage =
"Shadowfen is a delve domain symbol.";

Stronghold::usage =
"Stronghold is a delve domain symbol.";

Tanglewood::usage =
"Tanglewood is a delve domain symbol.";

Underkeep::usage =
"Underkeep is a delve domain symbol.";


(* ::Subsection::Closed:: *)
(*Denizen slot symbols*)


VeryCommon::usage =
"VeryCommon is the denizen slot symbol for the Very Common 01-27 slot.";

Common1::usage =
"Common1 is the denizen slot symbol for the Common 28-41 slot.";

Common2::usage =
"Common2 is the denizen slot symbol for the Common 42-55 slot.";

Common3::usage =
"Common3 is the denizen slot symbol for the Common 56-69 slot.";

Uncommon1::usage =
"Uncommon1 is the denizen slot symbol for the Uncommon 70-75 slot.";

Uncommon2::usage =
"Uncommon2 is the denizen slot symbol for the Uncommon 76-81 slot.";

Uncommon3::usage =
"Uncommon3 is the denizen slot symbol for the Uncommon 82-87 slot.";

Uncommon4::usage =
"Uncommon4 is the denizen slot symbol for the Uncommon 88-93 slot.";

Rare1::usage =
"Rare1 is the denizen slot symbol for the Rare 94-95 slot.";

Rare2::usage =
"Rare2 is the denizen slot symbol for the Rare 96-97 slot.";

Rare3::usage =
"Rare3 is the denizen slot symbol for the Rare 98-99 slot.";

Unforeseen::usage =
"Unforeseen is the denizen slot symbol for the Unforeseen 00 slot.";


(* ::Subsection::Closed:: *)
(*Asset category symbols*)


Companion::usage =
"Companion is the asset category symbol for companion assets.";

PathAsset::usage =
"PathAsset is the asset category symbol for path assets.";

CombatTalent::usage =
"CombatTalent is the asset category symbol for combat talent assets.";

Ritual::usage =
"Ritual is the asset category symbol for ritual assets.";


(* ::Subsection::Closed:: *)
(*Asset track symbols*)


CompanionHealth::usage =
"CompanionHealth[assetName] is a progressRoll target for an owned companion's health track.";

WarbandStrength::usage =
"WarbandStrength is a progressRoll target for the Commander strength track.";

Wealth::usage =
"Wealth is a progressRoll target for the Fortune Hunter wealth track.";

SimulacrumHealth::usage =
"SimulacrumHealth is a progressRoll target for the Awakening health track.";

Essence::usage =
"Essence is a progressRoll target for the Invoke essence track.";

Light::usage =
"Light is a progressRoll target for the Lightbearer light track.";


(* ::Subsection::Closed:: *)
(*Reroll selection symbols*)


AllDice::usage =
"AllDice specifies every die for reroll. In an action roll, this rerolls the action die and both challenge dice. In a progress roll, this rerolls both challenge dice.";

ActionDie::usage =
"ActionDie specifies the action die for reroll.";

ChallengeDice::usage =
"ChallengeDice specifies both challenge dice for reroll.";

LargerChallengeDie::usage =
"LargerChallengeDie specifies the larger challenge die for reroll. If the challenge dice are tied, the first challenge die is selected.";

SmallerChallengeDie::usage =
"SmallerChallengeDie specifies the smaller challenge die for reroll. If the challenge dice are tied, the first challenge die is selected.";


(* ::Subsection::Closed:: *)
(*Option symbols*)


Name::usage =
"Name is a public symbol reserved by IronLibrary and the asset field symbol for Name fields.";

Assets::usage =
"Assets is a public symbol reserved by IronLibrary.";

BackgroundVow::usage =
"BackgroundVow is a public symbol reserved by IronLibrary.";

Bonds::usage =
"Bonds is a public symbol reserved by IronLibrary.";

Adds::usage =
"Adds is an option for actionRoll that specifies a list of named bonus rules.";

ArcName::usage =
"ArcName is an option for beginChapter that specifies the arc name to use for the current chapter.";

Initiative::usage =
"Initiative is a True/False option for endTheFight, which specifies whether the character has initiative.";

Display::usage =
"Display is an option that specifies whether a function should display its result.";

Threat::usage =
"Threat is an option for vow and addVow that specifies an attached threat as {threatName, threatGoal}.";

Objective::usage =
"Objective is an option for addDelve that specifies the site objective.";

Expertise::usage =
"Expertise is an asset field symbol for field rules.";

GodsName::usage =
"GodsName is an asset field symbol for the printed \"God's Name\" field.";

Stat::usage =
"Stat is an asset field symbol for field rules.";

TitleLineage::usage =
"TitleLineage is an asset field symbol for the printed \"Title/Lineage\" field.";

Specialty::usage =
"Specialty is an asset field symbol for field rules.";

Equipped::usage =
"Equipped is an asset field symbol for field rules.";


(* ::Section::Closed:: *)
(*Private implementation*)


(* ::Subsection::Closed:: *)
(*Private context header*)


Begin["`Private`"];


(* ::Subsection::Closed:: *)
(*Implementation imports*)


If[!ValueQ[$IronLibraryPath], $IronLibraryPath = If[StringQ[$InputFileName] && $InputFileName =!= "", $InputFileName, $Failed]];

$ironLibraryHelperDirectory = DirectoryName[$IronLibraryPath];

Quiet[
	Get[FileNameJoin[{$ironLibraryHelperDirectory, "TextHelpers.wl"}]];
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
	"IronLibrary`FileHelpers`" | "IronLibrary`MechanicsHelpers`" | "IronLibrary`DisplayHelpers`" |
		"IronLibrary`TextHelpers`"
];
$ContextPath = DeleteDuplicates[Prepend[$ContextPath, "IronLibrary`"]];


(* ::Subsection::Closed:: *)
(*Wrapper plumbing*)


installHelperWrapper[helperContext_String, name_String] := Module[{publicName, helperName},
	publicName = StringJoin["IronLibrary`", name];
	helperName = StringJoin[helperContext, name];
	ToExpression[StringJoin["Clear[", publicName, "]"]];
	ToExpression[StringJoin["Options[", publicName, "] = Options[", helperName, "]"]];
	ToExpression[
		StringJoin[
			publicName,
			"[args___] := Apply[",
			helperName,
			", IronLibrary`Private`normalizePublicCallArguments[\"",
			name,
			"\", {args}]]"
		]
	]
];

installHelperWrappers[helperContext_String, names_List] :=
	Scan[installHelperWrapper[helperContext, #] &, names];

optionValueFromArgs[option_, default_, args___] := Module[{rules},
	rules = Cases[{args}, (_Rule | _RuleDelayed), {1}];
	option /. Join[rules, {option -> default}]
];

displayRequested[default_, args___] :=
	TrueQ[optionValueFromArgs[Display, default, args]];

withoutDisplayOption[args___] :=
	DeleteCases[{args}, (Display -> _) | (Display :> _), {1}];

publicStringMatchKey[s_String] :=
	ToLowerCase[StringTrim[s]];

publicStringCandidateRules[candidates_List] :=
	DeleteDuplicatesBy[
		Rule[publicStringMatchKey[#], #] & /@
			Select[Cases[Flatten[candidates], _String], StringLength[StringTrim[#]] > 0 &],
		First
	];

publicNormalExpression[association_Association] :=
	KeyValueMap[
		publicNormalExpression[#1] -> publicNormalExpression[#2] &,
		association
	];

publicNormalExpression[list_List] :=
	publicNormalExpression /@ list;

publicNormalExpression[other_] :=
	other;

publicStateStringCandidates[] := Module[
	{state, characters, data, candidates = {}, collections, currentKeys},
	state = IronLibrary`MechanicsHelpers`getIronState[];
	If[!AssociationQ[state], Return[{}]];
	characters = stateCharacterNames[state];
	collections = {"vows", "foes", "delves"};
	currentKeys = {"currentDelve"};
	Do[
		data = state[character];
		candidates = Join[
			candidates,
			{character},
			Flatten[
				Keys[Lookup[data, #, <||>]] & /@ collections
			],
			Lookup[Lookup[data, "assets", {}], "Name", {}],
			Lookup[data, currentKeys, {}],
			Cases[
				publicNormalExpression[data],
				Rule["Name", value_String] :> value,
				Infinity
			],
			Cases[Lookup[data, "bonds", {}], value_String :> value, Infinity],
			{"Failures", "Bonds"}
		],
		{character, characters}
	];
	DeleteDuplicates @ Cases[Flatten[candidates], _String]
];

publicAssetStringCandidates[] := Module[
	{records, fieldAssocs, trackAssocs, fields, tracks, selectorValues},
	records = Values[AssetData`assetData];
	fieldAssocs = Lookup[records, "Fields", <||>];
	trackAssocs = Lookup[records, "Tracks", <||>];
	fields = Flatten[Values /@ fieldAssocs];
	tracks = Flatten[Values /@ trackAssocs];
	selectorValues = Cases[
		Normal[records],
		Rule["Value", value_String] :> value,
		Infinity
	];
	DeleteDuplicates @ Cases[
		Flatten @ {
			Keys[AssetData`assetData],
			Lookup[records, "Name", {}],
			Lookup[records, "Category", {}],
			Keys /@ fieldAssocs,
			Lookup[fields, "Label", {}],
			Keys /@ trackAssocs,
			Lookup[tracks, "Key", {}],
			selectorValues,
			Lookup[fields, "Key", {}],
			Lookup[tracks, "Label", {}]
		},
		_String
	]
];

publicOracleStringCandidates[] := Module[{},
	DeleteDuplicates @ Cases[
		Flatten @ {
			Keys[OracleTables`oracles],
			{
				"Yes/No",
				"Reveal a Danger",
				"Delve Site Feature",
				"Delve Site Name",
				"Settlement: Name",
				"Settlement: Quick Name",
				"Core: Prompt",
				"Character",
				"Settlement",
				"Combat Scene",
				"Journey Waypoint",
				"Monstrosity",
				"Trap",
				"Combat Event",
				"Threat",
				"Settled",
				"Settled Lands",
				"Boundary",
				"Boundary Lands",
				"Remote",
				"Remote Lands",
				"Overland",
				"Coastal Waters"
			},
			If[
				KeyExistsQ[OracleTables`oracles, "Threat: Category"],
				Values[OracleTables`oracles["Threat: Category"]],
				{}
			],
			If[
				ValueQ[OracleTables`Private`yesNoOddsValues],
				Keys[OracleTables`Private`yesNoOddsValues],
				{}
			],
			If[
				ValueQ[OracleTables`Private`featureBaseTables],
				Keys[OracleTables`Private`featureBaseTables],
				{}
			],
			If[
				ValueQ[OracleTables`Private`dangerBaseTables],
				Keys[OracleTables`Private`dangerBaseTables],
				{}
			]
		},
		_String
	]
];

publicLiteralStringCandidates[] := {
	"Unequipped",
	"Lightly armored",
	"Geared for war",
	"Health",
	"Spirit",
	"Supply",
	"Momentum",
	"Failures",
	"Bonds"
};

$publicStringCandidateSources = {
	publicStateStringCandidates,
	publicAssetStringCandidates,
	publicOracleStringCandidates,
	publicLiteralStringCandidates
};

publicStringCandidates[] :=
	DeleteDuplicates @ Cases[
		Flatten[Quiet[Check[#[], {}]] & /@ $publicStringCandidateSources],
		_String
	];

publicStringCandidateMap[] :=
	Association[publicStringCandidateRules[publicStringCandidates[]]];

$denizenSlotSymbolRules = {
	HoldPattern[IronLibrary`VeryCommon] -> 1,
	HoldPattern[IronLibrary`Common1] -> 2,
	HoldPattern[IronLibrary`Common2] -> 3,
	HoldPattern[IronLibrary`Common3] -> 4,
	HoldPattern[IronLibrary`Uncommon1] -> 5,
	HoldPattern[IronLibrary`Uncommon2] -> 6,
	HoldPattern[IronLibrary`Uncommon3] -> 7,
	HoldPattern[IronLibrary`Uncommon4] -> 8,
	HoldPattern[IronLibrary`Rare1] -> 9,
	HoldPattern[IronLibrary`Rare2] -> 10,
	HoldPattern[IronLibrary`Rare3] -> 11,
	HoldPattern[IronLibrary`Unforeseen] -> 12
};

$denizenSlotSymbolNames = {
	"VeryCommon",
	"Common1",
	"Common2",
	"Common3",
	"Uncommon1",
	"Uncommon2",
	"Uncommon3",
	"Uncommon4",
	"Rare1",
	"Rare2",
	"Rare3",
	"Unforeseen"
};

denizenSlotNumber[slot_Symbol] := Module[{number},
	number = Replace[Unevaluated[slot], $denizenSlotSymbolRules, {0}];
	If[IntegerQ[number], number, $Failed]
];

denizenSlotNumber[_] :=
	$Failed;

denizenSlotSymbolQ[slot_] :=
	IntegerQ[denizenSlotNumber[slot]];

denizenSlotChoicesText[] :=
	StringRiffle[$denizenSlotSymbolNames, ", "];

denizenSlotArgument[function_Symbol, slot_] := Module[{slotNumber},
	slotNumber = denizenSlotNumber[slot];
	If[IntegerQ[slotNumber],
		slotNumber,
		Message[function::badslot, HoldForm[slot], denizenSlotChoicesText[]];
		$Failed
	]
];

normalizePublicString[s_String] :=
	Lookup[publicStringCandidateMap[], publicStringMatchKey[s], s];

normalizePublicArgument[s_String] :=
	normalizePublicString[s];

normalizePublicArgument[rule : (_Rule | _RuleDelayed)] :=
	rule;

normalizePublicArgument[association_Association] :=
	Association @ KeyValueMap[
		#1 -> normalizePublicArgument[#2] &,
		association
	];

normalizePublicArgument[list_List] :=
	normalizePublicArgument /@ list;

normalizePublicArgument[IronLibrary`CompanionHealth[name_String]] :=
	IronLibrary`CompanionHealth[normalizePublicString[name]];

normalizePublicArgument[other_] :=
	other;

$publicStringNormalizationPreservePaths = <|
	"beginStory" -> {{1}},
	"createCharacter" -> {{1}, {9}},
	"vow" -> {{1}},
	"addVow" -> {{1}},
	"setThreat" -> {{2}},
	"beginJourney" -> {{1}},
	"addFoe" -> {{1}},
	"addBond" -> {{1}},
	"beginScene" -> {{1}},
	"addRarity" -> {{2}}
|>;

publicPreservedArgumentPaths["addDelve", args_List] :=
	Join[
		{{1}},
		If[Length[args] >= 5 && ListQ[args[[5]]], {{5}}, {}]
	];

publicPreservedArgumentPaths["beginDelve", args_List] :=
	If[
		Length[args] >= 4,
		publicPreservedArgumentPaths["addDelve", args],
		{}
	];

publicPreservedArgumentPaths["setDenizen", args_List] :=
	Which[
		Length[args] >= 2 && denizenSlotSymbolQ[First[args]], {{2}},
		Length[args] >= 3, {{3}},
		True, {}
	];

publicPreservedArgumentPaths[name_String, _List] :=
	Lookup[$publicStringNormalizationPreservePaths, name, {}];

validPartPathQ[expr_, path_List] :=
	Quiet[Check[Extract[expr, path]; True, False]];

restorePreservedArgumentPaths[original_List, normalized_List, paths_List] :=
	Fold[
		If[
			validPartPathQ[original, #2],
			ReplacePart[#1, #2 -> Extract[original, #2]],
			#1
		] &,
		normalized,
		paths
	];

normalizePublicCallArguments[name_String, args_List] :=
	restorePreservedArgumentPaths[
		args,
		normalizePublicArgument /@ args,
		publicPreservedArgumentPaths[name, args]
	];

characterStateQ[data_] :=
	AssociationQ[data] &&
	AllTrue[{"assets", "edge", "heart", "iron", "shadow", "wits", "vows"}, KeyExistsQ[data, #] &];

stateCharacterNames[state_Association] :=
	Select[Keys[state], StringQ[#] && characterStateQ[state[#]] &];

soloCharacterForDisplay[] := Module[
	{state, character, characters},
	state = IronLibrary`MechanicsHelpers`getIronState[];
	If[!AssociationQ[state], Return[$Failed]];
	character = IronLibrary`MechanicsHelpers`soloCharacter[];
	If[StringQ[character] && KeyExistsQ[state, character], Return[character]];
	characters = stateCharacterNames[state];
	If[Length[characters] =!= 1, Return[$Failed]];
	IronLibrary`MechanicsHelpers`setSoloCharacter[First[characters]];
	First[characters]
];

emptyOwnedCollectionQ[collection_] :=
	(AssociationQ[collection] || ListQ[collection]) && Length[collection] == 0;

selectedCollectionCharacter[normalizedArgs_List] :=
	Replace[
		SelectFirst[Reverse[normalizedArgs], StringQ, Automatic],
		Automatic :> soloCharacterForDisplay[]
	];

warnIfEmptyCollection[collection_, normalizedArgs_List, function_Symbol] :=
	If[emptyOwnedCollectionQ[collection],
		Message[MessageName[function, "empty"], selectedCollectionCharacter[normalizedArgs]];
		True,
		False
	];

displaySoloCharacterSheet[] := Module[{character},
	character = soloCharacterForDisplay[];
	If[StringQ[character], characterSheet[character], $Failed]
];

displayCharacterAssets[character_String] := Module[{normalizedCharacter, ownedAssets, empty},
	normalizedCharacter = normalizePublicString[character];
	ownedAssets = IronLibrary`MechanicsHelpers`getAssets[normalizedCharacter];
	empty = warnIfEmptyCollection[ownedAssets, {normalizedCharacter}, getAssets];
	If[ListQ[ownedAssets] && !TrueQ[empty], IronLibrary`DisplayHelpers`displayOwnedAssets[ownedAssets]];
	ownedAssets
];

displayCharacterCurrentDelve[character_String] := Module[{normalizedCharacter, ownedDelve},
	normalizedCharacter = normalizePublicString[character];
	ownedDelve = IronLibrary`MechanicsHelpers`currentDelveDataQuiet[normalizedCharacter];
	If[AssociationQ[ownedDelve],
		IronLibrary`DisplayHelpers`displayDelve[ownedDelve],
		None
	]
];

displayCharacterSummary[character_String] := Module[{sheet, assets},
	sheet = characterSheet[character];
	If[sheet === $Failed, Return[$Failed]];
	assets = displayCharacterAssets[character];
	displayCharacterCurrentDelve[character];
	assets
];

displaySoloCharacterSummary[] := Module[{character},
	character = soloCharacterForDisplay[];
	If[StringQ[character], displayCharacterSummary[character], $Failed]
];

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

(* ::Subsection::Closed:: *)
(*Direct helper APIs*)


$mechanicsPassThroughAPI = {
	"setSoloCharacter",
	"vow",
	"setThreat",
	"removeThreat",
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
	"markOathbreaker",
	"clearOathbreaker",
	"asset",
	"sufferCompanionHealth",
	"takeCompanionHealth",
	"sufferWarbandStrength",
	"takeWarbandStrength",
	"sufferWealth",
	"takeWealth",
	"sufferSimulacrumHealth",
	"resetSimulacrumHealth",
	"sufferEssence",
	"takeEssence",
	"sufferLight",
	"resetLight",
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
	"markExperience",
	"setDelveTheme",
	"setDelveDomain"
};

installHelperWrappers["IronLibrary`MechanicsHelpers`", $mechanicsPassThroughAPI];


(* ::Subsection::Closed:: *)
(*Move wrappers*)


displayMoveForPublic[moveKey_String] :=
	IronLibrary`DisplayHelpers`displayMove[moveKey];

actionRollAssociationQ[roll_Association] :=
	KeyExistsQ[roll, "actionDie"] &&
	KeyExistsQ[roll, "actionScore"] &&
	KeyExistsQ[roll, "challengeDice"];

progressRollAssociationQ[roll_Association] :=
	KeyExistsQ[roll, "progressScore"] &&
	KeyExistsQ[roll, "challengeDice"] &&
	!KeyExistsQ[roll, "actionDie"];

rollKindDescription[roll_Association] := Which[
	actionRollAssociationQ[roll], "an action roll",
	progressRollAssociationQ[roll], "a progress roll",
	True, "an association that is not a recognized roll"
];

rollKindDescription[_] :=
	"a non-roll argument";

moveRollRequirement["Action", roll_Association] :=
	actionRollAssociationQ[roll];

moveRollRequirement["Progress", roll_Association] :=
	progressRollAssociationQ[roll];

moveRollRequirement[_, _] :=
	False;

moveRollExpectation[moveKey_String] :=
	Lookup[$moveRollExpectations, moveKey, None];

displayMoveForPublic[name_String, moveKey_String, expectedRoll_, roll_] := Module[
	{actual},
	If[expectedRoll =!= None && !moveRollRequirement[expectedRoll, roll],
		actual = rollKindDescription[roll];
		If[expectedRoll === "Action",
			Message[IronLibrary`displayMoveForPublic::badactionroll, name, actual],
			Message[IronLibrary`displayMoveForPublic::badprogressroll, name, actual]
		];
		Return[$Failed]
	];
	IronLibrary`DisplayHelpers`displayMove[moveKey, roll]
];

displayMoveForPublic[moveKey_String, roll_Association] :=
	displayMoveForPublic[moveKey, moveKey, moveRollExpectation[moveKey], roll];

IronLibrary`displayMoveForPublic::badactionroll =
"`1`[roll] requires an action roll, not `2`.";

IronLibrary`displayMoveForPublic::badprogressroll =
"`1`[roll] requires a progress roll, not `2`.";

installMoveHeaderWrapper[name_String, moveKey_String] :=
	ToExpression[
		StringJoin[
			"IronLibrary`", name, "[] := IronLibrary`Private`displayMoveForPublic[\"", moveKey, "\"]"
		]
	];

installMoveRollWrapper[name_String, moveKey_String, expectedRoll_] := (
	installMoveHeaderWrapper[name, moveKey];
	ToExpression[
		StringJoin[
			"IronLibrary`", name, "[roll_] := IronLibrary`Private`displayMoveForPublic[\"",
			name,
			"\", \"",
			moveKey,
			"\", \"",
			expectedRoll,
			"\", roll]"
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

$actionRollMoveAPI = {
	"faceDanger",
	"secureAnAdvantage",
	"gatherInformation",
	"makeCamp",
	"heal",
	"resupply",
	"checkYourGear",
	"undertakeAJourney",
	"followAPath",
	"faceDangerScene",
	"secureAnAdvantageScene",
	"swearAnIronVow",
	"compel",
	"sojourn",
	"sojournFocus",
	"forgeABond",
	"testYourBond",
	"drawTheCircle",
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
	"escapeTheDepths"
};

$progressRollMoveAPI = {
	"reachYourDestination",
	"finishTheScene",
	"fulfillYourVow",
	"writeYourEpilogue",
	"locateYourObjective"
};

$moveRollAPI = Join[$actionRollMoveAPI, $progressRollMoveAPI];
$moveRollExpectations = Association[
	Join[
		Thread[$actionRollMoveAPI -> "Action"],
		Thread[$progressRollMoveAPI -> "Progress"]
	]
];

Scan[installMoveHeaderWrapper[#, #] &, $moveHeaderAPI];
Scan[installMoveRollWrapper[#, #, "Action"] &, $actionRollMoveAPI];
Scan[installMoveRollWrapper[#, #, "Progress"] &, $progressRollMoveAPI];

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

endTheFightWithRoll[roll_, initiative_] := Module[
	{transformed},
	If[!moveRollRequirement["Progress", roll],
		Message[IronLibrary`displayMoveForPublic::badprogressroll, "endTheFight", rollKindDescription[roll]];
		Return[$Failed]
	];
	transformed = endTheFightRoll[roll, initiative];
	displayMoveForPublic["endTheFight", "endTheFight", "Progress", transformed]
];

endTheFight[roll_Association, opts : OptionsPattern[]] :=
	endTheFightWithRoll[roll, OptionValue[Initiative]];

endTheFight[roll_, opts : OptionsPattern[]] :=
	endTheFightWithRoll[roll, OptionValue[Initiative]];

learnFromYourFailures[] :=
	displayMoveForPublic["learnFromYourFailures"];

learnFromYourFailuresWithRoll[roll_] := Module[
	{trackName, progressScore},
	If[!moveRollRequirement["Progress", roll],
		Message[IronLibrary`displayMoveForPublic::badprogressroll, "learnFromYourFailures", rollKindDescription[roll]];
		Return[$Failed]
	];
	trackName = Lookup[roll, "trackName", None];
	progressScore = Lookup[roll, "progressScore", Missing["NoProgressScore"]];
	If[trackName =!= "Failures",
		Message[IronLibrary`learnFromYourFailures::badroll, trackName];
		Return[$Failed]
	];
	If[!NumericQ[progressScore] || progressScore < 6,
		Message[IronLibrary`learnFromYourFailures::threshold, progressScore];
		Return[$Failed]
	];
	displayMoveForPublic["learnFromYourFailures", roll]
];

learnFromYourFailures[roll_Association] :=
	learnFromYourFailuresWithRoll[roll];

learnFromYourFailures[roll_] :=
	learnFromYourFailuresWithRoll[roll];

IronLibrary`learnFromYourFailures::badroll = "learnFromYourFailures[roll] requires a progress roll against Failures, not `1`.";
IronLibrary`learnFromYourFailures::threshold = "learnFromYourFailures[roll] requires the Failures progress score to be at least 6, not `1`.";


(* ::Subsection::Closed:: *)
(*State and file lifecycle*)


resetLifecycleState[] :=
	IronLibrary`MechanicsHelpers`resetIronSession[];

beginStory[] := (
	resetLifecycleState[];
	IronLibrary`FileHelpers`beginStory[]
);

beginStory[name_String] := (
	resetLifecycleState[];
	installStateFromFileResult[
		IronLibrary`FileHelpers`beginStory[name, stateForFileHelpers[]]
	]
);

beginStory[name_] := (
	resetLifecycleState[];
	IronLibrary`FileHelpers`beginStory[name]
);

Options[beginChapter] =
	Join[Options[IronLibrary`FileHelpers`beginChapter], {Display -> True}];

beginChapter[opts : OptionsPattern[]] := Module[{state},
	resetLifecycleState[];
	state = IronLibrary`FileHelpers`beginChapter @@ withoutDisplayOption[opts];
	If[AssociationQ[state],
		IronLibrary`MechanicsHelpers`setIronState[state];
		If[TrueQ[OptionValue[Display]], displaySoloCharacterSummary[]]
	];
	state
];

Options[endChapter] = {Display -> True};

endChapter[opts : OptionsPattern[]] := Module[{state, result},
	state = IronLibrary`MechanicsHelpers`getIronState[];
	If[!AssociationQ[state],
		Message[IronLibrary`endChapter::nostate];
		Return[$Failed]
	];
	result = IronLibrary`FileHelpers`endChapter[state];
	If[AssociationQ[result] && TrueQ[OptionValue[Display]], displaySoloCharacterSummary[]];
	result
];

IronLibrary`endChapter::nostate = "No IronLibrary state is loaded.";


(* ::Subsection::Closed:: *)
(*Character display*)


characterSheet[] := Module[{character},
	character = IronLibrary`MechanicsHelpers`soloCharacter[];
	If[character === $Failed, Return[$Failed]];
	characterSheet[character]
];

characterSheet[character_String] := Module[{normalizedCharacter, characterData},
	normalizedCharacter = normalizePublicString[character];
	characterData = IronLibrary`MechanicsHelpers`normalizeCharacterForSheet[normalizedCharacter];
	If[characterData === $Failed, Return[$Failed]];
	IronLibrary`DisplayHelpers`displayCharacterSheet[normalizedCharacter, characterData]
];

Options[createCharacter] = {Display -> True};

createCharacter[args___] := Module[
	{characterArgs, characterData, character},
	characterArgs = normalizePublicCallArguments["createCharacter", withoutDisplayOption[args]];
	characterData = IronLibrary`MechanicsHelpers`createCharacter @@ characterArgs;
	character = If[Length[characterArgs] > 0, First[characterArgs], None];
	If[
		AssociationQ[characterData] &&
			StringQ[character] &&
			displayRequested[True, args],
		displayCharacterSummary[character]
	];
	characterData
];


(* ::Subsection::Closed:: *)
(*Displayed mechanical objects*)


Options[addVow] = Join[Options[IronLibrary`MechanicsHelpers`addVow], {Display -> True}];

addVow[args___] := Module[{normalizedArgs, ownedVow},
	normalizedArgs = normalizePublicCallArguments["addVow", withoutDisplayOption[args]];
	ownedVow = IronLibrary`MechanicsHelpers`addVow @@ normalizedArgs;
	If[AssociationQ[ownedVow] && displayRequested[True, args], Print[IronLibrary`DisplayHelpers`displayVowCard[ownedVow, "Added"]]];
	ownedVow
];

Options[removeVow] = {Display -> True};

removeVow[args___] := Module[{normalizedArgs, ownedVow},
	normalizedArgs = normalizePublicCallArguments["removeVow", withoutDisplayOption[args]];
	ownedVow = IronLibrary`MechanicsHelpers`removeVow @@ normalizedArgs;
	If[AssociationQ[ownedVow] && displayRequested[True, args], Print[IronLibrary`DisplayHelpers`displayVowCard[ownedVow, "Removed"]]];
	ownedVow
];

getVow[args___] := Module[{normalizedArgs, ownedVow},
	normalizedArgs = normalizePublicCallArguments["getVow", {args}];
	ownedVow = IronLibrary`MechanicsHelpers`getVow @@ normalizedArgs;
	If[AssociationQ[ownedVow], Print[IronLibrary`DisplayHelpers`displayVowCard[ownedVow]]];
	ownedVow
];

getVows[args___] := Module[{normalizedArgs, ownedVows, empty},
	normalizedArgs = normalizePublicCallArguments["getVows", {args}];
	ownedVows = IronLibrary`MechanicsHelpers`getVows @@ normalizedArgs;
	empty = warnIfEmptyCollection[ownedVows, normalizedArgs, getVows];
	If[AssociationQ[ownedVows] && !TrueQ[empty], IronLibrary`DisplayHelpers`displayVowCards[ownedVows]];
	ownedVows
];

getAsset[name_String] := Module[
	{normalizedName, character, ownedAssets, ownedAsset},
	normalizedName = normalizePublicString[name];
	character = soloCharacterForDisplay[];
	If[StringQ[character],
		ownedAssets = IronLibrary`MechanicsHelpers`getAssets[character];
		If[ListQ[ownedAssets],
			ownedAsset = FirstCase[
				ownedAssets,
				asset_Association /; Lookup[asset, "Name", ""] === normalizedName :> asset,
				None
			];
			If[AssociationQ[ownedAsset],
				Return[IronLibrary`DisplayHelpers`displayAssetCard[ownedAsset, character]]
			]
		]
	];
	IronLibrary`DisplayHelpers`displayAssetReference[normalizedName]
];

getAsset[name_String, character_] := Module[{normalizedArgs, ownedAsset},
	normalizedArgs = normalizePublicCallArguments["getAsset", {name, character}];
	ownedAsset = IronLibrary`MechanicsHelpers`getAsset @@ normalizedArgs;
	If[AssociationQ[ownedAsset],
		IronLibrary`DisplayHelpers`displayAssetCard[ownedAsset, Last[normalizedArgs]],
		ownedAsset
	]
];

getAsset[args___] := Module[{normalizedArgs, ownedAsset},
	normalizedArgs = normalizePublicCallArguments["getAsset", {args}];
	ownedAsset = IronLibrary`MechanicsHelpers`getAsset @@ normalizedArgs;
	If[AssociationQ[ownedAsset],
		IronLibrary`DisplayHelpers`displayAssetCard[ownedAsset],
		ownedAsset
	]
];

getAssetAbility[name_String, ability_Integer] := Module[{normalizedName, ownedAsset},
	normalizedName = normalizePublicString[name];
	ownedAsset = IronLibrary`MechanicsHelpers`getAssetAbility[normalizedName, ability];
	If[AssociationQ[ownedAsset],
		IronLibrary`DisplayHelpers`displayAssetAbility[ownedAsset, ability],
		ownedAsset
	]
];

getAssetAbility[name_String, ability_Integer, character_] := Module[{normalizedArgs, ownedAsset},
	normalizedArgs = normalizePublicCallArguments["getAssetAbility", {name, ability, character}];
	ownedAsset = IronLibrary`MechanicsHelpers`getAssetAbility[First[normalizedArgs], ability, Last[normalizedArgs]];
	If[AssociationQ[ownedAsset],
		IronLibrary`DisplayHelpers`displayAssetAbility[ownedAsset, ability],
		ownedAsset
	]
];

getAssets[args___] := Module[{normalizedArgs, ownedAssets, empty},
	normalizedArgs = normalizePublicCallArguments["getAssets", {args}];
	ownedAssets = IronLibrary`MechanicsHelpers`getAssets @@ normalizedArgs;
	empty = warnIfEmptyCollection[ownedAssets, normalizedArgs, getAssets];
	If[ListQ[ownedAssets] && !TrueQ[empty], IronLibrary`DisplayHelpers`displayOwnedAssets[ownedAssets]];
	ownedAssets
];

drawAssets[args___] := Module[{normalizedArgs, names},
	normalizedArgs = normalizePublicCallArguments["drawAssets", {args}];
	names = IronLibrary`MechanicsHelpers`drawAssets @@ normalizedArgs;
	If[ListQ[names], IronLibrary`DisplayHelpers`displayAssetReferences[names]];
	names
];

Options[beginJourney] = {Display -> True};

beginJourney[args___] := Module[{normalizedArgs, ownedJourney},
	normalizedArgs = normalizePublicCallArguments["beginJourney", withoutDisplayOption[args]];
	ownedJourney = IronLibrary`MechanicsHelpers`beginJourney @@ normalizedArgs;
	If[AssociationQ[ownedJourney] && displayRequested[True, args], IronLibrary`DisplayHelpers`displayProgressObjectCard["Journey", ownedJourney, "Began"]];
	ownedJourney
];

getJourney[args___] := Module[{normalizedArgs, ownedJourney},
	normalizedArgs = normalizePublicCallArguments["getJourney", {args}];
	ownedJourney = IronLibrary`MechanicsHelpers`journey @@ normalizedArgs;
	If[AssociationQ[ownedJourney], IronLibrary`DisplayHelpers`displayProgressObjectCard["Journey", ownedJourney]];
	ownedJourney
];

Options[endJourney] = {Display -> True};

endJourney[args___] := Module[{normalizedArgs, endedJourney, result},
	normalizedArgs = normalizePublicCallArguments["endJourney", withoutDisplayOption[args]];
	endedJourney = IronLibrary`MechanicsHelpers`journey @@ normalizedArgs;
	If[endedJourney === $Failed, Return[$Failed]];
	result = IronLibrary`MechanicsHelpers`endJourney @@ normalizedArgs;
	If[result =!= $Failed && AssociationQ[endedJourney] && displayRequested[True, args],
		IronLibrary`DisplayHelpers`displayProgressObjectCard["Journey", endedJourney, "Ended"]
	];
	result
];

Options[addFoe] = {Display -> True};

addFoe[args___] := Module[{normalizedArgs, ownedFoe},
	normalizedArgs = normalizePublicCallArguments["addFoe", withoutDisplayOption[args]];
	ownedFoe = IronLibrary`MechanicsHelpers`addFoe @@ normalizedArgs;
	If[AssociationQ[ownedFoe] && displayRequested[True, args], IronLibrary`DisplayHelpers`displayProgressObjectCard["Foe", ownedFoe, "Added"]];
	ownedFoe
];

getFoe[args___] := Module[{normalizedArgs, ownedFoe},
	normalizedArgs = normalizePublicCallArguments["getFoe", {args}];
	ownedFoe = IronLibrary`MechanicsHelpers`foe @@ normalizedArgs;
	If[AssociationQ[ownedFoe], IronLibrary`DisplayHelpers`displayProgressObjectCard["Foe", ownedFoe]];
	ownedFoe
];

Options[removeFoe] = {Display -> True};

removeFoe[args___] := Module[{normalizedArgs, removedFoe, result},
	normalizedArgs = normalizePublicCallArguments["removeFoe", withoutDisplayOption[args]];
	removedFoe = IronLibrary`MechanicsHelpers`foe @@ normalizedArgs;
	If[removedFoe === $Failed, Return[$Failed]];
	result = IronLibrary`MechanicsHelpers`removeFoe @@ normalizedArgs;
	If[result =!= $Failed && AssociationQ[removedFoe] && displayRequested[True, args],
		IronLibrary`DisplayHelpers`displayProgressObjectCard["Foe", removedFoe, "Removed"]
	];
	result
];

getFoes[args___] := Module[{normalizedArgs, ownedFoes, empty},
	normalizedArgs = normalizePublicCallArguments["getFoes", {args}];
	ownedFoes = IronLibrary`MechanicsHelpers`foes @@ normalizedArgs;
	empty = warnIfEmptyCollection[ownedFoes, normalizedArgs, getFoes];
	If[AssociationQ[ownedFoes] && !TrueQ[empty], IronLibrary`DisplayHelpers`displayProgressObjectCards["Foe", ownedFoes]];
	ownedFoes
];

getFailures[args___] := Module[{normalizedArgs, track},
	normalizedArgs = normalizePublicCallArguments["getFailures", {args}];
	track = IronLibrary`MechanicsHelpers`failures @@ normalizedArgs;
	If[AssociationQ[track], IronLibrary`DisplayHelpers`displayProgressObjectCard["Failures", track]];
	track
];

bondTrackArguments[normalizedArgs_List] :=
	If[Length[normalizedArgs] >= 2, {normalizedArgs[[2]]}, {}];

Options[addBond] = {Display -> True};

addBond[args___] := Module[{normalizedArgs, ownedBonds, track},
	normalizedArgs = normalizePublicCallArguments["addBond", withoutDisplayOption[args]];
	ownedBonds = IronLibrary`MechanicsHelpers`addBond @@ normalizedArgs;
	If[ListQ[ownedBonds] && displayRequested[True, args],
		track = IronLibrary`MechanicsHelpers`bondProgress @@ bondTrackArguments[normalizedArgs];
		IronLibrary`DisplayHelpers`displayBondList[ownedBonds, track, "Added"]
	];
	ownedBonds
];

Options[removeBond] = {Display -> True};

removeBond[args___] := Module[{normalizedArgs, ownedBonds, track},
	normalizedArgs = normalizePublicCallArguments["removeBond", withoutDisplayOption[args]];
	ownedBonds = IronLibrary`MechanicsHelpers`removeBond @@ normalizedArgs;
	If[ListQ[ownedBonds] && displayRequested[True, args],
		track = IronLibrary`MechanicsHelpers`bondProgress @@ bondTrackArguments[normalizedArgs];
		IronLibrary`DisplayHelpers`displayBondList[ownedBonds, track, "Removed"]
	];
	ownedBonds
];

getBonds[args___] := Module[{normalizedArgs, ownedBonds, track},
	normalizedArgs = normalizePublicCallArguments["getBonds", {args}];
	ownedBonds = IronLibrary`MechanicsHelpers`bonds @@ normalizedArgs;
	warnIfEmptyCollection[ownedBonds, normalizedArgs, getBonds];
	If[ListQ[ownedBonds],
		track = IronLibrary`MechanicsHelpers`bondProgress @@ normalizedArgs;
		IronLibrary`DisplayHelpers`displayBondList[ownedBonds, track]
	];
	ownedBonds
];

Options[beginScene] = {Display -> True};

beginScene[args___] := Module[{normalizedArgs, sceneData},
	normalizedArgs = normalizePublicCallArguments["beginScene", withoutDisplayOption[args]];
	sceneData = IronLibrary`MechanicsHelpers`beginScene @@ normalizedArgs;
	If[AssociationQ[sceneData] && displayRequested[True, args], IronLibrary`DisplayHelpers`displayScene[sceneData, "Began"]];
	sceneData
];

getScene[args___] := Module[{normalizedArgs, sceneData},
	normalizedArgs = normalizePublicCallArguments["getScene", {args}];
	sceneData = IronLibrary`MechanicsHelpers`scene @@ normalizedArgs;
	If[AssociationQ[sceneData], IronLibrary`DisplayHelpers`displayScene[sceneData]];
	sceneData
];

Options[endScene] = {Display -> True};

endScene[args___] := Module[{normalizedArgs, sceneData},
	normalizedArgs = normalizePublicCallArguments["endScene", withoutDisplayOption[args]];
	sceneData = IronLibrary`MechanicsHelpers`endScene @@ normalizedArgs;
	If[AssociationQ[sceneData] && displayRequested[True, args], IronLibrary`DisplayHelpers`displayScene[sceneData, "Ended"]];
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

markSceneCountdown[n_Integer?NonNegative, character_] := Module[{normalizedArgs, result, sceneData},
	normalizedArgs = normalizePublicCallArguments["markSceneCountdown", {n, character}];
	result = IronLibrary`MechanicsHelpers`markSceneCountdown @@ normalizedArgs;
	If[result === $Failed, Return[$Failed]];
	sceneData = IronLibrary`MechanicsHelpers`scene[Last[normalizedArgs]];
	If[AssociationQ[sceneData], IronLibrary`DisplayHelpers`displayScene[sceneData]];
	result
];

markSceneCountdown[args___] :=
	Apply[
		IronLibrary`MechanicsHelpers`markSceneCountdown,
		normalizePublicCallArguments["markSceneCountdown", {args}]
	];

Options[addDelve] = Join[Options[IronLibrary`MechanicsHelpers`addDelve], {Display -> True}];

addDelve[args___] := Module[{normalizedArgs, ownedDelve},
	normalizedArgs = normalizePublicCallArguments["addDelve", withoutDisplayOption[args]];
	ownedDelve = IronLibrary`MechanicsHelpers`addDelve @@ normalizedArgs;
	If[AssociationQ[ownedDelve] && displayRequested[True, args], IronLibrary`DisplayHelpers`displayDelve[ownedDelve, "Added"]];
	ownedDelve
];

Options[beginDelve] = Join[Options[IronLibrary`MechanicsHelpers`beginDelve], {Display -> True}];

beginDelve[args___] := Module[{normalizedArgs, ownedDelve},
	normalizedArgs = normalizePublicCallArguments["beginDelve", withoutDisplayOption[args]];
	ownedDelve = IronLibrary`MechanicsHelpers`beginDelve @@ normalizedArgs;
	If[AssociationQ[ownedDelve] && displayRequested[True, args], IronLibrary`DisplayHelpers`displayDelve[ownedDelve, "Began"]];
	ownedDelve
];

getDelve[args___] := Module[{normalizedArgs, ownedDelve},
	normalizedArgs = normalizePublicCallArguments["getDelve", {args}];
	ownedDelve = IronLibrary`MechanicsHelpers`delve @@ normalizedArgs;
	If[AssociationQ[ownedDelve], IronLibrary`DisplayHelpers`displayDelve[ownedDelve]];
	ownedDelve
];

Options[endDelve] = {Display -> True};

endDelve[args___] := Module[{normalizedArgs, endedDelve},
	normalizedArgs = normalizePublicCallArguments["endDelve", withoutDisplayOption[args]];
	endedDelve = IronLibrary`MechanicsHelpers`endDelve @@ normalizedArgs;
	If[AssociationQ[endedDelve] && displayRequested[True, args], IronLibrary`DisplayHelpers`displayDelve[endedDelve, "Ended"]];
	endedDelve
];

getDelves[args___] := Module[{normalizedArgs, ownedDelves, empty},
	normalizedArgs = normalizePublicCallArguments["getDelves", {args}];
	ownedDelves = IronLibrary`MechanicsHelpers`delves @@ normalizedArgs;
	empty = warnIfEmptyCollection[ownedDelves, normalizedArgs, getDelves];
	If[AssociationQ[ownedDelves] && !TrueQ[empty], IronLibrary`DisplayHelpers`displayDelves[ownedDelves]];
	ownedDelves
];

IronLibrary`getVows::empty = "`1` does not have any vows.";
IronLibrary`getAssets::empty = "`1` does not have any assets.";
IronLibrary`getFoes::empty = "`1` does not have any foes.";
IronLibrary`getBonds::empty = "`1` does not have any bonds.";
IronLibrary`getDelves::empty = "`1` does not have any delves.";

returnToSite[args___] := Module[{normalizedArgs, roll},
	normalizedArgs = normalizePublicCallArguments["returnToSite", {args}];
	roll = IronLibrary`MechanicsHelpers`returnToSite @@ normalizedArgs;
	If[AssociationQ[roll], IronLibrary`DisplayHelpers`displayReturnToSiteRoll[roll]];
	roll
];

rollDenizen[args___] := Module[{normalizedArgs, roll},
	normalizedArgs = normalizePublicCallArguments["rollDenizen", {args}];
	roll = IronLibrary`MechanicsHelpers`rollDenizen @@ normalizedArgs;
	If[AssociationQ[roll], IronLibrary`DisplayHelpers`displayDenizenRoll[roll["delveName"], roll]];
	roll
];

Clear[IronLibrary`setDenizen, IronLibrary`clearDenizen];

Options[setDenizen] = {};
Options[clearDenizen] = {};

IronLibrary`setDenizen::badslot =
"Denizen slot must be one of `2`, not `1`.";

IronLibrary`clearDenizen::badslot =
"Denizen slot must be one of `2`, not `1`.";

setDenizen[slot_, name_] := Module[{slotNumber, normalizedArgs},
	slotNumber = denizenSlotArgument[setDenizen, slot];
	If[slotNumber === $Failed, Return[$Failed]];
	normalizedArgs = normalizePublicCallArguments["setDenizen", {slot, name}];
	IronLibrary`MechanicsHelpers`setDenizen[slotNumber, normalizedArgs[[2]]]
];

setDenizen[delveName_String, slot_, name_] := Module[{slotNumber, normalizedArgs},
	slotNumber = denizenSlotArgument[setDenizen, slot];
	If[slotNumber === $Failed, Return[$Failed]];
	normalizedArgs = normalizePublicCallArguments["setDenizen", {delveName, slot, name}];
	IronLibrary`MechanicsHelpers`setDenizen[normalizedArgs[[1]], slotNumber, normalizedArgs[[3]]]
];

setDenizen[delveName_String, slot_, name_, character_] := Module[{slotNumber, normalizedArgs},
	slotNumber = denizenSlotArgument[setDenizen, slot];
	If[slotNumber === $Failed, Return[$Failed]];
	normalizedArgs = normalizePublicCallArguments["setDenizen", {delveName, slot, name, character}];
	IronLibrary`MechanicsHelpers`setDenizen[normalizedArgs[[1]], slotNumber, normalizedArgs[[3]], normalizedArgs[[4]]]
];

clearDenizen[slot_] := Module[{slotNumber},
	slotNumber = denizenSlotArgument[clearDenizen, slot];
	If[slotNumber === $Failed, Return[$Failed]];
	IronLibrary`MechanicsHelpers`clearDenizen[slotNumber]
];

clearDenizen[delveName_String, slot_] := Module[{slotNumber, normalizedArgs},
	slotNumber = denizenSlotArgument[clearDenizen, slot];
	If[slotNumber === $Failed, Return[$Failed]];
	normalizedArgs = normalizePublicCallArguments["clearDenizen", {delveName, slot}];
	IronLibrary`MechanicsHelpers`clearDenizen[normalizedArgs[[1]], slotNumber]
];

clearDenizen[delveName_String, slot_, character_] := Module[{slotNumber, normalizedArgs},
	slotNumber = denizenSlotArgument[clearDenizen, slot];
	If[slotNumber === $Failed, Return[$Failed]];
	normalizedArgs = normalizePublicCallArguments["clearDenizen", {delveName, slot, character}];
	IronLibrary`MechanicsHelpers`clearDenizen[normalizedArgs[[1]], slotNumber, normalizedArgs[[3]]]
];


(* ::Subsection::Closed:: *)
(*Displayed mutations and rolls*)


Options[addAsset] = {Display -> True};

addAsset[args___] := Module[{normalizedArgs, ownedAsset},
	normalizedArgs = normalizePublicCallArguments["addAsset", withoutDisplayOption[args]];
	ownedAsset = IronLibrary`MechanicsHelpers`addAsset @@ normalizedArgs;
	If[AssociationQ[ownedAsset] && displayRequested[True, args], IronLibrary`DisplayHelpers`displayAssetCard[ownedAsset, "Added Asset"]];
	ownedAsset
];

Options[upgradeAsset] = {Display -> True};

upgradeAsset[args___] := Module[{normalizedArgs, ownedAsset},
	normalizedArgs = normalizePublicCallArguments["upgradeAsset", {args}];
	ownedAsset = IronLibrary`MechanicsHelpers`upgradeAsset @@ normalizedArgs;
	If[AssociationQ[ownedAsset] && displayRequested[True, args], IronLibrary`DisplayHelpers`displayAssetCard[ownedAsset, "Upgraded Asset"]];
	ownedAsset
];

Options[setIroncladArmor] = {Display -> True};

setIroncladArmor[choice_, args___] := Module[{normalizedArgs, ownedAsset},
	normalizedArgs = normalizePublicCallArguments["setIroncladArmor", {choice, args}];
	ownedAsset = IronLibrary`MechanicsHelpers`setIroncladArmor @@ normalizedArgs;
	If[AssociationQ[ownedAsset] && displayRequested[True, args], IronLibrary`DisplayHelpers`displayAssetCard[ownedAsset, "Ironclad Armor"]];
	ownedAsset
];

Options[removeAsset] = {Display -> True};

removeAsset[args___] := Module[{normalizedArgs, ownedAsset},
	normalizedArgs = normalizePublicCallArguments["removeAsset", {args}];
	ownedAsset = IronLibrary`MechanicsHelpers`removeAsset @@ normalizedArgs;
	If[AssociationQ[ownedAsset] && displayRequested[True, args], IronLibrary`DisplayHelpers`displayAssetCard[ownedAsset, "Removed Asset"]];
	ownedAsset
];

Options[addRarity] = {Display -> True};

addRarity[args___] := Module[{normalizedArgs, ownedAsset},
	normalizedArgs = normalizePublicCallArguments["addRarity", {args}];
	ownedAsset = IronLibrary`MechanicsHelpers`addRarity @@ normalizedArgs;
	If[AssociationQ[ownedAsset] && displayRequested[True, args], IronLibrary`DisplayHelpers`displayAssetCard[ownedAsset, "Added Rarity"]];
	ownedAsset
];

Options[removeRarity] = {Display -> True};

removeRarity[args___] := Module[{normalizedArgs, ownedAsset},
	normalizedArgs = normalizePublicCallArguments["removeRarity", {args}];
	ownedAsset = IronLibrary`MechanicsHelpers`removeRarity @@ normalizedArgs;
	If[AssociationQ[ownedAsset] && displayRequested[True, args], IronLibrary`DisplayHelpers`displayAssetCard[ownedAsset, "Removed Rarity"]];
	ownedAsset
];

Options[actionRoll] = {Adds -> {}, Display -> True};

actionRoll[args___] := Module[{normalizedArgs, roll},
	normalizedArgs = normalizePublicCallArguments["actionRoll", {args}];
	roll = IronLibrary`MechanicsHelpers`actionRoll @@ normalizedArgs;
	If[AssociationQ[roll] && displayRequested[True, args], IronLibrary`DisplayHelpers`displayActionRoll[roll]];
	roll
];

Options[burnMomentum] = {Display -> True};

burnMomentum[args___] := Module[{normalizedArgs, burn},
	normalizedArgs = normalizePublicCallArguments["burnMomentum", {args}];
	burn = IronLibrary`MechanicsHelpers`burnMomentum @@ normalizedArgs;
	If[AssociationQ[burn] && displayRequested[True, args], IronLibrary`DisplayHelpers`displayMomentumBurn[burn]];
	burn
];

Options[rarityDieSix] = {Display -> True};

rarityDieSix[args___] := Module[{normalizedArgs, roll},
	normalizedArgs = normalizePublicCallArguments["rarityDieSix", {args}];
	roll = IronLibrary`MechanicsHelpers`rarityDieSix @@ normalizedArgs;
	If[AssociationQ[roll] && displayRequested[True, args], IronLibrary`DisplayHelpers`displayRarityDieSix[roll]];
	roll
];

Options[progressRoll] = {Display -> True};

progressRoll[args___] := Module[{normalizedArgs, roll},
	normalizedArgs = normalizePublicCallArguments["progressRoll", {args}];
	roll = IronLibrary`MechanicsHelpers`progressRoll @@ normalizedArgs;
	If[AssociationQ[roll] && displayRequested[True, args], IronLibrary`DisplayHelpers`displayProgressRoll[roll]];
	roll
];

Options[reroll] = {Display -> True};

reroll[args___] := Module[{normalizedArgs, roll},
	normalizedArgs = normalizePublicCallArguments["reroll", {args}];
	roll = IronLibrary`MechanicsHelpers`reroll @@ normalizedArgs;
	If[AssociationQ[roll] && displayRequested[True, args], IronLibrary`DisplayHelpers`displayReroll[roll]];
	roll
];


(* ::Subsection::Closed:: *)
(*Oracle composition*)


askTheOracle[args___] := Module[{normalizedArgs, ownedDelve},
	normalizedArgs = normalizePublicCallArguments["askTheOracle", {args}];
	Which[
		normalizedArgs === {"Reveal a Danger"},
			ownedDelve = IronLibrary`MechanicsHelpers`currentDelveDataQuiet[];
			If[AssociationQ[ownedDelve],
				IronLibrary`DisplayHelpers`displayOracleQuery["Reveal a Danger", ownedDelve],
				IronLibrary`DisplayHelpers`displayOracleQuery["Reveal a Danger"]
			],
		normalizedArgs === {"Delve Site Feature"},
			ownedDelve = IronLibrary`MechanicsHelpers`currentDelveData[];
			If[ownedDelve === $Failed, Return[$Failed]];
			IronLibrary`DisplayHelpers`displayOracleQuery["Delve Site Feature", ownedDelve],
		normalizedArgs === {"Delve Site Name"},
			ownedDelve = IronLibrary`MechanicsHelpers`currentDelveData[];
			If[ownedDelve === $Failed, Return[$Failed]];
			IronLibrary`DisplayHelpers`displayOracleQuery["Delve Site Name", ownedDelve],
		True,
			Apply[IronLibrary`DisplayHelpers`displayOracleQuery, normalizedArgs]
	]
];


(* ::Subsection::Closed:: *)
(*Private context footer*)


Clear[
	installHelperWrapper,
	installHelperWrappers,
	installMoveHeaderWrapper,
	installMoveRollWrapper,
	$mechanicsPassThroughAPI,
	$moveHeaderAPI,
	$actionRollMoveAPI,
	$progressRollMoveAPI,
	$moveRollAPI,
	$ironLibraryHelperDirectory
];

End[];


(* ::Section::Closed:: *)
(*Package footer*)


EndPackage[];
