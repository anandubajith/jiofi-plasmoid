import QtQuick 2.0

Item {
  id:root
  width: 200
  height: 160
  property string batteryPercentage: ""
  property string noOfClients: ""
  property string signalStrength: ""
  property string chargeIcon: ""


  function parseBody(x){
    if (x.responseText) {
      // Couldn't parse the HTML , so using regex to extract the values
      var htmlBody = x.responseText;
      root.batteryPercentage = htmlBody.match(/<p id="batterylevel" value="(.*)">/)[1]
      root.noOfClients = htmlBody.match(/<p id="noOfClient" value="(.*)">/)[1]
      root.signalStrength =htmlBody.match(/<p id="signalstrength" value="(.*)">/)[1]
      var batteryStatus = htmlBody.match(/<p id="batterystatus" value="(.*)">/)[1]
      if ( batteryStatus == "Charging" ) {
        root.chargeIcon = " ⚡";
      }
    }
  }

  function request(url, callback) {
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = (function f() {parseBody(xhr)});
    xhr.open('GET', url, true);
    xhr.send();
  }

  Timer {
    running: true
    triggeredOnStart: true
    interval: 60000
    onTriggered: request("https://jiofi.free.beeceptor.com",callback)
  }

  Column{
    Text {
      text:"🔋"+ root.chargeIcon+ " : "+ root.batteryPercentage
      font.pointSize: 24
    }
    Text {
      text:"📱 : "+ root.noOfClients
      font.pointSize: 24
    }
    Text {
      text: "📶 : "+root.signalStrength
      font.pointSize: 24
    }
  }
}