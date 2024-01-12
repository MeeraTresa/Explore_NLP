This file contains information related to the folder structure that's being submitted as a part of the deliverable code.

1) scripts
This folder contains the scripts used by the team members to run their respective experiments.
/scripts/Ankita/
	- mmlu-full.sh: This script contains the basic code to train the model. The current parameters are the ones that are used to train our best model which gave the eval accuracy of 92%. I used this script to modify different parameters and run again using testscr.sh.
	- mmlu_eval.sh: This script contains the basic code to test/evaluate the model. The current parameters are the ones that are used to evaluate our best model which gave the eval accuracy of 92%.
	- testscr.sh: This script is created to run the train/test script. Since there were common errors related to CUDA because of which it was difficult to get access to GPU, I created this script which keeps checking if the CUDA is available or not. If CUDA is available or no Pytorch error occurs, it will start executing the train/test script but if the CUDA error occurs, it will delete the current erroneous logs, wait for few seconds and try again. This will continue until the GPU is acquired to run the script.


2) logs
logs/mcq_case_10: This folder contains the results of our most optimal model. I have removed other folders and only kept 3 files:
	- run.log - contains all the information related to the model and hyperparameters as well as accuracy, debiased accuracy and eval_loss.
	- gpuTest_33642.out - It has a similar content to run.log file and contains all the information related to the model and the hyperparameters used to train our most optimal model.
	- eval_data_50-step-990.jsonl - This is the latest output file generated for our most optimal model. The file contains the query, all the retrieved passages based on the similarity, choice_probs and choice_logits. 

3) team3_dataset
This folder contains the dataset created by the team for dataset curation assignment along with datasets used to run various experiments by all team members in their respective folders.
	- team3_dataset/Ankita/case_2/: This folder contains the dataset used for creating the most optimal model.
