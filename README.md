# cobit

kobitoがMacOS以外に移植されるのがまだ先だということなので作ってみました。

kobitoと違うのは自分の好きなエディタを選べるということです。

ただし、ウィンドウを2枚開かないといけないですが…

あと、表示の更新は保存時です。すいません…

とりあえず、保存すると編集内容がブラウザに自動で同期されるというだけです。

CSSは適当なものを設定しているので、Qiitaと同じ表示にないと思います。だれかいいもの教えてください。

## インストール

> git clone https://github.com/youchan/cobit.git

> bundle install

## 使い方

> ruby cobit.rb

で起動して、ブラウザで
[http://localhost:4567/](http://localhost:4567/)
にアクセスしてください。

あとはお好きなエディタでdataディレクトリ内にxxx.mdファイルを作成し編集して保存するとブラウザ上の表示が更新されます。


## TODO

- Qiitaに投稿するが実装されていません。
- ファイルの新規作成に対応していません。
 - dataディレクトリ内でファイルを作成してください。

