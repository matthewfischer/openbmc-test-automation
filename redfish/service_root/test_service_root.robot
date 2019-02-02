*** Settings ***
Resource         ../../lib/resource.txt
Resource         ../../lib/bmc_redfish_resource.robot

*** Test Cases ***

Redfish Login And Logout
    [Documentation]  Login to BMCweb and then logout.
    [Tags]  Redfish_Login_And_Logout

    redfish.Login
    redfish.Logout


GET Redfish Hypermedia Without Login
    [Documentation]  GET hypermedia URL without login.
    [Tags]  GET_Redfish_Hypermedia_Without_Login
    [Template]  GET And Verify Redfish Response

    # Expect status      Resource URL Path
    ${HTTP_OK}           /
    ${HTTP_OK}           /redfish
    ${HTTP_OK}           /redfish/v1


GET Redfish SessionService Resource With Login
    [Documentation]  Login to BMCweb and get /redfish/v1/SessionService.
    [Tags]  GET_Redfish_SessionService_Resource_With_Login

    redfish.Login
    ${resp}=  redfish.Get  /redfish/v1/SessionService
    Should Be Equal As Strings  ${resp.status}  ${HTTP_OK}
    redfish.Logout


GET Redfish SessionService Without Login
    [Documentation]  Get /redfish/v1/SessionService without login
    [Tags]  GET_Redfish_SessionService_Without_Login

    ${resp}=  redfish.Get  /redfish/v1/SessionService
    Should Be Equal As Strings  ${resp.status}  ${HTTP_UNAUTHORIZED}


Redfish Login Using Invalid Token
    [Documentation]  Login to BMCweb with invalid token.
    [Tags]  Redfish_Login_Using_Invalid_Token

    Create Session  openbmc  ${AUTH_URI}

    # Example: "X-Auth-Token: 3la1JUf1vY4yN2dNOwun"
    ${headers}=  Create Dictionary  Content-Type=application/json
    ...  X-Auth-Token=deadbeef

    ${resp}=  Get Request
    ...  openbmc  /redfish/v1/SessionService/Sessions  headers=${headers}

    Should Be Equal As Strings  ${resp.status_code}  ${HTTP_UNAUTHORIZED}


Delete Redfish Session Using Valid login
    [Documentation]  Delete a session using valid login.
    [Tags]  Delete_Redfish_Session_Using_Valid_Login

    redfish.Login

    # Example o/p:
    # [{'@odata.id': '/redfish/v1/SessionService/Sessions/bOol3WlCI8'},
    #  {'@odata.id': '/redfish/v1/SessionService/Sessions/Yu3xFqjZr1'}]
    ${resp_list}=  redfish.List Request  SessionService/Sessions
    redfish.Delete  ${resp_list[1]}

    ${resp}=  redfish.List Request  SessionService/Sessions
    List Should Not Contain Value  ${resp}  ${resp_list[1]}


*** Keywords ***

GET And Verify Redfish Response
    [Documentation]  GET given resource and verfiy response.
    [Arguments]  ${expected_response_code}  ${resource_path}

    # Description of arguments:
    # expected_response_code   Expected REST status codes.
    # resource_path            Redfish resource URL path.

    ${resp}=  redfish.Get  ${resource_path}
    Should Be Equal As Strings  ${resp.status}  ${expected_response_code}
