#!/usr/bin/env bash
#SBATCH -p glenn
#SBATCH -A C3SE2018-1-15
#SBATCH -J simulateScenario6
#SBATCH -N 1
#SBATCH -t 0-10:00:00
#SBATCH -o simulateScenario6.stdout
#SBATCH -e simulateScenario6.stderr


module load matlab

cp  -r $SLURM_SUBMIT_DIR/* $TMPDIR
cd $TMPDIR

array=(  "-2;0;3000000000;50000000000" "-1;0;3000000000;50000000000" "0;0;3000000000;50000000000" "1;0;3000000000;50000000000" "2;0;3000000000;50000000000" "3;0;3000000000;50000000000" "4;0;3000000000;50000000000" "5;0;3000000000;50000000000" "6;0;3000000000;50000000000" "7;0;3000000000;50000000000" "8;0;3000000000;50000000000" "9;0;3000000000;50000000000" "10;0;3000000000;50000000000" "-20;0;4000000000;50000000000" "-19;0;4000000000;50000000000" "-18;0;4000000000;50000000000" )
for i in "${array[@]}"
do
    arr=(${i//;/ })
    echo ${arr[0]} ${arr[1]} ${arr[2]} ${arr[3]}
    RunMatlab.sh -o "-nodesktop -nosplash -singleCompThread -r \"simulateScenario(${arr[0]},${arr[1]},${arr[2]},${arr[3]});\"" & 
    sleep 0.1
done

wait

mkdir $SLURM_SUBMIT_DIR/simulateScenario6
cp -rf $TMPDIR/results/* $SLURM_SUBMIT_DIR/simulateScenario6
rm -rf $TMPDIR/*

#End of script

