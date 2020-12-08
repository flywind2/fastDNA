# -----------------
# File Paths
# -----------------

# Path to bifrost executable
bifrost=../../bifrost/build/src/Bifrost

data_path="data"
output_path="output/models"

mkdir -p $output_path

train_dataset="$data_path/train/A1.train.fasta"
train_labels="$data_path/train/A1.train.taxid"
test_dataset="$data_path/test/A1.test.fasta"
test_labels="$data_path/test/A1.test.taxid"
db=A1

fastdna=../fastdna

threads=4 # number of threads for training
d=10 # embedding dimension
k=1 # k-mer length
K=13 # long k-mer length
e=1 # number of epochs
L=100 # training read length,

model_name="fdna_K${K}_d${d}_e${e}"
model_path="$output_path/$model_name"
index="$output_path/bifrost_graph_$db_$K"

# Build the compacted De Bruijn graph
# echo "Building the De Bruijn graph $index"
# $bifrost build -t 4 -k $K -o $index -r $train_dataset

# Train a supervised model
echo "Training model $model_name"
$fastdna supervised -input $train_dataset -labels $train_labels -output $model_path -minn $k -dim $d -epoch $e -thread $threads -loadIndex ${index}.gfa

# Test the model
echo "Testing model $model_name"
$fastdna test $model_path.bin $test_dataset $test_labels ${index}.gfa
