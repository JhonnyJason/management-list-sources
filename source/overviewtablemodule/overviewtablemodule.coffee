############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("overviewtablemodule")
#endregion

############################################################
import { Grid } from "gridjs"

############################################################
import * as S from "./statemodule.js"
import * as utl from "./tableutils.js"
import * as dataModule from "./datamodule.js"

############################################################
tableObj = null
currentTableHeight = 0

############################################################
rootStyle = null

############################################################
export initialize = ->
    log "initialize"         
    window.addEventListener("resize", updateTableHeight)
    rootObj = document.querySelector(':root')
    rootStyle = rootObj.style
    setDefaultState()
    return

############################################################
renderTable = (dataPromise) ->
    log "renderTable"

    columns = utl.getColumnsObject()

    if Array.isArray(dataPromise) then data = dataPromise
    else data = -> dataPromise

    language = utl.getLanguageObject()
    search = false
    pagination = { limit: 50 }
    sort = true
    fixedHeader = true
    resizable = false
    autoWidth = false

    gridJSOptions = { columns, data, language, search, pagination, sort, fixedHeader, resizable, autoWidth }

    height = "#{utl.getTableHeight()}px"
    rootStyle.setProperty("--table-max-height", height)



    log "create Table Object and render"
    if tableObj?
        tableObj = null
        gridjsFrame.innerHTML = ""  
        tableObj = new Grid(gridJSOptions)
        await tableObj.render(gridjsFrame).forceRender()
        # render alone does not work here - it seems the Old State still remains in the GridJS singleton thus a render here does not refresh the table at all
    else
        tableObj = new Grid(gridJSOptions)
        gridjsFrame.innerHTML = ""    
        await tableObj.render(gridjsFrame)

    return

############################################################
updateTableHeight = (height) ->
    log "updateTableHeight"
    olog { height }

    if typeof height != "number" then height = utl.getTableHeight()
    if currentTableHeight == height then return
    currentTableHeight = height 
    height = height+"px"
    rootStyle.setProperty("--table-max-height", height)
    
    return


############################################################
export refresh = ->
    log "refresh"
    setDefaultState()
    return 

############################################################
export setDefaultState = ->
    log "setDefaultState"
    dataPromise = dataModule.getCurrentData()
    renderTable(dataPromise)
    return
