# Manage resources

## 概要

GCP は `組織` を作ることが出来、組織の配下に `フォルダ` を作ることが出来ます

GCP リソースを実際に運用するのは、大抵は Google Cloud Project の中です(組織に紐づくリソースもあります)

Google Cloud Project は `組織` の直下、もしくは `フォルダ` の配下に配置することが出来ます

`組織` を作らないと `フォルダ` も作れません。この場合は `野良の` Google Cloud Project となります

## 公式ドキュメントおよびイメージ

[Resource hierarchy (リソース階層)](https://cloud.google.com/resource-manager/docs/cloud-platform-resource-hierarchy)

[Creating and managing Folders (フォルダの作成と管理)](https://cloud.google.com/resource-manager/docs/creating-managing-folders)


[Google Cloud ランディング ゾーンのリソース階層を決定する](https://cloud.google.com/architecture/landing-zones/decide-resource-hierarchy)

![](https://cloud.google.com/resource-manager/img/cloud-folders-hierarchy.png)

## Tips

- おすすめの Role について
  - [./recommend-role](./recommend-role/README.md)
- フォルダについて
  - TBD
- プロジェクトについて
  - [./project](./project/README.md)
  