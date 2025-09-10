indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.mainBlockContent = document.getElementById("main-block-content")
    global.gridjsFrame = document.getElementById("gridjs-frame")
    global.serversearchVpnInput = document.getElementById("serversearch-vpn-input")
    global.serversearchFirstnameInput = document.getElementById("serversearch-firstname-input")
    global.serversearchSurenameInput = document.getElementById("serversearch-surename-input")
    global.serversearchPostcodeInput = document.getElementById("serversearch-postcode-input")
    global.serversearchLocationInput = document.getElementById("serversearch-location-input")
    global.serversearchExpertiseInput = document.getElementById("serversearch-expertise-input")
    global.serversearchErrorFeedback = document.getElementById("serversearch-error-feedback")
    global.resetButton = document.getElementById("reset-button")
    global.serversearchButton = document.getElementById("serversearch-button")
    return
    
module.exports = indexdomconnect