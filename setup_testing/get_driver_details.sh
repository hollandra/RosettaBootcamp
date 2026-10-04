#!/usr/bin/env bash
#
#SBATCH --job-name=get_driver_details
#SBATCH --mail-user=holla653@umn.edu
#SBATCH --mail-type=FAIL
#SBATCH --output=driver_details_%j_.txt
#SBATCH --partition=msigpu
#SBATCH --time=00:01:00
#SBATCH --mem=20g
#SBATCH --ntasks=1
#SBATCH --gres=gpu:a100:1

module load cuda
nvidia-smi
nvidia-smi --query-gpu=name,compute_cap --format=csv