#!/usr/local/easyops/python/bin/python
# -*- coding: UTF-8 -*-

import subprocess


def run_command(command, shell=False, close_fds=True):
    process = subprocess.Popen(
        command,
        shell=shell,
        close_fds=close_fds,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    process.wait()
    output, err = process.communicate()

    result = err or output
    return process.returncode, result


if __name__ == "__main__":
    run_command('ps -ef | grep oracledb_exporter | awk \'{print $2}\' | xargs kill -9', True)