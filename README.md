# mental-fatigue-study
This is the repository accompanying the paper 'Mental fatigue has only marginal effects on static balance control in healthy young adults'.

-------------------------------------------------------------------------------------------------

Title: Mental Fatigue has only marginal effects on static balance control in healthy young adults

Authors: Kerstin Weissinger1, Margit Midtgaard Bach1, Anna Brachmann2, John F. Stins1, and Peter Jan Beek1

1 Department of Human Movement Sciences, Faculty of Behavioural and Movement Sciences, Institute of Brain and Behavior Amsterdam & Amsterdam Movement Sciences, Vrije Universiteit Amsterdam, Netherlands
2 Institute of Sport Sciences, Department of Biomechanics, The Jerzy Kukuczka Academy of Physical Education, Katowice, Poland.

-------------------------------------------------------------------------------------------------

The codes were written by Kerstin Weissinger and Margit Midtgaard Bach
Last update: 27.06.2023

In the data analysis 43 subjects (i.e., 21 experimental and 22 contorol subjects) were analysed.

Files
------

** 'Data' folder **		
Consists of .txt files containing 
(1) Descriptives and general information (Descriptives.txt), incl. group, gender, age, sleep quality and quanity per session.

(1) AVA scale outcomes (AVASscales.txt) of all 43 participants.
rows 2-22: experimental subjects; rows 23-44: control subjects
column 1: subj. MF-levels VAS post intervention; column 2: rel. change in MF-levels post intervention
	
(2) Raw COP time-series data of each participant respectively.
File name coding: Each paticipant was assigned a combination of a letter and a number. The letter represents the group, i.e., experimental (E) and control (C) subject, while the number represents their specific participant number within that group (e.g. E5 = 5th participant in experimental group).  

Each file holds the COP time-series before (pre) and after (post) the intervention in mediolateral (x) and anteriorposterior (y) direction for each of the 6 balance tasks respectively. Each balance task was assigned a specific number-code, i.e., 1 = hip-broad stance eyes open, 2 = hip-broad stance eyes closed, 3 = hip-broad stance dual task, 4 = tandem stance eyes open, 5 = tandem stance eyes closed, 6 = tandem stance dual task

Structure of table: 
rows 2-22: experimental subjects; rows 23-44: control subjects
columns: (:,1:6) x_pre_#, (:, 7:12) y_pre_#, (:, 13:18) x_post_#, (:,19:24) y_post_# for all 6 (#) balance tasks. (e.g.: x_pre_1 = mediolat. COP before the intervention for task 1)

			    
** main_script.mat **
Main MATLAB script: Please run this script to reproduce our outcome measures and figures from the article.
The Main_script.mat, calls the raw COP time-series data from the 'Data' folder, processes them, and calculates the defined outcome measures. 
All needed functions, will be called automatically.  


** outcomes.mat **
Function for data processing (e.g. filtering) the raw data and calculating the outcome measures. 
Output: sway variability, mean speed, sample entropy


** sampen.mat **
Function for calculating sample entropy (is called by outcomes.mat)
Please note, this function was provided by Víctor Martínez-Cagigal (2018), and was downloaded from:		
https://nl.mathworks.com/matlabcentral/fileexchange/69381-sample-entropy
For the purpose of our study some marginal changes were applied (for using different sets of parameters simultaneously).
Output: sample entropy values using Lake et al.'s and Montesinos et al.'s method


** winsorizing.mat **
Function for winsorizing the outcome measures (is called by outcomes.mat)
Output: winsorized sway variability, mean speed, and sample entropy values


** changescores.mat **
Function for calculating the change scores from the winsorized data
