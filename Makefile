#
# By Hogenimushi
#
PYTHON=python3
SIMULATOR=./DonkeySimLinux/donkey_sim.x86_64

DATASET_10Hz = $(shell find data_10Hz -type d | sed -e '1d' | tr '\n' ' ')
DATASET_05Hz = $(shell find data_05Hz -type d | sed -e '1d' | tr '\n' ' ')

MAIN_DATASET = $(shell find data -type d | sed -e '1d' | tr '\n' ' ')
MAIN_START = $(shell find data_10Hz -name 'start*_v3' -type d | tr '\n' ' ')
MAIN_PRE = $(shell find data_10Hz -name 'pre_*' -type d | tr '\n' ' ')
MAIN_LAP = $(shell find data_10Hz -name 'lap_*' -type d | tr '\n' ' ')
#MAIN_DAKOU = $(shell find data_10Hz -name 'dakou' -type d | tr '\n' ' ')

DATASET_LINEAR = $(MAIN_DATASET) $(MAIN_START) $(MAIN_PRE) $(MAIN_LAP) 
DATASET_SEQ2 = $(DATASET_LINEAR)
DATASET_SEQ3 = $(DATASET_LINEAR) 

SUB_DAKOU = $(shell find data -type d -name 'dakou*' |  tr '\n' ' ')
SUB_LR    = $(shell find data -type d -name 'trim*' |  tr '\n' ' ')

DATASET_SUB = $(SUB_DAKOU) $(SUB_LR) $(MAIN_START) $(MAIN_LAP) 


COMMA=,
EMPTY=
SPACE=$(EMPTY) $(EMPTY)
DATASET_SLOW_ARG=$(subst $(SPACE),$(COMMA),$(DATASET_SLOW))


none:
	@echo "Argument is required."

sim:
	$(SIMULATOR) &
	@echo "Lounching simulator..."

run_linear: prebuilt/linear.h5
	$(PYTHON) manage.py drive --model=$< --type=linear --myconfig=configs/myconfig_10Hz.py

run_seq2: prebuilt/seq2.h5
	$(PYTHON) manage.py drive --model=$< --type=rnn --myconfig=configs/myconfig_10Hz_seq2.py

run_seq3: prebuilt/seq3.h5
	$(PYTHON) manage.py drive --model=$< --type=rnn --myconfig=configs/myconfig_10Hz_seq3.py

local_seq3: prebuilt/seq3.h5
	$(PYTHON) manage.py drive --model=$< --type=rnn --myconfig=configs/local_10Hz_seq3.py

race: prebuilt/seq3.h5
	$(PYTHON) manage.py drive --model=$< --type=rnn --myconfig=configs/race_10Hz_seq3.py


record: record10

record05:
	$(PYTHON) manage.py drive --js --myconfig=configs/myconfig_05Hz.py

record10:
	$(PYTHON) manage.py drive --js --myconfig=configs/myconfig_10Hz.py

record20:
	$(PYTHON) manage.py drive --js --myconfig=configs/myconfig_20Hz.py



# This shows how to use trim
trim_crash_001:
	$(PYTHON) scripts/trimming.py --input data_20Hz/crash_001 --output data_generated_20Hz/crash_001 --file data_20Hz/crash_001_trim.txt

clean:
	rm -fr models/*
	rm -rf data/*

install: 
	make DonkeySimLinux/donkey_sim.x86_64

DonkeySimLinux/donkey_sim.x86_64:
	wget -qO- https://github.com/tawnkramer/gym-donkeycar/releases/download/v2020.5.16/DonkeySimLinux.zip | bsdtar -xvf - -C .

kabe:
	make kabe_001
	make kabe_002
	make kabe_003
	make kabe_004
kabe_001:
	$(PYTHON) scripts/trimming.py --input data_10Hz/kabe_001 --output data/kabe_001 --file data_10Hz/kabe_001.txt

kabe_002:
	$(PYTHON) scripts/trimming.py --input data_10Hz/kabe_002 --output data/kabe_002 --file data_10Hz/kabe_002.txt

kabe_003:
	$(PYTHON) scripts/trimming.py --input data_10Hz/kabe_003 --output data/kabe_003 --file data_10Hz/kabe_003.txt

kabe_004:
	$(PYTHON) scripts/trimming.py --input data_10Hz/kabe_004 --output data/kabe_004 --file data_10Hz/kabe_004.txt

dakou:
	make dakoumigi_001
	make dakoumigi_002
	make dakoumigi_003
	make dakoumigi_004
	make dakoumigi_005
	make dakouhidari_001
	make dakouhidari_002
	make dakouhidari_003
	make dakouhidari_004

dakoumigi_001:
	$(PYTHON) scripts/trimming.py --input data_10Hz/dakoumigi_001 --output data/dakoumigi_001 --file data_10Hz/dakoumigi_001.txt

dakoumigi_002:
	$(PYTHON) scripts/trimming.py --input data_10Hz/dakoumigi_002 --output data/dakoumigi_002 --file data_10Hz/dakoumigi_002.txt

dakoumigi_003:
	$(PYTHON) scripts/trimming.py --input data_10Hz/dakoumigi_003 --output data/dakoumigi_003 --file data_10Hz/dakoumigi_003.txt

dakoumigi_004:
	$(PYTHON) scripts/trimming.py --input data_10Hz/dakoumigi_004 --output data/dakoumigi_004 --file data_10Hz/dakoumigi_004.txt

dakoumigi_005:
	$(PYTHON) scripts/trimming.py --input data_10Hz/dakoumigi_005 --output data/dakoumigi_005 --file data_10Hz/dakoumigi_005.txt

dakouhidari_001:
	$(PYTHON) scripts/trimming.py --input data_10Hz/dakouhidari_001 --output data/dakouhidari_001 --file data_10Hz/dakouhidari_001.txt

dakouhidari_002:
	$(PYTHON) scripts/trimming.py --input data_10Hz/dakouhidari_002 --output data/dakouhidari_002 --file data_10Hz/dakouhidari_002.txt

dakouhidari_003:
	$(PYTHON) scripts/trimming.py --input data_10Hz/dakouhidari_003 --output data/dakouhidari_003 --file data_10Hz/dakouhidari_003.txt

dakouhidari_004:
	$(PYTHON) scripts/trimming.py --input data_10Hz/dakouhidari_004 --output data/dakouhidari_004 --file data_10Hz/dakouhidari_004.txt
sayu:
	make right
	make left

right:
	$(PYTHON) scripts/trimming.py --input data_10Hz/right_001/ --output data/trimright --file data_10Hz/trimright.txt

left:
	$(PYTHON) scripts/trimming.py --input data_10Hz/left_001/ --output data/trimleft --file data_10Hz/trimleft.txt

models/linear.h5: $(DATASET_LINEAR)
	TF_FORCE_GPU_ALLOW_GROWTH=true $(PYTHON) manage.py train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=linear --myconfig=configs/myconfig_10Hz.py

models/seq2.h5: $(DATASET_SEQ2)
	TF_FORCE_GPU_ALLOW_GROWTH=true $(PYTHON) manage.py train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=rnn --myconfig=configs/myconfig_10Hz_seq2.py

models/seq3.h5: $(DATASET_SEQ3)
	TF_FORCE_GPU_ALLOW_GROWTH=true $(PYTHON) manage.py train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=rnn --myconfig=configs/myconfig_10Hz_seq3.py

models/main.h5: $(DATASET_MAIN)
	TF_FORCE_GPU_ALLOW_GROWTH=true $(PYTHON) manage.py train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=rnn --myconfig=configs/myconfig_10Hz_seq3.py

models/sub.h5: $(DATASET_SUB)
	TF_FORCE_GPU_ALLOW_GROWTH=true $(PYTHON) manage.py train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=rnn --myconfig=configs/myconfig_10Hz_seq3.py

models/main4.h5: $(DATASET_MAIN)
	TF_FORCE_GPU_ALLOW_GROWTH=true $(PYTHON) manage.py train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=rnn --myconfig=configs/myconfig_10Hz_seq4.py


dataset:
	make kabe
	make sayu
	make dakou
