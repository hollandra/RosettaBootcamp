import sys
from collections import Counter

AMINO_ACIDS = "ACDEFGHIKLMNPQRSTVWY"

seqs = []
seq = ""

for line in open(sys.argv[1]):
    line = line.strip()
    if line.startswith(">"):
        if seq:
            seqs.append(seq)
        seq = ""
    else:
        seq += line

seqs.append(seq)
seqs = seqs[1:]  # exclude first sequence

for position, residues in enumerate(zip(*seqs), 1):
    counts = Counter(residues)
    print(position, " ".join(
        f"{aa}:{counts[aa] / len(seqs):.2%}"
        for aa in AMINO_ACIDS
    ))

total = Counter("".join(seqs))
total_residues = sum(total.values())

print("\nOverall:")
for aa in AMINO_ACIDS:
    print(f"{aa}: {total[aa] / total_residues:.2%}")