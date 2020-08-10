#!/bin/bash

ps -ef | grep oracledb_exporter | awk \'{print $2}\' | xargs kill -9