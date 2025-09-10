############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("tableutils")
#endregion

############################################################
import { Grid, html} from "gridjs"

############################################################
import { expertiseMap } from "./datamodule.js"


############################################################
#region germanLanguage
deDE = {
    search: {
        placeholder: 'Suche...'
    }
    sort: {
        sortAsc: 'Spalte aufsteigend sortieren'
        sortDesc: 'Spalte absteigend sortieren'
    }
    pagination: {
        previous: 'Vorherige'
        next: 'Nächste'
        navigate: (page, pages) -> "Seite #{page} von #{pages}"
        page: (page) -> "Seite #{page}"
        showing: ' '
        of: 'von'
        to: '-'
        results: 'Daten'
    }
    loading: 'Wird geladen...'
    noRecordsFound: 'Keine übereinstimmenden Aufzeichnungen gefunden'
    error: 'Beim Abrufen der Daten ist ein Fehler aufgetreten'
}

#endregion

## datamodel default entry
# | VPN | DaMe | Vorname | Name | Straße | Ort | Postleitzahl | Kurativer Vertrag |

############################################################
#region cell formatter functions
vpnFormatter = (content, row) ->
    # if content? and content.length? and content.length > 0 and content[0].id? 
    #     return "#{content[0].id}"
    if content? and content.length? and content.length > 0        
        vpnsHTML = content.join("<br>")
        return html(vpnsHTML)
    return ""

daMeFormatter = (content, row) ->
    # if content? and content.length? and content.length > 0 and content[0].hv_uid?
    #     return content[0].hv_uid
    if content? and content.length? and content.length > 0
        dameIdsHTML = content.join("<br>")
        return html(dameIdsHTML)
    return ""

firstnameFormatter = (content, row) ->
    if content then return "#{content}"
    return ""

nameFormatter = (content, row) ->
    if content then return "#{content}"
    return ""

streetFormatter = (content, row) ->
    if content? and content.length? and content.length > 0
        streets = content.map((el) -> el.street)
        streetsHTML = streets.join("<br>")
        return html(streetsHTML)
    return ""

locationFormatter = (content, row) ->
    if content? and content.length? and content.length > 0 
        cities = content.map((el) -> el.city)
        citiesHTML = cities.join("<br>")
        return html(citiesHTML)
    return ""

postcodeFormatter = (content, row) ->
    if content? and content.length? and content.length > 0
        zipcodes = content.map((el) -> el.zip)
        zipHTML = zipcodes.join("<br>")
        return html(zipHTML)
    return ""

kurContractFormatter = (content, row) ->
    if content? and content.length? and content.length > 0
        kurContracts = content.map((el) -> if el.curative then "Ja" else "Nein")
        kurContractsHTML = kurContracts.join("<br>")
        return html(kurContractsHTML)
    return "Nein"

expertisesFormatter = (content, row) ->
    if content? and content.length? and content.length > 0
        expertises = new Uint32Array(content)
        expertises = expertises.sort()
        
        # Uint32Array.prototype.map does not work
        expertises = [...expertises] # -> Array.prototype.map
        expertises = expertises.map(createExpertiseWithTooltip)
        
        # expertisesHTML = expertises.join("<br>")
        expertisesHTML = expertises.join(", ")
        return html(expertisesHTML)
    # if content? and content.length? and content.length > 0 and content[0].code?
    #     expertiseFrameHTML = "<div class='expertise-frame'>"
    #     expertiseFrameHTML += "#{content[0].code}" 
    #     if content[0].description?
    #         expertiseFrameHTML += "<span class='tooltip'>#{content[0].description}</span>"
    #     expertiseFrameHTML += "</div>"
    #     return html(expertiseFrameHTML)
    return ""

createExpertiseWithTooltip = (el) ->
    # console.log(el)
    expertiseFrameHTML = "<span class='expertise-frame'>"
    expertiseFrameHTML += "#{el}" 
    if expertiseMap[el]?
        expertiseFrameHTML += "<span class='tooltip'>#{expertiseMap[el]}</span>"
    expertiseFrameHTML += "</span>"
    # console.log(expertiseFrameHTML)
    return expertiseFrameHTML


#endregion

############################################################
#region compare functions
localCompareOptions = {sensitivity: "base", numeric: true}

############################################################
vpnCompareFormatter = (content, row) ->
    if content? and content.length? and content.length > 0
        return "#{content[0]}"
    return ""

daMeCompareFormatter = (content, row) ->
    if content? and content.length? and content.length > 0
        return "#{content[0]}"
    return ""

############################################################
streetCompareFormatter = (content, row) ->
    if content? and content.length? and content.length > 0 and content[0].street? 
        return "#{content[0].street}"
    return ""

locationCompareFormatter = (content, row) ->
    if content? and content.length? and content.length > 0 and content[0].city? 
        return "#{content[0].city}"
    return ""

postcodeCompareFormatter = (content, row) ->
    if content? and content.length? and content.length > 0 and content[0].zip?
        return "#{content[0].zip}"
    return ""

kurContractCompareFormatter = (content, row) ->
    if content[0].curative then return "Ja"
    else return "Nein"

expertisesCompareFormatter = (content, row) ->
    if content? and content.length? and content.length > 0 and content[0].code?
        return "#{content[0].code}"
    return ""

############################################################
stringCompare = (el1, el2) ->
    el1String = "#{el1}"
    if !el1String then el1String = "zzzzzzzzzzzzzzzz"
    el2String = "#{el2}"
    if !el2String then el2String = "zzzzzzzzzzzzzzzz"
    return el1String.localeCompare(el2String, "de", localCompareOptions)

############################################################
vpnCompare = (el1, el2) ->
    el1String = vpnCompareFormatter(el1)
    el2String = vpnCompareFormatter(el2)
    return stringCompare(el1String, el2String)    

daMeCompare = (el1, el2) ->
    el1String = daMeCompareFormatter(el1)
    el2String = daMeCompareFormatter(el2)
    return stringCompare(el1String, el2String)    

firstnameCompare = (el1, el2) ->
    el1String = firstnameFormatter(el1)
    el2String = firstnameFormatter(el2)
    return stringCompare(el1String, el2String)    

nameCompare = (el1, el2) ->
    el1String = nameFormatter(el1)
    el2String = nameFormatter(el2)
    return stringCompare(el1String, el2String)    

streetCompare = (el1, el2) ->
    el1String = streetCompareFormatter(el1)
    el2String = streetCompareFormatter(el2)
    return stringCompare(el1String, el2String)    

locationCompare = (el1, el2) ->
    el1String = locationCompareFormatter(el1)
    el2String = locationCompareFormatter(el2)
    return stringCompare(el1String, el2String)    

postcodeCompare = (el1, el2) ->
    el1String = postcodeCompareFormatter(el1)
    el2String = postcodeCompareFormatter(el2)
    return stringCompare(el1String, el2String)    

kurContractCompare = (el1, el2) ->
    el1String = kurContractCompareFormatter(el1)
    el2String = kurContractCompareFormatter(el2)
    return stringCompare(el1String, el2String)    

expertisesCompare = (el1, el2) ->
    el1String = expertisesCompareFormatter(el1)
    el2String = expertisesCompareFormatter(el2)
    return stringCompare(el1String, el2String)    

#endregion

############################################################
#region exportedFunctions
export getTableHeight = ->
    # log "getTableHeight"

    # mainBlockContent = document.getElementById("main-block-content")
    # tableWrapper = document.getElementsByClassName("gridjs-wrapper")[0]
    gridJSFooter = document.getElementsByClassName("gridjs-footer")[0]
    
    fullHeight = window.innerHeight
    fullWidth = window.innerWidth
    

    
    outerPadding = 5

    nonTableOffset = 0
    # nonTableOffset += tableWrapper.offsetTop
    nonTableOffset += mainBlockContent.offsetTop
    nonTableOffset += outerPadding
    if gridJSFooter? then nonTableOffset += gridJSFooter.offsetHeight
    else nonTableOffset += 50
    log nonTableOffset

    tableHeight = fullHeight - nonTableOffset
    # olog {tableHeight, fullHeight, nonTableOffset, approvalHeight}

    olog {tableHeight}
    return tableHeight


############################################################
export getColumnsObject = ->

    ############################################################
    #region columnHeadObjects

    # indexHeadObj = {
    #     name: "",
    #     id: "index",
    #     sort: false,
    #     hidden: true
    # }

    ############################################################
    vpnHeadObj = {
        name: "VPN",
        id: "vpnList",
        autoWidth: true,
        formatter: vpnFormatter
        sort: {compare: vpnCompare}
            
    }

    ############################################################
    daMeHeadObj = {
        name: "DaMe Id",
        id: "dameIds",
        formatter: daMeFormatter
        sort: {compare: daMeCompare}
    }

    ############################################################
    firstnameHeadObj = {
        name: "Vorname",
        id: "first_name",
        formatter: firstnameFormatter
        sort: {compare: firstnameCompare}
    }

    ############################################################
    nameHeadObj = {
        name: "Name",
        id: "name",
        formatter: nameFormatter
        sort: {compare: nameCompare}
    }

    ############################################################
    streetHeadObj = {
        name: "Straße",
        id: "addresses",
        style: { 'white-space': 'nowrap' },
        formatter: streetFormatter
        sort: {compare: streetCompare}
    }

    ############################################################
    postcodeHeadObj = {
        name: "PLZ",
        id: "addresses",
        autoWidth: true,
        formatter: postcodeFormatter
        sort: {compare: postcodeCompare}
    }

    ############################################################
    locationHeadObj = {
        name: "Ort",
        id: "addresses",
        autoWidth: true,
        formatter: locationFormatter
        sort: {compare: locationCompare}
    }

    ############################################################
    kurContractHeadObj = {
        name: "Kur.V.",
        id: "addresses",
        autoWidth: true,
        formatter: kurContractFormatter
        sort: {compare: kurContractCompare}
    }

    ############################################################
    expertisesHeadObj = {
        name: "Expertise",
        id: "expertises",
        autoWidth: true,
        formatter: expertisesFormatter
        sort: {compare: expertisesCompare}
    }

    #endregion

    # if state == "shareToDoctor0" then return [checkboxHeadObj, indexHeadObj, screeningDateHeadObj, nameHeadObj, svnHeadObj, birthdayHeadObj, descriptionHeadObj, radiologistHeadObj, sendingDateHeadObj]

    return [vpnHeadObj, daMeHeadObj, firstnameHeadObj, nameHeadObj, streetHeadObj, postcodeHeadObj, locationHeadObj, kurContractHeadObj, expertisesHeadObj]

export getLanguageObject = -> deDE

#endregion
