#!/bin/bash


PACKAGE_NAME=oracle-collector-plugin
PACKAGE_PATH=$(dirname "$(cd `dirname $0`; pwd)")
LOG_DIRECTORY=$PACKAGE_PATH/log
LOG_FILE=$LOG_DIRECTORY/$PACKAGE_NAME.log


if ! type getopt >/dev/null 2>&1 ; then
  message="command \"getopt\" is not found"
  echo "[ERROR] Message: $message" >& 2
  echo "$(date "+%Y-%m-%d %H:%M:%S") [ERROR] Message: $message" > $LOG_FILE
  exit 1
fi

getopt_cmd=`getopt -o h -a -l help:,oracle-host:,oracle-port:,oracle-user:,oracle-password:,oracle-remote-collect:,oracle-sid:,oracle-service:,exporter-host:,exporter-port: -n "start_script.sh" -- "$@"`
if [ $? -ne 0 ] ; then
    exit 1
fi
eval set -- "$getopt_cmd"


oracle_host="127.0.0.1"
oracle_port=1521
oracle_user=""
oracle_password=""
oracle_remote_collect="false"
oracle_sid=""
oracle_service=""
exporter_host="127.0.0.1"
exporter_port=9161

print_help() {
    echo "Usage:"
    echo "    start_script.sh [options]"
    echo "    start_script.sh --oracle-host 127.0.0.1 --oracle-port 1521 --oracle-user root [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help                     show help"
    echo "      --oracle-host              the address of oracle server (\"127.0.0.1\" by default)"
    echo "      --oracle-port              the port of oracle server (1521 by default)"
    echo "      --oracle-user              the user to log in to oracle server"
    echo "      --oracle-password          the password to log in to oracle server"
    echo "      --oracle-remote-collect    whether use remote collect"
    echo "      --oracle-service           the service instance of oracle server"
    echo "      --oracle-sid               the sid  of oracle server"
    echo "      --exporter-host            the listen address of exporter (\"127.0.0.1\" by default)"
    echo "      --exporter-port            the listen port of exporter (9161 by default)"
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
            message="argument \"$1\" is invalid"
            echo "[ERROR] Message: $message" >& 2
            echo "$(date "+%Y-%m-%d %H:%M:%S") [ERROR] Message: $message" > $LOG_FILE
            print_help
            exit 1
            ;;
    esac
done

mkdir -p $LOG_DIRECTORY

message="start exporter"
echo "[INFO] Message: $message"
echo "$(date "+%Y-%m-%d %H:%M:%S") [INFO] Message: $message" >> $LOG_FILE

export LD_LIBRARY_PATH=$PACKAGE_PATH/script/src/oracle_instantclient_basiclite:$LD_LIBRARY_PATH

if [ "$oracle_remote_collect" = "false" ]; then
    export DATA_SOURCE_NAME="$oracle_user/$oracle_password@$oracle_sid"
else
    export DATA_SOURCE_NAME="$oracle_user/$oracle_password@//$oracle_host:$oracle_port/$oracle_service"
fi

cd $PACKAGE_PATH
chmod +x src/oracledb_exporter
./src/oracledb_exporter --default.metrics conf/default-metrics.toml --web.listen-address $exporter_host:$exporter_port 2>&1 | tee -a $LOG_FILE
