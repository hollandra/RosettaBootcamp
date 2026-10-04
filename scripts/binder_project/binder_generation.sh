#!/usr/bin/env bash
#
#SBATCH --job-name=binder_generation
#SBATCH --mail-user=holla653@umn.edu
#SBATCH --mail-type=FAIL
#SBATCH --output=binder_generation_%j_.txt
#SBATCH --partition=a100-4
#SBATCH --time=02:00:00
#SBATCH --mem=80g
#SBATCH --ntasks=4
#SBATCH --gres=gpu:a100:1



OUTPATH="/users/3/holla653/Code/RosettaBootcamp/output/binder_project/rfd_more_backbones"


module load cuda                   # 11.8

cd /users/3/holla653/Code/RFdiffusion               # your clone path

# Confirm PyTorch sees the A100 before doing real work:
python -c "import torch; print('CUDA:', torch.cuda.is_available(), '|', torch.cuda.get_device_name(0))"

# Generate de novo binder backbones
./scripts/run_inference.py \
    inference.input_pdb=/users/3/holla653/Code/RosettaBootcamp/input/7LSE.pdb \
    'contigmap.contigs=[E303-395/0 70-150]' \
    'ppi.hotspot_res=[E305,E306,E308,E309,E310,E311,E332,E333,E334,E335,E336,E366]' \
    inference.output_prefix=$OUTPATH \
    inference.num_designs=20
