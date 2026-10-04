#!/usr/bin/env bash
#
#SBATCH --job-name=test_boltz
#SBATCH --mail-user=holla653@umn.edu
#SBATCH --mail-type=FAIL
#SBATCH --output=test_boltz_%j_.txt
#SBATCH --partition=a100-4
#SBATCH --time=00:10:00
#SBATCH --mem=120g
#SBATCH --ntasks=1
#SBATCH --gres=gpu:a100:1

module purge
unset LD_LIBRARY_PATH
boltz predict /users/3/holla653/Code/RosettaBootcamp/setup_testing/boltz_test/test.yaml \
  --use_msa_server \
  --out_dir /users/3/holla653/Code/RosettaBootcamp/setup_testing/boltz_test/
