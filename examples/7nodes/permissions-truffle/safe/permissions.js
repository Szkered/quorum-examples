var Permissions = artifacts.require("./Permissions.sol")

var perm;
var foundEvent = "NO";
var eventName = "";
var nodeId = 0;

Permissions.deployed().then(function(instance) {
// 	console.log(instance);
	perm = instance;
	return perm.AddNode("ac6b1096ca56b9f6d004b779ae3728bf83f8e22453404cc3cef16a3d9b96608bc67c4b30db88e0a5a6c6390213f7acbe1153ff6d23ce57380104288ae19373ef","true", "true");
}).then (function(result) {
	//console.log(result.logs);
	for (var i = 0; i < result.logs.length; i++) {
    		var log = result.logs[i];
		//console.log(log);

    		if (log.event == "NewNodeAdded") {
			// We found the event!
			foundEvent = "YES";
			eventName = log.event;
			nodeId = log.args._nodeId;
			break;
		}

	}
	if (foundEvent == "YES"){
		console.log("Yes. detected the event!!!!!" + eventName + "---" + nodeId);
	} else {
		console.log("No.Did not find the event !!!!!!");

	}
//	return perm.AddNode("0ba6b9f606a43a95edc6247cdb1c1e105145817be7bcafd6b2c0ba15d58145f0dc1a194f70ba73cd6f4cdd6864edc7687f311254c7555cc32e4d45aeb1b80416","true", "true");
//}).then (function(result) {
	//console.log(result.logs);
//	for (var i = 0; i < result.logs.length; i++) {
//    		var log = result.logs[i];
		//console.log(log);

//    		if (log.event == "NewNodeAdded") {
			// We found the event!
			foundEvent = "YES";
			eventName = log.event;
			nodeId = log.args._nodeId;
			break;
		}

	}
	if (foundEvent == "YES"){
		console.log("Yes. detected the event!!!!!" + eventName + '-----' + nodeId);
	} else {
		console.log("No.Did not find the event !!!!!!");

	}
	return perm.AddNode("ac6b1096ca56b9f6d004b779ae3728bf83f8e22453404cc3cef16a3d9b96608bc67c4b30db88e0a5a6c6390213f7acbe1153ff6d23ce57380104288ae19373ef","true", "true");
}).then (function(result) {
	//console.log(result.logs);
	for (var i = 0; i < result.logs.length; i++) {
    		var log = result.logs[i];
		//console.log(log);

    		if (log.event == "NodeAlreadyExists") {
			// We found the event!
			foundEvent = "YES";
			eventName = log.event;
			break;
		}

	}
	if (foundEvent == "YES"){
		console.log("Yes. detected duplciate!!!!!" + eventName);
	} else {
		console.log("No.Did not detect duplicate !!!!!!");

	}
	return perm.DeactivateNode("ac6b1096ca56b9f6d004b779ae3728bf83f8e22453404cc3cef16a3d9b96608bc67c4b30db88e0a5a6c6390213f7acbe1153ff6d23ce57380104288ae19373ef");
}).then (function(result) {
	//console.log(result.logs);
	for (var i = 0; i < result.logs.length; i++) {
    		var log = result.logs[i];
		//console.log(log);

    		if (log.event == "NodeDeactivated") {
			// We found the event!
			foundEvent = "YES";
			eventName = log.event;
			break;
		}

	}
	if (foundEvent == "YES"){
		console.log("Yes. Node Deactivated!!!!!" + eventName);
	} else {
		console.log("No.Deactivation failed !!!!!!");

	}
	
}).catch(function(e){
	console.log("Error !!!!!!")
})
