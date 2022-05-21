# サンプルクエリ

## 任意の時間のデータを抽出して永続化させたい

BigQueryは7日前まででしたらば、FOR SYSTEM_TIME AS OFを使うことで任意の時間のデータを取り出せる

これをCREATE TABLE と組み合わせることで、任意の時間のデータを抽出して永続化させることが可能

```
CREATE TABLE example_dataset.example_destination
AS
SELECT *
FROM example_dataset.example_table
  FOR SYSTEM_TIME AS OF TIMESTAMP("2021-09-16 05:00:00+0900")
```


## 時間のイメージなくバックアップを取りたい

```
CREATE TABLE example_dataset.example_destination
CLONE example_dataset.example_table
```
