############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("headermodule")
#endregion

############################################################
import * as S from "./statemodule.js"

############################################################
export initialize = ->
    log "initialize"
    return