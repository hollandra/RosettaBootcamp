#!/usr/bin/env bash
#
#SBATCH --job-name=sub_ligand_3
#SBATCH --mail-user=holla653@umn.edu
#SBATCH --mail-type=FAIL
#SBATCH --output=sub_ligand_3_%j_.txt
#SBATCH --partition=msismall
#SBATCH --time=00:30:00
#SBATCH --mem=32g
#SBATCH --ntasks=4

cd /users/3/holla653/Code/LigandMPNN

path_to_PDB="/users/3/holla653/Code/RosettaBootcamp/input/proteinMPNN/1BC8.pdb"
output_dir="/users/3/holla653/Code/RosettaBootcamp/output/proteinMPNN/ligand_run_3"


if [ ! -d $output_dir ]
then
    mkdir -p $output_dir
fi

python /users/3/holla653/Code/LigandMPNN/run.py \
        --model_type "ligand_mpnn" \
        --pdb_path $path_to_PDB \
        --out_folder $output_dir \
	--bias_AA "W:3.0,P:3.0,C:3.0,A:-3.0" \
        --seed 68 \
        --batch_size 10
