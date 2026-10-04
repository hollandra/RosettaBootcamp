#!/usr/bin/env bash
#
#SBATCH --job-name=test_esmfold
#SBATCH --mail-user=holla653@umn.edu
#SBATCH --mail-type=FAIL
#SBATCH --output=test_esmfold_%j_.txt
#SBATCH --partition=a100-4
#SBATCH --time=00:30:00
#SBATCH --mem=32g
#SBATCH --ntasks=4
#SBATCH --gres=gpu:a100:1

module load cuda

python - <<'PY'
import torch, esm
model = esm.pretrained.esmfold_v1().eval().cuda()
seq = "MKTAYIAKQRQISFVKSHFSRQLEERLGLIEVQAPILSRVGDGTQDNLSGAEKAVQVKVKALPDAQFEVVHSLAKWKR"
with torch.no_grad():
    pdb = model.infer_pdb(seq)
open("esmfold_test.pdb", "w").write(pdb)
print("wrote esmfold_test.pdb")
PY