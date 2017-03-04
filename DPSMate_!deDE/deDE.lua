if (GetLocale() == "deDE") then
	DPSMate.L["name"] = "DPSMate"
	DPSMate.L["popup"] = "Möchtest du DPSMate zurücksetzen?"
	DPSMate.L["memory"] = "DPSMate hat eine große Datenmenge angesammelt. Dies kann zu Lag während des Speichervorgangs beim Abmelden führen. Möchtest du DPSMate vorher zurücksetzen?"
	DPSMate.L["accept"] = "Annehmen"
	DPSMate.L["decline"] = "Ablehnen"
	DPSMate.L["total"] = "Gesamt"
	DPSMate.L["current"] = "Aktuell"
	DPSMate.L["cancel"] = "Abbrechen"
	DPSMate.L["report"] = "Bericht"
	DPSMate.L["reportfor"] = "Bericht an "
	 
	-- Abilities
	DPSMate.L["vanish"] = "Verschwinden"
	DPSMate.L["feigndeath"] = "Totstellen"
	DPSMate.L["divineintervention"] = "Göttlicher Eingriff"
	DPSMate.L["stealth"] = "Verstohlenheit"
	 
	-- Evaluation frame
	DPSMate.L["procs"] = "Treffereffekte"
	DPSMate.L["procstooltip"] = "Wähle einen Treffereffekt zur Darstellung im Graphen aus."
	DPSMate.L["absorbsby"] = "Absorbierungen von "
	DPSMate.L["absorbstakenby"] = "Absorbierungen erhalten von "
	DPSMate.L["aurasof"] = "Auras von "
	DPSMate.L["BUDEBU"] = {"Stärkungszauber", "Schwächungszauber"}
	DPSMate.L["castsof"] = "Zauber von "
	DPSMate.L["bname"] = "Name"
	DPSMate.L["count"] = "Anzahl"
	DPSMate.L["uptime"] = "Aktive Zeit"
	DPSMate.L["chance"] = "Chance"
	DPSMate.L["ccbreakerof"] = "CCBreaker von "
	DPSMate.L["time"] = "Zeit"
	DPSMate.L["cbt"] = "CBT"
	DPSMate.L["ability"] = "Fähigkeit"
	DPSMate.L["target"] = "Ziel"
	DPSMate.L["diseasecuredby"] = "Krankheit geheilt durch "
	DPSMate.L["diseasecuredof"] = "Krankheit geheilt von "
	DPSMate.L["poisoncuredby"] = "Gift geheilt durch "
	DPSMate.L["poisoncuredof"] = "Gift geheilt von "
	DPSMate.L["dmgdoneby"] = "Schaden zugefügt von "
	DPSMate.L["dmgtakenby"] = "Schaden erhalten von "
	DPSMate.L["dmgtakensum"] = "Gesamtschaden zugefügt"
	DPSMate.L["dmgdonesum"] = "Gesamtschaden erhalten"
	DPSMate.L["deathsof"] = "Tode von "
	DPSMate.L["cause"] = "Grund"
	DPSMate.L["type"] = "Typ"
	DPSMate.L["healin"] = "Heilung erhalten"
	DPSMate.L["damagein"] = "Schaden erhalten"
	DPSMate.L["decursesby"] = "Entfluchungen von "
	DPSMate.L["decursesreceivedby"] = "Entfluchungen erhalten von "
	DPSMate.L["dispelsby"] = "Bannzauber von "
	DPSMate.L["dispelsreceivedby"] = "Bannzauber erhalten von "
	DPSMate.L["block"] = "Block"
	DPSMate.L["crush"] = "Schmettern"
	DPSMate.L["hit"] = "Hit"
	DPSMate.L["average"] = "Durchschnitt"
	DPSMate.L["min"] = "Min"
	DPSMate.L["max"] = "Max"
	DPSMate.L["crit"] = "Krit"
	DPSMate.L["miss"] = "Verfehlen"
	DPSMate.L["parry"] = "Parieren"
	DPSMate.L["dodge"] = "Ausweichen"
	DPSMate.L["resist"] = "Widerstehen"
	DPSMate.L["glance"] = "Streifen"
	DPSMate.L["effhealdoneby"] = "Effektive Heilung ausgeführt von "
	DPSMate.L["effhealtakenby"] = "Effektive Heilung erhalten von "
	DPSMate.L["failsof"] = "Fehler von "
	DPSMate.L["victim"] = "Opfer"
	DPSMate.L["ffby"] = "Friendly fire durch "
	DPSMate.L["healdoneby"] = "Heilung ausgeführt von "
	DPSMate.L["habby"] = "Heilung und Absorbierunben von "
	DPSMate.L["healtakenby"] = "Heilung erhalten von "
	DPSMate.L["interruptsby"] = "Unterbrechungen von "
	DPSMate.L["magicliftby"] = "Magie gebannt durch "
	DPSMate.L["magicliftof"] = "Magie gebannt von "
	DPSMate.L["overhealby"] = "Überheilung ausgeführt von "
	DPSMate.L["procsof"] = "Treffereffekt von "
	 
	-- Menu
	DPSMate.L["mdps"] = "Zeige Schaden pro Sekunde."
	DPSMate.L["mdmg"] = "Zeige zugefügten Schaden."
	DPSMate.L["mdmgtaken"] = "Zeige erhaltenen Schaden."
	DPSMate.L["medd"] = "Zeige den zugefügten Schaden von Gegnern."
	DPSMate.L["medt"] = "Zeige den Schaden, den Gegner erhalten haben."
	DPSMate.L["mhealing"] = "Zeige effektive Heilung."
	DPSMate.L["mhab"] = "Zeige effektive Heilung mit Absorbierungen."
	DPSMate.L["mhealingtaken"] = "Zeige erhaltene Heilung."
	DPSMate.L["moverhealing"] = "Zeige ausgeführte Überheilung."
	DPSMate.L["minterrupts"] = "Zeige ausgeführte Unterbrechungen."
	DPSMate.L["mdeaths"] = "Zeige Tode."
	DPSMate.L["mdispels"] = "Zeige ausgeführte Bannzauber."
	DPSMate.L["totalmode"] = "Wähle Gesamtmodus."
	DPSMate.L["currentmode"] = "Wähle aktuellen Modus."
	DPSMate.L["reportsegment"] = "Berichte diesen Abschnitt."
	DPSMate.L["resetdesc"] = "Setze DPSMate zurück."
	DPSMate.L["newsegment"] = "Neuer Abschnitt"
	DPSMate.L["newsegmentdesc"] = "Beginne einen neuen Abschnitt."
	DPSMate.L["removesegment"] = "Entferne Abschnitt"
	DPSMate.L["removesegmentdesc"] = "Entfernt einen Abschnitt."
	DPSMate.L["lockdesc"] = "Sperre das DPSMate-Fenster."
	DPSMate.L["hidewindowdesc"] = "Verstecke das DPSMate-Fenster."
	DPSMate.L["showwindowdesc"] = "Zeige das DPSMate-Fenster."
	DPSMate.L["configframe"] = "Öffne die Konfiguration."
	DPSMate.L["testmodedesc"] = "Aktiviere den Testmodus."
	DPSMate.L["filterdesc"] = "Filteroptionen."
	DPSMate.L["switchdesc"] = "Wechsle Modus"
	DPSMate.L["mcurrent"] = "Aktueller Kampf"
	DPSMate.L["mrealtime"] = "Erstelle Echtzeitgraphen"
	DPSMate.L["mrealtimedesc"] = 'Erstelle einen Echtzeitgraphen. Dies benötigt viel Rechenleistung.'
	DPSMate.L["damagedone"] = "Schaden zugefügt"
	DPSMate.L["realtimedmgdone"] = 'Wähle zugefügten Schaden für dieses Fenster.'
	DPSMate.L["realtimedmgtaken"] = 'Wähle erhaltenen Schaden für dieses Fenster.'
	DPSMate.L["realtimehealing"] = 'Wähle vollständige Heilung für dieses Fenster.'
	DPSMate.L["realtimeehealing"] = 'Wähle effektive Heilung für dieses Fenster.'
	DPSMate.L["showAll"] = "Alles anzeigen"
	DPSMate.L["showAllDesc"] = 'Klicke hier, um alle Fenster anzuzeigen'
	DPSMate.L["hideAll"] = "Alles verstecken"
	DPSMate.L["hideAllDesc"] = 'Klicke hier, um alle Fenster zu verstecken'
	DPSMate.L["showwindow"] = "Zeige Fenster"
	DPSMate.L["hidewindow"] = "Verstecke Fenster"
	DPSMate.L["unlock"] = "Entsperre Fenster"
	DPSMate.L["config"] = "Konfiguration"
	DPSMate.L["reportdesc"] = "Berichte Details"
	DPSMate.L["whisper"] = "Flüstern"
	DPSMate.L["whisperdesc"] = "Flüstere jemandem"
	DPSMate.L["classes"] = "Klassen"
	DPSMate.L["classesdesc"] = "Wähle Klassen"
	DPSMate.L["warrior"] = "Krieger"
	DPSMate.L["rogue"] = "Schurke"
	DPSMate.L["warlock"] = "Hexenmeister"
	DPSMate.L["mage"] = "Magier"
	DPSMate.L["paladin"] = "Paladin"
	DPSMate.L["shaman"] = "Schamane"
	DPSMate.L["priest"] = "Priester"
	DPSMate.L["druid"] = "Druide"
	DPSMate.L["hunter"] = "Jäger"
	DPSMate.L["warriordesc"] = "Zeige Krieger"
	DPSMate.L["roguedesc"] = "Zeige Schurken"
	DPSMate.L["warlockdesc"] = "Zeige Hexenmeister"
	DPSMate.L["magedesc"] = "Zeige Magier"
	DPSMate.L["paladindesc"] = "Zeige Paladine"
	DPSMate.L["shamandesc"] = "Zeige Schamanen"
	DPSMate.L["priestdesc"] = "Zeige Priester"
	DPSMate.L["druiddesc"] = "Zeige Druiden"
	DPSMate.L["hunterdesc"] = "Zeige Jäger"
	DPSMate.L["certainnames"] = "Bestimmte Namen"
	DPSMate.L["certainnamesdesc"] = 'Trenne durch "," Bsp: Shino,'
	DPSMate.L["grouponly"] = "Nur Gruppe"
	DPSMate.L["grouponlydesc"] = "Zeige nur Gruppenmitglieder"
	 
	-- Config menu
	DPSMate.L["slider"] = "Zeilen"
	DPSMate.L["slidertooltip"] = "Stelle hier die Anzahl der zu berichtenden Zeilen ein."
	DPSMate.L["editboxtitle"] = "Flüstere Ziel"
	DPSMate.L["editboxtooltip"] = "Gib den Namen des Spielers, an den du berichten möchtest ein."
	DPSMate.L["channel"] = "Kanal"
	DPSMate.L["channeltooltip"] = "Wähle den Kanal in dem du berichten möchtest."
	DPSMate.L["close"] = "Schließen"
	DPSMate.L["minimapleft"] = "Linksklick-Ziehen um das Symbol zu verschieben."
	DPSMate.L["minimapright"] = "Rechtsklick um das Menü zu öffnen."
	DPSMate.L["window"] = "Anzeigefenster"
	DPSMate.L["bars"] = "Leisten"
	DPSMate.L["titlebar"] = "Titelleiste"
	DPSMate.L["content"] = "Inhalt"
	DPSMate.L["modeswitching"] = "Modus wechseln"
	DPSMate.L["dataresets"] = "Daten zurücksetzen"
	DPSMate.L["generaloptions"] = "Allgemeine Optionen"
	DPSMate.L["columns"] = "Modi-Konfiguration"
	DPSMate.L["tooltips"] = "Tooltips"
	DPSMate.L["broadcasting"] = "Übertragungsoptionen"
	DPSMate.L["about"] = "Über"
	DPSMate.L["createwindow"] = "Erstelle Fenster"
	DPSMate.L["createwindowtooltip"] = "Name des Fensters."
	DPSMate.L["submit"] = "Bestätige"
	DPSMate.L["submitTooltip"] = "Klicke hier um das Fenster zu erstellen."
	DPSMate.L["availwindows"] = "Verfügbare Fenster"
	DPSMate.L["availwindowsTooltip"] = "Wähle ein Fenster."
	DPSMate.L["lock"] = "Sperre Fenster"
	DPSMate.L["testmode"] = "Testmodus"
	DPSMate.L["barfont"] = "Schriftart"
	DPSMate.L["barfontTooltip"] = "Wähle eine Leistenschriftart."
	DPSMate.L["barfontsize"] = "Schriftgröße"
	DPSMate.L["barfontsizeTooltip"] = "Stelle hier die Leistenschriftartsgröße ein."
	DPSMate.L["barfontflags"] = "Schriftumrandung"
	DPSMate.L["barfontflagsTooltip"] = "Wähle eine Schriftartsumrandung."
	DPSMate.L["bartexture"] = "Leistentextur"
	DPSMate.L["bartextureTooltip"] = "Wähle eine Leistentextur."
	DPSMate.L["barspacing"] = "Leistenabstand"
	DPSMate.L["barspacingTooltip"] = "Stelle hier den Abstand zwischen den Leisten ein."
	DPSMate.L["barheight"] = "Leistenhöhe"
	DPSMate.L["barheightTooltip"] = "Stelle hier die Höhe der Leisten ein."
	DPSMate.L["classicons"] = "Klassensymbole"
	DPSMate.L["ranks"] = "Ränge"
	DPSMate.L["mode"] = "Modus"
	DPSMate.L["modes"] = "Modi"
	DPSMate.L["reset"] = "Zurücksetzen"
	DPSMate.L["sync"] = "Synchronisieren"
	DPSMate.L["bgcolor"] = "Hintergrundfarbe"
	DPSMate.L["fontcolor"] = "Schriftfarbe"
	DPSMate.L["fontcolorTooltip"] = "Klicke hier um eine Schriftfarbe auszuwählen."
	DPSMate.L["bgcolorTooltip"] = "Klicke hier um eine Hintergrundfarbe auszuwählen."
	DPSMate.L["scale"] = "Maßstab"
	DPSMate.L["scaleTooltip"] = "Stelle hier den Maßstab des Fensters ein."
	DPSMate.L["opacity"] = "Deckkraft"
	DPSMate.L["opacityTooltip"] = "Stelle hier die Deckkraft des Fensters ein."
	DPSMate.L["bgtex"] = "Hintergrundtextur"
	DPSMate.L["bgtexTooltip"] = "Ändere die Hintergrundtextur des Fensters."
	DPSMate.L["enterworldinstance"] = "Welt/Instanz"
	DPSMate.L["enterworldinstanceTooltip"] = "Setze beim Betreten oder Verlassen einer Instanz zurück."
	DPSMate.L["joinparty"] = "Beitritt einer Gruppe"
	DPSMate.L["joinpartyTooltip"] = "Setze beim Beitritt einer Gruppe zurück."
	DPSMate.L["leavingparty"] = "Verlassen einer Gruppe"
	DPSMate.L["leavingpartyTooltip"] = "Setze beim Verlassen einer Gruppe zurück."
	DPSMate.L["partymemberchanged"] = "Gruppe verändert"
	DPSMate.L["partymemberchangedTooltip"] = "Setze zurück sobald sich die Anzahl der Gruppenmitglieder verändert."
	DPSMate.L["minimap"] = "Zeige Minimapsymbol"
	DPSMate.L["showtotal"] = "Zeige Gesamtheit"
	DPSMate.L["solo"] = "Verstecke, wenn allein"
	DPSMate.L["combat"] = "Verstecke im Kampf"
	DPSMate.L["bossfights"] = "Behalte nur Bosskampfwerte"
	DPSMate.L["pvp"] = "Verstecke während PvP"
	DPSMate.L["disable"] = "Deaktiviere während versteckt"
	DPSMate.L["mergepets"] = "Begleiter mit Spieler"
	DPSMate.L["numberformat"] = "Zahlenformat"
	DPSMate.L["numberformatTooltip"] = "Bestimmt, wie Zahlen dargestellt werden."
	DPSMate.L["segments"] = "Datenabschnitte"
	DPSMate.L["segmentsTooltip"] = "Stelle hier die Anzahl der Kampfabschnitte ein, die gespeichert werden sollen. Dies erhöht die Datenmenge erheblich und kann zu Verzögerungen führen!"
	DPSMate.L["enable"] = "Aktiviere"
	DPSMate.L["damage"] = "Schaden"
	DPSMate.L["percent"] = "Prozent"
	DPSMate.L["dps"] = "DPS"
	DPSMate.L["edps"] = "EDPS"
	DPSMate.L["dtps"] = "DTPS"
	DPSMate.L["edtps"] = "EDTPS"
	DPSMate.L["healing"] = "Heilung"
	DPSMate.L["hps"] = "HPS"
	DPSMate.L["ehps"] = "EHPS"
	DPSMate.L["etps"] = "ETPS"
	DPSMate.L["damagetaken"] = "Schaden erhalten"
	DPSMate.L["enemydamagedone"] = "Zugefügter Schaden von Gegnern"
	DPSMate.L["enemydamagetaken"] = "Erhaltener Schaden von Gegnern"
	DPSMate.L["healing"] = "Heilung"
	DPSMate.L["absorbs"] = "Absorbierungen"
	DPSMate.L["absorbstaken"] = "Absorbierungen erhalten"
	DPSMate.L["amount"] = "Menge"
	DPSMate.L["dispelsreceived"] = "Bannzauber erhalten"
	DPSMate.L["decurses"] = "Entfluchungen"
	DPSMate.L["decursesreceived"] = "Entfluchungen erhalten"
	DPSMate.L["curedisease"] = "Krankheiten geheilt"
	DPSMate.L["curepoison"] = "Gifte geheilt"
	DPSMate.L["liftmagic"] = "Magie gebannt"
	DPSMate.L["aurasgained"] = "Auras erhalten"
	DPSMate.L["auraslost"] = "Auras verloren"
	DPSMate.L["aurauptime"] = "Auras aufrecht erhalten"
	DPSMate.L["friendlyfire"] = "Friendly fire"
	DPSMate.L["procs"] = "Treffereffekte"
	DPSMate.L["liftmagicreceived"] = "Magie bannen erhalten"
	DPSMate.L["curepoisonreceived"] = "Gift heilen erhalten"
	DPSMate.L["curediseasereceived"] = "Krankheit heilen erhalten"
	DPSMate.L["effectivehealing"] = "Effektive Heilung"
	DPSMate.L["effectivehps"] = "Effektive HPS"
	DPSMate.L["effectivehealingtaken"] = "Effektive Heilung erhalten"
	DPSMate.L["healingandabsorbs"] = "Heilung und Absorbierungen"
	DPSMate.L["healingtaken"] = "Heilung erhalten"
	DPSMate.L["overhealing"] = "Überheilung"
	DPSMate.L["interrupts"] = "Unterbrechungen"
	DPSMate.L["deaths"] = "Tode"
	DPSMate.L["dispels"] = "Bannzauber"
	DPSMate.L["threat"] = "Bedrohung"
	DPSMate.L["tps"] = "TPS"
	DPSMate.L["fails"] = "Fehler"
	DPSMate.L["cat"] = "Kategorie"
	DPSMate.L["ccbreaker"] = "CCBreaker"
	DPSMate.L["subviewrows"] = "Subview Zeilen"
	DPSMate.L["subviewrowsTooltip"] = "Stelle hier die Anzahl von Zeilen an, die im Tooltip angezeigt werden."
	DPSMate.L["TooltipPositionDropDown"] = "Tooltip Position"
	DPSMate.L["TooltipPositionDropDownTooltip"] = "Stelle hier die relative Position des Tooltips zum Fenster ein."
	DPSMate.L["whatisdpsmate"] = "Was ist DPSMate?"
	DPSMate.L["whatisdpsmateText"] = "DPSMate ist ein Analysewerkzeug für Kampfdaten. Es stellt viele Funktionen zur Verfügung um Kämpfe so genau wie möglich zu überprüfen. Dadurch sind spielerische Verbesserungen leicht zu erkennen."
	DPSMate.L["whocreateddpsmate"] = "Wer erstellt DPSMate?"
	DPSMate.L["whocreateddpsmateText"] = "DPSMate wurde von Shino (Albea) <Synced> programmiert, der dieses AddOn auf Kronos (Twinstar.cz) entwickelt. Er ist auch als Geigerkind in der Twinstar-Community bekannt."
	DPSMate.L["thanksto"] = "Dank geht an folgende Unterstützer:"
	--DPSMate.L["thankstoText"] = "Weasel - Für Testen des Addons und Verbesserungsvorschläge. \nBambustreppe - Für die deutsche Übersetzung."
	DPSMate.L["remove"] = "Entferne"
	DPSMate.L["removeTooltip"] = "Klicke hier, um das ausgewählte Fenster zu entfernen."
	DPSMate.L["copy"] = "Kopiere"
	DPSMate.L["copyTooltip"] = "Klicke hier, um die Konfiguration auf das ausgewählte Fenster zu kopieren."
	DPSMate.L["configto"] = "Kopiere Konfiguration zu:"
	DPSMate.L["configtoTooltip"] = "Wähle das zu konfigurierende Fenster aus."
	DPSMate.L["configfrom"] = "Kopiere Konfiguration von:"
	DPSMate.L["configfromTooltip"] = "Wähle das Fenster, von dem die Konfiguration aus kopiert werden soll."
	DPSMate.L["reset"] = "Zurücksetzen"
	DPSMate.L["syncrequest"] = "Sync-Anfragen"
	DPSMate.L["syncrequesttooltip"] = "Was geschieht, wenn eine Anfrage auf Datenrücksetzung erscheint."
	DPSMate.L["dataresetslogout"] = "Beim Ausloggen"
	DPSMate.L["dataresetslogouttooltip"] = "Beim Ausloggen zurücksetzen"
	DPSMate.L["enabledisable"] = "Ak-/Deaktiviere"
	DPSMate.L["bgbarcolor"] = "Hintergrundfarbe"
	DPSMate.L["bgbarcolorTooltip"] = "Wähle eine Leistenhintergrundfarbe aus."
	DPSMate.L["displayoptions"] = "Anzeigeoptionen"
	DPSMate.L["filter"] = "Filteroptionen"
	DPSMate.L["raidleader"] = "Schlachtzugsleiteroptionen"
	DPSMate.L["bgOpacityTooltip"] = "Stelle die Deckkraft des Hintergrunds ein."
	DPSMate.L["bgOpacity"] = "Hintergrunddeckkraft"
	DPSMate.L["casts"] = "Zauber"
	DPSMate.L["locktooltip"] = "Setze Haken hier, um das Fenster zu sperren."
	DPSMate.L["testmodetooltip"] = "Setze Haken hier, um den Testmodus zu aktivieren."
	DPSMate.L["classiconstooltip"] = "Setze Haken hier, um zusätzlich Klassensymbole auf den Statusleisten anzuzeigen."
	DPSMate.L["rankstooltip"] = "Setze Haken hier, um den Rang anzuzeigen."
	DPSMate.L["enabletitlebartooltip"] = "Setze Haken hier, um die Titelleiste zu aktivieren."
	DPSMate.L["buttonshowtooltip"] = "Setze Haken hier, um dieses Symbol in der Titelleiste anzuzeigen."
	DPSMate.L["minimaptooltip"] = "Setze Haken hier, um das Minimapsymbol anzuzeigen."
	DPSMate.L["showtotaltooltip"] = "Setze Haken hier, um eine zusätzliche Leiste für Gesamtwerte anzuzeigen."
	DPSMate.L["solotooltip"] = "Setze Haken hier, um das Fenster zu verstecken, wenn man nicht in einer Gruppe oder einem Schlachtzug ist."
	DPSMate.L["combattooltip"] = "Setze Haken hier, um das Fenster zu verstecken, wenn man einen Kampf beginnt."
	DPSMate.L["bossfightstooltip"] = "Setze Haken hier, um nur die Daten von Bosskämpfen zu speichern."
	DPSMate.L["pvptooltip"] = "Setze Haken hier, um das Fenster zu verstecken, wenn ein Schlachtfeld betreten wird."
	DPSMate.L["disabletooltip"] = "Setze Haken hier, um Datensammlung zu deaktivieren, während Fenster versteckt sind."
	DPSMate.L["mergepetstooltip"] = "Setze Haken hier, um Begleiterdaten mit ihrem jeweiligen Spieler zusammenzufassen."
	DPSMate.L["showtooltips"] = "Zeige Tooltips"
	DPSMate.L["showtooltipsTooltip"] = "Setze Haken hier, um Tooltips anzuzeigen, wenn die Maus über einem Feld ist."
	DPSMate.L["informativetooltips"] = "Ausführliche Tooltips"
	DPSMate.L["informativetooltipsTooltip"] = "Setze Haken hier, um ausführlichere Tooltips anzuzeigen."
	DPSMate.L["shownmodes"] = "Angezeigte Modi"
	DPSMate.L["hiddenmodes"] = "Versteckte Modi"
	DPSMate.L["moveleftTooltip"] = "Klicke hier, um diesen Modus anzuzeigen."
	DPSMate.L["moverightTooltip"] = "Klicke hier, um diesen Modus zu verstecken."
	DPSMate.L["helloworld"] = "Hallo Welt!"
	DPSMate.L["helloworldTooltip"] = "Gibt eine Liste aller Spieler wieder, die sich im Synced-Kanal befinden."
	DPSMate.L["enablebroadcasting"] = "Setze Haken hier, um die untenstehenden Übertragungsoptionen zu aktivieren."
	DPSMate.L["useraidwarning"] = "Nutze Schlachtzugswarnung"
	DPSMate.L["useraidwarningTooltip"] = "Setze Haken hier, um die Schlachtzugswarnung-Kanal anstelle des Schlachtzug-Kanals zu nutzen."
	DPSMate.L["relevantcds"] = "Relevante Abklingzeiten"
	DPSMate.L["relevantcdsTooltip"] = "Setze Haken hier, um relevante Abklingzeiten wie zum Beispiel Schildwall zu übertragen."
	DPSMate.L["ress"] = "Wiederbelebungen"
	DPSMate.L["ressTooltip"] = "Setze Haken hier, um zu übertragen, ob jemand eine Wiederbelebung erhalten hat."
	DPSMate.L["killingblows"] = "Todesstoß"
	DPSMate.L["killingblowsTooltip"] = "Setze Haken hier, um Informationen über den Todesstoß eines Spielers zu übertragen."
	DPSMate.L["failsTooltip"] = "Setze Haken hier, um zu übertragen, wenn ein Spieler Fehler begeht (Friendly Fire, Schaden erhalten, Schwächungszauber erhalten)."
	DPSMate.L["framesavailable"] = "Folgende Fenster sind verfügbar. Falls keine angezeigt werden gib /config ein."
	DPSMate.L["slashabout"] = "|c3ffddd80About:|r Ein Analysewerkzeug."
	DPSMate.L["slashusage"] = "|c3ffddd80Usage:|r /dps {lock|unlock|show|hide|config}"
	DPSMate.L["slashlock"] = "|c3ffddd80- lock:|r Sperre die Fenster."
	DPSMate.L["slashunlock"] = "|c3ffddd80- unlock:|r Entsperre die Fenster."
	DPSMate.L["slashshowAll"] = "|c3ffddd80- showAll:|r Zeige alle Fenster."
	DPSMate.L["slashhideAll"] = "|c3ffddd80- hideAll:|r Verstecke alle Fenster."
	DPSMate.L["slashshow"] = "|c3ffddd80- show {name}:|r Zeige dieses Fenster: {name}."
	DPSMate.L["slashhide"] = "|c3ffddd80- hide {name}:|r Verstecke dieses Fenster: {name}."
	DPSMate.L["slashconfig"] = "|c3ffddd80- config:|r Öffne das Konfigurationsmenu."
	DPSMate.L["bccdo"] = function(who, what) return who.." bekommt "..what end
	DPSMate.L["bccdt"] = function(who, what) return who.."s "..what.." schwindet" end
	DPSMate.L["bcress"] = function(who, what) return what.." wurde wiederbelebt von "..who end
	DPSMate.L["bckb"] = function(who, what, with, value) return who.." wurde getötet von "..what.."s "..with.." ("..value.." Schaden)" end
	DPSMate.L["bcfailo"] = function(what, who, value, with) return "Fail: "..what.." fügt freundlichem Ziel "..who.." "..value.." Schaden zu mit "..with end
	DPSMate.L["bcfailt"] = function(who, with) return "Fail: "..who.." ist betroffen von "..with end
	DPSMate.L["bcfailth"] = function(who, value, with, what) return "Fail: "..who.." leidet "..value.." Schaden von "..with.." von "..what end
	DPSMate.L["syncreseterror"] = "DPSMate kann nicht während des Sync-Modus in Schlachtzügen zurückgesetzt werden."
	DPSMate.L["resetnotofficererror"] = "Du bist nicht Schlachtzugsleiter oder Assist!"
	DPSMate.L["findusererror"] = "Konnte Nutzer nicht finden!"
	DPSMate.L["yes"] = "Ja"
	DPSMate.L["no"] = "Nein"
	DPSMate.L["ask"] = "Nachfragen"
	DPSMate.L["normal"] = "Normal"
	DPSMate.L["condensed"] = "Verdichtet"
	DPSMate.L["default"] = "Standard"
	DPSMate.L["topright"] = "Oben rechts"
	DPSMate.L["topleft"] = "Oben Links"
	DPSMate.L["left"] = "Links"
	DPSMate.L["top"] = "Oben"
	DPSMate.L["gchannel"] = {[1]="Raid",[2]="Party",[3]="Say",[4]="Officer",[5]="Guild"}
	DPSMate.L["nodetailserror"] = "Es gibt keine Einzelheiten zu berichten."
	DPSMate.L["reportof"] = "Bericht über"
	DPSMate.L["opendetails"] = "Öffne Einzelheiten"
	DPSMate.L["reportdetails"] = "Berichte Einzelheiten dieses Nutzers."
	DPSMate.L["fdetailsfor"] = "Kampfeinzelheiten für "
	DPSMate.L["removesegmentof"] = "Entferne Abschnitt von "
	DPSMate.L["lockedallw"] = "Alle Fenster gesperrt."
	DPSMate.L["unlockedallw"] = "Alle Fenster entsperrt."
	DPSMate.L["leftclickopend"] = "Linksklick um Einzelheiten anzuzeigen."
	DPSMate.L["rightclickopenm"] = "Rechtsklick um das Menü zu öffnen."
	DPSMate.L["hide"] = "Verstecke"
	DPSMate.L["show"] = "Zeige"
	DPSMate.L["rcchangemode"] = "Rechtsklick um den Modus zu verändern."
	DPSMate.L["segment"] = "Abschnitt"
	DPSMate.L["sync"] = "Synchronisiere"
	DPSMate.L["alliance"] = "Allianz"
	DPSMate.L["horde"] = "Horde"
	DPSMate.L["unknown"] = "Unbekannt"
	DPSMate.L["votestartederror"] = "Abstimmung hat schon begonnen!"
	DPSMate.L["votefailederror"] = "Datenrücksetzungsanfrage fehlgeschlagen!"
	DPSMate.L["votesuccess"] = "Datenrücksetzungsanfrage erfolgreich! DPSMate wurde zurückgesetzt!"
	DPSMate.L["disease"] = "Krankheit"
	DPSMate.L["magic"] = "Magie"
	DPSMate.L["curse"] = "Fluch"
	DPSMate.L["poison"] = "Gift"
	DPSMate.L["physical"] = "Physisch"
	DPSMate.L["debufftaken"] = "Schwächungszauber erhalten"
	DPSMate.L["buffs"] = "Stärkungszauber"
	DPSMate.L["debuffs"] = "Schwächungszauber"
	 
	DPSMate.L["mc"] = "Geschmolzener Kern"
	DPSMate.L["bwl"] = "Pechschwingenhort"
	DPSMate.L["ony"] = "Onyxias Hort"
	DPSMate.L["zg"] = "Zul'Gurub"
	DPSMate.L["aq401"] = "Ruinen von Ahn'Qiraj"
	DPSMate.L["aq20"] = "Tempel von Ahn'Qiraj"
	DPSMate.L["aq402"] = "Ahn'Qiraj"
	DPSMate.L["naxx"] = "Naxxramas"
	DPSMate.L["azs"] = "Azshara"
	DPSMate.L["bl"] = "Verwüstete Lande"
	DPSMate.L["dw"] = "Dämmerwald"
	DPSMate.L["hintl"] = "Hinterland"
	DPSMate.L["ash"] = "Eschental"
	DPSMate.L["fe"] = "Feralas"
	
	DPSMate.L["switchgraphsdesc"] = "Graph wechseln"
	DPSMate.L["switchindividualsdesc"] = "Einzeln/Gesamt"
	DPSMate.L["OHPS"] = "OHPS"
	DPSMate.L["OHealingTaken"] = "Überheilung bekommen"
	DPSMate.L["eohps"] = "EOHPS"
	DPSMate.L["ohealtakenby"] = "Überheilung bekommen von "
	DPSMate.L["friendlyfiretaken"] = "Friendly fire bekommen"
	DPSMate.L["fftby"] = "Friendly fire bekommen von "
	DPSMate.L["poisoncleansingtotem"] = "Totem der Giftreinigung"
	DPSMate.L["threatdoneby"] = "Aggro gemacht von "
	DPSMate.L["periodic"] = "(Periodisch)"
	DPSMate.L["reportchannel"] = {[1]=DPSMate.L["whisper"],[2]="Raid",[3]="Party",[4]="Say",[5]="Officer",[6]="Guild"}
	DPSMate.L["raid"] = "Raid"
	DPSMate.L["activity"] = "Aktivität: "
	DPSMate.L["of"] = "von"
	DPSMate.L["comparewith"] = "Vergleichen mit"
	DPSMate.L["comparewithdesc"] = "Wähle einen Spieler, mit dem du diesen Spieler vergleichen willst."
	DPSMate.L["targetscale"] = "Ziel e-frame Größe"
	DPSMate.L["targetscaleTooltip"] = "Verändere die Größe von den analyse Fenster."
	DPSMate.L["eddsum"] = "Gesamtschaden von Gegnern"
	DPSMate.L["edtsum"] = "Gesamtschaden an Gegnern"
	DPSMate.L["ehpssum"] = "Gesamt effektive Heilung"
	DPSMate.L["tehealing"] = " effektive Heilung"
	DPSMate.L["hpssum"] = "Gesamtheilung"
	DPSMate.L["thealing"] = " heilung"
	DPSMate.L["ohpssum"] = "Gesamtüberheilung"
	DPSMate.L["tohealing"] = " Überheilung"
	DPSMate.L["tehealingtaken"] = " effektive Heilung bekommen"
	DPSMate.L["ehpstsum"] = "Gesamt effektive Heilung bekommen"
	DPSMate.L["thealingtaken"] = " Heilung bekommen"
	DPSMate.L["hpstsum"] = "Gesamtheilung bekommen"
	DPSMate.L["tohealingtaken"] = " Überheilung bekommen"
	DPSMate.L["ohpstsum"] = "Gesamtüberheilung bekommen"
	DPSMate.L["habsum"] = "Gesamtheilung und Absorbierungen"
	DPSMate.L["threatdone"] = "Aggro"
	DPSMate.L["threatsum"] = "Gesamtaggro"
	DPSMate.L["ffsum"] = "Gesamt friendly fire"
	DPSMate.L["fftsum"] = "Gesamt friendly fire bekommen"
	DPSMate.L["over"] = "Über"
	DPSMate.L["lastability"] = "Letzten drei Ereignisse"
	DPSMate.L["deathssum"] = "Gesamttode"
	DPSMate.L["victim"] = "Opfer"
	DPSMate.L["deathhistory"] = "Ereignisse"
	DPSMate.L["intersum"] = "Gesamtunterbrechungen"
	DPSMate.L["dispelssum"] = "Gesamtdispels"
	DPSMate.L["dispels"] = "Dispels"
	DPSMate.L["decursessum"] = "Gesamtentfluchungen"
	DPSMate.L["ccbreakersum"] = "Gesamt CCBreaker"
	DPSMate.L["failssum"] = "Fails Übersicht"
	DPSMate.L["AutoAttack"] = "Angreifen"
	DPSMate.L["AutoShot"] = "Automatischer Schuss"
	DPSMate.L["castssum"] = "Zauberübersicht"
	DPSMate.L["procssum"] = "Procsübersicht"
	DPSMate.L["aurassum"] = "Aura Übersicht"
	DPSMate.L["absorbssum"] = "Absorbübersicht"
	DPSMate.L["absorbeddmg"] = "Absorbierungen"
	DPSMate.L["absorbstakensum"] = "Absorbierungen bekommen Übersicht"
	DPSMate.L["activity"] = "Aktivität"
	DPSMate.L["cbtdisplay"] = "Deaktiviere CBT-Anzeige"
	
	DPSMate.L["disablebarbg"] = "Hintergrund deaktivieren"
	DPSMate.L["disablebarbgtooltip"] = "Deaktiviere den Hintergrund von jeder Bar."
	DPSMate.L["totalbaropacity"] = "Gesamtbar Transparenz"
	DPSMate.L["totalbaropacitytooltip"] = "Bewege das, um die Transparenz von der Gesamtbar zu verändern."
	DPSMate.L["abortvote"] = "Reset abbrechen. Als Assistent oder Schlachtzugsleiter kannst du den reset abbrechen, wenn du schnell genug bist."
	DPSMate.L["resetaborted"] = "Die Resetabstimmung wurde abgebrochen. Es wurde ein Cooldown von 20 Sekunden zum nächsten Reset gesetzt."
	
	DPSMate.L["vreset"] = "Reset"
	DPSMate.L["vdreset"] = "Nicht Resetten"
	DPSMate.L["togglereportframe"] = "Report fenster an/aus"
	DPSMate.L["toggleframes"] = "Hauptfenster an/aus"
	DPSMate.L["resetdpsmate"] = "DPSMate resetten"
	DPSMate.L["columnstooltip"] = "Aktiviere das, um diese Extrainformation in diesem Modus zu zeigen."
	DPSMate.L["commas"] = "Komma"
	DPSMate.L["versionisold"] = "Deine DPSMate-Version ist veraltet. Update besser mal. DPSMate synchronisiert nur aktuellen Versionen."
	DPSMate.L["rezz"] = "Wiederbelebungen"
	DPSMate.L["rezzof"] = "Wiederbelebungen von "
	DPSMate.L["rezzsum"] = "Wiederbelebungs Übersicht"
	DPSMate.L["activity"] = "Aktivität"
	DPSMate.L["cbtdisplay"] = "Deaktiviere CBT-Anzeige"
	DPSMate.L["semicondensed"] = "Semi-Verdichtet"
	DPSMate.L["loginhide"] = "Verstecke beim einloggen"
	DPSMate.L["borderOpacityTooltip"] = "Verändere die Sichtbarkeit des Randes."
	DPSMate.L["borderOpacity"] = "Rand-Transparenz"
	DPSMate.L["bordertextureTooltip"] = "Wähle eine Textur für den Rand."
	DPSMate.L["bordertexture"] = "Randtextur"
	DPSMate.L["borderstrataTooltip"] = "Wähle die Ebene des Randes aus."
	DPSMate.L["borderstrata"] = "Randebene"
	DPSMate.L["bordercolor"] = "Randfarbe"
	DPSMate.L["bordercolorTooltip"] = "Gestalte die Randfarbe."
	
	DPSMate.L["reportdelaytooltip"] = "Füge eine Verzögerung hinzu, um mutes auf manchen Servern zu entgehen."
	DPSMate.L["delay"] = "Delay"
	
	-- Newly added:
	DPSMate.L["tttop"] = "Top "
	DPSMate.L["ttdamage"] = " Damage"
	DPSMate.L["tthealing"] = " Healing"
	DPSMate.L["ttpet"] = " Pet"
	DPSMate.L["ttpet2"] = "Pet: "
	DPSMate.L["ttabilities"] = " Fähigkeiten"
	DPSMate.L["ttattacked"] = " Angegriffen"
	DPSMate.L["tthealed"] = " Geheilt"
	DPSMate.L["ttinterrupt"] = " Unterbrich"
	DPSMate.L["ttinterrupted"] = " Unterbrochen"
	DPSMate.L["ttdispelled"] = " Entzaubert"
	DPSMate.L["ttabsorbed"] = " Absorbiert"
	DPSMate.L["ttabsorb"] = " Absorb"
	DPSMate.L["ttthreat"] = " Bedrohung"
	
	
	-- Updating preloaded configs
	local _G = getglobal
	local prestr = "DPSMate_ConfigMenu_"
	-- Menu
	local substr = "Menu_"
	_G(prestr..substr.."Button1"):SetText(DPSMate.L["window"])
	_G(prestr..substr.."Button2"):SetText(DPSMate.L["dataresets"])
	_G(prestr..substr.."Button3"):SetText(DPSMate.L["generaloptions"])
	_G(prestr..substr.."Button4"):SetText(DPSMate.L["columns"])
	_G(prestr..substr.."Button5"):SetText(DPSMate.L["tooltips"])
	_G(prestr..substr.."Button6"):SetText(DPSMate.L["modes"])
	_G(prestr..substr.."Button7"):SetText(DPSMate.L["raidleader"])
	_G(prestr..substr.."Button8"):SetText(DPSMate.L["broadcasting"])
	_G(prestr..substr.."Button9"):SetText(DPSMate.L["about"])
	
	-- Window
	substr = "Tab_Window_"
	_G(prestr..substr.."EditboxText"):SetText(DPSMate.L["createwindow"])
	_G(prestr..substr.."Editbox").aide = DPSMate.L["createwindowtooltip"]
	_G(prestr..substr.."SubmitText"):SetText(DPSMate.L["submit"])
	_G(prestr..substr.."Submit").aide = DPSMate.L["submitTooltip"]
	_G(prestr..substr.."Remove_Text"):SetText(DPSMate.L["availwindows"])
	_G(prestr..substr.."Remove").aide = DPSMate.L["availwindowsTooltip"]
	_G(prestr..substr.."ButtonRemoveText"):SetText(DPSMate.L["remove"])
	_G(prestr..substr.."ButtonRemove").aide = DPSMate.L["removeTooltip"]
	_G(prestr..substr.."ConfigFrom_Text"):SetText(DPSMate.L["configfrom"])
	_G(prestr..substr.."ConfigFrom").aide = DPSMate.L["configfromTooltip"]
	_G(prestr..substr.."ConfigTo_Text"):SetText(DPSMate.L["configto"])
	_G(prestr..substr.."ConfigTo").aide = DPSMate.L["configtoTooltip"]
	_G(prestr..substr.."ButtonCopyText"):SetText(DPSMate.L["copy"])
	_G(prestr..substr.."ButtonCopy").aide = DPSMate.L["copyTooltip"]
	_G(prestr..substr.."Lock_Title"):SetText(DPSMate.L["lock"])
	_G(prestr..substr.."Lock").aide = DPSMate.L["locktooltip"]
	_G(prestr..substr.."Testmode_Title"):SetText(DPSMate.L["testmode"])
	_G(prestr..substr.."Testmode").aide = DPSMate.L["testmodetooltip"]
	
	-- Bars
	substr = "Tab_Bars_"
	_G(prestr..substr.."BarFont_Text"):SetText(DPSMate.L["barfont"])
	_G(prestr..substr.."BarFont").aide = DPSMate.L["barfontTooltip"]
	_G(prestr..substr.."BarFontSizeText"):SetText(DPSMate.L["barfontsize"])
	_G(prestr..substr.."BarFontSize").aide = DPSMate.L["barfontsizeTooltip"]
	_G(prestr..substr.."BarFontFlag_Text"):SetText(DPSMate.L["barfontflags"])
	_G(prestr..substr.."BarFontFlag").aide = DPSMate.L["barfontflagsTooltip"]
	_G(prestr..substr.."BarTexture_Text"):SetText(DPSMate.L["bartexture"])
	_G(prestr..substr.."BarTexture").aide = DPSMate.L["bartextureTooltip"]
	_G(prestr..substr.."BarSpacingText"):SetText(DPSMate.L["barspacing"])
	_G(prestr..substr.."BarSpacing").aide = DPSMate.L["barspacingTooltip"]
	_G(prestr..substr.."BarHeightText"):SetText(DPSMate.L["barheight"])
	_G(prestr..substr.."BarHeight").aide = DPSMate.L["barheightTooltip"]
	_G(prestr..substr.."FontColor_Font"):SetText(DPSMate.L["fontcolor"])
	_G(prestr..substr.."FontColor").aide = DPSMate.L["fontcolorTooltip"]
	_G(prestr..substr.."BackgroundBarColor_Font"):SetText(DPSMate.L["bgbarcolor"])
	_G(prestr..substr.."BackgroundBarColor").aide = DPSMate.L["bgbarcolorTooltip"]
	_G(prestr..substr.."ClassIcons_Title"):SetText(DPSMate.L["classicons"])
	_G(prestr..substr.."ClassIcons").aide = DPSMate.L["classiconstooltip"]
	_G(prestr..substr.."Ranks_Title"):SetText(DPSMate.L["ranks"])
	_G(prestr..substr.."Ranks").aide = DPSMate.L["rankstooltip"]
	_G(prestr..substr.."DisableBG_Title"):SetText(DPSMate.L["disablebarbg"])
	_G(prestr..substr.."DisableBG").aide = DPSMate.L["disablebarbgtooltip"]
	_G(prestr..substr.."TotalAlphaText"):SetText(DPSMate.L["totalbaropacity"])
	_G(prestr..substr.."TotalAlpha").aide = DPSMate.L["totalbaropacitytooltip"]
	
	-- Titlebar
	substr = "Tab_TitleBar_"
	_G(prestr..substr.."Enable_Title"):SetText(DPSMate.L["enable"])
	_G(prestr..substr.."Enable").aide = DPSMate.L["enabletitlebartooltip"]
	_G(prestr..substr.."BarFont_Text"):SetText(DPSMate.L["barfont"])
	_G(prestr..substr.."BarFont").aide = DPSMate.L["barfontTooltip"]
	_G(prestr..substr.."BarFontSizeText"):SetText(DPSMate.L["barfontsize"])
	_G(prestr..substr.."BarFontSize").aide = DPSMate.L["barfontsizeTooltip"]
	_G(prestr..substr.."BarFontFlag_Text"):SetText(DPSMate.L["barfontflags"])
	_G(prestr..substr.."BarFontFlag").aide = DPSMate.L["barfontflagsTooltip"]
	_G(prestr..substr.."BarTexture_Text"):SetText(DPSMate.L["bartexture"])
	_G(prestr..substr.."BarTexture").aide = DPSMate.L["bartextureTooltip"]
	_G(prestr..substr.."BarHeightText"):SetText(DPSMate.L["barheight"])
	_G(prestr..substr.."BarHeight").aide = DPSMate.L["barheightTooltip"]
	_G(prestr..substr.."BGOpacityText"):SetText(DPSMate.L["bgOpacity"])
	_G(prestr..substr.."BGOpacity").aide = DPSMate.L["bgOpacityTooltip"]
	_G(prestr..substr.."BGColor_Font"):SetText(DPSMate.L["bgcolor"])
	_G(prestr..substr.."BGColor").aide = DPSMate.L["bgcolorTooltip"]
	_G(prestr..substr.."FontColor_Font"):SetText(DPSMate.L["fontcolor"])
	_G(prestr..substr.."FontColor").aide = DPSMate.L["fontcolorTooltip"]
	_G(prestr..substr.."Box1_Report_Title"):SetText(DPSMate.L["report"])
	_G(prestr..substr.."Box1_Report").aide = DPSMate.L["buttonshowtooltip"]
	_G(prestr..substr.."Box1_Mode_Title"):SetText(DPSMate.L["mode"])
	_G(prestr..substr.."Box1_Mode").aide = DPSMate.L["buttonshowtooltip"]
	_G(prestr..substr.."Box1_Reset_Title"):SetText(DPSMate.L["reset"])
	_G(prestr..substr.."Box1_Reset").aide = DPSMate.L["buttonshowtooltip"]
	_G(prestr..substr.."Box1_Config_Title"):SetText(DPSMate.L["config"])
	_G(prestr..substr.."Box1_Config").aide = DPSMate.L["buttonshowtooltip"]
	_G(prestr..substr.."Box1_Sync_Title"):SetText(DPSMate.L["sync"])
	_G(prestr..substr.."Box1_Sync").aide = DPSMate.L["buttonshowtooltip"]
	_G(prestr..substr.."Box1_Enable_Title"):SetText(DPSMate.L["enabledisable"])
	_G(prestr..substr.."Box1_Enable").aide = DPSMate.L["buttonshowtooltip"]
	_G(prestr..substr.."Box1_Filter_Title"):SetText(DPSMate.L["filter"])
	_G(prestr..substr.."Box1_Filter").aide = DPSMate.L["buttonshowtooltip"]
	_G(prestr..substr.."Box1_CBTDisplay_Title"):SetText(DPSMate.L["cbtdisplay"])
	_G(prestr..substr.."Box1_CBTDisplay").aide = DPSMate.L["buttonshowtooltip"]
	
	-- Tab content
	substr = "Tab_Content_"
	_G(prestr..substr.."BGDropDown_Text"):SetText(DPSMate.L["bgtex"])
	_G(prestr..substr.."BGDropDown").aide = DPSMate.L["bgtexTooltip"]
	_G(prestr..substr.."ScaleText"):SetText(DPSMate.L["scale"])
	_G(prestr..substr.."Scale").aide = DPSMate.L["scaleTooltip"]
	_G(prestr..substr.."OpacityText"):SetText(DPSMate.L["opacity"])
	_G(prestr..substr.."Opacity").aide = DPSMate.L["opacityTooltip"]
	_G(prestr..substr.."BGOpacityText"):SetText(DPSMate.L["bgOpacity"])
	_G(prestr..substr.."BGOpacity").aide = DPSMate.L["bgOpacityTooltip"]
	_G(prestr..substr.."BorderOpacityText"):SetText(DPSMate.L["borderOpacity"])
	_G(prestr..substr.."BorderOpacity").aide = DPSMate.L["borderOpacityTooltip"]
	_G(prestr..substr.."BGColor_Font"):SetText(DPSMate.L["bgcolor"])
	_G(prestr..substr.."BGColor").aide = DPSMate.L["bgcolorTooltip"]
	_G(prestr..substr.."NumberFormat_Text"):SetText(DPSMate.L["numberformat"])
	_G(prestr..substr.."NumberFormat").aide = DPSMate.L["numberformatTooltip"]
	_G(prestr..substr.."BorderTexture_Text"):SetText(DPSMate.L["bordertexture"])
	_G(prestr..substr.."BorderTexture").aide = DPSMate.L["bordertextureTooltip"]
	_G(prestr..substr.."BorderStrata_Text"):SetText(DPSMate.L["borderstrata"])
	_G(prestr..substr.."BorderStrata").aide = DPSMate.L["borderstrataTooltip"]
	_G(prestr..substr.."BorderColor_Font"):SetText(DPSMate.L["bordercolor"])
	_G(prestr..substr.."BorderColor").aide = DPSMate.L["bordercolorTooltip"]
	
	-- Tab Dataresets
	substr = "Tab_DataResets_"
	_G(prestr..substr.."EnteringWorld_Text"):SetText(DPSMate.L["enterworldinstance"])
	_G(prestr..substr.."EnteringWorld").aide = DPSMate.L["enterworldinstanceTooltip"]
	_G(prestr..substr.."JoinParty_Text"):SetText(DPSMate.L["joinparty"])
	_G(prestr..substr.."JoinParty").aide = DPSMate.L["joinpartyTooltip"]
	_G(prestr..substr.."PartyMemberChanged_Text"):SetText(DPSMate.L["partymemberchanged"])
	_G(prestr..substr.."PartyMemberChanged").aide = DPSMate.L["partymemberchangedTooltip"]
	_G(prestr..substr.."LeaveParty_Text"):SetText(DPSMate.L["leavingparty"])
	_G(prestr..substr.."LeaveParty").aide = DPSMate.L["leavingpartyTooltip"]
	_G(prestr..substr.."Sync_Text"):SetText(DPSMate.L["syncrequest"])
	_G(prestr..substr.."Sync").aide = DPSMate.L["syncrequesttooltip"]
	_G(prestr..substr.."Logout_Text"):SetText(DPSMate.L["dataresetslogout"])
	_G(prestr..substr.."Logout").aide = DPSMate.L["dataresetslogouttooltip"]
	
	-- Tab general options
	substr = "Tab_GeneralOptions_"
	_G(prestr..substr.."Minimap_Title"):SetText(DPSMate.L["minimap"])
	_G(prestr..substr.."Minimap").aide = DPSMate.L["minimaptooltip"]
	_G(prestr..substr.."Total_Title"):SetText(DPSMate.L["showtotal"])
	_G(prestr..substr.."Total").aide = DPSMate.L["showtotaltooltip"]
	_G(prestr..substr.."Solo_Title"):SetText(DPSMate.L["solo"])
	_G(prestr..substr.."Solo").aide = DPSMate.L["solotooltip"]
	_G(prestr..substr.."Combat_Title"):SetText(DPSMate.L["combat"])
	_G(prestr..substr.."Combat").aide = DPSMate.L["combattooltip"]
	_G(prestr..substr.."Login_Title"):SetText(DPSMate.L["loginhide"])
	_G(prestr..substr.."Login").aide = DPSMate.L["loginhidetooltip"]
	_G(prestr..substr.."BossFights_Title"):SetText(DPSMate.L["bossfights"])
	_G(prestr..substr.."BossFights").aide = DPSMate.L["bossfightstooltip"]
	_G(prestr..substr.."PVP_Title"):SetText(DPSMate.L["pvp"])
	_G(prestr..substr.."PVP").aide = DPSMate.L["pvptooltip"]
	_G(prestr..substr.."Disable_Title"):SetText(DPSMate.L["disable"])
	_G(prestr..substr.."Disable").aide = DPSMate.L["disabletooltip"]
	_G(prestr..substr.."MergePets_Title"):SetText(DPSMate.L["mergepets"])
	_G(prestr..substr.."MergePets").aide = DPSMate.L["mergepetstooltip"]
	_G(prestr..substr.."SegmentsText"):SetText(DPSMate.L["segments"])
	_G(prestr..substr.."Segments").aide = DPSMate.L["segmentsTooltip"]
	_G(prestr..substr.."TargetScaleText"):SetText(DPSMate.L["targetscale"])
	_G(prestr..substr.."TargetScale").aide = DPSMate.L["targetscaleTooltip"]
	
	-- Tab Columns
	substr = "Tab_Columns_Child_"
	_G(prestr..substr.."DPS_Title"):SetText(DPSMate.L["dps"])
	_G(prestr..substr.."Damage_Title"):SetText(DPSMate.L["damage"])
	_G(prestr..substr.."DamageTaken_Title"):SetText(DPSMate.L["damagetaken"])
	_G(prestr..substr.."DTPS_Title"):SetText(DPSMate.L["dtps"])
	_G(prestr..substr.."EDD_Title"):SetText(DPSMate.L["enemydamagedone"])
	_G(prestr..substr.."EDT_Title"):SetText(DPSMate.L["enemydamagetaken"])
	_G(prestr..substr.."Healing_Title"):SetText(DPSMate.L["healing"])
	_G(prestr..substr.."HealingTaken_Title"):SetText(DPSMate.L["healingtaken"])
	_G(prestr..substr.."HPS_Title"):SetText(DPSMate.L["hps"])
	_G(prestr..substr.."Overhealing_Title"):SetText(DPSMate.L["overhealing"])
	_G(prestr..substr.."EffectiveHealing_Title"):SetText(DPSMate.L["effectivehealing"])
	_G(prestr..substr.."EffectiveHealingTaken_Title"):SetText(DPSMate.L["effectivehealingtaken"])
	_G(prestr..substr.."EffectiveHPS_Title"):SetText(DPSMate.L["effectivehps"])
	_G(prestr..substr.."Absorbs_Title"):SetText(DPSMate.L["absorbs"])
	_G(prestr..substr.."AbsorbsTaken_Title"):SetText(DPSMate.L["absorbstaken"])
	_G(prestr..substr.."HAB_Title"):SetText(DPSMate.L["healingandabsorbs"])
	_G(prestr..substr.."Deaths_Title"):SetText(DPSMate.L["deaths"])
	_G(prestr..substr.."Interrupts_Title"):SetText(DPSMate.L["interrupts"])
	_G(prestr..substr.."Dispels_Title"):SetText(DPSMate.L["dispels"])
	_G(prestr..substr.."DispelsReceived_Title"):SetText(DPSMate.L["dispelsreceived"])
	_G(prestr..substr.."Decurses_Title"):SetText(DPSMate.L["decurses"])
	_G(prestr..substr.."DecursesReceived_Title"):SetText(DPSMate.L["decursesreceived"])
	_G(prestr..substr.."Disease_Title"):SetText(DPSMate.L["curedisease"])
	_G(prestr..substr.."DiseaseReceived_Title"):SetText(DPSMate.L["curediseasereceived"])
	_G(prestr..substr.."Poison_Title"):SetText(DPSMate.L["curepoison"])
	_G(prestr..substr.."PoisonReceived_Title"):SetText(DPSMate.L["curepoisonreceived"])
	_G(prestr..substr.."Magic_Title"):SetText(DPSMate.L["liftmagic"])
	_G(prestr..substr.."MagicReceived_Title"):SetText(DPSMate.L["liftmagicreceived"])
	_G(prestr..substr.."AurasGained_Title"):SetText(DPSMate.L["aurasgained"])
	_G(prestr..substr.."AurasLost_Title"):SetText(DPSMate.L["auraslost"])
	_G(prestr..substr.."AuraUptime_Title"):SetText(DPSMate.L["aurauptime"])
	_G(prestr..substr.."FriendlyFire_Title"):SetText(DPSMate.L["friendlyfire"])
	_G(prestr..substr.."Procs_Title"):SetText(DPSMate.L["procs"])
	_G(prestr..substr.."Casts_Title"):SetText(DPSMate.L["casts"])
	_G(prestr..substr.."Threat_Title"):SetText(DPSMate.L["threat"])
	_G(prestr..substr.."TPS_Title"):SetText(DPSMate.L["tps"])
	_G(prestr..substr.."Fails_Title"):SetText(DPSMate.L["fails"])
	_G(prestr..substr.."CCBreaker_Title"):SetText(DPSMate.L["cccbreaker"])
	_G(prestr..substr.."OHPS_Title"):SetText(DPSMate.L["OHPS"])
	_G(prestr..substr.."OHealingTaken_Title"):SetText(DPSMate.L["OHealingTaken"])
	_G(prestr..substr.."FriendlyFireTaken_Title"):SetText(DPSMate.L["friendlyfiretaken"])
	
	-- Tab Tooltips
	substr = "Tab_Tooltips_"
	_G(prestr..substr.."Tooltips_Title"):SetText(DPSMate.L["showtooltips"])
	_G(prestr..substr.."Tooltips").aide = DPSMate.L["showtooltipsTooltip"]
	_G(prestr..substr.."InformativeTooltips_Title"):SetText(DPSMate.L["informativetooltips"])
	_G(prestr..substr.."InformativeTooltips").aide = DPSMate.L["informativetooltipsTooltip"]
	_G(prestr..substr.."RowsText"):SetText(DPSMate.L["subviewrows"])
	_G(prestr..substr.."Rows").aide = DPSMate.L["subviewrowsTooltip"]
	_G(prestr..substr.."Position_Text"):SetText(DPSMate.L["TooltipPositionDropDown"])
	_G(prestr..substr.."Position").aide = DPSMate.L["TooltipPositionDropDownTooltip"]
	
	-- Raidleader
	substr = "Tab_RaidLeader_"
	_G(prestr..substr.."HelloWorldText"):SetText(DPSMate.L["helloworld"])
	_G(prestr..substr.."HelloWorld").aide = DPSMate.L["helloworldTooltip"]
	
	-- Tab Broadcasting
	substr = "Tab_Broadcasting_"
	_G(prestr..substr.."Enable_Title"):SetText(DPSMate.L["enable"])
	_G(prestr..substr.."Enable").aide = DPSMate.L["enablebroadcasting"]
	_G(prestr..substr.."RaidWarning_Title"):SetText(DPSMate.L["useraidwarning"])
	_G(prestr..substr.."RaidWarning").aide = DPSMate.L["useraidwarningTooltip"]
	_G(prestr..substr.."Cooldowns_Title"):SetText(DPSMate.L["relevantcds"])
	_G(prestr..substr.."Cooldowns").aide = DPSMate.L["relevantcdsTooltip"]
	_G(prestr..substr.."Ress_Title"):SetText(DPSMate.L["ress"])
	_G(prestr..substr.."Ress").aide = DPSMate.L["ressTooltip"]
	_G(prestr..substr.."KillingBlows_Title"):SetText(DPSMate.L["killingblows"])
	_G(prestr..substr.."KillingBlows").aide = DPSMate.L["killingblowsTooltip"]
	_G(prestr..substr.."Fails_Title"):SetText(DPSMate.L["fails"])
	_G(prestr..substr.."Fails").aide = DPSMate.L["failsTooltip"]
	
	-- Tab About
	substr = "Tab_About_"
	_G(prestr..substr.."What_Title"):SetText(DPSMate.L["whatisdpsmate"])
	_G(prestr..substr.."What_Text"):SetText(DPSMate.L["whatisdpsmateText"])
	_G(prestr..substr.."Who_Title"):SetText(DPSMate.L["whocreateddpsmate"])
	_G(prestr..substr.."Who_Text"):SetText(DPSMate.L["whocreateddpsmateText"])
	_G(prestr..substr.."Thanks_Title"):SetText(DPSMate.L["thanksto"])
	_G(prestr..substr.."Thanks_Text"):SetText(DPSMate.L["thankstoText"])
	
	-- Damage done details
	DPSMate_Details_DiagramLegend_Procs_Text:SetText(DPSMate.L["procs"])
	DPSMate_Details_LogDetails_Block:SetText(DPSMate.L["block"])
	DPSMate_Details_LogDetails_Glance:SetText(DPSMate.L["glance"])
	DPSMate_Details_LogDetails_Hit:SetText(DPSMate.L["hit"])
	DPSMate_Details_LogDetails_Amount:SetText(DPSMate.L["amount"])
	DPSMate_Details_LogDetails_Average:SetText(DPSMate.L["average"])
	DPSMate_Details_LogDetails_Min:SetText(DPSMate.L["min"])
	DPSMate_Details_LogDetails_Max:SetText(DPSMate.L["max"])
	DPSMate_Details_LogDetails_Crit:SetText(DPSMate.L["crit"])
	DPSMate_Details_LogDetails_Miss:SetText(DPSMate.L["miss"])
	DPSMate_Details_LogDetails_Parry:SetText(DPSMate.L["parry"])
	DPSMate_Details_LogDetails_Dodge:SetText(DPSMate.L["dodge"])
	DPSMate_Details_LogDetails_Resist:SetText(DPSMate.L["resist"])
	
	DPSMate_Details_CompareDamage_DiagramLegend_Procs_Text:SetText(DPSMate.L["procs"])
	DPSMate_Details_CompareDamage_LogDetails_Block:SetText(DPSMate.L["block"])
	DPSMate_Details_CompareDamage_LogDetails_Glance:SetText(DPSMate.L["glance"])
	DPSMate_Details_CompareDamage_LogDetails_Hit:SetText(DPSMate.L["hit"])
	DPSMate_Details_CompareDamage_LogDetails_Amount:SetText(DPSMate.L["amount"])
	DPSMate_Details_CompareDamage_LogDetails_Average:SetText(DPSMate.L["average"])
	DPSMate_Details_CompareDamage_LogDetails_Min:SetText(DPSMate.L["min"])
	DPSMate_Details_CompareDamage_LogDetails_Max:SetText(DPSMate.L["max"])
	DPSMate_Details_CompareDamage_LogDetails_Crit:SetText(DPSMate.L["crit"])
	DPSMate_Details_CompareDamage_LogDetails_Miss:SetText(DPSMate.L["miss"])
	DPSMate_Details_CompareDamage_LogDetails_Parry:SetText(DPSMate.L["parry"])
	DPSMate_Details_CompareDamage_LogDetails_Dodge:SetText(DPSMate.L["dodge"])
	DPSMate_Details_CompareDamage_LogDetails_Resist:SetText(DPSMate.L["resist"])
	
	DPSMate.Options.Options[1]["args"]["damage"] = {
		order = 20,
		type = 'toggle',
		name = DPSMate.L["damage"],
		desc = DPSMate.L["show"].." "..DPSMate.L["damage"]..".",
		get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["damage"] end,
		set = function() DPSMate.Options:ToggleDrewDrop(1, "damage", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
	}
	DPSMate.Options.Options[1]["args"]["dps"] = {
		order = 10,
		type = 'toggle',
		name = DPSMate.L["dps"],
		desc = DPSMate.L["show"].." "..DPSMate.L["dps"]..".",
		get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["dps"] end, -- Addons might conflicting here with dewdrop
		set = function() DPSMate.Options:ToggleDrewDrop(1, "dps", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
	}
	
	-- Popups
	DPSMate_PopUp_Text:SetText(DPSMate.L["popup"])
	DPSMate_PopUp_TotalText:SetText(DPSMate.L["total"])
	DPSMate_PopUp_CurrentText:SetText(DPSMate.L["current"])
	DPSMate_PopUp_CancelText:SetText(DPSMate.L["cancel"])
	DPSMate_Vote_Text:SetText(DPSMate.L["popup"])
	DPSMate_Vote_AcceptText:SetText(DPSMate.L["vreset"])
	DPSMate_Vote_CancelText:SetText(DPSMate.L["vdreset"])
	DPSMate_Logout_Text:SetText(DPSMate.L["memory"])
	DPSMate_Logout_AcceptText:SetText(DPSMate.L["accept"])
	DPSMate_Logout_CancelText:SetText(DPSMate.L["decline"])
	DPSMate_Report_Text:SetText(DPSMate.L["report"].." - "..DPSMate.L["name"])
	DPSMate_Report_Channel_Text:SetText(DPSMate.L["channel"])
	DPSMate_Report_Delay.aide = DPSMate.L["reportdelaytooltip"]
	DPSMate_Report_Delay_Title:SetText(DPSMate.L["delay"])
	DPSMate_Report_Editbox_Text:SetText(DPSMate.L["editboxtitle"])
	DPSMate_Report_ReportButton:SetText(DPSMate.L["report"])
	
	
	DPSMate.Options.Options[2]["args"]["total"]["name"] = DPSMate.L["total"]
	DPSMate.Options.Options[2]["args"]["total"]["desc"] = DPSMate.L["totalmode"]
	DPSMate.Options.Options[2]["args"]["currentFight"]["name"] = DPSMate.L["mcurrent"]
	DPSMate.Options.Options[2]["args"]["currentFight"]["desc"] = DPSMate.L["currentmode"]
	DPSMate.Options.Options[3]["args"]["test"]["name"] = DPSMate.L["testmode"]
	DPSMate.Options.Options[3]["args"]["test"]["desc"] = DPSMate.L["testmodedesc"]
	DPSMate.Options.Options[3]["args"]["report"]["name"] = DPSMate.L["report"]
	DPSMate.Options.Options[3]["args"]["report"]["desc"] = DPSMate.L["reportsegment"]
	DPSMate.Options.Options[3]["args"]["reset"]["name"] = DPSMate.L["reset"]
	DPSMate.Options.Options[3]["args"]["reset"]["desc"] = DPSMate.L["resetdesc"]
	DPSMate.Options.Options[3]["args"]["realtime"]["name"] = DPSMate.L["mrealtime"]
	DPSMate.Options.Options[3]["args"]["realtime"]["desc"] = DPSMate.L["mrealtimedesc"]
	DPSMate.Options.Options[3]["args"]["realtime"]["args"]["damage"]["name"] = DPSMate.L["damagedone"]
	DPSMate.Options.Options[3]["args"]["realtime"]["args"]["damage"]["desc"] = DPSMate.L["realtimedmgdone"]
	DPSMate.Options.Options[3]["args"]["realtime"]["args"]["dmgt"]["name"] = DPSMate.L["damagetaken"]
	DPSMate.Options.Options[3]["args"]["realtime"]["args"]["dmgt"]["desc"] = DPSMate.L["realtimedmgtaken"]
	DPSMate.Options.Options[3]["args"]["realtime"]["args"]["heal"]["name"] = DPSMate.L["healing"]
	DPSMate.Options.Options[3]["args"]["realtime"]["args"]["heal"]["desc"] = DPSMate.L["realtimehealing"]
	DPSMate.Options.Options[3]["args"]["realtime"]["args"]["eheal"]["name"] = DPSMate.L["effectivehealing"]
	DPSMate.Options.Options[3]["args"]["realtime"]["args"]["eheal"]["desc"] = DPSMate.L["realtimeehealing"]
	DPSMate.Options.Options[3]["args"]["startnewsegment"]["name"] = DPSMate.L["newsegment"]
	DPSMate.Options.Options[3]["args"]["startnewsegment"]["desc"] = DPSMate.L["newsegmentdesc"]
	DPSMate.Options.Options[3]["args"]["deletesegment"]["name"] = DPSMate.L["removesegment"]
	DPSMate.Options.Options[3]["args"]["deletesegment"]["desc"] = DPSMate.L["removesegmentdesc"]
	DPSMate.Options.Options[3]["args"]["showAll"]["name"] = DPSMate.L["showAll"]
	DPSMate.Options.Options[3]["args"]["showAll"]["desc"] = DPSMate.L["showAllDesc"]
	DPSMate.Options.Options[3]["args"]["hideAll"]["name"] = DPSMate.L["hideAll"]
	DPSMate.Options.Options[3]["args"]["hideAll"]["desc"] = DPSMate.L["hideAllDesc"]
	DPSMate.Options.Options[3]["args"]["showwindow"]["name"] = DPSMate.L["showwindow"]
	DPSMate.Options.Options[3]["args"]["showwindow"]["desc"] = DPSMate.L["showwindowdesc"]
	DPSMate.Options.Options[3]["args"]["hidewindow"]["name"] = DPSMate.L["hidewindow"]
	DPSMate.Options.Options[3]["args"]["hidewindow"]["desc"] = DPSMate.L["hidewindowdesc"]
	DPSMate.Options.Options[3]["args"]["lock"]["name"] = DPSMate.L["lock"]
	DPSMate.Options.Options[3]["args"]["lock"]["desc"] = DPSMate.L["lockdesc"]
	DPSMate.Options.Options[3]["args"]["unlock"]["name"] = DPSMate.L["unlock"]
	DPSMate.Options.Options[3]["args"]["unlock"]["desc"] = DPSMate.L["unlock"]
	DPSMate.Options.Options[3]["args"]["configure"]["name"] = DPSMate.L["config"]
	DPSMate.Options.Options[3]["args"]["configure"]["desc"] = DPSMate.L["config"]
	DPSMate.Options.Options[3]["args"]["close"]["name"] = DPSMate.L["close"]
	DPSMate.Options.Options[3]["args"]["close"]["desc"] = DPSMate.L["close"]
	DPSMate.Options.Options[4]["args"]["report"]["name"] = DPSMate.L["report"]
	DPSMate.Options.Options[4]["args"]["report"]["desc"] = DPSMate.L["reportdesc"]
	DPSMate.Options.Options[4]["args"]["report"]["args"]["whisper"]["name"] = DPSMate.L["whisper"]
	DPSMate.Options.Options[4]["args"]["report"]["args"]["whisper"]["desc"] = DPSMate.L["whisperdesc"]
	DPSMate.Options.Options[4]["args"]["compare"]["name"] = DPSMate.L["comparewith"]
	DPSMate.Options.Options[4]["args"]["compare"]["desc"] = DPSMate.L["comparewithdesc"]
	DPSMate.Options.Options[5]["args"]["classes"]["name"] = DPSMate.L["classes"]
	DPSMate.Options.Options[5]["args"]["classes"]["desc"] = DPSMate.L["classesdesc"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["warrior"]["name"] = DPSMate.L["warrior"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["warrior"]["desc"] = DPSMate.L["warlockdesc"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["rogue"]["name"] = DPSMate.L["rogue"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["rogue"]["desc"] = DPSMate.L["roguedesc"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["priest"]["name"] = DPSMate.L["priest"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["priest"]["desc"] = DPSMate.L["priestdesc"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["hunter"]["name"] = DPSMate.L["hunter"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["hunter"]["desc"] = DPSMate.L["hunterdesc"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["druid"]["name"] = DPSMate.L["druid"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["druid"]["desc"] = DPSMate.L["druiddesc"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["mage"]["name"] = DPSMate.L["mage"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["mage"]["desc"] = DPSMate.L["magedesc"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["warlock"]["name"] = DPSMate.L["warlock"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["warlock"]["desc"] = DPSMate.L["warlockdesc"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["paladin"]["name"] = DPSMate.L["paladin"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["paladin"]["desc"] = DPSMate.L["paladindesc"]
	DPSMate.Options.Options[5]["args"]["people"]["name"] = DPSMate.L["certainnames"]
	DPSMate.Options.Options[5]["args"]["people"]["desc"] = DPSMate.L["certainnamesdesc"]
	DPSMate.Options.Options[5]["args"]["group"]["name"] = DPSMate.L["grouponly"]
	DPSMate.Options.Options[5]["args"]["group"]["desc"] = DPSMate.L["grouponlydesc"]
end