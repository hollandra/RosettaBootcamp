#!/usr/bin/env bash
#
#SBATCH --job-name=alphafold_myoglobin
#SBATCH --mail-user=holla653@umn.edu
#SBATCH --mail-type=FAIL
#SBATCH --output=alphafold_myoglobin_%j_.txt
#SBATCH --partition=a100-4
#SBATCH --time=04:00:00
#SBATCH --mem=64g
#SBATCH --ntasks=8
#SBATCH --gres=gpu:a100:1

module purge
module load alphafold

run_alphafold.sh \
  -d /common/software/install/manual/alphafold/data_dir_2.3.1-multimer \
  -o /users/3/holla653/Code/RosettaBootcamp/output \
  -f /users/3/holla653/Code/RosettaBootcamp/input/rcsb_pdb_1MBN.fasta \
  -t 2024-01-01 \
  -m monomer \
  -c reduced_dbs