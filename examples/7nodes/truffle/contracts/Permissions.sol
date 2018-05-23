pragma solidity ^0.4.23;

contract Permissions {

  enum NodeStatus { PendingApproval, Approved, PendingDeactivation, Deactivated, NotInList }
  struct nodeDetails {
    string enodeId;
    bool canWrite;
    bool canLead;
    NodeStatus status;
  }


  NodeStatus nodeStatus;

  uint globalNodeIndex;
  uint proposedNodeNum;
  mapping (uint => nodeDetails) nodelist;

  event NewNodeProposed (uint _nodeIndex, string _enodeId, bool _canWrite, bool _canLead);
  event NodeExists (string _enodeId);
  event NodeApproved(string _enodeId);
  event NothingToApprove(string _enodeId);
  event NodeDeactivated (string _enodeId);
  event NodePendingDeactivation (string _enodeId);
  event InvalidNodeId (string _endoeId);
  event OperationNotAllowed(string _enodeId);

  constructor() public {
    globalNodeIndex = 0;
  }
  // Checks if the Node is already added. If yes then returns true
  function checkIfNodeExists (string _enodeId) internal view  returns (NodeStatus _status, uint _nodeIndex){

    _status = NodeStatus.NotInList;
    _nodeIndex = 0;

    for (uint i=0; i<= globalNodeIndex; i++){
      if (keccak256(nodelist[i].enodeId) == keccak256(_enodeId) ){
        _status =  nodelist[i].status;
        _nodeIndex = i;
        break;
      }
    }
    return (_status, _nodeIndex);
  }

  function getNodeIndexForNode (string _enodeId) public view returns (uint _nodeIndex){
    for (uint i=0; i<= globalNodeIndex; i++){
      if (keccak256(nodelist[i].enodeId) == keccak256(_enodeId) ){
        _nodeIndex = i;
        break;
      }
    }
    return _nodeIndex;
  }

  function getNodeIndex () public view returns (uint _globalNodeIndex){
    _globalNodeIndex = globalNodeIndex;
    return _globalNodeIndex;
  }


  // Adds a node to the nodelist mapping and emits node added event if successfully and node exists event of node is already present
  function ApproveNode(string _enodeId) public returns (uint _nodeIndex){

    NodeStatus status = NodeStatus.NotInList;
    (status, _nodeIndex) = checkIfNodeExists(_enodeId);

    if (nodelist[_nodeIndex].status == NodeStatus.Approved){
      emit NothingToApprove(_enodeId);
    }
    else {
      nodelist[_nodeIndex].status = NodeStatus.Approved;
      emit NodeApproved(_enodeId);
    }
    return _nodeIndex;
  }

  //deactivates a given Enode and emits the decativation event
  function DeactivateNode (string _enodeId)  public {
    uint nodeIndex = 0;
    NodeStatus status = NodeStatus.NotInList;
    (status, nodeIndex) = checkIfNodeExists(_enodeId);

    if (status == NodeStatus.PendingDeactivation) {

      nodelist[nodeIndex].status = NodeStatus.Deactivated;
      emit NodeDeactivated(_enodeId);
    }
    else {
      emit OperationNotAllowed(_enodeId);
    }

  }

  function ProposeNode(string _enodeId, bool _canWrite, bool _canLead) public returns (uint _nodeIndex){
    NodeStatus status = NodeStatus.NotInList;
    (status, _nodeIndex) = checkIfNodeExists(_enodeId);

    if (status == NodeStatus.NotInList){
      globalNodeIndex ++;
      _nodeIndex = globalNodeIndex;
      nodelist[_nodeIndex] = nodeDetails(_enodeId, _canWrite, _canLead, NodeStatus.PendingApproval);
      emit NewNodeProposed (_nodeIndex, _enodeId, _canWrite, _canLead);
      return _nodeIndex;
    }
    else {
      emit NodeExists(_enodeId);
    }
    return _nodeIndex;
  }

  function ProposeDeactivation(string _enodeId) public {

    uint nodeIndex = 0;

    NodeStatus status = NodeStatus.NotInList;
    (status, nodeIndex) = checkIfNodeExists(_enodeId);


    if (status != NodeStatus.NotInList ){
      emit InvalidNodeId(_enodeId);
    }

    if (status == NodeStatus.Approved){
      nodelist[nodeIndex].status = NodeStatus.PendingDeactivation;
      emit NodePendingDeactivation(_enodeId);
    }
    else {
      emit OperationNotAllowed(_enodeId);
    }
  }

}
