pragma solidity ^0.4.0;

contract Permissions {
    struct nodeDetails {
        string enodeId;
        bool canWrite;
        bool canLead;
        bool active;
    }
    uint nodeNum;
    mapping (uint => nodeDetails) nodelist;

    event NewNodeAdded (uint _nodeId, string _enodeId, bool _canWrite, bool _canLead);
    event NodeAlreadyExists (string _enodeId);
    event NodeDeactivated (string _enodeId);

    constructor() public {
    nodeNum = 0;
    }
	// Checks if the Node is already added. If yes then returns true    
    function checkExistingNode (string _enodeId) public  returns (bool _ret){

		_ret = false;
        
        for (uint i=0; i<= nodeNum; i++){
            if (keccak256(nodelist[i].enodeId) == keccak256(_enodeId) ){
                _ret =  true;
                break;
            }
        }
		if (_ret == true){
    		emit NodeAlreadyExists(_enodeId);
		}
        return _ret;
    }
  
	// Adds a node to the nodelist mapping and emits node added event if successfully and node exists event of node is already present
    function AddNode(string _enodeId, bool _canWrite, bool _canLead) public returns (uint _nodeId){
        bool result = false;
        result = checkExistingNode(_enodeId);
        if (result == true){
            emit NodeAlreadyExists(_enodeId);
			return nodeNum;
        }
		else {

			nodeNum ++;
			_nodeId = nodeNum;
			nodelist[_nodeId] = nodeDetails(_enodeId, _canWrite, _canLead, true);
			emit NewNodeAdded (_nodeId, _enodeId, _canWrite, _canLead);
			return _nodeId;
		}
    }
	//deactivates a given Enode and emits the decativation event
	function DeactivateNode (string _enodeId)  public {

		for (uint i=0; i<= nodeNum; i++){
            if (keccak256(nodelist[i].enodeId) == keccak256(_enodeId) ){
                break;
            }
        }

		nodelist[i].active = false;
		emit NodeDeactivated(_enodeId);

	}

}
