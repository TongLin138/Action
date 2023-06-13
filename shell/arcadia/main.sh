#!/bin/bash
## Modified: 2023-06-13

function main() {
    case $# in
    0)
        import core/help
        print_help $ContrlCmd
        ;;
    *)
        case $1 in
        repo)
            import arcadia/repo
            shift
            add_repo_conf "$@"
            ;;
        raw)
            import arcadia/raw
            shift
            add_raw_conf "$@"
            ;;
        *)
            case $# in
            1)
                case $1 in
                dev)
                    import arcadia/dev
                    change_dev_version
                    ;;
                *)
                    output_command_error 1 # 命令错误
                    ;;
                esac
                ;;
            2)
                case $1 in
                service)
                    case $2 in
                    start | restart | stop | info | respwd)
                        import arcadia/service
                        main_service_manage $2
                        ;;
                    *)
                        output_command_error 1 # 命令错误
                        ;;
                    esac
                    ;;
                tgbot)
                    case $2 in
                    start | restart | stop | logs | update)
                        import arcadia/tgbot
                        tgbot_manage $2
                        ;;
                    *)
                        output_command_error 1 # 命令错误
                        ;;
                    esac
                    ;;
                server)
                    case $2 in
                    status)
                        import arcadia/service
                        server_status
                        ;;
                    *)
                        output_command_error 1 # 命令错误
                        ;;
                    esac
                    ;;
                env)
                    case $2 in
                    install | repairs)
                        import arcadia/env
                        environment_package $2
                        ;;
                    *)
                        output_command_error 1 # 命令错误
                        ;;
                    esac
                    ;;
                check)
                    case $2 in
                    config)
                        import arcadia/env
                        check_conf_files
                        ;;
                    *)
                        output_command_error 1 # 命令错误
                        ;;
                    esac
                    ;;
                *)
                    output_command_error 1 # 命令错误
                    ;;
                esac
                ;;
            *)
                output_command_error 2 # 命令过多
                ;;
            esac
            ;;
        esac
        ;;
    esac
}

main "$@"
