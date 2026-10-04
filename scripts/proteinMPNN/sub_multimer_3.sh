#!/usr/bin/env bash
#
#SBATCH --job-name=sub_multimer_3
#SBATCH --mail-user=holla653@umn.edu
#SBATCH --mail-type=FAIL
#SBATCH --output=sub_multimer_3_%j_.txt
#SBATCH --partition=msismall
#SBATCH --time=00:30:00
#SBATCH --mem=32g
#SBATCH --ntasks=4

pdb_path="/users/3/holla653/Code/RosettaBootcamp/input/proteinMPNN/HCV_input/HCV_E1E2_AF2.pdb"
folder_with_pdbs="/users/3/holla653/Code/RosettaBootcamp/input/proteinMPNN/HCV_input"
output_dir="/users/3/holla653/Code/RosettaBootcamp/output/proteinMPNN/multimer_run_3"
model_dir="/users/3/holla653/Code/ProteinMPNN/vanilla_model_weights"
model_name="v_48_020"


if [ ! -d $output_dir ]
then
    mkdir -p $output_dir
fi

path_for_parsed_chains=$output_dir"/parsed_pdbs.jsonl"
path_for_assigned_chains=$output_dir"/assigned_pdbs.jsonl"
path_for_fixed_positions=$output_dir"/fixed_pdbs.jsonl"

chains_to_design="B"
fixed_positions="25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43"

cd /users/3/holla653/Code/ProteinMPNN

python "helper_scripts/parse_multiple_chains.py" --input_path=$folder_with_pdbs --output_path=$path_for_parsed_chains

python "helper_scripts/assign_fixed_chains.py" --input_path=$path_for_parsed_chains --output_path=$path_for_assigned_chains --chain_list "$chains_to_design"

python "helper_scripts/make_fixed_positions_dict.py" --input_path=$path_for_parsed_chains --output_path=$path_for_fixed_positions --chain_list "$chains_to_design" --position_list "$fixed_positions"

python /users/3/holla653/Code/ProteinMPNN/protein_mpnn_run.py \
        --jsonl_path $path_for_parsed_chains \
        --chain_id_jsonl $path_for_assigned_chains \
        --fixed_positions_jsonl $path_for_fixed_positions \
        --pdb_path $pdb_path \
        --pdb_path_chains "$chains_to_design" \
        --out_folder $output_dir \
        --num_seq_per_target 10 \
        --sampling_temp "0.2" \
        --omit_AAs "CHX" \
        --seed 68 \
        --path_to_model_weights $model_dir \
        --model_name $model_name \
