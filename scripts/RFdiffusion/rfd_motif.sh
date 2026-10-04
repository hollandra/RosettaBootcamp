#!/usr/bin/env bash
#
#SBATCH --job-name=motif_design
#SBATCH --mail-user=holla653@umn.edu
#SBATCH --mail-type=FAIL
#SBATCH --output=rfd_motif_%j_.txt
#SBATCH --partition=a100-4
#SBATCH --time=00:20:00
#SBATCH --mem=80g
#SBATCH --ntasks=4
#SBATCH --gres=gpu:a100:1



OUTDIR="/users/3/holla653/Code/RosettaBootcamp/output/RFdiffusion/motif_design"


module load cuda                   # 11.8

cd /users/3/holla653/Code/RFdiffusion               # your clone path

# Confirm PyTorch sees the A100 before doing real work:
python -c "import torch; print('CUDA:', torch.cuda.is_available(), '|', torch.cuda.get_device_name(0))"

./scripts/run_inference.py \
    inference.input_pdb=/users/3/holla653/Code/RosettaBootcamp/input/8U08_motif.pdb \
    'contigmap.contigs=[39-39/C96-107/20-50/0 H1-131/0 L2-119/0]' \
    inference.output_prefix=$OUTDIR \
    inference.num_designs=10
