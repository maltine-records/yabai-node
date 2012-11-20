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

    make setup

ToDo
====

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

Twitterバッヂ
-------------

::

  <!-- twitter follow badge by go2web20 -->
  <script src='http://files.go2web20.net/twitterbadge/1.0/badge.js' type='text/javascript'></script><script type='text/javascript' charset='utf-8'><!--
  tfb.account = 'MaltineRecords';
  tfb.label = 'follow-me';
  tfb.color = '#8fc63d';
  tfb.side = 'r';
  tfb.top = 136;
  tfb.showbadge();
  --></script>
  <!-- end of twitter follow badge -->


タイムテーブル
--------------

- 20時30分~21時10分 (40分) Gassyoh

- 21時10分~21時40分 (30分) banvox

- 21時40分~22時10分 (30分) コバルト爆弾αΩ

- 22時10分~22時40分 (30分) miii

- 22時40分~23時20分 (40分) Submerse

- 23時20分~23時40分 (20分) 三毛猫ホームレス

- 23時40分~24時10分 (30分) fazerock

- 24時10分~24時40分 (30分) DJシーザー

- 24時40分~25時10分 (30分) Pollarstars

- 25時10分~25時40分 (30分) DJUSYN

- 25時40分~26時20分 (40分) RE:NDZ

- 26時20分~26時50分 (30分) DJ ニッチ

- 26時50分~27時10分 (20分) オノマトペ大臣

- 27時10分~27時40分 (30分) tofubeats

- 27時40分~28時20分 (40分) okadada

- 28時20分~29時00分 (40分) DJ WILDPARTY


