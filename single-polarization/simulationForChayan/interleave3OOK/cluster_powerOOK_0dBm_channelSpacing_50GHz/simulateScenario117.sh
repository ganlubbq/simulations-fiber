#!/usr/bin/env bash
#SBATCH -p glenn
#SBATCH -A C3SE2018-1-15
#SBATCH -J simulateScenario117
#SBATCH -N 1
#SBATCH -t 0-10:00:00
#SBATCH -o simulateScenario117.stdout
#SBATCH -e simulateScenario117.stderr


module load matlab

cp  -r $SLURM_SUBMIT_DIR/* $TMPDIR
cd $TMPDIR

array=(  "7;0;60000000000;50000000000" "8;0;60000000000;50000000000" "9;0;60000000000;50000000000" "10;0;60000000000;50000000000" )
for i in "${array[@]}"
do
    arr=(${i//;/ })
    echo ${arr[0]} ${arr[1]} ${arr[2]} ${arr[3]}
    RunMatlab.sh -o "-nodesktop -nosplash -singleCompThread -r \"simulateScenario(${arr[0]},${arr[1]},${arr[2]},${arr[3]});\"" & 
    sleep 0.1
done

wait

mkdir $SLURM_SUBMIT_DIR/simulateScenario117
cp -rf $TMPDIR/results/* $SLURM_SUBMIT_DIR/simulateScenario117
rm -rf $TMPDIR/*

#End of script

