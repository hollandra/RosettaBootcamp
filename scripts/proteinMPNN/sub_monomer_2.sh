#!/usr/bin/env bash
#
#SBATCH --job-name=sub_monomer_2
#SBATCH --mail-user=holla653@umn.edu
#SBATCH --mail-type=FAIL
#SBATCH --output=sub_monomer_2_%j_.txt
#SBATCH --partition=msismall
#SBATCH --time=00:30:00
#SBATCH --mem=32g
#SBATCH --ntasks=4


path_to_PDB="/users/3/holla653/Code/RosettaBootcamp/input/proteinMPNN/1PGX_AF2.pdb"
output_dir="/users/3/holla653/Code/RosettaBootcamp/output/proteinMPNN/monomer_run_2"
model_dir="/users/3/holla653/Code/ProteinMPNN/vanilla_model_weights"
model_name="v_48_020"


if [ ! -d $output_dir ]
then
    mkdir -p $output_dir
fi

chains_to_design="A"

python /users/3/holla653/Code/ProteinMPNN/protein_mpnn_run.py \
        --pdb_path $path_to_PDB \
        --out_folder $output_dir \
        --num_seq_per_target 10 \
        --sampling_temp "0.8" \
        --omit_AAs "CHX" \
        --seed 68 \
        --path_to_model_weights $model_dir \
        --model_name $model_name \
