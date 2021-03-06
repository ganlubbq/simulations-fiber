#!/usr/bin/env bash
#SBATCH -p glenn
#SBATCH -A C3SE2018-1-15
#SBATCH -J simulateScenario94
#SBATCH -N 1
#SBATCH -t 0-10:00:00
#SBATCH -o simulateScenario94.stdout
#SBATCH -e simulateScenario94.stderr


module load matlab

cp  -r $SLURM_SUBMIT_DIR/* $TMPDIR
cd $TMPDIR

array=(  "-20;0;49000000000;150000000000" "-19;0;49000000000;150000000000" "-18;0;49000000000;150000000000" "-17;0;49000000000;150000000000" "-16;0;49000000000;150000000000" "-15;0;49000000000;150000000000" "-14;0;49000000000;150000000000" "-13;0;49000000000;150000000000" "-12;0;49000000000;150000000000" "-11;0;49000000000;150000000000" "-10;0;49000000000;150000000000" "-9;0;49000000000;150000000000" "-8;0;49000000000;150000000000" "-7;0;49000000000;150000000000" "-6;0;49000000000;150000000000" "-5;0;49000000000;150000000000" )
for i in "${array[@]}"
do
    arr=(${i//;/ })
    echo ${arr[0]} ${arr[1]} ${arr[2]} ${arr[3]}
    RunMatlab.sh -o "-nodesktop -nosplash -singleCompThread -r \"simulateScenario(${arr[0]},${arr[1]},${arr[2]},${arr[3]});\"" & 
    sleep 0.1
done

wait

mkdir $SLURM_SUBMIT_DIR/simulateScenario94
cp -rf $TMPDIR/results/* $SLURM_SUBMIT_DIR/simulateScenario94
rm -rf $TMPDIR/*

#End of script

