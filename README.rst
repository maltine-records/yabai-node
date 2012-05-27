============================
YABAI Button in CoffeeScript
============================

Base Components
===============

- http://nodejs.org/

  - http://npmjs.org/

    - http://coffeescript.org/

- http://redis.io/

Node Modules
============

install w/ npm

- coffee-script

- express

- socket.io

- eco

- redis

- cluster

- jsonreq

ToDo
====

- Redisに入れるデータフォーマットの検討

  - UNIX時間が流行らしいので従うかを検討

- iframe.html.eco を作成し、iframeによる配置に対応

  - 時間がなければ、実運用と異なる仕組みでの動作なども検討

- スライドしてタイムテーブルとかタイムラインみたい

- ロゴの一覧を降らせるなどの効果をつけたい

  - API がまだロゴの一覧を出していない

- 勢いに応じてCSSトランスフォームなどで雰囲気を変える

CSS
---

横着

::

  div.yabaiButton {
    /* yabai.png は 表示サイズの2倍で作っておく */
    background: url('./yabai.png') 50% 50% no-repeat;
    background-size:480px 640px;
  }


ちゃんとやる

::

  div.yabaiButton {
    background-size:480px 320px;
  }

  @media only screen and (-webkit-min-device-pixel-ratio: 1) {
    /* iPhone3GS用 */
    div.yabaiButton {
      background: url('./yabai.png') 50% 50% no-repeat;
    }
  }

  @media only screen and (-webkit-min-device-pixel-ratio: 2) {
    /* iPhone4以降 */
     div.yabaiButton {
      background: url('./yabai@2x.png') 50% 50% no-repeat;
    }
  }

  @media only screen and (-webkit-min-device-pixel-ratio: 1.5) {
    /* Android */
    background: url('./yabai@1.5x.png') 50% 50% no-repeat;
  }



