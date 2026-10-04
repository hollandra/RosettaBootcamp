from esm.models.esmfold2 import (
    DNAInput,
    ESMFold2InputBuilder,
    LigandInput,
    Modification,
    ProteinInput,
    StructurePredictionInput,
)
from transformers.models.esmfold2.modeling_esmfold2 import ESMFold2Model

MYSTERY_SEQ = (
    "AVESIEKKRIRKGRVEYLVKWRGWSPKYNTWEPEENILDPRLLIAFQNRE"
)

model = ESMFold2Model.from_pretrained("biohub/ESMFold2-fast").cuda().eval()

spi = StructurePredictionInput(
    sequences=[
        ProteinInput(id="A", sequence=MYSTERY_SEQ),
    ]
)

input_builder = ESMFold2InputBuilder()

for output_number in range(1, 4):
    seed = 68 + output_number - 1

    result = input_builder.fold(
        model,
        spi,
        num_loops=20,
        num_sampling_steps=100,
        num_diffusion_samples=1,
        seed=seed,
    )

    output_filename = f"MYS_SEQ_{output_number}.cif"

    print(
        f"{output_filename}: "
        f"pLDDT mean: {float(result.plddt.mean()):.3f}, "
        f"pTM: {float(result.ptm):.3f}, "
        f"ipTM: {float(result.iptm):.3f}"
    )

    with open(output_filename, "w") as f:
        f.write(result.complex.to_mmcif())
