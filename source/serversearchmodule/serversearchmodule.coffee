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

    serversearchStudyDateInput.value = ""
    serversearchSurenameInput.value = "" 
    serversearchFirstnameInput.value = "" 
    serversearchSsnInput.value = "" 
    serversearchDobInput.value = ""
    serversearchDescriptionInput.value = "" 
    serversearchReferrerInput.value = "" 
    
    serversearchErrorFeedback.innerHTML = ""
    data.resetData()
    refresh()
    return


searchButtonClicked = (evnt) ->
    log "searchButtonClicked"

    study_date = serversearchStudyDateInput.value
    patient_name = serversearchSurenameInput.value
    patient_firstname = serversearchFirstnameInput.value
    patient_ssn = serversearchSsnInput.value
    patient_dob = serversearchDobInput.value
    study_description = serversearchDescriptionInput.value
    referrer_fullname = serversearchReferrerInput.value

    # isExact = serversearchExactInput.checked

    # set undefined what is empty
    if study_date.length == 0 then study_date = undefined
    if patient_name.length == 0 then patient_name = undefined 
    if patient_firstname.length == 0 then patient_firstname = undefined 
    if patient_ssn.length == 0 then patient_ssn = undefined 
    if patient_dob.length == 0 then patient_dob = undefined 
    if study_description.length == 0 then study_description = undefined 
    if referrer_fullname.length == 0 then referrer_fullname = undefined 

    searchData = { study_date, patient_name, patient_firstname, patient_ssn, patient_dob, study_description }
    
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
