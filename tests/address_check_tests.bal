import ballerina/io;
import ballerina/http;
import ballerina/test;

http:Client testClient = check new ("http://localhost:3000");

@test:BeforeGroups { value:["address_check"] }
function before_address_check_test() {
    io:println("Starting the address check tests");
}

@test:Config { groups: ["address_check"] }
function testServiceForTalliedAddress() {
    json payload = { "nic": "123456789V", "address": "123, Sample Street" };
    http:Response response = checkpanic testClient->post("/addressCheck", payload);
    test:assertEquals(response.statusCode, 200);
    json result = checkpanic response.getJsonPayload();
    json expected = { "status": 2, "description": "Address is checked!" };
    test:assertEquals(result, expected);
}   

@test:Config { groups: ["address_check"] }
function testServiceForInvalidAddress() {
    json payload = { "nic": "123456789V", "address": "No. 4, Random Road, Some District, Sri Lanka." };
    http:Response response = checkpanic testClient->post("/addressCheck", payload);
    test:assertEquals(response.statusCode, 200);
    json result = checkpanic response.getJsonPayload();
    json expected = { "status": 1, "description": "Address is not tallied!" };
    test:assertEquals(result, expected);
}   

@test:Config { groups: ["address_check"] }
function testServiceForInvalidNIC() {
    json payload = { "nic": "12345678", "address": "No. 4, Random Road, Some District, Sri Lanka." };
    http:Response response = checkpanic testClient->post("/addressCheck", payload);
    test:assertEquals(response.statusCode, 200);
    json result = checkpanic response.getJsonPayload();
    json expected = { "status": 4, "description": "Invalid NIC" };
    test:assertEquals(result, expected);
}  

@test:AfterGroups { value:["address_check"] }
function after_address_check_test() {
    io:println("Completed the address check tests");
}