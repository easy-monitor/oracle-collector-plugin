#!/bin/bash

if ! type getopt >/dev/null 2>&1 ; then
  echo "Error: command \"getopt\" is not found" >&2
  exit 1
fi

getopt_cmd=`getopt -o h -a -l help,oracle-host:,oracle-port:,oracle-user:,oracle-password:,oracle-sid:,oracle-service:,oracle-remote-collect:,exporter-host:,exporter-port: -n "start.sh" -- "$@"`
if [ $? -ne 0 ] ; then
    exit 1
fi
eval set -- "$getopt_cmd"

oracle_host="127.0.0.1"
oracle_port=1521
oracle_user=""
oracle_password=""
oracle_sid=""
oracle_service=""
oracle_remote_collect="false"

exporter_host="127.0.0.1"
exporter_port=9161

print_help() {
    echo "Usage:"
    echo "    start_script.sh [options]"
    echo "    start_script.sh --oracle-host 127.0.0.1 --oracle-port 1521 --oracle-user root [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help                    show help"
    echo "      --oracle-host             the address of oracle server (\"127.0.0.1\" by default)"
    echo "      --oracle-port             the port of oracle server (1521 by default)"
    echo "      --oracle-user             the user to log in to oracle server"
    echo "      --oracle-password         the password to log in to oracle server"
    echo "      --oracle-service          the service instance of oracle server"
    echo "      --oracle-sid              the sid  of oracle server"

    echo "      --oracle-remote-collect   whether use remote collect"

    echo "      --exporter-host        the listen address of exporter (\"127.0.0.1\" by default)"
    echo "      --exporter-port        the listen port of exporter (9161 by default)"
}

while true
do
    case "$1" in
        -h | --help)
            print_help
            shift 1
            exit 0
            ;;
        --oracle-host)
            case "$2" in
                "")
                    shift 2  
                    ;;
                *)
                    oracle_host="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --oracle-port)
            case "$2" in
                "")
                    shift 2  
                    ;;
                *)
                    oracle_port="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --oracle-user)
            case "$2" in
                "")
                    shift 2  
                    ;;
                *)
                    oracle_user="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --oracle-password)
            case "$2" in
                "")
                    shift 2  
                    ;;
                *)
                    oracle_password="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --oracle-sid)
            case "$2" in
                "")
                    shift 2
                    ;;
                *)
                    oracle_sid="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --oracle-service)
            case "$2" in
                "")
                    shift 2
                    ;;
                *)
                    oracle_service="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --oracle-remote-collect)
            case "$2" in
                "")
                    shift 2
                    ;;
                *)
                    oracle_remote_collect="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --exporter-host)
            case "$2" in
                "")
                    shift 2  
                    ;;
                *)
                    exporter_host="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --exporter-port)
            case "$2" in
                "")
                    shift 2  
                    ;;
                *)
                    exporter_port="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Error: argument \"$1\" is invalid" >&2
            echo ""
            print_help
            exit 1
            ;;
    esac
done

EASYOPS_COLLECTOR_oracle_server=$oracle_host
EASYOPS_COLLECTOR_oracle_port=$oracle_port
EASYOPS_COLLECTOR_oracle_username=$oracle_user
EASYOPS_COLLECTOR_oracle_password=$oracle_password
EASYOPS_COLLECTOR_oracle_sid=$oracle_sid
EASYOPS_COLLECTOR_oracle_service=$oracle_service
EASYOPS_COLLECTOR_oracle_remote_collect=$oracle_remote_collect


EASYOPS_COLLECTOR_exporter_host=$exporter_host
EASYOPS_COLLECTOR_exporter_port=$exporter_port

if [ "$oracle_remote_collect" = "false" ]; then
    export DATA_SOURCE_NAME="$oracle_user/$oracle_password@$oracle_sid"
else
    export DATA_SOURCE_NAME="$oracle_user/$oracle_password@//$oracle_host:$oracle_port/$oracle_service"
fi


export LD_LIBRARY_PATH=$PWD"/src/oracle_instantclient_basiclite":$LD_LIBRARY_PATH

cd ./src/oracledb_exporter
nohup ./oracledb_exporter --log.level error --web.listen-address $exporter_host:$exporter_port &
