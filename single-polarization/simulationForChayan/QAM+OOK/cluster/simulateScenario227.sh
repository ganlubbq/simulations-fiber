#!/usr/bin/env bash
#SBATCH -p glenn
#SBATCH -A C3SE2018-1-15
#SBATCH -J simulateScenario227
#SBATCH -N 1
#SBATCH -t 0-10:00:00
#SBATCH -o simulateScenario227.stdout
#SBATCH -e simulateScenario227.stderr


module load matlab

cp  -r $SLURM_SUBMIT_DIR/* $TMPDIR
cd $TMPDIR

array=(  "-6;-6;32000000000;200000000000" "-5;-6;32000000000;200000000000" "-4;-6;32000000000;200000000000" "-3;-6;32000000000;200000000000" "-2;-6;32000000000;200000000000" "-1;-6;32000000000;200000000000" "0;-6;32000000000;200000000000" "1;-6;32000000000;200000000000" "2;-6;32000000000;200000000000" "3;-6;32000000000;200000000000" "4;-6;32000000000;200000000000" "5;-6;32000000000;200000000000" "6;-6;32000000000;200000000000" "7;-6;32000000000;200000000000" "8;-6;32000000000;200000000000" "9;-6;32000000000;200000000000" )
for i in "${array[@]}"
do
    arr=(${i//;/ })
    echo ${arr[0]} ${arr[1]} ${arr[2]} ${arr[3]}
    RunMatlab.sh -o "-nodesktop -nosplash -singleCompThread -r \"simulateScenario(${arr[0]},${arr[1]},${arr[2]},${arr[3]});\"" & 
    sleep 0.1
done

wait

mkdir $SLURM_SUBMIT_DIR/simulateScenario227
cp -rf $TMPDIR/results/* $SLURM_SUBMIT_DIR/simulateScenario227
rm -rf $TMPDIR/*

#End of script

