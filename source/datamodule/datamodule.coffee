############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("datamodule")
#endregion

############################################################
import { requestDataListURL, dataLoadPageSize } from "./configmodule.js"

############################################################
import *  as S from "./statemodule.js"

############################################################
currentData = []

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

    URL = requestDataListURL

    try
        allData = []
        page_size = dataLoadPageSize
        
        page = 1
        receivedCount = 0
        
        loop
            requestData = { study_date, patient_name, patient_firstname, patient_ssn, patient_dob, study_description, page, page_size }
            rawData = await postRequest(URL, requestData)

            allData.push(rawData.providers) if Array.isArray(rawData.providers)
            receivedCount += rawData.count
            
            # if rawData.count <  page_size then break
            break
            
            page++
        # console.log(allData)
        return allData.flat()
    catch err then throw err

############################################################
export getCurrentData = -> currentData

export triggerSearch = (searchData) ->
    currentData = retrieveCurrentData(searchData)
    return

export resetData = ->
    currentData = []
    return
