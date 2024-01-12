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
EXPERIMENT_NAME=my_zeroshot_base_mmlu_exp
TRAIN_STEPS=30

size=base
PRETRAINED_MODEL=${DATA_DIR}/models/atlas/${size}
PRECISION="fp32"


srun python evaluate.py \
    --precision ${PRECISION} \
    --target_maxlength 16 \
    --reader_model_type google/t5-${size}-lm-adapt \
    --text_maxlength 512 \
    --model_path ${PRETRAINED_MODEL} \
    --eval_data ${EVAL_FILES} \
    --per_gpu_batch_size 1 \
    --n_context 30 --retriever_n_context 30 \
    --name ${EXPERIMENT_NAME} \
    --checkpoint_dir ${SAVE_DIR} \
    --main_port $port \
    --write_results \
    --task "multiple_choice" \
    --multiple_choice_eval_permutations all\
    --index_mode "flat" \
    --passages "/home/016592784/atlas/atlas_data/mmlu_data/unified_passages.jsonl" 
