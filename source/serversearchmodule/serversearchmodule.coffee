############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("serversearchmodule")
#endregion

############################################################
import * as data from "./datamodule.js"
import { refresh } from "./overviewtablemodule.js"

############################################################
export initialize = ->
    log "initialize"
    resetButton.addEventListener("click", resetButtonClicked)
    serversearchButton.addEventListener("click", searchButtonClicked)
    document.addEventListener("keydown", documentKeyDowned)
    return

############################################################
documentKeyDowned = (evnt) ->
    log "documentKeyDowned"
    keyCode = evnt.keyCode || evnt.which
    if (keyCode? and keyCode == 13) or (evnt.key == "Enter")
        searchButtonClicked(evnt)
    return

resetButtonClicked = (evnt) ->
    serversearchVpnInput.value = ""
    serversearchFirstnameInput.value = ""
    serversearchSurenameInput.value = ""
    serversearchLocationInput.value = ""
    serversearchPostcodeInput.value = ""
    serversearchExpertiseInput.value = ""
    
    serversearchErrorFeedback.innerHTML = ""
    data.resetData()
    refresh()
    return


searchButtonClicked = (evnt) ->
    log "searchButtonClicked"
    vpn = serversearchVpnInput.value
    first_name = serversearchFirstnameInput.value
    last_name = serversearchSurenameInput.value
    city = serversearchLocationInput.value
    zip = serversearchPostcodeInput.value
    expertise_id = serversearchExpertiseInput.value

    # isExact = serversearchExactInput.checked

    # set undefined what is empty
    if vpn.length == 0 then  vpn = undefined
    if first_name.length == 0 then first_name = undefined 
    if last_name.length == 0 then last_name = undefined 
    if city.length == 0 then city = undefined 
    if zip.length == 0 then zip = undefined 
    if expertise_id.length == 0 then expertise_id = undefined 


    searchData = { vpn, first_name, last_name, city, zip, expertise_id }
    olog searchData

    data.triggerSearch(searchData)
    refresh()

    serversearchErrorFeedback.innerHTML = ""
    serversearchButton.disabled = true
    
    try await data.getCurrentData()
    catch err
        errorFeedback = "Fehler bei der Datenabfrage: #{err.message}"
        log errorFeedback
        serversearchErrorFeedback.innerText = errorFeedback
    finally serversearchButton.disabled = false
    
    return
