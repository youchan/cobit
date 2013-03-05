# cobit

kobitoがMacOS以外に移植されるのがまだ先だということなので作ってみました。

kobitoと違うのは自分の好きなエディタを選べるということです。

ただし、ウィンドウを2枚開かないといけないですが…

あと、表示の更新は保存時です。すいません…

とりあえず、保存すると編集内容がブラウザに自動で同期されるというだけです。

CSSも設定していないので、ちゃんとQiitaと同じ表示になりません。

とりあえず、コミットしましたって感じです。すいません…

## インストール
a
alks
sinatra
> gem install sinatra

sinatra CometIO
> gem install sinatra-cometio

redcarpet
> gem install redcarpet

fssm
> gem install fssm

## 使い方

> ruby cobit.rb _&lt;filename&gt;_

で起動して、ブラウザで
[http://localhost:4567/](http://localhost:4567/)
にアクセスしてください。

あとはお好きなエディタでファイルを編集し保存するとブラウザ上の表示が更新されます。