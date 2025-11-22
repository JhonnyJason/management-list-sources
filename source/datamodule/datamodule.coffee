############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("datamodule")
#endregion

############################################################
import { 
    urlRequestDataList, urlRequestSummary, dataLoadPageSize
} from "./configmodule.js"

############################################################
import *  as S from "./statemodule.js"

############################################################
summary = null
currentData = []

############################################################
summaryRequestPeriodMS = 5000

############################################################
export initialize = (c) ->
    log "initialize"
    if c.summaryRequestPeriodMS? 
        summaryRequestPeriodMS = c.summaryRequestPeriodMS

    # setInterval(summaryRequest, summaryRequestPeriodMS)
    summaryRequest()
    return

############################################################
summaryRequest = ->
    log "summaryRequest"
    # dataRequest
    # url = urlRequestDataList
    # try list = await postRequest(url)
    # catch err then console.error(err)
    # olog { list }
    # return

    url = urlRequestSummary
    try summary = await postRequest(url)
    catch err then console.error(err)
    olog { summary }
    return

############################################################
postRequest = (url, data) ->
    options =
        method: 'POST'
        mode: 'cors'
        credentials: 'include'
    
        body: JSON.stringify(data)
        headers:
            'Content-Type': 'application/json'

    try
        response = await fetch(url, options)
        if !response.ok then throw new Error("Response not ok - status: #{response.status}!")
        if response.status == 204 then return null
        return response.json()
    catch err then throw new Error("Network Error: "+err.message)

getData = (url) ->
    options =
        method: 'GET'
        mode: 'cors'
        credentials: 'include'
    
    try
        response = await fetch(url, options)
        if !response.ok then throw new Error("Response not ok - status: #{response.status}!")
        return response.json()
    catch err then throw new Error("Network Error: "+err.message)

############################################################
retrieveCurrentData = (searchData) ->
    { study_date, patient_name, patient_firstname, patient_ssn, patient_dob, study_description } = searchData

    url = urlRequestDataList

    try
        allData = []
        page_size = dataLoadPageSize
        
        page = 1
        receivedCount = 0
        
        loop
            requestData = { study_date, patient_name, patient_firstname, patient_ssn, patient_dob, study_description, page, page_size }
            rawData = await postRequest(url, requestData)

            allData.push(rawData.providers) if Array.isArray(rawData.providers)
            receivedCount += rawData.count
            
            # if rawData.count <  page_size then break
            break
            
            page++
        # console.log(allData)
        return allData.flat()
    catch err then throw err

############################################################
export getSummary = -> summary
export getCurrentData = -> currentData

export triggerSearch = (searchData) ->
    currentData = retrieveCurrentData(searchData)
    return

export resetData = ->
    currentData = []
    return
