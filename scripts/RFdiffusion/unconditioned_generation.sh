#!/usr/bin/env bash
#
#SBATCH --job-name=uncon_gen
#SBATCH --mail-user=holla653@umn.edu
#SBATCH --mail-type=FAIL
#SBATCH --output=unconditional_generation_%j_.txt
#SBATCH --partition=a100-4
#SBATCH --time=00:20:00
#SBATCH --mem=80g
#SBATCH --ntasks=4
#SBATCH --gres=gpu:a100:1



OUTDIR="/users/3/holla653/Code/RosettaBootcamp/output/RFdiffusion/unconditioned_generation"


module load cuda                   # 11.8

cd /users/3/holla653/Code/RFdiffusion               # your clone path

# Confirm PyTorch sees the A100 before doing real work:
python -c "import torch; print('CUDA:', torch.cuda.is_available(), '|', torch.cuda.get_device_name(0))"

# Unconditional 100-residue monomer, one design:
./scripts/run_inference.py \
    'contigmap.contigs=[100-200]' \
    inference.output_prefix=$OUTDIR \
    inference.num_designs=10

