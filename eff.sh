#!/bin/bash
#
# eff - Shows CPU utilisation by SLURM job
#
# Copyright (C) 2023 Artem Anikeev
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNUGeneral Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program or from the site that you downloaded it
# from; if not, write to the Free Software Foundation, Inc., 59 Temple
# Place, Suite 330, Boston, MA  02111-1307   USA

jobid=$(scontrol show job $1 | grep 'JobId=' | awk -F ' ' '{print $1}' | tr -d 'JobId=')

used_string=$(sstat -a -j $jobid -o "TRESUsageInTot%80" -n | tail -n 1 | awk -F',' '{print $1}' | tr -d 'cpu=')
#echo $used_string
spent_string=$(scontrol show job $jobid | grep 'RunTime=' | awk -F ' ' '{print $1}' | tr -d 'RunTime=')
#echo $spent_string
cpus=$(scontrol show job $jobid | grep 'NumCPUs=' | awk -F ' ' '{print $2}' | tr -d 'NumCPUs=')
#echo $cpus

used_s=$(echo $used_string | awk -F '[-:]' '{print $NF}')
#echo $used_s
used_m=$(echo $used_string | awk -F '[-:]' '{ if (NF > 1) print $(NF-1); else print "0" }')
#echo $used_m
used_h=$(echo $used_string | awk -F '[-:]' '{ if (NF > 2) print $(NF-2); else print "0" }')
#echo $used_h
used_d=$(echo $used_string | awk -F '[-:]' '{ if (NF > 3) print $(NF-3); else print "0" }')
#echo $used_d

spent_s=$(echo $spent_string | awk -F '[-:]' '{print $NF}' | sed 's/^0*//')
#echo $spent_s
spent_m=$(echo $spent_string | awk -F '[-:]' '{ if (NF > 1) print $(NF-1); else print "0" }')
#echo $spent_m
spent_h=$(echo $spent_string | awk -F '[-:]' '{ if (NF > 2) print $(NF-2); else print "0" }')
#echo $spent_h
spent_d=$(echo $spent_string | awk -F '[-:]' '{ if (NF > 3) print $(NF-3); else print "0" }')
#echo $spent_d


used_time=$(awk 'BEGIN { print '$used_s' + 60 * ( '$used_m' + 60 * ( '$used_h' + 24 * '$used_d' )) }')
#echo $used_time
spent_time=$(awk 'BEGIN { print '$spent_s' + 60 * ( '$spent_m' + 60 * ( '$spent_h' + 24 * '$spent_d' )) }')
#echo $spent_time
eff=$(awk 'BEGIN { print '$used_time' / '$spent_time' / '$cpus' }')
echo $eff
