#!/usr/bin/env bash
#
#SBATCH --job-name=test_alphafold
#SBATCH --mail-user=holla653@umn.edu
#SBATCH --mail-type=FAIL
#SBATCH --output=test_alphafold_%j_.txt
#SBATCH --partition=a100-4
#SBATCH --time=04:00:00
#SBATCH --mem=64g
#SBATCH --ntasks=8
#SBATCH --gres=gpu:a100:1

module purge
module load alphafold

run_alphafold.sh \
  -d /common/software/install/manual/alphafold/data_dir_2.3.1-multimer \
  -o /users/3/holla653/Code/RosettaBootcamp/setup_testing/alphafold_test \
  -f /users/3/holla653/Code/RosettaBootcamp/setup_testing/alphafold_test/test_monomer.fasta \
  -t 2024-01-01 \
  -m monomer \
  -c reduced_dbs