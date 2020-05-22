#
# By Hogenimushi
#
PYTHON=python3
SIMULATOR=./DonkeySimLinux/donkey_sim.x86_64

#START_20HZ  = $(shell find data_20Hz -name 'start*' -type d | tr '\n' ' ')
#LAP_20HZ    = $(shell find data_20Hz -name 'lap*' -type d | tr '\n' ' ')
#nOTHERS_20HZ = data_20Hz/right_001 data_20Hz/left_001 data_20Hz/middle_001
#GEN_20HZ    = $(shell find data_generated_20Hz -type d | sed -e '1d' | tr '\n' ' ')

#DATASET_20HZ = $(START_20HZ) $(LAP_20HZ) $(OTHERS_20HZ) $(GEN_20HZ)

#START_10HZ  = $(shell find data_10Hz -name 'start*' -type d | tr '\n' ' ')
#LAP_10HZ    = $(shell find data_10Hz -name 'lap*'   -type d | tr '\n' ' ')
#OTHERS_10HZ = data_10Hz/slow_01 
#GEN_10HZ    = $(shell find data_generated_10Hz      -type d | sed -e '1d' | tr '\n' ' ')
#ALL_10HZ    = $(START_10HZ) $(LAP_10HZ) $(OTHERS_10HZ) $(GEN_10HZ)

DATASET_10Hz = $(shell find data_10Hz -type d | sed -e '1d' | tr '\n' ' ')
DATASET_05Hz = $(shell find data_05Hz -type d | sed -e '1d' | tr '\n' ' ')

DATASET = $(shell find data -type d | sed -e '1d' | tr '\n' ' ')
START = $(shell find data_10Hz -name 'start*' -type d | tr '\n' ' ')
PRE = $(shell find data_10Hz -name 'pre*' -type d | tr '\n' ' ')
DAKOU = $(shell find data_10Hz -name 'dakou' -type d | tr '\n' ' ')
DATASET_LINEAR = $(DATASET) $(START) $(PRE) $(DAKOU)
DATASET_SEQ2 = $(DATASET) $(START) $(PRE) $(DAKOU)
DATASET_SEQ3 = $(DATASET) $(START) $(PRE) $(DAKOU)

COMMA=,
EMPTY=
SPACE=$(EMPTY) $(EMPTY)
DATASET_SLOW_ARG=$(subst $(SPACE),$(COMMA),$(DATASET_SLOW))


none:
	@echo "Argument is required."

sim:
	$(SIMULATOR) &
	@echo "Lounching simulator..."

run: prebuilt/default.h5
	$(PYTHON) manage.py drive --model=$< --type=rnn --myconfig=configs/myconfig_10Hz.py

run_linear: prebuilt/linear.h5
	$(PYTHON) manage.py drive --model=$< --type=linear --myconfig=configs/myconfig_10Hz.py

run_seq2: prebuilt/seq2.h5
	$(PYTHON) manage.py drive --model=$< --type=rnn --myconfig=configs/myconfig_10Hz_seq2.py

run_seq3: prebuilt/seq3.h5
	$(PYTHON) manage.py drive --model=$< --type=rnn --myconfig=configs/myconfig_10Hz_seq3.py

race: prebuilt/default.h5
	$(PYTHON) manage.py drive --model=$< --type=rnn --myconfig=configs/race_10Hz.py

train:
	make models/default.h5

prebullt/default.h5: models/default.h5
	cp $< $@

record: record10

record05:
	$(PYTHON) manage.py drive --js --myconfig=configs/myconfig_05Hz.py

record10:
	$(PYTHON) manage.py drive --js --myconfig=configs/myconfig_10Hz.py

record20:
	$(PYTHON) manage.py drive --js --myconfig=configs/myconfig_20Hz.py


models/default.h5: $(DATASET_10Hz)
	TF_FORCE_GPU_ALLOW_GROWTH=true $(PYTHON) manage.py train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=rnn --myconfig=configs/myconfig_10Hz.py

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

dakoumigi_001:
	$(PYTHON) scripts/trimming.py --input data_10Hz/dakoumigi_001 --output data/dakoumigi_001 --file data_10Hz/dakoumigi_001.txt

sayu:
	make right
	make left

right:
	$(PYTHON) scripts/trimming.py --input data_10Hz/right_001/ --output data/trimright --num 579 1675

left:
	$(PYTHON) scripts/trimming.py --input data_10Hz/left_001/ --output data/trimleft --num 571 1734

models/linear.h5: $(DATASET_LINEAR)
	TF_FORCE_GPU_ALLOW_GROWTH=true $(PYTHON) manage.py train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=linear --myconfig=configs/myconfig_10Hz.py

models/seq2.h5: $(DATASET_SEQ2)
	TF_FORCE_GPU_ALLOW_GROWTH=true $(PYTHON) manage.py train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=rnn --myconfig=configs/myconfig_10Hz_seq2.py

models/seq3.h5: $(DATASET_SEQ3)
	TF_FORCE_GPU_ALLOW_GROWTH=true $(PYTHON) manage.py train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=rnn --myconfig=configs/myconfig_10Hz_seq3.py

dataset:
	make kabe
	make sayu
	make dakou
