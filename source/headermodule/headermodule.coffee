############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("headermodule")
#endregion

############################################################
import * as S from "./statemodule.js"
import { getStats } from "./datamodule.js"

############################################################
headerTitle = document.getElementById("header-title")

############################################################
titleTextBase = ""
titleTextReleaseDate = ""

############################################################
export initialize = ->
    log "initialize"
    # settingsButton.addEventListener("click", settingsButtonClicked)
    # titleTextBase = headerTitle.textContent
    titleTextReleaseDate = S.load("titleTextReleaseDate")
    headerTitle.textContent =  titleTextReleaseDate

    await updateHeader()
    return

settingsButtonClicked = ->
    log "settingsButtonClicked"
    settingsButton.classList.add("on")
    document.body.classList.add("settings")
    return

export updateHeader = ->
    log "updateHeader"
    try 
        stats = await getStats()
        olog stats
        log titleTextBase
        log stats.releaseDate
        releaseDate = new Date(stats.releaseDate)
        month = releaseDate.getMonth() + 1
        year = releaseDate.getFullYear()
        titleTextReleaseDate = month+"/"+year
        S.save("titleTextReleaseDate", titleTextReleaseDate)

        headerTitle.textContent = titleTextBase + " " + titleTextReleaseDate
    catch err then log "Could not request stats for header!\n" + err.message
