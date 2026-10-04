#!/usr/bin/env bash
#
#SBATCH --job-name=sub_monomer_1
#SBATCH --mail-user=holla653@umn.edu
#SBATCH --mail-type=FAIL
#SBATCH --output=sub_monomer_1_%j_.txt
#SBATCH --partition=a100-4
#SBATCH --time=00:15:00
#SBATCH --mem=20g
#SBATCH --ntasks=1
#SBATCH --gres=gpu:a100:1


path_to_PDB="/users/3/holla653/Code/RosettaBootcamp/input/proteinMPNN/1PGX_AF2.pdb"
output_dir="/users/3/holla653/Code/RosettaBootcamp/output/proteinMPNN/monomer_run_1"
model_dir="/users/3/holla653/Code/ProteinMPNN/vanilla_model_weights"
model_name="v_48_020"


if [ ! -d $output_dir ]
then
    mkdir -p $output_dir
fi

chains_to_design="A"

python ./protein_mpnn_run.py \
        --pdb_path $path_to_PDB \
        --out_folder $output_dir \
        --num_seq_per_target 10 \
        --sampling_temp "0.2" \
        --seed 68 \
        --path_to_model_weights $model_dir \
        --model_name $model_name \
