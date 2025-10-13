indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.mainBlockContent = document.getElementById("main-block-content")
    global.gridjsFrame = document.getElementById("gridjs-frame")
    global.serversearchErrorFeedback = document.getElementById("serversearch-error-feedback")
    global.serversearchStudyDateInput = document.getElementById("serversearch-study-date-input")
    global.serversearchSurenameInput = document.getElementById("serversearch-surename-input")
    global.serversearchFirstnameInput = document.getElementById("serversearch-firstname-input")
    global.serversearchSsnInput = document.getElementById("serversearch-ssn-input")
    global.serversearchDobInput = document.getElementById("serversearch-dob-input")
    global.serversearchDescriptionInput = document.getElementById("serversearch-description-input")
    global.serversearchReferrerInput = document.getElementById("serversearch-referrer-input")
    global.resetButton = document.getElementById("reset-button")
    global.serversearchButton = document.getElementById("serversearch-button")
    return
    
module.exports = indexdomconnect