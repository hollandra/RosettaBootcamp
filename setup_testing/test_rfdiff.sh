#!/usr/bin/env bash
#
#SBATCH --job-name=test_rfdiff
#SBATCH --mail-user=holla653@umn.edu
#SBATCH --mail-type=FAIL
#SBATCH --output=test_rfdiff_%j_.txt
#SBATCH --partition=a100-4
#SBATCH --time=00:30:00
#SBATCH --mem=32g
#SBATCH --ntasks=4
#SBATCH --gres=gpu:a100:1

module load cuda                   # 11.8

cd /users/3/holla653/Code/RFdiffusion               # your clone path

# Confirm PyTorch sees the A100 before doing real work:
python -c "import torch; print('CUDA:', torch.cuda.is_available(), '|', torch.cuda.get_device_name(0))"

# Unconditional 100-residue monomer, one design:
./scripts/run_inference.py \
  'contigmap.contigs=[100-100]' \
  inference.output_prefix=outputs/test_uncond \
  inference.num_designs=1