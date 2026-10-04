#!/usr/bin/env bash
#
#SBATCH --job-name=binder_design
#SBATCH --mail-user=holla653@umn.edu
#SBATCH --mail-type=FAIL
#SBATCH --output=rfd_binder_%j_.txt
#SBATCH --partition=a100-4
#SBATCH --time=00:20:00
#SBATCH --mem=80g
#SBATCH --ntasks=4
#SBATCH --gres=gpu:a100:1



OUTDIR="/users/3/holla653/Code/RosettaBootcamp/output/RFdiffusion/binder_design"


module load cuda                   # 11.8

cd /users/3/holla653/Code/RFdiffusion               # your clone path

# Confirm PyTorch sees the A100 before doing real work:
python -c "import torch; print('CUDA:', torch.cuda.is_available(), '|', torch.cuda.get_device_name(0))"

# Unconditional 100-residue monomer, one design:
./scripts/run_inference.py \
    inference.input_pdb=/users/3/holla653/Code/RosettaBootcamp/input/6OIM_cleaned.pdb \
    inference.deterministic=True \
    'contigmap.contigs=[A1-104/0  A108-169/0 70-150]' \
    'ppi.hotspot_res=[A94,A95,A98,A99,A102]' \
    inference.output_prefix=$OUTDIR \
    inference.num_designs=10
