# eff
An CPU utilisation calculator for running SLURM jobs.

Usage:

    ./eff.sh $JobId

Output is a CPU utilisation calculated as:

eff = TRESUsageInTot / RunTime / NumCPUs.

1 means 100%.
