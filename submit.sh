#!/bin/bash
#
#SBATCH -p gentzkow,hns,normal
#SBATCH --job-name=Task2
#SBATCH --time=10:00                  
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --mail-user=wernerd@stanford.edu                         
#SBATCH --mail-type=ALL

# Load any needed modules
module load R/4.4.2
module load texlive  

# Run your main script
srun bash run_all.sh
