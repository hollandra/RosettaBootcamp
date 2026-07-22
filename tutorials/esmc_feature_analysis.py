from functools import lru_cache

import numpy as np
import requests
import torch
from transformers import AutoModel, AutoTokenizer


SEQUENCE = "AVESIEKKRIRKGRVEYLVKWRGWSPKYNTWEPEENILDPRLLIAFQNRE"

MODEL_ID = "biohub/ESMC-6B"
SAE_ID = "biohub/ESMC-6B-sae-k64-codebook16384"

SAE_LAYER = 60
FEATURE_COUNT = 16384
TOP_N = 5

ACTIVATION_THRESHOLD = 0.5
MIN_CONSECUTIVE_RESIDUES = 10


@lru_cache(maxsize=FEATURE_COUNT)
def get_feature_info(feature_id):
    url = (
        "https://biohub.ai/esm/protein/api/v1alpha1/features/"
        f"{feature_id}"
    )
    response = requests.get(url, timeout=30)
    response.raise_for_status()
    return response.json()


def find_best_run(activations):
    active = activations > ACTIVATION_THRESHOLD
    best = None
    start = None

    for position, is_active in enumerate(np.append(active, False)):
        if is_active and start is None:
            start = position

        elif not is_active and start is not None:
            end = position
            length = end - start

            if length >= MIN_CONSECUTIVE_RESIDUES:
                values = activations[start:end]

                run = {
                    "start": start,
                    "end": end,
                    "length": length,
                    "mean": float(values.mean()),
                    "peak": float(values.max()),
                    "peak_position": start + int(values.argmax()),
                }

                if best is None or run["mean"] > best["mean"]:
                    best = run

            start = None

    return best


def is_generic(description):
    text = description.lower().strip()

    return (
        not text
        or text == "unknown"
        or "unknown generic feature" in text
        or text == "generic feature"
        or text == "no description available"
    )


if not torch.cuda.is_available():
    raise RuntimeError("A CUDA GPU is required for ESMC-6B.")

device = torch.device("cuda:0")

dtype = (
    torch.bfloat16
    if torch.cuda.is_bf16_supported()
    else torch.float16
)


print("Loading ESMC-6B...")

model = AutoModel.from_pretrained(
    MODEL_ID,
    dtype=dtype,
    device_map=None,
    low_cpu_mem_usage=False,
).eval().to(device)

tokenizer = AutoTokenizer.from_pretrained(MODEL_ID)


print("Loading layer-60 SAE...")

sae = AutoModel.from_pretrained(
    SAE_ID,
    allow_patterns=[
        "config.json",
        f"layer_{SAE_LAYER}.safetensors",
    ],
    device=device,
)

sae.initialize_layers([SAE_LAYER])
model.add_sae_models([sae.layers[str(SAE_LAYER)]])


encoded = tokenizer(
    SEQUENCE,
    return_tensors="pt",
    padding=False,
    return_special_tokens_mask=True,
)

special_tokens = encoded.pop("special_tokens_mask")[0].bool()
attention_mask = encoded["attention_mask"][0].bool()
residue_mask = attention_mask & ~special_tokens

inputs = {
    name: tensor.to(device)
    for name, tensor in encoded.items()
}


print("Running inference...")

with torch.inference_mode():
    output = model(**inputs)


features = output[
    "sae_outputs"
][f"layer{SAE_LAYER}"].to_dense()


feature_axis = next(
    axis
    for axis, size in enumerate(features.shape)
    if size == FEATURE_COUNT
)

features = features.movedim(feature_axis, -1)
features = features.reshape(-1, FEATURE_COUNT)
features = features[residue_mask.to(features.device)]
features = features.float().cpu().numpy()


results = []

for feature_id in range(FEATURE_COUNT):
    run = find_best_run(features[:, feature_id])

    if run is not None:
        results.append({
            "feature_id": feature_id,
            **run,
        })


results.sort(
    key=lambda result: result["mean"],
    reverse=True,
)


print(
    f"\nTop {TOP_N} non-generic features active across at least "
    f"{MIN_CONSECUTIVE_RESIDUES} consecutive residues"
)
print("=" * 80)


printed = 0

for result in results:
    feature_id = result["feature_id"]

    try:
        info = get_feature_info(feature_id)
        description = info.get("description", "")
    except requests.RequestException:
        continue

    if is_generic(description):
        continue

    start = result["start"]
    end = result["end"]
    peak_position = result["peak_position"]

    printed += 1

    print(f"\n{printed}. Feature {feature_id}")
    print(f"   Region: {start + 1}-{end}")
    print(f"   Sequence: {SEQUENCE[start:end]}")
    print(f"   Mean activation: {result['mean']:.3f}")
    print(f"   Peak activation: {result['peak']:.3f}")
    print(
        f"   Peak residue: "
        f"{SEQUENCE[peak_position]}{peak_position + 1}"
    )
    print(f"   Description: {description}")

    if printed == TOP_N:
        break


if printed == 0:
    print("No non-generic features met the criteria.")