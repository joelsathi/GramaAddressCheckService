public type User record {|
    string nic;
    string address;
|};

public type StatusEntry record {|
    string nic;
    int policeCheckStatus;
    int idCheckStatus;
    int addressCheckStatus;

|};