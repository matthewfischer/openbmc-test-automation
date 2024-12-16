*** Settings ***

Documentation          Keywords for KCS and Lanplus interface command.

Resource               ../lib/ipmi_client.robot
Resource               ../lib/state_manager.robot
Resource               ../lib/common_utils.robot
Variables              ../data/ipmi_raw_cmd_table.py
Library                ../lib/ipmi_utils.py


*** Keywords ***

Verify KCS Interface Commands
    [Documentation]  Execute set of IPMI raw KCS interface commands and verify it is
    ...  executable from os host. Set of IPMI raw commands includes system interface
    ...  command.

    #### raw cmd for get SDR Info.
    Run Inband IPMI Raw Command  ${IPMI_RAW_CMD['SDR_Info']['get'][0]}

    #### raw cmd for get Chassis status.
    Run Inband IPMI Raw Command  ${IPMI_RAW_CMD['Chassis_status']['get'][0]}

    #### raw cmd for get SEL INFO.
    Run Inband IPMI Raw Command  ${IPMI_RAW_CMD['SEL_Info']['get'][0]}

Verify Lanplus Interface Commands
    [Documentation]  Execute set of IPMI raw Command via lanplus interface and
    ...  verify it is executable from remote server. Set of IPMI raw commands
    ...  includes system interface command which should not execute via lanplus
    ...  interface.

    ## Executing system interface command on lanplus interface.
    #### raw cmd for get SDR Info.
    Run External IPMI Raw Command  ${IPMI_RAW_CMD['SDR_Info']['get'][0]}

    #### raw cmd for get Chassis status.
    Run External IPMI Raw Command  ${IPMI_RAW_CMD['Chassis_status']['get'][0]}

    #### raw cmd for get SEL INFO.
    Run External IPMI Raw Command  ${IPMI_RAW_CMD['SEL_Info']['get'][0]}
