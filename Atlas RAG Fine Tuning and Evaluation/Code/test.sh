#!/bin/bash
#SBATCH --mail-user=meeratresa.sebastian@sjsu.edu
#SBATCH --mail-user=/dev/null
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --job-name=gpuTest_016592784
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
EVAL_FILES="${DATA_DIR}/mmlu_data/test.jsonl"
SAVE_DIR=/scratch/cmpe259-fa23/016592784/experiments/output
EXPERIMENT_NAME="my_100_shot_rerank_1000_mmlu_eval"


size=large
PRETRAINED_MODEL=${SAVE_DIR}/my_100_shot_exp_rerank_1000total/checkpoint/latest
PRECISION="fp32"


srun python evaluate.py \
    --name ${EXPERIMENT_NAME} \
    --generation_max_length 16 \
    --gold_score_mode "pdist" \
    --precision  ${PRECISION} \
    --reader_model_type google/t5-${size}-lm-adapt \
    --text_maxlength 512 \
    --model_path ${PRETRAINED_MODEL} --eval_data  ${DATA_DIR}/mmlu_data/test.jsonl --per_gpu_batch_size 1 \
    --n_context 40 --retriever_n_context 40 \
    --checkpoint_dir ${SAVE_DIR} \
    --main_port $port \
    --index_mode "flat"  \
    --task "multiple_choice" \
    --passages "/home/016592784/atlas/atlas_data/mmlu_data/unified_passages.jsonl" \
    --write_results \
    --multiple_choice_eval_permutations all
