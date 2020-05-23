# vdc2020_race02
Dataset for virtual donkey car race #2


BinaryはDonkeySimLinuxに入れてくらさい．

# 学習の仕方
1. make clean でmodelsとdataディレクトリの中を初期化します
2. make dataset　でdata_10Hzから一部のデータの抽出を行います
3. make models/main_linear.h5　でmodels/main_linear.5に学習結果が出力されます

# 推論走行の仕方
1. 各々のdonkey仮想環境に入ります
2. make race_linear でDonkeySimLinuxが立ち上がり、推論走行がはじまります！
