#!/usr/local/easyops/python/bin/python
# -*- coding: UTF-8 -*-


import copy
import os
import subprocess


def run_command(command, cwd=".", env={}, shell=False, close_fds=True):
    process = subprocess.Popen(
        command,
        cwd=cwd,
        env=copy.deepcopy(os.environ).update(env),
        shell=shell,
        close_fds=close_fds
    )

    return process.returncode


if __name__ == "__main__":
    package_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

    argument_map = {
        '--oracle-server': 'oracle_server',
        '--oracle-port': 'oracle_port',
        '--oracle-username': 'oracle_username',
        '--oracle-password': 'oracle_password',
        '--oracle-sid': 'oracle_sid',
        '--oracle-service': 'oracle_service',
        '--oracle-remote-collect': 'oracle_remote_collect',
        '--exporter-host': 'exporter_host',
        '--exporter-port': 'exporter_port'
    }
    
    arguments = []
    for argument, env in argument_map.iteritems():
        env_value = os.environ.get('EASYOPS_COLLECTOR_' + env)
        if env_value is not None:
            arguments.append('{} {}'.format(argument, env_value))

    command = 'sh ./script/deploy/start_script.sh {} &'.format(' '.join(arguments))
    run_command(command, shell=True, cwd=package_path)
