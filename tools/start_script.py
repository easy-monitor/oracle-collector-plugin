#!/usr/local/easyops/python/bin/python
# -*- coding: UTF-8 -*-

import os
import subprocess

oracle_server = os.environ.get("EASYOPS_COLLECTOR_oracle_server", "127.0.0.1")
oracle_port = os.environ.get("EASYOPS_COLLECTOR_oracle_port", 1521)
oracle_username = os.environ.get("EASYOPS_COLLECTOR_oracle_username", "")
oracle_password = os.environ.get("EASYOPS_COLLECTOR_oracle_password", "")
oracle_sid = os.environ.get("EASYOPS_COLLECTOR_oracle_sid", "")
oracle_service = os.environ.get("EASYOPS_COLLECTOR_oracle_service", "")
oracle_remote_collect = os.environ.get("EASYOPS_COLLECTOR_oracle_remote_collect", "false")

exporter_host = os.environ.get("EASYOPS_COLLECTOR_exporter_host", "127.0.0.1")
exporter_port = os.environ.get("EASYOPS_COLLECTOR_exporter_port", 4000)


def run_command(command, env={}, shell=False, close_fds=True):
    process = subprocess.Popen(
        command,
        env=env,
        shell=shell,
        close_fds=close_fds
    )

    return process.returncode


if __name__ == "__main__":
    src_path = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "src")
    env = os.environ.copy()
    env["LD_LIBRARY_PATH"] = "{lib_path}:$LD_LIBRARY_PATH".format(lib_path=os.path.join(src_path, "oracle_instantclient_basiclite"))

    if oracle_remote_collect == "true":
        # or using a complete url:
        env["DATA_SOURCE_NAME"] = "{oracle_username}/{oracle_password}@//{oracle_server}:{oracle_port}/{oracle_service}".format(
            oracle_username=oracle_username, oracle_password=oracle_password, oracle_server=oracle_server,
            oracle_port=oracle_port, oracle_service=oracle_service
        )
    else:
        # export Oracle location:
        env["DATA_SOURCE_NAME"] = "{oracle_username}/{oracle_password}@{oracle_sid}".format(oracle_sid=oracle_sid, oracle_password=oracle_password, oracle_username=oracle_username)

    start_cmd = "cd {bin_path} && {bin_file} --log.level error --web.listen-address {exporter_host}:{exporter_port}".format(
                    bin_path=os.path.join(src_path, "oracledb_exporter"),
                    bin_file="./oracledb_exporter",
                    exporter_host=exporter_host,
                    exporter_port=exporter_port)

    run_command(start_cmd, shell=True, env=env)
