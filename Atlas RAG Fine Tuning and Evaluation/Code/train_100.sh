#!/bin/bash
#SBATCH --mail-user=meeratresa.sebastian@sjsu.edu
#SBATCH --mail-user=/dev/null
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --job-name=gpuAtlas_016592784
#SBATCH --output=gpuTest_%j.out
#SBATCH --error=gpuTest_%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=48:00:00     
##SBATCH --mem-per-cpu=2000
##SBATCH --gres=gpu:p100:1
#SBATCH --partition=gpu   

# on coe-hpc1 cluster load
# module load python3/3.8.8
#
# on coe-hpc2 cluster load:
module load python-3.10.8-gcc-11.2.0-c5b5yhp slurm
source /home/016592784/atlas/venv/bin/activate

export http_proxy=http://172.16.1.2:3128; export https_proxy=http://172.16.1.2:3128

cd /home/016592784/atlas

DATA_DIR=/home/016592784/atlas/atlas_data
port=$(shuf -i 15000-16000 -n 1)
TRAIN_FILE="${DATA_DIR}/mmlu_data/train_100.jsonl"
EVAL_FILES="${DATA_DIR}/mmlu_data/dev.jsonl"
TEST_FILES="${DATA_DIR}/mmlu_data/test.jsonl"
SAVE_DIR=/scratch/cmpe259-fa23/016592784/experiments/output
EXPERIMENT_NAME=my_100_shot_exp_rerank_1000total
TRAIN_STEPS=30
TOTAL_STEPS=1000
size=large
PRETRAINED_MODEL=${DATA_DIR}/models/atlas/${size}
PRECISION="fp32"
python3 /home/016592784/atlas/train.py \
        --shuffle  --train_retriever  --gold_score_mode pdist   \
        --use_gradient_checkpoint_reader \
        --use_gradient_checkpoint_retriever  \
        --precision ${PRECISION}   \
        --shard_optim --shard_grads   \
        --temperature_gold 0.01   \
        --refresh_index -1   \
        --query_side_retriever_training  \
        --retrieve_with_rerank \
        --target_maxlength 16   \
        --reader_model_type google/t5-${size}-lm-adapt \
        --dropout 0.1 --weight_decay 0.01 --lr 4e-5 --lr_retriever 4e-5 \
        --scheduler linear   \
        --text_maxlength 256   \
        --model_path ${PRETRAINED_MODEL} \
        --train_data ${TRAIN_FILE}   \
        --eval_data ${EVAL_FILES}   \
        --per_gpu_batch_size 1  \
        --n_context 40   \
        --retriever_n_context 40  \
        --name ${EXPERIMENT_NAME}   \
        --checkpoint_dir ${SAVE_DIR}   \
        --eval_freq  ${TRAIN_STEPS}    --log_freq 4   \
        --total_steps ${TOTAL_STEPS}   \
        --warmup_steps 5  --save_freq ${TRAIN_STEPS}   \
        --main_port $port   --write_results   \
        --task multiple_choice   \
        --multiple_choice_train_permutations all \
        --multiple_choice_eval_permutations all  \
        --index_mode flat   \
        --passages "/home/016592784/atlas/atlas_data/mmlu_data/unified_passages.jsonl"  \
        --save_index_path ${SAVE_DIR}/${EXPERIMENT_NAME}/saved_index \
        --save_index_n_shards 1

