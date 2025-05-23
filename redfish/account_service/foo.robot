*** Settings ***
Documentation    Test Redfish user account.

Resource         ../../lib/resource.robot
Resource         ../../lib/bmc_redfish_resource.robot
Resource         ../../lib/openbmc_ffdc.robot
Resource         ../../lib/bmc_redfish_utils.robot

Library          SSHLibrary

Test Setup       Redfish.Login
Test Teardown    Test Teardown Execution

*** Variables ***

${account_lockout_duration}   ${30}
${account_lockout_threshold}  ${3}

${ssh_status}                 ${True}

** Test Cases **

Verify AccountService Available
    [Documentation]  Verify Redfish account service is available.
    [Tags]  Verify_AccountService_Available

    ${resp} =  Redfish_utils.Get Attribute  /redfish/v1/AccountService  ServiceEnabled
    Should Be Equal As Strings  ${resp}  ${True}


Verify SSH Login Access With Admin User
    [Documentation]  Verify that admin user have SSH login access.
    ...              By default, admin should have access but there could be
    ...              case where admin user shell access is restricted by design
    ...              in the community sphere..
    [Tags]  Verify_SSH_Login_Access_With_Admin_User

    # Create an admin User.
    Redfish Create User  new_admin  TestPwd1  Administrator  ${True}

    # Attempt SSH login with admin user.
    SSHLibrary.Open Connection  ${OPENBMC_HOST}  port=${SSH_PORT}
    ${status}=  Run Keyword And Return Status  SSHLibrary.Login  new_admin  TestPwd1

    # By default ssh_status is True, user can change the status via CLI
    # -v ssh_status:False
    Should Be Equal As Strings  "${status}"  "${ssh_status}"

    Redfish.Login
    Redfish.Delete  /redfish/v1/AccountService/Accounts/new_admin
