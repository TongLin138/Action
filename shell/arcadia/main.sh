#!/bin/bash
## Modified: 2023-05-23

## 判定命令
case $# in
0)
    import core/help
    Help $ContrlCmd
    ;;
1)
    Output_Command_Error 1 # 命令错误
    ;;
2)
    case $1 in
    service)
        case $2 in
        start | stop | info | respwd)
            import arcadia/service
            Service_Control $2
            ;;
        *)
            Output_Command_Error 1 # 命令错误
            ;;
        esac
        ;;
    tgbot)
        case $2 in
        start | stop | logs | update)
            import arcadia/tgbot
            TGBot_Control $2
            ;;
        *)
            Output_Command_Error 1 # 命令错误
            ;;
        esac
        ;;
    server)
        case $2 in
        status)
            import arcadia/service
            Server_Status
            ;;
        *)
            Output_Command_Error 1 # 命令错误
            ;;
        esac
        ;;
    env)
        case $2 in
        install | repairs)
            import arcadia/env
            Environment_Deployment $2
            ;;
        *)
            Output_Command_Error 1 # 命令错误
            ;;
        esac
        ;;
    check)
        case $2 in
        files)
            import arcadia/env
            Check_Files
            ;;
        *)
            Output_Command_Error 1 # 命令错误
            ;;
        esac
        ;;
    *)
        Output_Command_Error 1 # 命令错误
        ;;
    esac
    ;;
*)
    case $1 in
    repo)
        import arcadia/repo
        Add_Repo "$@"
        ;;
    raw)
        import arcadia/raw
        Add_Raw "$@"
        ;;
    *)
        Output_Command_Error 2 # 命令过多
        ;;
    esac
    ;;
esac
