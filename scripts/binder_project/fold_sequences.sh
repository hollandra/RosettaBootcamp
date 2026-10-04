#!/usr/bin/env bash
#
#SBATCH --job-name=fold_sequences
#SBATCH --mail-user=holla653@umn.edu
#SBATCH --mail-type=FAIL
#SBATCH --output=fold_sequences_%j_.txt
#SBATCH --partition=a100-4
#SBATCH --time=02:00:00
#SBATCH --mem=64g
#SBATCH --ntasks=8
#SBATCH --gres=gpu:a100:1

module purge
module load alphafold

run_alphafold.sh \
  -d /common/software/install/manual/alphafold/data_dir_2.3.1-multimer \
  -o /users/3/holla653/Code/RosettaBootcamp/output/binder_project/folded_sequences \
  -f "/users/3/holla653/Code/RosettaBootcamp/output/binder_project/chosen_sequences/sequence_9-1.fasta,/users/3/holla653/Code/RosettaBootcamp/output/binder_project/chosen_sequences/sequence_9-2.fasta,/users/3/holla653/Code/RosettaBootcamp/output/binder_project/chosen_sequences/sequence_9-3.fasta,/users/3/holla653/Code/RosettaBootcamp/output/binder_project/chosen_sequences/sequence_9-4.fasta" \
  -t 2024-01-01 \
  -m multimer \
  -c reduced_dbs

run_alphafold.sh \
  -d /common/software/install/manual/alphafold/data_dir_2.3.1-multimer \
  -o /users/3/holla653/Code/RosettaBootcamp/output/binder_project/folded_sequences \
  -f "/users/3/holla653/Code/RosettaBootcamp/output/binder_project/chosen_sequences/sequence_18-1.fasta,/users/3/holla653/Code/RosettaBootcamp/output/binder_project/chosen_sequences/sequence_18-2.fasta,/users/3/holla653/Code/RosettaBootcamp/output/binder_project/chosen_sequences/sequence_18-3.fasta,/users/3/holla653/Code/RosettaBootcamp/output/binder_project/chosen_sequences/sequence_18-4.fasta" \
  -t 2024-01-01 \
  -m multimer \
  -c reduced_dbs