#omsaisasisankararao omsaisasisankararao omsaisasisankararao omsaisasisankararao omsaisasisankararao omsaisasisankararao omsaisasisankararao omsaisasisankararao omsaisasisankararao omsaisasisankararao omsaisasisankararao omsaisasisankararao omsaisasisankararao omsaisasisankararao omsaisasisankararao


#######   CTC feature extraction    ########

#!/usr/bin/bash


######    Data preparation   #######################

######   MFCC feature extraction   ########################

. ./path.sh
. ./cmd.sh
source  ~/.bashrc
dir=/scratch/tirusha.mandava/data_preparation_stuff
mkdir -p $dir
stage=1
#utils/subset_data_dir_tr_cv.sh --cv-spk-percent 5 data/train data/train_tr95 data/train_cv05 || exit 1


####   Data preparation folder in kaldi format using wavefiles in text file ########

bash Data_folder_creation_kaldi_format.sh test test_folder_kaldi_format

if [ $stage -le 1 ]; then
mfcc_dir=mfcc
for set in test_folder_kaldi_format; do
    steps/make_mfcc.sh --mfcc-config conf/mfcc_hires.conf --cmd "$train_cmd" --nj 1 $set exp/make_mfcc/$set $mfcc_dir || exit 1;
    utils/fix_data_dir.sh $set || exit;
    steps/compute_cmvn_stats.sh $set exp/make_mfcc/$set $mfcc_dir || exit 1;
done
fi

if [ $stage -le 2 ]; then
##----------------      Adding Deltas to the MFCC features     ---------------------##
bash utils/kaldi_feature_extract_mfcc_delta.sh test_folder_kaldi_format $dir/delta_train
bash utils/fextract_new.sh $dir/delta_train $dir/train_text_files
fi




##################               CTC feature extraction    ########################


python utils/LSTMP_decoding_without_langid.py $dir/train_text_files/ epoch_21_sample_19770_12.9235725403___10.4016637802 sample







