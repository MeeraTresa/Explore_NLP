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
SIZE=large
MODEL_DIR="${OUTPUT_DATA_DIR}/models/atlas/${SIZE}/"

port=$(shuf -i 15000-16000 -n 1)
TRAIN_FILE="${INPUT_DATA_DIR}/train_data_150.jsonl"
EVAL_FILE="${INPUT_DATA_DIR}/eval_data_50.jsonl"
PASSAGES_FILE="/home/016029585/atlas/unified_data/unified_passages.jsonl"
SAVE_DIR="${OUTPUT_DATA_DIR}/experiments/mcq_case_10"
EXPERIMENT_NAME="mcq_train_10"
TRAIN_STEPS=30
PRECISION="fp32"
N_CONTEXT=30
PYTORCH_CUDA_ALLOC_CONF="max_split_size_mb:512"

python3 /home/016029585/atlas/train.py \
    --shuffle \
    --train_retriever --gold_score_mode pdist \
    --use_gradient_checkpoint_reader \
    --use_gradient_checkpoint_retriever\
    --precision ${PRECISION} \
    --shard_optim --shard_grads \
    --temperature_gold 0.1 --temperature_score 0.1 \
    --refresh_index -1 \
    --target_maxlength 200 \
    --reader_model_type google/t5-${SIZE}-lm-adapt \
    --dropout 0.1 \
    --lr 4e-5 \
    --lr_retriever 4e-5 \
    --scheduler linear \
    --weight_decay 0.05 \
    --text_maxlength 256 \
    --model_path ${MODEL_DIR} \
    --train_data ${TRAIN_FILE} \
    --eval_data ${EVAL_FILE} \
    --per_gpu_batch_size 1 \
    --n_context ${N_CONTEXT} \
    --retriever_n_context ${N_CONTEXT} \
    --name ${EXPERIMENT_NAME} \
    --checkpoint_dir ${SAVE_DIR} \
    --eval_freq ${TRAIN_STEPS} \
    --log_freq 4 \
    --total_steps 1000 \
    --warmup_steps 5 \
    --save_freq ${TRAIN_STEPS} \
    --main_port $port \
    --write_results \
    --task multiple_choice \
    --multiple_choice_train_permutations all\
    --multiple_choice_eval_permutations cyclic\
    --index_mode flat \
    --query_side_retriever_training \
    --passages "${PASSAGES_FILE}" \
    --save_index_path ${SAVE_DIR}/${EXPERIMENT_NAME}/saved_index \
    --max_passages -1 \
    --save_index_n_shards 1 