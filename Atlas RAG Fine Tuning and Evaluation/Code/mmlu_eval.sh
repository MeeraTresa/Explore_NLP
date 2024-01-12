#!/bin/bash
#SBATCH --mail-user=ankitaarvind.deshmukh@sjsu.edu
#SBATCH --mail-user=/dev/null
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --job-name=gpuTest_061029585
#SBATCH --output=gpuTest_%j.out
#SBATCH --error=gpuTest_%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=48:00:00     
##SBATCH --mem-per-cpu=2000
##SBATCH --gres=gpu:p100:1
#SBATCH --partition=gpu

module load python-3.10.8-gcc-11.2.0-c5b5yhp slurm
export http_proxy=http://172.16.1.2:3128; export https_proxy=http://172.16.1.2:3128

cd /home/016029585/atlas
source /home/016029585/myenv2/bin/activate

BASE_INPUT_DATA_DIR="/home/016029585/atlas/unified_data"
INPUT_DATA_DIR="${BASE_INPUT_DATA_DIR}/case_2"
OUTPUT_DATA_DIR="/home/016029585/atlas/atlas_data"
port=$(shuf -i 15000-16000 -n 1)
TRAIN_FILE="${INPUT_DATA_DIR}/train_data_150.jsonl"
EVAL_FILE="${INPUT_DATA_DIR}/eval_data_50.jsonl"
PASSAGES_FILE="/home/016029585/atlas/unified_data/unified_passages.jsonl"
SAVE_DIR=${OUTPUT_DATA_DIR}/experiments/mcq_case_10
SAVE_DIR_EVAL=${OUTPUT_DATA_DIR}/experiments/mcq_case_10_eval
EXPERIMENT_NAME="mcq_train_10"
EVAL_EXPERIMENT_NAME="mcq_eval_10"
SIZE=large
MODEL_DIR="${OUTPUT_DATA_DIR}/models/atlas/${SIZE}/"
N_CONTEXT=30
TRAIN_STEPS=30
PRECISION="fp32"

PYTORCH_CUDA_ALLOC_CONF="max_split_size_mb:512"

python3 evaluate.py \
    --name "${EVAL_EXPERIMENT_NAME}" \
    --generation_max_length 200 \
    --gold_score_mode "pdist" \
    --precision ${PRECISION} \
    --reader_model_type google/t5-${SIZE}-lm-adapt \
    --text_maxlength 256 \
    --model_path ${SAVE_DIR}/${EXPERIMENT_NAME}/checkpoint/latest \
    --eval_data ${EVAL_FILE} \
    --per_gpu_batch_size 1 \
    --n_context ${N_CONTEXT} --retriever_n_context ${N_CONTEXT} \
    --checkpoint_dir ${SAVE_DIR_EVAL} \
    --main_port $port \
    --index_mode "flat" \
    --task "multiple_choice" \
    --passages "${PASSAGES_FILE}" \
    --save_index_path ${SAVE_DIR}/${EVAL_EXPERIMENT_NAME}/saved_index \
    --write_results \
    --multiple_choice_eval_permutations all