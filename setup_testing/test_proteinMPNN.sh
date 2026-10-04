#!/usr/bin/env bash
#
#SBATCH --job-name=test_proteinMPNN
#SBATCH --mail-user=holla653@umn.edu
#SBATCH --mail-type=FAIL
#SBATCH --output=test_proteinMPNN_%j_.txt
#SBATCH --partition=a100-4
#SBATCH --time=00:05:00
#SBATCH --mem=20g
#SBATCH --ntasks=1
#SBATCH --gres=gpu:a100:1

wget https://files.rcsb.org/download/1BC8.pdb -O proteinMPNN_test/1BC8.pdb
python /users/3/holla653/Code/ProteinMPNN/protein_mpnn_run.py \
  --pdb_path 1BC8.pdb \
  --out_folder proteinMPNN_test \
  --num_seq_per_target 2 \
  --sampling_temp "0.1" \
  --seed 37 \
  --batch_size 1
