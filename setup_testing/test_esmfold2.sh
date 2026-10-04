#!/usr/bin/env bash
#
#SBATCH --job-name=test_esmfold2
#SBATCH --mail-user=holla653@umn.edu
#SBATCH --mail-type=FAIL
#SBATCH --output=test_esmfold2_%j_.txt
#SBATCH --partition=a100-4
#SBATCH --time=00:30:00
#SBATCH --mem=32g
#SBATCH --ntasks=4
#SBATCH --gres=gpu:a100:1

module purge
unset LD_LIBRARY_PATH

nvidia-smi --query-gpu=name,memory.total --format=csv

python - <<'PY'
import torch
from esm.models.esmfold2 import ProteinInput, StructurePredictionInput, ESMFold2InputBuilder
from transformers.models.esmfold2.modeling_esmfold2 import ESMFold2Model

print("torch", torch.__version__, "cuda", torch.version.cuda, "gpu", torch.cuda.get_device_name(0))

model = ESMFold2Model.from_pretrained("biohub/ESMFold2", revision="6234905").cuda().eval()

seq = "MKTAYIAKQRQISFVKSHFSRQLEERLGLIEVQAPILSRVGDGTQDNLSGAEKAVQVKVKALPDAQFEVVHSLAKWKR"
spi = StructurePredictionInput(sequences=[ProteinInput(id="A", sequence=seq)])
result = ESMFold2InputBuilder().fold(
    model, spi, num_loops=3, num_sampling_steps=50, num_diffusion_samples=1, seed=0
)
open("esmfold2_test.cif", "w").write(result.complex.to_mmcif())
print(f"done - pLDDT {float(result.plddt.mean()):.3f}  pTM {float(result.ptm):.3f}")
PY