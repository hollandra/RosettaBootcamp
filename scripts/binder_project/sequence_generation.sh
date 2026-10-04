#!/usr/bin/env bash
#
#SBATCH --job-name=sequence_gen
#SBATCH --mail-user=holla653@umn.edu
#SBATCH --mail-type=FAIL
#SBATCH --output=sequence_generation_%j_.txt
#SBATCH --partition=msismall
#SBATCH --time=01:00:00
#SBATCH --mem=32g
#SBATCH --ntasks=4

cd /users/3/holla653/Code/LigandMPNN

output_dir="/users/3/holla653/Code/RosettaBootcamp/output/binder_project/sequence_2-9"

if [ ! -d $output_dir ]
then
    mkdir -p $output_dir
fi

path_to_PDB="/users/3/holla653/Code/RosettaBootcamp/output/binder_project/rfd_backbones/rfd_more_backbones_9.pdb"
python /users/3/holla653/Code/LigandMPNN/run.py \
        --model_type "ligand_mpnn" \
        --pdb_path $path_to_PDB \
        --out_folder $output_dir \
	--chains_to_design "A" \
        --seed 6 \
        --batch_size 10

output_dir="/users/3/holla653/Code/RosettaBootcamp/output/binder_project/sequence_2-16"

if [ ! -d $output_dir ]
then
    mkdir -p $output_dir
fi

path_to_PDB="/users/3/holla653/Code/RosettaBootcamp/output/binder_project/rfd_backbones/rfd_more_backbones_16.pdb"
python /users/3/holla653/Code/LigandMPNN/run.py \
        --model_type "ligand_mpnn" \
        --pdb_path $path_to_PDB \
        --out_folder $output_dir \
	--chains_to_design "A" \
        --seed 6 \
        --batch_size 10

output_dir="/users/3/holla653/Code/RosettaBootcamp/output/binder_project/sequence_2-17"

if [ ! -d $output_dir ]
then
    mkdir -p $output_dir
fi

path_to_PDB="/users/3/holla653/Code/RosettaBootcamp/output/binder_project/rfd_backbones/rfd_more_backbones_17.pdb"
python /users/3/holla653/Code/LigandMPNN/run.py \
        --model_type "ligand_mpnn" \
        --pdb_path $path_to_PDB \
        --out_folder $output_dir \
	--chains_to_design "A" \
        --seed 6 \
        --batch_size 10

output_dir="/users/3/holla653/Code/RosettaBootcamp/output/binder_project/sequence_2-18"

if [ ! -d $output_dir ]
then
    mkdir -p $output_dir
fi

path_to_PDB="/users/3/holla653/Code/RosettaBootcamp/output/binder_project/rfd_backbones/rfd_more_backbones_18.pdb"
python /users/3/holla653/Code/LigandMPNN/run.py \
        --model_type "ligand_mpnn" \
        --pdb_path $path_to_PDB \
        --out_folder $output_dir \
	--chains_to_design "A" \
        --seed 6 \
        --batch_size 10
